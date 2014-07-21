//
//  NBMapViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 05/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBMapViewController.h"
#import <MapKit/MapKit.h>
#import <CCHMapClusterController.h>
#import <CCHMapClusterAnnotation.h>
#import <CCHMapClusterControllerDelegate.h>
#import "UIStoryboard+NBAdditions.h"
#import "NBPlaceListViewController.h"
#import "NBPlaceViewController.h"
#import "NBPlaceAnnotationView.h"
#import "NBPlaceAnnotation.h"
#import "NBPlace.h"
#import "NBPlaceCategory.h"


#pragma mark - Constants

static CGFloat const kNBFilterViewAnimationDuration = .3f;

/*
 * These are arbitrary values to balance
 * clustering precision against performances.
 * Read CCHMapClusterController's documentation
 * for more informations
 */
static CGFloat const kMBMapClusterCellSize = 80.f;
static CGFloat const kMBMapMarginFactor = 1.f;

static NSUInteger const kNBMapMaxAnnotationsToDisplay = 50;

#pragma mark -


@interface NBMapViewController () <CCHMapClusterControllerDelegate, NBPlaceListViewControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *filterView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filterViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filterViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *placesSearchView;
@property (strong, nonatomic) NBPlaceListViewController *searchedPlacesViewController;
@property (strong, nonatomic) IBOutlet NBTextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPickerView;

@property (strong, nonatomic) CCHMapClusterController *mapClusterController;
@property (strong, nonatomic) NSArray *savedAnnotations;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NBPlaceCategory *selectedCategory;

@property (strong, nonatomic) NBAPINetworkOperation *searchPlacesOperation;

@end


@implementation NBMapViewController

#pragma mark - View lifecycle

- (void)dealloc
{
    [self unregisterForLoginNotifications];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForLoginNotifications];
    self.hidesNavigationBar = YES;

    [self initCategories];
    [self initMapClusterController];
    [self themeFilterView];
    [self themeMapView];
    [self hideCategoryPicker];
    [self hidePlacesSearchView];
}

- (void)initCategories
{
    NBAPINetworkOperation *categoriesOperation = [NBAPIRequest fetchCategories];
    [categoriesOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseCategoryList *response = (NBAPIResponseCategoryList *)operation.APIResponse;
        NSMutableArray *categories = [response.categories mutableCopy];
        NBPlaceCategory *noCategory = [NBPlaceCategory new];
        noCategory.identifier = nil;
        noCategory.description = @"Aucune categorie";
        [categories insertObject:noCategory atIndex:0];
        self.categories = categories;
        [self.categoryPickerView reloadAllComponents];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    [categoriesOperation enqueue];
}

- (void)initMapClusterController
{
    CCHMapClusterController *mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    mapClusterController.delegate = self;
    mapClusterController.cellSize = kMBMapClusterCellSize;
    mapClusterController.marginFactor = kMBMapMarginFactor;
    
    self.mapClusterController = mapClusterController;
    self.savedAnnotations = [NSArray array];
}

#pragma mark - Theming

- (void)themeFilterView
{
    self.filterView.backgroundColor = [self.theme.lightGreenColor colorWithAlphaComponent:.90f];
}

- (void)themeMapView
{
    self.mapView.tintColor = self.theme.lightGreenColor;
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString *kNBSearchedPlaceSegue = @"searchedPlaceViewController";
    
    if ([segue.identifier isEqualToString:kNBSearchedPlaceSegue])
    {
        self.searchedPlacesViewController = segue.destinationViewController;
        self.searchedPlacesViewController.delegate = self;
    }
}

- (BOOL)enableValidationButtonIfNeeded
{
    BOOL enable = [super enableValidationButtonIfNeeded];
    
    if (self.searchPlacesOperation.isCancelled == NO)
        [self.searchPlacesOperation cancel];
    
    NSString *text = self.searchTextField.text;
    if (text.length > 0)
    {
        
        NBPlaceListViewController *placesListViewController = self.searchedPlacesViewController;
        self.searchPlacesOperation = [NBAPIRequest fetchPlacesWithName:self.searchTextField.text];
        [self.searchPlacesOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
            NBAPIResponsePlaceList *response = (NBAPIResponsePlaceList *)operation.APIResponse;
            placesListViewController.places = response.places;
            
        } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
        [self.searchPlacesOperation enqueue];
    }
    
    return enable;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self showPlacesSearchView];
}

- (void)tappedMainView:(UITapGestureRecognizer *)gestureRecognizer
{
    [super tappedMainView:gestureRecognizer];
    [self hidePlacesSearchView];
    [self hideCategoryPicker];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [NSTimer cancelPreviousPerformRequestsWithTarget:self selector:@selector(mapDidMove) object:nil];
    [self hideFilterView];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self performSelector:@selector(mapDidMove) withObject:nil afterDelay:1.f];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self centerMapOnUserOnFirstDetection];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:[CCHMapClusterAnnotation class]])
    {
        static NSString * const kNBPlaceAnnotationViewReuseIdentifier = @"placeAnnotationView";
        NBPlaceAnnotationView *vehiculeAnnotationView = [[NBPlaceAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kNBPlaceAnnotationViewReuseIdentifier];
        annotationView = vehiculeAnnotationView;
    }
    
    return annotationView;
}

- (void)mapClusterController:(CCHMapClusterController *)mapClusterController willReuseMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{
    UIView *annotationView = [self.mapView viewForAnnotation:mapClusterAnnotation];
    
    if ([annotationView isKindOfClass:[NBPlaceAnnotationView class]])
    {
        NBPlaceAnnotationView *placeAnnotationView = (NBPlaceAnnotationView *)annotationView;
        [placeAnnotationView hideCallout];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[NBPlaceAnnotationView class]])
    {
        NBPlaceAnnotationView *annotationView = (NBPlaceAnnotationView *)view;
        [annotationView showCalloutWithAction:^(MKAnnotationView *annotationView) {
             [self pressedAnnotationCallout:annotationView.annotation];
         }];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[NBPlaceAnnotationView class]])
    {
        NBPlaceAnnotationView *annotationView = (NBPlaceAnnotationView *)view;
        [annotationView hideCallout];
    }
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.categories.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NBPlaceCategory *category = self.categories[row];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:category.description
                                                                          attributes:@{NSFontAttributeName: self.theme.font,
                                                                                       NSForegroundColorAttributeName: self.theme.whiteColor}];
    return attributedTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedCategory = self.categories[row];
    [self hideCategoryPicker];
    [self removeAllAnnotationsWithCompletion:^{
        [self loadPlacesInMap];
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGRect searchViewBounds = self.searchedPlacesViewController.view.bounds;
    CGPoint locationInSearchView = [touch locationInView:self.searchedPlacesViewController.view];
    
    if (CGRectContainsPoint(searchViewBounds, locationInSearchView))
        return NO;

    return YES;
}

#pragma mark - NBPlaceListViewControllerDelegate

- (void)placeListViewController:(NBPlaceListViewController *)placeListViewController didPickPlace:(NBPlace *)place
{
    MKMapView *mapView = self.mapView;
    NBPlaceAnnotation *annotation = [[NBPlaceAnnotation alloc] initWithPlace:place];

    [self removeAllAnnotationsWithCompletion:^{
        [self.mapClusterController addAnnotations:@[annotation] withCompletionHandler:^{
            MKCoordinateSpan regionSpan = MKCoordinateSpanMake(.02f, .02f);
            MKCoordinateRegion placeRegion = MKCoordinateRegionMake(place.coordinate, regionSpan);
            [mapView setRegion:placeRegion animated:YES];
        }];
    }];
    [self hidePlacesSearchView];
    [self tappedMainView:nil];
}

#pragma mark - User interactions

- (IBAction)pressedFilterButton:(id)sender
{
    [self tappedMainView:nil];

    if (self.categories.count == 0)
        return ;
    
    [self showCategoryPicker];
}

- (IBAction)pressedLocationButton:(id)sender
{
    CLLocationCoordinate2D userCoordinate = self.persistanceManager.lastKnownLocation;
    
    if (CLLocationCoordinate2DIsValid(userCoordinate) == NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"Oups"
                                    message:@"La géolocalisation semble désactivée. Afin de profiter de toutes les fonctionnalités de Neerbyy, activez-la dans l'application Réglages de votre iDevice"
                                   delegate:nil
                          cancelButtonTitle:@"Annuler"
                          otherButtonTitles:nil]
         show];
    }
    else
        [self centerMapOnUser];
}

#pragma mark - Private methods - Filter view

- (void)showFilterView
{
    if ([self filterViewIsShown])
        return ;
    
    self.filterViewTopConstraint.constant += self.filterViewHeightConstraint.constant;
    
    [UIView animateWithDuration:kNBFilterViewAnimationDuration animations:^{
        [self.filterView.superview layoutIfNeeded];
    }];
}

- (void)hideFilterView
{
    if ([self filterViewIsShown] == NO)
        return ;
    
    self.filterViewTopConstraint.constant -= self.filterViewHeightConstraint.constant;
    
    [UIView animateWithDuration:kNBFilterViewAnimationDuration animations:^{
        [self.filterView.superview layoutIfNeeded];
    }];
}

- (BOOL)filterViewIsShown
{
    BOOL filterViewIsShown = (self.filterViewTopConstraint.constant >= 0.f);
    return filterViewIsShown;
}

#pragma mark - Private methods - Map related

- (void)centerMapOnUserOnFirstDetection
{
    static BOOL hasUserLocation = NO;
    
    if (hasUserLocation == NO)
    {
        [self centerMapOnUser];
        hasUserLocation = YES;
    }
}

- (void)centerMapOnUser
{
    CLLocationCoordinate2D userCoordinate = self.mapView.userLocation.location.coordinate;
    MKCoordinateSpan regionSpan = MKCoordinateSpanMake(.02f, .02f);
    
    MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, regionSpan);
    [self.mapView setRegion:userRegion animated:YES];
}

- (void)mapDidMove
{
    [self showFilterView];
    [self loadPlacesInMap];
}

#pragma mark - Private methods - Network related

- (void)loadPlacesInMap
{
    CLLocationCoordinate2D centerCoordinate = self.mapView.centerCoordinate;
    NSString *selectedCategory = self.selectedCategory.identifier;
    
    NBAPINetworkOperation *fetchPlacesOperation = [NBAPIRequest fetchPlacesAroundCoordinate:centerCoordinate withCategory:selectedCategory];
    [fetchPlacesOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePlaceList *response = (NBAPIResponsePlaceList *)completedOperation.APIResponse;
        
        [self addPlacesToMap:response.places];
        
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [fetchPlacesOperation enqueue];
}

- (void)addPlacesToMap:(NSArray *)places
{
    NSMutableArray *annotations = [NSMutableArray array];
    
    for (NBPlace *place in places)
    {
        if ([self isPlaceOnMap:place] == NO)
        {
            NBPlaceAnnotation *annotation = [[NBPlaceAnnotation alloc] initWithPlace:place];
            [annotations addObject:annotation];
        }
    }
    
    NSArray *annotationsToDisplay = [self.savedAnnotations arrayByAddingObjectsFromArray:annotations];
    NSArray *annotationsToRemove = nil;
    if (annotationsToDisplay.count > kNBMapMaxAnnotationsToDisplay)
    {
        NSRange rangeToKeep = NSMakeRange(annotationsToDisplay.count - kNBMapMaxAnnotationsToDisplay, kNBMapMaxAnnotationsToDisplay);
        NSRange rangeToRemove = NSMakeRange(0, rangeToKeep.location);
        annotationsToRemove = [annotationsToDisplay subarrayWithRange:rangeToRemove];
        annotationsToDisplay = [annotationsToDisplay subarrayWithRange:rangeToKeep];
    }
    
    self.savedAnnotations = annotationsToDisplay;
    
    __weak CCHMapClusterController *clusterController = self.mapClusterController;
    [clusterController addAnnotations:annotations withCompletionHandler:^{
        if (annotationsToRemove.count)
            [clusterController removeAnnotations:annotationsToRemove withCompletionHandler:NULL];
    }];
}

- (BOOL)isPlaceOnMap:(NBPlace *)place
{
    NSArray *currentAnnotations = self.savedAnnotations;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", place.name];
    NSArray *filteredArray = [currentAnnotations filteredArrayUsingPredicate:predicate];

    if ([filteredArray count] == 0)
        return NO;
    else
        return YES;
}

#pragma mark - Private methods - User interactions related

- (void)pressedAnnotationCallout:(CCHMapClusterAnnotation *)annotation
{
    UIViewController *viewController;
    
    if ([annotation isCluster])
        viewController = [self viewControllerForMultipleAnnotations:annotation.annotations];
    else
        viewController = [self viewControllerForSingleAnnotation:annotation.annotations.anyObject];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIViewController *)viewControllerForMultipleAnnotations:(NSSet *)annotations
{
    NSMutableArray *places = [NSMutableArray array];
    for (NBPlaceAnnotation *placeAnnotation in annotations)
        [places addObject:placeAnnotation.place];
    places = [[places sortedArrayUsingComparator:^NSComparisonResult(NBPlace *obj1, NBPlace *obj2) {
        return [obj1.name compare:obj2.name];
    }] mutableCopy];

    NBPlaceListViewController *placeListViewController = [UIStoryboard placeListViewController];
    placeListViewController.places = [places copy];

    return placeListViewController;
}

- (UIViewController *)viewControllerForSingleAnnotation:(NBPlaceAnnotation *)annotation
{
    NBPlaceViewController *placeViewController = [UIStoryboard placeViewController];
    placeViewController.place = annotation.place;

    return placeViewController;
}

- (void)removeAllAnnotationsWithCompletion:(void (^)(void))completion
{
    NSArray *annotations = self.mapClusterController.annotations.allObjects;
    [self.mapClusterController removeAnnotations:annotations withCompletionHandler:^{
        self.savedAnnotations = [NSArray array];
        completion();
    }];
}

- (void)showCategoryPicker
{
    self.categoryPickerView.hidden = NO;
}

- (void)hideCategoryPicker
{
    self.categoryPickerView.hidden = YES;
}

- (void)showPlacesSearchView
{
    self.placesSearchView.hidden = NO;
}

- (void)hidePlacesSearchView
{
    self.placesSearchView.hidden = YES;
}


- (void)registerForLoginNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(receivedUserStatusNotification:) name:kNBNotificationUserLoggedIn object:nil];
    [notificationCenter addObserver:self selector:@selector(receivedUserStatusNotification:) name:kNBNotificationUserLoggedOut object:nil];
}

- (void)unregisterForLoginNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)receivedUserStatusNotification:(NSNotification *)notification
{
    [self removeAllAnnotationsWithCompletion:^{
        [self loadPlacesInMap];
    }];
}

@end

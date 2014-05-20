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

#pragma mark -


@interface NBMapViewController () <CCHMapClusterControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *filterView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filterViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filterViewHeightConstraint;

@property (strong, nonatomic) CCHMapClusterController *mapClusterController;

@end


@implementation NBMapViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidesNavigationBar = YES;

    [self initMapClusterController];
    [self themeFilterView];
    [self themeMapView];
}

- (void)initMapClusterController
{
    CCHMapClusterController *mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    mapClusterController.delegate = self;
    mapClusterController.cellSize = kMBMapClusterCellSize;
    mapClusterController.marginFactor = kMBMapMarginFactor;
    
    self.mapClusterController = mapClusterController;
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

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self hideFilterView];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self showFilterView];
    [self loadPlacesInMap];
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

#pragma mark - User interactions

- (IBAction)pressedFilterButton:(id)sender
{

}

- (IBAction)pressedLocationButton:(id)sender
{
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

#pragma mark - Private methods - Network related

- (void)loadPlacesInMap
{
    CLLocationCoordinate2D centerCoordinate = self.mapView.centerCoordinate;
    
    NBAPINetworkOperation *fetchPlacesOperation = [NBAPIRequest fetchPlacesAroundCoordinate:centerCoordinate];
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

    [self.mapClusterController addAnnotations:annotations withCompletionHandler:NULL];
}

- (BOOL)isPlaceOnMap:(NBPlace *)place
{
    NSSet *currentAnnotations = self.mapClusterController.annotations;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", place.name];
    NSSet *filteredArray = [currentAnnotations filteredSetUsingPredicate:predicate];

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

@end

//
//  NBMapViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 05/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBMapViewController.h"
#import <MapKit/MapKit.h>
#import "UIStoryboard+NBAdditions.h"
#import "NBPlaceViewController.h"
#import "NBAnnotationView.h"
#import "NBPlaceAnnotation.h"
#import "NBPlace.h"


#pragma mark - Constants

static CGFloat const kNBFilterViewAnimationDuration = .3f;

#pragma mark -


@interface NBMapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *filterView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filterViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filterViewHeightConstraint;

@end


@implementation NBMapViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidesNavigationBar = YES;
    
    [self themeFilterView];
}

#pragma mark - Theming

- (void)themeFilterView
{
    NBTheme *theme = [NBTheme sharedTheme];

    self.filterView.backgroundColor = [theme.lightGreenColor colorWithAlphaComponent:.90f];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self hideFilterView];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self showFilterView];
    
    if ([self isZoomedEnoughToLoadPlaces])
        [self loadPlacesInMap];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self centerMapOnUserOnFirstDetection];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    if ([annotation isKindOfClass:[NBPlaceAnnotation class]])
    {
        static NSString * const reuseIdentifier = @"placeAnnotation";

        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        if (annotationView == nil)
            annotationView = [[NBAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        else
            annotationView.annotation = annotation;
        return annotationView;
    }

    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[NBAnnotationView class]])
    {
        NBAnnotationView *annotationView = (NBAnnotationView *)view;
        [annotationView showCalloutWithAction:^(MKAnnotationView *annotationView)
         {
             NBPlaceAnnotation *placeAnnotation = (NBPlaceAnnotation *)annotationView.annotation;
             NBPlaceViewController *placeViewController = [UIStoryboard placeViewController];
             placeViewController.place = placeAnnotation.place;
             [self.navigationController pushViewController:placeViewController animated:YES];
         }];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[NBAnnotationView class]])
    {
        NBAnnotationView *annotationView = (NBAnnotationView *)view;
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

- (void)loadPlacesInMap
{
    CLLocationCoordinate2D centerCoordinate = self.mapView.centerCoordinate;
    
    NBAPINetworkOperation *fetchPlacesOperation = [NBAPIRequest fetchPlacesAroundCoordinate:centerCoordinate];
    [fetchPlacesOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
         NBAPIResponsePlaceList *response = (NBAPIResponsePlaceList *)completedOperation.APIResponse;
         
         NSArray *places = response.places;
         for (NBPlace *place in places)
         {
             if ([self isPlaceOnMap:place] == NO)
             {
                 NBPlaceAnnotation *placeAnnotation = [[NBPlaceAnnotation alloc] initWithPlace:place];
                 [self.mapView addAnnotation:placeAnnotation];
             }
         }
        
    } errorHandler:^(NBAPINetworkOperation *completedOperation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](completedOperation, error);
    }];
    
    [fetchPlacesOperation enqueue];
}

- (BOOL)isZoomedEnoughToLoadPlaces
{
    CGFloat const minZoomLevelToLoadPlaces = .08f;

    MKCoordinateSpan spanCoordinates = self.mapView.region.span;
    if (spanCoordinates.longitudeDelta <= minZoomLevelToLoadPlaces ||
        spanCoordinates.latitudeDelta <= minZoomLevelToLoadPlaces)
        return YES;
    
    return NO;
}

- (BOOL)isPlaceOnMap:(NBPlace *)place
{
    NSArray *currentAnnotations = self.mapView.annotations;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", place.name];
    NSArray *filteredArray = [currentAnnotations filteredArrayUsingPredicate:predicate];

    if ([filteredArray count] == 0)
        return NO;
    else
        return YES;
}

@end

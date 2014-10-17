//
//  RRMapViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRMapViewController.h"
#import <MapKit/MapKit.h>

#import "Restroom.h"
#import "RestroomManager.h"
#import "RRMapLocation.h"

#define METERS_PER_MILE 1609.344

@interface RRMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation RRMapViewController
{
}

- (void)viewWillAppear:(BOOL)animated
{
    RestroomManager *restroomManager = (RestroomManager *)[RestroomManager sharedInstance];
    restroomManager.delegate = self;
    
    // fetch restrooms
//    [[RestroomManager sharedInstance] fetchNewRestrooms];
//    [[RestroomManager sharedInstance] fetchRestroomsForQuery:@"Baltimore MD"];
    [[RestroomManager sharedInstance] fetchRestroomsOfAmount:10000];
    
    // set default view region
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    MKCoordinateRegion viewRegion = [self getRegionWithZoomLocation:zoomLocation];
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)plotRestrooms:(NSArray *)restrooms
{
    // remove existing annotations
    for (id<MKAnnotation> annotation in self.mapView.annotations)
    {
        [self.mapView removeAnnotation:annotation];
    }
    
    // add all annotations
    for (Restroom *restroom in restrooms)
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = restroom.latitude;
        coordinate.longitude = restroom.longitude;
    
        RRMapLocation *annotation = [[RRMapLocation alloc] initWithName:restroom.name address:restroom.street coordinate:coordinate];
    
        [self.mapView addAnnotation:annotation];
    }
}

#pragma mark - RestroomManagerDelegate methods

- (void)didReceiveRestrooms:(NSArray *)restrooms
{
    // plot Restrooms on map
    [self plotRestrooms:restrooms];
}

- (void)fetchingRestroomsFailedWithError:(NSError *)error
{
    // TODO: Handle fetching error
    NSLog(@"Error fetching Restroom data.");
}

#pragma mark - Helper methods

- (MKCoordinateRegion)getRegionWithZoomLocation:(CLLocationCoordinate2D)zoomLocation
{
    return MKCoordinateRegionMakeWithDistance(zoomLocation, (0.5 * METERS_PER_MILE), (0.5 * METERS_PER_MILE));
}

@end

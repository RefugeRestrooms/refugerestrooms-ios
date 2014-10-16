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
    RestroomManager *restroomManager;
}

- (void)viewWillAppear:(BOOL)animated
{
    // TODO: should RestroomManager be a singleton
    restroomManager = [[RestroomManager alloc] init];
    
    restroomManager.delegate = self;
    
    // set default view region
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    MKCoordinateRegion viewRegion = [self getRegionWithZoomLocation:zoomLocation];
    
    [self.mapView setRegion:viewRegion animated:YES];
    
    Restroom *restroom1 = [[Restroom alloc] initWithName:@"Verde Pizza"
                                                 Street:@"641 S Montford Ave"
                                                   City:@"Baltimore"
                                                  State:@"MD"
                                                Country:@"US"
                                           IsAccessible:YES
                                               IsUnisex:NO
                                           NumDownvotes:1
                                             NumUpvotes:0
                                            DateCreated:@"Todays Date"];
    restroom1.latitude = 39.2841239;
    restroom1.longitude = -76.5825334;
    
    
    Restroom *restroom2 = [[Restroom alloc] initWithName:@"Baltimore Aquarium"
                                                  Street:@"501 E Pratt St"
                                                    City:@"Baltimore"
                                                   State:@"MD"
                                                 Country:@"US"
                                            IsAccessible:NO
                                                IsUnisex:YES
                                            NumDownvotes:0
                                              NumUpvotes:0
                                             DateCreated:@"Todays Date"];
    
    restroom2.latitude = 39.284619;
    restroom2.longitude = -76.607012;
    
    [self plotRestrooms:[NSArray arrayWithObjects:restroom1, restroom2, nil]];
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

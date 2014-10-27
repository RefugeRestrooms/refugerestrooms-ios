//
//  RRMapViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"

#import "Restroom.h"
#import "RestroomManager.h"
#import "RRMapLocation.h"
#import "Reachability.h"

#define METERS_PER_MILE 1609.344

@interface RRMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation RRMapViewController
{
    Reachability *internetReachability;
    CLLocationManager *locationManager;
    MBProgressHUD *hud;
    BOOL initialZoomComplete;
}

- (void)viewDidLoad
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Loading...";
    
    initialZoomComplete = NO;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    // set RestroomManager delegate
    RestroomManager *restroomManager = (RestroomManager *)[RestroomManager sharedInstance]; // put in Viewwill Load
    restroomManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    // prompt for location allowing
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    // check for Internet reachability
    internetReachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachability.reachableBlock = ^(Reachability*reach)
    {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
//        dispatch_async
//        (
//            dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^
//            {
//                // fetch restrooms
//                [[RestroomManager sharedInstance] fetchRestroomsForQuery:@"San Francisco CA"];
//                
//                dispatch_async
//                (
//                    dispatch_get_main_queue(), ^
//                    {
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    }
//                );
//            }
//        );
        
        dispatch_async
        (
            // update UI on main thread
            dispatch_get_main_queue(), ^
            {
//                [[RestroomManager sharedInstance] fetchRestroomsOfAmount:10000];
                [[RestroomManager sharedInstance] fetchRestroomsForQuery:@"San Francisco CA"];
            }
         );
    };

    // Internet is not reachable
    internetReachability.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async
        (
            dispatch_get_main_queue(), ^
            {
                NSLog(@"Someone broke the internet :(");
            }
         );
    };
    
    [internetReachability startNotifier];
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
    
    [hud hide:YES];
}

#pragma mark - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    
    if(!initialZoomComplete)
    {
        // zoom to initial location
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];
    
        float longitude = coordinate.longitude;
        float latitude = coordinate.latitude;
    
        NSLog(@"dLongitude : %f",longitude);
        NSLog(@"dLatitude : %f", latitude);
    
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = latitude;
        zoomLocation.longitude= longitude;
        MKCoordinateRegion viewRegion = [self getRegionWithZoomLocation:zoomLocation];
    
        [self.mapView setRegion:viewRegion animated:YES];
    
        [locationManager startUpdatingLocation];
        
        initialZoomComplete = YES;
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    
    // TODO: implement error handling for finding location
    NSLog(@"ERROR finding location: %@", error);
}

#pragma mark - RestroomManagerDelegate methods

- (void)didReceiveRestrooms:(NSArray *)restrooms
{
    // plot Restrooms on map
    dispatch_async
    (
        // update UI on main thread
        dispatch_get_main_queue(), ^(void)
        {
            [self plotRestrooms:restrooms];
            
            NSLog(@"Finished fetching retrooms.");
        }
     );
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

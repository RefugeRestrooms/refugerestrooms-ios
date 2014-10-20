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
    BOOL initialZoomComplete;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Loading...");
    });
    
    initialZoomComplete = NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    // prompt for location allowing
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    // set RestroomManager delegate
    RestroomManager *restroomManager = (RestroomManager *)[RestroomManager sharedInstance];
    restroomManager.delegate = self;
    
    // check for Internet reachability
    internetReachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachability.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Finished loading. Fetching restrooms...");
        });
        
        dispatch_async
        (
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
            {
                // fetch Restrooms in background
                [[RestroomManager sharedInstance] fetchRestroomsForQuery:@"San Francisco CA"];
                
                // update UI when finished
                dispatch_async
                (
                    dispatch_get_main_queue(), ^(void)
                    {
                        NSLog(@"Finished fetching restrooms.");
                    }
                );
            }
         );
        
        // Fetch restrooms
//        [[RestroomManager sharedInstance] fetchRestroomsForQuery:@"San Francisco CA"];
    };
    
    // Internet is not reachable
    internetReachability.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [internetReachability startNotifier];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//     fetch restrooms
//    [[RestroomManager sharedInstance] fetchNewRestrooms];
//    [[RestroomManager sharedInstance] fetchRestroomsForQuery:@"San Francisco CA"];
//    [[RestroomManager sharedInstance] fetchRestroomsOfAmount:10000];
//}

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
    NSLog(@"ERROR finding location.");
}

#pragma mark - RestroomManagerDelegate methods

- (void)didReceiveRestrooms:(NSArray *)restrooms
{
    // plot Restrooms on map
    dispatch_async
    (
        dispatch_get_main_queue(), ^(void)
        {
            [self plotRestrooms:restrooms];
            
            NSLog(@"Finished fetching retrooms.");
        }
     );
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"Finished fetching retrooms.");
//    });
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

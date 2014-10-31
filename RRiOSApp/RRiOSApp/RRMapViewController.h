//
//  RRMapViewController.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "RestroomManagerDelegate.h"

@interface RRMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, RestroomManagerDelegate>

@end

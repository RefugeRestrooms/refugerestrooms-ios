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

#import "ADClusterMapView.h"
#import "RestroomManagerDelegate.h"
#import "RRMapSearchViewController.h"

@interface RRMapViewController : UIViewController <ADClusterMapViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, RestroomManagerDelegate, RRMapSearchDelegate, UISearchBarDelegate
, UITableViewDataSource, UITableViewDelegate>

// ADClusterMapView
@property (weak, nonatomic) IBOutlet ADClusterMapView *mapView;
@property (strong, readonly, nonatomic) NSString *seedFileName; // abstract
@property (strong, readonly, nonatomic) NSString *pictoName; // abstract
@property (strong, readonly, nonatomic) NSString *clusterPictoName; // abstract


@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;

@end

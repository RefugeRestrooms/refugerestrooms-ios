//
//  RefugeMapViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMapViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RefugeDataPersistenceManager.h"
#import "RefugeHUD.h"
#import "RefugeMapKitAnnotation.h"
#import "RefugeRestroom.h"
#import "RefugeRestroomBuilder.h"
#import "RefugeRestroomCommunicator.h"
#import "RefugeRestroomManager.h"

static NSString * const kRefugeRestroomDetailsShowSegue = @"RefugeRestroomDetailsShowSegue";

static NSString * const kHudTextSyncing = @"Syncing";

@interface RefugeMapViewController ()

@property (nonatomic, strong) RefugeHUD *hud;
@property (nonatomic, strong) RefugeRestroomManager *restroomManager;
@property (nonatomic, strong) RefugeDataPersistenceManager *dataPersistenceManager;
@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;
@property (nonatomic, strong) RefugeRestroomCommunicator *restroomCommunicator;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) BOOL isPlotComplete;

@end

@implementation RefugeMapViewController

# pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureRestroomManager];
    [self configureHUD];
    [self configureMap];
    
    [self.restroomManager fetchRestroomsFromAPI];
}

# pragma mark - Public methods

# pragma mark RefugeRestroomManagerDelegate methods

- (void)didFetchRestrooms
{
    self.hud.state = RefugeHUDStateSyncingComplete;
    self.hud.text = @"Sync complete!";
    
    [self.hud hide:RefugeHUDHideSpeedFast];
    
    [self plotRestrooms];
}

- (void)fetchingRestroomsFailedWithError:(NSError *)error
{
    self.hud.state = RefugeHUDStateSyncingComplete;
    [self.hud setErrorText:@"Sync error :(" forError:error];
    
    [self.hud hide:RefugeHUDHideSpeedModerate];
}

- (void)savingRestroomsFailedWithError:(NSError *)error
{
    self.hud.state = RefugeHUDStateSyncingComplete;
    [self.hud setErrorText:@"Sync error :(" forError:error];
    
    [self.hud hide:RefugeHUDHideSpeedModerate];
    
    [self plotRestrooms];
}

# pragma mark - Private methods

- (void)configureRestroomManager
{
    self.restroomManager = [[RefugeRestroomManager alloc] init];
    self.dataPersistenceManager = [[RefugeDataPersistenceManager alloc] init];
    self.restroomBuilder = [[RefugeRestroomBuilder alloc] init];
    self.restroomCommunicator = [[RefugeRestroomCommunicator alloc] init];
    
    self.restroomManager.dataPersistenceManager = self.dataPersistenceManager;
    self.restroomManager.restroomBuilder = self.restroomBuilder;
    self.restroomManager.restroomCommunicator = self.restroomCommunicator;
    
    self.dataPersistenceManager.delegate = self.restroomManager;
    self.restroomManager.delegate = self;
    self.restroomCommunicator.delegate = self.restroomManager;
}

- (void)configureHUD
{
    self.hud = [[RefugeHUD alloc] initWithView:self.view];
    self.hud.text = kHudTextSyncing;
}

- (void)configureMap
{
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
}

- (void)plotRestrooms
{
    NSArray *allRestrooms = [self.restroomManager restroomsFromLocalStore];
    
    [self removeAllAnnotationsFromMap];
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    // add all annotations
    for (RefugeRestroom *restroom in allRestrooms)
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [restroom.latitude doubleValue];
        coordinate.longitude = [restroom.longitude doubleValue];
        
        // create map location object
        RefugeMapKitAnnotation *annotation = [[RefugeMapKitAnnotation alloc] initWithRestroom:restroom];
        
        // add annotation
        [annotations addObject:annotation];
    }
    
    // set annotations
//    [self.mapView setAnnotations:[NSMutableArray arrayWithArray:annotations]];
    [self.mapView addAnnotations:annotations];
    self.isPlotComplete = YES;
}

- (void)removeAllAnnotationsFromMap
{
    for (id<MKAnnotation> annotation in self.mapView.annotations)
    {
        [self.mapView removeAnnotation:annotation];
    }
}

@end

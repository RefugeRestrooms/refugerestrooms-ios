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
#import <Reachability/Reachability.h>
#import "RefugeAppState.h"
#import "RefugeDataPersistenceManager.h"
#import "RefugeHUD.h"
#import "RefugeMapKitAnnotation.h"
#import "RefugeRestroom.h"
#import "RefugeRestroomBuilder.h"
#import "RefugeRestroomCommunicator.h"
#import "RefugeRestroomManager.h"

static float const kMetersPerMile = 1609.344;
static NSString * const kSearchResultsTableCellReuseIdentifier = @"SearchResultsTableCellReuseIdentifier";
static NSString * const kSegueNameShowRestroomDetails = @"RefugeRestroomDetailsShowSegue";

static NSString * const kHudTextSyncing = @"Syncing";
static NSString * const kHudTextSyncComplete = @"Sync complete!";
static NSString * const kHudTextSyncError = @"Sync error :(";
static NSString * const kHudTextNoInternet = @"Internet unavailable";
static NSString * const kHudTextLocationNotFound = @"Location not found";
static NSString * const kReachabilityTestURL = @"www.google.com";

@interface RefugeMapViewController ()

@property (nonatomic, strong) RefugeHUD *hud;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) RefugeRestroomManager *restroomManager;
@property (nonatomic, strong) RefugeDataPersistenceManager *dataPersistenceManager;
@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;
@property (nonatomic, strong) RefugeRestroomCommunicator *restroomCommunicator;

@property (nonatomic, assign) BOOL isSyncComplete;
@property (nonatomic, assign) BOOL isPlotComplete;
@property (nonatomic, assign) BOOL isInitialZoomComplete;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;

@end

@implementation RefugeMapViewController

# pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureHUD];
    [self configureLocationManager];
    [self configureMap];
    [self configureRestroomManager];
    self.searchResultsTableView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self promptToAllowLocationServices];
    [self.locationManager startUpdatingLocation];
    
    self.internetReachability = [Reachability reachabilityWithHostname:kReachabilityTestURL];
    
    if(self.internetReachability.isReachable)
    {
        [self fetchRestroomsWithCompletion:^
        {
            [self plotRestrooms];
        }];
    }
    else
    {
        self.hud.text = kHudTextNoInternet;
        
        self.isSyncComplete = YES;
        [self.hud hide:RefugeHUDHideSpeedModerate];
        
        [self plotRestrooms];
    }
}

# pragma mark - Setters

- (void)setIsSyncComplete:(BOOL)isSyncComplete
{
    _isSyncComplete = isSyncComplete;
    
    if(isSyncComplete)
    {
        self.hud.state = RefugeHUDStateSyncingComplete;
    }
}

# pragma mark - Public methods

# pragma mark CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    if(!self.isInitialZoomComplete)
    {
        CLLocation *location = [self.locationManager location];
        CLLocationCoordinate2D initialCoorindate = [location coordinate];
        
        [self zoomToCoordinate:initialCoorindate];
        
        [self.locationManager startUpdatingLocation];
        
        self.isInitialZoomComplete = YES;
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
}

# pragma mark RefugeRestroomManagerDelegate methods

- (void)didFetchRestrooms
{
    self.isSyncComplete = YES;
    self.hud.text = kHudTextSyncComplete;
    
    [self.hud hide:RefugeHUDHideSpeedFast];
    
    [RefugeAppState sharedInstance].dateLastSynced = [NSDate date];
    
    [self plotRestrooms];
}

- (void)fetchingRestroomsFailedWithError:(NSError *)error
{
    self.isSyncComplete = YES;
    [self.hud setErrorText:kHudTextSyncError forError:error];
    
    [self.hud hide:RefugeHUDHideSpeedModerate];
}

- (void)savingRestroomsFailedWithError:(NSError *)error
{
    self.isSyncComplete = YES;
    [self.hud setErrorText:kHudTextSyncError forError:error];
    
    [self.hud hide:RefugeHUDHideSpeedModerate];
}

# pragma mark UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    BOOL shouldHideSearchResults = ([searchText length] == 0);
    
    if(shouldHideSearchResults)
    {
        self.searchResultsTableView.hidden = YES;
        [self dismissSearch];
    }
    else
    {
        self.searchResultsTableView.hidden = NO;
        [self handleSearchForString:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self dismissSearch];
}

# pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [searchResultPlaces count];
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.searchResultsTableView dequeueReusableCellWithIdentifier:kSearchResultsTableCellReuseIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchResultsTableCellReuseIdentifier];
    }
    
//    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    
    cell.textLabel.text = @"Search Result";
    
    return cell;
}

# pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
//    
//    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error)
//     {
//         if (error)
//         {
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:RRCONSTANTS_ALERT_TITLE_ERROR message:RRCONSTANTS_SEARCH_ERROR_PLACE_NOT_FOUND delegate:nil cancelButtonTitle:RRCONSTANTS_ALERT_DISMISS_BUTTON_TEXT otherButtonTitles:nil];
//             
//             [alert show];
//         }
//         else if (placemark)
//         {
//             // placemark selected
//             [self mapSearchPlacemarkSelected:placemark cellName:[self tableView:tableView cellForRowAtIndexPath:indexPath].textLabel.text];
//             
//             // dismiss search
//             [self.searchTableView deselectRowAtIndexPath:indexPath animated:NO];
//             [self dismissSearch];
//         }
//     }];
    
    [self dismissSearch];
}

# pragma mark - Private methods

- (void)configureHUD
{
    self.hud = [[RefugeHUD alloc] initWithView:self.view];
    self.hud.text = kHudTextSyncing;
}

- (void)configureLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
}

- (void)configureMap
{
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
}

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

- (void)promptToAllowLocationServices
{
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else
    {
        // TODO: Test prompting for location services on iOS 7 device
    }
}

- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, (0.5 * kMetersPerMile), (0.5 * kMetersPerMile));
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)fetchRestroomsWithCompletion:(void (^)())completion
{
    if(!self.isSyncComplete)
    {
        [self.restroomManager fetchRestroomsFromAPI];
    }
    
    completion();
}

- (void)plotRestrooms
{
    NSArray *allRestrooms = [self.restroomManager restroomsFromLocalStore];
    
    [self removeAllAnnotationsFromMap];
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    for (RefugeRestroom *restroom in allRestrooms)
    {
        RefugeMapKitAnnotation *annotation = [[RefugeMapKitAnnotation alloc] initWithRestroom:restroom];
        
        [annotations addObject:annotation];
    }
    
    // TODO: update to setAnnotations when ADCluster added
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


- (void)handleSearchForString:(NSString *)searchString
{
//    //    searchQuery.location = self.mapView.userLocation.coordinate;
//    searchQuery.input = searchString;
//    
//    [searchQuery fetchPlaces:^(NSArray *places, NSError *error)
//     {
//         if (error)
//         {
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:RRCONSTANTS_ALERT_TITLE_ERROR message:RRCONSTANTS_SEARCH_ERROR_COULD_NOT_FETCH_PLACES delegate:nil cancelButtonTitle:RRCONSTANTS_ALERT_DISMISS_BUTTON_TEXT otherButtonTitles:nil];
//             
//             [alert show];
//             
//             [self dismissSearch];
//         }
//         else
//         {
//             searchResultPlaces = places;
//             //[self.searchDisplayController.searchResultsTableView reloadData];
//             [self.searchTableView reloadData];
//         }
//     }];
}

- (void)dismissSearch
{
    self.searchBar.text = @"";
    
    [self.searchBar performSelector: @selector(resignFirstResponder)
                      withObject: nil
                      afterDelay: 0.1];
    
    self.searchResultsTableView.hidden = YES;
}


@end

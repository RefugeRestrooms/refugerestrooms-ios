//
//  RefugeMapViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMapViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <Crashlytics/Crashlytics.h>
#import <MapKit/MapKit.h>
#import "Mixpanel+Refuge.h"
#import <Reachability/Reachability.h>
#import "RefugeAppState.h"
#import "RefugeDataPersistenceManager.h"
#import "RefugeHUD.h"
#import "RefugeMap.h"
#import "RefugeMapPin.h"
#import "RefugeMapPlace.h"
#import "RefugeSearch.h"
#import "RefugeRestroom.h"
#import "RefugeRestroomBuilder.h"
#import "RefugeRestroomCommunicator.h"
#import "RefugeRestroomDetailsViewController.h"
#import "RefugeRestroomManager.h"
#import "UIColor+Refuge.h"
#import "UIImage+Refuge.h"

static float const kMetersPerMile = 1609.344;
static NSString * const kSearchResultsTableCellReuseIdentifier = @"SearchResultsTableCellReuseIdentifier";
static NSString * const kSegueNameModalOnboarding = @"RefugeRestroomOnboardingModalSegue";
static NSString * const kSegueNameShowNewRestroomForm = @"RefugeRestroomNewRestroomShowSegue";
static NSString * const kSegueNameShowRestroomDetails = @"RefugeRestroomDetailsShowSegue";

static NSString * const kHudTextSyncing = @"Syncing";
static NSString * const kHudTextSyncComplete = @"Sync complete!";
static NSString * const kHudTextSyncError = @"Sync error :(";
static NSString * const kHudTextNoInternet = @"Internet unavailable";
static NSString * const kHudTextLocationNotFound = @"Location not found";
static NSString * const kReachabilityTestURL = @"www.google.com";
static NSString * const kErrorTextAutocompleteFail = @"Cound not fetch addresses for Search. Please check your Internet connection.";
static NSString * const kErrorTextNoInternet = @"Internet is unavailable. Certain features may be disabled.";
static NSString * const kErrorTextPlacemarkCreationFail = @"Could not map selected location";

@interface RefugeMapViewController ()

@property (nonatomic, strong) RefugeAppState *appState;
@property (nonatomic, strong) RefugeHUD *hud;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) RefugeRestroomManager *restroomManager;
@property (nonatomic, strong) RefugeDataPersistenceManager *dataPersistenceManager;
@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;
@property (nonatomic, strong) RefugeRestroomCommunicator *restroomCommunicator;

@property (nonatomic, assign) BOOL isSyncComplete;
@property (nonatomic, assign) BOOL isInitialZoomComplete;

@property (nonatomic, strong) RefugeSearch *searchQuery;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *searchResultsTable;
@property (nonatomic, weak) IBOutlet RefugeMap *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D defaultLocation;
- (IBAction)currentLocationButtonTouched:(id)sender;

@end

@implementation RefugeMapViewController

# pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appState = [[RefugeAppState alloc] init];
//    [self configureHUD];
    [self configureLocationManager];
    [self configureMap];
    [self configureSearch];
    [self configureRestroomManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!self.isSyncComplete)
    {
        [self promptToAllowLocationServices];
        
        if(self.appState.hasViewedOnboarding == NO)
        {
            [self displayOnboarding];
        }
        
        self.internetReachability = [Reachability reachabilityWithHostname:kReachabilityTestURL];
    
        if(self.internetReachability.isReachable)
        {
            if(self.isSyncComplete == NO)
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                
                        [self.restroomManager fetchRestroomsFromAPI];
            
                });
            }
        }
        else
        {
            self.isSyncComplete = YES;
            
            [self displayAlertForWithMessage:kErrorTextNoInternet];
        
            [self plotRestrooms];
        }
    }
    
    [self.locationManager startUpdatingLocation];
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
    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeLocationManagerFailed];
    
    [self.locationManager stopUpdatingLocation];
}

# pragma mark RefugeMapDelegate methods

- (void)tappingCalloutAccessoryDidRetrievedSingleMapPin:(RefugeMapPin *)mapPin
{
    [[Mixpanel sharedInstance] refugeTrackRestroomDetailsViewed:mapPin];
    
    [self performSegueWithIdentifier:kSegueNameShowRestroomDetails sender:mapPin];
}

- (void)retrievingSingleMapPinFromCalloutAccessoryFailed:(RefugeMapPin *)firstPinRetrieved
{
    [[Mixpanel sharedInstance] refugeTrackRestroomDetailsViewed:firstPinRetrieved];
    
    [self performSegueWithIdentifier:kSegueNameShowRestroomDetails sender:firstPinRetrieved];
}

# pragma mark RefugeRestroomManagerDelegate methods

- (void)didFetchRestrooms
{
    self.isSyncComplete = YES;
    self.appState.dateLastSynced = [NSDate date];
    
    [self plotRestrooms];
}

- (void)fetchingRestroomsFailedWithError:(NSError *)error
{
    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeFetchingRestroomsFailed];
    
    self.isSyncComplete = YES;
}

- (void)savingRestroomsFailedWithError:(NSError *)error
{
    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeSavingRestroomsFailed];
    
    self.isSyncComplete = YES;
}

# pragma mark UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0)
    {
        [self dismissSearch];
    }
    else
    {
        self.searchResultsTable.hidden = NO;
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
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.searchResultsTable dequeueReusableCellWithIdentifier:kSearchResultsTableCellReuseIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchResultsTableCellReuseIdentifier];
    }
    
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    
    return cell;
}

# pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefugeMapPlace *place = [self placeAtIndexPath:indexPath];
    NSString *cellText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    [[Mixpanel sharedInstance] refugeTrackSearchAttempted:cellText];
    
    [place resolveToPlacemarkWithSuccessBlock:^(CLPlacemark *placemark) {
        
                                    [[Mixpanel sharedInstance] refugeTrackSearchSuccessful:placemark];
        
                                    [self placemarkSelected:placemark];
        
                                    [self.searchResultsTable deselectRowAtIndexPath:indexPath animated:NO];
                                }
                                failure:^(NSError *error) {
                                    
                                    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeResolvingPlacemarkFailed];
                                    
                                    [self displayAlertForWithMessage:kErrorTextPlacemarkCreationFail];
                                }
     ];
    
    [self dismissSearch];
}

# pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:kSegueNameShowRestroomDetails])
    {
        RefugeRestroomDetailsViewController *destinationController = [segue destinationViewController];
        RefugeMapPin *mapPin = (RefugeMapPin *)sender;
        
        destinationController.restroom = mapPin.restroom;
    }
    
    if([[segue identifier] isEqualToString:kSegueNameShowNewRestroomForm])
    {
        [[Mixpanel sharedInstance] refugeTrackNewRestroomButtonTouched];
    }
}

- (IBAction)unwindFromOnboardingView:(UIStoryboardSegue *)segue
{
    [[Mixpanel sharedInstance] refugeTrackOnboardingCompleted];
    
    self.appState.hasViewedOnboarding = YES;
}

#pragma mark Touch

- (IBAction)currentLocationButtonTouched:(id)sender
{
    CLLocationCoordinate2D currentLocation = [[self.locationManager location] coordinate];
    
    if((currentLocation.latitude == 0) && (currentLocation.longitude == 0))
    {
        currentLocation = self.defaultLocation;
    }
    
    [self zoomToCoordinate:currentLocation];
}

# pragma mark - Private methods

- (void)configureHUD
{
    self.hud = [[RefugeHUD alloc] initWithView:self.view];
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
    self.mapView.mapDelegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    [self configureDefaultLocation];
    [self addTouchRecognizerToMap];
}

- (void)configureDefaultLocation
{
    CLLocationCoordinate2D oneEmbarcaderoCenterSF = CLLocationCoordinate2DMake(37.7945, -122.3997); // same as default in web app
    self.defaultLocation = oneEmbarcaderoCenterSF;
}

- (void)addTouchRecognizerToMap
{
    UITapGestureRecognizer *mapTouched = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(dismissSearch)];
    
    [self.mapView addGestureRecognizer:mapTouched];
}

- (void)configureSearch
{
    self.searchQuery = [[RefugeSearch alloc] init];
    self.searchResultsTable.hidden = YES;
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

- (void)displayOnboarding
{
    [self performSegueWithIdentifier:kSegueNameModalOnboarding sender:self];
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

- (void)plotRestrooms
{
    NSArray *allRestrooms = [self.restroomManager restroomsFromLocalStore];
    
    [self removeAllAnnotationsFromMap];
    
    NSMutableArray *mapPins = [NSMutableArray array];
    
    for (RefugeRestroom *restroom in allRestrooms)
    {
        RefugeMapPin *mapPin = [[RefugeMapPin alloc] initWithRestroom:restroom];
        
        [mapPins addObject:mapPin];
    }
    
    [self.mapView addAnnotations:mapPins];
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
    [self.searchQuery searchForPlaces:searchString
                                 success:^(NSArray *places) {
                                     self.searchResults = places;
                                     [self.searchResultsTable reloadData];
                                 }
                                 failure:^(NSError *error) {
                                     
                                     [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeSearchAttemptFailed];
                                     
                                     [self displayAlertForWithMessage:kErrorTextAutocompleteFail];
                                     [self dismissSearch];
                                 }
    ];
}

- (void)displayAlertForWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

- (void)dismissSearch
{
    self.searchBar.text = @"";
    
    [self.searchBar performSelector: @selector(resignFirstResponder)
                      withObject: nil
                      afterDelay: 0.1];
    
    self.searchResultsTable.hidden = YES;
}

- (RefugeMapPlace *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.searchResults objectAtIndex:indexPath.row];
}

- (void)placemarkSelected:(CLPlacemark *)placemark
{
    NSDictionary *addressInfo = placemark.addressDictionary;
    NSString *address = [NSString stringWithFormat:@"%@, %@, %@",
                         [addressInfo objectForKey:@"Name"],
                         [addressInfo objectForKey:@"City"],
                         [addressInfo objectForKey:@"State"]];
    
    [self addPlacemarkToMap:placemark withTitle:[NSString stringWithFormat:@"Search: %@", address]];
    [self recenterMapToPlacemark:placemark];
}

-(void) addPlacemarkToMap:(CLPlacemark *)placemark withTitle:(NSString *)title
{
    MKPointAnnotation *annotationFromPlacemark = [[MKPointAnnotation alloc] init];
    annotationFromPlacemark.coordinate = placemark.location.coordinate;
    annotationFromPlacemark.title = title;
    
    [self.mapView addAnnotation:annotationFromPlacemark];
}

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark
{
    [self zoomToCoordinate:placemark.location.coordinate];
}

@end

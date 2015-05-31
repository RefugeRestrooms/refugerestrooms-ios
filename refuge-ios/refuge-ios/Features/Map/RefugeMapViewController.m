//
// RefugeMapViewController.m
//
// Copyleft (c) 2015 Refuge Restrooms
//
// Refuge is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// This notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RefugeMapViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Mixpanel+Refuge.h"
#import <Reachability/Reachability.h>
#import "RefugeAppState.h"
#import "RefugeDataPersistenceManager.h"
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

static float const kRefugeMetersPerMile = 1609.344;
static NSString *const kRefugeSearchResultsTableCellReuseIdentifier = @"SearchResultsTableCellReuseIdentifier";
static NSString *const kRefugeSegueNameModalOnboarding = @"RefugeRestroomOnboardingModalSegue";
static NSString *const kRefugeSegueNameShowNewRestroomForm = @"RefugeRestroomNewRestroomShowSegue";
static NSString *const kRefugeSegueNameShowRestroomDetails = @"RefugeRestroomDetailsShowSegue";

static NSString *const kRefugeReachabilityTestURL = @"www.google.com";
static NSString *const kRefugeErrorTextAutocompleteFail = @"Cound not fetch addresses for Search";
static NSString *const kRefugeErrorTextNoInternet = @"Internet is unavailable. Certain features may be disabled";
static NSString *const kRefugeErrorTextPlacemarkCreationFail = @"Could not map selected location";
static NSString *const kRefugeErrorTextLocationServicesFailiOS7 =
    @"Location Access is disabled. If you'd like to authorize it, please go to your device settings";
    
@interface RefugeMapViewController ()

@property (nonatomic, strong) RefugeAppState *appState;
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

#pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appState = [[RefugeAppState alloc] init];
    [self configureLocationManager];
    [self configureMap];
    [self configureSearch];
    [self configureRestroomManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.isSyncComplete) {
        [self promptToAllowLocationServices];
        
        if (self.appState.hasViewedOnboarding == NO) {
            [self displayOnboarding];
        }
        
        self.internetReachability = [Reachability reachabilityWithHostname:kRefugeReachabilityTestURL];
        
        if (self.internetReachability.isReachable) {
            if (self.isSyncComplete == NO) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                               ^(void) {
                               
                                   [self.restroomManager fetchRestroomsFromAPI];
                                   
                               });
            }
        } else {
            self.isSyncComplete = YES;
            
            [self displayAlertForWithMessage:kRefugeErrorTextNoInternet];
            
            [self plotRestrooms];
        }
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Public methods

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    if (!self.isInitialZoomComplete) {
        CLLocation *location = [self.locationManager location];
        CLLocationCoordinate2D initialCoorindate = [location coordinate];
        
        [self zoomToCoordinate:initialCoorindate];
        
        [self.locationManager startUpdatingLocation];
        
        self.isInitialZoomComplete = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeLocationManagerFailed];
    
    [self.locationManager stopUpdatingLocation];
}

#pragma mark RefugeMapDelegate methods

- (void)tappingCalloutAccessoryDidRetrievedSingleMapPin:(RefugeMapPin *)mapPin
{
    [[Mixpanel sharedInstance] refugeTrackRestroomDetailsViewed:mapPin];
    
    [self performSegueWithIdentifier:kRefugeSegueNameShowRestroomDetails sender:mapPin];
}

- (void)retrievingSingleMapPinFromCalloutAccessoryFailed:(RefugeMapPin *)firstPinRetrieved
{
    [[Mixpanel sharedInstance] refugeTrackRestroomDetailsViewed:firstPinRetrieved];
    
    [self performSegueWithIdentifier:kRefugeSegueNameShowRestroomDetails sender:firstPinRetrieved];
}

#pragma mark RefugeRestroomManagerDelegate methods

- (void)didFetchRestrooms
{
    self.isSyncComplete = YES;
    self.appState.dateLastSynced = [NSDate date];
    
    [self plotRestrooms];
}

- (void)fetchingRestroomsFromApiFailedWithError:(NSError *)error
{
    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeFetchingRestroomsFailed];
    
    self.isSyncComplete = YES;
}

- (void)fetchingRestroomsFromLocalStoreFailedWithError:(NSError *)error
{
    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeLocalStoreFetchFailed];
}

- (void)savingRestroomsFailedWithError:(NSError *)error
{
    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeSavingRestroomsFailed];
    
    self.isSyncComplete = YES;
}

#pragma mark UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        [self dismissSearch];
    } else {
        self.searchResultsTable.hidden = NO;
        [self handleSearchForString:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self dismissSearch];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
        [self.searchResultsTable dequeueReusableCellWithIdentifier:kRefugeSearchResultsTableCellReuseIdentifier];
        
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kRefugeSearchResultsTableCellReuseIdentifier];
    }
    
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefugeMapPlace *place = [self placeAtIndexPath:indexPath];
    NSString *cellText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    [place resolveToPlacemarkWithSuccessBlock:^(CLPlacemark *placemark) {
    
        [[Mixpanel sharedInstance] refugeTrackSearchWithString:cellText placemark:placemark];
        
        [self placemarkSelected:placemark];
        
        [self.searchResultsTable deselectRowAtIndexPath:indexPath animated:NO];
    } failure:^(NSError *error) {
    
        [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeResolvingPlacemarkFailed];
        
        [self displayAlertForWithMessage:kRefugeErrorTextPlacemarkCreationFail];
    }];
    
    [self dismissSearch];
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kRefugeSegueNameShowRestroomDetails]) {
        RefugeRestroomDetailsViewController *destinationController = [segue destinationViewController];
        RefugeMapPin *mapPin = (RefugeMapPin *)sender;
        
        destinationController.restroom = mapPin.restroom;
    }
    
    if ([[segue identifier] isEqualToString:kRefugeSegueNameShowNewRestroomForm]) {
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
    
    if ((currentLocation.latitude == 0) && (currentLocation.longitude == 0)) {
        currentLocation = self.defaultLocation;
    }
    
    [self zoomToCoordinate:currentLocation];
}

#pragma mark - Private methods

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
    CLLocationCoordinate2D oneEmbarcaderoCenterSF =
        CLLocationCoordinate2DMake(37.7945, -122.3997); // same as default in web app
    self.defaultLocation = oneEmbarcaderoCenterSF;
}

- (void)addTouchRecognizerToMap
{
    UITapGestureRecognizer *mapTouched =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSearch)];
        
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
    [self performSegueWithIdentifier:kRefugeSegueNameModalOnboarding sender:self];
}

- (void)promptToAllowLocationServices
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    } else // iOS 7
    {
        if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusAuthorized) {
            [self.locationManager startUpdatingLocation];
        } else {
            [self displayAlertForWithMessage:kRefugeErrorTextLocationServicesFailiOS7];
        }
    }
}

- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion viewRegion =
        MKCoordinateRegionMakeWithDistance(coordinate, (0.5 * kRefugeMetersPerMile), (0.5 * kRefugeMetersPerMile));
        
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)plotRestrooms
{
    NSArray *allRestrooms = [self.restroomManager restroomsFromLocalStore];
    
    if (allRestrooms != nil) {
        [self removeAllAnnotationsFromMap];
        
        NSMutableArray *mapPins = [NSMutableArray array];
        
        for (RefugeRestroom *restroom in allRestrooms) {
            RefugeMapPin *mapPin = [[RefugeMapPin alloc] initWithRestroom:restroom];
            
            [mapPins addObject:mapPin];
        }
        
        [self.mapView addAnnotations:mapPins];
        
        // only track initial plot
        if (self.appState.hasPreloadedRestrooms == NO) {
            [[Mixpanel sharedInstance] refugeTrackRestroomsPlotted:[allRestrooms count]];
        }
    }
}

- (void)removeAllAnnotationsFromMap
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
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
            
            [self displayAlertForWithMessage:kRefugeErrorTextAutocompleteFail];
            [self dismissSearch];
        }];
}

- (void)displayAlertForWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                                          
    [alert show];
}

- (void)dismissSearch
{
    self.searchBar.text = @"";
    
    [self.searchBar performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.1];
    
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

- (void)addPlacemarkToMap:(CLPlacemark *)placemark withTitle:(NSString *)title
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

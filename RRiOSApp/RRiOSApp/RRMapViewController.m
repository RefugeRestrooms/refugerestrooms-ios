//
//  RRMapViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "RRMapViewController.h"

#import "AppDelegate.h"
#import "AppState.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "Restroom.h"
#import "RestroomManager.h"
#import "RestroomDetailsViewController.h"
#import "RRMapKitAnnotation.h"
#import "Reachability.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "SPGooglePlacesAutocompleteQuery.h"

BOOL initialZoomComplete = NO;
BOOL internetIsAccessible = NO;
BOOL syncComplete = NO;
BOOL plotComplete = NO;

@implementation RRMapViewController
{
    Reachability *internetReachability;
    CLLocationManager *locationManager;
    MBProgressHUD *hud;
    NSManagedObjectContext *context;
    
    // search
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    BOOL shouldBeginEditing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = RRCONSTANTS_APP_NAME;
    
    if(!initialZoomComplete)
    {
        // set up mapView
        self.mapView.delegate = self;
        self.mapView.mapType = MKMapTypeStandard;
        self.mapView.showsUserLocation = YES;
        
        // set up search
        searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
        searchQuery.key = RRCONSTANTS_API_KEY_GOOGLE_PLACES;
        searchQuery.radius = RRCONSTANTS_SEARCH_QUERY_RADIUS;
        self.search.delegate = self;
        self.search.placeholder = RRCONSTANTS_SEARCH_BAR_DEFAULT_TEXT;
        self.searchTableView.delegate = self;
        self.searchTableView.dataSource = self;
        self.searchTableView.hidden = YES;
        shouldBeginEditing = YES;
        
        // style keyboard
        for(UIView *searchSubView in [self.search subviews])
        {
            if([searchSubView conformsToProtocol:@protocol(UITextInputTraits)])
            {
                [(UITextField *)searchSubView setReturnKeyType: UIReturnKeyDone];
                [(UITextField *)searchSubView setEnablesReturnKeyAutomatically:NO];
            }
            else
            {
                for(UIView *searchSubSubView in [searchSubView subviews])
                {
                    if([searchSubSubView conformsToProtocol:@protocol(UITextInputTraits)])
                    {
                        [(UITextField *)searchSubSubView setReturnKeyType: UIReturnKeyDone];
                        [(UITextField *)searchSubSubView setEnablesReturnKeyAutomatically:NO];
                    }
                }
            }
        }
        
        // set up HUD
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.color = [UIColor colorWithRed:RRCONSTANTS_COLOR_DARKPURPLE_RED green:RRCONSTANTS_COLOR_DARKPURPLE_GREEN blue:RRCONSTANTS_COLOR_DARKPURPLE_BLUE alpha:1.0];
        hud.labelText = RRCONSTANTS_SYNC_TEXT;
    
        // set up location manager
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
        // set RestroomManager delegate
        RestroomManager *restroomManager = (RestroomManager *)[RestroomManager sharedInstance];
        restroomManager.delegate = self;
        
        // set up NSManagedObjectContext
        context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!initialZoomComplete)
    {
    
        // prompt for location allowing
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        else
        {
#pragma message "Should provide else case here that can run on iOS 7"
            // TODO: Test on iOS 7 device
        }
    
        [locationManager startUpdatingLocation];
    
        // check for Internet reachability
        internetReachability = [Reachability reachabilityWithHostname:RRCONSTANTS_URL_TO_TEST_REACHABILITY];
    
        __weak RRMapViewController *weakSelf = self;
    
        // Internet is reachable
        internetReachability.reachableBlock = ^(Reachability*reach)
        {
        
            dispatch_async
            (
                // update UI on main thread
                dispatch_get_main_queue(), ^
                {
                    RRMapViewController *strongSelf = weakSelf;
                
                    if(strongSelf)
                    {
                        internetIsAccessible = YES;
                    
                        // if not synced yet, fetch restrooms newly created and updated
                        if(!syncComplete)
                        {
                            [[RestroomManager sharedInstance] fetchRestroomsModifiedSince:[AppState sharedInstance].dateLastSynced];
                        }
                    
                        // reset date last synced
                        [AppState sharedInstance].dateLastSynced = [NSDate date];
                    
                        syncComplete = YES;
                    }
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
                    RRMapViewController *strongSelf = weakSelf;
                
                    if(strongSelf)
                    {
                        internetIsAccessible = NO;
                        
                        strongSelf->hud.hidden = YES;
                        
                        if(!plotComplete)
                        {
                            // alert user
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:RRCONSTANTS_ALERT_TITLE_INFO message:RRCONSTANTS_ALERT_NO_INTERNET_TEXT delegate:nil cancelButtonTitle:RRCONSTANTS_ALERT_DISMISS_BUTTON_TEXT otherButtonTitles:nil];
                            [alert show];
                            
                            // plot restrooms saved to Core Data
                            [strongSelf fetchAndPlotRestrooms];
                        }
                    }
                }
             );
        };
    
        [internetReachability startNotifier];
    }
}

#pragma mark - ADClusterMapView methods

- (NSInteger)numberOfClustersInMapView:(ADClusterMapView *)mapView
{
    return RRCONSTANTS_MAX_NUM_PIN_CLUSTERS;
}

- (NSString *)seedFileName
{
    return nil;
}

- (NSString *)pictoName
{
    return RRCONSTANTS_PIN_GRAPHIC;
}

- (NSString *)clusterPictoName
{
    return RRCONSTANTS_PIN_CLUSTER_GRAPHIC;
}

- (NSString *)clusterTitleForMapView:(ADClusterMapView *)mapView
{
    // default : @"%d elements"
    return RRCONSTANTS_PIN_CLUSTER_TITLE;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = nil;
    
    // user location
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // custom pin
    
    if([annotation isKindOfClass:[ADClusterAnnotation class]])
    {
        annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ADClusterableAnnotation"];
    
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"ADClusterableAnnotation"];
        
            // TODO: don't re-size pin size in code
            UIImage *resizedImage = [self resizeImageNamed:self.pictoName width:RRCONSTANTS_PIN_GRAPHIC_WIDTH height:RRCONSTANTS_PIN_GRAPHIC_HEIGHT];
        
            annotationView.image = resizedImage;
            annotationView.canShowCallout = YES;
        
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = rightButton;
        }
        else
        {
            annotationView.annotation = annotation;
        }
    }
    
    return annotationView;
}

- (MKAnnotationView *)mapView:(ADClusterMapView *)mapView viewForClusterAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ADMapCluster"];
    
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"ADMapCluster"];
        
        // TODO: don't re-set pin size in code
        UIImage *resizedImage = [self resizeImageNamed:self.pictoName width:RRCONSTANTS_PIN_GRAPHIC_WIDTH height:RRCONSTANTS_PIN_GRAPHIC_HEIGHT];
        
        annotationView.image = resizedImage;
        annotationView.canShowCallout = YES;
    }
    else
    {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = [view annotation];
    
    if ([[view annotation] isKindOfClass:[ADClusterAnnotation class]])
    {
        // segue to details controller
        [self performSegueWithIdentifier:RRCONSTANTS_TRANSITION_NAME_RESTROOM_DETAILS sender:annotation];
        
    }
}

#pragma mark - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    
    if(!initialZoomComplete)
    {
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        // zoom to initial location
        [self zoomToLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        [locationManager startUpdatingLocation];
        
        initialZoomComplete = YES;
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    
    if(internetIsAccessible) { hud.labelText = RRCONSTANTS_NO_LOCATION_TEXT; }
    [hud hide:YES afterDelay:5];
    
    hud.labelText = RRCONSTANTS_SYNC_TEXT;
    [hud hide:NO];
}

#pragma mark - RestroomManagerDelegate methods

- (void)didBuildRestrooms
{
    [self fetchAndPlotRestrooms];
}

- (void)fetchingRestroomsFailedWithError:(NSError *)error
{
    // display error
    hud.mode = MBProgressHUDModeText;
    hud.labelText = RRCONSTANTS_SYNC_ERROR_TEXT;
    hud.detailsLabelText = RRCONSTANTS_SYNC_ERROR_DETAILS_TEXT;
    
    NSLog(@"Sync Error Description: %@", [error description]);
}

#pragma mark - RRMapSearchDelegate methods

- (void)mapSearchPlacemarkSelected:(CLPlacemark *)placemark cellName:(NSString *)cellName
{
    NSString *placemarkLabel = [NSString stringWithFormat:@"Search: %@", cellName];
    
    [self addPlacemarkAnnotationToMap:placemark addressString:placemarkLabel];
    [self recenterMapToPlacemark:placemark];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResultPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:RRCONSTANTS_SEARCH_CELL_REUSE_IDENTIFIER];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RRCONSTANTS_SEARCH_CELL_REUSE_IDENTIFIER];
    }
    
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
    
    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error)
     {
         if (error)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:RRCONSTANTS_ALERT_TITLE_ERROR message:RRCONSTANTS_SEARCH_ERROR_PLACE_NOT_FOUND delegate:nil cancelButtonTitle:RRCONSTANTS_ALERT_DISMISS_BUTTON_TEXT otherButtonTitles:nil];
             
             [alert show];
         }
         else if (placemark)
         {
             // placemark selected
             [self mapSearchPlacemarkSelected:placemark cellName:[self tableView:tableView cellForRowAtIndexPath:indexPath].textLabel.text];
             
             // dismiss search
             [self.searchTableView deselectRowAtIndexPath:indexPath animated:NO];
             [self dismissSearch];
         }
     }];
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // if search text is cleared
    if([searchText length] == 0)
    {
        [self dismissSearch];
        self.searchTableView.hidden = YES;
    }
    else // search being made
    {
        if(self.searchTableView.hidden)
        {
            self.searchTableView.hidden = NO;
        }
        
        [self handleSearchForSearchString:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self dismissSearch];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:RRCONSTANTS_TRANSITION_NAME_RESTROOM_DETAILS])
    {
        RestroomDetailsViewController *destinationController = [segue destinationViewController];
        
        ADClusterAnnotation *annotation = (ADClusterAnnotation *)sender;
        RRMapKitAnnotation *originalAnnotation = annotation.originalAnnotations[0];
        
        destinationController.restroom = originalAnnotation.restroom;
    }
}

#pragma mark - Helper methods


- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (void)handleSearchForSearchString:(NSString *)searchString
{
    //    searchQuery.location = self.mapView.userLocation.coordinate;
    searchQuery.input = searchString;
    
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error)
     {
         if (error)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:RRCONSTANTS_ALERT_TITLE_ERROR message:RRCONSTANTS_SEARCH_ERROR_COULD_NOT_FETCH_PLACES delegate:nil cancelButtonTitle:RRCONSTANTS_ALERT_DISMISS_BUTTON_TEXT otherButtonTitles:nil];
             
             [alert show];
             
             [self dismissSearch];
         }
         else
         {
             searchResultPlaces = places;
             //[self.searchDisplayController.searchResultsTableView reloadData];
             [self.searchTableView reloadData];
         }
     }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    if (shouldBeginEditing)
//    {
//        // Animate in the table view.
//        NSTimeInterval animationDuration = 0.3;
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:animationDuration];
//        self.searchDisplayController.searchResultsTableView.alpha = 1.0;
//        [UIView commitAnimations];
//        
//        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
//    }
    
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    
    return boolToReturn;
}

- (IBAction)unwindToMapViewController:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
//    if ([sourceViewController isKindOfClass:[RRMapSearchViewController class]])
//    {
//        // handle unwinds coming from Search
//    }
}

- (void)zoomToLatitude:(float)latitude longitude:(float)longitude
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = latitude;
    zoomLocation.longitude= longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, (0.5 * RRCONSTANTS_METERS_PER_MILE), (0.5 * RRCONSTANTS_METERS_PER_MILE));
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark
{
    CLLocationCoordinate2D coordinate = placemark.location.coordinate;
    
    [self zoomToLatitude:coordinate.latitude longitude:coordinate.longitude];
}

- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemark addressString:(NSString *)address
{
    MKPointAnnotation *selectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
    selectedPlaceAnnotation.coordinate = placemark.location.coordinate;
    selectedPlaceAnnotation.title = address;
    
    [self.mapView addNonClusteredAnnotation:selectedPlaceAnnotation];
}

- (UIImage *)resizeImageNamed:(NSString *)imageName width:(CGFloat)width height:(CGFloat)height
{
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(newSize);
    [[UIImage imageNamed:imageName] drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (void)dismissSearch
{
    self.search.text = @"";
    
    [self.search performSelector: @selector(resignFirstResponder)
                    withObject: nil
                    afterDelay: 0.1];
    
    self.searchTableView.hidden = YES;
}

- (void)fetchAndPlotRestrooms
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:RRCONSTANTS_ENTITY_NAME_RESTROOM];
    
    NSError *error = nil;
    NSArray *allRestrooms = [context executeFetchRequest:fetchRequest error:&error];
    
    if(error)
    {
        // TODO: Handle error fetching Restrooms from Core Data
    }
    else
    {
        [self plotRestrooms:allRestrooms];
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:RRCONSTANTS_COMPLETION_GRAPHIC]];
        hud.labelText = RRCONSTANTS_COMPLETION_TEXT;
        [hud hide:YES afterDelay:1];
        
        plotComplete = YES;
    }
}

- (void)plotRestrooms:(NSArray *)restrooms
{
    // remove existing annotations
    for (id<MKAnnotation> annotation in self.mapView.annotations)
    {
        [self.mapView removeAnnotation:annotation];
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    NSLog(@"Num Restrooms to plot: %i", [restrooms count]);
    
    // add all annotations
    for (Restroom *restroom in restrooms)
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [restroom.latitude doubleValue];
        coordinate.longitude = [restroom.longitude doubleValue];
        
        // create map location object
        RRMapKitAnnotation *annotation = [[RRMapKitAnnotation alloc] initWithName:restroom.name address:restroom.street coordinate:coordinate];
        annotation.restroom = restroom;
        
        // add annotation
        [annotations addObject:annotation];
    }
    
    // set annotations
    [self.mapView setAnnotations:[NSMutableArray arrayWithArray:annotations]];
}

@end

//
//  RRMapSearchViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 11/4/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRMapSearchViewController.h"

#import "Constants.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

CGFloat SEARCH_QUERY_RADIUS = 100.0;
NSString *SEARCH_CELL_REUSE_IDENTIFIER = @"MapSearchCellResueIdentifier";
NSString *SEARCH_CONTROLLER_NAME = @"Search";
NSString *SEARCH_BAR_DEFAULT_TEXT = @"Address";
NSString *SEARCH_ERROR_PLACE_NOT_FOUND = @"Could not map selected Place";
NSString *SEARCH_ERROR_COULD_NOT_FETCH_PLACES = @"Could not fetch Places";

@implementation RRMapSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up search
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
    searchQuery.radius = SEARCH_QUERY_RADIUS;
    shouldBeginEditing = YES;
    
    // style navigation bar
    self.title = SEARCH_CONTROLLER_NAME;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // style search bar
    self.searchDisplayController.searchBar.placeholder = SEARCH_BAR_DEFAULT_TEXT;
    
    // set up data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResultPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_CELL_REUSE_IDENTIFIER];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SEARCH_CELL_REUSE_IDENTIFIER];
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
            SPPresentAlertViewWithErrorAndTitle(error, SEARCH_ERROR_PLACE_NOT_FOUND);
        }
        else if (placemark)
        {
            [self.delegate placemarkSelected:placemark];
            
            [self performSegueWithIdentifier:MAP_VIEW_TRANSITION_NAME sender:self];
        }
    }];
}

#pragma mark - UISearchDisplayController Delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchBar isFirstResponder])
    {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
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
            SPPresentAlertViewWithErrorAndTitle(error, SEARCH_ERROR_COULD_NOT_FETCH_PLACES);
        }
        else
        {
            searchResultPlaces = places;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (shouldBeginEditing)
    {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 1.0;
        [UIView commitAnimations];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    
    return boolToReturn;
}

//- (void)recenterMapToPlacemark:(CLPlacemark *)placemark
//{
//    MKCoordinateRegion region;
//    MKCoordinateSpan span;
//
//    span.latitudeDelta = 0.02;
//    span.longitudeDelta = 0.02;
//
//    region.span = span;
//    region.center = placemark.location.coordinate;
//
//    [self.mapView setRegion:region];
//}

//- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemark addressString:(NSString *)address
//{
//    [self.mapView removeAnnotation:selectedPlaceAnnotation];
////    [selectedPlaceAnnotation release];
//
//    selectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
//    selectedPlaceAnnotation.coordinate = placemark.location.coordinate;
//    selectedPlaceAnnotation.title = address;
//    [self.mapView addAnnotation:selectedPlaceAnnotation];
//}

//- (void)dismissSearchControllerWhileStayingActive
//{
//    // Animate out the table view.
//    NSTimeInterval animationDuration = 0.3;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:animationDuration];
//    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
//    [UIView commitAnimations];
//
//    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
//    [self.searchDisplayController.searchBar resignFirstResponder];
//}

@end
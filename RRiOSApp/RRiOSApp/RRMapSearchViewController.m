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

@implementation RRMapSearchViewController
{
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up search
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
    searchQuery.key = RRCONSTANTS_API_KEY_GOOGLE_PLACES;
    searchQuery.radius = RRCONSTANTS_SEARCH_QUERY_RADIUS;
    
    // style search bar
    self.searchDisplayController.searchBar.placeholder = RRCONSTANTS_SEARCH_BAR_DEFAULT_TEXT;
    
    shouldBeginEditing = YES;
    
    // style navigation bar
    self.title = RRCONSTANTS_SEARCH_CONTROLLER_NAME;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RRCONSTANTS_SEARCH_CELL_REUSE_IDENTIFIER];
    
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:RRCONSTANTS_ALERT_TITLE_ERROR message:[error localizedDescription] delegate:nil cancelButtonTitle:RRCONSTANTS_ALERT_DISMISS_BUTTON_TEXT otherButtonTitles:nil];
            
            [alert show];
        }
        else if (placemark)
        {
            // notify delegate of placemark selected
            [self.delegate mapSearchPlacemarkSelected:placemark cellName:[self tableView:tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            
            // deselect row
            [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
            
            // segue to map
            [self performSegueWithIdentifier:RRCONSTANTS_UNWIND_NAME_MAP_VIEW sender:self];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:RRCONSTANTS_ALERT_TITLE_ERROR message:[error localizedDescription] delegate:nil cancelButtonTitle:RRCONSTANTS_ALERT_DISMISS_BUTTON_TEXT otherButtonTitles:nil];
            
            [alert show];
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

@end
//
//  RRMapSearchViewController.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 11/4/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>

// FROM SP
#import <MapKit/MapKit.h>
@class SPGooglePlacesAutocompleteQuery;


@interface RRMapSearchViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    // FROM SP
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property IBOutlet UISearchBar *searchBar;

@end

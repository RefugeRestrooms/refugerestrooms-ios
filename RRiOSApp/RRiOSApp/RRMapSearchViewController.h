//
//  RRMapSearchViewController.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 11/4/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SPGooglePlacesAutocompleteQuery;

@class RRMapSearchViewController;

@protocol RRMapSearchDelegate <NSObject>

- (void)placemarkSelected:(CLPlacemark *)placemark;

@end


@interface RRMapSearchViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
}

@property (weak) id <RRMapSearchDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property IBOutlet UISearchBar *searchBar;

@end

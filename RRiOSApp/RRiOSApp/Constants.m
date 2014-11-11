//
//  Constants.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/30/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - General constants

const NSString *APP_NAME = @"Refuge Restrooms";
const NSString *ENTITY_NAME_RESTROOM = @"Restroom";
const NSString *TRANSITION_NAME_MAP_VIEW = @"ShowMap";
const NSString *TRANSITION_NAME_MAP_SEARCH = @"ShowMapSearch";
const NSString *TRANSITION_NAME_RESTROOM_DETAILS = @"ShowRestroomDetails";

#pragma mark - API constants

const NSString *API_CALL_RESTROOMS_BY_DATE = @"http://www.refugerestrooms.org:80/api/v1/restrooms/by_date.json";
const NSInteger MAX_RESTROOMS_TO_FETCH = 10000;

#pragma mark - Map constants

const NSString *COMPLETION_TEXT = @"Complete";
const NSString *COMPLETION_GRAPHIC = @"Images/37x-Checkmark@2x.png";
const NSInteger MAX_NUM_PIN_CLUSTERS = 100;
const NSString *NO_INTERNET_TEXT = @"Internet connection unavailable";
const NSString *NO_LOCATION_TEXT = @"Could not find your location";
const NSString *NO_NAME_TEXT = @"Details";
const NSString *PIN_GRAPHIC = @"Images/pin.png";
const NSString *PIN_CLUSTER_GRAPHIC = @"Images/pin.png";
const NSString *SYNC_TEXT = @"Syncing";
const NSString *SYNC_ERROR_TEXT = @"Sync error :(";
const NSString *SYNC_ERROR_DETAILS_TEXT = @"Please close and try again";
const NSString *URL_TO_TEST_REACHABILITY = @"www.google.com";

# pragma mark - Map Search constants

const NSString *SEARCH_CELL_REUSE_IDENTIFIER = @"MapSearchCellResueIdentifier";
const NSString *SEARCH_CONTROLLER_NAME = @"Search";
const NSString *SEARCH_BAR_DEFAULT_TEXT = @"Address";
const NSString *SEARCH_ERROR_PLACE_NOT_FOUND = @"Could not map selected location";
const NSString *SEARCH_ERROR_COULD_NOT_FETCH_PLACES = @"Could not fetch addresses for autocomplete";

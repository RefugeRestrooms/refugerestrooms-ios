//
//  Constants.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/30/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - General constants

const NSString *RRCONSTANTS_APP_NAME = @"Refuge Restrooms";

const NSString *RRCONSTANTS_ALERT_TITLE = @"Info";
const NSString *RRCONSTANTS_ALERT_DISMISS_BUTTON_TEXT = @"OK";
const NSString *RRCONSTANTS_ENTITY_NAME_RESTROOM = @"Restroom";
const NSString *RRCONSTANTS_TRANSITION_NAME_MAP_SEARCH = @"ShowMapSearch";
const NSString *RRCONSTANTS_TRANSITION_NAME_RESTROOM_DETAILS = @"ShowRestroomDetails";
const NSString *RRCONSTANTS_UNWIND_NAME_MAP_VIEW = @"UnwindToMap";

#pragma mark - API constants

const NSString *RRCONSTANTS_API_CALL_RESTROOMS_BY_DATE = @"http://www.refugerestrooms.org:80/api/v1/restrooms/by_date.json";
const NSInteger RRCONSTANTS_MAX_RESTROOMS_TO_FETCH = 10000;

#pragma mark - Map constants

const NSString *RRCONSTANTS_COMPLETION_TEXT = @"Complete";
const NSString *RRCONSTANTS_COMPLETION_GRAPHIC = @"Images/37x-Checkmark@2x.png";
const NSInteger RRCONSTANTS_MAX_NUM_PIN_CLUSTERS = 100;
const NSString *RRCONSTANTS_ALERT_NO_INTERNET_TEXT = @"Internet unavailable\nCertain features may be disabled";
const NSString *RRCONSTANTS_NO_LOCATION_TEXT = @"Could not find your location";
const NSString *RRCONSTANTS_NO_NAME_TEXT = @"Details";
const NSString *RRCONSTANTS_PIN_GRAPHIC = @"Images/pin.png";
const NSString *RRCONSTANTS_PIN_CLUSTER_GRAPHIC = @"Images/pin.png";
const NSString *RRCONSTANTS_SYNC_TEXT = @"Syncing";
const NSString *RRCONSTANTS_SYNC_ERROR_TEXT = @"Sync error :(";
const NSString *RRCONSTANTS_SYNC_ERROR_DETAILS_TEXT = @"Please close and try again";
const NSString *RRCONSTANTS_URL_TO_TEST_REACHABILITY = @"www.google.com";

# pragma mark - Map Search constants

const NSString *RRCONSTANTS_SEARCH_CELL_REUSE_IDENTIFIER = @"MapSearchCellResueIdentifier";
const NSString *RRCONSTANTS_SEARCH_CONTROLLER_NAME = @"Search";
const NSString *RRCONSTANTS_SEARCH_BAR_DEFAULT_TEXT = @"Address";
const NSString *RRCONSTANTS_SEARCH_ERROR_PLACE_NOT_FOUND = @"Could not map selected location";
const NSString *RRCONSTANTS_SEARCH_ERROR_COULD_NOT_FETCH_PLACES = @"Could not fetch addresses for autocomplete";

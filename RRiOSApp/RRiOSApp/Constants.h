//
//  Constants.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/30/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef RRiOSApp_Constants_h
#define RRiOSApp_Constants_h

#pragma mark - General constants

extern NSString *const RRCONSTANTS_APP_NAME;

extern NSString *const RRCONSTANTS_ALERT_TITLE;
extern NSString *const RRCONSTANTS_ALERT_DISMISS_BUTTON_TEXT;
extern NSString *const RRCONSTANTS_ENTITY_NAME_RESTROOM;
static const float RRCONSTANTS_METERS_PER_MILE = 1609.344;
extern NSString *const RRCONSTANTS_TRANSITION_NAME_MAP_SEARCH;
extern NSString *const RRCONSTANTS_TRANSITION_NAME_RESTROOM_DETAILS;
extern NSString *const RRCONSTANTS_UNWIND_NAME_MAP_VIEW;

#pragma mark - Colors

static const float RRCONSTANTS_COLOR_DARKPURPLE_RED = 65.0/255.0;
static const float RRCONSTANTS_COLOR_DARKPURPLE_GREEN = 60.0/255.0;
static const float RRCONSTANTS_COLOR_DARKPURPLE_BLUE = 107.0/255.0;

static const float RRCONSTANTS_COLOR_LIGHTPURPLE_RED = 131.0/255.0;
static const float RRCONSTANTS_COLOR_LIGHTPURPLE_GREEN = 119.0/255.0;
static const float RRCONSTANTS_COLOR_LIGHTPURPLE_BLUE = 175.0/255.0;

#pragma mark - API constants

extern NSString *const RRCONSTANTS_API_CALL_RESTROOMS_BY_DATE;
extern NSInteger const RRCONSTANTS_MAX_RESTROOMS_TO_FETCH;

#pragma mark - Map constants

extern NSString *const RRCONSTANTS_COMPLETION_TEXT;
extern NSString *const RRCONSTANTS_COMPLETION_GRAPHIC;
extern NSInteger const RRCONSTANTS_MAX_NUM_PIN_CLUSTERS;
extern NSString *const RRCONSTANTS_ALERT_NO_INTERNET_TEXT;
extern NSString *const RRCONSTANTS_NO_LOCATION_TEXT;
extern NSString *const RRCONSTANTS_NO_NAME_TEXT;
extern NSString *const RRCONSTANTS_PIN_GRAPHIC;
extern NSString *const RRCONSTANTS_PIN_CLUSTER_GRAPHIC;
static const float RRCONSTANTS_PIN_GRAPHIC_WIDTH = 31.0;
static const float RRCONSTANTS_PIN_GRAPHIC_HEIGHT = 39.5;
extern NSString *const RRCONSTANTS_SYNC_TEXT;
extern NSString *const RRCONSTANTS_SYNC_ERROR_TEXT;
extern NSString *const RRCONSTANTS_SYNC_ERROR_DETAILS_TEXT;
extern NSString *const RRCONSTANTS_URL_TO_TEST_REACHABILITY;

# pragma mark - Map Search constants

static const float RRCONSTANTS_SEARCH_QUERY_RADIUS = 100.0;
const NSString *RRCONSTANTS_SEARCH_CELL_REUSE_IDENTIFIER;
const NSString *RRCONSTANTS_SEARCH_CONTROLLER_NAME;
const NSString *RRCONSTANTS_SEARCH_BAR_DEFAULT_TEXT;
const NSString *RRCONSTANTS_SEARCH_ERROR_PLACE_NOT_FOUND;
const NSString *RRCONSTANTS_SEARCH_ERROR_COULD_NOT_FETCH_PLACES;

#endif

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

extern NSString *const APP_NAME;
static const float METERS_PER_MILE = 1609.344;
extern NSString *const RESTROOM_DETAILS_TRANSITION_NAME;

#pragma mark - Colors

static const float RRCOLOR_DARKPURPLE_RED = 65.0/255.0;
static const float RRCOLOR_DARKPURPLE_GREEN = 60.0/255.0;
static const float RRCOLOR_DARKPURPLE_BLUE = 107.0/255.0;

static const float RRCOLOR_LIGHTPURPLE_RED = 131.0/255.0;
static const float RRCOLOR_LIGHTPURPLE_GREEN = 119.0/255.0;
static const float RRCOLOR_LIGHTPURPLE_BLUE = 175.0/255.0;

#pragma mark - API constants

extern NSString *const API_CALL_ALL_RESTROOMS;
extern NSString *const API_CALL_SEARCH_RESTROOMS;

#pragma mark - Map constants

extern NSString *const COMPLETION_TEXT;
extern NSString *const COMPLETION_GRAPHIC;
extern NSString *const NO_INTERNET_TEXT;
extern NSString *const NO_LOCATION_TEXT;
extern NSString *const NO_NAME_TEXT;
extern NSString *const PIN_GRAPHIC;
extern NSString *const SYNC_TEXT;
extern NSString *const SYNC_ERROR_TEXT;
extern NSString *const URL_TO_TEST_REACHABILITY;

#endif

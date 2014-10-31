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
const NSString *RESTROOM_DETAILS_TRANSITION_NAME = @"ShowRestroomDetails";

#pragma mark - API constants

const NSString *API_CALL_ALL_RESTROOMS = @"http://www.refugerestrooms.org:80/api/v1/restrooms.json";
const NSString *API_CALL_SEARCH_RESTROOMS = @"http://www.refugerestrooms.org:80/api/v1/restrooms/search.json";

#pragma mark - Map constants

const NSString *COMPLETION_TEXT = @"Complete";
const NSString *COMPLETION_GRAPHIC = @"37x-Checkmark@2x.png";
const NSString *NO_INTERNET_TEXT = @"Internet connection unavailable";
const NSString *NO_LOCATION_TEXT = @"Could not find your location";
const NSString *NO_NAME_TEXT = @"Details";
const NSString *PIN_GRAPHIC = @"pin.png";
const NSString *SYNC_TEXT = @"Syncing";
const NSString *SYNC_ERROR_TEXT = @"Sync error";
const NSString *URL_TO_TEST_REACHABILITY = @"www.google.com";
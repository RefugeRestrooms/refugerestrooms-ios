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

const NSString *API_CALL_BY_DATE_RESTROOMS = @"http://www.refugerestrooms.org:80/api/v1/restrooms/by_date.json";
const NSInteger MAX_RESTROOMS_TO_FETCH = 500;

#pragma mark - Map constants

const NSString *COMPLETION_TEXT = @"Complete";
const NSString *COMPLETION_GRAPHIC = @"Images/37x-Checkmark@2x.png";
const NSString *NO_INTERNET_TEXT = @"Internet connection unavailable";
const NSString *NO_LOCATION_TEXT = @"Could not find your location";
const NSString *NO_NAME_TEXT = @"Details";
const NSString *PIN_GRAPHIC = @"Images/pin.png";
const NSString *REUSABLE_ANNOTATION_VIEW_IDENTIFIER = @"RestroomAnnotationView";
const NSString *SYNC_TEXT = @"Syncing";
const NSString *SYNC_ERROR_TEXT = @"Sync error";
const NSString *URL_TO_TEST_REACHABILITY = @"www.google.com";
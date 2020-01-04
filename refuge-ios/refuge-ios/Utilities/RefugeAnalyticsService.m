//
//  RefugeAnalyticsService.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 1/4/20.
//  Copyright © 2020 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefugeAnalyticsService.h"
#import <CoreLocation/CoreLocation.h>
#import "RefugeMapPin.h"
#import "RefugeRestroom.h"

#if DEBUG
static NSString *const kRefugePrefix = @"Test";
#else
static NSString *const kRefugePrefix = @"Refuge";
#endif

// NOTE: Originally Mixpanel was used - however it was extracted when the app was decommissioned.

@implementation RefugeAnalyticsService

#pragma mark - Initialization

static RefugeAnalyticsService *_sharedInstance = nil;

+(RefugeAnalyticsService *)sharedInstance {
    @synchronized([RefugeAnalyticsService class]) {
        if (!_sharedInstance)
          _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

- (instancetype)init
{
    self = [super init];
    return self;
}


#pragma mark - RefugeAnalyticsService

- (void)setup
{
    [self debugLog:@"Setup"];
}

- (void)trackAppLaunch
{
    [self debugLog:[NSString stringWithFormat:@"%@ App Launched", kRefugePrefix]];
}

- (void)trackError:(NSError *)error ofType:(RefugeAnalyticsErrorType)errorType
{
    [self debugLog: [NSString stringWithFormat:@"%@ Error Occurred: %@", kRefugePrefix, [error localizedDescription]]];
}

- (void)trackNewRestroomButtonTouched
{
    [self debugLog:[NSString stringWithFormat:@"%@ New Restroom Button Touched", kRefugePrefix]];
}

- (void)trackOnboardingCompleted
{
    [self debugLog:[NSString stringWithFormat:@"%@ Onboarding Completed", kRefugePrefix]];
}

- (void)trackRestroomDetailsViewed:(RefugeMapPin *)mapPin
{
    NSString *identifier = mapPin.restroom.identifier;
    [self debugLog: [NSString stringWithFormat:@"%@ Restroom Details Viewed ID %@", kRefugePrefix, (identifier == nil) ? @"" : identifier]];
}

- (void)trackSearchWithString:(NSString *)searchString placemark:(CLPlacemark *)placemark
{
    [self debugLog: [NSString stringWithFormat:@"%@ Search Successfully Executed; Info: %@", kRefugePrefix, placemark.addressDictionary]];
}

#pragma mark - Private methods

- (void)debugLog:(NSString *)message
{
    #if DEBUG
        NSLog(@"[Analytics] %@", message);
    #endif
}

- (NSString *)stringForErrorType:(RefugeAnalyticsErrorType)errorType
{
    switch (errorType) {
    case RefugeAnalyticsErrorTypeLocationManagerFailed:
        return @"Location Manager Failed";
        break;
        
    case RefugeAnalyticsErrorTypeFetchingRestroomsFailed:
        return @"Fetching Restrooms From API Failed";
        break;
        
    case RefugeAnalyticsErrorTypeSavingRestroomsFailed:
        return @"Saving Restrooms Failed";
        break;
        
    case RefugeAnalyticsErrorTypeResolvingPlacemarkFailed:
        return @"Resolving Placemark Failed";
        break;
        
    case RefugeAnalyticsErrorTypeSearchAttemptFailed:
        return @"Search Attempt Failed";
        break;
        
    case RefugeAnalyticsErrorTypePreloadingRestrooms:
        return @"Pre-loading Restrooms Failed";
        break;
        
    case RefugeAnalyticsErrorTypeLocalStoreFetchFailed:
        return @"Fetching Restrooms From Local Store Failed";
        break;
        
    case RefugeAnalyticsErrorTypeOpeningLinkFailed:
        return @"Opening Link Failed";
        break;
        
    case RefugeAnalyticsErrorTypeLoadingNewRestroomWebViewFailed:
        return @"Loading New Restroom Web View Failed";
        break;
        
    default:
        return @"Error Type Not Found";
        break;
    }
}

@end

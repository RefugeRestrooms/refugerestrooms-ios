//
//  RefugeAnalyticsService.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 1/4/20.
//  Copyright © 2020 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefugeAnalyticsService.h"
#import <Mixpanel.h>
#import <CoreLocation/CoreLocation.h>
#import "RefugeMapPin.h"
#import "RefugeRestroom.h"

#if DEBUG
static NSString *const kRefugePrefix = @"Test";
#else
static NSString *const kRefugePrefix = @"Refuge";
#endif

@implementation RefugeAnalyticsService

#define REFUGE_MIXPANEL_TOKEN @"5140bc4b6ebcb9fe05feb7bc7bf7ed11"

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
    [Mixpanel sharedInstanceWithToken:REFUGE_MIXPANEL_TOKEN];
}

- (void)trackAppLaunch
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ App Launched", kRefugePrefix]];
}

- (void)trackError:(NSError *)error ofType:(RefugeAnalyticsErrorType)errorType
{
    NSString *errorDomain = [error domain];
    NSString *errorDescription = [error localizedDescription];
    NSError *underlyingError = [[error userInfo] objectForKey:NSUnderlyingErrorKey];
    
    NSString *underlyingErrorDomain = @"";
    NSString *underlyingErrorCode = @"";
    
    if (underlyingError) {
        underlyingErrorDomain = [underlyingError domain];
        underlyingErrorCode = [NSString stringWithFormat:@"%li", (long)[underlyingError code]];
    }
    
    [[Mixpanel sharedInstance]
             track:[NSString stringWithFormat:@"%@ Error Occurred", kRefugePrefix]
        properties:@{
            [NSString stringWithFormat:@"%@ Error Type", kRefugePrefix] : [self stringForErrorType:errorType],
            [NSString stringWithFormat:@"%@ Error Domain", kRefugePrefix] : (errorDomain == nil) ? @"" : errorDomain,
            [NSString stringWithFormat:@"%@ Error Description", kRefugePrefix] : (!errorDescription) ? @""
                                                                                                     : errorDescription,
            [NSString stringWithFormat:@"%@ Underlying Error Domain", kRefugePrefix] : underlyingErrorDomain,
            [NSString stringWithFormat:@"%@ Underlying Error Code", kRefugePrefix] : underlyingErrorCode
        }];
}

- (void)trackNewRestroomButtonTouched
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ New Restroom Button Touched", kRefugePrefix]];
}

- (void)trackOnboardingCompleted
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ Onboarding Completed", kRefugePrefix]];
}

- (void)trackRestroomDetailsViewed:(RefugeMapPin *)mapPin
{
    RefugeRestroom *restroom = mapPin.restroom;
    
    NSString *identifier = restroom.identifier;
    NSString *city = restroom.city;
    NSString *state = restroom.state;
    NSString *country = restroom.country;
    
    [[Mixpanel sharedInstance]
             track:[NSString stringWithFormat:@"%@ Restroom Details Viewed", kRefugePrefix]
        properties:@{
            [NSString stringWithFormat:@"%@ Restroom ID", kRefugePrefix] : (identifier == nil) ? @"" : identifier,
            [NSString stringWithFormat:@"%@ Restroom City", kRefugePrefix] : (city == nil) ? @"" : city,
            [NSString stringWithFormat:@"%@ Restroom State", kRefugePrefix] : (state == nil) ? @"" : state,
            [NSString stringWithFormat:@"%@ Restroom Country", kRefugePrefix] : (country == nil) ? @"" : country
        }];
}

- (void)trackRestroomsPlotted:(NSUInteger)numRestroomsPlotted
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ Restrooms Plotted", kRefugePrefix]
                          properties:@{
                              [NSString stringWithFormat:@"%@ # Restrooms Plotted", kRefugePrefix] :
                                  [NSNumber numberWithInteger:numRestroomsPlotted]
                          }];
}

- (void)trackSearchWithString:(NSString *)searchString placemark:(CLPlacemark *)placemark
{
    NSDictionary *addressInfo = placemark.addressDictionary;
    NSString *searchName = [addressInfo objectForKey:@"Name"];
    NSString *searchCity = [addressInfo objectForKey:@"City"];
    NSString *searchState = [addressInfo objectForKey:@"State"];
    NSString *searchCountry = [addressInfo objectForKey:@"Country"];
    
    [[Mixpanel sharedInstance]
             track:[NSString stringWithFormat:@"%@ Search Successfully Executed", kRefugePrefix]
        properties:@{
            [NSString stringWithFormat:@"%@ Search String", kRefugePrefix] : searchString,
            [NSString stringWithFormat:@"%@ Search Name", kRefugePrefix] : (searchName == nil) ? @"" : searchName,
            [NSString stringWithFormat:@"%@ Search City", kRefugePrefix] : (searchCity == nil) ? @"" : searchCity,
            [NSString stringWithFormat:@"%@ Search State", kRefugePrefix] : (searchState == nil) ? @"" : searchState,
            [NSString stringWithFormat:@"%@ Search Country", kRefugePrefix] : (searchCountry == nil) ? @""
                                                                                                     : searchCountry
        }];
}

#pragma mark - Private methods

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

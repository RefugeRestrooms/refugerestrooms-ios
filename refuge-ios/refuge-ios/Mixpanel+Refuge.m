//
//  Mixpanel+Refuge.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/19/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "Mixpanel+Refuge.h"

#import <CoreLocation/CoreLocation.h>
#import "iRate+Refuge.h"
#import "RefugeMapPin.h"
#import "RefugeRestroom.h"

#if DEBUG
static NSString * const kRefugePrefix = @"Test";
#else
static NSString * const kRefugePrefix = @"Refuge";
#endif

@implementation Mixpanel (Refuge)

#pragma mark - Public methods

- (void)refugeRegisterSuperProperties
{
    if([self hasEverLaunchedApp])
    {
        [[Mixpanel sharedInstance] registerSuperProperties:@{
                                                             [NSString stringWithFormat:@"%@ Date First Launched", kRefugePrefix] : [iRate sharedInstance].firstUsed,
                                                             [NSString stringWithFormat:@"%@ Number of Launches", kRefugePrefix] : [NSNumber numberWithInteger:[iRate sharedInstance].usesCount],
                                                             [NSString stringWithFormat:@"%@ Has Declined to Rate", kRefugePrefix] : ([iRate sharedInstance].declinedAnyVersion) ? @"Yes" : @"No",
                                                             [NSString stringWithFormat:@"%@ Has Rated", kRefugePrefix ] : ([iRate sharedInstance].ratedAnyVersion) ? @"Yes" : @"No"
                                                             }
         ];
    }
}

- (void)refugeTrackAppLaunch
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ App Launched", kRefugePrefix]];
}

- (void)refugeTrackError:(NSError *)error ofType:(RefugeMixpanelErrorType)errorType
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ Error Occurred", kRefugePrefix]
                          properties:@{
                                       [NSString stringWithFormat:@"%@ Error Type", kRefugePrefix] : [self stringForErrorType:errorType],
                                       [NSString stringWithFormat:@"%@ Error Domain", kRefugePrefix] : [error domain],
                                       [NSString stringWithFormat:@"%@ Error Code", kRefugePrefix] : [NSNumber numberWithInteger:[error code]],
                                       [NSString stringWithFormat:@"%@ Error Reason", kRefugePrefix] : [error localizedFailureReason],
                                       [NSString stringWithFormat:@"%@ Error Description", kRefugePrefix] : [error localizedDescription]
                                       }
     ];
}

- (void)refugeTrackNewRestroomButtonTouched
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ New Restroom Button Touched", kRefugePrefix]];
}

- (void)refugeTrackOnboardingCompleted
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ Onboarding Completed", kRefugePrefix]];
}

- (void)refugeTrackRestroomDetailsViewed:(RefugeMapPin *)mapPin
{
    RefugeRestroom *restroom = mapPin.restroom;
    
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ Restroom Details Viewed", kRefugePrefix]
                          properties:@{
                                       [NSString stringWithFormat:@"%@ Restroom ID", kRefugePrefix] : restroom.identifier,
                                       [NSString stringWithFormat:@"%@ Restroom City", kRefugePrefix] : restroom.city,
                                       [NSString stringWithFormat:@"%@ Restroom State", kRefugePrefix] : restroom.state,
                                       [NSString stringWithFormat:@"%@ Restroom Country", kRefugePrefix] : restroom.country
                                       }
     ];
}

- (void)refugeTrackSearchAttempted:(NSString *)searchString
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ Search Attempted", kRefugePrefix]
                          properties:@{
                                       [NSString stringWithFormat:@"%@ Search String", kRefugePrefix] : searchString
                                       }
     ];
}

- (void)refugeTrackSearchSuccessful:(CLPlacemark *)placemark
{
    NSDictionary *addressInfo = placemark.addressDictionary;
    
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ Search Successfully Executed", kRefugePrefix]
                          properties:@{
                                       [NSString stringWithFormat:@"%@ Search Name", kRefugePrefix] : [addressInfo objectForKey:@"Name"],
                                       [NSString stringWithFormat:@"%@ Search City", kRefugePrefix] : [addressInfo objectForKey:@"City"],
                                       [NSString stringWithFormat:@"%@ Search State", kRefugePrefix] : [addressInfo objectForKey:@"State"],
                                       [NSString stringWithFormat:@"%@ Search Country", kRefugePrefix] : [addressInfo objectForKey:@"Country"]
                                       }
     ];
}

#pragma mark - Private methods

- (BOOL)hasEverLaunchedApp
{
    return [iRate sharedInstance].usesCount > 0;
}

- (NSString *)stringForErrorType:(RefugeMixpanelErrorType)errorType
{
    switch (errorType) {
        case RefugeMixpanelErrorTypeLocationManagerFailed:
            return @"Location Manager Failed";
            break;
        case RefugeMixpanelErrorTypeFetchingRestroomsFailed:
            return @"Fetching Restrooms Failed";
            break;
        case RefugeMixpanelErrorTypeSavingRestroomsFailed:
            return @"Saving Restrooms Failed";
            break;
        case RefugeMixpanelErrorTypeResolvingPlacemarkFailed:
            return @"Resolving Placemark Failed";
            break;
        case RefugeMixpanelErrorTypeSearchAttemptFailed:
            return @"Search Attempt Failed";
            break;
        default:
            return @"Error Type Not Found";
            break;
    }
}

@end

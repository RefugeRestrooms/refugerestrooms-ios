//
//  Mixpanel+Refuge.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/19/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "Mixpanel+Refuge.h"

#import "iRate+Refuge.h"
#import "RefugeMapPin.h"
#import "RefugeRestroom.h"

static NSString * const kRefugePrefix = @"Test"; // TODO: Change event name prefix before launch

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

#pragma mark - Private methods

- (BOOL)hasEverLaunchedApp
{
    return [iRate sharedInstance].usesCount > 0;
}

@end

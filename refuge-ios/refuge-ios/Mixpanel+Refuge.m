//
//  Mixpanel+Refuge.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/19/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "Mixpanel+Refuge.h"

#import "iRate+Refuge.h"

@implementation Mixpanel (Refuge)

#pragma mark - Public methods

- (void)refugeTrackAppLaunch
{
    if([self hasEverLaunchedApp])
    {
        [[Mixpanel sharedInstance] track:@"Test-App Launched"
                              properties:@{
                                           @"Date First Launched" : [iRate sharedInstance].firstUsed,
                                           @"Number of Launches" : [NSNumber numberWithInteger:[iRate sharedInstance].usesCount],
                                           @"Had Declined to Rate" : ([iRate sharedInstance].declinedAnyVersion) ? @"Yes" : @"No",
                                           @"Has Rated" : ([iRate sharedInstance].ratedAnyVersion) ? @"Yes" : @"No"
                                           }
         ];
    }

}

#pragma mark - Private methods

- (BOOL)hasEverLaunchedApp
{
    return [iRate sharedInstance].usesCount > 0;
}

@end

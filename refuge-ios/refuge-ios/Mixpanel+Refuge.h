//
//  Mixpanel+Refuge.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/19/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

@class RefugeMapPin;

#import "Mixpanel.h"

@interface Mixpanel (Refuge)

- (void)refugeRegisterSuperProperties;
- (void)refugeTrackAppLaunch;
- (void)refugeTrackNewRestroomButtonTouched;
- (void)refugeTrackOnboardingCompleted;
- (void)refugeTrackRestroomDetailsViewed:(RefugeMapPin *)mapPin;

@end

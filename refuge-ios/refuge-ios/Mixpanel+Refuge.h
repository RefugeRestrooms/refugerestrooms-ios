//
//  Mixpanel+Refuge.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/19/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "Mixpanel.h"

@class CLPlacemark;

typedef NS_ENUM(NSInteger, RefugeMixpanelErrorType)
{
    RefugeMixpanelErrorTypeLocationManagerFailed,
    RefugeMixpanelErrorTypeFetchingRestroomsFailed,
    RefugeMixpanelErrorTypeSavingRestroomsFailed,
    RefugeMixpanelErrorTypeResolvingPlacemarkFailed
};

@class RefugeMapPin;

@interface Mixpanel (Refuge)

- (void)refugeRegisterSuperProperties;
- (void)refugeTrackAppLaunch;
- (void)refugeTrackError:(NSError *)error ofType:(RefugeMixpanelErrorType)errorType;
- (void)refugeTrackNewRestroomButtonTouched;
- (void)refugeTrackOnboardingCompleted;
- (void)refugeTrackRestroomDetailsViewed:(RefugeMapPin *)mapPin;
- (void)refugeTrackSearchExecuted:(CLPlacemark *)placemark;

@end

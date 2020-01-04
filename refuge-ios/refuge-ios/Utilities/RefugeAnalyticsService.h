//
//  RefugeAnalyticsService.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 1/4/20.
//  Copyright © 2020 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLPlacemark;

typedef NS_ENUM(NSInteger, RefugeAnalyticsErrorType) {
    RefugeAnalyticsErrorTypeLocationManagerFailed,
    RefugeAnalyticsErrorTypeFetchingRestroomsFailed,
    RefugeAnalyticsErrorTypeSavingRestroomsFailed,
    RefugeAnalyticsErrorTypeResolvingPlacemarkFailed,
    RefugeAnalyticsErrorTypeSearchAttemptFailed,
    RefugeAnalyticsErrorTypePreloadingRestrooms,
    RefugeAnalyticsErrorTypeLocalStoreFetchFailed,
    RefugeAnalyticsErrorTypeOpeningLinkFailed,
    RefugeAnalyticsErrorTypeLoadingNewRestroomWebViewFailed
};

@class RefugeMapPin;

@interface RefugeAnalyticsService : NSObject

+ (RefugeAnalyticsService *)sharedInstance;
- (void)setup;
- (void)trackAppLaunch;
- (void)trackError:(NSError *)error ofType:(RefugeAnalyticsErrorType)errorType;
- (void)trackNewRestroomButtonTouched;
- (void)trackOnboardingCompleted;
- (void)trackRestroomDetailsViewed:(RefugeMapPin *)mapPin;
- (void)trackRestroomsPlotted:(NSUInteger)numRestroomsPlotted;
- (void)trackSearchWithString:(NSString *)searchString placemark:(CLPlacemark *)placemark;

@end

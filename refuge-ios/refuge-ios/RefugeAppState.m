//
//  RefugeAppState.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeAppState.h"

@interface RefugeAppState ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation RefugeAppState

static NSString * const REFUGE_APP_STATE_DATE_LAST_SYNCED_KEY = @"RefugeAppStateDateLastSyncedKey";
static NSString * const REFUGE_APP_STATE_HAS_VIEWED_ONBOARDING_KEY = @"RefugeAppStateHasViewedOnboardingKey";

# pragma mark - Initializers

- (id)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    
    if(self)
    {
        self.userDefaults = userDefaults;
        
        self.hasViewedOnboarding = [[userDefaults objectForKey:REFUGE_APP_STATE_HAS_VIEWED_ONBOARDING_KEY] boolValue];
        
        NSDate *dateLastSynced = [userDefaults objectForKey:REFUGE_APP_STATE_DATE_LAST_SYNCED_KEY];
        
        if(dateLastSynced == nil)
        {
            dateLastSynced = [NSDate dateWithTimeIntervalSince1970:0];
        }
        
        self.dateLastSynced = dateLastSynced;
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
}

# pragma mark Setters

- (void)setHasViewedOnboarding:(BOOL)hasViewedOnboarding
{
    _hasViewedOnboarding = hasViewedOnboarding;
    
    [self.userDefaults setObject:@(hasViewedOnboarding) forKey:REFUGE_APP_STATE_HAS_VIEWED_ONBOARDING_KEY];
    [self.userDefaults synchronize];
}

- (void)setDateLastSynced:(NSDate *)dateLastSynced
{
    _dateLastSynced = dateLastSynced;
    
    [self.userDefaults setObject:dateLastSynced forKey:REFUGE_APP_STATE_DATE_LAST_SYNCED_KEY];
    [self.userDefaults synchronize];
}

@end

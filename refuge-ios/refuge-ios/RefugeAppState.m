//
//  RefugeAppState.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeAppState.h"

@implementation RefugeAppState

static NSString * const REFUGE_APP_STATE_DATE_LAST_SYNCED_KEY = @"RefugeAppStateDateLastSyncedKey";

# pragma mark - Initializers

+(instancetype)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        // sync date
        NSDate *dateLastSynced = [[NSUserDefaults standardUserDefaults] objectForKey:REFUGE_APP_STATE_DATE_LAST_SYNCED_KEY];
        
        // if never synced before, set date in far past
        if(dateLastSynced == nil)
        {
            dateLastSynced = [NSDate dateWithTimeIntervalSince1970:0];
        }
        
        self.dateLastSynced = dateLastSynced;
    }
    
    return self;
}

# pragma mark Setters

- (void)setDateLastSynced:(NSDate *)dateLastSynced
{
    _dateLastSynced = dateLastSynced;
    
    [[NSUserDefaults standardUserDefaults] setObject:dateLastSynced forKey:REFUGE_APP_STATE_DATE_LAST_SYNCED_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

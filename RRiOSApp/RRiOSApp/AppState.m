//
//  AppState.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 11/6/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "AppState.h"

static NSString *const GAME_STATE_DATE_LAST_SYNCED_KEY = @"GameStateDateLastSynced";

@implementation AppState

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
        NSDate *dateLastSynced = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_DATE_LAST_SYNCED_KEY];
        
        // if never synced before, set date in far past
        if(dateLastSynced == nil)
        {
            dateLastSynced = [NSDate dateWithTimeIntervalSince1970:0];
        }
        
        self.dateLastSynced = dateLastSynced;
    }
    
    return self;
}

- (void)setDateLastSynced:(NSDate *)dateLastSynced
{
    _dateLastSynced = dateLastSynced;
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:dateLastSynced forKey:GAME_STATE_DATE_LAST_SYNCED_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end

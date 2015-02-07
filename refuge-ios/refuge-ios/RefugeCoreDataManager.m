//
//  RefugeCoreDataManager.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeCoreDataManager.h"

#import "RefugeAppDelegate.h"

@implementation RefugeCoreDataManager

# pragma mark - Initializers

+ (id)sharedInstance
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

# pragma mark - Public methods

+ (NSManagedObjectContext *)mainManagedObjectContext
{
    return ((RefugeAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

@end

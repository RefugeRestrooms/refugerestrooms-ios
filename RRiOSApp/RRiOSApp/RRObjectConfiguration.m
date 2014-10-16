//
//  RRObjectConfiguration.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/16/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRObjectConfiguration.h"

#import "RestroomManager.h"
#import "RestroomCommunicator.h"
#import "RestroomBuilder.h"

@implementation RRObjectConfiguration

- (RestroomManager *)restroomManager
{
    RestroomManager *restroomManager = [[RestroomManager alloc] init];
    
    restroomManager.restroomCommunicator = [[RestroomCommunicator alloc] init];
    restroomManager.restroomCommunicator.delegate = restroomManager;
    restroomManager.restroomBuilder = [[RestroomBuilder alloc] init];
    
    return restroomManager;
}

+ (RRObjectConfiguration *)sharedInstance
{
    static RRObjectConfiguration *sharedInstance = nil;
    
    if(!sharedInstance)
    {
        sharedInstance = [[[self class] hiddenAlloc] init];
    }
    
    return sharedInstance;
}

+ (id)hiddenAlloc
{
    return [super alloc];
}

// override alloc in case it's called
+ (id)alloc
{
    NSLog(@"+sharedInstance should be used instead of +alloc");
    
    return nil;
}

// override new in case it's called
+ (id)new
{
    return [self alloc];
}

// override allocWithZone in case it's called
+ (id)allocWithZone:(NSZone *)zone
{
    return [self alloc];
}

// override copyWithZone in case it's called
- (id)copyWithZone:(NSZone *)zone
{
    // - copy inherited from NSObject calls -copyWithZone
    NSLog(@"RRObjectConfiguraton: attempt to -copy may be a bug.");
    
    return self;
}

// override mutableCopyWithZone in case it's called
- (id)mutableCopyWithZone:(NSZone *)zone
{
    // -mutableCopy inherited from NSObject calls -mutableCopyWithZone
    
    return [self copyWithZone:zone];
}

@end

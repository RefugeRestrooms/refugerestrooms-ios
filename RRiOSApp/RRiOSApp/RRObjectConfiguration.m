//
//  RRObjectConfiguration.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/15/14.
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

@end

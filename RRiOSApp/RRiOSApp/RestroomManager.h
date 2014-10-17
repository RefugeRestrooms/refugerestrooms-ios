//
//  RestroomManager.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RestroomManagerDelegate.h"
#import "RestroomCommunicator.h"

#import "RestroomCommunicator.h"
#import "RestroomBuilder.h"

extern NSString *RestroomManagerError;

typedef NS_ENUM(NSInteger, RestroomManagerErrorCode)
{
    RestroomManagerErrorSearchCode
};

@interface RestroomManager : NSObject <RestroomCommunicatorDelegate>

@property (weak, nonatomic) id <RestroomManagerDelegate> delegate;
@property (strong) RestroomCommunicator *restroomCommunicator;
@property (strong) RestroomBuilder *restroomBuilder;

+ (id)sharedInstance;
- (void)fetchRestroomsForQuery:(NSString *)query;
- (void)fetchNewRestrooms;

@end

//
//  RestroomManager.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RestroomCommunicatorDelegate.h"
#import "RestroomManagerDelegate.h"

@class RestroomBuilder;
@class RestroomCommunicator;

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
-(void)fetchRestroomsOfAmount:(NSInteger)numberRestrooms;

@end

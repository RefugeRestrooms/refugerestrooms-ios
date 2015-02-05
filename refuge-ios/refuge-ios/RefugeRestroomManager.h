//
//  RefugeRestroomManager.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RefugeRestroomCommunicatorDelegate.h"
#import "RefugeRestroomManagerDelegate.h"

@class RefugeRestroomBuilder;
@class RefugeRestroomCommunicator;

extern NSString *RefugeRestroomManagerErrorDomain;

typedef NS_ENUM(NSInteger, RefugeRestroomManagerErrorCode)
{
    RefugeRestroomManagerErrorRestroomsBuildCode,
    RefugeRestroomManagerErrorRestroomsFetchCode
};

@interface RefugeRestroomManager : NSObject <RefugeRestroomCommunicatorDelegate>

@property (nonatomic, weak) id<RefugeRestroomManagerDelegate> delegate;
@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;
@property (nonatomic, strong) RefugeRestroomCommunicator *restroomCommunicator;

- (void)fetchRestrooms;

@end

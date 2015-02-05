//
//  RefugeRestroomCommunicator.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RefugeRestroomCommunicatorDelegate.h"

@interface RefugeRestroomCommunicator : NSObject

@property (nonatomic, weak) id<RefugeRestroomCommunicatorDelegate> delegate;

- (void)searchForRestrooms;

@end

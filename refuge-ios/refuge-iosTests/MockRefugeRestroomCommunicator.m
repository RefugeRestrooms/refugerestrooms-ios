//
//  MockRefugeRestroomCommunicator.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "MockRefugeRestroomCommunicator.h"

@implementation MockRefugeRestroomCommunicator

- (void)searchForRestrooms
{
    self.wasAskedToFetchRestrooms = YES;
}

@end

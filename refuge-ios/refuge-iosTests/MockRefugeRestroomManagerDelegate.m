//
//  MockRefugeRestroomManagerDelegate.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "MockRefugeRestroomManagerDelegate.h"

@implementation MockRefugeRestroomManagerDelegate

- (void)didReceiveRestrooms:(NSArray *)restrooms
{
    self.receivedRestrooms = restrooms;
}

- (void)fetchingRestroomsFailedWithError:(NSError *)error
{
    self.fetchError = error;
}

@end

//
//  MockRefugeRestroomManagerDelegate.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "MockRefugeRestroomManagerDelegate.h"

@implementation MockRefugeRestroomManagerDelegate

- (void)didFetchRestrooms
{
    self.wasNotifiedOfFetchedRestrooms = YES;
}

- (void)fetchingRestroomsFromApiFailedWithError:(NSError *)error
{
    self.fetchFromApiError = error;
}

- (void)fetchingRestroomsFromLocalStoreFailedWithError:(NSError *)error
{
    self.fetchFromLocalStoreError = error;
}

- (void)savingRestroomsFailedWithError:(NSError *)error
{
    self.saveError = error;
}

@end

//
//  RefugeRestroomManagerDelegate.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RefugeRestroomManagerDelegate <NSObject>

- (void)didFetchRestrooms;
- (void)fetchingRestroomsFromApiFailedWithError:(NSError *)error;
- (void)fetchingRestroomsFromLocalStoreFailedWithError:(NSError *)error;
- (void)savingRestroomsFailedWithError:(NSError *)error;

@end

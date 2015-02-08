//
//  RefugeRestroomManagerDelegate.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RefugeRestroomManagerDelegate <NSObject>

- (void)didReceiveRestrooms:(NSArray *)restrooms;
- (void)fetchingRestroomsFailedWithError:(NSError *)error;
- (void)savingRestroomsFailedWithError:(NSError *)error;

@end

//
//  RefugeDataPeristenceManagerDelegate.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RefugeDataPeristenceManagerDelegate <NSObject>

- (void)didSaveRestrooms;
- (void)retrievingAllRestroomsFailedWithError:(NSError *)error;
- (void)savingRestroomsFailedWithError:(NSError *)error;

@end

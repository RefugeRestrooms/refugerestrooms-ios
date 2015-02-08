//
//  RefugeDataPersistenceManager.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "RefugeDataPeristenceManagerDelegate.h"

@interface RefugeDataPersistenceManager : NSObject

@property (nonatomic, weak) id<RefugeDataPeristenceManagerDelegate> delegate;

- (void)saveRestrooms:(NSArray *)restrooms;

@end

//
//  MockRefugeDataPersistenceManager.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "MockRefugeDataPersistenceManager.h"

@implementation MockRefugeDataPersistenceManager

- (void)saveRestrooms:(NSArray *)restrooms
{
    self.wasAskedToSaveRestrooms = YES;
}

@end

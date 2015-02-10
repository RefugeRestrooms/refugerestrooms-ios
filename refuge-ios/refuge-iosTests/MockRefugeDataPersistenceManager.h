//
//  MockRefugeDataPersistenceManager.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeDataPersistenceManager.h"

@interface MockRefugeDataPersistenceManager : RefugeDataPersistenceManager

@property (nonatomic, assign) BOOL wasAskedForAllRestrooms;
@property (nonatomic, assign) BOOL wasAskedToSaveRestrooms;

@end

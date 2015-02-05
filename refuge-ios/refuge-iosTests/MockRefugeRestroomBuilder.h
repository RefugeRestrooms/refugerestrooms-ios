//
//  MockRefugeRestroomBuilder.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomBuilder.h"

@interface MockRefugeRestroomBuilder : RefugeRestroomBuilder

@property (nonatomic, copy) id jsonObjects;
@property (nonatomic, copy) NSArray *arrayToReturn;
@property (nonatomic, copy) NSError *errorToSet;

@end

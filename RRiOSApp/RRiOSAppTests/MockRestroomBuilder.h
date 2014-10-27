//
//  MockRestroomBuilder.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomBuilder.h"

@class Question;

@interface MockRestroomBuilder : RestroomBuilder

@property (copy) NSString *JSON;
@property (copy) NSArray *arrayToReturn;
@property (copy) NSError *errorToSet;

@end

//
//  MockRestroomBuilder.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "MockRestroomBuilder.h"

@implementation MockRestroomBuilder

@synthesize errorToSet;

- (NSArray *)restroomsFromJSON:(NSString *)jsonString error:(NSError **)error
{
    _JSON = jsonString;
    
    if (error)
    {
        *error = errorToSet;
    }
    
    return _arrayToReturn;
}

@end

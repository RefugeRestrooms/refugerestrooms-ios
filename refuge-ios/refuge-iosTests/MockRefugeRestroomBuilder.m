//
//  MockRefugeRestroomBuilder.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "MockRefugeRestroomBuilder.h"

@implementation MockRefugeRestroomBuilder

- (NSArray *)buildRestroomsFromJSON:(id)jsonObjects error:(NSError **)error
{
    self.jsonObjects = jsonObjects;
    
    if(error != nil)
    {
        *error = self.errorToSet;
    }
    
    return self.arrayToReturn;
}

@end

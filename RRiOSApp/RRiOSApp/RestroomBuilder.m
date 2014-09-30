//
//  RestroomBuilder.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomBuilder.h"

@implementation RestroomBuilder

- (NSArray *)restroomsFromJSON:(NSString *)objectNoation error:(NSError **)error
{
    NSParameterAssert(objectNoation != nil);
    
    if(error != NULL)
    {
        *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderInvalidJSONError userInfo:NIL];
    }
    
    return nil;
}

@end

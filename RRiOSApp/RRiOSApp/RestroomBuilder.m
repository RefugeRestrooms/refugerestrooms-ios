//
//  RestroomBuilder.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomBuilder.h"

@implementation RestroomBuilder

NSString *RestroomBuilderErrorDomain = @"RestroomBuilderErrorDomain";

- (NSArray *)restroomsFromJSON:(NSString *)objectNotation error:(NSError **)error
{
    NSParameterAssert(objectNotation != nil);
    
    if(error != NULL)
    {
        *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderInvalidJSONError userInfo:nil];
    }
    
    return nil;
}

@end

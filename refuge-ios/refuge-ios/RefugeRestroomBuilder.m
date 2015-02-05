//
//  RefugeRestroomBuilder.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomBuilder.h"

#import "NSDate+Refuge.h"
#import "RefugeRestroom.h"
#import "RefugeSerialization.h"

NSString *RefugeRestroomBuilderErrorDomain = @"RefugeRestroomBuilderErrorDomain";

@implementation RefugeRestroomBuilder

- (NSArray *)buildRestroomsFromJSON:(id)jsonObjects error:(NSError **)error
{
    NSParameterAssert(jsonObjects != nil);
    
    NSError *errorWhileCreatingRestrooms;
    id jsonArray = nil;
    
    if(![jsonObjects isKindOfClass:[NSArray class]])
    {
        jsonArray = @[ jsonObjects ];
    }
    else
    {
        jsonArray = jsonObjects;
    }
    
    if([jsonArray count] == 0)
    {
        return [NSArray array];
    }
    
    NSArray *restrooms = [RefugeSerialization deserializeRestroomsFromJSON:jsonArray error:&errorWhileCreatingRestrooms];
    
    if(restrooms == nil || errorWhileCreatingRestrooms)
    {
        [self setErrorToReturn:error withUnderlyingError:errorWhileCreatingRestrooms];
    }
    
    return restrooms;
}

- (void)setErrorToReturn:(NSError **)error withUnderlyingError:(NSError *)underlyingError
{
    if (error != NULL)
    {
        NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        
        if (underlyingError != nil)
        {
            [errorInfo setObject:underlyingError forKey:NSUnderlyingErrorKey];
        }
        
        *error = [NSError errorWithDomain:RefugeRestroomBuilderErrorDomain code:RefugeRestroomBuilderDeserializationErrorCode userInfo:errorInfo];
    }
}

@end

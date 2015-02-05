//
//  RefugeSerialization.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeSerialization.h"

#import "MTLJSONAdapter.h"
#import "RefugeRestroom.h"

NSString *RefugeSerializationErrorDomain = @"RefugeSerializationErrorDomain";

@implementation RefugeSerialization

# pragma mark - Public methods

+ (NSArray *)deserializeRestroomsFromJSON:(NSArray *)JSON error:(NSError **)error
{
    if (!JSON || ![JSON isKindOfClass:[NSArray class]] || [JSON count] == 0)
    {
        return nil;
    }
    
    NSError *errorWhileDeserializingJSON;
    NSMutableArray *restrooms = [NSMutableArray new];
    
    for (NSDictionary *restroomJSON in JSON)
    {
        RefugeRestroom *restroom = [RefugeSerialization deserializeRestroomFromJSON:restroomJSON error:&errorWhileDeserializingJSON];
        
        if(errorWhileDeserializingJSON)
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            
            [userInfo setObject:errorWhileDeserializingJSON forKey:NSUnderlyingErrorKey];
            
            *error = [NSError errorWithDomain:RefugeSerializationErrorDomain code:RefugeSerializationErrorDeserializationFromJSONCode userInfo:userInfo];
        }
        
        if (restroom)
        {
            [restrooms addObject:restroom];
        }
    }
    
    return [restrooms count] > 0 ? [NSArray arrayWithArray:restrooms] : nil;
}

# pragma mark - Private methods

+ (RefugeRestroom *)deserializeRestroomFromJSON:(NSDictionary *)JSON error:(NSError **)error
{
    NSError *errorWhileDeserializingJSON;
    
    RefugeRestroom *restroom = [MTLJSONAdapter modelOfClass:[RefugeRestroom class] fromJSONDictionary:JSON error:&errorWhileDeserializingJSON];
    
    if (errorWhileDeserializingJSON)
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [userInfo setObject:errorWhileDeserializingJSON forKey:NSUnderlyingErrorKey];
        
        *error = [NSError errorWithDomain:RefugeSerializationErrorDomain code:RefugeSerializationErrorDeserializationFromJSONCode userInfo:userInfo];
    }
    
    return restroom;
}

@end

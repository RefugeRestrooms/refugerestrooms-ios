//
//  RestroomBuilder.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomBuilder.h"
#import "Restroom.h"

static NSString *RestroomBuilderErrorDomain = @"RestroomBuilderErrorDomain";

@implementation RestroomBuilder

- (NSArray *)restroomsFromJSON:(NSString *)jsonString error:(NSError **)error
{
    NSParameterAssert(jsonString != nil);
    
    // create JSON object
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&localError];
    NSArray *restroomDictionaries = nil;
    
    if (jsonObject == nil)
    {
        // handle error
        if(!error)
        {
            // *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
            
            *error = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeInvalidJSONError userInfo:nil];
        }
        
        return nil;
    }
    else if ([jsonObject isKindOfClass:[NSArray class]])
    {
        restroomDictionaries = jsonObject;
    }
    else // jsonObject is not an array
    {
        // make it into an array
        restroomDictionaries = @[ jsonObject ];
    }
    
    // else create Restroom objects out of parsed data
    NSMutableArray *restrooms = [NSMutableArray array];
    
    for(NSDictionary *restroomDictionary in restroomDictionaries)
    {
        // required properties
        // if lat/long is null, setting here with doubleValue throws error - 0.0 default used
        Restroom *restroom = [[Restroom alloc]
                                initWithName:restroomDictionary[@"name"]
                                street:restroomDictionary[@"street"]
                                city:restroomDictionary[@"city"]
                                state:restroomDictionary[@"state"]
                                country:restroomDictionary[@"country"]
                                isAccessible:[restroomDictionary[@"accessible"] boolValue]
                                isUnisex:[restroomDictionary[@"unisex"] boolValue]
                                numDownvotes:[restroomDictionary[@"downvote"] intValue]
                                numUpvotes:[restroomDictionary[@"upvote"] intValue]
                                latitude:0.0
                                longitude:0.0
                                databaseID:[restroomDictionary[@"id"] intValue]
                              ];
        
        id latitude = restroomDictionary[@"latitude"];
        id longitude = restroomDictionary[@"longitude"];
        
        // if error or incomplete
        if(![self isValidRestroom:restroom withLatitude:latitude andLongitude:longitude])
        {
            if(!error)
            {
                //            *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
                
                *error = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeInvalidJSONError userInfo:nil];
            }
        }
        else
        {
            restroom.latitude = [latitude doubleValue];
            restroom.longitude = [longitude doubleValue];
            
            // add optional properties if Restroom was formed
            id directions = restroomDictionary[@"directions"];
            id comment = restroomDictionary[@"comment"];
            
            (directions == nil) ? (restroom.directions = @"") : (restroom.directions = directions);
            (comment == nil) ? (restroom.comment = @"") : (restroom.comment = comment);
            
            [restrooms addObject:restroom];
        }
    }
    
    return [restrooms copy];
}

#pragma mark - Helper methods

// tests if Restroom data has required fields
- (BOOL)isValidRestroom:(Restroom *)restroom withLatitude:(id)latitude andLongitude:(id)longitude
{
    if(restroom == nil ||
       restroom.name == nil ||
       restroom.street == nil ||
       restroom.state == nil ||
       restroom.country == nil ||
       latitude == [NSNull null] ||
       longitude == [NSNull null]
       )
    {
        return NO;
    }
    

    return YES;
}

@end

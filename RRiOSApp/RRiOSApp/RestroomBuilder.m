//
//  RestroomBuilder.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomBuilder.h"
#import "Restroom.h"

NSString *RestroomBuilderErrorDomain = @"RestroomBuilderErrorDomain";

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
//            *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
            
            *error = [NSError errorWithDomain:@"TEST" code:RestroomBuilderInvalidJSONError userInfo:nil];
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
        Restroom *restroom = [[Restroom alloc]
                                initWithName:restroomDictionary[@"name"]
                                Street:restroomDictionary[@"street"]
                                City:restroomDictionary[@"city"]
                                State:restroomDictionary[@"state"]
                                Country:restroomDictionary[@"country"]
                                IsAccessible:[restroomDictionary[@"accessible"] boolValue]
                                IsUnisex:[restroomDictionary[@"unisex"] boolValue]
                                NumDownvotes:[restroomDictionary[@"downvote"] intValue]
                                NumUpvotes:[restroomDictionary[@"upvote"] intValue]
                                DateCreated:restroomDictionary[@"created_at"]
                              ];
        
        
        // if error or incomplete, return
        if(restroom == nil ||
           restroom.name == nil ||
           restroom.street == nil ||
           restroom.state == nil ||
           restroom.country == nil ||
           restroom.dateCreated == nil
           )
        {
            if(!error)
            {
                *error = [NSError errorWithDomain:@"TEST" code:RestroomBuilderMissingDataError userInfo:nil];
            }
            
            return nil;
        }
        
        // if no latitude or longitude, discard
        id latitude = restroomDictionary[@"latitude"];
        id longitude = restroomDictionary[@"longitude"];
        
        if((latitude == [NSNull null]) || (longitude == [NSNull null]))
        {
            if(!error)
            {
                [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
            }
            
            break;
        }
        else
        {
            restroom.latitude = [latitude doubleValue];
            restroom.longitude = [longitude doubleValue];
        }
        
        // add optional properties if Restroom was formed
        id directions = restroomDictionary[@"directions"];
        id comment = restroomDictionary[@"comment"];
        id searchRank = restroomDictionary[@"pg_search_rank"];
        id databaseID = restroomDictionary[@"id"];
        
        (directions == nil) ? (restroom.directions = @"") : (restroom.directions = directions);
        (comment == nil) ? (restroom.comment = @"") : (restroom.comment = comment);
        if(!(searchRank == [NSNull null])) { restroom.searchRank = [searchRank doubleValue]; }
        if(!(databaseID == [NSNull null])) { restroom.databaseID = [databaseID intValue]; }
        
        [restrooms addObject:restroom];
    }
    
    return [restrooms copy];
}

@end

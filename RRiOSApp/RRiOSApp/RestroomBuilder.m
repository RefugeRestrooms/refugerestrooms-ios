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
    NSDictionary *parsedObject = (id)jsonObject;
    
    // if not parsed successfully, error
    if(parsedObject == nil)
    {
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
        }
        
        return nil;
    }
    
    // else create Restroom objects out of parsed data
    NSMutableArray *restrooms = [NSMutableArray array];
    
    for(NSDictionary *restroomDictionary in parsedObject)
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
        
        // if error, return
        if(restroom == nil)
        {
            if(!error)
            {
                *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
            }
            
            return nil;
        }
        
        // add optional properties if Restroom was formed
        id directions = restroomDictionary[@"directions"];
        id comment = restroomDictionary[@"comment"];
        id latitude = restroomDictionary[@"latitude"];
        id longitude = restroomDictionary[@"longitude"];
        id searchRank = restroomDictionary[@"pg_search_rank"];
        id databaseID = restroomDictionary[@"id"];
        
        (directions == nil) ? (restroom.directions = @"") : (restroom.directions = directions);
        (comment == nil) ? (restroom.comment = @"") : (restroom.comment = comment);
        if(!(latitude == [NSNull null])) { restroom.latitude = [latitude doubleValue]; }
        if(!(longitude == [NSNull null])) { restroom.longitude = [longitude doubleValue]; }
        if(!(searchRank == [NSNull null])) { restroom.searchRank = [searchRank doubleValue]; }
        if(!(databaseID == [NSNull null])) { restroom.databaseID = [databaseID intValue]; }
        
        [restrooms addObject:restroom];
    
    }
    
    return [restrooms copy];
}

@end

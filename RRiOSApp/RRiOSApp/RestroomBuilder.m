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
                          initWithName:[restroomDictionary objectForKey:@"name"]
                          andStreet:[restroomDictionary objectForKey:@"street"]
                          andCity:[restroomDictionary objectForKey:@"city"]
                          andState:[restroomDictionary objectForKey:@"state"]
                          andCountry:[restroomDictionary objectForKey:@"country"]
                          andIsAccessible:[[restroomDictionary objectForKey:@"accessible"] boolValue]
                          andIsUnisex:[[restroomDictionary objectForKey:@"unisex"] boolValue]
                          andNumDownvotes:[[restroomDictionary objectForKey:@"downvote"] intValue]
                          andNumUpvotes:[[restroomDictionary objectForKey:@"upvote"] intValue]
                          andDateCreated:[restroomDictionary objectForKey:@"created_at"]
                          andDatabaseID:[[restroomDictionary objectForKey:@"id"] intValue]];
        
        // if error, return
        if(restroom == nil)
        {
            if(error != NULL)
            {
                *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
            }
            
            return nil;
        }
        
        // add optional properties if Restroom was formed
        id directions = [restroomDictionary objectForKey:@"directions"];
        id comment = [restroomDictionary objectForKey:@"comment"];
        id latitude = [restroomDictionary objectForKey:@"latitude"];
        id longitude = [restroomDictionary objectForKey:@"longitude"];
        id searchRank = [restroomDictionary objectForKey:@"pg_search_rank"];
        
        
        if(!(directions == nil)) { restroom.directions = directions; }
        if(!(comment == nil)) { restroom.comment = comment; }
        if(!(latitude == [NSNull null])) { restroom.latitude = [latitude doubleValue]; }
        if(!(longitude == [NSNull null])) { restroom.longitude = [longitude doubleValue]; }
        if(!(searchRank == [NSNull null])) { restroom.searchRank = [searchRank doubleValue];}
        
        [restrooms addObject:restroom];
    
    }
    
    return [restrooms copy];
}

@end

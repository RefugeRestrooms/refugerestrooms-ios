//
//  RestroomBuilder.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomBuilder.h"
#import "Restroom.h"

@implementation RestroomBuilder

NSString *RestroomBuilderErrorDomain = @"RestroomBuilderErrorDomain";

- (NSArray *)restroomsFromJSON:(NSString *)objectNotation error:(NSError **)error
{
    NSParameterAssert(objectNotation != nil);
    
    // create JSON object
    NSData *jsonData = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&localError];
    NSDictionary *parsedObject = (id)jsonObject;
    
    if(parsedObject == nil)
    {
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
        }
        
        return nil;
    }
    
    NSMutableArray *restrooms = [NSMutableArray array];
    
    // create Restroom objects out of parsed data
    for(NSDictionary *restroomDictionary in parsedObject)
    {
        // required properties
        Restroom *restroom = [[Restroom alloc]
                          initWithName:(NSString *)[restroomDictionary objectForKey:@"name"]
                          andStreet:(NSString *)[restroomDictionary objectForKey:@"street"]
                          andCity:(NSString *)[restroomDictionary objectForKey:@"city"]
                          andState:(NSString *)[restroomDictionary objectForKey:@"state"]
                          andCountry:(NSString *)[restroomDictionary objectForKey:@"country"]
                          andIsAccessible:(BOOL)[restroomDictionary objectForKey:@"accessible"]
                          andIsUnisex:(BOOL)[restroomDictionary objectForKey:@"unisex"]
                          andNumDownvotes:(int)[restroomDictionary objectForKey:@"downvote"]
                          andNumUpvotes:(int)[restroomDictionary objectForKey:@"upvote"]
                          andDateCreated:(NSString *)[restroomDictionary objectForKey:@"created_at"]
                          andDatabaseID:(int)[restroomDictionary objectForKey:@"id"]];
    
        // optional properties
        
        
        if(!([restroomDictionary objectForKey:@"directions"] == nil))
        {
            restroom.directions = [restroomDictionary objectForKey:@"directions"];
        }
//    restroom.comment = ;
//    restroom.latitude = ;
//    restroom.longitude = ;
//    restroom.searchRank = ;
    
        // if error, return
        if(restroom == nil)
        {
            if(error != NULL)
            {
                *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
            }
            
            return nil;
        }
        
        [restrooms addObject:restroom];
    
    }
    
    return restrooms;
}

@end

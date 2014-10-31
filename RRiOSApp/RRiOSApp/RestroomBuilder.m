//
//  RestroomBuilder.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "RestroomBuilder.h"
#import "Restroom.h"

static NSString *RestroomBuilderErrorDomain = @"RestroomBuilderErrorDomain";

@implementation RestroomBuilder
{
    NSManagedObjectContext *context;
    
    int numInvalidLat;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        numInvalidLat = 0;
    }
        
    return self;
}

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
//        Restroom *restroom = [[Restroom alloc]
//                                initWithName:restroomDictionary[@"name"]
//                                street:restroomDictionary[@"street"]
//                                city:restroomDictionary[@"city"]
//                                state:restroomDictionary[@"state"]
//                                country:restroomDictionary[@"country"]
//                                isAccessible:[restroomDictionary[@"accessible"] boolValue]
//                                isUnisex:[restroomDictionary[@"unisex"] boolValue]
//                                numDownvotes:[restroomDictionary[@"downvote"] intValue]
//                                numUpvotes:[restroomDictionary[@"upvote"] intValue]
//                                latitude:0.0
//                                longitude:0.0
//                                identifier:restroomDictionary[@"id"]
//                              ];
        
//        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        Restroom *restroom = [NSEntityDescription insertNewObjectForEntityForName:@"Restroom" inManagedObjectContext:context];
        [self setRestroomProperties:restroom fromDictionary:restroomDictionary];
        
        // lat/lon and id must be tested for validity before assigning
        id latitude = restroomDictionary[@"latitude"];
        id longitude = restroomDictionary[@"longitude"];
        id identifier = restroomDictionary[@"id"];
        
        // if error or incomplete
        if(![self isValidRestroom:restroom withIdentifier:identifier latitude:latitude longitude:longitude])
        {
            if(error)
            {
                //            *error = [NSError errorWithDomain:RestroomBuilderErrorDomain code:RestroomBuilderMissingDataError userInfo:nil];
                
                *error = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeInvalidJSONError userInfo:nil];
            }
        }
        else
        {
            restroom.latitude = latitude;
            restroom.longitude = longitude;
            restroom.identifier = [identifier stringValue];
            
            // add optional properties if Restroom was formed
            id directions = restroomDictionary[@"directions"];
            id comment = restroomDictionary[@"comment"];
            
            (directions == [NSNull null]) ? (restroom.directions  = @"") : (restroom.directions = directions);
            (comment == [NSNull null]) ? (restroom.comment = @"") : (restroom.comment = comment);
            
            NSError *saveError = nil;
            
            [context save:&saveError];
            
            if(saveError)
            {
                saveError = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeSaveError userInfo:nil];
            }
            else
            {
                [restrooms addObject:restroom];
            }
        }
    }
    
    NSLog(@"Num Invalid Lat: %i", numInvalidLat);
    
    return [restrooms copy];
}

#pragma mark - Helper methods

- (void)setRestroomProperties:(Restroom *)restroom fromDictionary:(NSDictionary *)dictionary
{
    id name = dictionary[@"name"];
    id street = dictionary[@"street"];
    id city = dictionary[@"city"];
    id state = dictionary[@"state"];
    id country = dictionary[@"country"];
    id isAccessible = dictionary[@"accessible"];
    id isUnisex = dictionary[@"unisex"];
    id numDownVotes = dictionary[@"downvote"];
    id numUpvotes = dictionary[@"upvote"];
    
    // values should not end up as null
    (name == [NSNull null]) ? (restroom.name = @"No Name") : (restroom.name = name);
    (street == [NSNull null]) ? (restroom.street = @"") : (restroom.street = street);
    (city == [NSNull null]) ? (restroom.city = @"") : (restroom.city = city);
    (state == [NSNull null]) ? (restroom.state = @"") : (restroom.state = state);
    (country == [NSNull null]) ? (restroom.country = @"") : (restroom.country = country);
    (isAccessible == [NSNull null]) ? (restroom.isAccessible = NO) : (restroom.isAccessible = isAccessible);
    (isUnisex == [NSNull null]) ? (restroom.isUnisex  = NO) : (restroom.isUnisex = isUnisex);
    (numDownVotes == [NSNull null]) ? (restroom.numDownvotes  = 0) : (restroom.numDownvotes = numDownVotes);
    (numUpvotes == [NSNull null]) ? (restroom.numUpvotes  = 0) : (restroom.numUpvotes = numUpvotes);
}

// tests if Restroom data has required fields
- (BOOL)isValidRestroom:(Restroom *)restroom withIdentifier:(id)identifier latitude:(id)latitude longitude:(id)longitude
{
    // no lat/lon  or ID is invalid
    
    if(
        latitude == [NSNull null] ||
        longitude == [NSNull null] ||
        identifier == [NSNull null]
       )
    {
        if(latitude == [NSNull null])
        {
            numInvalidLat++;
            
            NSLog(@"Invalid Restroom: %@", restroom);
        }
        
        return NO;
    }
    

    return YES;
}

@end


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
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
        
    return self;
}

- (void)buildRestroomsFromJSON:(NSString *)jsonString error:(NSError **)error
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
            
            *error = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeInvalidJSONError userInfo:nil];
        }
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
    NSError *syncError = nil;
    
    [self syncRestrooms:restroomDictionaries error:&syncError];
    
    if(syncError)
    {
        *error = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeSyncError userInfo:nil];
    }
}

#pragma mark - Helper methods

- (void)syncRestrooms:(NSArray *)restroomDictionaries error:(NSError **)error
{
    for(NSDictionary *restroomDictionary in restroomDictionaries)
    {
        // lat/lon and id must be tested for validity before assigning
        id latitude = restroomDictionary[@"latitude"];
        id longitude = restroomDictionary[@"longitude"];
        id identifier = restroomDictionary[@"id"];
        
        if([self isValidIdentifier:identifier latitude:latitude longitude:longitude])
        {
            NSString *identifierString = [identifier stringValue];
            
            // see if Restroom exists in Core Data based on identifier
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME_RESTROOM];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifierString];
            [fetchRequest setPredicate:predicate];
            [fetchRequest setFetchLimit:1];
            
            NSError *coreDataFetchError = nil;
            NSUInteger count = [context countForFetchRequest:fetchRequest error:&coreDataFetchError];
            
            if (count == NSNotFound || coreDataFetchError)
            {
                *error = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeCoreDataSaveError userInfo:nil];
            }
            else if (count == 0) // no matching object already in Core Data
            {
                // Insert new Restroom
                Restroom *restroom = [NSEntityDescription insertNewObjectForEntityForName:@"Restroom" inManagedObjectContext:context];
                
                // fill out restroom properties
                [self setRestroomProperties:restroom fromDictionary:restroomDictionary];
                
                restroom.latitude = latitude;
                restroom.longitude = longitude;
                restroom.identifier = identifierString;
                
                // add optional properties if Restroom was formed
                id directions = restroomDictionary[@"directions"];
                id comment = restroomDictionary[@"comment"];
                
                (directions == [NSNull null]) ? (restroom.directions  = @"") : (restroom.directions = directions);
                (comment == [NSNull null]) ? (restroom.comment = @"") : (restroom.comment = comment);
                
                NSError *coreDataSaveError = nil;
                [context save:&coreDataSaveError];
                
                if(coreDataSaveError)
                {
                    *error = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeCoreDataSaveError userInfo:nil];
                }
            }
            else // Restroom already exists in Core Data
            {
                NSError *coreDataUpdateError = nil;
                NSArray *restroomsForIdentifier = [context executeFetchRequest:fetchRequest error:&coreDataUpdateError];
                
                if(restroomsForIdentifier == nil || coreDataUpdateError)
                {
                    *error = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeCoreDataFetchError userInfo:nil];
                }
                else
                {
                    Restroom *restroomToUpdate = restroomsForIdentifier[0];
                    
                    [self setRestroomProperties:restroomToUpdate fromDictionary:restroomDictionary];
                    restroomToUpdate.latitude = latitude;
                    restroomToUpdate.longitude = longitude;
                    restroomToUpdate.identifier = identifierString;
                    
                    NSError *coreDataSaveError = nil;
                    [context save:&coreDataSaveError];
                    
                    if(coreDataSaveError)
                    {
                        *error = [NSError errorWithDomain:@"RestroomBuilderErrorDomain" code:RestroomBuilderErrorCodeCoreDataSaveError userInfo:nil];
                    }
                }
            }
        }
    }
    
//    return restrooms;
}

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
    (name == [NSNull null]) ? (restroom.name = NO_NAME_TEXT) : (restroom.name = name);
    (street == [NSNull null]) ? (restroom.street = @"") : (restroom.street = street);
    (city == [NSNull null]) ? (restroom.city = @"") : (restroom.city = city);
    (state == [NSNull null]) ? (restroom.state = @"") : (restroom.state = state);
    (country == [NSNull null]) ? (restroom.country = @"") : (restroom.country = country);
    (isAccessible == [NSNull null]) ? (restroom.isAccessible = @(NO)) : (restroom.isAccessible = isAccessible);
    (isUnisex == [NSNull null]) ? (restroom.isUnisex = @(NO)) : (restroom.isUnisex = isUnisex);
    (numDownVotes == [NSNull null]) ? (restroom.numDownvotes  = 0) : (restroom.numDownvotes = numDownVotes);
    (numUpvotes == [NSNull null]) ? (restroom.numUpvotes  = 0) : (restroom.numUpvotes = numUpvotes);
}

// tests if Restroom data has required fields
- (BOOL)isValidIdentifier:(id)identifier latitude:(id)latitude longitude:(id)longitude
{
    // no lat/lon  or ID is invalid
    if(
        latitude == [NSNull null] ||
        longitude == [NSNull null] ||
        identifier == [NSNull null]
       )
    {
        return NO;
    }
    

    return YES;
}

@end

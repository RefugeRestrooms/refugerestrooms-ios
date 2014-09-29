//
//  Restroom.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/26/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restroom : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *street;
@property (readonly) NSString *city;
@property (readonly) NSString *state;
@property (readonly) NSString *country;
@property (readonly) BOOL isAccessible;
@property (readonly) BOOL isUnisex;
@property (readonly) NSString *directions;
@property (readonly) NSString *comment;
@property (readonly) int numDownvotes;
@property (readonly) int numUpvotes;
@property (readonly) NSDate *dateCreated;
@property (readonly) NSDate *dateUpdated;
@property (readonly) NSString *databaseID;

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) double searchRank;

- (id)initWithName:(NSString *)name
         andStreet:(NSString *)street
           andCity:(NSString *)city
          andState:(NSString *)state
        andCountry:(NSString *)country
   andIsAccessible:(BOOL)isAccessible
       andIsUnisex:(BOOL)isUnisex
     andDirections:(NSString *)directions
       andComments:(NSString *)comment
   andNumDownvotes:(int)numDownvotes
     andNumUpvotes:(int)numUpvotes
    andDateCreated:(NSDate *)dateCreated
    andDateUpdated:(NSDate *)dateUpdated
     andDatabaseID:(NSString *)databaseID
;

@end

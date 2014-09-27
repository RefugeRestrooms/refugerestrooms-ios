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
@property (readonly) NSString *isAccessible;
@property (readonly) NSString *isUnisex;
@property (readonly) NSString *directions;
@property (readonly) NSString *comment;
@property (readonly) NSString *latitude;
@property (readonly) NSString *longitude;
@property (readonly) NSString *numDownvotes;
@property (readonly) NSString *numUpvotes;
@property (readonly) NSString *dateCreated;
@property (readonly) NSString *dateUpdated;
@property (readonly) NSString *databaseID;

- (id)initWithName:(NSString *)name
         andStreet:(NSString *)street
           andCity:(NSString *)city
          andState:(NSString *)state
        andCountry:(NSString *)country
andFlagForAccessibility:(NSString *)isAccessible
  andFlagForUnisex:(NSString *)isUnisex
     andDirections:(NSString *)directions
       andComments:(NSString *)comment
       andLatitude:(NSString *)latitude
      andLongitude:(NSString *)longitude
   andNumDownvotes:(NSString *)numDownvotes
     andNumUpvotes:(NSString *)numUpvotes
    andDateCreated:(NSString *)dateCreated
    andDateUpdated:(NSString *)dateUpdated
     andDatabaseID:(NSString *)databaseID
;

@end

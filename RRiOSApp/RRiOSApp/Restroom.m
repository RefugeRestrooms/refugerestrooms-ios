//
//  Restroom.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/26/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "Restroom.h"

@implementation Restroom

-(id) initWithName:(NSString *)name andStreet:(NSString *)street andCity:(NSString *)city andState:(NSString *)state andCountry:(NSString *)country andIsAccessible:(BOOL)isAccessible andIsUnisex:(BOOL)isUnisex andDirections:(NSString *)directions andComments:(NSString *)comment andNumDownvotes:(int)numDownvotes andNumUpvotes:(int)numUpvotes andDateCreated:(NSDate *)dateCreated andDateUpdated:(NSDate *)dateUpdated andDatabaseID:(NSString *)databaseID
{
    self = [super init];
    
    _name = name;
    _street = street;
    _city = city;
    _state = state;
    _country = country;
    _isAccessible = isAccessible;
    _isUnisex = isUnisex;
    _directions = directions;
    _comment = comment;
    _numDownvotes = numDownvotes;
    _numUpvotes = numUpvotes;
    _dateCreated = dateCreated;
    _dateUpdated = dateUpdated;
    _databaseID = databaseID;
    
    return self;
}

@end

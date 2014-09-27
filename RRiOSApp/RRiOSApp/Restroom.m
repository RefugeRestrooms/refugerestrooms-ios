//
//  Restroom.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/26/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "Restroom.h"

@implementation Restroom

-(id) initWithName:(NSString *)name andStreet:(NSString *)street andCity:(NSString *)city andState:(NSString *)state andCountry:(NSString *)country andFlagForAccessibility:(NSString *)isAccessible andFlagForUnisex:(NSString *)isUnisex andDirections:(NSString *)directions andComments:(NSString *)comment andLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andNumDownvotes:(NSString *)numDownvotes andNumUpvotes:(NSString *)numUpvotes andDateCreated:(NSString *)dateCreated andDateUpdated:(NSString *)dateUpdated andDatabaseID:(NSString *)databaseID
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
    _latitude = latitude;
    _longitude = longitude;
    _numDownvotes = numDownvotes;
    _numUpvotes = numUpvotes;
    _dateCreated = dateCreated;
    _dateUpdated = dateUpdated;
    _databaseID = databaseID;
    
    return self;
}

@end

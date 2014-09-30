//
//  Restroom.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/26/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "Restroom.h"

@implementation Restroom

-(id) initWithName:(NSString *)name andStreet:(NSString *)street andCity:(NSString *)city andState:(NSString *)state andCountry:(NSString *)country andIsAccessible:(BOOL)isAccessible andIsUnisex:(BOOL)isUnisex andNumDownvotes:(int)numDownvotes andNumUpvotes:(int)numUpvotes andDateCreated:(NSString *)dateCreated andDatabaseID:(int)databaseID
{
    self = [super init];
    
    _name = name;
    _street = street;
    _city = city;
    _state = state;
    _country = country;
    _isAccessible = isAccessible;
    _isUnisex = isUnisex;
    _numDownvotes = numDownvotes;
    _numUpvotes = numUpvotes;
    _dateCreated = dateCreated;
    _databaseID = databaseID;
    
    return self;
}

@end

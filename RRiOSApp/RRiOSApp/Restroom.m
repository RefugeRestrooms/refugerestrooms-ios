//
//  Restroom.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/26/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "Restroom.h"

@implementation Restroom


// Designated Initializer
-(id) initWithName:(NSString *)name andStreet:(NSString *)street andCity:(NSString *)city andState:(NSString *)state andCountry:(NSString *)country andIsAccessible:(BOOL)isAccessible andIsUnisex:(BOOL)isUnisex andNumDownvotes:(int)numDownvotes andNumUpvotes:(int)numUpvotes andDateCreated:(NSString *)dateCreated
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
    
    return self;
}

// Overriden inherited Designated Initializer
- (id)init
{
    // NOTE: this example was taken from the default address on the Refuge website 10-3-2014
    static NSString *defaultName = @"Ferry Bldg";
    static NSString *defaultStreet = @"1 Embarcadero";
    static NSString *defaultCity = @"San Francisco";
    static NSString *defaultState = @"CA";
    static NSString *defaultCountry = @"US";
    static BOOL defaultAccessibilityFlag = FALSE;
    static BOOL defaultUnisexFlag = FALSE;
    static int defaultNumDownvotes = 0;
    static int defaultNumUpvotes = 0;
    static NSString *defaultDateCreated = @"Todays Date";    // TODO: change this when date created is a Date object!
    
    return [self initWithName:defaultName
                    andStreet:defaultStreet
                      andCity:defaultCity
                     andState:defaultState
                   andCountry:defaultCountry
              andIsAccessible:defaultAccessibilityFlag
                  andIsUnisex:defaultUnisexFlag
              andNumDownvotes:defaultNumDownvotes
                andNumUpvotes:defaultNumUpvotes
               andDateCreated:defaultDateCreated];
}

@end

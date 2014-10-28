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
-(id)initWithName:(NSString *)name street:(NSString *)street city:(NSString *)city state:(NSString *)state country:(NSString *)country isAccessible:(BOOL)isAccessible isUnisex:(BOOL)isUnisex numDownvotes:(NSInteger)numDownvotes numUpvotes:(NSInteger)numUpvotes latitude:(double)latitude longitude:(double)longitude identifier:(NSNumber *)identifier
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
    _latitude = latitude;
    _longitude = longitude;
    _identifier = identifier;
    
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
    static BOOL defaultAccessibilityFlag = NO;
    static BOOL defaultUnisexFlag = NO;
    static NSInteger defaultNumDownvotes = 0;
    static NSInteger defaultNumUpvotes = 0;
    static double defaultLatitude = 37.7944167;
    static double defaultLongitude = -122.3996389;
    NSNumber *defaultIdentifier = [NSNumber numberWithInt:847];
    
    return [self initWithName:defaultName
                       street:defaultStreet
                         city:defaultCity
                        state:defaultState
                      country:defaultCountry
                 isAccessible:defaultAccessibilityFlag
                     isUnisex:defaultUnisexFlag
                 numDownvotes:defaultNumDownvotes
                   numUpvotes:defaultNumUpvotes
                    latitude:defaultLatitude
                    longitude:defaultLongitude
                   identifier:defaultIdentifier
            ];
}

@end

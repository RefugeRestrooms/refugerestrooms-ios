//
//  RRMapLocation.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <AddressBook/AddressBook.h>

#import "Constants.h"
#import "REstroom.h"
#import "RRMapKitAnnotation.h"

@interface RRMapKitAnnotation ()

@end

@implementation RRMapKitAnnotation

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init]))
    {
        if ([name isKindOfClass:[NSString class]])
        {
            _title = name;
        }
        else
        {
            _title = NO_NAME_TEXT;
        }
        
        _subtitle = address;
        _coordinate = coordinate;
    }
    
    return self;
}

@end
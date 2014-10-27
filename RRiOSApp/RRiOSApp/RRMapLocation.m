//
//  RRMapLocation.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRMapLocation.h"

#import <AddressBook/AddressBook.h>

@interface RRMapLocation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation RRMapLocation

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init]))
    {
        if ([name isKindOfClass:[NSString class]])
        {
            self.name = name;
        }
        else
        {
            self.name = @"Unknown charge";
        }
        
        self.address = address;
        self.coordinate = coordinate;
    }
    return self;
}

- (MKMapItem *)mapItem
{
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
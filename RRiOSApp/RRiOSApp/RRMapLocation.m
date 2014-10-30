//
//  RRMapLocation.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "Constants.h"
#import "MKPointAnnotation+RR.h"
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
            self.name = NO_NAME_TEXT;
        }
        
        self.address = address;
        self.coordinate = coordinate;
    }
    
    return self;
}

- (MKPointAnnotation *)annotation
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    annotation.coordinate = self.coordinate;
    annotation.title = NSLocalizedString(self.name, @"Name");
    annotation.subtitle = NSLocalizedString(self.address, @"Address");
    annotation.restroom = self.restroom;
    
    return annotation;
}

@end
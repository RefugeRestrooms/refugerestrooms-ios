//
//  RefugeMapKitAnnotation.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/9/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMapKitAnnotation.h"

static NSString * const kNoName = @"No Name";

@implementation RefugeMapKitAnnotation

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    
    if (self)
    {
        if ([name isKindOfClass:[NSString class]])
        {
            _title = name;
        }
        else
        {
            _title = kNoName;
        }
        
        _subtitle = address;
        _coordinate = coordinate;
    }
    
    return self;
}

- (id)init
{
    NSAssert(false, @"Use initWitName:address:coordinate: to initialize this class.");
    
    return nil;
}

@end

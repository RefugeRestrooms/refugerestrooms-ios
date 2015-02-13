//
//  MockRefugeMapDelegate.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "MockRefugeMapDelegate.h"

@implementation MockRefugeMapDelegate

- (void)tappingCalloutAccessoryDidRetrievedSingleMapPin:(RefugeMapPin *)mapPin
{
    self.wasNotifiedOfCalloutBeingTapped = YES;
}

- (void)retrievingSingleMapPinFromCalloutAccessoryFailed:(RefugeMapPin *)firstPinRetrieved
{
    
}

@end

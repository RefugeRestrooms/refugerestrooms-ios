//
//  RRMapLocation.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
#import "Restroom.h"
#import "RRPointAnnotation.h"

@interface RRMapLocation : NSObject <MKAnnotation>

@property (retain, nonatomic) Restroom *restroom;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (RRPointAnnotation *)annotation;

@end

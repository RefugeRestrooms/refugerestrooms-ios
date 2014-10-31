//
//  RRMapLocation.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@class Restroom;

@interface RRMapKitAnnotation : NSObject <MKAnnotation>

// custom properties
@property (nonatomic, strong)  Restroom *restroom;

// MKAnnotation properties
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end

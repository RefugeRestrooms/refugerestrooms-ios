//
//  MKPointAnnotation+RR.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/30/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <MapKit/MapKit.h>
//#import "Restroom.h"

@class Restroom;

@interface MKPointAnnotation (RR)

@property Restroom *restroom;

@end

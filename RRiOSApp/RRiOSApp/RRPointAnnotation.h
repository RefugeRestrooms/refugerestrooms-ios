//
//  RRPointAnnotation.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "Restroom.h"

@interface RRPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) Restroom *restroom;

@end

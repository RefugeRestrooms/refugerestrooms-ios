//
//  RefugeMap.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <ADClusterMapView/ADClusterMapView.h>
#import "RefugeMapDelegate.h"

@interface RefugeMap : ADClusterMapView

@property (nonatomic, weak) id<RefugeMapDelegate> mapDelegate;

@end

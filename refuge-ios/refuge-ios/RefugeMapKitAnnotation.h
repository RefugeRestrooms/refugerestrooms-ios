//
//  RefugeMapKitAnnotation.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/9/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <MapKit/MapKit.h>

@class RefugeRestroom;

@interface RefugeMapKitAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) RefugeRestroom *restroom;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end

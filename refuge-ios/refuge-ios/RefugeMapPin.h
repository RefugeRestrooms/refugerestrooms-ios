//
//  RefugeMapKitAnnotation.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/9/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <MapKit/MapKit.h>

@class RefugeRestroom;

@interface RefugeMapPin : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, copy, readonly) RefugeRestroom *restroom;

- (id)initWithRestroom:(RefugeRestroom *)restroom;

@end

//
//  RefugeMapPlace.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/10/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface RefugeMapPlace : NSObject

typedef NS_ENUM(NSInteger, RefugeMapPlaceType)
{
    RefugeMapPlaceTypeGeocode,
    RefugeMapPlaceTypeEstablishment
};

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) RefugeMapPlaceType type;
@property (nonatomic, strong) NSString *key;

- (void)toPlacemarkWithSuccessBlock:(void (^)(CLPlacemark *placemark))placemarkSuccess
                            failure:(void (^)(NSError *error))placemarkError;

@end

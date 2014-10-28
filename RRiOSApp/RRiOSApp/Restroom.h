//
//  Restroom.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/28/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Restroom : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * numUpvotes;
@property (nonatomic, retain) NSNumber * numDownvotes;
@property (nonatomic, retain) NSNumber * isUnisex;
@property (nonatomic, retain) NSNumber * isAccessible;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * directions;
@property (nonatomic, retain) NSString * comment;

@end

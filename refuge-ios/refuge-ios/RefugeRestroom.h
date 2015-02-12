//
//  RefugeRestroom.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MTLModel.h>
#import <MTLJSONAdapter.h>
#import <MTLManagedObjectAdapter.h>

@interface RefugeRestroom : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, assign) BOOL isAccessible;
@property (nonatomic, assign) BOOL isUnisex;
@property (nonatomic, assign) NSNumber *numUpvotes;
@property (nonatomic, assign) NSNumber *numDownvotes;
@property (nonatomic, strong) NSString *directions;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSDecimalNumber *latitude;
@property (nonatomic, strong) NSDecimalNumber *longitude;
@property (nonatomic, strong) NSDate *createdDate;

@end

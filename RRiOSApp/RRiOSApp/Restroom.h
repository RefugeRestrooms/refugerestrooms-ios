//
//  Restroom.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/26/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restroom : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *street;
@property (readonly) NSString *city;
@property (readonly) NSString *state;
@property (readonly) NSString *country;
@property (readonly) BOOL isAccessible;
@property (readonly) BOOL isUnisex;
@property (readonly) NSInteger numDownvotes;
@property (readonly) NSInteger numUpvotes;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) NSNumber *identifier;

@property (assign, nonatomic) NSString *directions;
@property (assign, nonatomic) NSString *comment;

- (id)initWithName:(NSString *)name
            street:(NSString *)street
              city:(NSString *)city
             state:(NSString *)state
           country:(NSString *)country
      isAccessible:(BOOL)isAccessible
          isUnisex:(BOOL)isUnisex
      numDownvotes:(NSInteger)numDownvotes
        numUpvotes:(NSInteger)numUpvotes
         latitude:(double)latitude
         longitude:(double)longitude
        identifier:(NSNumber *)identifier
;

@end

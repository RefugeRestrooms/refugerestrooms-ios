//
//  MockRefugeRestroomManagerDelegate.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RefugeRestroomManagerDelegate.h"

@interface MockRefugeRestroomManagerDelegate : NSObject <RefugeRestroomManagerDelegate>

@property (nonatomic, strong) NSArray *receivedRestrooms;
@property (nonatomic, strong) NSError *fetchError;
@property (nonatomic, strong) NSError *saveError;

@end

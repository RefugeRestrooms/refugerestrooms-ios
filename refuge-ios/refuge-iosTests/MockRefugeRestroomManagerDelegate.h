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

@property (nonatomic, assign) BOOL wasNotifiedOfFetchedRestrooms;
@property (nonatomic, strong) NSError *fetchFromApiError;
@property (nonatomic, strong) NSError *fetchFromLocalStoreError;
@property (nonatomic, strong) NSError *saveError;

@end

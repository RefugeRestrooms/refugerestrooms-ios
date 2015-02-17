//
//  MockRefugeMapDelegate.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RefugeMapDelegate.h"

@interface MockRefugeMapDelegate : NSObject <RefugeMapDelegate>

@property (nonatomic, assign) BOOL wasNotifiedOfCalloutBeingTapped;

@end

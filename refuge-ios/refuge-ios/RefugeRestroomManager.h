//
//  RefugeRestroomManager.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RefugeRestroomManagerDelegate.h"

@class RefugeRestroomBuilder;

@interface RefugeRestroomManager : NSObject

@property (nonatomic, weak) id<RefugeRestroomManagerDelegate> delegate;
@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;

@end

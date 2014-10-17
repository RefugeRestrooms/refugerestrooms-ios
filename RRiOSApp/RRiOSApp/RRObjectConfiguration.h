//
//  RRObjectConfiguration.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/16/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RestroomManager.h"

@interface RRObjectConfiguration : NSObject

//+ (id)sharedInstance;
- (RestroomManager *)restroomManager;

@end

//
//  RRObjectConfiguration.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/16/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma message "Prefer @class over #import"
#import "RestroomManager.h"

#pragma message "What does this class do? When abstracting in OOP you end up with pretty abstract names, which is fine, however you should have a comment in the header that explains why this class exists and what its responsibilites are"

@interface RRObjectConfiguration : NSObject

//+ (id)sharedInstance;
- (RestroomManager *)restroomManager;

@end

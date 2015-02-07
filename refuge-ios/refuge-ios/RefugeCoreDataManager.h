//
//  RefugeCoreDataManager.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface RefugeCoreDataManager : NSObject

+ (instancetype)sharedInstance;
- (void)saveRestroomsToCoreData:(NSArray *)restrooms error:(NSError *)error;

@end

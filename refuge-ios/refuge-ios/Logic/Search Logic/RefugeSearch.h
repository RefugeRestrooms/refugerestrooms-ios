//
//  RefugeMapSearchQuery.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/10/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefugeSearch : NSObject

- (void)searchForPlaces:(NSString *)searchString
                success:(void (^)(NSArray *places))searchSuccess
                failure:(void (^)(NSError *error))searchError;

@end

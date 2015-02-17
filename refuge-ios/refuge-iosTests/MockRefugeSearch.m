//
//  MockRefugeSearch.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "MockRefugeSearch.h"

@implementation MockRefugeSearch

- (void)searchForPlaces:(NSString *)searchString success:(void (^)(NSArray *))searchSuccess failure:(void (^)(NSError *))searchError
{
    if(self.errorToSet)
    {
        searchError(self.errorToSet);
    }
    
    if(self.arrayToReturn)
    {
        searchSuccess(self.arrayToReturn);
    }
}

@end

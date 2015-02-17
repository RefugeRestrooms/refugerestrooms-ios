//
//  MockRefugeSearch.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeSearch.h"

@interface MockRefugeSearch : RefugeSearch

@ property (nonatomic, strong) NSArray *arrayToReturn;
@property (nonatomic, strong) NSError *errorToSet;

@end

//
//  MockRefugeRestroomCommunicator.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomCommunicator.h"

@interface MockRefugeRestroomCommunicator : RefugeRestroomCommunicator

@property (nonatomic, assign) BOOL wasAskedToFetchRestrooms;

@end

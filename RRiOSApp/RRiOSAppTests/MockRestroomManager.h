//
//  MockRestroomManager.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/1/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomManager.h"

@class Topic;
@class Question;

@interface MockRestroomManager : RestroomManager <RestroomCommunicatorDelegate>
{
    NSInteger restroomFailureErrorCode;
    NSString *restroomSearchString;
    
    BOOL wasAskedToFetchRestrooms;
}

//@property (strong) id delegate;

- (NSInteger)restroomFailureErrorCode;
- (NSString *)restroomSearchString;

- (BOOL)didFetchRestrooms;
- (void)fetchRestroomsForQuery:(NSString *)query;
- (NSArray *)receivedRestrooms;

@end

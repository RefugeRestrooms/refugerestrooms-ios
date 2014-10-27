//
//  RestroomCommunicatorDelegate.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/1/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RestroomCommunicatorDelegate <NSObject>

- (void)searchingForRestroomsFailedWithError:(NSError *)error;
- (void)receivedRestroomsJSONString:(NSString *)jsonString;

@end

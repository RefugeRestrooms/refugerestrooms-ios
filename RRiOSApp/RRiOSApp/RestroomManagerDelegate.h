//
//  RestroomManagerDelegate.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RestroomManagerDelegate <NSObject>

- (void)didReceiveRestrooms:(NSArray *)restrooms;
- (void)fetchingRestroomsFailedWithError:(NSError *)error;

@end
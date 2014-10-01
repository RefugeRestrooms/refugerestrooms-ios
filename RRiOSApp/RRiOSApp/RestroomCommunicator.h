//
//  RestroomCommunicator.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestroomCommunicator : NSObject

- (NSURL *)URLToFetch;
- (NSURLConnection *)currentURLConnection;
- (void)searchForRestroomsWithQuery:(NSString *)query;
- (void)cancelAndDiscardURLConnection;

@end

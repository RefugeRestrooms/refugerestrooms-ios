//
//  InspectableRestroomCommunicator.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/1/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "InspectableRestroomCommunicator.h"

@implementation InspectableRestroomCommunicator

- (NSURL *)URLToFetch
{
    return fetchingURL;
}

- (NSURLConnection *)currentURLConnection
{
    return fetchingConnection;
}

@end

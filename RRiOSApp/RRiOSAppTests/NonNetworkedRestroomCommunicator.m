//
//  NonNetworkedRestroomCommunicator.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/1/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "NonNetworkedRestroomCommunicator.h"

@implementation NonNetworkedRestroomCommunicator

- (void)launchConnectionForRequest: (NSURLRequest *)request
{
    
}

- (void)setReceivedData:(NSData *)data
{
    receivedData = [data mutableCopy];
}

- (NSData *)receivedData
{
    return [receivedData copy];
}

@end

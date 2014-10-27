//
//  NonNetworkedRestroomCommunicator.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/1/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomCommunicator.h"

@interface NonNetworkedRestroomCommunicator : RestroomCommunicator <NSURLConnectionDelegate>

@property (copy) NSData *receivedData;

- (void)setReceivedData:(NSData *)data;

@end

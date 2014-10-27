//
//  FakeURLResponse.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/2/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "FakeURLResponse.h"

@implementation FakeURLResponse
{
//    NSInteger statusCode;
}

- (id)initWithStatusCode:(NSInteger)code
{
    self = [super init];
    
    _statusCode = code;
    
    return self;
}

@end

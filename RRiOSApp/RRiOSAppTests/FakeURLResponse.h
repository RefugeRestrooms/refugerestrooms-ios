//
//  FakeURLResponse.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/2/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeURLResponse : NSURLResponse

@property NSInteger statusCode;

- (id)initWithStatusCode:(NSInteger)code;

@end

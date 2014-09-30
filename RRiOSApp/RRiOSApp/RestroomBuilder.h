//
//  RestroomBuilder.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestroomBuilder : NSObject

enum
{
    RestroomBuilderInvalidJSONError,
    RestroomBuilderMissingDataError
};

- (NSArray *)restroomsFromJSON: (NSString *)objectNotation error:(NSError **)error;

@end

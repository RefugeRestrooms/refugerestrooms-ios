//
//  RefugeRestroomBuilder.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefugeRestroomBuilder : NSObject

typedef NS_ENUM(NSInteger, RefugeRestroomBuilderErrorCode)
{
    RefugeRestroomBuilderDeserializationErrorCode
};

- (NSArray *)buildRestroomsFromJSON:(id)jsonObjects error:(NSError **)error;

@end

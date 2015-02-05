//
//  RefugeSerialization.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *RefugeSerializationErrorDomain;

typedef NS_ENUM(NSInteger, RefugeSerializationErrorCode)
{
    RefugeSerializationErrorDeserializationFromJSONCode
};

@interface RefugeSerialization : NSObject

+ (NSArray *)deserializeRestroomsFromJSON:(NSArray *)JSON error:(NSError **)error;

@end

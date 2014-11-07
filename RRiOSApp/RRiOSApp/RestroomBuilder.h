//
//  RestroomBuilder.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestroomBuilder : NSObject

typedef NS_ENUM(NSInteger, RestroomBuilderErrorCode)
{
    RestroomBuilderErrorCodeInvalidJSONError,
    RestroomBuilderErrorCodeMissingDataError,
    RestroomBuilderErrorCodeSyncError,
    RestroomBuilderErrorCodeCoreDataFetchError,
    RestroomBuilderErrorCodeCoreDataSaveError
};

- (NSArray *)restroomsFromJSON: (NSString *)jsonString error:(NSError **)error;

@end

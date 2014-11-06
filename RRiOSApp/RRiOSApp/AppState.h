//
//  AppState.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 11/6/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppState : NSObject

@property (nonatomic, strong) NSDate *dateLastSynced;

+ (instancetype)sharedInstance;

@end

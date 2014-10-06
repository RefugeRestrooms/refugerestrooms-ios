//
//  RRTableViewDelegate.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "RRTableViewDataSource.h"

extern NSString *RRTableViewDidSelectRestroomNotification;

@class RRTableViewDataSource;

@interface RRTableViewDelegate : NSObject <UITableViewDelegate>

@property (strong) RRTableViewDataSource *tableDataSource;

@end

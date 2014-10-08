//
//  RRTableViewDataSource.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "Restroom.h"

extern NSString *RRTableViewDidSelectRestroomNotification;

@interface RRTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *restroomsList;

- (void)setRestroomsList:(NSArray *)restroomsList;

@end

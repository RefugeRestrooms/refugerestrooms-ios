//
//  RRViewController.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RRTableViewDataSource.h"

@interface RRViewController : UIViewController

@property (strong) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;

- (void)userDidSelectRestroomNotification:(NSNotification *)notification;

@end

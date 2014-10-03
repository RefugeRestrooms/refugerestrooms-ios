//
//  RRViewController.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRViewController : UIViewController

@property (strong) UITableView *tableView;
@property (strong) id <UITableViewDataSource> dataSource;
@property (strong) id <UITableViewDelegate> tableViewDelegate;

@end

//
//  RRViewController.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RRTableViewDataSource.h"
#import "RRTableViewDelegate.h"

@interface RRViewController : UIViewController

@property (strong) UITableView *tableView;

// TODO: make generic if this controller is to be re-used
// i.e. <id> UITableViewDataSource and <id> UITableViewDelegate
@property (strong) RRTableViewDataSource *dataSource;
@property (strong) RRTableViewDelegate *tableViewDelegate;

@end

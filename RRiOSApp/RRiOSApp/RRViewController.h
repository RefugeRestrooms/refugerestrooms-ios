//
//  RRViewController.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "RRTableViewDataSource.h"

@interface RRViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSArray *restroomsList;
@property (strong) IBOutlet UITableView *tableView;
//@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;
//@property (strong) RRTableViewDataSource *dataSource;
@property IBOutlet UISearchBar *searchBar;

- (void)userDidSelectRestroomNotification:(NSNotification *)notification;
- (void)setRestroomsList:(NSArray *)restroomsList;

@end

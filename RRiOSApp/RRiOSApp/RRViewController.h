//
//  RRViewController.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSArray *restroomsList;
@property (strong) IBOutlet UITableView *tableView;
@property IBOutlet UISearchBar *searchBar;

- (void)setRestroomsList:(NSArray *)restroomsList;
- (void)userDidSelectRestroomNotification:(NSNotification *)notification;

@end

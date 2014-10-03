//
//  RRViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRViewController.h"

@implementation RRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.delegate = self.tableViewDelegate;
    _tableView.dataSource = self.dataSource;
    
    _tableViewDelegate.tableDataSource = self.dataSource;
}

@end

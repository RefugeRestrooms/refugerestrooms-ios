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
    
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.dataSource;
}

@end

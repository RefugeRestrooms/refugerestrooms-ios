//
//  RRViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRViewController.h"
#import "RRTableViewDataSource.h"
#import "RestroomDetailsViewController.h"

@implementation RRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.delegate = self.dataSource;
    _tableView.dataSource = self.dataSource;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // register for notification of restroom selection by user
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSelectRestroomNotification:) name:RRTableViewDidSelectRestroomNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // view controller should not know of restroom selections if it is not active
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRTableViewDidSelectRestroomNotification object:nil];
}

#pragma mark - Helper methods

- (void)userDidSelectRestroomNotification:(NSNotification *)notification
{
//    objc_setAssociatedObject(self, viewControllerTestsNotificationKey, notification, OBJC_ASSOCIATION_RETAIN);

    Restroom *selectedRestroom = (Restroom *)[notification object];
    RestroomDetailsViewController *nextViewController = [[RestroomDetailsViewController alloc] init];
    
    nextViewController.restroom = selectedRestroom;
    
    // TODO: review whether animated s hould be NO
    // (changed to this because of http://stackoverflow.com/q/26223897/3777116 )
    [[self navigationController] pushViewController:nextViewController animated:NO];
}


@end

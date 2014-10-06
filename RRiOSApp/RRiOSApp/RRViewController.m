//
//  RRViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRViewController.h"
#import "RRTableViewDataSource.h"

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

- (void)viewDidDisappear:(BOOL)animated
{
      [super viewDidDisappear:animated];
    
    // view controller should not know of restroom selections if it is not active
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRTableViewDidSelectRestroomNotification object:nil];
}

#pragma mark - Helper methods

- (void)userDidSelectRestroomNotification:(NSNotification *)notification
{
//    objc_setAssociatedObject(self, viewControllerTestsNotificationKey, notification, OBJC_ASSOCIATION_RETAIN);

    Restroom *selectedRestroom = (Restroom *)[notification object];
    RRViewController *nextViewController = [[RRViewController alloc] init];
//    QuestionListTableDataSource *questionsDataSource = [[QuestionListTableDataSource alloc] init];
//    questionsDataSource.topic = selectedTopic;
//    nextViewController.dataSource = questionsDataSource;
//    nextViewController.objectConfiguration = self.objectConfiguration;
    [[self navigationController] pushViewController: nextViewController animated: YES];
}


@end

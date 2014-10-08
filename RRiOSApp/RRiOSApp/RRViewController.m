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
    
    self.dataSource = [[RRTableViewDataSource alloc] init];
    
    _tableView.delegate = _dataSource;
    _tableView.dataSource = _dataSource;
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
    Restroom *selectedRestroom = (Restroom *)[notification object];
    
    [self performSegueWithIdentifier:@"ShowRestroomDetails" sender:selectedRestroom];
};

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRestroomDetails"])
    {
        if([sender isKindOfClass:[Restroom class]])
        {
            RestroomDetailsViewController *restroomDetailsViewController = (RestroomDetailsViewController*)segue.destinationViewController;
    
            restroomDetailsViewController.restroom = sender;
        }
    }
}

@end

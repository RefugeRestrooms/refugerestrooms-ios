//
//  RRMapSearchViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 11/4/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRMapSearchViewController.h"
#import "RestroomDetailsViewController.h"
#import "Restroom.h"

NSString *cellReuseIdentifier = @"CustomCell";
//NSString *RRTableViewDidSelectRestroomNotification = @"RRTableViewDidSelectRestroomNotification";

NSString *controllerName = @"Search";

@implementation RRMapSearchViewController
{
    NSArray *sourceArray;
    NSMutableArray *filteredArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    sourceArray = @[ @"Apples", @"More Apples", @"Oranges" ];
    
    // set up search
    filteredArray = [NSMutableArray arrayWithCapacity:[sourceArray count]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // navigation bar styling
    self.title = controllerName;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // hide navigation bar
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    // register for notification of restroom selection by user
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSelectRestroomNotification:) name:RRTableViewDidSelectRestroomNotification object:nil];
//}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    // view controller should not know of restroom selections if it is not active
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRTableViewDidSelectRestroomNotification object:nil];
//}

//#pragma mark - getters and setters
//
//- (void)setRestroomsList:(NSArray *)restroomsList
//{
//    _restroomsList = restroomsList;
//}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredArray count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath section] == 0);
    NSParameterAssert([indexPath row] < [sourceArray count]);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
//    Restroom *restroom = [filteredRestroomArray objectAtIndex:indexPath.row];
    
    NSString *cellName = [filteredArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellName;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // post a notification whe a selection is made
//    NSNotification *notification = [NSNotification notificationWithName:RRTableViewDidSelectRestroomNotification object:[self restroomForIndexPath:indexPath]];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - Search methods

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope
    // Remove all objects from the filtered search array
    [filteredArray removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    
    filteredArray = [NSMutableArray arrayWithArray:[sourceArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
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
        RestroomDetailsViewController *restroomDetailsViewController = (RestroomDetailsViewController*)segue.destinationViewController;
        
        restroomDetailsViewController.restroom = sender;
    }
}

- (Restroom *)restroomForIndexPath:(NSIndexPath *)indexPath
{
    return [sourceArray objectAtIndex:[indexPath row]];
}

@end
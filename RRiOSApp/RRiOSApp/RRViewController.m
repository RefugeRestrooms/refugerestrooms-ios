//
//  RRViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRViewController.h"
#import "RestroomDetailsViewController.h"
#import "Restroom.h"

#pragma message "Use static here, see other comments"

NSString *restroomCellReuseIdentifier = @"RestroomCell";
NSString *RRTableViewDidSelectRestroomNotification = @"RRTableViewDidSelectRestroomNotification";

@interface RRViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RRViewController
{
    NSMutableArray *filteredRestroomArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    Restroom *restroom1 = [[Restroom alloc] init];
    
//    Restroom *restroom2 = [[Restroom alloc]
//                           initWithName:@"Friendlys"
//                           street:@"7129 O'Kelly Chapel Road"
//                           city:@"Cary"
//                           state:@"North Carolina"
//                           country:@"United States"
//                           isAccessible:FALSE
//                           isUnisex:TRUE
//                           numDownvotes:0
//                           numUpvotes:0
//                           latitude:10.0
//                           longitude:20.0
//                           databaseID:30
//                           ];
    
    Restroom *restroom2 = [[Restroom alloc]
                           initWithName:@"Friendlys"
                           street:@"7129 O'Kelly Chapel Road"
                           city:@"Cary"
                           state:@"North Carolina"
                           country:@"United States"
                           isAccessible:NO
                           isUnisex:YES
                           numDownvotes:0
                           numUpvotes:0
                           latitude:10.0
                           longitude:20.0
                           identifier:[NSNumber numberWithInt:30]
                           ];
    
    Restroom *restroom3 = [[Restroom alloc]
                           initWithName:@"Target"
                           street:@"123 ABC St"
                           city:@"Boston"
                           state:@"Massachusetts"
                           country:@"United States"
                           isAccessible:FALSE
                           isUnisex:TRUE
                           numDownvotes:0
                           numUpvotes:0
                           latitude:40.0
                           longitude:50.0
                           identifier:[NSNumber numberWithInt:60]
                           ];
    restroom3.directions = @"Take a left at Harvard.";
    
    self.restroomsList = @[ restroom1, restroom2, restroom3 ];
    
    // set up search
    filteredRestroomArray = [NSMutableArray arrayWithCapacity:[self.restroomsList count]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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

#pragma mark - getters and setters

- (void)setRestroomsList:(NSArray *)restroomsList
{
    _restroomsList = restroomsList;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredRestroomArray count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath section] == 0);
    NSParameterAssert([indexPath row] < [self.restroomsList count]);
    
    UITableViewCell *restroomCell = [tableView dequeueReusableCellWithIdentifier:restroomCellReuseIdentifier];
    
    if(!restroomCell)
    {
        restroomCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:restroomCellReuseIdentifier];
    }
    
    Restroom *restroom = [filteredRestroomArray objectAtIndex:indexPath.row];
    restroomCell.textLabel.text = restroom.name;
    
    return restroomCell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // post a notification whe a selection is made
    NSNotification *notification = [NSNotification notificationWithName:RRTableViewDidSelectRestroomNotification object:[self restroomForIndexPath:indexPath]];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - Search methods

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope
    // Remove all objects from the filtered search array
    [filteredRestroomArray removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    
    filteredRestroomArray = [NSMutableArray arrayWithArray:[self.restroomsList filteredArrayUsingPredicate:predicate]];
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
    return [filteredRestroomArray objectAtIndex:[indexPath row]];
}

@end

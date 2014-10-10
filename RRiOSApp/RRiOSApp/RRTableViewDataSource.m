//
//  RRTableViewDataSource.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRTableViewDataSource.h"

#import "Restroom.h"

//NSString *restroomCellReuseIdentifier = @"RestroomCell";
//NSString *RRTableViewDidSelectRestroomNotification = @"RRTableViewDidSelectRestroomNotification";

@implementation RRTableViewDataSource
{
    NSArray *searchResults;
}

// TODO: remove after testing
- (instancetype)init
{
    self = [super init];
    
    searchResults = [NSArray array];
    
    if(self)
    {
        Restroom *restroom1 = [[Restroom alloc] init];
        
        Restroom *restroom2 = [[Restroom alloc]
                               initWithName:@"Target"
                               andStreet:@"7129 O'Kelly Chapel Road"
                               andCity:@"Cary"
                               andState:@"North Carolina"
                               andCountry:@"United States"
                               andIsAccessible:FALSE
                               andIsUnisex:TRUE
                               andNumDownvotes:0
                               andNumUpvotes:0
                               andDateCreated:@"2014-02-02T20:55:31.555Z"];
        
        Restroom *restroom3 = [[Restroom alloc]
                               initWithName:@"Walmart"
                               andStreet:@"123 ABC St"
                               andCity:@"Boston"
                               andState:@"Massachusetts"
                               andCountry:@"United States"
                               andIsAccessible:FALSE
                               andIsUnisex:TRUE
                               andNumDownvotes:0
                               andNumUpvotes:0
                               andDateCreated:@"2014-01-01T20:55:31.555Z"];
        restroom3.directions = @"Take a left at Harvard.";
        
        self.restroomsList = @[ restroom1, restroom2, restroom3 ];
    }
    
    return self;
}

- (void)setRestroomsList:(NSArray *)restroomsList
{
    _restroomsList = restroomsList;
}

//- (void)setSearchDisplayController:(UISearchDisplayController *)searchDisplayController
//{
//    _searchDisplayController = searchDisplayController;
//}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        return [searchResults count];
    
//    }
//    else
//    {
        return [_restroomsList count];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath section] == 0);
    NSParameterAssert([indexPath row] < [_restroomsList count]);
    
    UITableViewCell *restroomCell = [tableView dequeueReusableCellWithIdentifier:@"RestroomCell"];
    
    if(!restroomCell)
    {
        restroomCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RestroomCell"];
    }
    
    Restroom *restroom = nil;
    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        restroom = [searchResults objectAtIndex:indexPath.row];
//    }
//    else
//    {
        restroom = [_restroomsList objectAtIndex:indexPath.row];
//    }
    
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

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    
    searchResults = [self.restroomsList filteredArrayUsingPredicate:resultPredicate];
}

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                               objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    
//    return YES;
//}

#pragma mark - Helper methods

- (Restroom *)restroomForIndexPath:(NSIndexPath *)indexPath
{
    return [_restroomsList objectAtIndex:[indexPath row]];
}

@end

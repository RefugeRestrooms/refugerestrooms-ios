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
                               street:@"7129 O'Kelly Chapel Road"
                               city:@"Cary"
                               state:@"North Carolina"
                               country:@"United States"
                               isAccessible:FALSE
                               isUnisex:TRUE
                               numDownvotes:0
                               numUpvotes:0
                               latitude:10.0
                               longitude:20.0
                               identifier:[NSNumber numberWithInt:30]
                               ];
        
        Restroom *restroom3 = [[Restroom alloc]
                               initWithName:@"Walmart"
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
    }
    
    return self;
}

- (void)setRestroomsList:(NSArray *)restroomsList
{
    _restroomsList = restroomsList;
}

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

// TO DO: REMOVE NOTIFICATION
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

#pragma mark - Helper methods

- (Restroom *)restroomForIndexPath:(NSIndexPath *)indexPath
{
    return [_restroomsList objectAtIndex:[indexPath row]];
}

@end

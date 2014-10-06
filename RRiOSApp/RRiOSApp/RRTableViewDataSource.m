//
//  RRTableViewDataSource.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RRTableViewDataSource.h"

NSString *restroomCellReuseIdentifier = @"RestroomCell";

@implementation RRTableViewDataSource

- (void)setRestroomsList:(NSArray *)restroomsList
{
    _restroomsList = restroomsList;
}

- (Restroom *)restroomForIndexPath:(NSIndexPath *)indexPath
{
    return [_restroomsList objectAtIndex:[indexPath row]];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    
    return [_restroomsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath section] == 0);
    NSParameterAssert([indexPath row] < [_restroomsList count]);
    
    UITableViewCell *restroomCell = [tableView dequeueReusableCellWithIdentifier:restroomCellReuseIdentifier];
    
    if(!restroomCell)
    {
        restroomCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:restroomCellReuseIdentifier];
    }
    
    restroomCell.textLabel.text = [[_restroomsList objectAtIndex:[indexPath row]] name];
    
    return restroomCell;
}

@end

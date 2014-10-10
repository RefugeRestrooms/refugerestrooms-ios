//
//  RestroomSearchTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/9/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Restroom.h"
#import "RRViewController.h"

@interface RestroomSearchTests : XCTestCase

@end

@implementation RestroomSearchTests
{
    RRViewController *viewController;
    UITableView *tableView;
    id <UITableViewDataSource, UITableViewDelegate> dataSource;
    NSArray *restrooms;
}

- (void)setUp
{
    [super setUp];
    
    viewController = [[RRViewController alloc] init];
    
    tableView = [[UITableView alloc] init];
    viewController.tableView = tableView;
    
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
    
    restrooms = @[ restroom1, restroom2, restroom3 ];
    
//    viewController.dataSource.restroomsList = restrooms;
    viewController.restroomsList = restrooms;
}

- (void)tearDown
{
    viewController = nil;
    tableView = nil;
    tableView = nil;
    restrooms = nil;
    
    [super tearDown];
}

@end

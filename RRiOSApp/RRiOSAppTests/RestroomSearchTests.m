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
                           Street:@"7129 O'Kelly Chapel Road"
                           City:@"Cary"
                           State:@"North Carolina"
                           Country:@"United States"
                           IsAccessible:FALSE
                           IsUnisex:TRUE
                           NumDownvotes:0
                           NumUpvotes:0
                           DateCreated:@"2014-02-02T20:55:31.555Z"];
    Restroom *restroom3 = [[Restroom alloc]
                           initWithName:@"Walmart"
                           Street:@"123 ABC St"
                           City:@"Boston"
                           State:@"Massachusetts"
                           Country:@"United States"
                           IsAccessible:FALSE
                           IsUnisex:TRUE
                           NumDownvotes:0
                           NumUpvotes:0
                           DateCreated:@"2014-01-01T20:55:31.555Z"];
    restroom3.directions = @"Take a left at Harvard.";
    
    restrooms = @[ restroom1, restroom2, restroom3 ];
    
    viewController.restroomsList = restrooms;
}

- (void)tearDown
{
    viewController = nil;
    tableView = nil;
    restrooms = nil;
    
    [super tearDown];
}

- (void)testThatTableViewHasNoRecordsBeforeSearch
{
    [viewController viewDidAppear:NO];
    
    XCTAssertTrue([viewController tableView:tableView numberOfRowsInSection:0] == 0, @"There should be no records in table view before a search is started.");
}

//- (void)testSearchProducesResults
//{
//    [viewController viewDidAppear:NO];
//    
//    // add Restroom
//    Restroom *restroom = [[Restroom alloc] init];
//    viewController.restroomsList = [NSArray arrayWithObject:restroom];
//    
//    // update search text
//    viewController.searchDisplayController.searchBar.text = restroom.name;
//    
//    // notify view controller that search query has changed
//    [viewController searchBar:viewController.searchDisplayController.searchBar textDidChange:restroom.name];
//    
//    XCTAssertTrue([viewController tableView:tableView numberOfRowsInSection:0] == 1, @"Searching should return results.");
//}

@end

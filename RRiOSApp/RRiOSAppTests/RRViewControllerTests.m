//
//  RRViewControllerTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <objc/runtime.h>

#import "RRTableViewDataSource.h"
#import "EmptyTableViewDelegate.h"

#import "RRViewController.h"

@interface RRViewControllerTests : XCTestCase
{
    RRViewController *viewController;
    UITableView *tableView;
}
@end

@implementation RRViewControllerTests

- (void)setUp
{
    [super setUp];
    
    viewController = [[RRViewController alloc] init];
    tableView = [[UITableView alloc] init];
    
    viewController.tableView = tableView;
}

- (void)tearDown
{
    viewController = nil;
    tableView = nil;
    
    [super tearDown];
}

- (void)testViewControllerHasTableViewProperty
{
    objc_property_t tableViewProperty = class_getProperty([viewController class], "tableView");
    
    XCTAssertTrue(tableViewProperty != NULL, @"RRViewController should have a table view.");
}

- (void)testViewControllerHasADataSourceProperty
{
    objc_property_t dataSourceProperty = class_getProperty([viewController class], "tableViewDelegate");
    
    XCTAssertTrue(dataSourceProperty != NULL, @"RRViewController should have a table view delegate.");
}

- (void)testViewControllerHasATableViewDelegateProperty
{
    objc_property_t delegateProperty = class_getProperty([viewController class], "tableViewDelegate");
    
    XCTAssertTrue(delegateProperty != NULL, @"View Controller needs a table view delegate.");
}

- (void)testViewControllerConnectsDataSourceInViewDidLoad
{
    id <UITableViewDataSource> dataSource = [[RRTableViewDataSource alloc] init];
    
    viewController.dataSource = dataSource;
    [viewController viewDidLoad];
    
    XCTAssertEqualObjects([tableView dataSource], dataSource, @"View Controller should have set the table view's data source.");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad
{
    id <UITableViewDelegate> delegate = [[EmptyTableViewDelegate alloc] init];
    
    viewController.tableViewDelegate = delegate;
    [viewController viewDidLoad];
    
    XCTAssertEqualObjects([tableView delegate], delegate, @"View Controller should have set the table view's delegate.");
}

@end

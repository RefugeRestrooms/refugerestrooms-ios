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
#import "RRTableViewDelegate.h"

#import "RRViewController.h"

@interface RRViewControllerTests : XCTestCase
{
    RRViewController *viewController;
    UITableView *tableView;
    id <UITableViewDataSource> dataSource;
    RRTableViewDelegate *delegate;
}
@end

@implementation RRViewControllerTests

- (void)setUp
{
    [super setUp];
    
    viewController = [[RRViewController alloc] init];
    
    tableView = [[UITableView alloc] init];
    viewController.tableView = tableView;
    
    dataSource = [[RRTableViewDataSource alloc] init];
    delegate = [[RRTableViewDelegate alloc] init];
    viewController.dataSource = dataSource;
    viewController.tableViewDelegate = delegate;
}

- (void)tearDown
{
    viewController = nil;
    tableView = nil;
    dataSource = nil;
    delegate = nil;
    
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
    [viewController viewDidLoad];
    
    XCTAssertEqualObjects([tableView dataSource], dataSource, @"View Controller should have set the table view's data source.");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad
{
    [viewController viewDidLoad];
    
    XCTAssertEqualObjects([tableView delegate], delegate, @"View Controller should have set the table view's delegate.");
}

- (void)testViewControllerConnectsDataSourceToDelegate
{
    [viewController viewDidLoad];
    
    XCTAssertEqualObjects(delegate.tableDataSource, dataSource, @"The ViewController should tell the table view delegate about its datasource.");
}

@end

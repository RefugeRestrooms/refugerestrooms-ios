//
//  RRTableViewDataSourceTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RRTableViewDataSource.h"
#import "Restroom.h"

@interface RRTableViewDataSourceTests : XCTestCase

@end

@implementation RRTableViewDataSourceTests
{
    RRTableViewDataSource *dataSource;
    NSArray *restroomsList;
}

- (void)setUp
{
    [super setUp];
    
    dataSource = [[RRTableViewDataSource alloc] init];
    
    Restroom *sampleRestroom = [[Restroom alloc] init];
    restroomsList = [NSArray arrayWithObject:sampleRestroom];
    
    dataSource.restroomsList = restroomsList;
}

- (void)tearDown
{
    dataSource = nil;
    restroomsList = nil;
    
    [super tearDown];
}

- (void)testDataSourceCanReceiveAListOfRestrooms
{

    XCTAssertNoThrow(dataSource.restroomsList = restroomsList, @"The data source should have a list of Restrooms.");
}

- (void)testOneTableRowForOneRestroom
{
    XCTAssertEqual((NSInteger)[restroomsList count], [dataSource tableView:nil numberOfRowsInSection:0], @"There should be one row in the table given there is one Restroom.");
}

- (void)testTwoTableRowsForTwoRestrooms
{
    Restroom *restroom1 = [[Restroom alloc] init];
    Restroom *restroom2 = [[Restroom alloc] init];
    
    NSArray *twoRestroomsList = [NSArray arrayWithObjects:restroom1, restroom2, nil];
    
    dataSource.restroomsList = twoRestroomsList;

    XCTAssertEqual((NSInteger)[twoRestroomsList count], [dataSource tableView:nil numberOfRowsInSection:0], @"There should be two rows in the table for two Restrooms.");
}

- (void)testTheresOnlyOneSectionsInTheTableView
{
    XCTAssertThrows([dataSource tableView:nil numberOfRowsInSection:1]);
}

- (void)testDataSourceCellCreationExpectsOneSection
{
    NSIndexPath *secondSection = [NSIndexPath indexPathForRow:0 inSection:1];
    
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:secondSection], @"Data source should expect only one section.");
}

- (void)testDataSourceCellCreationWillNotCreateMoreRowsThanItHasRestrooms
{
    NSIndexPath *afterLastRestrooms = [NSIndexPath indexPathForRow:[restroomsList count] inSection:0];
    
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:afterLastRestrooms], @"Data source should not create more rows than there are Restrooms.");
}

- (void)testCellCreatedByDataSourceContainsRestroomNameAsTextLabel
{
    NSIndexPath *firstRestroom = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *firstCell = [dataSource tableView:nil cellForRowAtIndexPath:firstRestroom];
    
    NSString *cellText = firstCell.textLabel.text;
    
    XCTAssertEqualObjects(@"Ferry Bldg", cellText, @"Cell's text should be equal to the Restroom's name.");
}

@end

//
//  RRTableViewDelegateTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RRTableViewDelegate.h"
#import "RRTableViewDataSource.h"
#import "Restroom.h"

@interface RRTableViewDelegateTests : XCTestCase
{
    NSNotification *receivedNotification;
    RRTableViewDataSource *dataSource;
    RRTableViewDelegate *delegate;
    Restroom *testRestroom;
}
@end

@implementation RRTableViewDelegateTests

- (void)setUp
{
    [super setUp];
    
    delegate = [[RRTableViewDelegate alloc] init];
    dataSource = [[RRTableViewDataSource alloc] init];
    testRestroom = [[Restroom alloc] init];
    
    dataSource.restroomsList = [NSArray arrayWithObject: testRestroom];
    delegate.tableDataSource = dataSource;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:RRTableViewDidSelectRestroomNotification object:nil];
}

- (void)tearDown
{
    receivedNotification = nil;
    dataSource = nil;
    delegate = nil;
    testRestroom = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super tearDown];
}

- (void)testDelegatePostNotificationOnSelectionIsShowingSelectedRestroom
{
    NSIndexPath *selection = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [delegate tableView:nil didSelectRowAtIndexPath:selection];
    
    XCTAssertEqualObjects([receivedNotification name], @"RRTableViewDidSelectRestroomNotification", @"The delegate should notify that a Restroom was selected.");
    
    XCTAssertEqualObjects([receivedNotification object], testRestroom, @"The notification should indicate the correct Restroom was selected.");
}

#pragma mark - Helper methods

- (void)didReceiveNotification:(NSNotification *)notification
{
    receivedNotification = notification;
}

@end
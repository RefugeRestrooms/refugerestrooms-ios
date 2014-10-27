//
//  RRTableViewDelegateTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RRTableViewDataSource.h"
#import "Restroom.h"

@interface RRTableViewDelegateTests : XCTestCase
{
    NSNotification *receivedNotification;
    RRTableViewDataSource *dataSource;
    Restroom *testRestroom;
}
@end

@implementation RRTableViewDelegateTests

- (void)setUp
{
    [super setUp];
    
    dataSource = [[RRTableViewDataSource alloc] init];
    testRestroom = [[Restroom alloc] init];
    
    dataSource.restroomsList = [NSArray arrayWithObject: testRestroom];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:RRTableViewDidSelectRestroomNotification object:nil];
}

- (void)tearDown
{
    receivedNotification = nil;
    dataSource = nil;
    testRestroom = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super tearDown];
}

- (void)testDelegatePostsNotificationOnSelectionShowingWhichRestroomWasSelected
{
    NSIndexPath *selection = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [dataSource tableView:nil didSelectRowAtIndexPath:selection];
    
    XCTAssertEqualObjects([receivedNotification name], @"RRTableViewDidSelectRestroomNotification", @"The delegate should notify that a Restroom was selected.");
    
    XCTAssertEqualObjects([receivedNotification object], testRestroom, @"The notification should indicate the correct Restroom was selected.");
}

#pragma mark - Helper methods

- (void)didReceiveNotification:(NSNotification *)notification
{
    receivedNotification = notification;
}

@end
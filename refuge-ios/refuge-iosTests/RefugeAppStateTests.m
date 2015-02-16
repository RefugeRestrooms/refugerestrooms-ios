//
//  RefugeAppStateTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <objc/runtime.h>
#import "MockNSUserDefaults.h"
#import "RefugeAppState.h"

@interface RefugeAppStateTests : XCTestCase

@property (nonatomic, strong) MockNSUserDefaults *userDefaults;
@property (nonatomic, strong) RefugeAppState *appState;

@end

@implementation RefugeAppStateTests

- (void)setUp
{
    [super setUp];
    
    self.userDefaults = [[MockNSUserDefaults alloc] init];
    self.appState = [[RefugeAppState alloc] initWithUserDefaults:self.userDefaults];
}

- (void)tearDown
{
    self.userDefaults = nil;
    self.appState = nil;
    
    [super tearDown];
}

- (void)testAppStateHasDateLastSyncedProperty
{
    objc_property_t dateLastSyncedProperty = class_getProperty([self.appState class], "dateLastSynced");
    
    XCTAssertTrue(dateLastSyncedProperty != NULL, @"AppState should have dateLastSynced property");
}

- (void)testUpdatingDateLastSyncedUpdatesUserDefaults
{
    NSDate *now = [NSDate date];
    self.appState.dateLastSynced = now;
    
    XCTAssertEqualObjects(self.userDefaults.date, now, @"Updating lastDateSynced in AppState should update date in User Defaults");
}

@end

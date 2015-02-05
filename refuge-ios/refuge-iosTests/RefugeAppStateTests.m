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
#import "RefugeappState.h"

@interface RefugeAppStateTests : XCTestCase

@property (nonatomic, strong) RefugeAppState *appState;

@end

@implementation RefugeAppStateTests

- (void)setUp
{
    [super setUp];
    
    self.appState = [RefugeAppState sharedInstance];
}

- (void)tearDown
{
    self.appState = nil;
    
    [super tearDown];
}

- (void)testAppStateHasDateLastSyncedProperty
{
    objc_property_t dateLastSyncedProperty = class_getProperty([self.appState class], "dateLastSynced");
    
    XCTAssertTrue(dateLastSyncedProperty != NULL, @"AppState should have dateLastSynced property");
}

@end

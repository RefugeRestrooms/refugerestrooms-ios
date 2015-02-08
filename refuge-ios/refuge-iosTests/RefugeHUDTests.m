//
//  RefugeHUDTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RefugeHUD.h"

@interface RefugeHUDTests : XCTestCase

@property (nonatomic, strong) RefugeHUD *hud;

@end

@implementation RefugeHUDTests

- (void)setUp
{
    [super setUp];
    
    self.hud = [[RefugeHUD alloc] init];
}

- (void)tearDown
{
    self.hud = nil;
    
    [super tearDown];
}

- (void)testThatHUDExists
{
    XCTAssertNotNil(self.hud, @"Should be able to create a new HUD instance");
}

@end

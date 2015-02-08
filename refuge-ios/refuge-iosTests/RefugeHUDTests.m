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
@property (nonatomic, strong) UIView *view;

@end

@implementation RefugeHUDTests

- (void)setUp
{
    [super setUp];
    
    self.view = [[UIView alloc] init];
//    self.view.bounds = [[UIScreen mainScreen] bounds];
    
    self.hud = [[RefugeHUD alloc] initWithView:self.view];
}

- (void)tearDown
{
    self.hud = nil;
    self.view = nil;
    
    [super tearDown];
}

- (void)testThatHUDExists
{
    XCTAssertNotNil(self.hud, @"Should be able to create a new HUD instance");
}

- (void)testNilIsReturnedWhenInitIsUsed
{
    RefugeHUD *invalidHUD = [[RefugeHUD alloc] init];
    
    XCTAssertNil(invalidHUD, @"Should not be able able to use init to initialize RefugeHUD");
}

- (void)testHudDoesNotAcceptNilForView
{
    RefugeHUD *invalidHUD;
    XCTAssertThrows(invalidHUD = [[RefugeHUD alloc] initWithView:nil], @"Should not be able to pass nil as a view to HUD");
}

@end

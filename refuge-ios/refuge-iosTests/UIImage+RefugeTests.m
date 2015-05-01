//
//  UIImage+RefugeTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "UIImage+Refuge.h"

@interface UIImage_RefugeTests : XCTestCase

@end

@implementation UIImage_RefugeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testThatResizeImageReturnsImageWithCorrectDimensions
{
    CGFloat desiredWith = 10.0;
    CGFloat desiredHeight = 20.0;
    NSString *imageName = @"refuge-map-pin.png";
    
    UIImage *resizedImage = [UIImage RefugeResizeImageNamed:imageName width:desiredWith height:desiredHeight];
    
    XCTAssertEqual(resizedImage.size.width, desiredWith, @"Resizing should change width");
    XCTAssertEqual(resizedImage.size.height, desiredHeight, @"Resizing should change height");
}

@end

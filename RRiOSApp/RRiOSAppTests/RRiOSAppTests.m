//
//  RRiOSAppTests.m
//  RRiOSAppTests
//
//  Created by Harlan Kellaway on 9/26/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Restroom.h"

@interface RRiOSAppTests : XCTestCase
{
    Restroom *restroom;
}
@end

@implementation RRiOSAppTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    restroom = [[Restroom alloc] initWithName:@"Target" andStreet:@"7129 O'Kelly Chapel Road" andCity:@"Cary" andState:@"North Carolina" andCountry:@"United States" andIsAccessible:FALSE andIsUnisex:TRUE andDirections:@"Labeled \"Family Restroom,\" right around the corner to the left when you walk in. " andComments:@"" andNumDownvotes:0 andNumUpvotes:0 andDateCreated:[NSDate distantPast] andDateUpdated:[NSDate distantPast] andDatabaseID:@"6303"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    restroom = nil;
}

@end

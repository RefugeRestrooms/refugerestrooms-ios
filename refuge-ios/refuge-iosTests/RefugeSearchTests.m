//
//  RefugeSearchTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RefugeSearch.h"

@interface RefugeSearchTests : XCTestCase

@property (nonatomic, strong) RefugeSearch *searchQuery;

@end

@implementation RefugeSearchTests

- (void)setUp
{
    [super setUp];
    
    self.searchQuery = [[RefugeSearch alloc] init];
}

- (void)tearDown
{
    self.searchQuery = nil;
    
    [super tearDown];
}

- (void)testThatSearchExists
{
    XCTAssertNotNil(self.searchQuery, @"Should be able to create a new Search instance");
}

//- (void)testThatValidSearchProducesSearchResults
//{
//    __block NSArray *searchResults;
//    __block NSError *searchError;
//    
//    [self.searchQuery searchForPlaces:@"The White House"
//                              success:^(NSArray *places) {
//                                  searchResults = places;
//                              }
//                              failure:^(NSError *error) {
//                                  searchError = error;
//                              }
//     ];
//    
//    XCTAssertNotNil(searchResults, @"Valid search should return search results.");
//    XCTAssertNil(searchError, @"Valid search should not return an error.");
//}

@end

//
//  RestroomCommunicatorTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/1/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "InspectableRestroomCommunicator.h"
#import "NonNetworkedRestroomCommunicator.h"
#import "MockRestroomManager.h"
#import "FakeURLResponse.h"

@interface RestroomCommunicatorTests : XCTestCase
{
    InspectableRestroomCommunicator *inspectableRestroomCommunicator;
    NonNetworkedRestroomCommunicator *nonNetworkedRestroomCommunicator;
    MockRestroomManager *mockRestroomManager;
    FakeURLResponse *fourOhFourResponse;
    NSData *receivedData;
}
@end

@implementation RestroomCommunicatorTests

- (void)setUp
{
    [super setUp];
    
    inspectableRestroomCommunicator = [[InspectableRestroomCommunicator alloc] init];
    nonNetworkedRestroomCommunicator = [[NonNetworkedRestroomCommunicator alloc] init];
    mockRestroomManager = [[MockRestroomManager alloc] init];
    
    nonNetworkedRestroomCommunicator.delegate = mockRestroomManager;
    
    fourOhFourResponse = [[FakeURLResponse alloc] initWithStatusCode:404];
    
    receivedData = [@"Result" dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown
{
    inspectableRestroomCommunicator = nil;
    nonNetworkedRestroomCommunicator = nil;
    mockRestroomManager = nil;
    fourOhFourResponse = nil;
    receivedData = nil;
    
    [super tearDown];
}

- (void)testThatARestroomManagerCanBeCreated
{
    XCTAssertNotNil(inspectableRestroomCommunicator, @"Should be able to create a RestroomCommunicator instance.");
}

- (void)testSearchingForRestroomsWithQueryCallsRefugeAPICorrectly
{
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"Walmart"];
    
    XCTAssertEqualObjects([[inspectableRestroomCommunicator URLToFetch] absoluteString], @"http://www.refugerestrooms.org:80/api/v1/restrooms/search.json?query=Walmart", @"Searching should call the Refuge API.");
}

- (void)testSearchingForRestroomsWithQueryContainingSpacesCallsRefugeAPICorrectly
{
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    
    XCTAssertEqualObjects([[inspectableRestroomCommunicator URLToFetch] absoluteString], @"http://www.refugerestrooms.org:80/api/v1/restrooms/search.json?query=San%20Francisco", @"Searching should call the Refuge API.");
}

- (void)testSearchingForRestroomsCreatesURLConnection
{
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    
    XCTAssertNotNil([inspectableRestroomCommunicator currentURLConnection], @"There should be a URL connection made when a search is exectued.");
    
    [inspectableRestroomCommunicator cancelAndDiscardURLConnection];
}

- (void)testStartingNewSearchThrowsOutOldConnection
{
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    NSURLConnection *firstConnection = [inspectableRestroomCommunicator currentURLConnection];
    
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"Walmart"];
    
    XCTAssertFalse([[inspectableRestroomCommunicator currentURLConnection] isEqual:firstConnection], @"The communicator should replace its current URL connection to start a new one.");
    
    [inspectableRestroomCommunicator cancelAndDiscardURLConnection];
}

- testReceivingResponseDiscardsExistingData
{
    nonNetworkedRestroomCommunicator.receivedData = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
    
    [nonNetworkedRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    
    [nonNetworkedRestroomCommunicator connection:nil didReceiveData:nil];
    
    XCTAssertEqual([nonNetworkedRestroomCommunicator.receivedData length], (NSUInteger)0, @"Data should be discarded if communicator receives a new response.");
}

 - (void)testReceivingResponseWith404StatusPassesErrorToDelegate
{
    [nonNetworkedRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    [nonNetworkedRestroomCommunicator connection:nil didReceiveResponse:(NSURLResponse *)fourOhFourResponse];
    
    XCTAssertEqual([mockRestroomManager restroomFailureErrorCode], 404, @"Receiving a 404 status response should pass an error to the delegate.");
}

- (void)testNoErrorReceivedOn200Status
{
    FakeURLResponse *twoHundredResponse = [[FakeURLResponse alloc] initWithStatusCode:200];
    
    [nonNetworkedRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    
    [nonNetworkedRestroomCommunicator connection:nil didReceiveResponse:(NSURLResponse *)twoHundredResponse];
    
    XCTAssertFalse([mockRestroomManager restroomFailureErrorCode] == 200, @"An error should not be returned from a 200 response.");
}

- (void)testConnectionFailingPassesErrorToDelegate
{
    [nonNetworkedRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    
    NSError *error = [NSError errorWithDomain:@"Fake domain" code:12345 userInfo:nil];
    [nonNetworkedRestroomCommunicator connection: nil didFailWithError:error];
    
    XCTAssertEqual([mockRestroomManager restroomFailureErrorCode], 12345, @"Failure to connect should get passed to delegate.");
}

- (void)testSuccessfulSearchPassesDataToDelegate
{
    [nonNetworkedRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    
    [nonNetworkedRestroomCommunicator setReceivedData:receivedData];
    [nonNetworkedRestroomCommunicator connectionDidFinishLoading:nil];
    
    XCTAssertEqualObjects([mockRestroomManager restroomSearchString], @"Result", @"The delegate should have received data on succes.");
}

- (void)testAdditionalDataIsAppendedToDownload
{
    [nonNetworkedRestroomCommunicator setReceivedData:receivedData];
    
    NSData *extraData = [@" appended" dataUsingEncoding:NSUTF8StringEncoding];
    [nonNetworkedRestroomCommunicator connection:nil didReceiveData:extraData];
    
    NSString *combinedString = [[NSString alloc] initWithData:[nonNetworkedRestroomCommunicator receivedData] encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(combinedString, @"Result appended", @"Received data should be appended ot the downloaded data.");
}

// TODO: add support for filtering by accessibility/unisex

@end

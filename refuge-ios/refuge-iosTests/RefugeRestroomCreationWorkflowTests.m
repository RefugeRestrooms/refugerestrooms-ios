//
//  RefugeRestroomCreationWorkflowTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MockRefugeDataPersistenceManager.h"
#import "MockRefugeHUD.h"
#import "MockRefugeRestroomBuilder.h"
#import "MockRefugeRestroomCommunicator.h"
#import "MockRefugeRestroomManagerDelegate.h"
#import "RefugeRestroom.h"
#import "RefugeRestroomManager.h"

@interface RefugeRestroomCreationWorkflowTests : XCTestCase

@end

@implementation RefugeRestroomCreationWorkflowTests
{
    RefugeRestroomManager *restroomManager;
    MockRefugeDataPersistenceManager *dataPersistenceManager;
    MockRefugeRestroomManagerDelegate *delegate;
    MockRefugeRestroomBuilder *restroomBuilder;
//    MockRefugeHUD *hud;
    NSError *underlyingError;
    NSArray *jsonObjects;
    NSArray *restrooms;
}

- (void)setUp
{
    [super setUp];
    
    restroomManager = [[RefugeRestroomManager alloc] init];
    dataPersistenceManager = [[MockRefugeDataPersistenceManager alloc] init];
    delegate = [[MockRefugeRestroomManagerDelegate alloc] init];
    restroomBuilder = [[MockRefugeRestroomBuilder alloc] init];
    
//    UIView *view = [[UIView alloc] init];
//    view.bounds = [[UIScreen mainScreen] bounds];
//    hud = [[MockRefugeHUD alloc] initWithView:view];
    
    underlyingError = [NSError errorWithDomain:@"Test Domain" code:0 userInfo:nil];
    jsonObjects = [NSArray array];
    
    RefugeRestroom *restroom = [[RefugeRestroom alloc] init];
    restrooms = [NSArray arrayWithObject:restroom];
    
    dataPersistenceManager.delegate = restroomManager;
    restroomManager.dataPersistenceManager = dataPersistenceManager;
    restroomManager.delegate = delegate;
    restroomManager.restroomBuilder = restroomBuilder;
}

- (void)tearDown
{
    restroomManager = nil;
    dataPersistenceManager = nil;
    delegate = nil;
    restroomBuilder = nil;
//    hud = nil;
    underlyingError = nil;
    jsonObjects = nil;
    restrooms = nil;
    
    [super tearDown];
}

- (void)testAskingForRestroomsMeansRequestingData
{
    MockRefugeRestroomCommunicator *restroomCommunicator = [[MockRefugeRestroomCommunicator alloc] init];
    
    restroomManager.restroomCommunicator =  restroomCommunicator;
    
    [restroomManager fetchRestroomsFromAPI];
    
    XCTAssertTrue(restroomCommunicator.wasAskedToFetchRestrooms, @"Communicator should register need to fetch data");
}

- (void)testErrorReturnedToDelegateWhenCommunicatorFails
{
    [restroomManager searchingForRestroomsFailedWithError:underlyingError];
    
    XCTAssertNotNil([delegate fetchError], @"Delegate should receive error when Communicator fails");
}

- (void)testErrorReturnedToDelegateIsNotNotifiedByCommunicator
{
    [restroomManager searchingForRestroomsFailedWithError:underlyingError];
    
    XCTAssertFalse(underlyingError == delegate.fetchError, @"Error passed to delegate should be at the correct level of abstraction");
}

- (void)testErrorReturnedToelegateDocumentsUnderlyingError
{
    [restroomManager searchingForRestroomsFailedWithError:underlyingError];
    
    XCTAssertEqualObjects([[[delegate fetchError] userInfo] objectForKey:NSUnderlyingErrorKey], underlyingError, @"Error passed to delegate should document underlying error");
}

- (void)testRestroomJSONIsPassedToRestroomBuilder
{
    [restroomManager didReceiveRestroomsJsonObjects:jsonObjects];
    
    XCTAssertEqualObjects(restroomBuilder.jsonObjects, jsonObjects, @"Downloaded JSON should be sent to Builder");
}

- (void)testErrorReturnedToDelegateWhenBuilderFails
{
    restroomBuilder.arrayToReturn = nil;
    restroomBuilder.errorToSet = underlyingError;
    
    [restroomManager didReceiveRestroomsJsonObjects:jsonObjects];
    
    XCTAssertNotNil(delegate.fetchError, @"Delegate should receive error when Builder fails");
    XCTAssertEqualObjects([[delegate.fetchError userInfo] objectForKey:NSUnderlyingErrorKey], underlyingError, @"Delegate should receive error when Builder fails");
}

- (void)testErrorNotReturnedToDelegateWhenRestroomsReceived
{
    restroomBuilder.arrayToReturn = restrooms;
    
    [restroomManager didReceiveRestroomsJsonObjects:jsonObjects];
    
    XCTAssertNil(delegate.fetchError, @"Error should not be received by delegate when fetching Books is successful");
}

- (void)testDelegateNotifiedOfRestroomsFetchedByManager
{
    restroomBuilder.arrayToReturn = restrooms;
    
    [restroomManager didReceiveRestroomsJsonObjects:jsonObjects];
    
    XCTAssertTrue(delegate.wasNotifiedOfFetchedRestrooms, @"Delegate should receive Restrooms from Manager when fetch is successful");
}

- (void)testEmptyRestroomsArrayCanBePassedToDelegate
{
    NSArray *emptyArray = [NSArray array];
    restroomBuilder.arrayToReturn = emptyArray;
    
    [restroomManager didReceiveRestroomsJsonObjects:jsonObjects];
    
    XCTAssertTrue(delegate.wasNotifiedOfFetchedRestrooms, @"Delegate receiving an empty array of Restrooms should not be an error");
}

- (void)testDataPeristenceManagerToldToSaveWhenRestroomsBuildSuccessfully
{
    restroomBuilder.arrayToReturn = restrooms;
    
    [restroomManager didReceiveRestroomsJsonObjects:jsonObjects];
    
    XCTAssertTrue(dataPersistenceManager.wasAskedToSaveRestrooms, @"Data persistence manager should be asked to save Restrooms when restrooms are built successfully");
}

- (void)testErrorReturnedToDelegateWhenSaveFails
{
    [restroomManager savingRestroomsFailedWithError:underlyingError];
    
    XCTAssertNotNil([delegate saveError], @"Delegate should receive error when save fails");
}

//- (void)testHUDAskedToDisplayErrorWhenFetchingFails
//{
//    [restroomManager searchingForRestroomsFailedWithError:nil];
//    
//    XCTAssertTrue(hud.wasAskedToDisplayError, @"HUD should display error when fetch fails");
//}
//
//- (void)testHUDAskedToDisplayErrorWhenSavingFails
//{
//    [restroomManager savingRestroomsFailedWithError:nil];
//    
//    XCTAssertTrue(hud.wasAskedToDisplayError, @"HUD should display error when fetch fails");
//}

@end
//
//  RRViewControllerTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/3/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <objc/runtime.h>

#import "RRTableViewDataSource.h"
#import "RRViewController.h"
#import "RestroomDetailsViewController.h"

// CATEGORY = TestNotificationDelivery
static const char *notificationKey = "RRViewControllerTestsAssociatedNotificationKey";

@implementation RRViewController (TestNotificationDelivery)

- (void)RRViewControllerTests_userDidSelectRestroomNotification: (NSNotification *)notification
{
    objc_setAssociatedObject(self, notificationKey, notification, OBJC_ASSOCIATION_RETAIN);
}

@end

// CATEGORY = TestSuperclassCalled
static const char *viewDidAppearKey = "RRViewControllerTestsViewDidAppearKey";
static const char *viewWillDisappearKey = "RRControllerTestsViewWillDisappearKey";
static const char *viewWillAppearKey = "RRViewControllerTestsViewWillAppearKey";

@implementation UIViewController (TestSuperclassCalled)

- (void)RRViewControllerTests_viewDidAppear:(BOOL)animated
{
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    
    objc_setAssociatedObject(self, viewDidAppearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

- (void)RRViewControllerTests_viewWillDisappear:(BOOL)animated
{
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    
    objc_setAssociatedObject(self, viewWillDisappearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

- (void)RRViewControllerTests_viewWillAppear:(BOOL)animated
{
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    
    objc_setAssociatedObject(self, viewWillAppearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}
@end

@interface RRViewControllerTests : XCTestCase
@end

@implementation RRViewControllerTests
{
    RRViewController *viewController;
    UITableView *tableView;
    id <UITableViewDataSource, UITableViewDelegate> dataSource;
    UINavigationController *navigationController;
    
    // view appear/disappear selectors
    SEL realViewDidAppear, testViewDidAppear;
    SEL realViewWillDisappear, testViewWillDisappear;
    
    // restroom selection selectors
    SEL realUserDidSelectRestroom, testUserDidSelectRestroom;
}

// swap methods at runtime for testing
+ (void)swapInstanceMethodsForClass:(Class)classWithSwap selector:(SEL)selector1 andSelector:(SEL)selector2
{
    Method method1 = class_getInstanceMethod(classWithSwap, selector1);
    Method method2 = class_getInstanceMethod(classWithSwap, selector2);

    method_exchangeImplementations(method1, method2);
}

- (void)setUp
{
    [super setUp];
    
    viewController = [[RRViewController alloc] init];
    
    tableView = [[UITableView alloc] init];
    viewController.tableView = tableView;
    
//    dataSource = [[RRTableViewDataSource alloc] init];
//    viewController.dataSource = dataSource;
    
    objc_removeAssociatedObjects(viewController);
    
    // swap UIViewControllers real -viewDidAppear with our test version
    realViewDidAppear = @selector(viewDidAppear:);
    testViewDidAppear = @selector(RRViewControllerTests_viewDidAppear:);
    [RRViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];

    // swap UIViewControllers real -viewDidDisappear with our test version
    realViewWillDisappear = @selector(viewWillDisappear:);
    testViewWillDisappear = @selector(RRViewControllerTests_viewWillDisappear:);
    [RRViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
    
    // swap RRViewControllers real -userDidSelectRestroom with our test version
    realUserDidSelectRestroom = @selector(userDidSelectRestroomNotification:);
    testUserDidSelectRestroom = @selector(RRViewControllerTests_userDidSelectRestroomNotification:);
    
    // navigation controller set up
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
}

- (void)tearDown
{
    objc_removeAssociatedObjects(viewController);
    
    viewController = nil;
    tableView = nil;
    dataSource = nil;
    navigationController = nil;
    
    // undo swaps
    [RRViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];
    [RRViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
    
    [super tearDown];
}

- (void)testViewControllerHasTableViewProperty
{
    objc_property_t tableViewProperty = class_getProperty([viewController class], "tableView");
    
    XCTAssertTrue(tableViewProperty != NULL, @"RRViewController should have a table view.");
}

- (void)testViewControllerHasDataSourceProperty
{
    objc_property_t dataSourceProperty = class_getProperty([viewController class], "dataSource");
    
    XCTAssertTrue(dataSourceProperty != NULL, @"RRViewController should have a table view delegate.");
}

- (void)testViewControllerConnectsDataSourceInViewDidLoad
{
    [viewController viewDidLoad];
    
    XCTAssertNotNil([tableView dataSource], @"View Controller should have set the table view's data source.");
    
    XCTAssertTrue([[tableView dataSource] isKindOfClass:[RRTableViewDataSource class]], @"Table view's data source should be an RRTableViewDataSource.");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad
{
    [viewController viewDidLoad];
    
    XCTAssertNotNil([tableView delegate], @"View Controller should have set the table view's delegate.");
    
    XCTAssertTrue([[tableView delegate] isKindOfClass:[RRTableViewDataSource class]], @"Table view's delegate should be an RRTableViewDataSource.");
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotifications
{
    // swap
    [RRViewControllerTests swapInstanceMethodsForClass:[RRViewController class] selector:realUserDidSelectRestroom andSelector:testUserDidSelectRestroom];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RRTableViewDidSelectRestroomNotification object:nil userInfo:nil];
    
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"Notification should not be received before -viewDidAppear");
    
    // un-do swap
    [RRViewControllerTests swapInstanceMethodsForClass:[RRViewController class] selector:realUserDidSelectRestroom andSelector:testUserDidSelectRestroom];
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidAppear
{
    // swap
    [RRViewControllerTests swapInstanceMethodsForClass:[RRViewController class] selector:realUserDidSelectRestroom andSelector:testUserDidSelectRestroom];
    
    [viewController viewDidAppear:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RRTableViewDidSelectRestroomNotification object:nil userInfo:nil];
    
    XCTAssertNotNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewDidAppear, the View Controller should handle selection notifications.");
    
    // un-do swap
    [RRViewControllerTests swapInstanceMethodsForClass:[RRViewController class] selector:realUserDidSelectRestroom andSelector:testUserDidSelectRestroom];
}

- (void)testViewControllerDoesNotReceiveTableSelectionNotificationAfterViewWillDisappear
{
    // swap
    [RRViewControllerTests swapInstanceMethodsForClass:[RRViewController class] selector:realUserDidSelectRestroom andSelector:testUserDidSelectRestroom];
    
    [viewController viewDidAppear:NO];
    [viewController viewWillDisappear:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RRTableViewDidSelectRestroomNotification object:nil userInfo:nil];
    
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewWillDisappear, the View Controller should no longer respond to topic selection notifications.");
    
    // un-do swap
    [RRViewControllerTests swapInstanceMethodsForClass:[RRViewController class] selector:realUserDidSelectRestroom andSelector:testUserDidSelectRestroom];
}

- (void)testViewControllerCallsSuperViewDidAppear
{
    [viewController viewDidAppear:NO];
    
    XCTAssertNotNil(objc_getAssociatedObject(viewController, viewDidAppearKey), @"-viewDidAppear should call through to superclass implementation.");
}

- (void)testViewControllerCallsSuperViewWillDisappear
{
    [viewController viewWillDisappear:NO];
    
    XCTAssertNotNil(objc_getAssociatedObject(viewController, viewWillDisappearKey), @"-viewWillDisappear should call through to supperclass implementation.");
}

- (void)testThatPrepareForSegueExecutesShowRestroomDetailsOnlyWithARestroomObject
{
    // TODO: implement
    XCTAssertTrue(YES, @"This test needs to be implemented.");
}

@end

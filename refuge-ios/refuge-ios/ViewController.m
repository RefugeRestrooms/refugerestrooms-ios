//
//  ViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "ViewController.h"

#import "RefugeDataPersistenceManager.h"
#import "RefugeRestroomBuilder.h"
#import "RefugeRestroomCommunicator.h"
#import "RefugeRestroomManager.h"

@interface ViewController ()

@property (nonatomic, strong) RefugeRestroomManager *restroomManager;
@property (nonatomic, strong) RefugeDataPersistenceManager *dataPersistenceManager;
@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;
@property (nonatomic, strong) RefugeRestroomCommunicator *restroomCommunicator;

@end

@implementation ViewController

# pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self configureRestroomManager];
//    [self.restroomManager fetchRestrooms];
}

# pragma mark - Public methods

# pragma mark RefugeRestroomManagerDelegate methods

- (void)didReceiveRestrooms:(NSArray *)restrooms
{
    NSLog(@"Restrooms received: %@", restrooms);
}

- (void)fetchingRestroomsFailedWithError:(NSError *)error
{
    NSLog(@"Restrooms fetch error: %@", error);
}

- (void)syncingRestroomsFailedWithError:(NSError *)error
{
    NSLog(@"Restrooms sync error: %@", error);
}

# pragma mark - Private methods

- (void)configureRestroomManager
{
    self.restroomManager = [[RefugeRestroomManager alloc] init];
    self.dataPersistenceManager = [[RefugeDataPersistenceManager alloc] init];
    self.restroomBuilder = [[RefugeRestroomBuilder alloc] init];
    self.restroomCommunicator = [[RefugeRestroomCommunicator alloc] init];
    
    self.restroomManager.dataPersistenceManager = self.dataPersistenceManager;
    self.restroomManager.restroomBuilder = self.restroomBuilder;
    self.restroomManager.restroomCommunicator = self.restroomCommunicator;
    
    self.restroomManager.delegate = self;
    self.restroomCommunicator.delegate = self.restroomManager;
}

@end

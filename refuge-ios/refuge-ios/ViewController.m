//
//  ViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "ViewController.h"

#import "RefugeRestroomManager.h"
#import "RefugeRestroomBuilder.h"
#import "RefugeRestroomCommunicator.h"

@interface ViewController ()

@property (nonatomic, strong) RefugeRestroomManager *restroomManager;
@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;
@property (nonatomic, strong) RefugeRestroomCommunicator *restroomCommunicator;

@end

@implementation ViewController

# pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureRestroomManager];
    [self.restroomManager fetchRestrooms];
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

# pragma mark - Private methods

- (void)configureRestroomManager
{
    self.restroomManager = [[RefugeRestroomManager alloc] init];
    self.restroomBuilder = [[RefugeRestroomBuilder alloc] init];
    self.restroomCommunicator = [[RefugeRestroomCommunicator alloc] init];
    
    self.restroomManager.restroomBuilder = self.restroomBuilder;
    self.restroomManager.restroomCommunicator = self.restroomCommunicator;
    
    self.restroomManager.delegate = self;
    self.restroomCommunicator.delegate = self.restroomManager;
}

@end

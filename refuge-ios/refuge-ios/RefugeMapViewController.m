//
//  RefugeMapViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMapViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RefugeDataPersistenceManager.h"
#import "RefugeHUD.h"
#import "RefugeRestroomBuilder.h"
#import "RefugeRestroomCommunicator.h"
#import "RefugeRestroomManager.h"

static NSString * const kRefugeRestroomDetailsShowSegue = @"RefugeRestroomDetailsShowSegue";

static NSString * const kHudTextSyncing = @"Syncing";

@interface RefugeMapViewController ()

@property (nonatomic, strong) RefugeHUD *hud;
@property (nonatomic, strong) RefugeRestroomManager *restroomManager;
@property (nonatomic, strong) RefugeDataPersistenceManager *dataPersistenceManager;
@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;
@property (nonatomic, strong) RefugeRestroomCommunicator *restroomCommunicator;

- (IBAction)showRestroomDetails:(id)sender;

@end

@implementation RefugeMapViewController

# pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self configureRestroomManager];
    
    self.hud = [[RefugeHUD alloc] initWithView:self.view];
    self.hud.text = kHudTextSyncing;
    
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

- (void)savingRestroomsFailedWithError:(NSError *)error
{
    NSLog(@"Restrooms save error: %@", error);
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
    
    self.dataPersistenceManager.delegate = self.restroomManager;
    self.restroomManager.delegate = self;
    self.restroomCommunicator.delegate = self.restroomManager;
}

- (IBAction)showRestroomDetails:(id)sender
{
    [self performSegueWithIdentifier:kRefugeRestroomDetailsShowSegue sender:self];
}

@end

//
//  RefugeOnboardingViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/16/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeOnboardingViewController.h"

#import <EAIntroView/EAIntroView.h>

static NSString * const kSegueNameDismissOnboarding = @"RefugeRestroomDissmissOnboardingSegue";

@interface RefugeOnboardingViewController ()

@property (nonatomic, strong) EAIntroView *onboardingView;

@end

@implementation RefugeOnboardingViewController

#pragma mark - View life-cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *pages = [self createPages];
    self.onboardingView = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:pages];
    self.onboardingView.delegate = self;
    
    [self.onboardingView showInView:self.view animateDuration:0.3];
}

#pragma mark - Public methods

#pragma mark EAIntroViewDelegate methods

- (void)introDidFinish:(EAIntroView *)introView
{
    [self performSegueWithIdentifier:kSegueNameDismissOnboarding sender:self];
}

#pragma mark - Private methods

- (NSArray *)createPages
{
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Description";
    page1.bgImage = [UIImage imageNamed:@"refuge-onboard-image1.png"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Description";
    page2.bgImage = [UIImage imageNamed:@"refuge-onboard-image2.png"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Description";
    page3.bgImage = [UIImage imageNamed:@"refuge-onboard-image3.png"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = @"Description";
    page4.bgImage = [UIImage imageNamed:@"refuge-onboard-image4.png"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refuge-map-pin.png"]];
    
    return @[page1, page2, page3, page4];
}

@end

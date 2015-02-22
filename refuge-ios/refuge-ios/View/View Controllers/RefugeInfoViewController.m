//
//  RefugeInfoViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/21/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeInfoViewController.h"

@interface RefugeInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *githubImage;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;

@end

@implementation RefugeInfoViewController

#pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addGestureRecognizersToImages];
}

#pragma mark - Touch

- (void)didTouchGithubImage
{
    NSLog(@"Github");
}

- (void)didTouchFacebookImage
{
    NSLog(@"Facebook");
}

- (void)didTouchTwitterImage
{
    NSLog(@"Twitter");
}

#pragma mark - Private methods

- (void)addGestureRecognizersToImages
{
    UITapGestureRecognizer *githubGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchGithubImage)];
    [self.githubImage addGestureRecognizer:githubGestureRecognizer];
    
    UITapGestureRecognizer *facebookGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchFacebookImage)];
    [self.facebookImage addGestureRecognizer:facebookGestureRecognizer];
    
    UITapGestureRecognizer *twitterGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchTwitterImage)];
    [self.twitterImage addGestureRecognizer:twitterGestureRecognizer];
}

@end

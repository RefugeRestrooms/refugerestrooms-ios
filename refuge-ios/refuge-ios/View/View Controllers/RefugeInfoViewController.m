//
//  RefugeInfoViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/21/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeInfoViewController.h"

#import "Mixpanel+Refuge.h"

NSString *RefugeInfoViewErrorDomain = @"RefugeInfoViewErrorDomain";
static NSInteger const kRefugeInfoErrorCode = 0;

static NSString * const kGithubLinkName = @"https://github.com/RefugeRestrooms/refugerestrooms";
static NSString * const kFacebookLinkName = @"https://www.facebook.com/refugerestrooms";
static NSString * const kTwitterLinkName = @"https://twitter.com/refugerestrooms";

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
    [self openLinkWithName:kGithubLinkName];
}

- (void)didTouchFacebookImage
{
    [self openLinkWithName:kFacebookLinkName];
}

- (void)didTouchTwitterImage
{
    [self openLinkWithName:kTwitterLinkName];
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

- (void)openLinkWithName:(NSString *)linkName
{
    NSURL *url = [NSURL URLWithString:linkName];
    
    if (![[UIApplication sharedApplication] openURL:url])
    {
        [self reportErrorOpeningLinkWithName:linkName];
    }
}

- (void)reportErrorOpeningLinkWithName:(NSString *)linkName
{
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Could not open link: %@", linkName]
                               };
    NSError *error = [NSError errorWithDomain:RefugeInfoViewErrorDomain code:kRefugeInfoErrorCode userInfo:userInfo];
    
    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeOpeningLinkFailed];
}

@end

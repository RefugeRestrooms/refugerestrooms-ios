//
//  RefugeNewRestroomViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/17/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeNewRestroomViewController.h"

static NSString * const kUrlNewRestroom = @"http://www.refugerestrooms.org/restrooms/new";

@interface RefugeNewRestroomViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@end

@implementation RefugeNewRestroomViewController

#pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:kUrlNewRestroom];
    NSURLRequest *urlResquest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlResquest];
}

#pragma mark - Public methods

#pragma mark UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadingView.hidden = YES;
}

@end

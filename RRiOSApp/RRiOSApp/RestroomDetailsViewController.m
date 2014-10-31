//
//  RestroomDetailsViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/6/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "UIKit/UIKit.h"

#import "Constants.h"
#import "RestroomDetailsViewController.h"

@interface RestroomDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@end

@implementation RestroomDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // navigation bar styling
    self.title = self.restroom.name;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // set details
    self.nameLabel.text = self.restroom.name;
    self.addressLabel.text = [NSString stringWithFormat:@"%@", self.restroom.street];
    self.directionsLabel.text = self.restroom.directions;
    self.commentsLabel.text = self.restroom.comment;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

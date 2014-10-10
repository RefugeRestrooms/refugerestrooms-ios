//
//  RestroomDetailsViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/6/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "UIKit/UIKit.h"

#import "RestroomDetailsViewController.h"

@interface RestroomDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation RestroomDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    self.nameLabel.text = self.restroom.name;
}

@end

//
//  RRFilterViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 11/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "Constants.h"
#import "RRFilterViewController.h"

@implementation RRFilterViewController

// switch defaults
static BOOL isFilteredByUnisex = NO;
static BOOL isFilteredByAccessibility = NO;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // navigation bar styling
    self.title = RRCONSTANTS_FILTER_VIEW_CONTROLLER_TITLE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.unisexFilterLabel.text = RRCONSTANTS_UNISEX_FILTER_TEXT;
    self.accessibilityFilterLabel.text = RRCONSTANTS_ACCESSIBILITY_FILTER_TEXT;
    
    self.unisexFilterSwitch.on = isFilteredByUnisex;
    self.accessibilityFilterSwitch.on = isFilteredByAccessibility;
}

- (IBAction)unisexFilterSwitchTouched:(id)sender
{
    isFilteredByUnisex = self.unisexFilterSwitch.on;
}

- (IBAction)accessibilityFilterSwitchTouched:(id)sender
{
    isFilteredByAccessibility = self.accessibilityFilterSwitch.on;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end

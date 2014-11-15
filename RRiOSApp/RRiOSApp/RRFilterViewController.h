//
//  RRFilterViewController.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 11/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRFilterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *unisexFilterLabel;
@property (weak, nonatomic) IBOutlet UISwitch *unisexFilterSwitch;
@property (weak, nonatomic) IBOutlet UILabel *accessibilityFilterLabel;
@property (weak, nonatomic) IBOutlet UISwitch *accessibilityFilterSwitch;


@end

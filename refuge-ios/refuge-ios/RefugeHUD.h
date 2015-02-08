//
//  RefugeHUD.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefugeHUD : UIView

@property (nonatomic, strong) NSString *text;

- (id)initWithView:(UIView *)view;

@end

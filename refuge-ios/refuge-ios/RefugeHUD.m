//
//  RefugeHUD.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeHUD.h"

#import <MBProgressHUD.h>
#import "UIColor+Refuge.h"

@interface RefugeHUD ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation RefugeHUD

# pragma mark - Initializers

- (id)initWithView:(UIView *)view
{
    if(view == nil)
    {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"View argument cannot be nil for this class." userInfo:nil] raise];
        
        return nil;
    }
    
    self = [self initWithFrame:view.bounds];
    
    if(self)
    {
        self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        self.hud.mode = MBProgressHUDAnimationFade;
        self.hud.color = [UIColor RefugePurpleDark];
    }
    
    return self;
}

- (id)init
{
    NSAssert(false, @"Use initInView: to initialize this class.");

    return nil;
}

# pragma mark - Setters

- (void)setText:(NSString *)text
{
//    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = text;
}

@end

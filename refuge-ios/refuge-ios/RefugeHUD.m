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

static NSTimeInterval const kHideSpeedFast = 1;
static NSTimeInterval const kHideSpeedModerate = 2;
static NSTimeInterval const kHideSpeedSlow = 5;

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
        
        self.state = RefugeHUDStateSyncing;
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
    if(self.state != RefugeHUDStateSyncing)
    {
        self.hud.mode = MBProgressHUDModeText;
    }
    
    self.hud.labelText = text;
}

# pragma mark - Public methods

- (void)hide:(RefugeHUDHideSpeed)speed
{
    NSTimeInterval hideSpeed;
    
    switch (speed) {
        case RefugeHUDHideSpeedFast:
            hideSpeed = kHideSpeedFast;
            break;
        case RefugeHUDHideSpeedModerate:
            hideSpeed = kHideSpeedModerate;
            break;
        case RefugeHUDHideSpeedSlow:
            hideSpeed = kHideSpeedSlow;
            break;
        default:
            hideSpeed = RefugeHUDHideSpeedModerate;
            break;
    }
    
    [self.hud hide:YES afterDelay:hideSpeed];
}

- (void)setErrorText:(NSString *)errorText forError:(NSError *)error
{
    [self setText:errorText];
    
    int errorCode = [error code];
    NSString *errorDescription = [[[[error userInfo] objectForKey:NSUnderlyingErrorKey] userInfo] objectForKey:NSLocalizedDescriptionKey];
    self.hud.detailsLabelText = [NSString stringWithFormat:@"Error Code: %i\nError Description: %@", errorCode, errorDescription];
    
    NSLog(@"%@", self.hud.detailsLabelText);
}

@end

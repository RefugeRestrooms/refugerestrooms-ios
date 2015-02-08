//
//  RefugeHUD.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RefugeHUDState)
{
    RefugeHUDStateSyncing,
    RefugeHUDStateSyncingComplete
};

@interface RefugeHUD : UIView

@property (nonatomic, assign) RefugeHUDState state;
@property (nonatomic, strong) NSString *text;

- (id)initWithView:(UIView *)view;

@end

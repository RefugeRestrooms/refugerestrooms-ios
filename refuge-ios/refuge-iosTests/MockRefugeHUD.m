//
//  MockRefugeHUD.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/9/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "MockRefugeHUD.h"

@implementation MockRefugeHUD

- (void)setErrorText:(NSString *)errorText forError:(NSError *)error
{
    self.wasAskedToDisplayError = YES;
}

@end

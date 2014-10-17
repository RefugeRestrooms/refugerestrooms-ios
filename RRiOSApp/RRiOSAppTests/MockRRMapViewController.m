//
//  MockRRMapViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/16/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "MockRRMapViewController.h"

@implementation MockRRMapViewController

- (void)didReceiveRestrooms:(NSArray *)restrooms
{
    self.restroomsList = restrooms;
}

- (NSArray *)receivedRestrooms
{
    return self.restroomsList;
}

@end

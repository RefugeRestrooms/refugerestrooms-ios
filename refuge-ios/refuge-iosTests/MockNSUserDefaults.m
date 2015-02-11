//
//  MockNSUserDefaults.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "MockNSUserDefaults.h"

@implementation MockNSUserDefaults

- (void)setObject:(id)value forKey:(NSString *)defaultName
{
    if([defaultName isEqualToString:@"RefugeAppStateDateLastSyncedKey"])
    {
        self.date = (NSDate *)value;
    }
}

- (BOOL)synchronize
{
    return YES;
}

@end

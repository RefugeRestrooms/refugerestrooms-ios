//
//  iRate+Refuge.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/19/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "iRate+Refuge.h"

static NSUInteger const kAppID = 968531953;

@implementation iRate (Refuge)

- (void)refugeSetup
{
    [iRate sharedInstance].appStoreID = kAppID;
    [iRate sharedInstance].daysUntilPrompt = 3; // number of days the user must have had the app installed before they are prompted to rate it
    [iRate sharedInstance].usesUntilPrompt = 3; // minimum number of times the user must launch the app before they are prompted to rate it
    [iRate sharedInstance].usesPerWeekForPrompt = 0; // average number of times the user must launch the app per week for the prompt to be shown
    [iRate sharedInstance].remindPeriod = 10; // how long in days the app should wait before reminding a user to rate after selcting "remind me later"
    [iRate sharedInstance].messageTitle = @"Enjoying REFUGE?"; // title displayed for the rating prompt
    [iRate sharedInstance].message = @"Rating REFUGE positively encourages others to use it. Leaving constructive comments helps improve it.";
    [iRate sharedInstance].updateMessage = @"REFUGE was updated! If you're still enjoying it or the improvements, please take a minute to rate."; // message to be used for users who have previously rated the app
    [iRate sharedInstance].cancelButtonLabel = @"No"; // button label for the button to dismiss the rating prompt without rating the app
    [iRate sharedInstance].rateButtonLabel = @"Yes! I'd like to rate it"; // button label for button to rate app
    [iRate sharedInstance].remindButtonLabel = @"Yes, I'd like to rate it later"; // button label for button to reminder for rating later
    [iRate sharedInstance].promptForNewVersionIfUserRated = YES; // because ratings are version-specific
    [iRate sharedInstance].onlyPromptIfLatestVersion = YES; // whether rating prompt to be displayed if the user is not running the latest version of the app
    [iRate sharedInstance].previewMode = NO; // whether rating prompt will always displayed on launch (for testing purposes)
}

@end

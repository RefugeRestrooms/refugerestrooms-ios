//
//  AppDelegate.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeAppDelegate.h"

#import <iRate.h>

static NSUInteger const kAppID = 968531953;

@interface RefugeAppDelegate ()

@end

@implementation RefugeAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configureRatingPrompt];
    
    NSDate *dateAppFirstUsed = [iRate sharedInstance].firstUsed;
    NSUInteger numTimesAppLaunched = [iRate sharedInstance].usesCount;
    BOOL hasDeclinedToRate = [iRate sharedInstance].declinedAnyVersion;
    BOOL hasRated = [iRate sharedInstance].ratedAnyVersion;
    NSLog(@"Date first used: %@", dateAppFirstUsed);
    NSLog(@"Num times current app version launched: %i", numTimesAppLaunched);
    NSLog(@"Has declined to rate: %i", hasDeclinedToRate);
    NSLog(@"Has rated: %i", hasRated);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.RefugeRestrooms.refuge_ios" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"refuge_ios" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"refuge_ios.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Private methods

- (void)configureRatingPrompt
{
    // TODO: Set appropriate iRate values before launch
    [iRate sharedInstance].appStoreID = kAppID;
    [iRate sharedInstance].daysUntilPrompt = 1; // number of days the user must have had the app installed before they are prompted to rate it
    [iRate sharedInstance].usesUntilPrompt = 2; // minimum number of times the user must launch the app before they are prompted to rate it
    [iRate sharedInstance].usesPerWeekForPrompt = 0; // average number of times the user must launch the app per week for the prompt to be shown
    [iRate sharedInstance].remindPeriod = 7; // how long in days the app should wait before reminding a user to rate after selcting "remind me later"
    [iRate sharedInstance].messageTitle = @"Enjoying REFUGE?"; // title displayed for the rating prompt
    [iRate sharedInstance].message = @"Rating REFUGE positively encourages others to use it. Leaving constructive comments helps improve it.";
    [iRate sharedInstance].updateMessage = @"REFUGE was updated! If you're still enjoying it or enjoy the improvements, take a minute to rate"; // message to be used for users who have previously rated the app
    [iRate sharedInstance].cancelButtonLabel = @"No"; // button label for the button to dismiss the rating prompt without rating the app
    [iRate sharedInstance].rateButtonLabel = @"Yes! I'd like to rate it"; // button label for button to rate app
    [iRate sharedInstance].remindButtonLabel = @"Yes, I'd like to rate it later"; // button label for button to reminder for rating later
    [iRate sharedInstance].promptForNewVersionIfUserRated = YES; // because ratings are version-specific
    [iRate sharedInstance].onlyPromptIfLatestVersion = YES; // whether rating prompt to be displayed if the user is not running the latest version of the app
    [iRate sharedInstance].previewMode = NO; // whether rating prompt will always displayed on launch (for testing purposes)
}

@end

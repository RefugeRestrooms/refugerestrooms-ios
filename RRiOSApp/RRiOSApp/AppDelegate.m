//
//  AppDelegate.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/26/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "AppDelegate.h"

#import "Constants.h"
#import "RestroomManager.h"

@interface AppDelegate ()
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // change navigation style
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:RRCOLOR_DARKPURPLE_RED green:RRCOLOR_DARKPURPLE_GREEN blue:RRCOLOR_DARKPURPLE_BLUE alpha:1.0]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           nil]
     ];
//    self.window.tintColor = [UIColor colorWithRed:RRCOLOR_LIGHTPURPLE_RED green:RRCOLOR_LIGHTPURPLE_GREEN blue:RRCOLOR_LIGHTPURPLE_BLUE alpha:1.0];
    

    // clear our Core Data for testing
//    [self resetApplicationModel];
    
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
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.refugerestrooms.RRiOSApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RRiOSApp" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RRiOSApp.sqlite"];
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

#pragma mark - Helper methods

// removes all traces of the Core Data store and then resets the application defaults
- (BOOL) resetApplicationModel
{
    // set flag for first-time use
    // [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kApplicationIsFirstTimeRunKey];
    
    NSError *error = nil;
//    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: ]];
    NSURL *storeURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", [[self applicationDocumentsDirectory] absoluteString], @"MyAppSQLStore.sqlite"]];
    NSPersistentStore *store = [_persistentStoreCoordinator persistentStoreForURL:storeURL];
    
    // Remove the SQL store and the file associated with it
    if ([_persistentStoreCoordinator removePersistentStore:store error:&error])
    {
        [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
    }
    
    if (error)
    {
        NSLog(@"Failed to remove persistent store: %@", [error localizedDescription]);
        
        NSArray *detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        
        if (detailedErrors != nil && [detailedErrors count] > 0)
        {
            for (NSError *detailedError in detailedErrors)
            {
                NSLog(@" DetailedError: %@", [detailedError userInfo]);
            }
        }
        else
        {
            NSLog(@" %@", [error userInfo]);
        }
        return NO;
    }
    
//    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
//    [managedObjectContext release], managedObjectContext = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectContext = nil;
    
    // Rebuild the application's managed object context
    [self managedObjectContext];
    [self persistentStoreCoordinator];
    
    // Repopulate Core Data defaults
//    [self setupModelDefaults];
    
    return YES;
}

@end

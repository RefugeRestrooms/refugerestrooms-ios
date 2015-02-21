//
//  RefugeDataPersistenceManager.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeDataPersistenceManager.h"

#import <CoreData/CoreData.h>
#import "RefugeAppDelegate.h"
#import "RefugeRestroom.h"

@interface RefugeDataPersistenceManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation RefugeDataPersistenceManager

# pragma mark - Initializers

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.managedObjectContext = ((RefugeAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    
    return self;
}

# pragma mark - Public methods

- (NSArray *)allRestrooms
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[RefugeRestroom managedObjectEntityName]];
    
    NSError *error = nil;
    NSArray *allRestrooms = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error)
    {
        [self.delegate retrievingAllRestroomsFailedWithError:error];
        
        return nil;
    }
    
    return allRestrooms;
}

- (void)saveRestrooms:(NSArray *)restrooms
{
    NSError *errorSavingRestrooms;
    
    for(RefugeRestroom *restroom in restrooms)
    {
        [MTLManagedObjectAdapter managedObjectFromModel:restroom
                                   insertingIntoContext:self.managedObjectContext
                                                  error:&errorSavingRestrooms];
        [self.managedObjectContext save:&errorSavingRestrooms];
    }
    
    if(errorSavingRestrooms)
    {
        [self.delegate savingRestroomsFailedWithError:errorSavingRestrooms];
    }
    else
    {
        [self.delegate didSaveRestrooms];
    }
}

@end

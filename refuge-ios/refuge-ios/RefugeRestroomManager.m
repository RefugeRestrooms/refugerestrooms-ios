//
//  RefugeRestroomManager.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomManager.h"

#import <CoreData/CoreData.h>
#import <MTLManagedObjectAdapter.h>
#import "RefugeCoreDataManager.h"
#import "RefugeRestroom.h"
#import "RefugeRestroomBuilder.h"
#import "RefugeRestroomCommunicator.h"
#import "RefugeRestroomEntity.h"
#import "RefugeRestroomManagerDelegate.h"

NSString *RefugeRestroomManagerErrorDomain = @"RefugeRestroomManagerErrorDomain";

@implementation RefugeRestroomManager

# pragma mark - Setters

- (void)setDelegate:(id<RefugeRestroomManagerDelegate>)delegate
{
    if((delegate != nil) && !([delegate conformsToProtocol:@protocol(RefugeRestroomManagerDelegate)]))
    {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delgate protocol" userInfo:nil] raise];
    }
    
    _delegate = delegate;
}

# pragma mark - Public methods

- (void)fetchRestrooms
{
    [self.restroomCommunicator searchForRestrooms];
}

# pragma mark RefugeRestroomCommunicatorDelegate methods

- (void)didReceiveRestroomsJsonObjects:(id)jsonObjects
{
    NSError *errorBuildingRestrooms;
    NSArray *restrooms = [self.restroomBuilder buildRestroomsFromJSON:jsonObjects error:&errorBuildingRestrooms];
    
    if(restrooms != nil)
    {
        NSError *errorSavingToCoreData;
        [self saveRestroomsToCoreData:restrooms error:errorSavingToCoreData];
        
        if(errorSavingToCoreData)
        {
            [self tellDelegateAboutSyncErrorWithCode:RefugeRestroomManagerSaveToCoreDataCode underlyingError:errorSavingToCoreData];
        }
        
        [self.delegate didReceiveRestrooms:restrooms];
    }
    else
    {
        [self tellDelegateAboutFetchErrorWithCode:RefugeRestroomManagerErrorRestroomsBuildCode underlyingError:errorBuildingRestrooms];
    }
}

- (void)searchingForRestroomsFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain:RefugeRestroomManagerErrorDomain code:RefugeRestroomManagerErrorRestroomsFetchCode userInfo:errorInfo];
    
    [self.delegate fetchingRestroomsFailedWithError:reportableError];
}

# pragma mark - Private methods

- (void)saveRestroomsToCoreData:(NSArray *)restrooms error:(NSError *)error
{
    NSManagedObjectContext *managedObjectContext = [[RefugeCoreDataManager sharedInstance] mainManagedObjectContext];
    
    for(RefugeRestroom *restroom in restrooms)
    {
        
        [MTLManagedObjectAdapter managedObjectFromModel:restroom
                                   insertingIntoContext:managedObjectContext
                                                  error:&error];
        [managedObjectContext save:&error];
    }
}

- (void)tellDelegateAboutFetchErrorWithCode:(NSInteger)errorCode underlyingError:(NSError *)underlyingError
{
    NSDictionary *errorInfo = nil;
    
    if (underlyingError)
    {
        errorInfo = [NSDictionary dictionaryWithObject:underlyingError forKey: NSUnderlyingErrorKey];
    }
    
    NSError *reportableError = [NSError errorWithDomain:RefugeRestroomManagerErrorDomain code:errorCode userInfo:errorInfo];
    
    [self.delegate fetchingRestroomsFailedWithError:reportableError];
}

- (void)tellDelegateAboutSyncErrorWithCode:(NSInteger)errorCode underlyingError:(NSError *)underlyingError
{
    NSDictionary *errorInfo = nil;
    
    if (underlyingError)
    {
        errorInfo = [NSDictionary dictionaryWithObject:underlyingError forKey: NSUnderlyingErrorKey];
    }
    
    NSError *reportableError = [NSError errorWithDomain:RefugeRestroomManagerErrorDomain code:errorCode userInfo:errorInfo];
    
    [self.delegate syncingRestroomsFailedWithError:reportableError];
}

@end

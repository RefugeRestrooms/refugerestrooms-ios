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
#import "RefugeDataPersistenceManager.h"
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

- (void)fetchRestroomsFromAPI
{
    [self.restroomCommunicator searchForRestrooms];
}

- (NSArray *)restroomsFromLocalStore
{
    return [self.dataPersistenceManager allRestrooms];
}

# pragma mark RefugeRestroomCommunicatorDelegate methods


- (void)didReceiveRestroomsJsonObjects:(id)jsonObjects
{
    NSError *errorBuildingRestrooms;
    NSArray *restrooms = [self.restroomBuilder buildRestroomsFromJSON:jsonObjects error:&errorBuildingRestrooms];
    
    if(restrooms != nil)
    {
        [self.dataPersistenceManager saveRestrooms:restrooms];
    }
    else
    {
        [self tellDelegateAboutFetchErrorWithCode:RefugeRestroomManagerErrorRestroomsBuildCode underlyingError:errorBuildingRestrooms];
    }
}

- (void)retrievingAllRestroomsFailedWithError:(NSError *)error
{
    [self.delegate fetchingRestroomsFromLocalStoreFailedWithError:error];
}

- (void)searchingForRestroomsFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain:RefugeRestroomManagerErrorDomain code:RefugeRestroomManagerErrorRestroomsFetchCode userInfo:errorInfo];
    
    [self.delegate fetchingRestroomsFromApiFailedWithError:reportableError];
}

# pragma mark RefugeDataPeristenceManagerDelegate methods

- (void)didSaveRestrooms
{
    [self.delegate didFetchRestrooms];
}

- (void)savingRestroomsFailedWithError:(NSError *)error
{
    [self tellDelegateAboutSyncErrorWithCode:RefugeRestroomManagerErrorRestroomsSaveCode underlyingError:error];
}

# pragma mark - Private methods

- (void)tellDelegateAboutFetchErrorWithCode:(NSInteger)errorCode underlyingError:(NSError *)underlyingError
{
    NSDictionary *errorInfo = nil;
    
    if (underlyingError)
    {
        errorInfo = [NSDictionary dictionaryWithObject:underlyingError forKey: NSUnderlyingErrorKey];
    }
    
    NSError *reportableError = [NSError errorWithDomain:RefugeRestroomManagerErrorDomain code:errorCode userInfo:errorInfo];
    
    [self.delegate fetchingRestroomsFromApiFailedWithError:reportableError];
}

- (void)tellDelegateAboutSyncErrorWithCode:(NSInteger)errorCode underlyingError:(NSError *)underlyingError
{
    NSDictionary *errorInfo = nil;
    
    if (underlyingError)
    {
        errorInfo = [NSDictionary dictionaryWithObject:underlyingError forKey: NSUnderlyingErrorKey];
    }
    
    NSError *reportableError = [NSError errorWithDomain:RefugeRestroomManagerErrorDomain code:errorCode userInfo:errorInfo];
    
    [self.delegate savingRestroomsFailedWithError:reportableError];
}

@end

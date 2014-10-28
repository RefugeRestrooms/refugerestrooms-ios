//
//  RestroomManager.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomManager.h"
#import "RestroomManagerDelegate.h"
#import "Reachability.h"

@interface RestroomManager ()

- (void)tellDelegateAboutRestroomSearchError: (NSError *)underlyingError;

@end

@implementation RestroomManager

NSString *RestroomManagerSearchFailedError = @"RestroomManagerSearchFailedError";

+ (id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        RestroomCommunicator *restroomCommunicator = [[RestroomCommunicator alloc] init];
        RestroomBuilder *restroomBuilder = [[RestroomBuilder alloc] init];
        
        self.restroomCommunicator = restroomCommunicator;
        self.restroomCommunicator.delegate = self;
        self.restroomBuilder = restroomBuilder;
    }
    
    return self;
}

- (void)setDelegate:(id<RestroomManagerDelegate>)newDelegate
{
    if (newDelegate && ![newDelegate conformsToProtocol: @protocol(RestroomManagerDelegate)])
    {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol." userInfo: nil] raise];
    }
    
    _delegate = newDelegate;
}

- (void)fetchRestroomsForQuery:(NSString *)query
{
    [self.restroomCommunicator searchForRestroomsWithQuery:query];
}

- (void)fetchRestroomsOfAmount:(NSInteger)numberRestrooms
{
    [self.restroomCommunicator searchForRestroomsOfAmount:numberRestrooms];
}

- (void)fetchNewRestrooms
{
    [self.restroomCommunicator searchForNewRestrooms];
}

- (void)receivedRestroomsJSONString:(NSString *)jsonString
{
    NSError *error = nil;
    
    //build restrooms from JSON
    NSArray *restrooms = [self.restroomBuilder restroomsFromJSON:jsonString error:&error];
    
    if(!restrooms)
    {
        // underlying error
        [self searchingForRestroomsFailedWithError:error];
    }
    else
    {
        [self.delegate didReceiveRestrooms:restrooms];
    }
}


- (void)searchingForRestroomsFailedWithError:(NSError *)error
{
    [self tellDelegateAboutRestroomSearchError:error];
}

#pragma mark - Helper methods

- (void)tellDelegateAboutRestroomSearchError:(NSError *)underlyingError
{
    NSDictionary *errorInfo = nil;
    
    if (underlyingError)
    {
        errorInfo = [NSDictionary dictionaryWithObject:underlyingError forKey:NSUnderlyingErrorKey];
    }
    
    NSError *reportableError = [NSError errorWithDomain:RestroomManagerSearchFailedError code:RestroomManagerErrorSearchCode userInfo:errorInfo];

    [self.delegate fetchingRestroomsFailedWithError:reportableError];
}

@end
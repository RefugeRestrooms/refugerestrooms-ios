//
//  RefugeRestroomCommunicator.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomCommunicator.h"

#import <AFNetworking.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "RefugeAppState.h"
#import "RefugeHTTPSessionManager.h"
#import "RefugeRestroomCommunicatorDelegate.h"

static NSInteger const kMaxRestroomsToFetch = 100;
static NSString * const kApiBaseURL = @"http://www.refugerestrooms.org:80/api/v1/restrooms";
static NSString * const kApiEndPointRestroomsByDate = @"by_date.json";

@interface RefugeRestroomCommunicator ()

@property (nonatomic, strong) RefugeAppState *appState;

@end

@implementation RefugeRestroomCommunicator

# pragma mark - Initializers

- (id)initWithHttpSessionManager:(RefugeHTTPSessionManager *)httpSessionManager
{
    self = [super init];
    
    if(self)
    {
        _httpSessionManager = httpSessionManager;
        
        self.appState = [[RefugeAppState alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        RefugeHTTPSessionManager *httpSessionManager = [[RefugeHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kApiBaseURL]];
        
        return [self initWithHttpSessionManager:httpSessionManager];
    }
    
    return nil;
}

# pragma mark Setters

- (void)setDelegate:(id<RefugeRestroomCommunicatorDelegate>)delegate
{
    if((delegate != nil) && !([delegate conformsToProtocol:@protocol(RefugeRestroomCommunicatorDelegate)]))
    {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delgate protocol" userInfo:nil] raise];
    }
    
    _delegate = delegate;
}

# pragma mark - Public methods

- (void)searchForRestrooms
{
    NSDate *dateLastSynced = self.appState.dateLastSynced;
    
    int day = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:dateLastSynced] day];
    int month = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:dateLastSynced] month];
    int year = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateLastSynced] year];
    
    NSString *endPoint = [NSString stringWithFormat:@"%@?per_page=%li&day=%i&month=%i&year=%i", kApiEndPointRestroomsByDate, (long)kMaxRestroomsToFetch, day, month, year];
    NSDictionary *httpSessionParameters =  @{ @"format": @"json" };
    
    [self.httpSessionManager GET:endPoint parameters:httpSessionParameters
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         [self.delegate didReceiveRestroomsJsonObjects:responseObject];
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         [self.delegate searchingForRestroomsFailedWithError:error];
                     }
     ];
}

@end

//
//  RefugeRestroomCommunicator.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomCommunicator.h"

#import <AFNetworking.h>
#import "RefugeRestroomCommunicatorDelegate.h"

static NSInteger const kMaxRestroomsToFetch = 10000;
static NSString * const kApiBaseURL = @"http://www.refugerestrooms.org:80/api/v1/restrooms";
static NSString * const kApiEndPointRestroomsByDate = @"by_date.json";

@interface RefugeRestroomCommunicator ()

@property (nonatomic, strong)  AFHTTPSessionManager *httpSessionManager;

@end

@implementation RefugeRestroomCommunicator

# pragma mark - Initializers

- (id)initWithHttpSessionManager:(AFHTTPSessionManager *)httpSessionManager
{
    self = [super init];
    
    if(self)
    {
        _httpSessionManager = httpSessionManager;
        _httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kApiBaseURL]];
        
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
//    int day = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date] day];
//    int month = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date] month];
//    int year = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
    
    int day = 1;
    int month = 1;
    int year = 2015;
    
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

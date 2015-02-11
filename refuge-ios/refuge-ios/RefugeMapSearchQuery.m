//
//  RefugeMapSearchQuery.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/10/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMapSearchQuery.h"

#import <CoreLocation/CoreLocation.h>
#import <SPGooglePlacesAutocomplete/SPGooglePlacesAutocomplete.h>

static NSString * const kApiKey = @"API_KEY";
static CLLocationDistance const kSearchQueryRadius = 100.0;

@interface RefugeMapSearchQuery ()

@property (nonatomic, strong) SPGooglePlacesAutocompleteQuery *searchQuery;

@end

@implementation RefugeMapSearchQuery

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        self.searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
        self.searchQuery.key = kApiKey;
        self.searchQuery.radius = kSearchQueryRadius;
    }
    
    return self;
}

@end

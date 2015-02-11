//
//  RefugeMapSearchQuery.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/10/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMapSearchQuery.h"

#import <CoreLocation/CoreLocation.h>
#import "RefugeMapPlace.h"
#import <SPGooglePlacesAutocomplete/SPGooglePlacesAutocomplete.h>

static NSString * const kApiKey = @"AIzaSyAKV9gg_l1jNL8Pep7FIwwI6FQ84ldsEKI";
static CLLocationDistance const kSearchQueryRadius = 100.0;

@interface RefugeMapSearchQuery ()

@property (nonatomic, strong) SPGooglePlacesAutocompleteQuery *searchQuery;

@end

@implementation RefugeMapSearchQuery

# pragma mark - Initializers

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

# pragma mark - Public methods

- (void)searchForPlaces:(NSString *)searchString success:(void (^)(NSArray *))searchSuccess failure:(void (^)(NSError *))searchError
{
    self.searchQuery.input = searchString;
    
    [self.searchQuery fetchPlaces:^(NSArray *places, NSError *error)
     {
         if (error)
         {
             searchError(error);
         }
         else
         {
             NSArray *refugeMapPlaces = [self translateToRefugePlaces:places];
             
             searchSuccess(refugeMapPlaces);
         }
     }];
}

# pragma mark - Private methods

- (NSArray *)translateToRefugePlaces:(NSArray *)places
{
    NSMutableArray *array = [NSMutableArray array];
    
    for(SPGooglePlacesAutocompletePlace *place in places)
    {
        RefugeMapPlace *refugeMapPlace = [[RefugeMapPlace alloc] init];
        
        refugeMapPlace.name = place.name;
        refugeMapPlace.reference = place.reference;
        refugeMapPlace.identifier = place.identifier;
        refugeMapPlace.key = place.key;
        
        if(place.type == SPPlaceTypeGeocode)
        {
            refugeMapPlace.type = RefugeMapPlaceTypeGeocode;
        }
        else
        {
            refugeMapPlace.type = RefugeMapPlaceTypeEstablishment;
        }
        
        [array addObject:refugeMapPlace];
    }
    
    return [array copy];
}

@end

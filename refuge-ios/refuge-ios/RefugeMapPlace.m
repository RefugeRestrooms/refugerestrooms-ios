//
//  RefugeMapPlace.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/10/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMapPlace.h"

#import <SPGooglePlacesAutocomplete/SPGooglePlacesAutocomplete.h>

@interface RefugeMapPlace ()

@property (nonatomic, strong) SPGooglePlacesAutocompletePlace *place;

@end

#pragma mark - Initializers

@implementation RefugeMapPlace

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        self.place = [[SPGooglePlacesAutocompletePlace alloc] init];
    }
    
    return self;
}

# pragma mark - Public methods

- (void)toPlacemarkWithSuccessBlock:(void (^)(CLPlacemark *))placemarkSuccess failure:(void (^)(NSError *))placemarkError
{
    SPGooglePlacesAutocompletePlace *place = [self translateToSPPlace];
    
    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
        if(error)
        {
            placemarkError(error);
        }
        else
        {
            placemarkSuccess(placemark);
        }
    }];
    
}

# pragma mark - Private methods

- (SPGooglePlacesAutocompletePlace *)translateToSPPlace
{
    NSString *typeString = [self typeToString];
    
    NSDictionary *dictionary = @{
                                 @"description" : self.name,
                                 @"reference" : self.reference,
                                 @"id" : self.identifier,
                                 @"types" : typeString
                                 };
    
    SPGooglePlacesAutocompletePlace *place = [SPGooglePlacesAutocompletePlace placeFromDictionary:dictionary apiKey:self.key];
    
    return place;
}

- (NSString *)typeToString
{
    if(self.type == RefugeMapPlaceTypeGeocode)
    {
        return @"geocode";
    }
    else
    {
        return @"establishment";
    }
}

@end

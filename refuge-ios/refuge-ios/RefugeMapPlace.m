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

@end

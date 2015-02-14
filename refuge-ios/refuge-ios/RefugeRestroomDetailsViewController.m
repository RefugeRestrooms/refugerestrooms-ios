//
//  RefugeRestroomDetailsViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomDetailsViewController.h"

#import <Mantle/Mantle.h>
#import "RefugeRestroom.h"
#import "UIColor+Refuge.h"

static NSString * const kImageNameCharacteristicUnisex = @"refuge-details-unisex.png";
static NSString * const kImageNameCharacteristicAccessible = @"refuge-details-accessible.png";

@interface RefugeRestroomDetailsViewController ()

@property (nonatomic, assign) RefugeRestroomRatingType restroomRatingType;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailsLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *characteristicImage1;
@property (weak, nonatomic) IBOutlet UIImageView *characteristicImage2;
@property (weak, nonatomic) IBOutlet UITextView *directionsTextField;

@end

# pragma mark - View life-cycle

@implementation RefugeRestroomDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.restroomRatingType = [RefugeRestroom ratingTypeForRating:self.restroom.ratingNumber];
    
    [self setDetails];
}

# pragma mark - Private methods

- (void)setDetails
{
    self.nameLabel.text = self.restroom.name;
    self.streetLabel.text = self.restroom.street;
    self.addressDetailsLabel.text = [NSString stringWithFormat:@"%@, %@, %@", self.restroom.city, self.restroom.state, self.restroom.country];
    self.ratingView.backgroundColor = [self ratingColor];
    self.ratingLabel.text = [[self ratingString] uppercaseString];
    self.directionsTextField.backgroundColor = [UIColor clearColor];
    self.directionsTextField.text = self.restroom.directions;
    
    [self createCharacteristicsImages];
}

- (UIColor *)ratingColor
{
    UIColor *noRatingColor = [UIColor RefugeRatingNoneColor];
    
    switch (self.restroomRatingType)
    {
        case RefugeRestroomRatingTypeNegative:
            return [UIColor RefugeRatingNegativeColor];
            break;
        case RefugeRestroomRatingTypeNeutral:
            return noRatingColor;
            break;
        case RefugeRestroomRatingTypeNone:
            return [UIColor RefugeRatingNoneColor];
            break;
        case RefugeRestroomRatingTypePositive:
            return [UIColor RefugeRatingPositiveColor];
            break;
        default:
            return noRatingColor;
            break;
    }
}

- (NSString *)ratingString
{
    int numUpvotes = [self.restroom.numUpvotes intValue];
    int numDownvotes = [self.restroom.numDownvotes intValue];
    int percentPositive = (numUpvotes / (numUpvotes + numDownvotes)) * 100;
    
    switch (self.restroomRatingType) {
        case RefugeRestroomRatingTypeNone:
            return @"Not Yet Rated";
            break;
        default:
            return [NSString stringWithFormat:@"%i%% positive", percentPositive];
            break;
    }
}

- (void)createCharacteristicsImages
{
    BOOL isUnisex = [self.restroom.isUnisex boolValue];
    BOOL isAccessible = [self.restroom.isAccessible boolValue];
    UIImage *imageUnisex = [UIImage imageNamed:kImageNameCharacteristicUnisex];
    UIImage *imageAccessible = [UIImage imageNamed:kImageNameCharacteristicAccessible];
    
    if(isUnisex && isAccessible)
    {
        self.characteristicImage1.image = imageUnisex;
        self.characteristicImage2.image = imageAccessible;
    }
    else if(isUnisex && !isAccessible)
    {
        self.characteristicImage1.image = imageUnisex;
        self.characteristicImage2.image = nil;
    }
    else if(!isUnisex && isAccessible)
    {
        self.characteristicImage1.image = imageAccessible;
        self.characteristicImage2.image = nil;
    }
    else
    {
        self.characteristicImage1.image = nil;
        self.characteristicImage2.image = nil;
    }
}

@end

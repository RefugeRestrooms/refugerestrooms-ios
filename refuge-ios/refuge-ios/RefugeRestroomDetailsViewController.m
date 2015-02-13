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

@interface RefugeRestroomDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailsLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

# pragma mark - View life-cycle

@implementation RefugeRestroomDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDetails];
}

# pragma mark - Private methods

- (void)setDetails
{
    self.nameLabel.text = self.restroom.name;
    self.streetLabel.text = self.restroom.street;
    self.addressDetailsLabel.text = [NSString stringWithFormat:@"%@, %@, %@", self.restroom.city, self.restroom.state, self.restroom.country];
    self.ratingView.backgroundColor = [self ratingColor];
    self.ratingLabel.text = @"RATING TEXT";
}

- (UIColor *)ratingColor
{
    RefugeRestroomRatingType ratingType = [RefugeRestroom ratingTypeForRating:self.restroom.rating];
    
    switch (ratingType) {
        case RefugeRestroomRatingTypeNegative:
            return [UIColor RefugeRatingNegativeColor];
            break;
        case RefugeRestroomRatingTypeNeutral:
            return [UIColor RefugeRatingNeutralColor];
            break;
        case RefugeRestroomRatingTypeNone:
            return [UIColor RefugeRatingNoneColor];
            break;
        case RefugeRestroomRatingTypePositive:
            return [UIColor RefugeRatingPositiveColor];
            break;
        default:
            return [UIColor RefugeRatingNoneColor];
            break;
    }
}

@end

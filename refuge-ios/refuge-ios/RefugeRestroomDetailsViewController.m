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
    int rating = [self.restroom.rating intValue];
    
    switch (rating) {
        case 0:
            return [UIColor RefugeRatingNegativeColor];
            break;
        case 1:
            return [UIColor RefugeRatingNeutralColor];
            break;
        case 2:
            return [UIColor RefugeRatingNoneColor];
            break;
        case 3:
            return [UIColor RefugeRatingPositiveColor];
            break;
        default:
            return [UIColor RefugeRatingNoneColor];
            break;
    }
}

@end

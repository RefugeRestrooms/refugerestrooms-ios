//
//  RefugeRestroomDetailsViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomDetailsViewController.h"

# import "RefugeRestroom.h"
#import "UIColor+Refuge.h"

@interface RefugeRestroomDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailsLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingView;

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
}

- (UIColor *)ratingColor
{
    int numUpvotes = self.restroom.numUpvotes;
    int numDownvotes = self.restroom.numDownvotes;
    
    if((numUpvotes == 0) && (numDownvotes == 0))
    {
        return [UIColor RefugeRatingNoneColor];
    }
    
    int percentPositive = (self.restroom.numUpvotes / (self.restroom.numUpvotes + self.restroom.numDownvotes)) * 100;
    
    if(percentPositive > 50)
    {
        return [UIColor RefugeRatingPositiveColor];
    }
    else
    {
        return [UIColor RefugeRatingNegativeColor];
    }
}

@end

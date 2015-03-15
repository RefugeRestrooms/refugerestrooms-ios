//
//  RefugeRestroomDetailsViewController.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomDetailsViewController.h"

#import "RefugeRestroom.h"
#import "UIColor+Refuge.h"
#import "UIDevice+Hardware.h"

static NSString * const kImageNameCharacteristicUnisex = @"refuge-details-unisex.png";
static NSString * const kImageNameCharacteristicAccessible = @"refuge-details-accessible.png";
static NSString * const kTextFieldFontName = @"HelveticaNeue";
static NSString * const kTextFieldPlaceholderNoDirections = @"No directions";
static NSString * const kTextFieldPlaceholderNoComments = @"No comments";

@interface RefugeRestroomDetailsViewController ()

@property (nonatomic, assign) RefugeRestroomRatingType restroomRatingType;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailsLabel;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *characteristicImage1;
@property (weak, nonatomic) IBOutlet UIImageView *characteristicImage2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;
@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *directionsTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restroomNameLabelLeadingAlignmentConstraint;

@end

# pragma mark - View life-cycle

@implementation RefugeRestroomDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.restroomRatingType = [RefugeRestroom ratingTypeForRating:self.restroom.ratingNumber];
    
    [self setDetails];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self styleTextFields];
    [self setupUI];
}

# pragma mark - Private methods

- (void)setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ratingView.layer.cornerRadius = 5.0f;
    
    if(![self.restroom.isUnisex boolValue] && ![self.restroom.isAccessible boolValue])
    {
        self.restroomNameLabelLeadingAlignmentConstraint.constant += self.imagesView.bounds.size.width;
    }
    
    [self adjustUIForDevice];
}

- (void)adjustUIForDevice
{
    if([self isDeviceiPhone4])
    {
        self.directionsTextViewHeightConstraint.constant = 50;
        self.commentsTextViewHeightConstraint.constant = 50;
    }
}

- (BOOL)isDeviceiPhone4
{
    UIDevicePlatform devicePlatform = [[UIDevice currentDevice] platformType];
    
    return (devicePlatform == UIDevice4iPhone || devicePlatform == UIDevice4SiPhone);
}

- (void)setDetails
{
    self.nameLabel.text = self.restroom.name;
    self.streetLabel.text = self.restroom.street;
    self.addressDetailsLabel.text = [NSString stringWithFormat:@"%@, %@, %@", self.restroom.city, self.restroom.state, self.restroom.country];
    self.ratingView.backgroundColor = [self ratingColor];
    self.ratingLabel.text = [[self ratingString] uppercaseString];
    self.directionsTextView.backgroundColor = [UIColor clearColor];
    self.directionsTextView.text = [self.restroom.directions isEqualToString:@""] ? kTextFieldPlaceholderNoDirections: self.restroom.directions;
    self.commentsTextField.text = [self.restroom.comment isEqualToString:@""] ? kTextFieldPlaceholderNoComments : self.restroom.comment;
    
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
    int sumVotes = numUpvotes + numDownvotes;
    int percentPositive = 0;
    
    if(sumVotes > 0)
    {
        percentPositive = (numUpvotes / sumVotes) * 100;
    }
    
    switch (self.restroomRatingType) {
        case RefugeRestroomRatingTypeNone:
            return @"Not yet rated";
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

- (void)styleTextFields
{
    UIFont *font = [UIFont fontWithName:kTextFieldFontName size:16.0];
    
    self.directionsTextView.font = font;
    self.directionsTextView.textColor = [UIColor RefugePurpleDarkColor];
    
    self.commentsTextField.font = font;
    self.commentsTextField.textColor = [UIColor RefugePurpleDarkColor];
}

@end

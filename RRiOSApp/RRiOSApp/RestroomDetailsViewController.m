//
//  RestroomDetailsViewController.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/6/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "UIKit/UIKit.h"

#import "Constants.h"
#import "Restroom.h"
#import "RestroomDetailsViewController.h"

@interface RestroomDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@end

@implementation RestroomDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // navigation bar styling
    self.title = self.restroom.name;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    int numUpvotes = [self.restroom.numUpvotes intValue];
    int numDownvotes = [self.restroom.numDownvotes intValue];
    int numVotes = numUpvotes + numDownvotes;
    
    // set details
    self.addressLabel.text = [NSString stringWithFormat:@"%@", self.restroom.street];
    self.ratingLabel.text = (numVotes > 0) ? [NSString stringWithFormat:@"%i%% Positive", (numUpvotes / (numUpvotes + numDownvotes)) * 100 ] : RRCONSTANTS_NO_RATING_TEXT;
    self.directionsLabel.text = self.restroom.directions;
    self.commentsLabel.text = self.restroom.comment;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // background
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    UIImage *backgroundImage = [self scaleWithAspectRatioImageNamed:RRCONSTANTS_DETAILS_BACKGROUND_IMAGE_NAME scaledToWidth:screenWidth];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [self.view addSubview: backgroundImageView];
}

#pragma mark - Helper methods

- (UIImage*)scaleWithAspectRatioImageNamed:(NSString *)imageName scaledToWidth: (float)width
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    float originalWidth = image.size.width;
    float scaleFactor = width / originalWidth;
    
    float newHeight = image.size.height * scaleFactor;
    float newWidth = originalWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

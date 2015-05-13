//
// RefugeRestroomDetailsViewController.m
//
// Copyleft (c) 2015 Refuge Restrooms
//
// Refuge is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// This notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RefugeRestroomDetailsViewController.h"

#import "RefugeRestroom.h"
#import "NSString+Refuge.h"
#import "UIColor+Refuge.h"

static NSString *const kRefugeImageNameCharacteristicUnisex = @"refuge-details-unisex.png";
static NSString *const kRefugeImageNameCharacteristicAccessible = @"refuge-details-accessible.png";
static NSString *const kRefugeTextFieldFontName = @"HelveticaNeue";
static NSString *const kRefugeTextFieldPlaceholderNoDirections = @"No directions";
static NSString *const kRefugeTextFieldPlaceholderNoComments = @"No comments";

@interface RefugeRestroomDetailsViewController ()

@property (nonatomic, assign) RefugeRestroomRatingType restroomRatingType;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailsLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *characteristicImage1;
@property (weak, nonatomic) IBOutlet UIImageView *characteristicImage2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;
@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *directionsTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeadingAlignmentConstraint;

@end

#pragma mark - View life-cycle

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
    
    [self setupUI];
}

#pragma mark - Private methods

- (void)setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ratingView.layer.cornerRadius = 5.0f;
    
    [self styleTextFields];
    [self centerHeaderTextIfNoImages];
}

- (void)styleTextFields
{
    UIFont *font = [UIFont fontWithName:kRefugeTextFieldFontName size:16.0];
    
    self.directionsTextView.font = font;
    self.directionsTextView.textColor = [UIColor RefugePurpleDarkColor];
    
    self.commentsTextView.font = font;
    self.commentsTextView.textColor = [UIColor RefugePurpleDarkColor];
    
    CGSize maximumTextViewSize = CGSizeMake(self.directionsTextView.bounds.size.width, CGFLOAT_MAX);
    CGRect rectNeededForDirections = [self.directionsTextView.text
        boundingRectWithSize:maximumTextViewSize
                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                  attributes:@{
                      NSFontAttributeName : font
                  } context:nil];
    CGRect rectNeededForComments = [self.commentsTextView.text
        boundingRectWithSize:maximumTextViewSize
                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                  attributes:@{
                      NSFontAttributeName : font
                  } context:nil];
    CGFloat textPadding = font.lineHeight * 3; // Text can get cut-off without adjustment
    
    self.directionsTextViewHeightConstraint.constant = rectNeededForDirections.size.height + textPadding;
    self.commentsTextViewHeightConstraint.constant = rectNeededForComments.size.height + textPadding;
}

- (void)centerHeaderTextIfNoImages
{
    if (![self.restroom.isUnisex boolValue] && ![self.restroom.isAccessible boolValue]) {
        [self.nameLabel removeConstraint:self.nameLabelLeadingAlignmentConstraint];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:0
                                                                 toItem:self.nameLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0]];
    }
}

- (void)setDetails
{
    self.nameLabel.text = [self.restroom.name RefugePrepareForDisplay];
    self.streetLabel.text = [self.restroom.street RefugePrepareForDisplay];
    self.addressDetailsLabel.text = [[NSString stringWithFormat:@"%@, %@, %@",
                                                                self.restroom.city,
                                                                self.restroom.state,
                                                                self.restroom.country] RefugePrepareForDisplay];
    self.ratingView.backgroundColor = [self ratingColor];
    self.ratingLabel.text = [[self ratingString] uppercaseString];
    self.directionsTextView.backgroundColor = [UIColor clearColor];
    self.directionsTextView.text = [self.restroom.directions isEqualToString:@""]
                                       ? kRefugeTextFieldPlaceholderNoDirections
                                       : [self.restroom.directions RefugePrepareForDisplay];
    self.commentsTextView.text = [self.restroom.comment isEqualToString:@""]
                                     ? kRefugeTextFieldPlaceholderNoComments
                                     : [self.restroom.comment RefugePrepareForDisplay];
                                     
    [self createCharacteristicsImages];
}

- (UIColor *)ratingColor
{
    UIColor *noRatingColor = [UIColor RefugeRatingNoneColor];
    
    switch (self.restroomRatingType) {
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
    
    if (sumVotes > 0) {
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
    UIImage *imageUnisex = [UIImage imageNamed:kRefugeImageNameCharacteristicUnisex];
    UIImage *imageAccessible = [UIImage imageNamed:kRefugeImageNameCharacteristicAccessible];
    
    if (isUnisex && isAccessible) {
        self.characteristicImage1.image = imageUnisex;
        self.characteristicImage2.image = imageAccessible;
    } else if (isUnisex && !isAccessible) {
        self.characteristicImage1.image = imageUnisex;
        self.characteristicImage2.image = nil;
    } else if (!isUnisex && isAccessible) {
        self.characteristicImage1.image = imageAccessible;
        self.characteristicImage2.image = nil;
    } else {
        self.characteristicImage1.image = nil;
        self.characteristicImage2.image = nil;
    }
}

@end

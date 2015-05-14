//
// RefugeInfoViewController.m
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

#import "RefugeInfoViewController.h"

#import "Mixpanel+Refuge.h"

NSString *RefugeInfoViewErrorDomain = @"RefugeInfoViewErrorDomain";
static NSInteger const kRefugeInfoErrorCode = 0;

static NSString *const kRefugeGithubLinkName = @"https://github.com/RefugeRestrooms/refuge-iOS";
static NSString *const kRefugeFacebookLinkName = @"https://www.facebook.com/refugerestrooms";
static NSString *const kRefugeTwittetLinkName = @"https://twitter.com/refugerestrooms";

@interface RefugeInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *githubImage;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;

@end

@implementation RefugeInfoViewController

#pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addGestureRecognizersToImages];
}

#pragma mark - Touch

- (void)didTouchGithubImage
{
    [self openLinkWithName:kRefugeGithubLinkName];
}

- (void)didTouchFacebookImage
{
    [self openLinkWithName:kRefugeFacebookLinkName];
}

- (void)didTouchTwitterImage
{
    [self openLinkWithName:kRefugeTwittetLinkName];
}

#pragma mark - Private methods

- (void)addGestureRecognizersToImages
{
    UITapGestureRecognizer *githubGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchGithubImage)];
    [self.githubImage addGestureRecognizer:githubGestureRecognizer];
    
    UITapGestureRecognizer *facebookGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchFacebookImage)];
    [self.facebookImage addGestureRecognizer:facebookGestureRecognizer];
    
    UITapGestureRecognizer *twitterGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchTwitterImage)];
    [self.twitterImage addGestureRecognizer:twitterGestureRecognizer];
}

- (void)openLinkWithName:(NSString *)linkName
{
    NSURL *url = [NSURL URLWithString:linkName];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        [self reportErrorOpeningLinkWithName:linkName];
    }
}

- (void)reportErrorOpeningLinkWithName:(NSString *)linkName
{
    NSDictionary *userInfo =
        @{ NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Could not open link: %@", linkName] };
    NSError *error = [NSError errorWithDomain:RefugeInfoViewErrorDomain code:kRefugeInfoErrorCode userInfo:userInfo];
    
    [[Mixpanel sharedInstance] refugeTrackError:error ofType:RefugeMixpanelErrorTypeOpeningLinkFailed];
}

@end

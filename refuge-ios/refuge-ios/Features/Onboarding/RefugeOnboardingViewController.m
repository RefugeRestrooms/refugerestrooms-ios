//
// RefugeOnboardingViewController.m
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

#import "RefugeOnboardingViewController.h"

#import <EAIntroView/EAIntroView.h>
#import "UIColor+Refuge.h"

static NSString *const kRefugeSegueNameDismissOnboarding = @"RefugeRestroomDissmissOnboardingSegue";
static NSString *const kRefugeOnboardPageName1 = @"RefugeOnboardPage1";
static NSString *const kRefugeOnboardPageName2 = @"RefugeOnboardPage2";
static NSString *const kRefugeOnboardPageName3 = @"RefugeOnboardPage3";
static NSString *const kRefugeOnboardPageName4 = @"RefugeOnboardPage4";

@interface RefugeOnboardingViewController ()

@property (nonatomic, strong) EAIntroView *onboardingView;

@end

@implementation RefugeOnboardingViewController

#pragma mark - View life-cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *pages = [self createPages];
    self.onboardingView = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:pages];
    [self styleOnboardingView];
    self.onboardingView.delegate = self;
    
    [self.onboardingView showInView:self.view animateDuration:0.3];
}

#pragma mark - Public methods

#pragma mark EAIntroViewDelegate methods

- (void)introDidFinish:(EAIntroView *)introView
{
    [self performSegueWithIdentifier:kRefugeSegueNameDismissOnboarding sender:self];
}

#pragma mark - Private methods

- (NSArray *)createPages
{
    EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:kRefugeOnboardPageName1];
    EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:kRefugeOnboardPageName2];
    EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:kRefugeOnboardPageName3];
    EAIntroPage *page4 = [EAIntroPage pageWithCustomViewFromNibNamed:kRefugeOnboardPageName4];
    
    return @[ page1, page2, page3, page4 ];
}

- (void)styleOnboardingView
{
    self.onboardingView.pageControl.currentPageIndicatorTintColor = [UIColor RefugePurpleDarkColor];
    self.onboardingView.pageControl.pageIndicatorTintColor = [UIColor RefugePurpleMediumColor];
    self.onboardingView.skipButton.hidden = YES;
}

// makes status bar white
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

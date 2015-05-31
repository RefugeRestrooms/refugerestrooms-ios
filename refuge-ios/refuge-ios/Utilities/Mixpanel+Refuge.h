//
// Mixpanel+Refuge.h
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

#import "Mixpanel.h"

@class CLPlacemark;

typedef NS_ENUM(NSInteger, RefugeMixpanelErrorType) {
    RefugeMixpanelErrorTypeLocationManagerFailed,
    RefugeMixpanelErrorTypeFetchingRestroomsFailed,
    RefugeMixpanelErrorTypeSavingRestroomsFailed,
    RefugeMixpanelErrorTypeResolvingPlacemarkFailed,
    RefugeMixpanelErrorTypeSearchAttemptFailed,
    RefugeMixpanelErrorTypePreloadingRestrooms,
    RefugeMixpanelErrorTypeLocalStoreFetchFailed,
    RefugeMixpanelErrorTypeOpeningLinkFailed,
    RefugeMixpanelErrorTypeLoadingNewRestroomWebViewFailed
};

@class RefugeMapPin;

@interface Mixpanel (Refuge)

- (void)refugeRegisterSuperProperties;
- (void)refugeTrackAppLaunch;
- (void)refugeTrackError:(NSError *)error ofType:(RefugeMixpanelErrorType)errorType;
- (void)refugeTrackNewRestroomButtonTouched;
- (void)refugeTrackOnboardingCompleted;
- (void)refugeTrackRestroomDetailsViewed:(RefugeMapPin *)mapPin;
- (void)refugeTrackRestroomsPlotted:(NSUInteger)numRestroomsPlotted;
- (void)refugeTrackSearchWithString:(NSString *)searchString placemark:(CLPlacemark *)placemark;

@end

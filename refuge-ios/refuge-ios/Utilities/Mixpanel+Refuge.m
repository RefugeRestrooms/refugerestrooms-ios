//
// Mixpanel+Refuge.m
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

#import "Mixpanel+Refuge.h"

#import <CoreLocation/CoreLocation.h>
#import "iRate+Refuge.h"
#import "RefugeMapPin.h"
#import "RefugeRestroom.h"

#if DEBUG
static NSString *const kRefugePrefix = @"Test";
#else
static NSString *const kRefugePrefix = @"Refuge";
#endif

@implementation Mixpanel (Refuge)

#pragma mark - Public methods

- (void)refugeRegisterSuperProperties
{
    if ([self hasEverLaunchedApp]) {
        [[Mixpanel sharedInstance] registerSuperProperties:@{
            [NSString stringWithFormat:@"%@ Date First Launched", kRefugePrefix] : [iRate sharedInstance].firstUsed,
            [NSString stringWithFormat:@"%@ Number of Launches", kRefugePrefix] :
                [NSNumber numberWithInteger:[iRate sharedInstance].usesCount],
            [NSString stringWithFormat:@"%@ Has Declined to Rate", kRefugePrefix] :
                    ([iRate sharedInstance].declinedAnyVersion)
                ? @"Yes"
                : @"No",
            [NSString stringWithFormat:@"%@ Has Rated", kRefugePrefix] : ([iRate sharedInstance].ratedAnyVersion)
                ? @"Yes"
                : @"No"
        }];
    }
}

- (void)refugeTrackAppLaunch
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ App Launched", kRefugePrefix]];
}

- (void)refugeTrackError:(NSError *)error ofType:(RefugeMixpanelErrorType)errorType
{
    NSString *errorDomain = [error domain];
    NSString *errorDescription = [error localizedDescription];
    NSError *underlyingError = [[error userInfo] objectForKey:NSUnderlyingErrorKey];
    
    NSString *underlyingErrorDomain = @"";
    NSString *underlyingErrorCode = @"";
    
    if (underlyingError) {
        underlyingErrorDomain = [underlyingError domain];
        underlyingErrorCode = [NSString stringWithFormat:@"%li", (long)[underlyingError code]];
    }
    
    [[Mixpanel sharedInstance]
             track:[NSString stringWithFormat:@"%@ Error Occurred", kRefugePrefix]
        properties:@{
            [NSString stringWithFormat:@"%@ Error Type", kRefugePrefix] : [self stringForErrorType:errorType],
            [NSString stringWithFormat:@"%@ Error Domain", kRefugePrefix] : (errorDomain == nil) ? @"" : errorDomain,
            [NSString stringWithFormat:@"%@ Error Description", kRefugePrefix] : (!errorDescription) ? @""
                                                                                                     : errorDescription,
            [NSString stringWithFormat:@"%@ Underlying Error Domain", kRefugePrefix] : underlyingErrorDomain,
            [NSString stringWithFormat:@"%@ Underlying Error Code", kRefugePrefix] : underlyingErrorCode
        }];
}

- (void)refugeTrackNewRestroomButtonTouched
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ New Restroom Button Touched", kRefugePrefix]];
}

- (void)refugeTrackOnboardingCompleted
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ Onboarding Completed", kRefugePrefix]];
}

- (void)refugeTrackRestroomDetailsViewed:(RefugeMapPin *)mapPin
{
    RefugeRestroom *restroom = mapPin.restroom;
    
    NSString *identifier = restroom.identifier;
    NSString *city = restroom.city;
    NSString *state = restroom.state;
    NSString *country = restroom.country;
    
    [[Mixpanel sharedInstance]
             track:[NSString stringWithFormat:@"%@ Restroom Details Viewed", kRefugePrefix]
        properties:@{
            [NSString stringWithFormat:@"%@ Restroom ID", kRefugePrefix] : (identifier == nil) ? @"" : identifier,
            [NSString stringWithFormat:@"%@ Restroom City", kRefugePrefix] : (city == nil) ? @"" : city,
            [NSString stringWithFormat:@"%@ Restroom State", kRefugePrefix] : (state == nil) ? @"" : state,
            [NSString stringWithFormat:@"%@ Restroom Country", kRefugePrefix] : (country == nil) ? @"" : country
        }];
}

- (void)refugeTrackRestroomsPlotted:(NSUInteger)numRestroomsPlotted
{
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@ Restrooms Plotted", kRefugePrefix]
                          properties:@{
                              [NSString stringWithFormat:@"%@ # Restrooms Plotted", kRefugePrefix] :
                                  [NSNumber numberWithInteger:numRestroomsPlotted]
                          }];
}

- (void)refugeTrackSearchWithString:(NSString *)searchString placemark:(CLPlacemark *)placemark
{
    NSDictionary *addressInfo = placemark.addressDictionary;
    NSString *searchName = [addressInfo objectForKey:@"Name"];
    NSString *searchCity = [addressInfo objectForKey:@"City"];
    NSString *searchState = [addressInfo objectForKey:@"State"];
    NSString *searchCountry = [addressInfo objectForKey:@"Country"];
    
    [[Mixpanel sharedInstance]
             track:[NSString stringWithFormat:@"%@ Search Successfully Executed", kRefugePrefix]
        properties:@{
            [NSString stringWithFormat:@"%@ Search String", kRefugePrefix] : searchString,
            [NSString stringWithFormat:@"%@ Search Name", kRefugePrefix] : (searchName == nil) ? @"" : searchName,
            [NSString stringWithFormat:@"%@ Search City", kRefugePrefix] : (searchCity == nil) ? @"" : searchCity,
            [NSString stringWithFormat:@"%@ Search State", kRefugePrefix] : (searchState == nil) ? @"" : searchState,
            [NSString stringWithFormat:@"%@ Search Country", kRefugePrefix] : (searchCountry == nil) ? @""
                                                                                                     : searchCountry
        }];
}

#pragma mark - Private methods

- (BOOL)hasEverLaunchedApp
{
    return [iRate sharedInstance].usesCount > 0;
}

- (NSString *)stringForErrorType:(RefugeMixpanelErrorType)errorType
{
    switch (errorType) {
    case RefugeMixpanelErrorTypeLocationManagerFailed:
        return @"Location Manager Failed";
        break;
        
    case RefugeMixpanelErrorTypeFetchingRestroomsFailed:
        return @"Fetching Restrooms From API Failed";
        break;
        
    case RefugeMixpanelErrorTypeSavingRestroomsFailed:
        return @"Saving Restrooms Failed";
        break;
        
    case RefugeMixpanelErrorTypeResolvingPlacemarkFailed:
        return @"Resolving Placemark Failed";
        break;
        
    case RefugeMixpanelErrorTypeSearchAttemptFailed:
        return @"Search Attempt Failed";
        break;
        
    case RefugeMixpanelErrorTypePreloadingRestrooms:
        return @"Pre-loading Restrooms Failed";
        break;
        
    case RefugeMixpanelErrorTypeLocalStoreFetchFailed:
        return @"Fetching Restrooms From Local Store Failed";
        break;
        
    case RefugeMixpanelErrorTypeOpeningLinkFailed:
        return @"Opening Link Failed";
        break;
        
    case RefugeMixpanelErrorTypeLoadingNewRestroomWebViewFailed:
        return @"Loading New Restroom Web View Failed";
        break;
        
    default:
        return @"Error Type Not Found";
        break;
    }
}

@end

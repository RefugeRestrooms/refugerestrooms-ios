//
// RefugeMapPlace.m
//
// Copyleft (c) 2015 Refuge Restrooms
//
// Refuge is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// This notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RefugeMapPlace.h"

#import "CLPlacemark+HNKAdditions.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

@implementation RefugeMapPlace

#pragma mark - Public methods

- (void)resolveToPlacemarkWithSuccessBlock:(void (^)(CLPlacemark *))placemarkSuccess
                                   failure:(void (^)(NSError *))placemarkError
{
    HNKGooglePlacesAutocompletePlace *place = [self translateToHNKPlace];
    
    [CLPlacemark hnk_placemarkFromGooglePlace:place
                                       apiKey:self.key
                                   completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                       if (error) {
                                           placemarkError(error);
                                       } else {
                                           placemarkSuccess(placemark);
                                       }
                                   }];
}

#pragma mark - Private methods

- (HNKGooglePlacesAutocompletePlace *)translateToHNKPlace
{
    NSString *typeString = [self typeToString];
    
    NSDictionary *placeJSON = @{
        @"description" : self.name,
        @"id" : @"N/A",
        @"matched_substrings" : @[],
        @"place_id" : self.placeId,
        @"reference" : @"N/A",
        @"terms" : @[],
        @"types" : @[ typeString ]
    };
    
    HNKGooglePlacesAutocompletePlace *place = [HNKGooglePlacesAutocompletePlace modelFromJSONDictionary:placeJSON];
    
    return place;
}

- (NSString *)typeToString
{
    if (self.type == RefugeMapPlaceTypeGeocode) {
        return @"geocode";
    } else {
        return @"establishment";
    }
}

@end

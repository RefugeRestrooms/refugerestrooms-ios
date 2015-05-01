//
// RefugeSearch.m
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

#import "RefugeSearch.h"

#import <CoreLocation/CoreLocation.h>
#import "RefugeMapPlace.h"
#import <SPGooglePlacesAutocomplete/SPGooglePlacesAutocomplete.h>

static NSString * const kRefugeSearchApiKey = @"AIzaSyAs1N-hce2hD16SJyh-QGbpeZIwv5mCSlY";
static CLLocationDistance const kRefugeSearchQueryRadius = 100.0;

@interface RefugeSearch ()

@property (nonatomic, strong) SPGooglePlacesAutocompleteQuery *searchQuery;

@end

@implementation RefugeSearch

# pragma mark - Initializers

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        self.searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
        self.searchQuery.key = kRefugeSearchApiKey;
        self.searchQuery.radius = kRefugeSearchQueryRadius;
    }

    return self;
}

# pragma mark - Public methods

- (void)searchForPlaces:(NSString *)searchString success:(void (^)(NSArray *))searchSuccess failure:(void (^)(NSError *))searchError
{
    self.searchQuery.input = searchString;

    [self.searchQuery fetchPlaces:^(NSArray *places, NSError *error)
     {
         if (error)
         {
             searchError(error);
         }
         else
         {
             NSArray *refugeMapPlaces = [self translateToRefugePlaces:places];

             searchSuccess(refugeMapPlaces);
         }
     }];
}

# pragma mark - Private methods

- (NSArray *)translateToRefugePlaces:(NSArray *)places
{
    NSMutableArray *array = [NSMutableArray array];

    for(SPGooglePlacesAutocompletePlace *place in places)
    {
        RefugeMapPlace *refugeMapPlace = [[RefugeMapPlace alloc] init];

        refugeMapPlace.name = place.name;
        refugeMapPlace.reference = place.reference;
        refugeMapPlace.identifier = place.identifier;
        refugeMapPlace.key = place.key;

        if(place.type == SPPlaceTypeGeocode)
        {
            refugeMapPlace.type = RefugeMapPlaceTypeGeocode;
        }
        else
        {
            refugeMapPlace.type = RefugeMapPlaceTypeEstablishment;
        }

        [array addObject:refugeMapPlace];
    }

    return [array copy];
}

@end

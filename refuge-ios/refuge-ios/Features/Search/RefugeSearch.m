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
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

@interface RefugeSearch ()

@property (nonatomic, strong) HNKGooglePlacesAutocompleteQuery *searchQuery;

@end

@implementation RefugeSearch

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    }
    
    return self;
}

#pragma mark - Public methods

- (void)searchForPlaces:(NSString *)searchString
                success:(void (^)(NSArray *))searchSuccess
                failure:(void (^)(NSError *))searchError
{
    [self.searchQuery fetchPlacesForSearchQuery:searchString
                                     completion:^(NSArray *places, NSError *error) {
                                     
                                         if (error) {
                                             searchError(error);
                                         } else {
                                             NSArray *refugeMapPlaces = [self translateToRefugePlaces:places];
                                             
                                             searchSuccess(refugeMapPlaces);
                                         }
                                         
                                     }];
}

#pragma mark - Private methods

- (NSArray *)translateToRefugePlaces:(NSArray *)places
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (HNKGooglePlacesAutocompletePlace *place in places) {
        RefugeMapPlace *refugeMapPlace = [[RefugeMapPlace alloc] init];
        
        refugeMapPlace.name = place.name;
        refugeMapPlace.placeId = place.placeId;
        refugeMapPlace.key = self.searchQuery.apiKey;
        
        if (([place.types count] == 1) && [place isPlaceType:HNKGooglePlaceTypeGeocode]) {
            refugeMapPlace.type = RefugeMapPlaceTypeGeocode;
        } else {
            refugeMapPlace.type = RefugeMapPlaceTypeEstablishment;
        }
        
        [array addObject:refugeMapPlace];
    }
    
    return [array copy];
}

@end

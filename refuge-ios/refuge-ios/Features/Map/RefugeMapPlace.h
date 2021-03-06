//
// RefugeMapPlace.h
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

#import <CoreLocation/CoreLocation.h>

@interface RefugeMapPlace : NSObject

typedef NS_ENUM(NSInteger, RefugeMapPlaceType) { RefugeMapPlaceTypeGeocode, RefugeMapPlaceTypeEstablishment };

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *placeId;
@property (nonatomic, assign) RefugeMapPlaceType type;
@property (nonatomic, strong) NSString *key;

- (void)resolveToPlacemarkWithSuccessBlock:(void (^)(CLPlacemark *placemark))placemarkSuccess
                                   failure:(void (^)(NSError *error))placemarkError;
                                   
@end

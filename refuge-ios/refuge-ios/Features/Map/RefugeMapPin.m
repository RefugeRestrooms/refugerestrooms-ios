//
// RefugeMapPin.m
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

#import "RefugeMapPin.h"

#import <CoreLocation/CoreLocation.h>
#import "RefugeRestroom.h"
#import "NSString+Refuge.h"

static NSString *const kRefugeRestroomNoName = @"No Name";

@implementation RefugeMapPin

#pragma mark - Initializers

- (id)initWithRestroom:(RefugeRestroom *)restroom
{
    self = [super init];
    
    if (self) {
        _restroom = restroom;
        
        if ([restroom.name isEqualToString:@""]) {
            _title = kRefugeRestroomNoName;
        } else {
            _title = [restroom.name RefugePrepareForDisplay];
        }
        
        _subtitle = [self addressForRestroom:restroom];
        _coordinate = [self coordinateForRestroom:restroom];
    }
    
    return self;
}

- (id)init
{
    NSAssert(false, @"Use initWitRestroom: to initialize this class.");
    
    return nil;
}

#pragma mark - Private methods

- (NSString *)addressForRestroom:(RefugeRestroom *)restroom
{
    return [NSString stringWithFormat:@"%@, %@, %@", restroom.street, restroom.city, restroom.state];
}

- (CLLocationCoordinate2D)coordinateForRestroom:(RefugeRestroom *)restroom
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [restroom.latitude doubleValue];
    coordinate.longitude = [restroom.longitude doubleValue];
    
    return coordinate;
}

@end

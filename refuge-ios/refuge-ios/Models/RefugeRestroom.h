//
// RefugeRestroom.h
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

#import <Foundation/Foundation.h>

#import <MTLModel.h>
#import <MTLJSONAdapter.h>
#import <MTLManagedObjectAdapter.h>

typedef NS_ENUM(NSInteger, RefugeRestroomRatingType) {
    RefugeRestroomRatingTypeNegative = 0,
    RefugeRestroomRatingTypeNeutral = 1,
    RefugeRestroomRatingTypeNone = 2,
    RefugeRestroomRatingTypePositive = 3
};

@interface RefugeRestroom : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, assign) NSNumber *isAccessible;
@property (nonatomic, assign) NSNumber *isUnisex;
@property (nonatomic, assign) NSNumber *numUpvotes;
@property (nonatomic, assign) NSNumber *numDownvotes;
@property (nonatomic, assign) NSNumber *ratingNumber;
@property (nonatomic, strong) NSString *directions;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSDecimalNumber *latitude;
@property (nonatomic, strong) NSDecimalNumber *longitude;
@property (nonatomic, strong) NSDate *createdDate;

+ (RefugeRestroomRatingType)ratingTypeForRating:(NSNumber *)rating; // Core Data object uses NSNumber

@end

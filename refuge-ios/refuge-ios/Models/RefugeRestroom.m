//
// RefugeRestroom.m
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

#import "RefugeRestroom.h"

#import "MTLJSONAdapter.h"
#import "MTLValueTransformer.h"
#import "NSDate+Refuge.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation RefugeRestroom

#pragma mark - Getters

- (NSNumber *)ratingNumber
{
    int numUpvotes = [self.numUpvotes intValue];
    int numDownvotes = [self.numDownvotes intValue];
    
    if ((numUpvotes == 0) && (numDownvotes == 0)) {
        return [NSNumber numberWithInteger:RefugeRestroomRatingTypeNone];
    }
    
    int percentPositive = (numUpvotes / (numUpvotes + numDownvotes)) * 100;
    
    if (percentPositive < 50) {
        return [NSNumber numberWithInteger:RefugeRestroomRatingTypeNegative];
    } else if (percentPositive > 50 && percentPositive < 70) {
        return [NSNumber numberWithInteger:RefugeRestroomRatingTypeNeutral];
    } else {
        return [NSNumber numberWithInteger:RefugeRestroomRatingTypePositive];
    }
}

#pragma mark - Public methods

+ (RefugeRestroomRatingType)ratingTypeForRating:(NSNumber *)rating
{
    int ratingValue = [rating intValue];
    
    switch (ratingValue) {
    case 0:
        return RefugeRestroomRatingTypeNegative;
        break;
    case 1:
        return RefugeRestroomRatingTypeNeutral;
        break;
    case 2:
        return RefugeRestroomRatingTypeNone;
        break;
    case 3:
        return RefugeRestroomRatingTypePositive;
        break;
    default:
        return RefugeRestroomRatingTypeNone;
        break;
    }
}

#pragma mark MTLJSONSerializing methods

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"identifier" : @"id",
        @"name" : @"name",
        @"street" : @"street",
        @"city" : @"city",
        @"state" : @"state",
        @"country" : @"country",
        @"isAccessible" : @"accessible",
        @"isUnisex" : @"unisex",
        @"numUpvotes" : @"upvote",
        @"numDownvotes" : @"downvote",
        @"ratingNumber" : [NSNull null],
        @"directions" : @"directions",
        @"comment" : @"comment",
        @"createdDate" : @"created_at"
    };
}

+ (NSValueTransformer *)createdDateJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        NSDate *date = [NSDate RefugeDateFromString:str];
        return date;
    } reverseBlock:^(NSDate *date) {
        return [NSDate RefugeStringFromDate:date];
    }];
}

+ (NSValueTransformer *)identifierJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *number) {
        return [number stringValue];
    } reverseBlock:^(NSString *str) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
        return [numberFormatter numberFromString:str];
    }];
}

+ (NSValueTransformer *)latitudeJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *number) {
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } reverseBlock:^(NSDecimalNumber *decimalNumber) {
        return [NSNumber numberWithDouble:[decimalNumber doubleValue]];
    }];
}

+ (NSValueTransformer *)longitudeJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *number) {
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } reverseBlock:^(NSDecimalNumber *decimalNumber) {
        return [NSNumber numberWithDouble:[decimalNumber doubleValue]];
    }];
}

#pragma mark MTLManagedObjectSerializing methods

+ (NSString *)managedObjectEntityName
{
    return @"RefugeRestroom";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
        @"id" : @"identifier",
        @"name" : @"name",
        @"street" : @"street",
        @"city" : @"city",
        @"state" : @"state",
        @"country" : @"country",
        @"accessible" : @"isAccessible",
        @"unisex" : @"isUnisex",
        @"upvote" : @"numUpvotes",
        @"downvote" : @"numDownvotes",
        @"directions" : @"directions",
        @"comment" : @"comment",
        @"created_at" : @"createdDate"
    };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing
{
    return [NSSet setWithObject:@"identifier"];
}

@end

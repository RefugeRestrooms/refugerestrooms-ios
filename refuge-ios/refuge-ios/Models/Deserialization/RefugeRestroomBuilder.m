//
// RefugeRestroomBuilder.m
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

#import "RefugeRestroomBuilder.h"

#import "NSDate+Refuge.h"
#import "RefugeRestroom.h"
#import "RefugeSerialization.h"

NSString *RefugeRestroomBuilderErrorDomain = @"RefugeRestroomBuilderErrorDomain";

@implementation RefugeRestroomBuilder

#pragma mark - Public methods

- (NSArray *)buildRestroomsFromJSON:(id)jsonObjects error:(NSError **)error
{
    NSParameterAssert(jsonObjects != nil);
    
    NSError *errorWhileCreatingRestrooms;
    id jsonArray = nil;
    
    if (![jsonObjects isKindOfClass:[NSArray class]]) {
        jsonArray = @[ jsonObjects ];
    } else {
        jsonArray = jsonObjects;
    }
    
    if ([jsonArray count] == 0) {
        return [NSArray array];
    }
    
    NSArray *restrooms =
        [RefugeSerialization deserializeRestroomsFromJSON:jsonArray error:&errorWhileCreatingRestrooms];
        
    if (restrooms == nil || errorWhileCreatingRestrooms) {
        [self setErrorToReturn:error withUnderlyingError:errorWhileCreatingRestrooms];
    }
    
    return restrooms;
}

#pragma mark - Private methods

- (void)setErrorToReturn:(NSError **)error withUnderlyingError:(NSError *)underlyingError
{
    if (error != NULL) {
        NSMutableDictionary *errorInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        
        if (underlyingError != nil) {
            [errorInfo setObject:underlyingError forKey:NSUnderlyingErrorKey];
        }
        
        *error = [NSError errorWithDomain:RefugeRestroomBuilderErrorDomain
                                     code:RefugeRestroomBuilderDeserializationErrorCode
                                 userInfo:errorInfo];
    }
}

@end

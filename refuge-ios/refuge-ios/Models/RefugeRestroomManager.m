//
// RefugeRestroomManager.m
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

#import "RefugeRestroomManager.h"

#import <CoreData/CoreData.h>
#import <MTLManagedObjectAdapter.h>
#import "RefugeDataPersistenceManager.h"
#import "RefugeRestroom.h"
#import "RefugeRestroomBuilder.h"
#import "RefugeRestroomCommunicator.h"
#import "RefugeRestroomEntity.h"
#import "RefugeRestroomManagerDelegate.h"

NSString *RefugeRestroomManagerErrorDomain = @"RefugeRestroomManagerErrorDomain";

@implementation RefugeRestroomManager

#pragma mark - Setters

- (void)setDelegate:(id<RefugeRestroomManagerDelegate>)delegate
{
    if ((delegate != nil) && !([delegate conformsToProtocol:@protocol(RefugeRestroomManagerDelegate)])) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Delegate object does not conform to the delgate protocol"
                               userInfo:nil] raise];
    }
    
    _delegate = delegate;
}

#pragma mark - Public methods

- (void)fetchRestroomsFromAPI
{
    [self.restroomCommunicator searchForRestrooms];
}

- (NSArray *)restroomsFromLocalStore
{
    return [self.dataPersistenceManager allRestrooms];
}

#pragma mark RefugeRestroomCommunicatorDelegate methods

- (void)didReceiveRestroomsJsonObjects:(id)jsonObjects
{
    NSError *errorBuildingRestrooms;
    NSArray *restrooms = [self.restroomBuilder buildRestroomsFromJSON:jsonObjects error:&errorBuildingRestrooms];
    
    if (restrooms != nil) {
        [self.dataPersistenceManager saveRestrooms:restrooms];
    } else {
        [self tellDelegateAboutFetchErrorWithCode:RefugeRestroomManagerErrorRestroomsBuildCode
                                  underlyingError:errorBuildingRestrooms];
    }
}

- (void)retrievingAllRestroomsFailedWithError:(NSError *)error
{
    [self.delegate fetchingRestroomsFromLocalStoreFailedWithError:error];
}

- (void)searchingForRestroomsFailedWithError:(NSError *)error
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    NSError *reportableError = [NSError errorWithDomain:RefugeRestroomManagerErrorDomain
                                                   code:RefugeRestroomManagerErrorRestroomsFetchCode
                                               userInfo:errorInfo];
                                               
    [self.delegate fetchingRestroomsFromApiFailedWithError:reportableError];
}

#pragma mark RefugeDataPeristenceManagerDelegate methods

- (void)didSaveRestrooms
{
    [self.delegate didFetchRestrooms];
}

- (void)savingRestroomsFailedWithError:(NSError *)error
{
    [self tellDelegateAboutSyncErrorWithCode:RefugeRestroomManagerErrorRestroomsSaveCode underlyingError:error];
}

#pragma mark - Private methods

- (void)tellDelegateAboutFetchErrorWithCode:(NSInteger)errorCode underlyingError:(NSError *)underlyingError
{
    NSDictionary *errorInfo = nil;
    
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject:underlyingError forKey:NSUnderlyingErrorKey];
    }
    
    NSError *reportableError =
        [NSError errorWithDomain:RefugeRestroomManagerErrorDomain code:errorCode userInfo:errorInfo];
        
    [self.delegate fetchingRestroomsFromApiFailedWithError:reportableError];
}

- (void)tellDelegateAboutSyncErrorWithCode:(NSInteger)errorCode underlyingError:(NSError *)underlyingError
{
    NSDictionary *errorInfo = nil;
    
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject:underlyingError forKey:NSUnderlyingErrorKey];
    }
    
    NSError *reportableError =
        [NSError errorWithDomain:RefugeRestroomManagerErrorDomain code:errorCode userInfo:errorInfo];
        
    [self.delegate savingRestroomsFailedWithError:reportableError];
}

@end

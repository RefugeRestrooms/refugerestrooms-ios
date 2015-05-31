//
// RefugeDataPersistenceManager.m
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

#import "RefugeDataPersistenceManager.h"

#import <CoreData/CoreData.h>
#import "RefugeAppDelegate.h"
#import "RefugeRestroom.h"

@interface RefugeDataPersistenceManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation RefugeDataPersistenceManager

#pragma mark - Initializers

- (id)init
{
    self = [super init];
    
    if (self) {
        self.managedObjectContext =
            ((RefugeAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    
    return self;
}

#pragma mark - Public methods

- (NSArray *)allRestrooms
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[RefugeRestroom managedObjectEntityName]];
    
    NSError *error = nil;
    NSArray *allRestrooms = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        [self.delegate retrievingAllRestroomsFailedWithError:error];
        
        return nil;
    }
    
    return allRestrooms;
}

- (void)saveRestrooms:(NSArray *)restrooms
{
    NSError *errorSavingRestrooms;
    
    for (RefugeRestroom *restroom in restrooms) {
        [MTLManagedObjectAdapter managedObjectFromModel:restroom
                                   insertingIntoContext:self.managedObjectContext
                                                  error:&errorSavingRestrooms];
        [self.managedObjectContext save:&errorSavingRestrooms];
    }
    
    if (errorSavingRestrooms) {
        [self.delegate savingRestroomsFailedWithError:errorSavingRestrooms];
    } else {
        [self.delegate didSaveRestrooms];
    }
}

@end

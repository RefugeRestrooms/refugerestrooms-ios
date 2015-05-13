//
// NSDate+Refuge.m
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

#import "NSDate+Refuge.h"

static NSString *const kRefugeDateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

@implementation NSDate (Refuge)

#pragma mark - Public methods

+ (NSString *)RefugeDateFormat
{
    return kRefugeDateFormat;
}

+ (NSDate *)RefugeDateFromString:(NSString *)dateString
{
    return [self.RefugeDateFormatter dateFromString:dateString];
}

+ (NSString *)RefugeStringFromDate:(NSDate *)date
{
    return [self.RefugeDateFormatter stringFromDate:date];
}

#pragma mark - Private methods

+ (NSDateFormatter *)RefugeDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = kRefugeDateFormat;
    
    return dateFormatter;
}

@end

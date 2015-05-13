//
// UIColor+Refuge.m
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

#import "UIColor+Refuge.h"

@implementation UIColor (Refuge)

#pragma mark - Public methods

+ (UIColor *)RefugePurpleDarkColor
{
    return [UIColor colorWithRed:65.0 / 255.0 green:50.0 / 255.0 blue:107.0 / 255.0 alpha:1.0];
}

+ (UIColor *)RefugePurpleMediumColor
{
    return [UIColor colorWithRed:131.0 / 255.0 green:119.0 / 255.0 blue:175.0 / 255.0 alpha:1.0];
}

+ (UIColor *)RefugePurpleLightColor
{
    return [UIColor colorWithRed:229.0 / 255.0 green:215.0 / 255.0 blue:236.0 / 255.0 alpha:1.0];
}

+ (UIColor *)RefugeRatingNegativeColor
{
    return [UIColor colorWithRed:220.0 / 255.0 green:129.0 / 255.0 blue:137.0 / 255.0 alpha:1.0];
}

+ (UIColor *)RefugeRatingNeutralColor
{
    return [UIColor colorWithRed:226.0 / 255.0 green:224.0 / 255.0 blue:155.0 / 255.0 alpha:1.0];
}

+ (UIColor *)RefugeRatingNoneColor
{
    return [self RefugePurpleMediumColor];
}

+ (UIColor *)RefugeRatingPositiveColor
{
    return [UIColor colorWithRed:162.0 / 255.0 green:210.0 / 255.0 blue:147.0 / 255.0 alpha:1.0];
}

@end

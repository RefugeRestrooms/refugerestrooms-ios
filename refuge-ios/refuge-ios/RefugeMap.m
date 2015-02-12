//
//  RefugeMap.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMap.h"

static NSString * const kMapAnnotationReuseIdentifier = @"MapAnnotationReuseIdentifier";
static NSString * const kImageNamePin = @"refuge-pin.png";
static float const kImageHeightPin = 39.5;
static float const kImageWidthPin = 31.0;
static NSInteger const kMaxNumPinClusters = 1000;
static NSString * const kTitlePinCluster = @"%d Restrooms";

@implementation RefugeMap

# pragma mark - Public methods

# pragma mark ADClusterMapView methods

- (NSInteger)numberOfClustersInMapView:(ADClusterMapView *)mapView
{
    return kMaxNumPinClusters;
}

- (NSString *)pictoName
{
    return kImageNamePin;
}

- (NSString *)clusterPictoName
{
    return kImageNamePin;
}

- (NSString *)clusterTitleForMapView:(ADClusterMapView *)mapView
{
    return kTitlePinCluster;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if(![annotation isKindOfClass:[ADClusterAnnotation class]])
    {
        return nil;
    }
    else
    {
        return [self clusterAnnotationViewForMapView:mapView withAnnotation:annotation];
    }
}

//-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//    id <MKAnnotation> annotation = [view annotation];
//    
//    if ([[view annotation] isKindOfClass:[ADClusterAnnotation class]])
//    {
//        // segue to details controller
//        [self performSegueWithIdentifier:RRCONSTANTS_TRANSITION_NAME_RESTROOM_DETAILS sender:annotation];
//        
//    }
//}

# pragma mark MKMapView methods

- (void)addAnnotation:(id<MKAnnotation>)annotation
{
    [self addNonClusteredAnnotation:annotation];
}

- (void)addAnnotations:(NSArray *)annotations
{
    NSMutableArray *newAnnotationsList = [NSMutableArray array];

    [newAnnotationsList addObjectsFromArray:self.annotations];
    [newAnnotationsList addObjectsFromArray:annotations];
    
    [self setAnnotations:[newAnnotationsList copy]];
}

# pragma mark - Private methods

- (MKAnnotationView *)clusterAnnotationViewForMapView:(MKMapView *)mapView withAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kMapAnnotationReuseIdentifier];
        
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:kMapAnnotationReuseIdentifier];
        UIImage *resizedImage = [self resizeImageNamed:self.pictoName width:kImageWidthPin height:kImageHeightPin];
            
        annotationView.image = resizedImage;
        annotationView.canShowCallout = YES;
            
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = rightButton;
    }
    else
    {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

- (UIImage *)resizeImageNamed:(NSString *)imageName width:(CGFloat)width height:(CGFloat)height
{
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(newSize);
    [[UIImage imageNamed:imageName] drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}


@end

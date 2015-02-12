//
//  RefugeMap.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMap.h"
#import "RefugeMapDelegate.h"
#import "RefugeMapPin.h"
#import "UIImage+Refuge.h"

static NSString * const kMapAnnotationReuseIdentifier = @"MapAnnotationReuseIdentifier";
static NSString * const kImageNamePin = @"refuge-pin.png";
static float const kImageHeightPin = 39.5;
static float const kImageWidthPin = 31.0;
static NSInteger const kMaxNumPinClusters = 1000;
static NSString * const kTitlePinCluster = @"%d Restrooms";

@implementation RefugeMap

# pragma mark - Setters

- (void)setMapDelegate:(id<RefugeMapDelegate>)mapDelegate
{
    if((mapDelegate != nil) && !([mapDelegate conformsToProtocol:@protocol(RefugeMapDelegate)]))
    {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delgate protocol" userInfo:nil] raise];
    }
    
    _mapDelegate = mapDelegate;
}

# pragma mark - Public methods

# pragma mark ADClusterMapView methods

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

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if([[view annotation] isKindOfClass:[ADClusterAnnotation class]])
    {
        ADClusterAnnotation *clusterAnnotation = (ADClusterAnnotation *)[view annotation];
        int numMapPins = 0;
        RefugeMapPin *lastMapPin;
        
        for(id<MKAnnotation> annotation in clusterAnnotation.originalAnnotations)
        {
            if([annotation isKindOfClass:[RefugeMapPin class]])
            {
                lastMapPin = (RefugeMapPin *)annotation;
                numMapPins++;
            }
        }
        
        if(numMapPins == 1)
        {
            [self.mapDelegate tappingCalloutAccessoryDidRetrieveMapPin:lastMapPin];
        }
        else
        {
            [self.mapDelegate retrievingAnnotationFromCalloutAccessoryFailed];
        }
    }
}

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
        UIImage *resizedImage = [UIImage resizeImageNamed:self.pictoName width:kImageWidthPin height:kImageHeightPin];
            
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

@end

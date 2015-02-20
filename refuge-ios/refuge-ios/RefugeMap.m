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
static NSString * const kMapClusterAnnotationReuseIdentifier = @"MapClusterAnnotationReuseIdentifier";
static NSString * const kImageNamePin = @"refuge-map-pin.png";
static float const kImageHeightPin = 39.5;
static float const kImageWidthPin = 31.0;
@implementation RefugeMap

# pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        self.delegate = self;
    }
    
    return self;
}

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

# pragma mark ADClusterMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([self isCurrentUserLocation:annotation])
    {
        return nil;
    }
    
    if([annotation isKindOfClass:[ADClusterAnnotation class]])
    {
        return [self annotationViewForMapView:mapView withAnnotation:annotation];
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if([[view annotation] isKindOfClass:[ADClusterAnnotation class]])
    {
        ADClusterAnnotation *clusterAnnotation = (ADClusterAnnotation *)[view annotation];
        NSArray *originalAnnotations = clusterAnnotation.originalAnnotations;
        int numMapPins = 0;
        RefugeMapPin *firstMapPin;
        
        for(id<MKAnnotation> annotation in originalAnnotations)
        {
            if([annotation isKindOfClass:[RefugeMapPin class]])
            {
                if(numMapPins == 0)
                {
                    firstMapPin = (RefugeMapPin *)annotation;
                }
                numMapPins++;
            }
        }
        
        if(numMapPins == 1)
        {
            [self.mapDelegate tappingCalloutAccessoryDidRetrievedSingleMapPin:firstMapPin];
        }
        else
        {
            [self.mapDelegate retrievingSingleMapPinFromCalloutAccessoryFailed:firstMapPin];
        }
    }
}

# pragma mark MKMapView methods

- (void)addAnnotation:(id<MKAnnotation>)annotation
{
    [super addNonClusteredAnnotation:annotation];
}

- (void)addAnnotations:(NSArray *)annotations
{
    NSMutableArray *newAnnotationsList = [NSMutableArray array];

    [newAnnotationsList addObjectsFromArray:self.annotations];
    [newAnnotationsList addObjectsFromArray:annotations];
    
    [super setAnnotations:[newAnnotationsList copy]];
}

# pragma mark - Private methods

- (BOOL)isCurrentUserLocation:(id<MKAnnotation>)annotation
{
    return [annotation isKindOfClass:[MKUserLocation class]];
}

- (MKAnnotationView *)annotationViewForMapView:(MKMapView *)mapView withAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kMapAnnotationReuseIdentifier];
    
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:kMapAnnotationReuseIdentifier];
        UIImage *resizedImage = [UIImage resizeImageNamed:kImageNamePin width:kImageWidthPin height:kImageHeightPin];
        
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

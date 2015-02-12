//
//  RefugeMap.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeMap.h"

@implementation RefugeMap

# pragma mark - Public methods

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

@end

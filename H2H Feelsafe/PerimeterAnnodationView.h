//
//  PerimeterAnnodationView.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 17/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <MapKit/MapKit.h>
@class PerimeterAnnodation;


@interface PerimeterAnnodationView : MKPinAnnotationView {
@private
    MKCircle *Perimeter;
    BOOL isPerimeterUpdated;
}

@property (nonatomic, assign) MKMapView *map;
@property (nonatomic, assign) PerimeterAnnodation *theAnnotation;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation;
- (void)updatePerimeter;
- (void)removePerimeter;


@end

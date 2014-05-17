//
//  PerimeterAnnodationView.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 17/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "PerimeterAnnodationView.h"
#import "PerimeterAnnodation.h"

@implementation PerimeterAnnodationView


@synthesize map, theAnnotation;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation {
	self = [super initWithAnnotation:annotation reuseIdentifier:[annotation title]];
	
	if (self) {
		self.canShowCallout	= YES;
		self.multipleTouchEnabled = NO;
		self.draggable = YES;
		self.animatesDrop = YES;
		self.map = nil;
		theAnnotation = (PerimeterAnnodation *)annotation;
		self.pinColor = MKPinAnnotationColorPurple;
		Perimeter = [MKCircle circleWithCenterCoordinate:theAnnotation.coordinate radius:theAnnotation.radius];
		
		[map addOverlay:Perimeter];
	}
	
	return self;
}


- (void)removePerimeter{
	// Find the overlay for this annotation view and remove it if it has the same coordinates.
	for (id overlay in [map overlays]) {
		if ([overlay isKindOfClass:[MKCircle class]]) {
			MKCircle *circleOverlay = (MKCircle *)overlay;
			CLLocationCoordinate2D coord = circleOverlay.coordinate;
			
			if (coord.latitude == theAnnotation.coordinate.latitude && coord.longitude == theAnnotation.coordinate.longitude) {
				[map removeOverlay:overlay];
			}
		}
	}
	
	isPerimeterUpdated = NO;
}


- (void)updatePerimeter {
	if (!isPerimeterUpdated) {
		isPerimeterUpdated = YES;
		
		[self removePerimeter];
		
		self.canShowCallout = NO;
		
		[map addOverlay:[MKCircle circleWithCenterCoordinate:theAnnotation.coordinate radius:theAnnotation.radius]];
		
		self.canShowCallout = YES;
	}
}




@end

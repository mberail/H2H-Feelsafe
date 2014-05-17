//
//  PerimeterAnnodation.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 17/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "PerimeterAnnodation.h"

@implementation PerimeterAnnodation

@synthesize perimeter, coordinate, radius, title, subtitle;

- (id)init {
	self = [super init];
	if (self != nil) {
		self.title = NSLocalizedString(@"Périmètre", nil);
	}
	
	return self;
}


- (id)initWithCLRegion:(CLRegion *)newPerimeter {
	self = [self init];
	
	if (self != nil) {
		self.perimeter = newPerimeter;
		self.coordinate = perimeter.center;
		self.radius = perimeter.radius;
		self.title = NSLocalizedString(@"Périmètre", nil);
	}
    
	return self;
}


/*
 This method provides a custom setter so that the model is notified when the subtitle value has changed.
 */
- (void)setRadius:(CLLocationDistance)newRadius {
	[self willChangeValueForKey:@"subtitle"];
	
	radius = newRadius;
	
	[self didChangeValueForKey:@"subtitle"];
}


- (NSString *)subtitle {
	return [NSString stringWithFormat: @"Lat: %.4F, Lon: %.4F, Rad: %.1fm", coordinate.latitude, coordinate.longitude, radius];
}




@end

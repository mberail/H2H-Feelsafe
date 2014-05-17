//
//  PerimeterAnnodation.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 17/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PerimeterAnnodation : NSObject  <MKAnnotation> {
    
}
@property (nonatomic, retain) CLRegion *perimeter;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) CLLocationDistance radius;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

- (id)initWithCLRegion:(CLRegion *)newPerimeter;

@end

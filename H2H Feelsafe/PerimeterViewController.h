//
//  PerimeterViewController.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 17/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "PerimeterAnnodation.h"
#import "PerimeterAnnodationView.h"

@interface PerimeterViewController : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)radiusSizeSlider:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *radiusLabel;
@property (strong, nonatomic) IBOutlet UISlider *radiusSizeSlider;

@end

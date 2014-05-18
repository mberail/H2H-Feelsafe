//
//  PerimeterViewController.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 17/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "PerimeterViewController.h"
#import "IIViewDeckController.h"
#import <QuartzCore/QuartzCore.h>

@interface PerimeterViewController ()
{
  
}
@end

@implementation PerimeterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self.navigationItem setTitle:NSLocalizedString(@"Périmètre", nil)];
    UIImage *profile = [UIImage imageNamed:@"LeftBut.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width/1.5, profile.size.height/1.5)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItem = profilItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(perform)];
    
    
	// Do any additional setup after loading the view.
    
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(displayPerimeter) withObject:Nil afterDelay:0.1  ];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)displayPerimeter
{
    CLLocationCoordinate2D coord = self.mapView.centerCoordinate;
    NSLog(@"longiture : %f \n latitude %f",coord.longitude,coord.latitude);
     MKCircle *circle = [[MKCircle alloc]init];
    MKPointAnnotation *pinperimeter = [[MKPointAnnotation alloc]init];
    if(self.mapView.annotations.count != 0)
    {
        NSLog(@"batard : %i",self.mapView.annotations.count);
    
    MKPointAnnotation *currentpin = [self.mapView.annotations objectAtIndex:0];
   
    if(currentpin.coordinate.latitude == coord.latitude)
    {
     circle  = [MKCircle circleWithCenterCoordinate:coord radius:self.mapView.region.span.latitudeDelta * 3000 * self.radiusSizeSlider.value/10 ];
    }
    else
    {
        pinperimeter.coordinate = coord;
        circle  = [MKCircle circleWithCenterCoordinate:coord radius:self.mapView.region.span.latitudeDelta * 3000 * self.radiusSizeSlider.value/10 ];
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [_mapView addAnnotation:pinperimeter];
    }
    }
    else
    {
        pinperimeter.coordinate = coord;
        circle  = [MKCircle circleWithCenterCoordinate:coord radius:self.mapView.region.span.latitudeDelta * 3000 * self.radiusSizeSlider.value/10 ];
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [_mapView addAnnotation:pinperimeter];
    }
    [self.mapView removeOverlays:self.mapView.overlays];
    
    [_mapView addOverlay:circle];
    
  
    NSString *radius = [[NSString alloc]init];
    if (circle.radius < 1000)
    {
     radius = [NSString stringWithFormat:@"%i m", (int)circle.radius];
    }
    else if (circle.radius <10000)
    {
        radius = [NSString stringWithFormat:@"%.3f km",circle.radius/1000];
    }
    else
    {
        radius = [NSString   stringWithFormat:@"%i km",(int)circle.radius/1000 ];
    }
    self.radiusLabel.text = radius;
}




- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor purpleColor];
    circleView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
    return circleView;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id <MKAnnotation>) annotation {
    MKPinAnnotationView *pin=[[MKPinAnnotationView alloc]
                                  initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pin.pinColor = MKPinAnnotationColorPurple;
    [pin setAnimatesDrop:NO];
    pin.canShowCallout = YES;
    pin.draggable =YES;
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
   
   [self performSelector:@selector(displayPerimeter) withObject:nil afterDelay:0.1];
}

- (IBAction)radiusSizeSlider:(id)sender {

   [self performSelector:@selector(displayPerimeter) withObject:nil afterDelay:0];
}
@end

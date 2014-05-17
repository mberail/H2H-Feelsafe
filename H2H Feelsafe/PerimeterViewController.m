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
    UIImage *profile = [UIImage imageNamed:@"LeftBut.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width/1.5, profile.size.height/1.5)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self action:@selector(displayPerimeter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItem = profilItem;
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
    
    MKPointAnnotation *pinperimeter = [[MKPointAnnotation alloc]init];
    pinperimeter.coordinate = coord;
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coord radius:1000];
    [_mapView addOverlay:circle];
    
    
    [_mapView addAnnotation:pinperimeter];
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
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]
                                  initWithAnnotation:annotation reuseIdentifier:@"pin"];
    annView.pinColor = MKPinAnnotationColorPurple;
    return annView;
}
@end

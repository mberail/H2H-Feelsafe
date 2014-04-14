//
//  ListViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 02/01/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "IIViewDeckController.h"
#import "ListViewController.h"
#import "SVProgressHUD.h"
#import "WebServices.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface ListViewController ()
{
    NSArray *arrays;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D userLoc;
}
@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    NSLog(@"userLoc : %f %f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude);
    
    self.tableView.allowsSelection = NO;
    self.navigationItem.title = @"H2H Feelsafe";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIImage *profile = [UIImage imageNamed:@"19-gear.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width, profile.size.height)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    
    
    //UIBarButtonItem *Settings = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(toggleLeftView)];
    
    self.navigationItem.leftBarButtonItem = profilItem;
    
    UIBarButtonItem *contactButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(displayPins)];
    
   /* UIImage *add = [UIImage imageNamed:@"user_add.png"];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, add.size.width, add.size.height)];
    [addButton setBackgroundImage:add forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addContact)  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem =[[UIBarButtonItem alloc] initWithCustomView:addButton];*/
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:contactButton,refreshButton, nil];
    
    if (arrays == nil)
    {
        arrays = [[NSArray alloc]initWithArray:[WebServices protegesInfos]];
        [self displayPins];
    }
}

- (void)addContact
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changeInterface:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        [self.listSuperView setHidden:YES];
        [self.mapSuperView setHidden:NO];
    }
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        
        [self.listSuperView setHidden:NO];
        [self.mapSuperView setHidden:YES];
    }
}

#pragma mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Mes protégés";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNull *rien = [[NSNull alloc]init];
    NSLog( @"arrays : %@", arrays);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSDictionary *protege = [[NSDictionary alloc] init];
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        protege = [arrays objectAtIndex:indexPath.row];
        NSLog(@"protege : %@",protege);
        if ([[protege objectForKey:@"mail"] isEqual:rien])
        {
            NSString *name = [[NSString alloc]initWithFormat:@"%@   (Réponse en attente)",[protege objectForKey:@"username"]];
             cell.textLabel.text = name;
        }
        else
        {
            float distance = 0;
            UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(160, 13, 140, 20)];
            labelTwo.textAlignment = UITextAlignmentRight;
            if ([[protege objectForKey:@"distance"]floatValue]<1)
            {
                 distance = [[protege objectForKey:@"distance"]floatValue]*1000;
                labelTwo.text = [NSString stringWithFormat:@"%d m",(int)distance] ;
                
            }
            else
            {
                distance = [[protege objectForKey:@"distance"]integerValue];
                labelTwo.text = [NSString stringWithFormat:@"%d km",(int)distance ] ;
            }
           
            
            
            NSString *name = [protege objectForKey:@"username"];
             cell.textLabel.text = name;
            [cell.contentView addSubview:labelTwo];
        }
        
        
       
    }
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - MapView datasource




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSLog(@"annotation : %@",annotation);
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else
    {
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:nil];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        }
        MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        pinAnnotation.pinColor = MKPinAnnotationColorRed;
        pinAnnotation.canShowCallout = YES;
        pinAnnotation.animatesDrop = YES;
        annotationView = pinAnnotation;
        return annotationView;
    }
}

- (void)displayPins
{
   

    MKCoordinateRegion region;
    region.center = locationManager.location.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.15;
    span.longitudeDelta = 0.15;
    region.span = span;
    [_mapView setRegion:region animated:YES];
    // comte les éléments
    NSLog(@"count : %i",arrays.count);
    // récupération des données du tableau dans un dic
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    NSNull *rien = [[NSNull alloc]init];
    int i = 0;
    // création d'un dicto avec les id des bornes et les distances
    for (NSDictionary *dictTemp in arrays)
    {
        
        //chope les coordonnées des stations
        if ([[dictTemp objectForKey:@"latitude"]isEqual:rien])
        {
              NSLog(@"countcount %d",i );
            i++;
            continue;
        }
        else
        {
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[dictTemp objectForKey:@"latitude"] floatValue], [[dictTemp objectForKey:@"longitude"] floatValue]);
            //calcul la distance
            NSNumber *dist = [NSNumber numberWithFloat:6378 * acos(cos(degreesToRadians(locationManager.location.coordinate.latitude))*cos(degreesToRadians(coord.latitude))*cos(degreesToRadians(coord.longitude)-degreesToRadians(locationManager.location.coordinate.longitude))+sin(degreesToRadians(locationManager.location.coordinate.latitude))*sin(degreesToRadians(coord.latitude)))];
            
            [mutDict setObject:dist forKey:@"dist"];
           
              NSLog(@"truc truc : %@",mutDict);
           
            //rajoute des pins sur la carte
           MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
            [self.mapView removeAnnotation:pin];
            //coordonnées du pins
            pin.coordinate = coord;
            //
            pin.title = [dictTemp objectForKey:@"username"];
            pin.subtitle = [NSString stringWithFormat:@"%d km",[[mutDict objectForKey:@"dist"]integerValue]];
            [_mapView addAnnotation:pin];
              NSLog(@"countcount %d",i );
            [[arrays objectAtIndex:i]setObject:[mutDict objectForKey:@"dist"] forKey:@"distance"];
            i++;
        }
      
    }
  
    
    
}

#pragma mark - MapView delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

@end

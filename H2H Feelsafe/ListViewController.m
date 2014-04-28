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
#import "markerAlert.h"
#import "markerAlertAnnodationView.h"


#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface ListViewController ()
{
    NSArray *arrays;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D userLoc;
    NSString *proAlert;
 
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
  
    
    //self.tableView.allowsSelection = NO;
    self.navigationItem.title = @"H2H Feelsafe";
    
    //UIImage *profile = [UIImage imageNamed:@"19-gear.png"];
    //UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width, profile.size.height)];
    
    
    
   // [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
 //   [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];


    //UIBarButtonItem *Settings = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(toggleLeftView)];
    
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self.viewDeckController action:@selector(toggleLeftView)];
    
    UIBarButtonItem *contactButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    
    UIImage *profile = [UIImage imageNamed:@"LeftBut.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width/1.5, profile.size.height/1.5)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(proceedRefreshing)];
    
   /* UIImage *add = [UIImage imageNamed:@"user_add.png"];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, add.size.width, add.size.height)];
    [addButton setBackgroundImage:add forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addContact)  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem =[[UIBarButtonItem alloc] initWithCustomView:addButton];*/
    
    proAlert = [[NSString alloc]init];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:contactButton,refreshButton, nil];
  
    self.navigationItem.leftBarButtonItem = profilItem;
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    if (arrays == nil)
    {
        [SVProgressHUD show];
        [self performSelector:@selector(refresh) withObject:nil afterDelay:0.2];
        
    }
    
}

-(void)proceedRefreshing
{
    
    [SVProgressHUD show];
    [self performSelectorInBackground:@selector(refresh) withObject:nil];
   
}

-(void)refresh
{
        //[WebServices getPicture];
    
    
        arrays = [[NSArray alloc]init];
    
        arrays = [[NSArray alloc]initWithArray:[WebServices protegesInfos]];
        [self.tableView reloadData];
        [_mapView removeAnnotations:_mapView.annotations];

        [self displayPins];
        [self.segmentedControl setSelectedSegmentIndex:0];
        [self.listSuperView setHidden:YES];
        [self.mapSuperView setHidden:NO];
 
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
    
        protege = [arrays objectAtIndex:indexPath.row];
       
        UILabel *nom = [[UILabel alloc ] initWithFrame:CGRectMake(120, 30, 130, 25)];
        
        nom.font = [nom.font fontWithSize:22];
        nom.adjustsFontSizeToFitWidth = YES;
        nom.frame = CGRectMake(120, (cell.frame.size.height/2 - nom.frame.size.height/2)+7, 130, 25);
        
        cell.textLabel.font = [cell.textLabel.font fontWithSize:22];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        
        UIImageView *photo=[[UIImageView alloc]init];

    if(photo.image == nil)
    {
        photo.frame = CGRectMake(60, 10, 46,40);
        photo.image = [UIImage imageNamed:@"no_img.jpg"];
        photo.image = [WebServices getPicture:[protege objectForKey:@"id"]];
    }
    
        
        NSLog(@"protege : %@",protege);
        if ([[protege objectForKey:@"mail"] isEqual:rien])
        {
            NSString *name = [[NSString alloc]initWithFormat:@"%@ (Invitation en attente...)",[protege objectForKey:@"username"]];
             cell.textLabel.text = name;
            
        }
        else
        {
            UIImageView *alertView = [[UIImageView alloc]init];
            alertView.frame = CGRectMake(20, (cell.bounds.size.height/2)-10, 28, 35);
            
            UIButton *messageView = [[UIButton alloc]init];
            messageView.frame = CGRectMake(250, (cell.bounds.size.height/2)-15, 60, 45);
            
           	[messageView addTarget:self action:@selector(messages:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.textLabel.frame = CGRectMake(120, cell.textLabel.frame.origin.y, 130, 25);
            
            //messageView.imageView.image  = [UIImage imageNamed:@"letter_off"];
            [messageView setImage:[UIImage imageNamed:@"letter_off"] forState:UIControlStateNormal];
            //[alertView setTextAlignment:UITextAlignmentCenter];
            
            float distance = 0;
            NSString *dist = [[NSString alloc]init];
            if ([[protege objectForKey:@"distance"]floatValue]<1)
            {
                 distance = [[protege objectForKey:@"distance"]floatValue]*1000;
                dist  = [NSString stringWithFormat:@"%d m",(int)distance] ;
                
            }
            else
            {
                distance = [[protege objectForKey:@"distance"]integerValue];
                dist  = [NSString stringWithFormat:@"%d km",(int)distance ] ;
            }
          
            if ([[protege objectForKey:@"alert"]isEqualToString:@"1"])
            {
             //   alertView.backgroundColor = [UIColor greenColor];
                alertView.image = [UIImage imageNamed:@"good.png"];
                //[alertView setTitle:@"Ok" forState:UIControlStateNormal];
                //alertView.text = @"OK";
            }
            if ([[protege objectForKey:@"alert"]isEqualToString:@"3"])
            {
               // alertView.backgroundColor = [UIColor redColor];
                 alertView.frame = CGRectMake(20, (cell.bounds.size.height/2)-10, 35, 35);
                alertView.image = [UIImage imageNamed:@"alert.png"];
                //[alertView setTitle:@"En danger" forState:UIControlStateNormal];
               // alertView.text = @"En danger";
            }
            if ([[protege objectForKey:@"alert"]isEqualToString:@"2"])
            {
                //alertView.backgroundColor = [UIColor orangeColor];
               alertView.frame = CGRectMake(20, (cell.bounds.size.height/2)-10, 35, 35);
                alertView.image = [UIImage imageNamed:@"warning.png"];
                //[alertView setTitle:@"Imprévu" forState:UIControlStateNormal];
               // alertView.text = @"Imprévu";
                
            }
            NSString *name = [NSString stringWithFormat:@"%@ à %@",[protege objectForKey:@"username"],dist];
            messageView.tag = indexPath.row;
            nom.text = name;
            
                      // [cell.contentView addSubview:Dist];
            
            [cell.contentView addSubview:nom];
            //cell.textLabel.text = name;
            [cell.contentView addSubview:messageView];
            [cell.contentView addSubview:alertView];
            [cell.contentView addSubview:photo];
            
            
          //  cell.textLabel.text = name;
            
        }
        
        
       
    
    return cell;
}

-(void)messages:(UIButton*)sender
{
    NSDictionary  *protege2 = [[NSDictionary alloc]init];
    protege2 = [arrays objectAtIndex:sender.tag];
    NSString *msg = [[NSString alloc]init];

    if ([[protege2 objectForKey:@"message"] isEqualToString:@"<null>"])
    {
        msg = [NSString stringWithFormat:@"Il n'y a pas de messages"]  ;
    }
    else
    {
        msg = [NSString stringWithFormat:@"%@",[protege2 objectForKey:@"message"]]  ;
    }
   
    
    NSLog(@"ici il y a des messages, %@",[protege2 objectForKey:@"message"]);
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"message" message:[NSString stringWithFormat:@"%@",msg] delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [message show];
    
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary  *protege2 = [[NSDictionary alloc]init];
    protege2 = [arrays objectAtIndex:indexPath.row];
    if ([[protege2 objectForKey:@"allow"]isEqualToString:@"1"])
    {
        if ([[protege2 objectForKey:@"alert"]isEqualToString:@"3"])
        {
            if ([[protege2 objectForKey:@"message"]isEqualToString:@"<null>"])
            {
                UIAlertView *etatProtege = [[UIAlertView alloc]initWithTitle:@"Protégé en Danger" message:@"Pas de message" delegate:self cancelButtonTitle:@"Quitter" otherButtonTitles:@"Débloquer", nil];
                proAlert = [protege2 objectForKey:@"id"];
                [etatProtege show];
            }
            else
            {
                UIAlertView *etatProtege = [[UIAlertView alloc]initWithTitle:@"Protégé en Danger" message:[NSString stringWithFormat:@"Dernier message:\n%@",[protege2 objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Quitter" otherButtonTitles:@"Débloquer", nil];
                proAlert = [protege2 objectForKey:@"id"];
                [etatProtege show];
            }
        }
        else if ([[protege2 objectForKey:@"alert"]isEqualToString:@"2"] )
        {
            if ([[protege2 objectForKey:@"message"]isEqualToString:@"<null>"])
            {
                UIAlertView *etatProtege = [[UIAlertView alloc]initWithTitle:@"Protégé en situation imprévue" message:@"Pas de message" delegate:self cancelButtonTitle:@"Quitter" otherButtonTitles:nil];
                [etatProtege show];
            }
            else
            {
                UIAlertView *etatProtege = [[UIAlertView alloc]initWithTitle:@"Protégé en situation imprévue" message:[NSString stringWithFormat:@"Dernier message:\n%@",[protege2 objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Quitter" otherButtonTitles: nil];
                [etatProtege show];
            }
        }
        else if ([[protege2 objectForKey:@"alert"]isEqualToString:@"1"] )
        {
            if ([[protege2 objectForKey:@"message"]isEqualToString:@"<null>"])
            {
                UIAlertView *etatProtege = [[UIAlertView alloc]initWithTitle:@"Protégé Ok" message:@"Pas de message" delegate:self cancelButtonTitle:@"Quitter" otherButtonTitles:nil];
                [etatProtege show];
            }
            else
            {
                UIAlertView *etatProtege = [[UIAlertView alloc]initWithTitle:@"Protégé Ok" message:[NSString stringWithFormat:@"Dernier message:\n%@",[protege2 objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Quitter" otherButtonTitles: nil];
                [etatProtege show];
                
            }
        }
      //[tableView reloadData];
    }
   
    else
    {
        UIAlertView *etatProtege = [[UIAlertView alloc]initWithTitle:@"Protege en attente de confirmation" message:nil delegate:self cancelButtonTitle:@"Quitter" otherButtonTitles: nil];
        [etatProtege show];
      //  [tableView reloadData];
    }
    //[tableView reloadData];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Changement d'état du protégé"];
        [self startUnlockProcess];
        
    }
}

-(void )startUnlockProcess
{

    
    [WebServices stopAlert:proAlert];
    arrays = [[NSArray alloc]initWithArray:[WebServices protegesInfos]];
    [self refresh];
    [self.tableView reloadData];
    [self displayPins];
    
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.listSuperView setHidden:YES];
    [self.mapSuperView setHidden:NO];
    
    

}

#pragma mark - MapView datasource




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSLog(@"annotation : %@",annotation);
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    
 markerAlertAnnodationView *annotationView = [[markerAlertAnnodationView alloc] initWithAnnotation:annotation reuseIdentifier:@"alert"];
 annotationView.canShowCallout = YES;
        return annotationView;
    
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
    NSLog(@"count : %d",arrays.count);
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
            markerAlert *pin = [[markerAlert alloc]init];
            
            
           
            [mutDict setObject:dist forKey:@"dist"];
            
            NSLog(@"truc truc : %@",dictTemp);
            
            if ([[dictTemp objectForKey:@"alert"] isEqualToString:@"1"])
            {
                pin.img.image = [UIImage imageNamed:@"alert"];
                pin.type = AlertGreen;
                NSLog(@"green");
            }
            else if ([[dictTemp objectForKey:@"alert"] isEqualToString:@"2"])
            {
                pin.img.image = [UIImage imageNamed:@"alert"];
                pin.type = AlertOrange;
                NSLog(@"orange");
            }
            else if ([[dictTemp objectForKey:@"alert"] isEqualToString:@"3"])
            {
                pin.img.image = [UIImage imageNamed:@"alert"];
                pin.type = AlertRed;
                NSLog(@"red");
            }
          
            
           
            [self.mapView removeAnnotation:pin];
            pin.coordinate = coord;
            pin.title = [dictTemp objectForKey:@"username"];
            pin.subtitle = [NSString stringWithFormat:@"%ld km",(long)[[mutDict objectForKey:@"dist"]integerValue]];
            
            [_mapView addAnnotation:pin];
              NSLog(@"countcount %d",i );
            [[arrays objectAtIndex:i]setObject:[mutDict objectForKey:@"dist"] forKey:@"distance"];
            i++;
        }
      
    }
  
    
    
}

/*- (void)loadSelectedOptions {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    for (NSDictionary *dict in arrays) {
        switch ([[dict objectForKey:@"alert" ] integerValue])
        {
            case alert:
                [self addAttractionPins];
                break;
            default:
                break;
        }
    }
}*/

#pragma mark - MapView delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

@end

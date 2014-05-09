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
#import "ListCell.h"
#import "JPSThumbnailAnnotationView.h"
#import "JPSThumbnailAnnotation.h"


#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface ListViewController ()
{
    NSArray *arrays;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D userLoc;
    NSString *proAlert;
    NSMutableArray *classArray;
    NSInteger x;
    UIAlertView *alert;
    NSMutableDictionary *share;
    NSMutableArray *pins;
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

    alert = [[UIAlertView alloc]init];
    share = [[NSMutableDictionary alloc] init];
    pins = [[NSMutableArray alloc]init];
    
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
   
        classArray = [[NSMutableArray alloc ]init];
        [SVProgressHUD show];
        
        [self performSelector:@selector(proceedRefreshing) withObject:nil afterDelay:0.2];
    
    
        
    
    
}

-(void)proceedRefreshing
{
    
    [SVProgressHUD show];
    [self performSelectorInBackground:@selector(refresh) withObject:nil];
   
}

-(void)refresh
{
        //[WebServices getPicture];
    
    NSNull *rien = [[NSNull alloc]init];
        arrays = [[NSArray alloc]init];
        arrays = [[NSArray alloc]initWithArray:[WebServices protegesInfos]];
    
    NSMutableDictionary *pro = [[NSMutableDictionary alloc]init];
    NSInteger i = 0;
        for(pro in arrays)
        {
            if ([[pro objectForKey:@"mail"] isEqual:rien])
            {
                continue;
            }
            else
            {
                [pro setObject:[WebServices getPicture:[pro objectForKey:@"id"]] forKey:@"picture"];
                [classArray setObject:pro atIndexedSubscript:i];
                i ++;
            }
        }

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
    return [classArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Mes protégés";
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    
    if (cell == nil)
    {
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCell"];
    }
    
    
    
    NSDictionary *protege = [[NSDictionary alloc] init];
    
    protege = [classArray objectAtIndex:indexPath.row];
    
    NSNull *rien = [[NSNull alloc]init];
    NSLog( @"arrays : %@", arrays);
    NSLog(@"callArray  %@",classArray);
   
    
        
        //cell.Name.font = [cell.textLabel.font fontWithSize:22];
        cell.Name.adjustsFontSizeToFitWidth = YES;
       cell.address.adjustsFontSizeToFitWidth = YES;
        
        cell.Picture.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([[protege objectForKey:@"address"]isEqualToString:@"inconue"])
    {
        cell.address.text = [NSString stringWithFormat:@"addresse %@",[protege objectForKey:@"address"] ];
    }
    else{
         cell.address.text = [protege objectForKey:@"address"];
    }
    
        //cell.Picture.frame = CGRectMake(60,0, 46,60);
        cell.Picture.image = [UIImage imageNamed:@"no_img.jpg"];
        cell.Picture.image = [protege objectForKey:@"picture"];

        
        NSLog(@"protege : %@",protege);
        if ([[protege objectForKey:@"mail"] isEqual:rien])
        {
           // NSString *name = [[NSString alloc]initWithFormat:@"%@ (Invitation en attente...)",[protege objectForKey:@"username"]];
             //cell.textLabel.text = name;
            
        }
        else
        {
            
            cell.Alert.contentMode = UIViewContentModeScaleAspectFit;
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
                NSLog(@"tailles %f %f",cell.Alert.frame.origin.x ,cell.Alert.frame.origin.y);
             //   alertView.backgroundColor = [UIColor greenColor];
              //  cell.Alert.frame = CGRectMake(25 , cell.Alert.frame.origin.y,28,35 );
                cell.Alert.image = [UIImage imageNamed:@"good.png"];
                //[alertView setTitle:@"Ok" forState:UIControlStateNormal];
                //alertView.text = @"OK";
            }
            if ([[protege objectForKey:@"alert"]isEqualToString:@"3"])
            {
               // alertView.backgroundColor = [UIColor redColor];
               //  cell.Alert.frame = CGRectMake(20, (cell.bounds.size.height/2)-10, 35, 35);
                cell.Alert.image = [UIImage imageNamed:@"alert.png"];
                //[alertView setTitle:@"En danger" forState:UIControlStateNormal];
               // alertView.text = @"En danger";
            }
            if ([[protege objectForKey:@"alert"]isEqualToString:@"2"])
            {
                //alertView.backgroundColor = [UIColor orangeColor];
               //cell.Alert.frame = CGRectMake(20, (cell.bounds.size.height/2)-10, 35, 35);
                cell.Alert.image = [UIImage imageNamed:@"warning.png"];
                //[alertView setTitle:@"Imprévu" forState:UIControlStateNormal];
               // alertView.text = @"Imprévu";
                
            }
            NSString *name = [NSString stringWithFormat:@"%@ à %@",[protege objectForKey:@"username"],dist];
            
   
            cell.Name.text = name;
            
            //[cell reloadInputViews];
         
            //[cell.contentView addSubview:photo];
            
            //[cell.contentView addSubview:nom];
            //cell.textLabel.text = name;
           // [cell.contentView addSubview:messageView];
           // [cell.contentView addSubview:alertView];
          //  cell.textLabel.text = name;
            //[cell.contentView removeFromSuperview];
          
        }
        
        
       
    
    return cell;
}



#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    x = 0;
    NSDictionary  *protege2 = [[NSDictionary alloc]init];
    protege2 = [classArray objectAtIndex:indexPath.row];
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
    [tableView reloadData];
    
}



- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
       
    }
    else
    {
        if (x == 0)
        {
            [SVProgressHUD showWithStatus:@"Changement d'état du protégé"];
             [self startUnlockProcess];
        }
        else if ( x == 1)
        {
           
            [share setValue:[alert textFieldAtIndex:0].text forKey:@"recipient"];
            [SVProgressHUD showWithStatus:@"Partage du protégé en cours"];
            [self performSelector:@selector(startShareProcess) withObject:nil afterDelay:0.2];
        }
      
      
    }
}

-(void)startShareProcess
{
    NSLog(@"Sharing %@",share);
    [WebServices Share:share];
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




- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
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
    for (NSDictionary *dictTemp in classArray)
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
            JPSThumbnail *pin = [[JPSThumbnail alloc]init];
            
            
           
            [mutDict setObject:dist forKey:@"dist"];
            
            NSLog(@"truc truc : %@",dictTemp);
            
            if ([[dictTemp objectForKey:@"alert"] isEqualToString:@"1"])
            {
                
                pin.point = [UIImage imageNamed:@"point_vert.png"];
                NSLog(@"green");
            }
            else if ([[dictTemp objectForKey:@"alert"] isEqualToString:@"2"])
            {
               pin.point = [UIImage imageNamed:@"point_orange.png"];
                NSLog(@"orange");
            }
            else if ([[dictTemp objectForKey:@"alert"] isEqualToString:@"3"])
            {
               pin.point = [UIImage imageNamed:@"point_rouge.png"];
                NSLog(@"red");
            }
            
            
           
        
            pin.coordinate = coord;
            pin.title = [dictTemp objectForKey:@"username"];
            pin.subtitle = [NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"message"]];
            
           
            
          
            pin.image = [dictTemp objectForKey:@"picture"];
            pin.disclosureBlock = nil;
              NSLog(@"countcount %d",i );
            [[arrays objectAtIndex:i]setObject:[mutDict objectForKey:@"dist"] forKey:@"distance"];
            [pins setObject:[JPSThumbnailAnnotation annotationWithThumbnail:pin] atIndexedSubscript:i];
            
            i++;
        }
       [_mapView addAnnotations:pins];
    }
  
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Partager";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    x = 1;
   
    alert =  [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Partagé \"%@\"", [[classArray objectAtIndex:indexPath.row]objectForKey:@"username"]] message:@"Veuiller inscrire le username du referent" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].delegate = self;
    [alert show];
    //json_protege : json array des ids
    NSString *toShare = [NSString stringWithFormat:@"%@", [[classArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    NSArray *ids = [[NSArray alloc]initWithObjects:toShare, nil];
    [share setValue:ids forKey:@"json_protege"];
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

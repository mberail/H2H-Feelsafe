//
//  Navigation_Pro_ViewController.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 29/03/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "Navigation_Pro_ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "IIViewDeckController.h"
#import "SVProgressHUD.h"
#import "WebServices.h"


@interface Navigation_Pro_ViewController ()<CLLocationManagerDelegate>
{
    NSString *alert;
    CLLocationManager *locationManager;
    NSTimer *decompte;
    int compte;
    UIAlertView *dangerView;
    NSString *address;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation Navigation_Pro_ViewController

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
  
  //  CGRect frameRect = self.message.frame;
  //  frameRect.size.height = 60;
//    self.message.frame = frameRect;
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    [super viewDidLoad];
    
    address = [[NSString alloc]initWithFormat:@"%@",[[pref objectForKey:@"infos"]objectForKey:@"address" ]];
    
    self.SendBut.titleLabel.text = @"";
    
    decompte = [[NSTimer alloc]init];
    decompte = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerCount) userInfo:nil repeats:YES];
    
    compte = 10;
    dangerView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alerte danger dans:",nil) message:@"10" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles: nil];

    
    NSDictionary *infos = [pref objectForKey:@"infos"];
    alert = [infos  objectForKey:@"alert"];
    NSLog(@"%@",alert);
    self.alert.contentMode   = UIViewContentModeScaleAspectFit;
   if ([alert isEqualToString:@"1"])
   {
       self.alert.image = [UIImage imageNamed:@"good.png"];
   }
    else if ([alert isEqualToString:@"2"])
    {
        self.alert.image = [UIImage imageNamed:@"warning.png"];
    }
   else  if ([alert isEqualToString:@"3"])
    {
        self.alert.image = [UIImage imageNamed:@"alert.png"];
    }
    
    self.navigationItem.title = NSLocalizedString(@"Protégé", nil) ;
    
    self.StatutView.layer.borderColor =[UIColor blackColor].CGColor;
    self.StatutView.layer.borderWidth = 2.0f;
    
    self.dangerView.layer.borderColor = [UIColor redColor].CGColor;
    self.dangerView.layer.borderWidth = 15.0f;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
  //  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.Prenom.adjustsFontSizeToFitWidth = YES;
    self.Prenom.text = [[pref objectForKey:@"infos"]objectForKey:@"firstname"];
    
    self.Name.text = [[pref objectForKey:@"infos"]objectForKey:@"lastname"];
    self.adresse.adjustsFontSizeToFitWidth = YES;
    self.adresse.text = [infos  objectForKey:@"address"];
    self.Phone.text = [[pref objectForKey:@"infos"]objectForKey:@"phone"];
    
   
    self.Picture.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *pic = [[UIImage alloc] init];
    
   // NSLog(@"%@",[[pref objectForKey:@"picture"]class ]);
    pic = [UIImage imageWithData:[pref objectForKey:@"picture"]];
    self.Picture.image = pic;
    
        [self.alertLabel  setHidden:YES];
   if(  [ [ UIScreen mainScreen ] bounds ].size.height== 568)
   {
       [self.alertLabel  setHidden:NO];
      
       self.DangerBut.frame = CGRectMake(self.DangerBut.frame.origin.x, self.DangerBut.frame.origin.y +40, self.DangerBut.frame.size.width, self.DangerBut.frame.size.height-32);
       
       
   }
    
    UIBarButtonItem *contactButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];

    
    
    UIImage *profile = [UIImage imageNamed:@"LeftBut.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width /1.5, profile.size.height /1.5)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    
    /*UIImage *add = [UIImage imageNamed:@"user_add.png"];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, add.size.width * 2, add.size.height *2)];
    [addButton setBackgroundImage:add forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addContact)  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem =[[UIBarButtonItem alloc] initWithCustomView:addButton];*/
    
    self.navigationItem.rightBarButtonItem = contactButton;
    
    self.navigationItem.leftBarButtonItem = profilItem;
  
    locationManager = [[CLLocationManager alloc]init];
    
}




- (void)addContact
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OK:(id)sender {
    if([CLLocationManager locationServicesEnabled])
    {
    if([alert isEqualToString:@"3"])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Compte en danger, changement d'état impossible",nil)];
    }
    else
    {
        self.alert.image = [UIImage imageNamed:@"good.png"];
        alert = @"1";
        [self startUpdateProcess];
    }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Veuillez activer les services de localisation",nil)];
    }
}

- (IBAction)Imprevu:(id)sender {
    if([CLLocationManager locationServicesEnabled])
    {
    if([alert isEqualToString:@"3"])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Compte en danger, changement d'état impossible",nil)];
    }
    else
    {
        self.alert.image = [UIImage imageNamed:@"warning.png"];
        alert = @"2";
        [self startUpdateProcess];
    }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Veuillez activer les services de localisation",nil)];
    }
}

- (IBAction)Danger:(id)sender {
    if([CLLocationManager locationServicesEnabled])
    {
    if([alert isEqualToString:@"3"])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Compte en danger, changement d'état impossible",nil)];
    }
    else
    {

        dangerView.message = [NSString stringWithFormat:@"%d",10];
        [dangerView show];

    }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Veuillez activer les services de localisation",nil)];
    }
}

-(void)TimerCount
{
    if(dangerView.visible)
    {
        
        dangerView.message = [NSString stringWithFormat:@"%d",compte];
        compte -=1;
    }    else
    {
        compte = 10;

    }
    if(compte == -1)
    {
        
        [dangerView dismissWithClickedButtonIndex:0 animated:YES];
        self.alert.image = [UIImage imageNamed:@"alert.png"];
        alert = @"3";
        [self startUpdateProcess];
    }

}


- (IBAction)send:(id)sender {
    [self.message endEditing:YES];
     self.message.text = nil;
    NSLog(@"message %@", self.message.text);
}



-(void)StartUpdate
{
    NSString *latitude =[[NSString alloc]initWithFormat:@"%f",locationManager.location.coordinate.latitude];
    NSString *longitude =[[NSString alloc]initWithFormat:@"%f",locationManager.location.coordinate.longitude];
    NSArray *infos = [[NSArray alloc]initWithObjects:alert,longitude,latitude,address,self.message.text,nil];
    BOOL Update = [WebServices updateInformations:infos] ;
    NSLog(@"Update %@",infos);
    if (Update)
    {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Informations mise à jours",nil)];
        self.adresse.text = address;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"La mise à jour des informations à échouée...",nil)];
    
    }
}


- (void)startUpdateProcess
{
    
   
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Mise à jour des informations",nil) maskType:SVProgressHUDMaskTypeBlack];
    
    
    [locationManager startUpdatingLocation];
   // [self performSelectorOnMainThread:@selector(GetAdress) withObject:Nil waitUntilDone:YES];
    [self performSelector:@selector(GetAdress)  withObject:nil afterDelay:0];
    [self performSelector:@selector(StartUpdate) withObject:nil afterDelay:2];
    
}

-(void) GetAdress
{
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder reverseGeocodeLocation: locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         NSLog(@"Placemark array: %@",placemark.addressDictionary );
         
         //String to address
         NSString *locatedaddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         address = locatedaddress ;
     }];

}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    self.SendBut.titleLabel.text = NSLocalizedString(@"envoyer",nil);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.SendBut.titleLabel.text = @"";
    textField.text = nil;
    return YES;
}

@end

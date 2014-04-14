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
    
    [super viewDidLoad];
    alert = @"0";
    self.navigationItem.title = @"Protégé";
    self.StatutView.layer.borderColor =[UIColor blackColor].CGColor;
    self.StatutView.layer.borderWidth = 2.0f;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIImage *profile = [UIImage imageNamed:@"19-gear.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width, profile.size.height)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    
    UIImage *add = [UIImage imageNamed:@"user_add.png"];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, add.size.width, add.size.height)];
    [addButton setBackgroundImage:add forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addContact)  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem =[[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    self.navigationItem.rightBarButtonItem = addItem;
    
    self.navigationItem.leftBarButtonItem = profilItem;
  
    locationManager = [[CLLocationManager alloc]init];
    
}

- (void)addContact
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProAddViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OK:(id)sender {
    self.SecondStatutView.backgroundColor = [UIColor greenColor];
    alert = @"1";
    [self startUpdateProcess];
}

- (IBAction)Imprevu:(id)sender {
    self.SecondStatutView.backgroundColor = [UIColor orangeColor];
    alert = @"2";
  [self startUpdateProcess];
}

- (IBAction)Danger:(id)sender {
    self.SecondStatutView.backgroundColor = [UIColor redColor];
    alert = @"3";
    [self startUpdateProcess];
}
- (IBAction)send:(id)sender {
}

-(void)StartUpdate: (NSArray *)tab
{
    BOOL Update = [WebServices updateInformations:tab] ;
    
    if (Update)
    {
        [SVProgressHUD showSuccessWithStatus:@"Informations mise à jours"];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"La mise à jour des informations à échouée..."];
    
    }
}


- (void)startUpdateProcess
{
   
    [SVProgressHUD showWithStatus:@"Mise à jour des informations" maskType:SVProgressHUDMaskTypeBlack];
    [locationManager startUpdatingLocation];
    NSNull  *rien = [[NSNull alloc]init];
    NSString *latitude =[[NSString alloc]initWithFormat:@"%f",locationManager.location.coordinate.latitude];
    NSString *longitude =[[NSString alloc]initWithFormat:@"%f",locationManager.location.coordinate.longitude];
    NSArray *infos = [[NSArray alloc]initWithObjects:alert,longitude,latitude,@"inconue",rien,nil];
    NSLog(@" update : %@",infos);
   [self performSelector:@selector(StartUpdate:) withObject:infos afterDelay:0.2];
    
}

@end

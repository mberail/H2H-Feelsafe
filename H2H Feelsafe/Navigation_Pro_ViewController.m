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

@interface Navigation_Pro_ViewController ()<CLLocationManagerDelegate>

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
  
    //self.navigationItem.title = @"Protégé";
    
	// Do any additional setup after loading the view.
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
}

- (IBAction)Imprevu:(id)sender {
    self.SecondStatutView.backgroundColor = [UIColor orangeColor];
}

- (IBAction)Danger:(id)sender {
    self.SecondStatutView.backgroundColor = [UIColor redColor];
}
- (IBAction)send:(id)sender {
}
@end

//
//  Navigation_Pro_ViewController.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 29/03/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "Navigation_Pro_ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface Navigation_Pro_ViewController ()

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
    //self.navigationItem.title = @"Protégé";
    
	// Do any additional setup after loading the view.
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

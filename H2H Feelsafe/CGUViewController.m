//
//  CGUViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 28/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "CGUViewController.h"

@interface CGUViewController ()

@end

@implementation CGUViewController

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
	self.navigationItem.title = @"CGU";
    self.textView.textAlignment = NSTextAlignmentJustified;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Accepter" style:UIBarButtonItemStylePlain target:self action:@selector(dismissCGU)];
    self.navigationItem.rightBarButtonItem = item;
    //self.textView.text = @"";
}

- (void)dismissCGU
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CGUaccepted" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

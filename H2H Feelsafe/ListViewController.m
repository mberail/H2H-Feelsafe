//
//  ListViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 02/01/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "IIViewDeckController.h"
#import "ListViewController.h"

@interface ListViewController ()

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
    self.navigationItem.title = @"H2H Feelsafe";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIImage *profile = [UIImage imageNamed:@"19-gear.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width, profile.size.height)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItem = profilItem;
    
    UIImage *add = [UIImage imageNamed:@"user_add.png"];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, add.size.width, add.size.height)];
    [addButton setBackgroundImage:add forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem =[[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - MapView datasource

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
}

#pragma mark - MapView delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

@end

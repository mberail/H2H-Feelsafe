//
//  RefListViewController.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 05/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "RefListViewController.h"
#import "IIViewDeckController.h"
#import "WebServices.h"
#import "SVProgressHUD.h"

@interface RefListViewController ()
{
    NSArray *arrays;
}
@end

@implementation RefListViewController

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
    arrays = [[NSArray alloc]init];
    [self performSelectorOnMainThread:@selector(proceedGetting) withObject:nil waitUntilDone:YES];
    // NSLog(@"referent %@",arrays);
    UIImage *profile = [UIImage imageNamed:@"LeftBut.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width/1.5, profile.size.height/1.5)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItem = profilItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.edit ButtonItem;
}

-(void)proceedGetting
{
    
    [SVProgressHUD show];
    [self performSelectorInBackground:@selector(getReferent) withObject:nil];
    
}

-(void)getReferent
{
    arrays = [WebServices referentsInfos];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Mes référents";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return arrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (cell ==nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *referent = [[NSDictionary alloc]init];
    referent = [arrays objectAtIndex:indexPath.row];
    NSLog(@"referent %@",referent);
    cell.textLabel.font = [UIFont fontWithName:nil size:25];
     cell.textLabel.text = [referent objectForKey:@"username"];
    NSString *infos = [NSString stringWithFormat:@"%@ %@    %@",[referent objectForKey:@"firstname"],[referent objectForKey:@"lastname"],[referent objectForKey:@"phone"]];
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.text = infos;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
}
@end

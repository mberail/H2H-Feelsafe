//
//  NavigationViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 02/01/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "IIViewDeckController.h"
#import "NavigationViewController.h"

@interface NavigationViewController ()
{
    NSArray *textes;
}
@end

@implementation NavigationViewController

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
    NSArray *first = [NSArray arrayWithObjects:@"Protégés",@"Périmètres", nil];
    NSArray *second = [NSArray arrayWithObjects:@"Notifications",@"Mon compte", nil];
    NSArray *third = [NSArray arrayWithObjects:@"Aide",@"Déconnexion", nil];
    textes = [NSArray arrayWithObjects:first,second,third, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return textes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[textes objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NavigationCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NavigationCell"];
    }
    cell.textLabel.text = [[textes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"Déconnexion"])
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Voulez-vous vraiment vous déconnecter ?" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:@"Déconnexion" otherButtonTitles:nil];
        action.actionSheetStyle = UIActionSheetStyleAutomatic;
        [action showInView:self.view];
    }
    else if ([cell.textLabel.text isEqualToString:@"Protégés"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
        [self.viewDeckController closeLeftView];
    }
    else if ([cell.textLabel.text isEqualToString:@"Périmètres"])
    {
        
    }
    [self.tableView reloadData];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionTransitionNone animations:^{[self.viewDeckController closeLeftView];} completion:^(BOOL finished){if (finished)[self dismissModalViewControllerAnimated:YES];}];
    }
}

@end

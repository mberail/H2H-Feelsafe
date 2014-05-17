//
//  NavigationViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 02/01/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "IIViewDeckController.h"
#import "NavigationViewController.h"
#import "SVProgressHUD.h"

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
    NSArray *first = [NSArray arrayWithObjects:NSLocalizedString(@"Protégés",nil),NSLocalizedString( @"Périmètres", nil),nil];
    NSArray *second = [NSArray arrayWithObjects:NSLocalizedString(@"Notifications",nil),NSLocalizedString(@"Mon compte",nil), nil];
    NSArray *third = [NSArray arrayWithObjects:NSLocalizedString(@"Aide",nil),NSLocalizedString(@"Déconnexion",nil), nil];
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
    cell.textLabel.textColor = [[UIColor alloc]initWithRed:(142.0/255.0) green:(20./255.0) blue:(129./255.0) alpha:1.0];
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
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Déconnexion",nil)])
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Voulez-vous vraiment vous déconnecter ?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Annuler",nil) destructiveButtonTitle:NSLocalizedString(@"Déconnexion",nil) otherButtonTitles:nil];
        action.actionSheetStyle = UIActionSheetStyleAutomatic;
        [action showInView:self.view];
    }
    else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Protégés",nil)])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
        [self.viewDeckController closeLeftView];
    }
    else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Notifications",nil)])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
        self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
        [self.viewDeckController closeLeftView];
    }
    else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Périmètres",nil)])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PerimeterViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
        self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
        [self.viewDeckController closeLeftView];
    }
    else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Mon compte",nil)])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UpdateAccountViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
         self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
        [self.viewDeckController closeLeftView];
    }
    else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Aide",nil)])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UIGuideViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
        [self.viewDeckController closeLeftView];
    }
    [self.tableView reloadData];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isConnected"];
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults]    ;
        [pref removeObjectForKey:@"picture"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
        [self.viewDeckController closeLeftView];
        //[UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionTransitionNone animations:^{[self.viewDeckController closeLeftView];} completion:^(BOOL finished){if (finished)[self dismissViewControllerAnimated:YES completion:^{[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isConnected"];}];}]; //fermeture des vues + mise en cache de la déconnexion
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isConnected"]);
    }
}


@end

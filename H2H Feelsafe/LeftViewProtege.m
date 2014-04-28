//
//  LeftViewProtege.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 01/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "IIViewDeckController.h"
#import "LeftViewProtege.h"

@interface LeftViewProtege ()
{
    NSArray *textes;
}


@end

@implementation LeftViewProtege

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
    NSArray *first = [NSArray arrayWithObjects:@"Protégés"/*@",Périmètres"*/, nil];
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
    else if ([cell.textLabel.text isEqualToString:@"Mon compte"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UpdateAccountViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
        [self.viewDeckController closeLeftView];
    }
    else if ([cell.textLabel.text isEqualToString:@"Protégés"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Navigation_Pro_ViewController"];
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
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isConnected"];
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults  ];
        [pref removeObjectForKey:@"picture"];
        [pref removeObjectForKey:@"password"];
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

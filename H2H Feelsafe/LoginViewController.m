//
//  LoginViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "LoginViewController.h"
#import "signUpCell.h"
#import "WebServices.h"
#import "NavigationViewController.h"
#import "ListViewController.h"
#import "IIViewDeckController.h"

@interface LoginViewController ()
{
    NSArray *labels;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Suivant" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = @"Connexion";
	
    labels = [[NSArray alloc] initWithObjects:@"Identifiant",@"Mot de passe", nil];
}

- (void)login
{
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < labels.count; i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        signUpCell *cell = (signUpCell *)[self.tableView cellForRowAtIndexPath:index];
        if (cell.theTextField.text.length == 0)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Veuillez compléter tous les champs" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
            
        }
        [mutArray addObject:cell.theTextField.text];
    }
    if (mutArray.count == labels.count)
    {
        BOOL login = [WebServices login:mutArray];
        if (login)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            UIViewController *leftvc = [storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
            IIViewDeckController *viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:nvc leftViewController:leftvc];
            viewDeck.leftSize = 65;
            viewDeck.panningMode = IIViewDeckNavigationBarPanning;
            [self.navigationController presentViewController:viewDeck animated:YES completion:nil];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Identifiants incorrects, veuillez réessayer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return labels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    signUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signUpCell"];
    if (cell == nil)
    {
        cell = [[signUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"signUpCell"];
    }
    cell.leftLabel.text = [labels objectAtIndex:indexPath.row];
    if (indexPath.row == 1)
    {
        cell.theTextField.secureTextEntry = YES;
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
#import "SVProgressHUD.h"
#import <AddressBookUI/AddressBookUI.h>

@interface LoginViewController ()
{
    NSArray *labels;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Suivant",nil) style:UIBarButtonItemStylePlain target:self action:@selector(proceedWithLogin)];
    self.navigationItem.rightBarButtonItem = item;
    
   // self.recup.image = [UIImage imageNamed:@"no_img"];
    self.navigationItem.title = NSLocalizedString(@"Connexion",nil);
	self.navigationItem.leftBarButtonItem =nil;
    labels = [[NSArray alloc] initWithObjects:@"Email",NSLocalizedString(@"Mot de passe",nil), nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if(  [ [ UIScreen mainScreen ] bounds ].size.height== 568)
    {
        self.tableView.rowHeight = 44.0;
        self.Valider.frame = CGRectMake(self.Valider.frame.origin.x, self.Valider.frame.origin.y +40, self.Valider.frame.size.width, self.Valider.frame.size.height);
        
    }
    


}

- (void)proceedWithLogin
{
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < labels.count; i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        signUpCell *cell = (signUpCell *)[self.tableView cellForRowAtIndexPath:index];
        if (cell.theTextField.text.length == 0)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Veuillez compléter tous les champs",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
            
        }
        [mutArray addObject:cell.theTextField.text];
    }
    if (mutArray.count != labels.count)
    {
        return;
    }
    for (int i = 0; i < mutArray.count; i++)
    {
        NSString *expression = @"";
        if (i == 0)
        {
            expression = @"[\\w-_.]{1,30}@[\\w-_.]{1,30}\\.[a-z]{2,6}";
        }
        else
            expression = @".{6,30}";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:mutArray[i] options:0 range:NSMakeRange(0, [mutArray[i] length])];
        if (!match)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Champs mal complétés",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
    }
    [self startLoginProcess:mutArray];
}

- (void)startLoginProcess:(NSArray *)tab
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Vérification du Mot de passe",nil) maskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(login:) withObject:tab afterDelay:0.2];
}

- (void)login:(NSArray *)tab
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *status = [pref objectForKey:@"status"];
    NSLog(@"status : %@",status);
    BOOL login = [WebServices login:tab];
    
    if (login )
    {
        if ([status isEqual:@"referent"])
        {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Bienvenue",nil)];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        UIViewController *leftvc = [storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
        IIViewDeckController *viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:nvc leftViewController:leftvc];
        viewDeck.leftSize = 65;
        viewDeck.panningMode = IIViewDeckNavigationBarPanning;
        [self.navigationController presentViewController:viewDeck animated:YES completion:nil];
        }
        else if ([status isEqual:@"protege"])
        {[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Bienvenue",nil)];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Navigation_Pro_ViewController"];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            UIViewController *leftvc = [storyboard instantiateViewControllerWithIdentifier:@"LeftViewProtege"];
            IIViewDeckController *viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:nvc leftViewController:leftvc];
            viewDeck.leftSize = 65;
            viewDeck.panningMode = IIViewDeckNavigationBarPanning;
            [self.navigationController presentViewController:viewDeck animated:YES completion:nil];
          //  [[[UIAlertView alloc] initWithTitle:nil message:@"Page protégé en cours de conception" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                 }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Mot-de-passe incorrect",nil)];
    }

}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

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
    if(  [ [ UIScreen mainScreen ] bounds ].size.height== 568)
    {
        cell.leftLabel.frame = CGRectMake(cell.leftLabel.frame.origin.x, 10, cell.leftLabel.frame.size.width, cell.leftLabel.frame.size.height);
        cell.theTextField.frame = CGRectMake(cell.theTextField.frame.origin.x, 10, cell.theTextField.frame.size.width, cell.theTextField.frame.size.height);
    }
    
    if (cell == nil)
    {
        cell = [[signUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"signUpCell"];
    }
    cell.leftLabel.text = [labels objectAtIndex:indexPath.row];
    if (indexPath.row == 1)
    {
        cell.theTextField.secureTextEntry = YES;
        [cell.theTextField becomeFirstResponder ];
       
    }
    if (indexPath.row == 0)
    {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        NSString *email = [pref objectForKey:@"email"];
        cell.theTextField.text = email;
        cell.theTextField.textColor = [UIColor grayColor];
        [cell.theTextField setUserInteractionEnabled:false];
    }
    self.tableView.scrollEnabled = NO;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Mailpassword:(id)sender {
     [SVProgressHUD show];
    [self performSelector:@selector(startresetProcess) withObject:nil afterDelay:0.2];
}



- (void)startresetProcess
{
    [self performSelector:@selector(reset)];
}

- (void)reset
{
    [WebServices resetPassword];
}
- (IBAction)Valid:(id)sender {
    [self proceedWithLogin];
}
@end

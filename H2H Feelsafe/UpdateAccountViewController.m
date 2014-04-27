//
//  UpdateAccountViewController.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 02/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "UpdateAccountViewController.h"
#import "SignUpViewController.h"
#import "signUpCell.h"
#import "WebServices.h"
#import "IIViewDeckController.h"
#import "SVProgressHUD.h"


@interface UpdateAccountViewController ()
{
    NSArray *labels;
    UIAlertView *Check;
    NSString *pass;
}
@end

@implementation UpdateAccountViewController


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
    
   
    
    self.navigationItem.title = @"Mise à jour du compte";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSArray *labelsFirst = [[NSArray alloc] initWithObjects:@"Identifiant",@"Nouveau mot de passe",@"Confirmation mot de passe", nil];
    NSArray *labelsSecond = [[NSArray alloc] initWithObjects:@"E-mail",@"Mobile",@"Nom",@"Prénom", nil];
      labels = [[NSArray alloc] initWithObjects:labelsFirst,labelsSecond, nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Edit)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
   /* UIImage *profile = [UIImage imageNamed:@"19-gear.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width, profile.size.height)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItem = profilItem;*/
    
	//UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Terminé" style:UIBarButtonItemStylePlain target:self action:@selector(signup)];
    //self.navigationItem.rightBarButtonItem = item;
    [self.tableView setUserInteractionEnabled:NO];
    Check =  [[UIAlertView alloc] initWithTitle:@"Mot de passe" message:@"Veuiller inscrire votre mot de passe utilisateur" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Ok", nil];
    Check.alertViewStyle = UIAlertViewStylePlainTextInput;
    [Check textFieldAtIndex:0].delegate = self;
    [Check textFieldAtIndex:0].secureTextEntry = YES;
    UIButton *picture = [[UIButton alloc]init];
    picture.enabled = NO;
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    pass = [pref objectForKey:@"password"];
    
}
-(void)Annuler
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.viewDeckController.centerController = navController;
}
-(void)Edit
{
    [Check show];
}
-(void) Verif
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSLog(@"Vérification du mot de passe");
    NSString *truc = [pref objectForKey:@"password"];
    if ([[Check textFieldAtIndex:0].text isEqualToString:truc])
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(Update)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStyleBordered target:self action:@selector(Annuler)];
            [self.tableView setUserInteractionEnabled:YES];
        }
    else
    {
        UIAlertView *Faux = [[UIAlertView alloc]initWithTitle:@"Mot de passe incorect" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [Faux show];
    }
}
-(void)StartUpdate: (NSMutableDictionary *)tab
{
    BOOL Update = [WebServices updateAccount:tab] ;
    
    if (Update)
    {
        
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        [pref setObject:pass forKey:@"password"];
        if([[pref objectForKey:@"staus"]isEqualToString:@"referent"])
        {
            [SVProgressHUD showSuccessWithStatus:@"Informations mises à jour !"];
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
            [SVProgressHUD showSuccessWithStatus:@"Informations mises à jour !"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Navigation_Pro_ViewController"];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            UIViewController *leftvc = [storyboard instantiateViewControllerWithIdentifier:@"LeftViewProtege"];
            IIViewDeckController *viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:nvc leftViewController:leftvc];
            viewDeck.leftSize = 65;
            viewDeck.panningMode = IIViewDeckNavigationBarPanning;
            [self.navigationController presentViewController:viewDeck animated:YES completion:nil];
        }
        
        
    }
    else
    {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:nil message:@"Tous les champs ne sont pas correctement remplis, veuillez réessayer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}


- (void)startUpdateProcess:(NSMutableDictionary *)tab
{
    [SVProgressHUD showWithStatus:@"Mise à jour des informations" maskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(StartUpdate:) withObject:tab afterDelay:0.2];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return labels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[labels objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    NSDictionary *infos = [pref objectForKey:@"infos"];
    NSLog(@"%@",infos)  ;
    signUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signUpCell"];
    if (cell == nil)
    {
        cell = [[signUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"signUpCell"];
    }
    cell.theTextField.placeholder = [[labels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0)
    {

        if(indexPath.row == 0)
        {
            cell.theTextField.text = [infos objectForKey:@"username"];
        }
        if (indexPath.row == 1 || indexPath.row == 2)
        {
            cell.theTextField.secureTextEntry = YES;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            
        
            cell.theTextField.text = [pref objectForKey:@"email"];
         }
        if (indexPath.row == 1)
        {
            
            cell.rightLabel.text = @"";
            cell.theTextField.text = [infos objectForKey:@"phone"];
        }
        if (indexPath.row == 2)
        {
            
            cell.rightLabel.text = @"";
            cell.theTextField.text = [infos objectForKey:@"lastname"];
        }
        if (indexPath.row == 3)
        {
            cell.rightLabel.text = @"";
            cell.theTextField.text = [infos objectForKey:@"firstname"];
        }
        else
        {
            cell.rightLabel.text = @"";
        }
    }
      return cell;
}

- (void)Update
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    NSDictionary *infos = [pref objectForKey:@"infos"];
    BOOL reallyBreak = NO;
    for (int i = 0; i < labels.count; i++)
    {
        if (reallyBreak)
        {
            break;
        }
        NSArray *label = [labels objectAtIndex:i];
        
        for (int j = 0; j < label.count; j++)
        {
            NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
            signUpCell *cell = (signUpCell *)[self.tableView cellForRowAtIndexPath:index];
            if (index.section == 0 && index.row == 0)
            {
                NSString *expression = @"[0-9a-z]{4,100}";
                NSError *error = nil;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
                NSTextCheckingResult *match = [regex firstMatchInString:cell.theTextField.text options:0 range:NSMakeRange(0, cell.theTextField.text.length)];
                if (!match)
                {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Le username ne doit contenir au moins 4 lettres minuscules et/ou des chiffres :" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    reallyBreak = YES;
                    break;
                }
            }
            if (index.section == 1 && index.row == 0)
            {
                NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                NSError *error = nil;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
                NSTextCheckingResult *match = [regex firstMatchInString:cell.theTextField.text options:0 range:NSMakeRange(0, cell.theTextField.text.length)];
                if (!match)
                {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Veuillez compléter une adresse mail valide." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    reallyBreak = YES;
                    break;
                }
            }
            if (index.section != 2)
            {
                if (index.section == 0)
                {
                    if(index.row == 0)
                    {
                        if([cell.theTextField.text isEqualToString:[infos objectForKey:@"username"]])
                        {
                            continue;
                        }
                        else
                        {
                            [mutDict setObject:cell.theTextField.text forKey:@"username"]  ;
                            
                        }
                    }
                    if(index.row == 1 )
                    {
                        if([cell.theTextField.text isEqualToString:[pref objectForKey:@"password"]])
                        {
                            continue;
                        }
                        else
                        {
                            
                            [mutDict setObject:cell.theTextField.text forKey:@"password"];
                            if(cell.theTextField.text.length != 0)
                            {
                                    pass = cell.theTextField.text;
                            }
                        
                        }
                    }
                    if(index.row == 2)
                    {
                        if([cell.theTextField.text isEqualToString:[infos objectForKey:@"confirmation"]])
                        {
                            continue;
                        }
                        else
                        {
                            [mutDict setObject:cell.theTextField.text forKey:@"confirmation"]  ;
                        }
                    }
                    
                }
                if (index.section == 1)
                {
                    if(index.row == 0)
                    {
                        if([cell.theTextField.text isEqualToString:[infos objectForKey:@"mail"]])
                        {
                            continue;
                        }
                        else
                        {
                         [mutDict setObject:cell.theTextField.text forKey:@"mail"] ;
                        [pref setObject:cell.theTextField.text forKey:@"email"];
                        }
                    }
                    if(index.row == 1 )
                    {
                        if([cell.theTextField.text isEqualToString:[infos objectForKey:@"phone"]])
                        {
                            continue;
                        }
                        else
                        {
                              [mutDict setObject:cell.theTextField.text forKey:@"phone"] ;
                             [pref setObject:cell.theTextField.text forKey:@"phone"];
                        }
                    }
                    if(index.row == 2)
                    {
                        if([cell.theTextField.text isEqualToString:[infos objectForKey:@"firstname"]])
                        {
                            continue;
                        }
                        else
                        {
                              [mutDict setObject:cell.theTextField.text forKey:@"firstname"]  ;
                             [pref setObject:cell.theTextField.text forKey:@"firstname"];
                        }
                    }
                    if(index.row == 3)
                    {
                        if([cell.theTextField.text isEqualToString:[infos objectForKey:@"lastname"]])
                        {
                            continue;
                        }
                        else
                        {
                            [mutDict setObject:cell.theTextField.text forKey:@"lastname"]  ;
                             [pref setObject:cell.theTextField.text forKey:@"lastname"];
                        }
                    }
                }
            }
        }
    }
    

        NSLog(@"mutDict : %@",mutDict);
        
        
        [self startUpdateProcess:mutDict];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else
    {
        [self Verif];
    }
}


- (IBAction)picture:(id)sender
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *delete = nil;
    if ([pref objectForKey:@"picture"])
    {
        delete = @"Supprimer la photo";
    }
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:delete otherButtonTitles:@"Choisir une photo",@"Prendre une photo", nil];
    action.actionSheetStyle = UIActionSheetStyleAutomatic;
    [action showInView:self.view];
}
#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Choisir une photo"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ALGroupViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"Prendre une photo"])
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
            imagePicker.allowsEditing = NO;
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else if ([title isEqualToString:@"Supprimer la photo"])
    {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        [pref removeObjectForKey:@"picture"];
        self.PictureView.image = [UIImage imageNamed:@"default_profile.jpg"];
    }
}

#pragma mark - ImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error)
     {
         NSLog(@"url : %@",assetURL);
         ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset)
         {
             CGImageRef ref = [asset thumbnail];
             NSLog(@"ref : %@",ref);
             if (ref)
             {
                 UIImage *image = [UIImage imageWithCGImage:ref];
                 self.PictureView.image = image;
                 NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                 [pref setObject:UIImagePNGRepresentation(image) forKey:@"picture"];
             }
         };
         ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){NSLog(@"error : %@",error.localizedDescription);};
         if (assetURL)
         {
             ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
             [assetsLibrary assetForURL:assetURL resultBlock:resultBlock failureBlock:failureBlock];
         }
     }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGRect frameCell = textField.superview.superview.superview.frame;
    if (frameCell.origin.y > 0 && self.view.frame.origin.y == -180)
    {
        [UIView animateWithDuration:0.2 animations:^{CGRect tabFrame = self.view.frame;
            tabFrame.origin.y += 180;
            self.view.frame = tabFrame;}];
    }
    [textField resignFirstResponder];
    return YES;
}

@end

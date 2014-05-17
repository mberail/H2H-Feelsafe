//
//  UpdateAccountViewController.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 02/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "UpdateAccountViewController.h"
//#import "SignUpViewController.h"
#import "signUpCell.h"
#import "WebServices.h"
#import "IIViewDeckController.h"
#import "SVProgressHUD.h"


@interface UpdateAccountViewController ()
{
    NSArray *labels;
    UIAlertView *Check;
    NSString *pass;
    //UIImagePickerController *picker;
    NSMutableArray *nextTArray;
    NSMutableArray *countries;
    NSString *currentCountry;
    
    int tag;
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
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    currentCountry = [NSString stringWithFormat:@"%@",[pref objectForKey:@"country"]];
    nextTArray = [[NSMutableArray alloc]init];
   
       countries = [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"Allemagne", nil),NSLocalizedString(@"Australie", nil),NSLocalizedString(@"Autriche", nil),NSLocalizedString(@"Belgique", nil),NSLocalizedString(@"Danemark", nil),NSLocalizedString(@"Espagne", nil),NSLocalizedString(@"France", nil),NSLocalizedString(@"Inde", nil),NSLocalizedString(@"Italie", nil),NSLocalizedString(@"Pays-Bas", nil), nil];
    
    self.navigationItem.title = NSLocalizedString(@"Mise à jour du compte",nil);
    
    
    NSArray *labelsFirst = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Identifiant",nil),NSLocalizedString(@"Nouveau mot de passe",nil),NSLocalizedString(@"Confirmation mot de passe",nil), nil];
    NSArray *labelsSecond = [[NSArray alloc] initWithObjects:@"E-mail",@"Mobile",NSLocalizedString(@"Pays", nil),NSLocalizedString(@"Nom",nil),NSLocalizedString(@"Prénom",nil), nil];
      labels = [[NSArray alloc] initWithObjects:labelsFirst,labelsSecond, nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Edit)];
    UIImage *profile = [UIImage imageNamed:@"LeftBut.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width/1.5, profile.size.height/1.5)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItem = profilItem;
    [self.tableView setUserInteractionEnabled:NO];
    [self.PictureView setUserInteractionEnabled:NO];
    
    Check =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Mot de passe",nil) message:NSLocalizedString(@"Veuiller inscrire votre mot de passe utilisateur",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Annuler",nil) otherButtonTitles:@"Ok", nil];
    Check.alertViewStyle = UIAlertViewStylePlainTextInput;
    [Check textFieldAtIndex:0].delegate = self;
    [Check textFieldAtIndex:0].secureTextEntry = YES;
   
    pass = [pref objectForKey:@"password"];
    
    self.PictureView.contentMode = UIViewContentModeScaleAspectFit;
    
    if([pref objectForKey:@"picture"])
       {
           self.PictureView.image = [self decodeBase64ToImage:[pref objectForKey:@"picture"]];
           
       }
    else
    {
        self.PictureView.image = [UIImage imageNamed:@"default_profile.jpg"];
    }
  
    
    
}
-(void)Annuler
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if([[pref objectForKey:@"status"]isEqualToString:@"referent"])
    {
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Navigation_Pro_ViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.viewDeckController.centerController = navController;
    }
}

-(void)Edit
{
    [Check show];
}
-(void) Verif
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *truc = [pref objectForKey:@"password"];
    if ([[Check textFieldAtIndex:0].text isEqualToString:truc])
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(Update)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStyleBordered target:self action:@selector(Annuler)];
            [self.Picture setEnabled:YES];
            [self.tableView setUserInteractionEnabled:YES];
        }
    else
    {
        UIAlertView *Faux = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Mot de passe incorrect",nil) message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
        if([[pref objectForKey:@"status"]isEqualToString:@"referent"])
        {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Informations mises à jour !",nil)];
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
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Informations mises à jour !",nil)];
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
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Tous les champs ne sont pas correctement remplis, veuillez réessayer.",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}


- (void)startUpdateProcess:(NSMutableDictionary *)tab
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Mise à jour des informations",nil) maskType:SVProgressHUDMaskTypeBlack];
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
            cell.theTextField.text = currentCountry;
            [cell.theTextField setUserInteractionEnabled:false];
        }
        if (indexPath.row == 2)
        {
            
            cell.rightLabel.text = @"";
            cell.theTextField.text = [infos objectForKey:@"phone"];
        }
        if (indexPath.row == 3)
        {
            
            cell.rightLabel.text = @"";
            cell.theTextField.text = [infos objectForKey:@"lastname"];
        }
        if (indexPath.row == 4)
        {
            cell.rightLabel.text = @"";
            cell.theTextField.text = [infos objectForKey:@"firstname"];
        }
        else
        {
            cell.rightLabel.text = @"";
        }
    }
     [cell.rightLabel setHidden:YES];
    [nextTArray addObject:cell.theTextField    ];
      return cell;
}


#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            self.CountrySelector.hidden = false;
        }
        
    }
        [self.tableView reloadData];
    
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
                    [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Le username ne doit contenir au moins 4 lettres minuscules et/ou des chiffres :",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
                    [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Veuillez compléter une adresse mail valide.",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
                    if (index.row == 1 )
                    {
                        NSLog(@"on est là mon grand %@  et %@",[pref objectForKey:@"country"],cell.theTextField.text);
                        if([cell.theTextField.text isEqualToString:[pref objectForKey:@"country"]])
                            {
                                continue    ;
                            }
                        else
                        {
                            [mutDict setObject:cell.theTextField.text forKey:@"country"];
                            [pref setObject:cell.theTextField.text forKey:@"country"];
                        }
                        
                    }
                    if(index.row == 2 )
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
                    if(index.row == 3)
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
                    if(index.row == 4)
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
    
    NSString *country = [mutDict objectForKey:@"country"];
    
    
    void (^selectedCase)() = @{
                               
                               NSLocalizedString(@"Allemagne", nil): ^{
                                   [mutDict setObject:@"49" forKey:@"country"];
                               },
                               NSLocalizedString(@"Australie", nil): ^{
                                   [mutDict setObject:@"61" forKey:@"country"];
                               },
                               NSLocalizedString(@"Autriche", nil): ^{
                                   [mutDict setObject:@"43" forKey:@"country"];
                               },
                               NSLocalizedString(@"Belgique", nil): ^{
                                   [mutDict setObject:@"32" forKey:@"country"];
                               },
                               NSLocalizedString(@"Danemark", nil): ^{
                                   [mutDict setObject:@"45" forKey:@"country"];
                               },
                               NSLocalizedString(@"Espagne", nil): ^{
                                   [mutDict setObject:@"34" forKey:@"country"];
                               },
                               NSLocalizedString(@"France", nil): ^{
                                   [mutDict setObject:@"33" forKey:@"country"];
                               },
                               NSLocalizedString(@"Inde", nil): ^{
                                   [mutDict setObject:@"91" forKey:@"country"];
                               },
                               NSLocalizedString(@"Italie", nil): ^{
                                   [mutDict setObject:@"39" forKey:@"country"];
                               },
                               NSLocalizedString(@"Pays-Bas", nil): ^{
                                   [mutDict setObject:@"31" forKey:@"country"];
                               },
                               }[country];
    if (selectedCase != nil)
        selectedCase();

    
        if ([pref objectForKey:@"picture"])
        {
            
            UIImage *imageToSend = [UIImage imageWithData:[pref objectForKey:@"picture"]];
        
           // NSData *photoData = [[pref objectForKey:@"picture"] base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];;
            NSString *Image64 = [[NSString  alloc]init];
            Image64 =[self encodeToBase64String:imageToSend];
           [mutDict setObject:Image64 forKey:@"picture"];
            NSLog(@"mutDict : %@",Image64);
            _testImage.image = [self decodeBase64ToImage:Image64];
            
            
               [self performSelector:@selector(startUpdateProcess:) withObject:mutDict afterDelay:0.5];
        }
    else
    {
        [self startUpdateProcess:mutDict];
    }
    

    
   
    
    
    
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(NSString *)getStringFromImage:(UIImage *)image{
	if(image){
		NSData *dataObj = UIImagePNGRepresentation(image);
		return [dataObj base64Encoding];
	} else {
		return @"";
	}
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
        delete = NSLocalizedString(@"Supprimer la photo",nil);
    }
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Annuler",nil) destructiveButtonTitle:delete otherButtonTitles:NSLocalizedString(@"Choisir une photo",nil),NSLocalizedString(@"Prendre une photo",nil), nil];
    action.actionSheetStyle = UIActionSheetStyleAutomatic;
    [action showInView:self.view];
}


#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:NSLocalizedString(@"Choisir une photo",nil)])
    {
        picker = [[UIImagePickerController alloc ]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ALGroupViewController"];
        [self.navigationController pushViewController:vc animated:YES];*/
    }
    else if ([title isEqualToString:NSLocalizedString(@"Prendre une photo",nil)])
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
    else if ([title isEqualToString:NSLocalizedString(@"Supprimer la photo",nil)])
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


#pragma mark - TextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    CGRect frameCell = textField.superview.superview.superview.frame;
    if (frameCell.origin.y > 160 && self.view.frame.origin.y == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{CGRect frame = self.view.frame;
            frame.origin.y -= 170;
            self.view.frame = frame;}];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    int x=tag+1;

    if (x<8)
    {
          UITextField *nextTextField = (UITextField *)[nextTArray objectAtIndex:x];
        if (x<3) {
            if (self.view.frame.origin.y == -170)
            {
                [UIView animateWithDuration:0.2 animations:^{CGRect tabFrame = self.view.frame;
                    tabFrame.origin.y += 170;
                    self.view.frame = tabFrame;}];
            }
            [nextTextField becomeFirstResponder];
            tag ++;
        }
        
        else if ( x>=3 )
        {
            [nextTextField becomeFirstResponder];
            if (x == 3)
            {
                tag ++;
            }
            tag ++;
        }
    }
  
   
    else
    {
        if (self.view.frame.origin.y == -170)
        {
            [UIView animateWithDuration:0.2 animations:^{CGRect tabFrame = self.view.frame;
                tabFrame.origin.y += 170;
                self.view.frame = tabFrame;}];
        }
        tag = 0;
        [textField resignFirstResponder ];
        return YES;
        
    }
    return YES;
}


#pragma mark - PickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [countries count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [countries objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentCountry = [NSString stringWithFormat:@"%@",[countries objectAtIndex:row]];
    [self.tableView reloadData];
    if (self.view.frame.origin.y == -180)
    {
        [UIView animateWithDuration:0.2 animations:^{CGRect tabFrame = self.view.frame;
            tabFrame.origin.y += 180;
            self.view.frame = tabFrame;}];
    }
    pickerView.hidden = YES;
}



@end

//
//  SignUpViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "SignUpViewController.h"
#import "signUpCell.h"
#import "WebServices.h"
#import "IIViewDeckController.h"
#import "SVProgressHUD.h"

@interface SignUpViewController ()
{
    NSArray *labels;
    NSMutableArray *nextTFarray;
    int tag;
    NSMutableArray *countries;
    UIImagePickerController *picker;
}
@end

@implementation SignUpViewController
@synthesize accepted;

- (void)viewDidLoad
{
    tag = 0;
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"Inscription", nil);
 
    countries = [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"Allemagne", nil),NSLocalizedString(@"Australie", nil),NSLocalizedString(@"Autriche", nil),NSLocalizedString(@"Belgique", nil),NSLocalizedString(@"Danemark", nil),NSLocalizedString(@"Espagne", nil),NSLocalizedString(@"France", nil),NSLocalizedString(@"Inde", nil),NSLocalizedString(@"Italie", nil),NSLocalizedString(@"Pays-Bas", nil), nil];
    
    nextTFarray = [[NSMutableArray alloc]init];
    
    NSArray *labelsFirst = [[NSArray alloc] initWithObjects:NSLocalizedString( @"Identifiant",nil),NSLocalizedString(@"Mot de passe",nil),NSLocalizedString(@"Confirmation mot de passe",nil), nil];
    NSArray *labelsSecond = [[NSArray alloc] initWithObjects:NSLocalizedString(@"E-mail",nil),NSLocalizedString(@"Pays",nil),NSLocalizedString(@"Mobile",nil),NSLocalizedString(@"Nom",nil),NSLocalizedString(@"Prénom",nil), nil];
    NSArray *labelsThird = [[NSArray alloc] initWithObjects:NSLocalizedString(@"J'accepte les CGU",nil), nil];
    labels = [[NSArray alloc] initWithObjects:labelsFirst,labelsSecond,labelsThird, nil];
    
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Terminé",nil) style:UIBarButtonItemStylePlain target:self action:@selector(signup)];
    self.navigationItem.rightBarButtonItem = item;
    accepted = NO;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CGUaccepted) name:@"CGUaccepted" object:nil];
}


-(void)StartSignUp: (NSArray *)tab
{
    BOOL signUp = [WebServices signUp:tab] ;
    [SVProgressHUD dismiss];
    if (signUp)
    {
        if(self.segmentedControl.selectedSegmentIndex == 0)
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
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Navigation_Pro_ViewController"];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            UIViewController *leftvc = [storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
            IIViewDeckController *viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:nvc leftViewController:leftvc];
            viewDeck.leftSize = 65;
            viewDeck.panningMode = IIViewDeckNavigationBarPanning;
            [self.navigationController presentViewController:viewDeck animated:YES completion:nil];
        }
    }
    else
    {
        //[[[UIAlertView alloc] initWithTitle:nil message:@"Tous les champs ne sont pas correctement remplis, veuillez réessayer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}


- (void)startSignupProcess:(NSArray *)tab
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Inscription en cours",nil) maskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(StartSignUp:) withObject:tab afterDelay:0.2];

}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([pref objectForKey:@"picture"])
    {
        self.pictureView.image = [UIImage imageWithData:[pref objectForKey:@"picture"]];
    }
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.pictureView.image =nil;
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults ];
    [pref removeObjectForKey:@"picture"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)signup
{
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
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
            if ([cell.rightLabel.text isEqualToString:@"*"] && cell.theTextField.text.length == 0)
            {
                [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Veuillez compléter tous les champs obligatoires.",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                reallyBreak = YES;
                break;
                
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
            if (index.section == 2 && cell.accessoryType == UITableViewCellAccessoryNone)
            {
                [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Veuillez accepter les CGU",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                reallyBreak = YES;
                break;
            }
            if (index.section != 2)
            {
                [mutArray addObject:cell.theTextField.text];
            }
        }
    }
   
    if (mutArray.count == 8 && accepted)
    {
        
        NSString *statut = @"";
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        if (self.segmentedControl.selectedSegmentIndex == 0)
        {
            statut = @"referent";
        }
        else if (self.segmentedControl.selectedSegmentIndex == 1)
        {
            statut = @"protege";
        }
        [pref setObject:statut forKey:@"status"];
        NSString *country = [mutArray objectAtIndex:4];
      
      
            void (^selectedCase)() = @{
                                       
                                       NSLocalizedString(@"Allemagne", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"49"] atIndexedSubscript:4];
                                       },
                                       NSLocalizedString(@"Australie", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"61"] atIndexedSubscript:4];
                                       },
                                       NSLocalizedString(@"Autriche", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"43"] atIndexedSubscript:4];
                                       },
                                       NSLocalizedString(@"Belgique", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"32"] atIndexedSubscript:4];
                                       },
                                       NSLocalizedString(@"Danemark", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"45"] atIndexedSubscript:4];
                                       },
                                       NSLocalizedString(@"Espagne", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"34"] atIndexedSubscript:4];
                                       },
                                       NSLocalizedString(@"France", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"33"] atIndexedSubscript:4];
                                       },
                                       NSLocalizedString(@"Inde", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"91"] atIndexedSubscript:4];
                                       },
                                       NSLocalizedString(@"Italie", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"39"] atIndexedSubscript:4];
                                       },
                                       NSLocalizedString(@"Pays-Bas", nil): ^{
                                           [mutArray setObject:[NSString stringWithFormat:@"31"] atIndexedSubscript:4];
                                       },
                                       }[country];
            if (selectedCase != nil)
               selectedCase();
        
        
    
         NSLog(@"mutArray : %@",mutArray);
        
        
        [self startSignupProcess:mutArray];
    }
}

- (void)CGUaccepted
{
    accepted = YES;
}

- (void)displayCGU
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CGUViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)statusChange:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
 
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

#pragma mark - TextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    CGRect frameCell = textField.superview.superview.superview.frame;
    if (frameCell.origin.y > 170 && self.view.frame.origin.y == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{CGRect frame = self.view.frame;
            frame.origin.y -= 180;
            self.view.frame = frame;}];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int i=[nextTFarray count];
    int x=tag+1;
    UITextField *nextTextField = (UITextField *)[nextTFarray objectAtIndex:x];
    if (x<3) {
        if (self.view.frame.origin.y == -180)
        {
            [UIView animateWithDuration:0.2 animations:^{CGRect tabFrame = self.view.frame;
                tabFrame.origin.y += 180;
                self.view.frame = tabFrame;}];
        }
        [nextTextField becomeFirstResponder];
       if (x == 2)
        {
            tag +=2;
        }
        tag ++;
    }

    else if ( x>3 && x<i-1)
    {
        [nextTextField becomeFirstResponder];
        tag ++;
    }
    else
    {
        if (self.view.frame.origin.y == -180)
        {
            [UIView animateWithDuration:0.2 animations:^{CGRect tabFrame = self.view.frame;
                tabFrame.origin.y += 180;
                self.view.frame = tabFrame;}];
        }
        tag = 0;
       
        [textField resignFirstResponder];
        return YES;
       
    }
    return YES;
}

#pragma mark - TableView datasource

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
    signUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signUpCell"];
    if (cell == nil)
    {
        cell = [[signUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"signUpCell"];
    }
    cell.theTextField.placeholder = [[labels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0)
    {
        cell.rightLabel.text = @"*";
        if (indexPath.row == 1 || indexPath.row == 2)
        {
            cell.theTextField.secureTextEntry = YES;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0 )
        {
            NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
            cell.theTextField.text = [pref objectForKey:@"email"];
            cell.theTextField.textColor = [UIColor grayColor];
            [cell.theTextField setUserInteractionEnabled:false];
            
            cell.rightLabel.text = @"*";
            
        }
        else if (indexPath.row == 1)
        {
             NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
            if([pref objectForKey:@"country"])
            {
                cell.theTextField.text = [pref objectForKey:@"country"];
            }
            cell.rightLabel.text = @"*";
        
            [cell.theTextField setUserInteractionEnabled:false];
        }
       
        else
        {
            cell.rightLabel.text = @"";
        }
    }
    else if (indexPath.section == 2)
    {
        
        cell.rightLabel.text = @"";
        [cell.theTextField setHidden:YES];
      //  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
        cell.textLabel.text = [[labels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        //label.font = [UIFont systemFontOfSize:15];
        //[cell addSubview:label];
        UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
        info.frame = CGRectMake(170, 9, 22, 22);
        [info addTarget:self action:@selector(displayCGU) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:info];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if (accepted)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [nextTFarray addObject:cell.theTextField    ];

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
    if (indexPath.section == 2)
    {
        if (self.view.frame.origin.y == -180)
        {
            [UIView animateWithDuration:0.2 animations:^{CGRect tabFrame = self.view.frame;
                tabFrame.origin.y += 180;
                self.view.frame = tabFrame;}];
        }
        if (accepted)
        {
            accepted = NO;
        }
        else
        {
            accepted = YES;
        }
        [self.tableView reloadData];
    }
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
        self.pictureView.image = [UIImage imageNamed:@"default_profile.jpg"];
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
                self.pictureView.image = image;
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                [pref setObject:UIImageJPEGRepresentation(image, 1.0) forKey:@"picture"];
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
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults ];
    [pref setObject:[countries objectAtIndex:row] forKey:@"country"];
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

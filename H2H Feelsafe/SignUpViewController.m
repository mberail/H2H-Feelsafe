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

@interface SignUpViewController ()
{
    NSArray *labels;
}
@end

@implementation SignUpViewController
@synthesize accepted;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Inscription";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSArray *labelsFirst = [[NSArray alloc] initWithObjects:@"Identifiant",@"Mot de passe",@"Confirmation mot de passe", nil];
    NSArray *labelsSecond = [[NSArray alloc] initWithObjects:@"E-mail",@"Mobile",@"Nom",@"Prénom", nil];
    NSArray *labelsThird = [[NSArray alloc] initWithObjects:@"J'accepte les CGU", nil];
    labels = [[NSArray alloc] initWithObjects:labelsFirst,labelsSecond,labelsThird, nil];
    
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Terminé" style:UIBarButtonItemStylePlain target:self action:@selector(signup)];
    self.navigationItem.rightBarButtonItem = item;
    accepted = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CGUaccepted) name:@"CGUaccepted" object:nil];
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
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Le username ne doit contenir au moins 4 lettres minuscules et/ou des chiffres :" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    reallyBreak = YES;
                    break;
                }
            }
            if ([cell.rightLabel.text isEqualToString:@"*"] && cell.theTextField.text.length == 0)
            {
                [[[UIAlertView alloc] initWithTitle:nil message:@"Veuillez compléter tous les champs obligatoires." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Veuillez compléter une adresse mail valide." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    reallyBreak = YES;
                    break;
                }
            }
            if (index.section == 2 && cell.accessoryType == UITableViewCellAccessoryNone)
            {
                [[[UIAlertView alloc] initWithTitle:nil message:@"Veuillez accepter les CGU" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                reallyBreak = YES;
                break;
            }
            if (index.section != 2)
            {
                [mutArray addObject:cell.theTextField.text];
            }
        }
    }
   
    if (mutArray.count == 7 && accepted)
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
         NSLog(@"mutArray : %@",mutArray);
        
        
        BOOL signUp = [WebServices signUp:mutArray];
        if (signUp)
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
            [[[UIAlertView alloc] initWithTitle:nil message:@"Tous les champs ne sont pas correctement remplis, veuillez réessayer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
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
        if (indexPath.row == 0)
        {
            NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
            cell.rightLabel.text = @"*";
            cell.theTextField.text = [pref objectForKey:@"email"];
            cell.theTextField.textColor = [UIColor grayColor];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
        label.text = [[labels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        label.font = [UIFont systemFontOfSize:15];
        [cell addSubview:label];
        UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
        info.frame = CGRectMake(160, 9, 22, 22);
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
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

@end

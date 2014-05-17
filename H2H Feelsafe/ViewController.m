//
//  ViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "ViewController.h"
#import "WebServices.h"
#import "SVProgressHUD.h"

@interface ViewController ()
{
    BOOL pageControlBeingUsed;
}
@end

@implementation ViewController
@synthesize slides, scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"H2H Feelsafe";
    self.texte.text = NSLocalizedString(@"Le meilleur moyen de protéger ceux que vous aimez", nil);
   // self.Visite.layer.borderColor =[UIColor purpleColor].CGColor;
    //self.Visite.layer.borderWidth = 2.0f;
    self.Texte1.text = NSLocalizedString(@"Entrez votre adresse e-mail", nil) ;
    self.Texte2.text = NSLocalizedString(@"afin de vous identifier ou de créer votre profil H2H FeelSafe.", nil);
    
    self.mailText.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Votre adresse mail", nil)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Valider", nil) style:UIBarButtonItemStylePlain target:self action:@selector(ProceedWithEmail)];
    self.navigationItem.rightBarButtonItem = item;
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Annuler",nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelEmail)];
    self.navigationItem.leftBarButtonItem = item2;
    
    if(  [ [ UIScreen mainScreen ] bounds ].size.height== 568)
    {
        CGRect frame2 = self.logo2.frame;
        frame2.origin.y = 200;
        self.logo2.frame = frame2;
        
        CGRect frame3 = self.logo.frame;
        frame3.origin.y = 50;
        self.logo.frame = frame3;
        
         self.Valider.frame = CGRectMake(self.Valider.frame.origin.x, self.Valider.frame.origin.y +35, self.Valider.frame.size.width, self.Valider.frame.size.height);
        
        self.Texte1.frame =CGRectMake(self.Texte1.frame.origin.x, self.Texte1.frame.origin.y +10, self.Texte1.frame.size.width, self.Texte1.frame.size.height);
        
        self.Texte2.frame = CGRectMake(self.Texte2.frame.origin.x, self.Texte2.frame.origin.y +15, self.Texte2.frame.size.width, self.Texte2.frame.size.height);
    }
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"picture"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"picture"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)ProceedWithEmail
{
    
    NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self.emailTextField.text options:0 range:NSMakeRange(0, self.emailTextField.text.length)];
    NSString *text = self.emailTextField.text;
    if (match)
    {
        [self StartCheckEmailProcess:text];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Veuillez compléter une adresse mail valide." , nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

-(void)StartCheckEmailProcess: (NSString *)mail
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Vérification de l'adresse mail", nil)  maskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(checkEmail:) withObject:mail afterDelay:0.2];
}

- (void)checkEmail: (NSString *)mail
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        BOOL emailExists = [WebServices checkEmail:mail];
    [SVProgressHUD dismiss];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [[UIViewController alloc] init];
        if (emailExists)
        {
             [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Adresse Mail idenftifié", nil) ];
            vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        }
        else if ([[pref objectForKey:@"CheckMail"]  isEqual: @"false"])
        {
            return;
        }
        else
        {
             [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Mail inconue veuillez créer un compte", nil) ];
            vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        }
        [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelEmail
{
    [self.emailTextField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:
     ^{//[self.flowView setHidden:NO];
         [self.navigationController setNavigationBarHidden:YES];
         [self.scrollView setHidden:NO];
         [self.logo setHidden:NO];
         [self.logo2 setHidden:NO];
         [self.Texte1 setHidden:YES];
         [self.Texte2 setHidden:YES];
         [self.Valider setHidden:YES];
         [self.Valider setEnabled:NO];
         CGRect frame = self.emailTextField.frame;
         frame.origin.y = self.view.frame.size.height - 64;
         self.emailTextField.frame = frame;}];
   
}




- (IBAction)changeSlide:(id)sender
{
    CGRect frame;
   // frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}

- (IBAction)valid:(id)sender {
    [self ProceedWithEmail];
}

- (IBAction)Visite:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [[UIViewController alloc] init];
    vc = [storyboard instantiateViewControllerWithIdentifier:@"UIGuideViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Scroll view delegate

/*- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
        int page = (scrollView.contentOffset.x / scrollView.frame.size.width);
        self.pageControl.currentPage = page;
    }
}*/

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    [UIView animateWithDuration:0.2 animations:
     ^{//[self.flowView setHidden:YES];
         [self.navigationController setNavigationBarHidden:NO];
         [self.scrollView setHidden:YES];
         [self.logo setHidden:YES];
         [self.logo2 setHidden:YES];
         [self.Texte1 setHidden:NO];
         [self.Texte2 setHidden:NO];
         [self.Valider setHidden:NO];
         [self.Valider setEnabled:YES];
        // [self.pageControl setHidden:YES];
         CGRect frame = self.emailTextField.frame;
         frame.origin.y = 83;
         self.emailTextField.frame = frame;}];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Vérification du mail", nil) maskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(checkEmail:) withObject:textField.text afterDelay:0.2];
    
    return YES;
}

/*#pragma mark - OpenFlow datasource
 
 - (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index
 {
 [openFlowView setImage:[UIImage imageNamed:[slides objectAtIndex:index]] forIndex:index];
 }
 
 - (UIImage *)defaultImage
 {
 return [UIImage imageNamed:@"Slide-Default.png"];
 }*/

@end

//
//  ViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "ViewController.h"
#import "WebServices.h"

@interface ViewController ()
{
    BOOL pageControlBeingUsed;
}
@end

@implementation ViewController
@synthesize slides, scrollView, pageControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"H2H Feelsafe";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Suivant" style:UIBarButtonItemStylePlain target:self action:@selector(checkEmail)];
    self.navigationItem.rightBarButtonItem = item;
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEmail)];
    self.navigationItem.leftBarButtonItem = item2;
    
    slides = [[NSArray alloc] initWithObjects:@"01_Accueil_IOS7_v2.jpg",@"02_Plan_Suivis_IOS7_v3.jpg",@"03_Liste_Suivis_IOS7_v3.jpg",@"04_Alertes_IOS7_v3.jpg",@"05_Diaporama_IOS7_v3.jpg",nil];
    
    for (int i = 0; i < slides.count; i++)
    {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:[slides objectAtIndex:i]];
        [scrollView addSubview:imageView];
    }
    
    //self.flowView.dataSource = self;
    //self.flowView.numberOfImages = slides.count;
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * slides.count, scrollView.frame.size.height)];
    pageControl.numberOfPages = slides.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)checkEmail
{
    
    NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self.emailTextField.text options:0 range:NSMakeRange(0, self.emailTextField.text.length)];
    if (match)
    {
        BOOL emailExists = [WebServices checkEmail:self.emailTextField.text];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [[UIViewController alloc] init];
        if (emailExists)
        {
            vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        }
        else
        {
            vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Veuillez compléter une adresse mail valide." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)cancelEmail
{
    [self.emailTextField resignFirstResponder];
    [UIView animateWithDuration:0 animations:
     ^{//[self.flowView setHidden:NO];
         [self.scrollView setHidden:NO];
         [self.pageControl setHidden:NO];
         CGRect frame = self.emailTextField.frame;
         frame.origin.y = self.view.frame.size.height - 64;
         self.emailTextField.frame = frame;}];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)changeSlide:(id)sender
{
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
        int page = (scrollView.contentOffset.x / scrollView.frame.size.width);
        self.pageControl.currentPage = page;
    }
}

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
    self.navigationController.navigationBarHidden = NO;
    [UIView animateWithDuration:0 animations:
     ^{//[self.flowView setHidden:YES];
         [self.scrollView setHidden:YES];
         [self.pageControl setHidden:YES];
         CGRect frame = self.emailTextField.frame;
         frame.origin.y = 83;
         self.emailTextField.frame = frame;}];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self checkEmail];
    
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

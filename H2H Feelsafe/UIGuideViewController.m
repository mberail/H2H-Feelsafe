//
//  UIGuideViewController.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 18/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "UIGuideViewController.h"

@interface UIGuideViewController ()
{
      BOOL pageControlBeingUsed;
}
@end

@implementation UIGuideViewController
@synthesize slides, scrollView, pageControl;

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
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.title = @"H2H Feelsafe";
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< retour" style:UIBarButtonSystemItemCancel target:self action:@selector(Return)];
    
    
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

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)Return
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [[UIViewController alloc] init];
    vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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

@end

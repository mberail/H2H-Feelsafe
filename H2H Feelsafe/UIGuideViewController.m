//
//  UIGuideViewController.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 18/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "UIGuideViewController.h"
#import "IIViewDeckController.h"

@interface UIGuideViewController ()
{
      BOOL pageControlBeingUsed;
    NSUserDefaults * pref;
}
@end

@implementation UIGuideViewController
@synthesize slides, scrollView, pageControl , slidesText;

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
    scrollView.contentMode = UIViewContentModeScaleAspectFit;
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width,scrollView.frame.size.height);

    [self.navigationController setNavigationBarHidden:NO];

    pref = [NSUserDefaults standardUserDefaults ];
    NSAttributedString *inscription = [self htmlToText: @"<h2>Créez vous, au choix, un compte :</h2><p><b>Référent</b>, pour localiser et recevoir des notifications des personnes que vous souhaitez protéger.</p><p><b>Protégé</b>, pour envoyer des messages à vos référent(s), alerter si besoin, et transmettre votre position.</p>"];
    NSAttributedString *plan = [self htmlToText:@"  <h2>Position des protégés</h2><p>Le référent peut localiser et actualiser la position de ses protégés sur la carte.</p>"];
    NSAttributedString *contact = [self htmlToText:@"<h2>Ajoutez vos protégés</h2><p>Le référent peut ajouter des protégés à partir de son répertoire ou du pseudo d’un protégé</p>"];
    NSAttributedString *liste =  [self htmlToText:@"<h2>Liste des protégés</h2><p>Le référent peut accéder à la liste de ses protégés, indiquant la dernière adresse où ils se trouvent.</p>"];
    NSAttributedString *alert = [self htmlToText:@"<h2>Alertez vos Référents</h2><p>Le protégé peut avertir son ou ses référent(s) d’un éventuel imprévu et lancer une alerte en cas d’urgence.</p>"];
    
    
    slidesText = [[NSArray alloc]initWithObjects:inscription,plan,contact,liste,alert, nil];
    NSLog(@"slidesText %@",slidesText);
    slides = [[NSArray alloc] initWithObjects:@"Inscription.png",@"Plan.png",@"Contact.png",@"Liste.png",@"AlertScreen.png",nil];
    
    
    for (int i = 0; i < slides.count; i++)
    {
        
        CGRect frame;
        frame.origin.x =(scrollView.frame.size.width)* i;
        frame.origin.y = 150;
        frame.size.height = 240;
        frame.size.width = scrollView.frame.size.width;
        if(  [ [ UIScreen mainScreen ] bounds ].size.height== 568)
        {
            frame.origin.x =(scrollView.frame.size.width)* i;
            frame.origin.y = 150;
            frame.size.height = 290;
            frame.size.width = scrollView.frame.size.width;
        }
        UIImageView *Photo = [[UIImageView  alloc]initWithFrame:frame];
        Photo.contentMode = UIViewContentModeScaleAspectFit;
        Photo.image = [UIImage imageNamed:[slides objectAtIndex:i]];
        
        CGRect frame2;
        frame2.origin.x = scrollView.frame.size.width* i + 20 ;
        frame2.origin.y = 10;
        frame2.size.height = 151;
        frame2.size.width = 300;
        
       
        
        UITextView *texte = [[UITextView  alloc]initWithFrame:frame2];
        texte.backgroundColor = nil;
        
        [texte setUserInteractionEnabled:NO];
        texte.attributedText = [slidesText objectAtIndex:i];
        
       /* CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:[slides objectAtIndex:i]];*/
       [scrollView addSubview:Photo];
        [scrollView addSubview:texte];
    }
    
    //self.flowView.dataSource = self;
    //self.flowView.numberOfImages = slides.count;
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * slides.count, scrollView.frame.size.height)];
    pageControl.numberOfPages = slides.count;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(NSAttributedString *)htmlToText: (NSString *)text
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    NSFontAttributeName *truc = [UIFont fontWithName:@"arial" size:15];
    
   // NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text
                                                   //    attributes:@{NSFontAttributeName}];
    return attributedString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)skip:(id)sender {
    if ([[pref objectForKey:@"isConnected"] boolValue] == NO)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [[UIViewController alloc] init];
        vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if([[pref objectForKey:@"status"]isEqualToString:@"referent"])
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
            UIViewController *leftvc = [storyboard instantiateViewControllerWithIdentifier:@"LeftViewProtege"];
            IIViewDeckController *viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:nvc leftViewController:leftvc];
            viewDeck.leftSize = 65;
            viewDeck.panningMode = IIViewDeckNavigationBarPanning;
            [self.navigationController presentViewController:viewDeck animated:YES completion:nil];
        }
    }
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

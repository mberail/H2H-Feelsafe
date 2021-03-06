//
//  UIGuideViewController.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 18/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "ViewController.h"

@interface UIGuideViewController : ViewController

@property (nonatomic, strong) NSArray *slides;
@property (nonatomic, strong) NSArray *slidesText;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *Texte;
@property (strong, nonatomic) IBOutlet UIImageView *Photo;
- (IBAction)skip:(id)sender;


- (IBAction)changeSlide:(id)sender;

@end

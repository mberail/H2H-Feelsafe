//
//  ViewController.h
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"

@interface ViewController : UIViewController </*AFOpenFlowViewDataSource,*/UITextFieldDelegate, UIScrollViewDelegate>

//@property (weak, nonatomic) IBOutlet AFOpenFlowView *flowView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) NSArray *slides;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)changeSlide:(id)sender;

@end

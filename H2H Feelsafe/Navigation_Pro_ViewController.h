//
//  Navigation_Pro_ViewController.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 29/03/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Navigation_Pro_ViewController : UIViewController 
@property (strong, nonatomic) IBOutlet UIView *StatutView;
@property (strong, nonatomic) IBOutlet UIView *SecondStatutView;
- (IBAction)OK:(id)sender;
- (IBAction)Imprevu:(id)sender;
- (IBAction)Danger:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *message;
- (IBAction)send:(id)sender;

@end

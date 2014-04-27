//
//  Navigation_Pro_ViewController.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 29/03/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Navigation_Pro_ViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *StatutView;
@property (strong, nonatomic) IBOutlet UIView *SecondStatutView;
- (IBAction)OK:(id)sender;
- (IBAction)Imprevu:(id)sender;
- (IBAction)Danger:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *message;
@property (strong, nonatomic) IBOutlet UILabel *Phone;
- (IBAction)send:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Name;
@property (strong, nonatomic) IBOutlet UILabel *Prenom;
@property (strong, nonatomic) IBOutlet UILabel *adresse;
@property (strong, nonatomic) IBOutlet UITextView *message2;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;
@property (strong, nonatomic) IBOutlet UIButton *AlertButton;
@property (strong, nonatomic) IBOutlet UIButton *warningView;
@property (strong, nonatomic) IBOutlet UIImageView *alert;

@property (strong, nonatomic) IBOutlet UIView *dangerView;
@property (strong, nonatomic) IBOutlet UIButton *goodView;

- (IBAction)send:(id)sender;

@end

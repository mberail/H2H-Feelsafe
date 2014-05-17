//
//  NotificationViewController.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 16/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "NotificationViewController.h"
#import "WebServices.h"
#import "IIViewDeckController.h"
#import "SVProgressHUD.h"

@interface NotificationViewController ()
{
    BOOL topActive;
    BOOL centerActive;
    BOOL bottomActive;
    NSArray * time;
    int timeSelected;
    
}
@end

@implementation NotificationViewController

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
    
    NSUserDefaults *pref = [NSUserDefaults  standardUserDefaults];
    
    
  
   self.Valid.layer.borderColor = ([[UIColor alloc]initWithRed:(142.0/255.0) green:(20./255.0) blue:(129./255.0) alpha:1.0]).CGColor;
   self.Valid.layer.borderWidth = 1.f;
      self.Valid.layer.cornerRadius = 4.0f;
    self.Valid.titleLabel.text = NSLocalizedString(@"Valider", nil);
    
    topActive = [[pref objectForKey:@"alert_mail"]boolValue];
    centerActive = [[pref objectForKey:@"alert_message"]boolValue];
    bottomActive = [[pref objectForKey:@"alert_notification"]boolValue];
    timeSelected = [[pref objectForKey:@"alert_frequency"] intValue];
    
    if (timeSelected > 0)
    {
        self.SegmentControl.selectedSegmentIndex = 1;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(beforeChangement)];
    self.navigationItem.title = NSLocalizedString(@"Notifications", nil);
    
    UIImage *profile = [UIImage imageNamed:@"LeftBut.png"];
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, profile.size.width/1.5, profile.size.height/1.5)];
    [profileButton setBackgroundImage:profile forState:UIControlStateNormal];
    [profileButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profilItem =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItem = profilItem;
    
    
    
    
    time = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    
    
    
    self.topLabel.text = NSLocalizedString(@"Acitiver l'envoi du mail lors d'une alerte", nil);
    self.centerLabel.text = NSLocalizedString(@"Activer l'envoie d'un sms lors d'une alerte", nil);
    self.bottomLabel.text = NSLocalizedString(@"Activer les notifications lors d'une alerte", nil);
    self.descriptionLabel.text = NSLocalizedString(@"Fréquences entre deux alertes (min)", nil);
    
    
    [self.topSwitch setOn:topActive];
    [self.centerSwitch setOn:centerActive];
    [self.bottomSwitch setOn:bottomActive];
  
    
    [self.SegmentControl setTitle:NSLocalizedString(@"Ponctuelle", nil) forSegmentAtIndex:0];
    [self.SegmentControl setTitle:NSLocalizedString(@"Régulière", nil) forSegmentAtIndex:1];
    
    if (bottomActive)
    {
        self.SegmentControl.hidden  = NO;
        self.timeSelection.hidden =NO;
        self.descriptionLabel.hidden = NO;
        
    }
    else if (bottomActive == false)
    {
        self.SegmentControl.hidden  = YES;
        self.timeSelection.hidden =YES;
        self.descriptionLabel.hidden = YES;
    }
    
    if (self.SegmentControl.selectedSegmentIndex == 0)
    {
        self.timeSelection.hidden =YES;
        self.descriptionLabel.hidden = YES;
    }
    else if (self.SegmentControl.selectedSegmentIndex == 1)
    {
        self.timeSelection.hidden =NO;
        self.descriptionLabel.hidden = NO;
    }
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (timeSelected > 0)
    {
        NSUserDefaults *pref =[NSUserDefaults standardUserDefaults];
        NSLog(@"time %i",timeSelected);
        [self.timeSelection reloadAllComponents];
        [self.timeSelection selectRow:[[pref objectForKey:@"alert_frequency"]integerValue]-1  inComponent:0 animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)topSwitch:(id)sender {
    if(topActive)
    {
         topActive = false ;
    }
    else
    {
        topActive = true ;
    }
    NSLog(@"%i",topActive);
    
}

- (IBAction)centerSwitch:(id)sender {
    if(centerActive)
    {
        centerActive = false ;
    }
    else
    {
        centerActive = true ;
    }
     NSLog(@"%i",centerActive);
    
}

- (IBAction)bottomSwitch:(id)sender {
    if(bottomActive)
    {
        bottomActive = false ;
        self.SegmentControl.hidden  = YES;
        self.timeSelection.hidden =YES;
        self.descriptionLabel.hidden = YES;
        
    }
    else
    {
       
        bottomActive = true ;
        self.SegmentControl.hidden  = NO;
       if(self.SegmentControl.selectedSegmentIndex == 1)
       {
           
           self.timeSelection.hidden =NO;
           self.descriptionLabel.hidden = NO;
       }
        
    }
     NSLog(@"%i",timeSelected);
    
}

- (IBAction)segmentedControl:(id)sender
{
    
    if (self.SegmentControl.selectedSegmentIndex == 0)
    {
        self.timeSelection.hidden =YES;
        self.descriptionLabel.hidden = YES;
         timeSelected = 0;
    }
    else if (self.SegmentControl.selectedSegmentIndex == 1)
    {
        self.timeSelection.hidden =NO;
        self.descriptionLabel.hidden = NO;
        timeSelected = [self.timeSelection selectedRowInComponent:0]+1;
    }

}

-(void)beforeChangement
{
    [SVProgressHUD showWithStatus:@"Changement des paramètres"];
    [self performSelector:@selector(sendChangement) withObject:nil afterDelay:.2];
}



-(void)sendChangement
{
    NSString *mail = [NSString stringWithFormat:@"%hhd",topActive];
     NSString *message = [NSString stringWithFormat:@"%hhd",centerActive];
     NSString *notif = [NSString stringWithFormat:@"%hhd",bottomActive];
    NSString *timestr = [NSString stringWithFormat:@"%i",timeSelected];
    
    NSArray *keys = [[NSArray alloc]initWithObjects:@"alert_mail",@"alert_message",@"alert_notification",@"alert_frequency",nil];
   NSArray *value = [[NSArray alloc]initWithObjects:mail,message,notif,(int)timestr,nil];
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] initWithObjects:value forKeys:keys];
    NSLog(@"infos : %@",dictData);
    [WebServices updatealerting:dictData];
}



#pragma mark - PickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger *)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [time count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [time objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    timeSelected = row+1;
    NSLog(@"%i",timeSelected);
}
- (IBAction)Valid:(id)sender {
    
    [self beforeChangement];
}
@end

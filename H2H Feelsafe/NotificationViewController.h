//
//  NotificationViewController.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 16/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController <UIImagePickerControllerDelegate,UIPickerViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *centerLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
- (IBAction)topSwitch:(id)sender;
- (IBAction)centerSwitch:(id)sender;
- (IBAction)bottomSwitch:(id)sender;
- (IBAction)segmentedControl:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *topSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *centerSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *bottomSwitch;


@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentControl;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) IBOutlet UIPickerView *timeSelection;
- (IBAction)Valid:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *Valid;


@end

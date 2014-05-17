//
//  SignUpViewController.h
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *PicView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property BOOL accepted;
- (IBAction)statusChange:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *TextField;
@property (strong, nonatomic) IBOutlet UIPickerView *CountrySelector;

- (IBAction)picture:(id)sender;

@end

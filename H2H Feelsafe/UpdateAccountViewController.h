//
//  UpdateAccountViewController.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 02/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UpdateAccountViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIImagePickerController *picker;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *PictureView;
- (IBAction)picture:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *picView;
@property (strong, nonatomic) IBOutlet UIPickerView *CountrySelector;

@property (strong, nonatomic) IBOutlet UIImageView *testImage;
 
@property (strong, nonatomic) IBOutlet UIButton *Picture;


@end

//
//  ProAddViewController.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 12/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface ProAddViewController : UIViewController <UITableViewDataSource, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

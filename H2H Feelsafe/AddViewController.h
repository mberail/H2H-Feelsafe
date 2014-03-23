//
//  AddViewController.h
//  H2H Feelsafe
//
//  Created by Maxime Berail on 02/01/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface AddViewController : UIViewController <UITableViewDataSource, MFMessageComposeViewControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)changeSearch:(id)sender;

@end

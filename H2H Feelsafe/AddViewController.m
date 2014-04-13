//
//  AddViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 02/01/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "AddViewController.h"
#import "WebServices.h"
#import <AddressBookUI/AddressBookUI.h>
#import "SVProgressHUD.h"


@interface AddViewController ()
{
    NSArray *arrays;
    NSArray *searchs;
    NSArray*contactsFromAddressBook;
    NSArray *ContactsChecked;

}
@end

@implementation AddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"recherche de protégés"];
    self.navigationItem.title = @"Ajouter un protégé";
    arrays = [[NSArray alloc] init];
    searchs = [[NSArray alloc] init];
  
    contactsFromAddressBook = [self getAllContactsFromAddressBook];
   
    //ContactsChecked = [self proceedWithSearch: contactsFromAddressBook];
    //NSLog(@"Contacts list : %@",ContactsChecked);

   
    

}
-(void)viewDidAppear:(BOOL)animated
{
    
     [self updateContactsFromAddressBook];
}


- (void)updateContactsFromAddressBook
{
    
    NSArray *contacts = [self startsearchInPhoneBookProcess:contactsFromAddressBook];
    //NSLog(@"tructruc : %@",contacts);
    NSMutableArray *alreadyRegistered = [[NSMutableArray alloc] init];
    NSMutableArray *notRegistered = [[NSMutableArray alloc] init];
    [SVProgressHUD dismiss];
    for (NSDictionary *dict in contacts)
    {
        if ([[dict objectForKey:@"registered"] intValue] != 0)
        {
            [alreadyRegistered addObject:dict];
        }
        else
        {
            [notRegistered addObject:dict];
        }
    }
    
    arrays = [NSArray arrayWithObjects:alreadyRegistered, notRegistered, nil];
    
    [self.tableView reloadData];
}

- (NSArray *)startsearchInPhoneBookProcess:(NSArray *)tab
{
    
    NSArray *ContactsCheck = [WebServices searchInPhoneBook:tab];
    [SVProgressHUD dismiss];
    return ContactsCheck;
   // NSLog(@"contact %@" , ContactsChecked);
}

- (NSArray *)getAllContactsFromAddressBook
{
    
    NSMutableArray *theContacts = [[NSMutableArray alloc] init];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    NSLog(@"%@",addressBook);
    if (addressBook != nil)
    {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
                ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
                NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, ABPersonGetSortOrdering());
                for (int i = 0; i < allContacts.count; i++)
                {
                    //Contact *theContacts = [[Contact alloc] init];
                    ABRecordRef contact = (__bridge ABRecordRef)allContacts[i];
                    NSMutableDictionary *theContact = [[NSMutableDictionary alloc] init];
                    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
                    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty);
                    if (firstName == NULL)
                    {
                              [theContact setValue:lastName forKey:@"name"];
                    }
                    if (lastName == NULL)
                    {
                            [theContact setValue:firstName forKey:@"name"];
                    }
                    else
                        [theContact setValue:[ NSString stringWithFormat:@"%@ %@",firstName,lastName] forKey:@"name"];
                    
                    ABMultiValueRef phones = ABRecordCopyValue(contact, kABPersonPhoneProperty);
                    for (int j = 0; j < ABMultiValueGetCount(phones); j++)
                    {
                        NSString *phoneTemp = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
                        if ([[phoneTemp substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"06"] || [[phoneTemp substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"07"] || [[phoneTemp substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"+33"])
                        {
                            [theContact setValue:phoneTemp forKey:@"phone"];
                            //NSLog(@"%@",phoneTemp);
                        }
                    }
                    ABMultiValueRef emails = ABRecordCopyValue(contact, kABPersonEmailProperty);
                    for (int k = 0; k < ABMultiValueGetCount(emails); k++)
                    {
                        NSString *emailTemp = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, k);
                        NSString *vide = @"";
                        if (emailTemp.length != 0)
                        {
                            [theContact setValue:emailTemp forKey:@"mail"];
                        }
                        else
                        {
                            [theContact setValue:vide forKey:@"mail"];
                        }
                    }
                    
                    [theContacts addObject:theContact];
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            // The user has previously given access, add the contact
            ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
            NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, ABPersonGetSortOrdering());
            for (int i = 0; i < allContacts.count; i++)
            {

                //Contact *theContacts = [[Contact alloc] init];
                ABRecordRef contact = (__bridge ABRecordRef)allContacts[i];
                NSMutableDictionary *theContact = [[NSMutableDictionary alloc] init];
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
                NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty);
                if (firstName == NULL)
                {
                    [theContact setValue:lastName forKey:@"name"];
                }
                if (lastName == NULL)
                {
                    [theContact setValue:firstName forKey:@"name"];
                }
                else
                    [theContact setValue:[ NSString stringWithFormat:@"%@ %@",firstName,lastName] forKey:@"name"];
                ABMultiValueRef phones = ABRecordCopyValue(contact, kABPersonPhoneProperty);
                for (int j = 0; j < ABMultiValueGetCount(phones); j++)
                {
                    NSString *phoneTemp = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
                    if ([[phoneTemp substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"06"] || [[phoneTemp substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"07"] || [[phoneTemp substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"+33"])
                    {
                        [theContact setValue:phoneTemp forKey:@"phone"];
                        //NSLog(@"%@",phoneTemp);
                    }
                }
                ABMultiValueRef emails = ABRecordCopyValue(contact, kABPersonEmailProperty);
                for (int k = 0; k < ABMultiValueGetCount(emails); k++)
                {
                    NSString *emailTemp = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, k);
                    NSString  *vide = @"";
                    if (emailTemp.length != 0)
                    {
                        [theContact setValue:emailTemp forKey:@"mail"];
                    }
                    else
                    {
                        [theContact setValue:vide forKey:@"mail"];
                    }
                }
                
                [theContacts addObject:theContact];
                
                
            }
        }
        else if( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied)
        {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Veuillez autoriser l'application à accéder à vos contact dans les réglages du téléphone !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            NSMutableDictionary *theContact = [[NSMutableDictionary alloc] init];
            [theContact setValue:@"L'application ne peut pas acceder aux contacts" forKey:@"firstname"];
            [theContacts addObject:theContact];
            
        }
        
    }
   // NSLog(@"Contacts : %@",theContacts);
    return theContacts;
}

- (IBAction)changeSearch:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        CGRect frame = self.tableView.frame;
        frame.origin.y -= 40;
        self.tableView.frame = frame;
    }
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        CGRect frame = self.tableView.frame;
        frame.origin.y += 40;
        self.tableView.frame = frame;
    }
    [self.tableView reloadData];
}

#pragma mark - Search display delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *search = searchBar.text;
   [self.searchDisplayController setActive:NO animated:YES];
    [self.searchBar setHidden:YES];
    [SVProgressHUD showWithStatus:@"Recherche du Username"];
    
   [self performSelector:@selector(Searchprocess:) withObject:search afterDelay:0.2];
}
-(NSArray *)startSearchProcess:(NSString *)recherche
{
     NSArray *responses = [WebServices searchResults:recherche];
    
    return responses;
}
- (void)Searchprocess: (NSString *)recherche
{
    NSArray *responses = [self startSearchProcess:recherche];
    searchs = responses;
    [self.tableView reloadData];
    [self.searchBar setHidden:NO];
    [SVProgressHUD dismiss];
  //  [self.tableView setHidden:NO];
}


#pragma mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        return arrays.count;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        return [[arrays objectAtIndex:section] count];
    }
    else
    {
        return searchs.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        if (section == 0)
        {
            title = @"Amis protégés";
        }
        else if (section == 1)
        {
            title = @"Inviter des amis";
        }
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactCell"];
    }
    NSDictionary *contact = [[NSDictionary alloc] init];
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        contact = [[arrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString *name = [contact objectForKey:@"name"];
        
        cell.textLabel.text = name;
    }
    else
    {
        contact = [searchs objectAtIndex:indexPath.row];
        cell.textLabel.text = [contact objectForKey:@"username"];
    }
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(280, 8, 28, 28);
    button.tag = indexPath.row;
    if (indexPath.section == 0)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"user_add.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addContactFromAddressBook:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.section == 1)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"19-gear.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sendInvitation:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell addSubview:button];
    return cell;
}

- (void)addContactFromAddressBook:(UIButton *)sender
{
    if( self.segmentedControl.selectedSegmentIndex == 0)
    {
        NSLog(@"truc %@",[[arrays objectAtIndex:0] objectAtIndex:sender.tag]);
        NSString *protegeId = [[NSString alloc]initWithFormat:@"%@",[[[arrays objectAtIndex:0] objectAtIndex:sender.tag] objectForKey:@"registered"]];
        [self startInviteProcess:protegeId];
    }
    else
    {
        NSLog(@"truc %@",[searchs objectAtIndex:sender.tag]);
        NSString *protegeId = [[NSString alloc]initWithFormat:@"%@",[[searchs objectAtIndex:sender.tag] objectForKey:@"id"]];
        [self startInviteProcess:protegeId];
    }
}

- (void)startInviteProcess:(NSString *)tab
{
    [SVProgressHUD showWithStatus:@"Envoie de l'invitation" maskType:SVProgressHUDMaskTypeBlack];
    
    [self performSelector:@selector(invite:) withObject:tab afterDelay:0.2];
    
}

- (void)invite: (NSString *)tab
{
   [WebServices sendInvit:tab];
    
    //[self updateContactsFromAddressBook];
}

- (void)sendInvitation:(UIButton *)sender
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText])
    {
        NSString *phone = [[[arrays objectAtIndex:1] objectAtIndex:sender.tag] objectForKey:@"phone"];
        if (phone != NULL)
        {
        NSLog(@"tag : %li phone : %@",(long)sender.tag, phone);
        controller.recipients = [NSArray arrayWithObjects:phone, nil];
        controller.body = @"Bonjour, je vous invite à découvrir Feelsafe.";
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    
        }
        else
            [[[UIAlertView alloc] initWithTitle:nil message:@"Ce contact n'a pas de numéro enregistré !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
    }
    //[self updateContactsFromAddressBook];
}


#pragma mark - MessageComposer delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
}

@end

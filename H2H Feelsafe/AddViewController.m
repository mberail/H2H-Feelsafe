//
//  AddViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 02/01/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "AddViewController.h"
#import "WebServices.h"

@interface AddViewController ()
{
    NSArray *arrays;
    NSArray *searchs;
    NSArray *contactsFromAddressBook;
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
    self.navigationItem.title = @"Ajouter un protégé";
    arrays = [[NSArray alloc] init];
    searchs = [[NSArray alloc] init];
    contactsFromAddressBook = [self getAllContactsFromAddressBook];
    [self updateContactsFromAddressBook];
}

- (void)updateContactsFromAddressBook
{
    //NSArray *contacts = [WebServices searchInPhoneBook:contactsFromAddressBook];
    NSArray *contacts = contactsFromAddressBook;
    NSMutableArray *alreadyRegistered = [[NSMutableArray alloc] init];
    NSMutableArray *notRegistered = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in contacts)
    {
        if ([[dict objectForKey:@"registered"] intValue] == 1)
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

- (NSArray *)getAllContactsFromAddressBook
{
    NSMutableArray *theContacts = [[NSMutableArray alloc] init];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook != nil)
    {
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, ABPersonGetSortOrdering());
        for (int i = 0; i < allContacts.count; i++)
        {
            //Contact *theContact = [[Contact alloc] init];
            ABRecordRef contact = (__bridge ABRecordRef)allContacts[i];
            NSMutableDictionary *theContact = [[NSMutableDictionary alloc] init];
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
            if (firstName)
            {
                [theContact setValue:firstName forKey:@"firstname"];
            }
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty);
            if (lastName)
            {
                [theContact setValue:lastName forKey:@"lastname"];
            }
            ABMultiValueRef phones = ABRecordCopyValue(contact, kABPersonPhoneProperty);
            for (int j = 0; j < ABMultiValueGetCount(phones); j++)
            {
                NSString *phoneTemp = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
                if ([[phoneTemp substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"06"] || [[phoneTemp substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"07"] || [[phoneTemp substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"+33"])
                {
                    [theContact setValue:phoneTemp forKey:@"phone"];
                }
            }
            ABMultiValueRef emails = ABRecordCopyValue(contact, kABPersonEmailProperty);
            for (int k = 0; k < ABMultiValueGetCount(emails); k++)
            {
                NSString *emailTemp = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, k);
                if (emailTemp.length != 0)
                {
                    [theContact setValue:emailTemp forKey:@"mail"];
                }
            }
            /*theContact.firstName = firstName;
            theContact.lastName = lastName;
            theContact.phone = phone;
            theContact.email = email;*/
            [theContacts addObject:theContact];
        }
    }
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
    NSArray *responses = [WebServices searchResults:searchBar.text];
    searchs = responses;
    [self.tableView reloadData];
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
    }
    else
    {
        contact = [searchs objectAtIndex:indexPath.row];
    }
    NSString *firstname = [contact objectForKey:@"firstname"];
    NSString *lastname = [contact objectForKey:@"lastname"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",firstname, lastname];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
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
    [self updateContactsFromAddressBook];
}

- (void)sendInvitation:(UIButton *)sender
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText])
    {
        NSString *phone = [[[arrays objectAtIndex:1] objectAtIndex:sender.tag] objectForKey:@"phone"];
        NSLog(@"tag : %li phone : %@",(long)sender.tag, phone);
        controller.recipients = [NSArray arrayWithObjects:phone, nil];
        controller.body = @"Bonjour, je vous invite à découvrir Feelsafe.";
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
    [self updateContactsFromAddressBook];
}

#pragma mark - MessageComposer delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
}

@end

//
//  NavigationViewController.h
//  H2H Feelsafe
//
//  Created by Maxime Berail on 02/01/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

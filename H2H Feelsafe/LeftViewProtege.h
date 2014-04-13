//
//  LeftViewProtege.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 01/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewProtege : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

//
//  ListCell.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 01/05/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *Alert;
@property (strong, nonatomic) IBOutlet UIImageView *Picture;
@property (strong, nonatomic) IBOutlet UILabel *Name;
@property (strong, nonatomic) IBOutlet UIImageView *message;
@property (strong, nonatomic) IBOutlet UILabel *address;

@end

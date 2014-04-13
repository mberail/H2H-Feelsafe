//
//  WebServices.h
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServices : NSObject

+ (BOOL)checkEmail:(NSString *)emailAddress;
+ (BOOL)login:(NSArray *)parameters;
+ (BOOL)signUp:(NSArray *)parameters;
+ (NSArray *)searchInPhoneBook:(NSArray *)contacts;
+ (NSArray *)searchResults:(NSString *)searchText;
+ (BOOL)updatePosition:(NSArray *)parameters;
+ (BOOL)updateAccount:(NSArray *)parameters;
+ (void)sendInvit:(NSString *)registered;
+ (NSArray *)checkInvitation;
+ (void)answerInvitation:(NSArray *)response;

@end

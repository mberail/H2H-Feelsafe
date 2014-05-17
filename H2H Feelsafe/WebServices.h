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
+ (BOOL)updateInformations:(NSArray *)parameters;
+ (BOOL)updateAccount:(NSMutableDictionary *)parameters;
+ (void)sendInvit:(NSString *)registered;
+ (NSArray *)checkInvitation;
+ (void)answerInvitation:(NSArray *)response;
+ (NSArray *)protegesInfos;
+(void)stopAlert: (NSString *)idProtege;
+(void)resetPassword;
+(UIImage *)getPicture: (NSString *)userId;
+ (NSString *)base64forData:(NSData *)theData;
+(void)Share: (NSMutableDictionary *)params;
+(NSArray *) referentsInfos;
+(void)updatealerting: (NSMutableDictionary *)params;
@end

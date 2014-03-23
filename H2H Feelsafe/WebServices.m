//
//  WebServices.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "WebServices.h"

@implementation WebServices

+ (NSString *)base64forData:(NSData *)theData
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSData *)sendData:(id)parameters atUrl:(NSString *)url withAuthorization:(BOOL)authorization inJSON:(BOOL)json
{
    NSLog(@"url : %@",url);
    NSLog(@"para : %@",parameters);
    
    NSData *requestData = [[NSData alloc] init];
    if (json)
    {
        requestData = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    }
    else
    {
        NSString *stringTemp = @"";
        for (int i = 0; i < [parameters count]; i++)
        {
            stringTemp = [NSString stringWithFormat:@"%@%@=%@&",stringTemp,[parameters allKeys][i],[parameters allValues][i]];
        }
        requestData = [stringTemp dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"data : %@",[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (authorization)
    {
        NSDictionary *dictTemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"infos"];
        NSString *authStr = [NSString stringWithFormat:@"%@:%@",[dictTemp objectForKey:@"mail"],[dictTemp objectForKey:@"password"]];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [self base64forData:authData]];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%lu",(unsigned long)requestData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    NSHTTPURLResponse *response = nil;
    NSError *errors = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errors];
    NSLog(@"data : %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    return responseData;
}

+ (NSData *)getData:(NSString *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSDictionary *dictTemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"infos"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",[dictTemp objectForKey:@"mail"],[dictTemp objectForKey:@"password"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [self base64forData:authData]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response = nil;
    NSError *errors = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errors];
    return responseData;
}

+ (BOOL)checkEmail:(NSString *)emailAddress
{
    NSArray *objects = [NSArray arrayWithObject:emailAddress];
    NSArray *keys = [NSArray arrayWithObject:@"login"];
    NSDictionary *infosDict = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/whoami",kURL];
    NSData *response = [self sendData:infosDict atUrl:stringUrl withAuthorization:NO inJSON:NO];
    if (response != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 4128)
        {
            NSString *statut = [dictData objectForKey:@"statut"];
            NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
            [pref setObject:statut forKey:@"statut"];
            return 1;
        }
    }
    return 0;
}

+ (BOOL)login:(NSArray *)parameters
{
    NSArray *keys = [NSArray arrayWithObjects:@"mail",@"password", nil];
    NSDictionary *infosDict = [[NSDictionary alloc] initWithObjects:parameters forKeys:keys];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/%@/login",kURL,[pref objectForKey:@"statut"]];
    NSData *responseData = [self sendData:infosDict atUrl:stringUrl withAuthorization:NO inJSON:NO];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            NSDictionary *infos = [dictData objectForKey:@"message"];
            NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
            [pref setObject:infos forKey:@"infos"];
            return 1;
        }
    }
    return 0;
}

+ (BOOL)signUp:(NSArray *)parameters
{
    NSArray *keys = [NSArray arrayWithObjects:@"username",@"password",@"confirmation",@"mail",@"phone",@"lastname",@"firstname", nil];
    NSDictionary *infosDict = [[NSDictionary alloc] initWithObjects:parameters forKeys:keys];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/%@/register",kURL,[pref objectForKey:@"statut"]];
    NSData *responseData = [self sendData:infosDict atUrl:stringUrl withAuthorization:NO inJSON:NO];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            NSDictionary *infos = [dictData objectForKey:@"message"];
            NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
            [pref setObject:infos forKey:@"infos"];
            return 1;
        }
    }
    return 0;
}

+ (NSArray *)searchInPhoneBook:(NSArray *)contacts
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/%@/searchinphonebook",kURL,[pref objectForKey:@"statut"]];
    NSData *responseData = [self sendData:contacts atUrl:stringUrl withAuthorization:YES inJSON:NO];
    if (responseData != nil)
    {
        
    }
    return nil;
}

+ (NSArray *)searchResults:(NSString *)searchText
{
    return nil;
}

@end

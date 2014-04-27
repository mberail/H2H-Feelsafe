//
//  WebServices.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "WebServices.h"
#import <AddressBookUI/AddressBookUI.h>
#import "SVProgressHUD.h"

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

+ (NSData *)sendData:(id)parameters atUrl:(NSString *)url withAuthorization:(BOOL)authorization Json:(BOOL)json
{
    NSLog(@"url : %@",url);
    NSLog(@"para : %@",parameters);
    
    NSData *requestData = [[NSData alloc] init];
    
 
        NSString *stringTemp = @"";
        for (int i = 0; i < [parameters count]; i++)
        {
            if( i == [parameters count]-1 )
            {
                stringTemp = [NSString stringWithFormat:@"%@%@=%@",stringTemp,[parameters allKeys][i],[parameters allValues][i]];
            }
            else
            {
                stringTemp = [NSString stringWithFormat:@"%@%@=%@&",stringTemp,[parameters allKeys][i],[parameters allValues][i]];
            }
        }
        requestData = [stringTemp dataUsingEncoding:NSUTF8StringEncoding];
    

    NSLog(@"requestdata : %@",[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (authorization)
    {
        NSDictionary *dictTemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"infos"];
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        NSString *authStr = [NSString stringWithFormat:@"%@:%@",[dictTemp objectForKey:@"mail"],[pref objectForKey:@"password"]];
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
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSDictionary *dictTemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"infos"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",[dictTemp objectForKey:@"mail"],[pref objectForKey:@"password"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [self base64forData:authData]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response = nil;
    NSError *errors = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errors];
     NSLog(@"data : %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    return responseData;
}

+ (UIImage *)getPictureData:(NSString *)url
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSDictionary *dictTemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"infos"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",[dictTemp objectForKey:@"mail"],[pref objectForKey:@"password"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [self base64forData:authData]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];

    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *pic = [[UIImage alloc] initWithData:responseData];
    NSLog(@"data : %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    return pic;
}

+ (BOOL)checkEmail:(NSString *)emailAddress
{
    //return 1;
    NSArray *objects = [NSArray arrayWithObject:emailAddress];
    NSArray *keys = [NSArray arrayWithObject:@"login"];
    NSDictionary *infosDict = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/whoami",kURL];
    NSData *response = [self sendData:infosDict atUrl:stringUrl withAuthorization:NO Json:NO];
    if (response != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        NSString *email = [infosDict objectForKey:@"login"];
        [pref setObject:email forKey:@"email"];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 404)
        {
            NSString *mailOK = @"true";
            [pref setObject:mailOK forKey:@"CheckMail"];

        }
        if (code == 4129)
        {
            
            NSString *status = [dictData objectForKey:@"status"];
           
            [pref setObject:status forKey:@"status"];
            NSString *mailOK = @"true";
            [pref setObject:mailOK forKey:@"CheckMail"];
            
            return 1;
        }
        if (code == 4119)
        {
            NSString *mailOK = @"false";
            [pref setObject:mailOK forKey:@"CheckMail"];
            [[[UIAlertView alloc] initWithTitle:nil message:@"L'adresse mail n'est pas valide !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
    return 0;
}

+ (BOOL)login:(NSArray *)parameters
{
    NSArray *keys = [NSArray arrayWithObjects:@"mail",@"password", nil];
    NSMutableDictionary *infosDict = [[NSMutableDictionary alloc] initWithObjects:parameters forKeys:keys];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *phoneid = [pref objectForKey:@"phoneid"];
    [infosDict setObject:phoneid forKey:@"phoneid"]; //mise en cache du phoneid
    NSString *phoneos = [pref objectForKey:@"phoneos"];
    [infosDict setObject:phoneos forKey:@"phoneos"]; //mise en cache de phoneos
    NSString *MDP = [infosDict objectForKey:@"password"];
    [pref setObject:MDP forKey:@"password"]; //mise en cache du mot de passe
    NSString *stringUrl = [NSString stringWithFormat:@"%@/%@/login",kURL,[pref objectForKey:@"status"]];
    NSData *responseData = [self sendData:infosDict atUrl:stringUrl withAuthorization:NO Json:NO];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            [pref setBool:YES forKey:@"isConnected"]; //mise en cache de la connexion réussie
            NSString *status = [pref objectForKey:@"status"];
            if ([status isEqual:@"referent"])
            {
                NSDictionary *infos_referent = [dictData objectForKey:@"message"];
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                [pref setObject:infos_referent forKey:@"infos"];
                NSLog(@"infos : %@",dictData);
            }
            else if ([status isEqual:@"protege"])
            {
                NSNull *rien = [[NSNull alloc]init];
                NSDictionary *infos_protege = [dictData objectForKey:@"message"];
                if ([[infos_protege objectForKey:@"latitude"] isEqual:rien])
                {
                    [infos_protege setValue:@"Rien"forKey:@"latitude"];
                }
                if ([[infos_protege objectForKey:@"longitude"]  isEqual:rien])
                {
                    [infos_protege setValue:@"Rien"forKey:@"longitude"];
                }
                if ([infos_protege objectForKey:@"address"]  == rien)
                {
                    [infos_protege setValue:@"Rien"forKey:@"address"];
                }
                NSLog(@"infos : %@", infos_protege);
                 [pref setObject:infos_protege forKey:@"infos"];
                
            }
            return 1;
        }
    }
    return 0;
}

+ (BOOL)signUp:(NSArray *)parameters
{
    NSArray *keys = [NSArray arrayWithObjects:@"username",@"password",@"confirmation",@"mail",@"phone",@"lastname",@"firstname", nil];
    NSMutableDictionary *infosDict = [[NSMutableDictionary alloc] initWithObjects:parameters forKeys:keys];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    //NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    NSString *phoneos = [pref objectForKey:@"phoneos"];
    [infosDict setObject:phoneos forKey:@"phoneos"];
    NSString *phoneid = [pref objectForKey:@"phoneid"];
    [infosDict setObject:phoneid forKey:@"phoneid"];
    NSString *Status = [pref objectForKey:@"status"];
    [infosDict setObject:Status forKey:@"status"];
    NSString *MDP = [infosDict objectForKey:@"password"];
    [pref setObject:MDP forKey:@"password"];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/register",kURL];
    NSData *response = [self sendData:infosDict atUrl:stringUrl withAuthorization:NO Json:NO];
    if (response != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            if ([Status isEqual:@"referent"])
            {
                NSDictionary *infos = [dictData objectForKey:@"message"];
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                [pref setObject:infos forKey:@"infos"];
                NSLog(@"infos : %@",infos);
            }
            else if ([Status isEqual:@"protege"])
            {
                NSNull *rien = [[NSNull alloc]init];
                NSDictionary *infos_protege = [dictData objectForKey:@"message"];
                if ([[infos_protege objectForKey:@"latitude"] isEqual:rien])
                {
                    [infos_protege setValue:@"Rien"forKey:@"latitude"];
                }
                if ([[infos_protege objectForKey:@"longitude"]  isEqual:rien])
                {
                    [infos_protege setValue:@"Rien"forKey:@"longitude"];
                }
                if ([infos_protege objectForKey:@"address"]  == rien)
                {
                    [infos_protege setValue:@"Rien"forKey:@"address"];
                }
                NSLog(@"infos : %@", infos_protege);
                [pref setObject:infos_protege forKey:@"infos"];
            }
            return 1;
        }
        if (code == 4128)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"L'identifiant est déja utilisé !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        if (code == 4129)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"L'addresse Mail est déja utilisé !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
    return 0;
}

+ (NSArray *)searchInPhoneBook:(NSArray *)contacts
{
   // NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *infodict = [[NSMutableDictionary alloc]init];
    NSData *JsonData = [NSJSONSerialization dataWithJSONObject:contacts options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:JsonData encoding:NSUTF8StringEncoding];
    [infodict setObject:contacts forKey:@"phonebook"];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/searchinphonebook",kURL];
    [infodict setObject:jsonString forKey:@"phonebook"];
    NSData *response = [self sendData:infodict atUrl:stringUrl withAuthorization:YES Json:YES];
    if (response != nil)
    {
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
         NSDictionary *infos = [responsedict objectForKey:@"message"];
        NSMutableArray *contactList =[[NSMutableArray alloc]init ];
        for (int i =0; i <[infos count]-1; i+=1)
        {
            NSString *index = [NSString stringWithFormat:@"%i",i];
            NSArray *value = [infos objectForKey:index];
            if (value !=nil)
            [contactList addObject:value];
            else
                continue;
            
        }
//NSLog(@"truc truc %@",contactList);
        return contactList;
        
    }
         return nil;
}


+ (NSArray *)searchResults:(NSString *)searchText
{
   
    NSArray *objects = [NSArray arrayWithObject:searchText];
    NSArray *keys = [NSArray arrayWithObject:@"login"];
    NSDictionary *infosDict = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    //NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/searchbylogin",kURL];
    NSData *responseData = [self sendData:infosDict atUrl:stringUrl withAuthorization:YES Json:NO];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            NSArray *infos = [[NSArray alloc]initWithArray:[dictData objectForKey:@"message"]];
            return infos;
        }
        if (code == 4119)
        {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:nil message:@"Minimum 4 catatères en minuscule !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            

        }
        if (code == 404)
        {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:nil message:@"Aucun protégé trouvé" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
       
    }
    return nil;
}

+ (BOOL)updateInformations:(NSArray *)parameters
{
      NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSArray *keys = [NSArray arrayWithObjects:@"alert",@"lon",@"lat",@"address",@"message",nil];
    NSMutableDictionary *infosDict = [[NSMutableDictionary alloc] initWithObjects:parameters forKeys:keys];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/%@/updateposition",kURL,[pref objectForKey:@"status"]];
    NSData *responseData = [self sendData:infosDict atUrl:stringUrl withAuthorization:YES Json:NO];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
   
                NSDictionary *infos = [dictData objectForKey:@"message"];
              //  NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                NSLog(@"infos : %@", infos);
                // [pref setObject:infos forKey:@"infos"];
             return 1;
            }
        
        
    }
    return 0;
}

+ (BOOL)updateAccount:(NSMutableDictionary *)infosDict
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    //NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    NSString *phoneos = [pref objectForKey:@"phoneos"];
    [infosDict setObject:phoneos forKey:@"phoneos"];
    NSString *phoneid = [pref objectForKey:@"phoneid"];
    [infosDict setObject:phoneid forKey:@"phoneid"];
    NSString *Status = [pref objectForKey:@"status"];
    [infosDict setObject:Status forKey:@"status"];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/updateaccount",kURL];
    NSData *response = [self sendData:infosDict atUrl:stringUrl withAuthorization:YES Json:NO];
    if (response != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            if ([Status isEqual:@"referent"])
            {
                
                NSDictionary *infos = [dictData objectForKey:@"message"];
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                [pref setObject:infos forKey:@"infos"];
           
                NSLog(@"infos : %@",infos);
                
            }
            else if ([Status isEqual:@"protege"])
            {
                NSNull *rien = [[NSNull alloc]init];
                NSDictionary *infos_protege = [dictData objectForKey:@"message"];
                if ([[infos_protege objectForKey:@"latitude"] isEqual:rien])
                {
                    [infos_protege setValue:@"Rien"forKey:@"latitude"];
                }
                if ([[infos_protege objectForKey:@"longitude"]  isEqual:rien])
                {
                    [infos_protege setValue:@"Rien"forKey:@"longitude"];
                }
                if ([infos_protege objectForKey:@"address"]  == rien)
                {
                    [infos_protege setValue:@"Rien"forKey:@"address"];
                }
                NSLog(@"infos : %@", infos_protege);
                [pref setObject:infos_protege forKey:@"infos"];
            }
            return 1;
        }
        if (code == 4128)
        {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:nil message:@"L'identifiant est déja utilisé !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        if (code == 4129)
        {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:nil message:@"L'addresse Mail est déja utilisé !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
    return 0;
}

+(void)stopAlert: (NSString *)idProtege
{
    NSArray *protegeId = [[NSArray alloc]initWithObjects:idProtege, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"id", nil];
    
    //NSMutableDictionary *infosDict = [[NSMutableDictionary alloc] initWithObjects:registered forKeys:keys];
    NSDictionary *infosDict = [[NSDictionary alloc] initWithObjects:protegeId forKeys:keys];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/referent/decreasealert",kURL];
    NSData *responseData = [self sendData:infosDict atUrl:stringUrl withAuthorization:YES Json:NO];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
             //NSString *infos = [[NSArray alloc]initWithArray:[dictData objectForKey:@"message"]];
            //NSLog(@"marche = %@",infos);
            [SVProgressHUD showSuccessWithStatus:@"Alerte danger desactivée"];
            //return infos;
        }
        else
            [SVProgressHUD showSuccessWithStatus:@"Alerte danger desactivée"];
    }
    //return nil;
    
}


+(void)sendInvit: (NSString *)registered
{
    NSArray *protegeId = [[NSArray alloc]initWithObjects:registered, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"id", nil];
    
    //NSMutableDictionary *infosDict = [[NSMutableDictionary alloc] initWithObjects:registered forKeys:keys];
    NSDictionary *infosDict = [[NSDictionary alloc] initWithObjects:protegeId forKeys:keys];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/invite",kURL];
    NSData *responseData = [self sendData:infosDict atUrl:stringUrl withAuthorization:YES Json:NO];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
           // NSString *infos = [[NSArray alloc]initWithArray:[dictData objectForKey:@"message"]];
            //NSLog(@"marche = %@",infos);
            [SVProgressHUD showSuccessWithStatus:@"Invitation envoyée"];
            //return infos;
            
        }
        if (code == 500)
        {
            [SVProgressHUD showErrorWithStatus:@"Invitation déjà envoyée"];
        }
        else
            NSLog(@"casser");
    }
    //return nil;
}

+(NSArray *) checkInvitation
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/checkinvitations",kURL];
    NSData *responseData = [self getData:stringUrl ];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            NSArray *infos = [[NSArray alloc]initWithArray:[dictData objectForKey:@"message"]];
            NSLog(@"marche = %@",infos);
            //[SVProgressHUD showSuccessWithStatus:@"Invitation envoyée"];
            return infos;
            
        }
        if (code == 500)
        {
           // [SVProgressHUD showErrorWithStatus:@"Invitation déjà envoyée"];
            NSArray *infos = [[NSArray alloc]initWithArray:[dictData objectForKey:@"message"]];
            NSLog(@"marche = %@",infos);
        }
        else
        {
            //NSArray *infos = [[NSArray alloc]initWithArray:[dictData objectForKey:@"message"]];
           // NSLog(@"marche = %@",dictData);
        }
           
    }
    return nil;
}

+(void) answerInvitation: (NSArray *)response
{
    NSMutableDictionary *infosDict = [[NSMutableDictionary alloc] init];
    NSData *JsonData = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:JsonData encoding:NSUTF8StringEncoding];
    [infosDict setObject:jsonString forKey:@"invitations"];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/respondinvitation",kURL];
    NSData *responseData = [self sendData:infosDict atUrl:stringUrl withAuthorization:YES Json:YES];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            [SVProgressHUD showSuccessWithStatus:@"Réponse envoyée"];
        }
        else
        {
            [SVProgressHUD dismiss];
        }

    }
}

+(NSArray *) protegesInfos
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@/referent/getprotegeinformations",kURL];
    NSData *responseData = [self getData:stringUrl ];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            NSArray *infos = [[NSArray alloc]initWithArray:[dictData objectForKey:@"message"]];
            return infos;
            
        }
    }
    return nil;
}


+(void)resetPassword
{
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"mail", nil];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSString *truc = [NSString stringWithFormat:@"%@",[pref objectForKey:@"email"]];
    NSArray *param = [[NSArray alloc]initWithObjects:truc, nil];
    NSMutableDictionary *infosDict = [[NSMutableDictionary alloc] initWithObjects:param forKeys:keys];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/user/resetpassword",kURL];
    NSData *responseData = [self sendData:infosDict atUrl:stringUrl withAuthorization:NO Json:NO];
    if (responseData != nil)
    {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        int code = [[dictData objectForKey:@"code"] intValue];
        if (code == 200)
        {
            // NSString *infos = [[NSArray alloc]initWithArray:[dictData objectForKey:@"message"]];
            //NSLog(@"marche = %@",infos);
            [SVProgressHUD showSuccessWithStatus:@"Un e-mail vous a été envoyer"];
            //return infos;
            
        }
        else
            NSLog(@"casser");
    }
    //return nil;
}

+(UIImage *) getPicture: (NSString*) userId
{
    
    
    NSData *thedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/portrait.jpg",picURL,userId]]];
    NSLog(@"par ici %@",userId);
    NSString *data = [NSString stringWithFormat:@"%@",thedata];
    NSLog(@"les photo %@",data );
    if ([data isEqualToString:@"(null)"])
    {
        NSLog(@"Success");
        return [UIImage imageNamed:@"no_img.jpg"];
    }
    else
    {
        UIImage *img = [[UIImage alloc] initWithData:thedata];
        return img;
    }
        
    

}










@end

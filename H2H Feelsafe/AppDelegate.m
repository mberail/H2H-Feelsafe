//
//  AppDelegate.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUUID *phoneuuid = [[UIDevice currentDevice] identifierForVendor];
    NSString *phoneid = [phoneuuid UUIDString];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:phoneid forKey:@"phoneid"];
    NSLog(@"PhoneID : %@",phoneid);
    NSString *phoneos = @"iphone";
    [pref setObject:phoneos forKey:@"phoneos"];
    
    if ([[pref objectForKey:@"isConnected"] boolValue] == YES)
    {
        if ([[pref objectForKey:@"status"] isEqualToString:@"referent"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            UIViewController *leftvc = [storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
            IIViewDeckController *viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:nvc leftViewController:leftvc];
            viewDeck.leftSize = 65;
            viewDeck.panningMode = IIViewDeckNavigationBarPanning;
            self.window.rootViewController = viewDeck;
        }
        else if ([[pref objectForKey:@"status"] isEqualToString:@"protege"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Navigation_Pro_ViewController"];
            self.window.rootViewController = vc;
        }
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nvc;
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

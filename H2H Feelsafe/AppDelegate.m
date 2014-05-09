//
//  AppDelegate.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 10/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
   
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
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
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            UIViewController *leftvc = [storyboard instantiateViewControllerWithIdentifier:@"LeftViewProtege"];
            IIViewDeckController *viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:nvc leftViewController:leftvc];
            viewDeck.leftSize = 65;
            viewDeck.panningMode = IIViewDeckNavigationBarPanning;
            self.window.rootViewController = viewDeck;
            
        }
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nvc;
    }
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.window.tintColor = [[UIColor alloc]initWithRed:(142.0/255.0) green:(20./255.0) blue:(129./255.0) alpha:1.0];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
//enregistrement de l'UDID dans la mémoire de l'appli
{
    NSLog(@"My token is: %@",[newDeviceToken description]); //numéro de série de l'iPhone (UDID)
    NSString *newToken = @"";
    for (int i = 0; i < newDeviceToken.description.length; i++) //fonction pour supprimer les espaces et caractères incorrects de l'UDID
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [newDeviceToken.description substringWithRange:range];
        if ([subString isEqualToString:@" "] || [subString isEqualToString:@"<"] || [subString isEqualToString:@">"])
            newToken = [NSString stringWithFormat:@"%@",newToken];
        else
            newToken = [NSString stringWithFormat:@"%@%@",newToken,subString];
    }
    NSLog(@"newToken : %@",newToken);
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:newToken forKey:@"phoneid"];
}








/*
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"to background");
    
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = 0;
    
    // Request permission to run in the background. Provide an
    // expiration handler in case the task runs long.
    NSAssert(bgTask == UIBackgroundTaskInvalid, nil);
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^
              {
                  // Synchronize the cleanup call on the main thread in case
                  // the task actually finishes at around the same time.
                  dispatch_async(dispatch_get_main_queue(), ^
                                 {
                                     if (bgTask != UIBackgroundTaskInvalid)
                                     {
                                         [app endBackgroundTask:bgTask];
                                         bgTask = UIBackgroundTaskInvalid;
                                     }
                                 });
              }];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       if ([[preferences objectForKey:@"order_begun"] intValue] == 1)
                       {
                           self.locationManager.distanceFilter = kCLDistanceFilterNone;
                           self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; //meilleure précision pour la géolocalisation
                           [self.locationManager startMonitoringSignificantLocationChanges];
                           [self.locationManager startUpdatingLocation]; //début de la géolocalisation
                           [self setPosition];
                           NSLog(@"App staus: applicationDidEnterBackground");
                           // Synchronize the cleanup call on the main thread in case
                           // the expiration handler is fired at the same time.
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              if (bgTask != UIBackgroundTaskInvalid)
                                              {
                                                  [app endBackgroundTask:bgTask];
                                                  bgTask = UIBackgroundTaskInvalid;
                                              }
                                          });
                       }
                   });
    NSLog(@"backgroundTimeRemaining: %.0f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
}*/

/*- (void)setPosition //envoie des coord GPS à la BDD
{
    CLLocation *location = self.locationManager.location;
    //ajouter appel à la méthode updateLocation WebServices
}

//iOS > 6 : envoi des coord GPS
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"new location %@", location.description);
    //ajouter appel à la méthode updateLocation WebServices
}

//iOS < 6 : envoi des coord GPS
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"new location %@", newLocation.description);
    //ajouter appel à la méthode updateLocation WebServices
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Erreur de localisation %@", error);
    [self.locationManager stopUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([[preferences objectForKey:@"isConnected"] boolValue] == YES)
    {
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
        [self setPosition];
        NSLog(@"App status: applicationWillEnterForeground");
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
*/
@end

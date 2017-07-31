//
//  AppDelegate.m
//  KNMVVMReactiveCocoaDemo
//
//  Created by devzkn on 31/07/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "AppDelegate.h"
#import "MRCLoginViewModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1、注册registerNavigationHooks
    self.services = [[MRCViewModelServicesImpl alloc] init];
    self.navigationControllerStack = [[MRCNavigationControllerStack alloc] initWithServices:self.services];

//    2、创建window
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.services resetRootViewModel:[self createInitialViewModel]];
    
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}



- (MRCViewModel *)createInitialViewModel {
    // The user has logged-in.
    if ([SSKeychain rawLogin].isExist && [SSKeychain accessToken].isExist) {
        // Some OctoKit APIs will use the `login` property of `OCTUser`.
        OCTUser *user = [OCTUser mrc_userWithRawLogin:[SSKeychain rawLogin] server:OCTServer.dotComServer];
        
        OCTClient *authenticatedClient = [OCTClient authenticatedClientWithUser:user token:[SSKeychain accessToken]];
        self.services.client = authenticatedClient;
        
        //        return [[MRCHomepageViewModel alloc] initWithServices:self.services params:nil];
        return nil;
    } else {
        return [[MRCLoginViewModel alloc] initWithServices:self.services params:nil];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

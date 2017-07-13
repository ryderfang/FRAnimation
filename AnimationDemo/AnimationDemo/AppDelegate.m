//
//  AppDelegate.m
//  AnimationDemo
//
//  Created by Ray Fong on 16/12/5.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <DCIntrospect/DCIntrospect.h>
#import "SensorsAnalyticsSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BiliIconFont initWithName:@"iconfont"];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *root = [[MainViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = navigationController;
    [[UINavigationBar appearance] setBarTintColor:FR_BLUE_COLOR];
    [[UINavigationBar appearance]
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.window addSubview:root.view];
    [self.window makeKeyAndVisible];

#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif

    // 数据接收的 URL
#define SA_SERVER_URL @"YOUR_SERVER_URL"
    // 配置分发的 URL
#define SA_CONFIGURE_URL @"YOUR_CONFIGURE_URL"
    // Debug 模式选项
    //   SensorsAnalyticsDebugOff - 关闭 Debug 模式
    //   SensorsAnalyticsDebugOnly - 打开 Debug 模式，校验数据，但不进行数据导入
    //   SensorsAnalyticsDebugAndTrack - 打开 Debug 模式，校验数据，并将数据导入到 Sensors Analytics 中
    // 注意！请不要在正式发布的 App 中使用 Debug 模式！
#define SA_DEBUG_MODE SensorsAnalyticsDebugOnly

    // 初始化 SDK
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL
                                     andConfigureURL:SA_CONFIGURE_URL
                                        andDebugMode:SA_DEBUG_MODE];

    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart |
     SensorsAnalyticsEventTypeAppEnd |
     SensorsAnalyticsEventTypeAppViewScreen |
     SensorsAnalyticsEventTypeAppClick];

    return YES;
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

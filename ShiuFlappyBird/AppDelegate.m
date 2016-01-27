//
//  AppDelegate.m
//  ShiuFlappyBird
//
//  Created by 許佳豪 on 2016/1/26.
//  Copyright © 2016年 許佳豪. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [MainViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

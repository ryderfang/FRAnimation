//
//  UITabBarController+Rotate.m
//  FRAnimation
//
//  Created by Rui on 2020/4/13.
//  Copyright © 2020 ryderfang. All rights reserved.
//

#import "UITabBarController+Rotate.h"

@implementation UITabBarController (Rotate)

- (NSUInteger) supportedInterfaceOrientations {
    return [self.currentViewController supportedInterfaceOrientations];

}

- (BOOL)shouldAutorotate {
    return [self.currentViewController shouldAutorotate];
}

- (UIViewController*) currentViewController {
    UIViewController* controller = self.selectedViewController;
    if([controller isKindOfClass:[UINavigationController class]]) {
        controller = [((UINavigationController*)controller).viewControllers objectAtIndex:0];
    }
    return controller;
}

@end

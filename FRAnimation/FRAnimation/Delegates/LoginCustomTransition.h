//
//  LoginCustomTransition.h
//  FRAnimation
//
//  Created by Rui on 2016/12/29.
//  Copyright © 2016年 ryderfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MyTransitionType) {
    MyTransitionTypePresent,
    MyTransitionTypeDismiss
};

@interface LoginCustomTransition : NSObject <
    UIViewControllerAnimatedTransitioning,
    CAAnimationDelegate
>

+ (instancetype)transitionWithTransitionType:(MyTransitionType)type;

@end

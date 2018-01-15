//
//  LoginCustomTransition.h
//  FRAnimation
//
//  Created by Ray Fong on 2016/12/29.
//  Copyright © 2016年 Ray Fong. All rights reserved.
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

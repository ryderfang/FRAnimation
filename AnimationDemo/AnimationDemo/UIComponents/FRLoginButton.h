//
//  FRLoginButton.h
//  AnimationDemo
//
//  Created by Ray Fong on 2016/12/26.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)(void);

@interface FRLoginButton : UIView

@property (nonatomic, copy) completeBlock block;

- (void)show;

@end

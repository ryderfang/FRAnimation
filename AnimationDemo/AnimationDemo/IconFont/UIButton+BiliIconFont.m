//
//  UIButton+BiliIconFont.m
//  AnimationDemo
//
//  Created by Ray Fong on 2017/6/15.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

#import "UIButton+BiliIconFont.h"
#import "UIImage+BiliIconFont.h"

@implementation UIButton (BiliIconFont)

+ (instancetype)buttonWithIconInfo:(BiliIconInfo *)info {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageWithIconInfo:info] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithIconInfo:info] forState:UIControlStateHighlighted];
    return button;
}

@end

//
//  UIButton+BiliIconFont.m
//  FRAnimation
//
//  Created by Rui on 2017/6/15.
//  Copyright © 2017年 ryderfang. All rights reserved.
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

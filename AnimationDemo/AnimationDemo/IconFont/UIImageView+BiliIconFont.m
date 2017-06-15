//
//  UIImageView+BiliIconFont.m
//  AnimationDemo
//
//  Created by Ray Fong on 2017/6/15.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

#import "UIImageView+BiliIconFont.h"
#import "UIImage+BiliIconFont.h"

@implementation UIImageView (BiliIconFont)

+ (instancetype)imageViewWithIconInfo:(BiliIconInfo *)info {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageWithIconInfo:info];
    return imageView;
}

@end

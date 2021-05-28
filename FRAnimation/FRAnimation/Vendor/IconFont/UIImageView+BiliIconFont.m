//
//  UIImageView+BiliIconFont.m
//  FRAnimation
//
//  Created by Rui on 2017/6/15.
//  Copyright © 2017年 ryderfang. All rights reserved.
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

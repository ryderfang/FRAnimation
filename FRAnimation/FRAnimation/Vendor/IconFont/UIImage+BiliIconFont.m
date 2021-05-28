//
//  UIImage+BiliIconFont.m
//  FRAnimation
//
//  Created by Rui on 2017/6/15.
//  Copyright © 2017年 ryderfang. All rights reserved.
//

#import "UIImage+BiliIconFont.h"

@implementation UIImage (BiliIconFont)

+ (instancetype)imageWithIconInfo:(BiliIconInfo *)info {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat size = info.size * scale;
    UIFont *font = [BiliIconFont fontWithSize:size];
    UIGraphicsBeginImageContext(CGSizeMake(size, size));
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ([info.text respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        [info.text drawAtPoint:CGPointZero withAttributes:@{NSFontAttributeName: font,
                                                            NSForegroundColorAttributeName: info.color}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, info.color.CGColor);
        [info.text drawAtPoint:CGPointMake(0, 0) withFont:font];
#pragma clang pop
    }

    UIImage *image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage
                                         scale:scale
                                   orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    return image;
}

@end

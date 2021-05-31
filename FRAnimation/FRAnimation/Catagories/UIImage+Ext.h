//
//  UIImage+Ext.h
//  FRAnimation
//
//  Created by Rui on 2018/7/25.
//  Copyright © 2018年 ryderfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ext)

// 生成1*1像素的纯色图片
+ (UIImage *)imageWithColor1x1:(UIColor *)color;

// 生成指定尺寸的纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

// 设置图片透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;

// 修改图片大小
+ (UIImage *)resizeImage:(UIImage *)image withNewSize:(CGSize)newSize scale:(CGFloat)scale;

// 圆角图片
- (UIImage *)roundedCornerImageWithRadius:(CGFloat)radius;

@end

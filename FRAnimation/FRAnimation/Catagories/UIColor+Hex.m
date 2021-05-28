//
//  UIColor+UIColor_Hex.m
//  FRAnimation
//
//  Created by Rui on 2016/12/30.
//  Copyright © 2016年 ryderfang. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (UIColor_Hex)

+ (UIColor *)colorWithHex:(NSInteger)hexColor {
    return [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0
                           green:((float)((hexColor & 0xFF00) >> 8))/255.0
                            blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)hexColor alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0
                           green:((float)((hexColor & 0xFF00) >> 8))/255.0
                            blue:((float)(hexColor & 0xFF))/255.0 alpha:alpha];
}

@end

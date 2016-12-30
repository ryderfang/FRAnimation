//
//  UIColor+UIColor_Hex.m
//  AnimationDemo
//
//  Created by Ray Fong on 2016/12/30.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (UIColor_Hex)

+ (UIColor *)colorWithHex:(NSInteger)hexColor {
    return [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0
                           green:((float)((hexColor & 0xFF00) >> 8))/255.0
                            blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0];
}

@end

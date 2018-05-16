//
//  UIColor+UIColor_Hex.h
//  FRAnimation
//
//  Created by Ray Fong on 2016/12/30.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColor_Hex)

+ (UIColor *)colorWithHex:(NSInteger)hexColor;

+ (UIColor *)colorWithHex:(NSInteger)hexColor alpha:(CGFloat)alpha;

@end

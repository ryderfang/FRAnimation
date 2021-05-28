//
//  UIDefs.h
//  FRAnimation
//
//  Created by Rui on 2017/5/22.
//  Copyright © 2017年 ryderfang. All rights reserved.
//

#ifndef UIDefs_h
#define UIDefs_h

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXCOLORA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define RGBCOLOR(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define FR_PINK_COLOR [UIColor colorWithRed:251./255 green:114./255 blue:153./255 alpha:1]
#define FR_BLUE_COLOR [UIColor colorWithRed:20./255 green:155./255 blue:213./255 alpha:1]

#define FR_GRAY_COLOR_53 [UIColor colorWithWhite:53./255 alpha:1]
#define FR_GRAY_COLOR_153 [UIColor colorWithWhite:153./255 alpha:1]

#define FR_SCREEN_WIDTH MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define FR_SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

// 被坑了一把，记得后面的括号！！不然在表达式中就坑了！(a - b + c) != (a - (b + c))
#define FR_NavStatusHeight  (self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height)


#define kGlobalNotification @"kGlobalNotification"

#import "UIViewAdditions.h"

#endif /* UIDefs_h */

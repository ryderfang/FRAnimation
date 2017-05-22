//
//  UIDefs.h
//  AnimationDemo
//
//  Created by Ray Fong on 2017/5/22.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

#ifndef UIDefs_h
#define UIDefs_h

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define RGBCOLOR(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define FR_PINK_COLOR [UIColor colorWithRed:251./255 green:114./255 blue:153./255 alpha:1]
#define FR_BLUE_COLOR [UIColor colorWithRed:20./255 green:155./255 blue:213./255 alpha:1]

#endif /* UIDefs_h */

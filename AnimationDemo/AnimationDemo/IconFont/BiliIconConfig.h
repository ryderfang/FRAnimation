//
//  BiliIconConfig.h
//  AnimationDemo
//
//  Created by Ray Fong on 2017/6/15.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

#ifndef BiliIconConfig_h
#define BiliIconConfig_h

#define BiliIconMake(t, sz, c) [BiliIconInfo iconInfoWithText:t size:sz color:c]

#define Bili_Icon_Female BiliIconMake("\uE65E", 32, FR_PINK_COLOR)

#define Bili_Icon_Male BiliIconMake("\uE65F", 32, FR_BLUE_COLOR)

#define Bili_Icon_Unknown_Gender BiliIconMake("\uE660", 32, FR_BLUE_COLOR)

#define Bili_Icon_Tab_Home BiliIconMake("\uE661", 32, FR_GRAY_COLOR_153)

#define Bili_Icon_Tab_Home_S BiliIconMake("\uE661", 32, FR_PINK_COLOR)

#endif /* BiliIconConfig_h */

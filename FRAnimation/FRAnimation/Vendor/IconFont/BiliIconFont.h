//
//  BiliIconFont.h
//  FRAnimation
//
//  Created by Ray Fong on 2017/6/15.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BiliIconConfig.h"

@interface BiliIconFont : NSObject

+ (void)initWithName:(NSString *)fontName;

+ (UIFont *)fontWithSize:(CGFloat)fontSize;

+ (BOOL)isIconFont:(UIFont *)font;

@end

@interface BiliIconInfo : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly, assign) CGFloat size;
@property (nonatomic, readonly) UIColor *color;

// text format - "\uE65E"
+ (instancetype)iconInfoWithText:(const char *)text size:(CGFloat)size color:(UIColor *)color;

@end

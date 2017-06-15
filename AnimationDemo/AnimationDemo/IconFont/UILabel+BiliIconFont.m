//
//  UILabel+BiliIconFont.m
//  AnimationDemo
//
//  Created by Ray Fong on 2017/6/15.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

#import "UILabel+BiliIconFont.h"
#import "UIImage+BiliIconFont.h"

@implementation UILabel (BiliIconFont)

+ (instancetype)labelWithIconInfo:(BiliIconInfo *)info {
    UILabel *label = [[UILabel alloc] init];
    label.text = info.text;
    label.font = [BiliIconFont fontWithSize:info.size];
    label.textColor = info.color;
    return label;
}

- (void)layoutSubviews {
    if ([BiliIconFont isIconFont:self.font]) {
        self.font = [BiliIconFont fontWithSize:self.frame.size.height];
    }
}

@end

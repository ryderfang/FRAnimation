//
//  UILabel+BiliIconFont.m
//  FRAnimation
//
//  Created by Rui on 2017/6/15.
//  Copyright © 2017年 ryderfang. All rights reserved.
//

#import "UILabel+BiliIconFont.h"
#import "UIImageView+BiliIconFont.h"
#import "UIImage+BiliIconFont.h"
#import <objc/runtime.h>

static char s_icon_info_key;
static char s_image_view_key;

@implementation UILabel (BiliIconFont)

+ (instancetype)labelWithIconInfo:(BiliIconInfo *)info {
    UILabel *label = [[UILabel alloc] init];
    UIImageView *imageView = [UIImageView imageViewWithIconInfo:info];
    [label addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(label);
    }];
    objc_setAssociatedObject(label, &s_icon_info_key, info, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(label, &s_image_view_key, imageView, OBJC_ASSOCIATION_RETAIN);
    return label;
}

- (void)layoutSubviews {
    BiliIconInfo *info = objc_getAssociatedObject(self, &s_icon_info_key);
    if (info) {
        BiliIconInfo *newInfo = [BiliIconInfo iconInfoWithText:info.text.UTF8String size:self.frame.size.height color:info.color];
        UIImageView *imageView = objc_getAssociatedObject(self, &s_image_view_key);
        if (imageView) {
            imageView.image = [UIImage imageWithIconInfo:newInfo];
        }
    }
}

@end

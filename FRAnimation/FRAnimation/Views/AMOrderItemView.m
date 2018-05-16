//
//  AMOrderItemView.m
//  FRAnimation
//
//  Created by YiMu on 2018/5/16.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "AMOrderItemView.h"

@implementation AMOrderItemView

- (instancetype)initWithFrame:(CGRect)frame Index:(NSInteger)index {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = HEXCOLOR(0x888888).CGColor;
        // test
        UILabel *lbl = [[UILabel alloc] initWithFrame:self.bounds];
        lbl.text = [NSString stringWithFormat:@"%ld", (long)index];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:48];
        lbl.textColor = [UIColor redColor];
        [self addSubview:lbl];
    }
    return self;
}

@end

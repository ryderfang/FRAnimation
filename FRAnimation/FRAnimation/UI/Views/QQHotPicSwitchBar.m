//
//  QQHotPicSwitchBar.m
//  ryderfang
//
//  Created by Rui on 2020/2/24.
//  Copyright © 2018年 ryderfang. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "QQHotPicSwitchBar.h"

@interface QQHotPicSwitchBar ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) NSMutableArray<UIView *> *dots;

@end

@implementation QQHotPicSwitchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.buttons = [NSMutableArray arrayWithCapacity:2];
        self.dots = [NSMutableArray arrayWithCapacity:2];
        [self createViews:@[@"热图", @"DIY斗图", @"测试"]];
        [self doSelectIndex:0];
    }
    return self;
}

- (void)createViews:(NSArray *)titles {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    NSUInteger count = titles.count;
    for (NSUInteger i = 0; i < count; i++) {
        CGRect btnFrame = CGRectMake(i * width / count, 0, width / count, height);
        UIButton *btn = [self createButton:btnFrame text:titles[i]];
        btn.tag = i;
        CGRect dotFrame = CGRectMake((width / count - 4) / 2, height / 2 + 7, 4, 4);
        UIView *dot = [self createDotView:dotFrame];
        [btn addSubview:dot];
        [self addSubview:btn];
        [self.buttons addObject:btn];
        [self.dots addObject:dot];
    }
}

- (UIButton *)createButton:(CGRect)frame text:(NSString *)text {
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(-7, 0, 0, 0)];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIView *)createDotView:(CGRect)frame {
    UIView *dot = [[UIView alloc] initWithFrame:frame];
    dot.backgroundColor = [UIColor whiteColor];
    dot.layer.cornerRadius = 2;
    dot.layer.masksToBounds = YES;
    return dot;
}

- (void)btnClicked:(UIButton *)btn {
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    [self.dots enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = [UIColor whiteColor];
    }];
    btn.selected = YES;
    UIView *dot = self.dots[btn.tag];
    dot.backgroundColor = [UIColor blackColor];

    if (self.delegate && [self.delegate respondsToSelector:@selector(hotPicSwitchBarSelected:)]) {
        [self.delegate hotPicSwitchBarSelected:btn.tag];
    }
}

- (void)doSelectIndex:(NSUInteger)index {
    if (index < self.buttons.count) {
        [self btnClicked:self.buttons[index]];
    }
}

@end

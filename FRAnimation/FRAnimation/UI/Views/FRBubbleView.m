//
//  FRBubbleView.m
//  FRAnimation
//
//  Created by Rui on 2020/7/22.
//  Copyright © 2020 ryderfang. All rights reserved.
//

#import "FRBubbleView.h"

@interface FRMaskView : UIControl

@property (nonatomic, weak) UIView *superView;
@property (nonatomic, copy) void (^maskTouched)(void);

@end

@implementation FRMaskView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [self.superView hitTest:point withEvent:event];
    if (v) {
        [self removeAllSubviews];
        [self removeFromSuperview];
        return v;
    }
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    return [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    return [super touchesEnded:touches withEvent:event];
}

@end

@implementation FRBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _labelInset = UIEdgeInsetsMake(32, 5, 40, 5);

        UIImage *image = [UIImage imageNamed:@"qipao2.png"];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = image;
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];

        CGRect labelRect = UIEdgeInsetsInsetRect(self.bounds, _labelInset);
        _labelTip = [[UILabel alloc] initWithFrame:labelRect];
        _labelTip.backgroundColor = [UIColor clearColor];
        _labelTip.textColor = HEXCOLOR(0x03081A);
        _labelTip.textAlignment = NSTextAlignmentCenter;
        _labelTip.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        [_imageView addSubview:_labelTip];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect superRect = self.bounds;
    CGRect contentRect = UIEdgeInsetsInsetRect(superRect, _contentInset);

    CGRect imageRect = UIEdgeInsetsInsetRect(contentRect, _imageInset);
    _imageView.bounds = CGRectMake(0, 0, imageRect.size.width, imageRect.size.height);
    _imageView.center = CGPointMake(CGRectGetMidX(imageRect), CGRectGetMidY(imageRect));

    CGRect labelRect = UIEdgeInsetsInsetRect(contentRect, _labelInset);
    _labelTip.bounds = CGRectMake(0, 0, labelRect.size.width, labelRect.size.height);
    _labelTip.center = CGPointMake(CGRectGetMidX(labelRect), CGRectGetMidY(labelRect));
    ;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setNeedsLayout];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    return [super touchesBegan:touches withEvent:event];
}

+ (void)showBubble:(FRBubbleView *)bubble inView:(UIView *)superView fullScreenMask:(BOOL)fullScreenMask {
    if (fullScreenMask) {
        FRMaskView *mask = [[FRMaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        mask.superView = superView;
        mask.maskTouched = ^{
            
        };
        [mask addSubview:bubble];
        [[[UIApplication sharedApplication] keyWindow] addSubview:mask];
    } else {
        [superView addSubview:bubble];
    }
}

@end

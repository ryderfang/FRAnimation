//
//  RRSlider.m
//  FRAnimation
//
//  Created by Rui on 2021/5/28.
//  Copyright © 2021 ryderfang. All rights reserved.
//

#import "RRSlider.h"
#import "UIImage+Ext.h"

const CGFloat kRRSliderTrackHeight = 4.0f;

@interface RRSlider ()

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIView *maxTrackView;
@property (nonatomic, strong) UIView *minTrackView;
@property (nonatomic, strong) UIView *defaultValueView;
@property (nonatomic, assign) CGRect trackRect;

@end

@implementation RRSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImage *thumbImage = [UIImage imageNamed:@"slider_thumb"];
        [self setThumbImage:thumbImage forState:UIControlStateNormal];
        [self setThumbImage:thumbImage forState:UIControlStateSelected];
        [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
        self.maximumTrackTintColor = HEXCOLOR(0xF1F2F4);
        UIImage *minTrackImage = [UIImage imageNamed:@"slider_min"];
        minTrackImage = [minTrackImage roundedCornerImageWithRadius:(kRRSliderTrackHeight / 2)];
        // 并不会改变图片大小，只是让他可弹性形变
        minTrackImage = [minTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
//        minTrackImage = [UIImage resizeImage:minTrackImage withNewSize:CGSizeMake(CGRectGetWidth(frame), kRRSliderTrackHeight) scale:1.0];
        [self setMinimumTrackImage:minTrackImage forState:UIControlStateNormal];

        [self addSubview:self.valueLabel];
        
    }
    return self;
}

- (void)setDefaultValue:(float)defaultValue {
    _defaultValue = defaultValue;
    [self setDefaultValueHidden:NO];
}

- (void)setDefaultValueHidden:(BOOL)isHidden {
    self.defaultValueView.hidden = isHidden;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, 30, 20)];
        _valueLabel.font = [UIFont systemFontOfSize:13.f];
        _valueLabel.textColor = [UIColor blackColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.text = [NSString stringWithFormat:@"%.0f", self.value];
    }
    return _valueLabel;
}

- (UIView *)defaultValueView {
    if (!_defaultValueView) {
        _defaultValueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _defaultValueView.backgroundColor = [UIColor whiteColor];
        _defaultValueView.layer.cornerRadius = 4.0;
        _defaultValueView.hidden = NO;
    }
    return _defaultValueView;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    bounds = [super trackRectForBounds:bounds];
    // 修改默认滑杆高度
    self.trackRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, kRRSliderTrackHeight);
    return self.trackRect;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    // 解决 thumb 无法紧靠两端的问题
    CGFloat factor = (value - self.minimumValue) / (self.maximumValue - self.minimumValue);
    CGFloat centerX = CGRectGetWidth(rect) * factor + CGRectGetMinX(rect);
    CGFloat thumbWidth = CGRectGetHeight(bounds);
    return CGRectMake(centerX - thumbWidth / 2.0, 0, thumbWidth, thumbWidth);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateFrame];
}

- (void)updateFrame {
    CGRect thumbRect = [self thumbRectForBounds:self.bounds trackRect:self.bounds value:self.value];
    // layout valueLabel
    self.valueLabel.center = CGPointMake(thumbRect.origin.x + thumbRect.size.width / 2, self.valueLabel.centerY);
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f", self.value];
    
    if (self.defaultValueView.hidden) {
        return;
    }
    if (!self.thumbImageView) {
        for (UIView *v in self.subviews.firstObject.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                self.thumbImageView = (UIImageView *)v;
            }
        }
    }
    
    if (!self.maxTrackView) {
        self.maxTrackView = self.subviews.firstObject.subviews[0];
    }
    if (!self.minTrackView) {
        self.minTrackView = self.subviews.firstObject.subviews[1];
    }

    if (self.thumbImageView && !self.defaultValueView.superview) {
        [self.subviews.firstObject insertSubview:self.defaultValueView belowSubview:self.thumbImageView];
    }
    
    CGSize viewSize = self.defaultValueView.bounds.size;
    CGFloat originX = self.trackRect.origin.x + (self.defaultValue - self.minimumValue) * self.trackRect.size.width / (self.maximumValue - self.minimumValue) - viewSize.width / 2;
    CGRect defaultFrame = CGRectMake(originX, self.trackRect.origin.y + self.trackRect.size.height / 2 - viewSize.height / 2, viewSize.width, viewSize.height);
    self.defaultValueView.frame = defaultFrame;
    
    if (self.enableBiDirection) {
        self.maxTrackView.frame = self.trackRect;
        self.maxTrackView.subviews[0].frame = self.maxTrackView.bounds;
        CGRect minRect = CGRectZero;
        if (self.value > self.defaultValue) {
            minRect = CGRectMake(CGRectGetMidX(defaultFrame), self.trackRect.origin.y, (self.value - self.defaultValue) * CGRectGetWidth(self.bounds) / (self.maximumValue - self.minimumValue), CGRectGetHeight(self.trackRect));
        } else {
            minRect = CGRectMake(CGRectGetMidX(thumbRect), self.trackRect.origin.y, (self.defaultValue - self.value) * CGRectGetWidth(self.bounds) / (self.maximumValue - self.minimumValue), CGRectGetHeight(self.trackRect));
        }
        self.minTrackView.frame = minRect;
        self.minTrackView.subviews[0].frame = self.minTrackView.bounds;
    }
}

// Enlarger hitArea
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -16, -20);
    return CGRectContainsPoint(bounds, point);
}

@end

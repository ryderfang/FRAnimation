//
//  FRLoginButton.m
//  AnimationDemo
//
//  Created by Ray Fong on 2016/12/26.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "FRLoginButton.h"

@interface FRLoginButton () <CAAnimationDelegate>

@property (nonatomic, strong) UIButton *button;

// 中间圆形图层
@property (nonatomic, strong) CAShapeLayer *maskLayer;

// 椭矩形边框
@property (nonatomic, strong) CAShapeLayer *sharpLayer;

// 菊花图层
@property (nonatomic, strong) CAShapeLayer *loadingLayer;

// 点击后圆形图层
@property (nonatomic, strong) CAShapeLayer *clickCircleLayer;

@end

@implementation FRLoginButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.maskLayer];
        [self addSubview:self.button];
        self.button.frame = self.bounds;
        self.button.hidden = YES;
    }
    return self;
}

- (void)show {
    [self.layer addSublayer:self.sharpLayer];
    self.maskLayer.opacity = 0.5;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 0.5;
    pathAnimation.toValue = (__bridge id _Nullable)([self drawBezierPath:self.frame.size.height/2].CGPath);
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.beginTime = 0.5;
    opacityAnimation.duration = 0.5;
    opacityAnimation.toValue = @0;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1;
    animationGroup.animations = @[pathAnimation, opacityAnimation];
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    [self.maskLayer addAnimation:animationGroup forKey:@"maskAnimation"];
}

#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[self.maskLayer animationForKey:@"maskAnimation"] isEqual:anim]) {
        self.button.hidden = NO;
    }
}

#pragma mark - lazy init
- (CAShapeLayer *)sharpLayer {
    if (!_sharpLayer) {
        _sharpLayer = [CAShapeLayer layer];
        _sharpLayer.frame = self.bounds;
        _sharpLayer.path = [self drawBezierPath:self.frame.size.height / 2].CGPath;
        _sharpLayer.fillColor = [UIColor clearColor].CGColor;
        _sharpLayer.strokeColor = [UIColor whiteColor].CGColor;
        _sharpLayer.lineWidth = 2;
    }
    return _sharpLayer;
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.opacity = 0;
        _maskLayer.fillColor = [UIColor whiteColor].CGColor;
        _maskLayer.path = [self drawBezierPath:self.frame.size.width/2].CGPath;
    }
    return _maskLayer;
}

- (CAShapeLayer *)loadingLayer {
    if (!_loadingLayer) {
        _loadingLayer = [CAShapeLayer layer];
        _loadingLayer.position = CGPointMake(self.bounds.size.width / 2 , self.bounds.size.height / 2);
        _loadingLayer.fillColor = [UIColor clearColor].CGColor;
        _loadingLayer.strokeColor = [UIColor whiteColor].CGColor;
        _loadingLayer.lineWidth = 2;
        _loadingLayer.path = [self drawLoadingBezierPath].CGPath;
    }
    return _loadingLayer;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"SIGN IN" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark - drawBezierPath
- (UIBezierPath *)drawBezierPath:(CGFloat)x {
    CGFloat radius = self.bounds.size.height / 2 - 3;
    CGFloat right = self.bounds.size.width - x;
    CGFloat left = x;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    [bezierPath addArcWithCenter:CGPointMake(right, self.bounds.size.height / 2) radius:radius startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
    [bezierPath addArcWithCenter:CGPointMake(left, self.bounds.size.height / 2) radius:radius startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
    [bezierPath closePath];
    return bezierPath;
}

- (UIBezierPath *)drawCircleBezierPath:(CGFloat)radius {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0, 0) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    return bezierPath;
}
                              
- (UIBezierPath *)drawLoadingBezierPath {
    CGFloat radius = self.bounds.size.height / 2 + 3;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0, 0) radius:radius startAngle:M_PI/2 endAngle:M_PI clockwise:YES];
    return bezierPath;
}

- (void)buttonClicked:(UIButton *)btn {
    [self startAnimation];
}

- (void)startAnimation {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 0, 0);
    circleLayer.fillColor = [UIColor whiteColor].CGColor;
    circleLayer.path = [self drawCircleBezierPath:0].CGPath;
    [self.layer addSublayer:circleLayer];
    
    // 圆形放大
    CABasicAnimation *roundAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    roundAnimation.duration = 0.5;
    roundAnimation.toValue = (__bridge id _Nullable)([self drawCircleBezierPath:(self.bounds.size.height - 10 * 2) / 2].CGPath);
    roundAnimation.removedOnCompletion = NO;
    roundAnimation.fillMode = kCAFillModeForwards;
    roundAnimation.beginTime = 0;
//    roundAnimation.beginTime = CACurrentMediaTime() + 1;
    [circleLayer addAnimation:roundAnimation forKey:nil];
    
    self.clickCircleLayer = circleLayer;
    [self performSelector:@selector(nextAnimation) withObject:self afterDelay:roundAnimation.duration];
}

- (void)nextAnimation {
    // 圆形变圆环、圆环变大
    self.clickCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.clickCircleLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.clickCircleLayer.lineWidth = 10;
    
    CABasicAnimation *ringAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    ringAnimation.beginTime = 0;
    ringAnimation.duration = 0.5;
    ringAnimation.toValue = (__bridge id)([self drawCircleBezierPath:(self.bounds.size.height - 10 * 2)].CGPath);
    ringAnimation.removedOnCompletion = NO;
    ringAnimation.fillMode = kCAFillModeForwards;
    
    // 消失
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.beginTime = 0.1;
    opacityAnimation.duration = 0.5;
    opacityAnimation.toValue = @0;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = opacityAnimation.beginTime + opacityAnimation.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[ringAnimation, opacityAnimation];
    
    [self.clickCircleLayer addAnimation:animationGroup forKey:@"clickNextAnimation"];
    [self performSelector:@selector(maskAnimation) withObject:self afterDelay:animationGroup.duration];
}

// 扩散到整个按钮
- (void)maskAnimation {
    self.maskLayer.opacity = 0.5;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.25;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPath:self.frame.size.height/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.maskLayer addAnimation:basicAnimation forKey:nil];
    [self performSelector:@selector(dismissAnimation) withObject:self afterDelay:basicAnimation.duration + 0.2];
}

// 按钮消失
- (void)dismissAnimation {
    [self.maskLayer removeFromSuperlayer];
    self.maskLayer = nil;
    [self.clickCircleLayer removeFromSuperlayer];
    self.button.hidden = YES;
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.2;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPath:self.frame.size.width / 2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.beginTime = 0.1;
    opacityAnimation.duration = 0.2;
    opacityAnimation.toValue = @0;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[basicAnimation, opacityAnimation];
    animationGroup.duration = opacityAnimation.beginTime + opacityAnimation.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    [self.sharpLayer addAnimation:animationGroup forKey:nil];
    [self performSelector:@selector(loadingAnimation) withObject:self afterDelay:animationGroup.duration];
}

- (void)loadingAnimation {
    [self.sharpLayer removeFromSuperlayer];
    self.sharpLayer = nil;
    [self.layer addSublayer:self.loadingLayer];
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(M_PI * 2);
    basicAnimation.duration = 0.5;
    basicAnimation.repeatCount = LONG_MAX;
    [self.loadingLayer addAnimation:basicAnimation forKey:nil];
    [self performSelector:@selector(complete) withObject:self afterDelay:2];
}

- (void)complete {
    [self.loadingLayer removeFromSuperlayer];
    if (self.block) {
        self.block();
    }
}

@end

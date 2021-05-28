//
//  LoginCustomTransition.m
//  FRAnimation
//
//  Created by Rui on 2016/12/29.
//  Copyright © 2016年 ryderfang. All rights reserved.
//

#import "LoginCustomTransition.h"

@interface LoginCustomTransition ()

@property (nonatomic, assign) MyTransitionType type;

@end

@implementation LoginCustomTransition

+ (instancetype)transitionWithTransitionType:(MyTransitionType)type {
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(MyTransitionType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UINavigationController *fromNavVC = ((UITabBarController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]).viewControllers[0];
    UINavigationController *toNavVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVC = fromNavVC.viewControllers.lastObject;
    UIButton *loginButton = fromVC.view.subviews.lastObject;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toNavVC.view];
    
    UIBezierPath *startCircle = [UIBezierPath bezierPathWithOvalInRect:loginButton.frame];
    CGFloat x = MAX(loginButton.frame.origin.x, containerView.frame.size.width - loginButton.frame.origin.x);
    CGFloat y = MAX(loginButton.frame.origin.y, containerView.frame.size.height - loginButton.frame.origin.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    UIBezierPath *endCircle = [UIBezierPath bezierPathWithArcCenter:containerView.center
                                                             radius:radius//CGRectGetHeight(containerView.bounds) / 2
                                                                                   startAngle:0
                                                                                   endAngle:M_PI * 2
                                                                                   clockwise:YES];
//    UIBezierPath *endCircle = [UIBezierPath bezierPathWithRect:containerView.bounds];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCircle.CGPath;
    // set mask
    toNavVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animation];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCircle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(endCircle.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromNavVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toNavVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *toVC = toNavVC.viewControllers.lastObject;
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view atIndex:0];
    
    CGFloat radius = sqrtf(pow(containerView.frame.size.height, 2) + pow(containerView.frame.size.height, 2)) / 2;
    
    UIBezierPath *startCircle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCircle = [UIBezierPath bezierPathWithOvalInRect:toVC.view.subviews.lastObject.frame];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCircle.CGPath;
    // set mask
    fromNavVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animation];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCircle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(endCircle.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.55;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_type == MyTransitionTypePresent) {
        [self presentAnimation:transitionContext];
    } else if (_type == MyTransitionTypeDismiss) {
        [self dismissAnimation:transitionContext];
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    if (_type == MyTransitionTypePresent) {
        [transitionContext completeTransition:YES];
        // to
        [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    } else if (_type == MyTransitionTypeDismiss) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        // from
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        }
    }
}

@end

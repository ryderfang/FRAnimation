//
//  ViewController.m
//  AnimationDemo
//
//  Created by Ray Fong on 16/12/5.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "ClockViewController.h"

@interface ClockViewController () <CALayerDelegate>

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) UIImageView *hourImage;
@property (nonatomic, strong) UIImageView *minutesImage;
@property (nonatomic, strong) UIImageView *secondsImage;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ClockViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];

    [self.shadowView addSubview:self.bgView];
    [self.view addSubview:self.shadowView];
    [self.view.layer addSublayer:self.circleLayer];
    [self performSelector:@selector(startAnimation) withObject:self afterDelay:0.5];
    
    [self.view addSubview:self.hourImage];
    [self.view addSubview:self.minutesImage];
    [self.view addSubview:self.secondsImage];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.and.height.equalTo(@300);
    }];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    
    [self.hourImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
    }];
    
    [self.minutesImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
    }];
    
    [self.secondsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
    }];
}

- (void)rotateHands {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hourAngle = (components.hour / 12.0) * M_PI * 2.0;
    CGFloat minAngle = (components.minute / 60.0) * M_PI * 2.0;
    CGFloat secAngle = (components.second / 60.0) * M_PI * 2.0;
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = [NSNumber numberWithFloat:hourAngle];
    basicAnimation.duration = 0.5;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.hourImage.layer addAnimation:basicAnimation forKey:nil];
    basicAnimation.toValue = [NSNumber numberWithFloat:minAngle];
    [self.minutesImage.layer addAnimation:basicAnimation forKey:nil];
    basicAnimation.toValue = [NSNumber numberWithFloat:secAngle];
    [self.secondsImage.layer addAnimation:basicAnimation forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hourImage.layer removeAllAnimations];
        [self.minutesImage.layer removeAllAnimations];
        [self.secondsImage.layer removeAllAnimations];
        [self.timer fire];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self rotateHands];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue = @1;
    opacityAnimation.duration = 0.3;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    [self.bgView.layer addAnimation:opacityAnimation forKey:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)startAnimation {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.toValue = @1;
    basicAnimation.duration = 1;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.circleLayer addAnimation:basicAnimation forKey:nil];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSetLineWidth(ctx, 3.f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)tick {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hourAngle = (components.hour / 12.0) * M_PI * 2.0;
    CGFloat minAngle = (components.minute / 60.0) * M_PI * 2.0;
    CGFloat secAngle = (components.second / 60.0) * M_PI * 2.0;
    
    self.hourImage.transform = CGAffineTransformMakeRotation(hourAngle);
    self.minutesImage.transform = CGAffineTransformMakeRotation(minAngle);
    self.secondsImage.transform = CGAffineTransformMakeRotation(secAngle);
}

- (NSTimer *)timer {
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        [_bgView setImage:[UIImage imageNamed:@"icon_balloon"]];
        _bgView.layer.cornerRadius = 150;
        // 这个会导致阴影也被干掉，所以必须在外面套一层view添加阴影
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.opacity = 0;
    }
    return _bgView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.layer.shadowColor = [UIColor blueColor].CGColor;
        _shadowView.layer.shadowOpacity = 0.5;
        _shadowView.layer.shadowOffset = CGSizeMake(5, 5);
        _shadowView.layer.shadowRadius = 3;
    }
    return _shadowView;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.strokeColor = [UIColor yellowColor].CGColor;
        _circleLayer.lineWidth = 5;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x, self.view.center.y) radius:150 startAngle:-M_PI / 2  endAngle:M_PI * 3 / 2 clockwise:YES].CGPath;
        _circleLayer.strokeEnd = 0;
    }
    return _circleLayer;
}

- (UIImageView *)hourImage {
    if (!_hourImage) {
        _hourImage = [[UIImageView alloc] init];
        _hourImage.image = [UIImage imageNamed:@"hour"];
    }
    return _hourImage;
}

- (UIImageView *)minutesImage {
    if (!_minutesImage) {
        _minutesImage = [[UIImageView alloc] init];
        _minutesImage.image = [UIImage imageNamed:@"minute"];
    }
    return _minutesImage;
}

- (UIImageView *)secondsImage {
    if (!_secondsImage) {
        _secondsImage = [[UIImageView alloc] init];
        _secondsImage.image = [UIImage imageNamed:@"second"];
    }
    return _secondsImage;
}

@end

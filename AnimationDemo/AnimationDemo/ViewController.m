//
//  ViewController.m
//  AnimationDemo
//
//  Created by Ray Fong on 16/12/5.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController () <CALayerDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *hourImage;
@property (nonatomic, strong) UIImageView *minutesImage;
@property (nonatomic, strong) UIImageView *secondsImage;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    CALayer *blueLayer = self.bgView.layer;
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    UIImage *image = [UIImage imageNamed:@"icon_balloon"];
    blueLayer.contents = (__bridge id)image.CGImage;
    blueLayer.contentsGravity = kCAGravityResizeAspect;
    blueLayer.contentsScale = image.scale;
    blueLayer.cornerRadius = 150;
    blueLayer.masksToBounds = YES;

    [self.view addSubview:self.hourImage];
    [self.view addSubview:self.minutesImage];
    [self.view addSubview:self.secondsImage];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.and.height.equalTo(@300);
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self tick];
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

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor yellowColor];
    }
    return _bgView;
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

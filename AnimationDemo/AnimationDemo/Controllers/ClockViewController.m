//
//  ViewController.m
//  AnimationDemo
//
//  Created by Ray Fong on 16/12/5.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "ClockViewController.h"
#import "Masonry.h"

@interface ClockViewController () <CALayerDelegate>

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *hourImage;
@property (nonatomic, strong) UIImageView *minutesImage;
@property (nonatomic, strong) UIImageView *secondsImage;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ClockViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.shadowView = [[UIView alloc] init];
    // shadow
    self.shadowView.layer.shadowColor = [UIColor blueColor].CGColor;
    self.shadowView.layer.shadowOpacity = 0.4;
    self.shadowView.layer.shadowOffset = CGSizeMake(3, 3);
    self.shadowView.layer.shadowRadius = 3;
    [self.shadowView addSubview:self.bgView];
    [self.view addSubview:self.shadowView];
    
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

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        [_bgView setImage:[UIImage imageNamed:@"icon_balloon"]];
        _bgView.layer.cornerRadius = 150;
        // 这个会导致阴影也被干掉，所以必须在外面套一层view添加阴影
        _bgView.layer.masksToBounds = YES;
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

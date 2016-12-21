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
//    blueLayer.masksToBounds = YES;
//    blueLayer.contentsRect = CGRectMake(0.5, 0, 0.5, 0.5);
//    blueLayer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
//    blueLayer.delegate = self;
//    [blueLayer display];
    blueLayer.anchorPoint = CGPointMake(1, 1);
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.and.height.equalTo(@300);
    }];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSetLineWidth(ctx, 3.f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor yellowColor];
    }
    return _bgView;
}

@end

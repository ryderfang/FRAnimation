//
//  LottieViewController.m
//  AnimationDemo
//
//  Created by YiMu on 2017/11/7.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

#import "LottieViewController.h"
#import <Lottie/Lottie.h>

@interface LottieViewController () {
    CGFloat _yOffset;
}

@end

@implementation LottieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _yOffset = 0;
    
    [self addAnimationView:@"bell"];
    [self addAnimationView:@"gears"];
    [self addAnimationView:@"birth"];
}

- (void)addAnimationView:(NSString *)jsonName {
    LOTAnimationView *animation = [LOTAnimationView animationNamed:jsonName];
    animation.loopAnimation = YES;
    animation.frame = CGRectMake(animation.frame.origin.x, _yOffset, CGRectGetWidth(animation.frame), CGRectGetHeight(animation.frame));
    [self.view addSubview:animation];
    [animation playWithCompletion:^(BOOL animationFinished) {
        // Do Something
    }];
    _yOffset += CGRectGetHeight(animation.frame) + 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

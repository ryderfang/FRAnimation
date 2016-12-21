//
//  ViewController.m
//  AnimationDemo
//
//  Created by Ray Fong on 16/12/5.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.and.height.equalTo(@300);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor yellowColor];
    }
    return _bgView;
}

@end

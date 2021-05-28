//
//  UITestViewController.m
//  FRAnimation
//
//  Created by Rui on 2021/5/28.
//  Copyright © 2021 ryderfang. All rights reserved.
//

#import "UITestViewController.h"
#import "RRSlider.h"

@interface UITestViewController ()

@property (nonatomic, strong) RRSlider *slider;

@end

@implementation UITestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UI 测试";
    
    [self buildUI];
}

- (void)buildUI {
    self.slider = [[RRSlider alloc] initWithFrame:CGRectMake(40, 200, self.view.width - 40 * 2, 20)];
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 1.0;
    self.slider.defaultValue = 0.3;
    [self.view addSubview:self.slider];
}

@end

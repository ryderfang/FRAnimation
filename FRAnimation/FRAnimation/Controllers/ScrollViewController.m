//
//  ScrollViewController.m
//  FRAnimation
//
//  Created by YiMu on 2018/5/16.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "ScrollViewController.h"
#import "AMOrderContainerView.h"

@interface ScrollViewController ()

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, FR_NavStatusHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - FR_NavStatusHeight);
    AMOrderContainerView *container = [[AMOrderContainerView alloc] initWithFrame:frame ItemCount:6];
    [self.view addSubview:container];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


@end

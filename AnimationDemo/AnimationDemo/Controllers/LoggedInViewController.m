//
//  LoggedInViewController.m
//  AnimationDemo
//
//  Created by Ray Fong on 2016/12/29.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "LoggedInViewController.h"
#import "LoginCustomTransition.h"

@interface LoggedInViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation LoggedInViewController

- (instancetype)init {
    if (self = [super init]) {
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next_bg.jpg"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    // * important *
    bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pop:)];
    [bgView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [LoginCustomTransition transitionWithTransitionType:MyTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [LoginCustomTransition transitionWithTransitionType:MyTransitionTypeDismiss];
}


- (void)pop:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

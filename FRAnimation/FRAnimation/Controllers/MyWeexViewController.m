//
//  MyWeexViewController.m
//  FRAnimation
//
//  Created by YiMu on 2018/8/9.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "MyWeexViewController.h"
#import <WeexSDK/WXSDKInstance.h>

@interface MyWeexViewController ()

@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) WXSDKInstance *instance;

@end

@implementation MyWeexViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    
    self.instance.onFailed = ^(NSError *error) {
        NSLog(@"$Weex$ render failed.");
    };
    
    self.instance.renderFinish = ^(UIView *v) {
        //
    };
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"fuck_weex" withExtension:@"js"];
    [self.instance renderWithURL:url options:@{@"bundleUrl": [url absoluteString]} data:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WXSDKInstance *)instance {
    if (!_instance) {
        _instance = [[WXSDKInstance alloc] init];
        _instance.viewController = self;
        _instance.frame = self.view.frame;
    }
    return _instance;
}

@end

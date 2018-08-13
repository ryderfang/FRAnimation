//
//  MyWeexViewController.m
//  FRAnimation
//
//  Created by YiMu on 2018/8/9.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "MyWeexViewController.h"
#import <WeexSDK/WXSDKInstance.h>
#import <SocketRocket/SRWebSocket.h>
#import "WXDevTool.h"

@interface MyWeexViewController () <SRWebSocketDelegate>

@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) WXSDKInstance *instance;

@end

@implementation MyWeexViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(render) name:@"RefreshInstance" object:nil];
    [self render];
}

- (void)render {
    [self.instance destroyInstance];
    self.instance = [[WXSDKInstance alloc] init];
    self.instance.viewController = self;
    self.instance.frame = self.view.frame;
    
    __weak typeof(self) weakSelf = self;
    self.instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf.weexView);
    };
    
    self.instance.onFailed = ^(NSError *error) {
        NSLog(@"$Weex$ render failed.");
    };
    
    self.instance.renderFinish = ^(UIView *v) {
        //
    };
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"fuck_weex" withExtension:@"js"];
    NSURL *url = [NSURL URLWithString:@"http://30.17.104.85:8088/weex/fuck_weex.js"];
    [self.instance renderWithURL:url options:@{@"bundleUrl": [url absoluteString]} data:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"] style:UIBarButtonItemStylePlain target:self action:@selector(render)];
    refreshButtonItem.accessibilityHint = @"click to reload curent page";
    self.navigationItem.rightBarButtonItem = refreshButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.instance destroyInstance];
}

#pragma mark - Socket
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if ([message isEqualToString:@"refresh"]) {
        [self render];
    }
}

@end

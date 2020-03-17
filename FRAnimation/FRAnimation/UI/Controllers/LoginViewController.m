//
//  LoginViewController.m
//  FRAnimation
//
//  Created by Ray Fong on 2016/12/26.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "LoginViewController.h"
#import "LoggedInViewController.h"
#import "FRTextField.h"
#import "FRLoginButton.h"
#import "UIColor+Hex.h"

@interface LoginViewController ()

@property (nonatomic, strong) FRLoginButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view.layer addSublayer:[self backgroundLayer]];
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.loginButton show];
}

- (void)buildUI {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    titleLabel.center = CGPointMake(self.view.center.x, 150);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"LOGIN";
    titleLabel.font = [UIFont boldSystemFontOfSize:40.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    detailLabel.center = CGPointMake(self.view.center.x, 100);
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.text = @"Don't have an account yes? Sign Up";
    detailLabel.font = [UIFont systemFontOfSize:13.f];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:detailLabel];
    
    FRTextField *userName = [[FRTextField alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
    userName.center = CGPointMake(self.view.center.x, 350);
    userName.placeholderLabel.text = @"UserName";
    [self.view addSubview:userName];
    
    FRTextField *passWord = [[FRTextField alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
    passWord.center = CGPointMake(self.view.center.x, userName.center.y + 60);
    passWord.placeholderLabel.text = @"Password";
    [self.view addSubview:passWord];
    
    _loginButton = [[FRLoginButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    _loginButton.center = CGPointMake(self.view.center.x, passWord.center.y + 100);
    __weak __typeof(self) weakSelf = self;
    _loginButton.block = ^{
        __strong __typeof(self) strongSelf = weakSelf;
        LoggedInViewController *nextVC = [[LoggedInViewController alloc] init];
        [strongSelf presentViewController:nextVC animated:YES completion:nil];
    };
    [self.view addSubview:_loginButton];
}

- (CAGradientLayer *)backgroundLayer {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.view.bounds;
    layer.colors = @[(__bridge id)[UIColor colorWithHex:0x87bef1].CGColor,
                     (__bridge id)[UIColor colorWithHex:0xe9dcb7].CGColor,
                     (__bridge id)[UIColor colorWithHex:0xeaa1c8].CGColor];
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.locations = @[@0.25, @0.75];
    return layer;
}

@end

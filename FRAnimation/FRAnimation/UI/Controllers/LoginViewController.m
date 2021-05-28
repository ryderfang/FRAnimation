//
//  LoginViewController.m
//  FRAnimation
//
//  Created by Rui on 2016/12/26.
//  Copyright © 2016年 ryderfang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoggedInViewController.h"
#import "FRTextField.h"
#import "FRLoginButton.h"
#import "UIColor+Hex.h"
#import "FRBubbleView.h"

@interface LoginViewController ()

@property (nonatomic, strong) FRLoginButton *loginButton;
@property (nonatomic, strong) FRBubbleView *bubbleView;

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
    
    self.bubbleView.left = self.loginButton.left + (self.loginButton.width - self.bubbleView.width) / 2;
    self.bubbleView.bottom = self.loginButton.top;
    [FRBubbleView showBubble:self.bubbleView inView:self.view fullScreenMask:YES];
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

- (FRBubbleView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [[FRBubbleView alloc] initWithFrame:CGRectMake(0, 0, 152, 76)];
        _bubbleView.imageView.image = [UIImage imageNamed:@"qipao1.png"];
        _bubbleView.labelInset = UIEdgeInsetsMake(0, 16, 0, 16);
        // Label
        NSString *labelString = @"这是一个气泡\n点了也没有反应";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:labelString];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;
        [attrStr addAttributes:@{ NSParagraphStyleAttributeName : paragraphStyle } range:NSMakeRange(0, labelString.length)];
        _bubbleView.labelTip.attributedText = attrStr;
        _bubbleView.labelTip.font = [UIFont systemFontOfSize:14];
        _bubbleView.labelTip.textColor = [UIColor blackColor];
        _bubbleView.labelTip.numberOfLines = 2;
        _bubbleView.labelTip.textAlignment = NSTextAlignmentLeft;
    }
    return _bubbleView;
}

@end

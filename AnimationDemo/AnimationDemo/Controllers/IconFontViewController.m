//
//  IconFontViewController.m
//  AnimationDemo
//
//  Created by Ray Fong on 2017/6/15.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

#import "IconFontViewController.h"
#import "UILabel+BiliIconFont.h"
#import "UIImage+BiliIconFont.h"
#import "UIImageView+BiliIconFont.h"
#import "UIButton+BiliIconFont.h"

@interface IconFontViewController ()

@property (nonatomic, strong) UILabel *emojiLabel;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UILabel *iconWithTextLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *iconButtonUp;
@property (nonatomic, strong) UIButton *iconButtonDown;

@end

@implementation IconFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.emojiLabel];
    [self.emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.view).offset(80);
        make.height.equalTo(@40);
    }];

    [self.view addSubview:self.iconLabel];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emojiLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.width.and.height.equalTo(@20);
    }];

    [self.view addSubview:self.iconWithTextLabel];
    [self.iconWithTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@20);
    }];

    [self.view addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconWithTextLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.width.and.height.equalTo(@60);
    }];

    [self.view addSubview:self.iconButtonUp];
    [self.iconButtonUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_centerX).offset(-20);
        make.width.and.height.equalTo(@30);
    }];
    [self.view addSubview:self.iconButtonDown];
    [self.iconButtonDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconButtonUp);
        make.left.equalTo(self.view.mas_centerX).offset(20);
        make.width.and.height.equalTo(@30);
    }];
}

- (void)buttonClicked:(UIButton *)btn {
    if (btn == self.iconButtonUp) {
        CGRect frame = self.iconImageView.frame;
        frame.size.width += 2;
        frame.size.height += 2;
        self.iconImageView.frame = frame;
    } else if (btn == self.iconButtonDown) {
        CGRect frame = self.iconImageView.frame;
        frame.size.width -= 2;
        frame.size.height -= 2;
        self.iconImageView.frame = frame;
    }
}

- (UILabel *)emojiLabel {
    if (!_emojiLabel) {
        _emojiLabel = [[UILabel alloc] init];
        _emojiLabel.layer.borderColor = [UIColor redColor].CGColor;
        _emojiLabel.layer.borderWidth = 0.5;
        _emojiLabel.layer.cornerRadius = 4;
        _emojiLabel.layer.masksToBounds= YES;
        _emojiLabel.textAlignment = NSTextAlignmentCenter;
        _emojiLabel.font = [BiliIconFont fontWithSize:28];
//        _emojiLabel.font = [UIFont fontWithName:@"fontello" size:16];
        _emojiLabel.textColor = [UIColor blueColor];
        _emojiLabel.text = [NSString stringWithUTF8String:"\ue65e"];// @"\U0000e801\U0000e802\U0000e803\U0000e804\U0000e805\U0000e809\U0000F182";
    }
    return _emojiLabel;
}

- (UILabel *)iconLabel {
    if (!_iconLabel) {
        _iconLabel = [UILabel labelWithIconInfo:Bili_Icon_Female];
        _iconLabel.layer.borderColor = [UIColor redColor].CGColor;
        _iconLabel.layer.borderWidth = 0.5;
    }
    return _iconLabel;
}

- (UILabel *)iconWithTextLabel {
    if (!_iconWithTextLabel) {
        _iconWithTextLabel = [[UILabel alloc] init];
        _iconWithTextLabel.layer.borderColor = [UIColor redColor].CGColor;
        _iconWithTextLabel.layer.borderWidth = 0.5;

        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageWithIconInfo:Bili_Icon_Unknown_Gender]];
        [_iconWithTextLabel addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.equalTo(_iconWithTextLabel);
            make.width.equalTo(@20);
        }];
        UILabel *textLabel = [[UILabel alloc] init];
        [_iconWithTextLabel addSubview:textLabel];
        textLabel.text = @"这是一行文字，显示在图标后面";
        textLabel.font = [UIFont systemFontOfSize:14];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(10);
            make.top.and.bottom.and.right.equalTo(_iconWithTextLabel);
        }];
    }
    return _iconWithTextLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView imageViewWithIconInfo:Bili_Icon_Tab_Home];
    }
    return _iconImageView;
}

- (UIButton *)iconButtonUp {
    if (!_iconButtonUp) {
        _iconButtonUp = [UIButton buttonWithIconInfo:Bili_Icon_Tab_Home_S];
        [_iconButtonUp addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconButtonUp;
}

- (UIButton *)iconButtonDown {
    if (!_iconButtonDown) {
        _iconButtonDown = [UIButton buttonWithIconInfo:Bili_Icon_Tab_Home_S];
        [_iconButtonDown addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconButtonDown;
}
@end

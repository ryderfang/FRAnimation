//
//  FRTextField.m
//  AnimationDemo
//
//  Created by Ray Fong on 2016/12/26.
//  Copyright © 2016年 Ray Fong. All rights reserved.
//

#import "FRTextField.h"

@interface FRTextField () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) CALayer *lineLayer;

@property (nonatomic, assign) BOOL moved;

@end

@implementation FRTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textField];
        [self addSubview:self.placeholderLabel];
        [self addSubview:self.lineView];
        [self.lineView.layer addSublayer:self.lineLayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self.textField];
        self.moved = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _placeholderLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - 1, 1);
}

- (void)textChanged:(NSNotification *)notification {
    CGPoint placeholderCenter = _placeholderLabel.center;
    if (_textField.text.length > 0 && !_moved) {
        [self moveAnimation:placeholderCenter];
    } else if (_textField.text.length == 0 && _moved) {
        [self backAnimation:placeholderCenter];
    }
}

- (void)moveAnimation:(CGPoint)p {
    __block CGPoint point = p;
    _placeholderLabel.font = [UIFont systemFontOfSize:10];
    _placeholderLabel.textColor = [UIColor darkGrayColor];
    [UIView animateWithDuration:0.15 animations:^{
        point.x -= 5;
        point.y -= _placeholderLabel.frame.size.height / 2 + 2;
        _placeholderLabel.center = point;
        _moved = YES;
        _lineLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
    }];
}

- (void)backAnimation:(CGPoint)p {
    __block CGPoint point = p;
    _placeholderLabel.font = [UIFont systemFontOfSize:13];
    _placeholderLabel.textColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.15 animations:^{
        point.x += 5;
        point.y += _placeholderLabel.frame.size.height / 2 + 2;
        _placeholderLabel.center = point;
        _moved = NO;
        _lineLayer.bounds = CGRectMake(0, 0, 0, 1);
    }];
}

#pragma mark - lazy init
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = [UIColor whiteColor];
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
    }
    return _textField;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _placeholderLabel.font = [UIFont systemFontOfSize:13];
        _placeholderLabel.textColor = [UIColor whiteColor];
        _placeholderLabel.alpha = 1;
    }
    return _placeholderLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.frame = CGRectMake(0, 0, 0, 1);
        _lineLayer.anchorPoint = CGPointMake(0, 0.5);
        _lineLayer.backgroundColor =[UIColor whiteColor].CGColor;
    }
    return _lineLayer;
}

@end

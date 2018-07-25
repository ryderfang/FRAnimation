//
//  LottieViewController.m
//  FRAnimation
//
//  Created by YiMu on 2017/11/7.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

#import "LottieViewController.h"
#import <Lottie/Lottie.h>
#import "UIImage+Color.h"

@interface MyButton : UIButton

@end

@implementation MyButton

- (NSAttributedString *)normalAttrStr {
    NSString *text = @"按住说出单个菜品名和价格(元)";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, text.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10, 5)];
    return [[NSAttributedString alloc] initWithAttributedString:attrStr];
}

- (NSAttributedString *)highlightAttrStr {
    return [[NSAttributedString alloc] initWithString:@"松开录入，上滑取消"];
}

- (void)setup {
    [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal | UIControlStateHighlighted)];
    [self setAttributedTitle:[self normalAttrStr] forState:UIControlStateNormal];
    [self setAttributedTitle:[self highlightAttrStr] forState:UIControlStateHighlighted];
    
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.bounds.size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor] size:self.bounds.size] forState:UIControlStateHighlighted];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setHighlighted:YES];
    NSLog(@"$ASRView$ Begin: %zd", self.state);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"$ASRView$ Moved: %zd", self.state);
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"$ASRView$ touchesMoved: (%f, %f)", point.x, point.y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setHighlighted:NO];
    
    NSLog(@"$ASRView$ Ended: %zd", self.state);
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"$ASRView$ touchesEnded: (%f, %f)", point.x, point.y);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setHighlighted:NO];
    NSLog(@"$ASRView$ touchCancelled");
}

@end

@interface LottieViewController () {
    CGFloat _yOffset;
}

@property (nonatomic, strong) MyButton *myButton;

@end

@implementation LottieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _yOffset = 0;
    
    [self addAnimationView:@"bell"];
    [self addAnimationView:@"gears"];
    [self addAnimationView:@"birth"];
    
    [self.view addSubview:self.myButton];
}

- (MyButton *)myButton {
    if (!_myButton) {
        _myButton = [[MyButton alloc] initWithFrame:CGRectMake(20, 380, FR_SCREEN_WIDTH - 20 * 2, 60 - 2 * 8)];
//        _myButton = [MyButton buttonWithType:UIButtonTypeCustom];
//        _myButton.frame = CGRectMake(150, 400, 200, 30);
        _myButton.layer.borderWidth = 0.5;
        _myButton.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
        [_myButton setup];
    }
    return _myButton;
}

- (void)addAnimationView:(NSString *)jsonName {
    LOTAnimationView *animation = [LOTAnimationView animationNamed:jsonName];
    animation.loopAnimation = YES;
    animation.frame = CGRectMake(animation.frame.origin.x, _yOffset, CGRectGetWidth(animation.frame), CGRectGetHeight(animation.frame));
    [self.view addSubview:animation];
    [animation playWithCompletion:^(BOOL animationFinished) {
        // Do Something
    }];
    _yOffset += CGRectGetHeight(animation.frame) + 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  UITestViewController.m
//  FRAnimation
//
//  Created by Rui on 2021/5/28.
//  Copyright © 2021 ryderfang. All rights reserved.
//

#import "UITestViewController.h"
#import "RRSlider.h"
#import "UIImage+Ext.h"

@interface RRHitOutsideView : UIView



@end

@implementation RRHitOutsideView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {
        if (CGRectContainsPoint(subview.frame, point)) {
            return subview;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end

@interface UITestViewController ()

//@property (nonatomic, strong) RRSlider *slider;
@property (nonatomic, strong) UIButton *open;
@property (nonatomic, strong) RRHitOutsideView *panel;
@property (nonatomic, strong) UIButton *fav;

@end

@implementation UITestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UI 测试";
    
    [self buildUI];
}

- (void)buildUI {
//    self.slider = [[RRSlider alloc] initWithFrame:CGRectMake(40, 200, self.view.width - 40 * 2, 28)];
//    self.slider.minimumValue = -1.0;
//    self.slider.maximumValue = 1.0;
//    self.slider.enableBiDirection = YES;
//    self.slider.defaultValue = 0;
//    [self.view addSubview:self.slider];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"mikasa.png"];
    bgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bgView];
    
    self.open = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 80 - 12, 200, 80, 30)];
    [self.open setTitle:@"OPEN" forState:UIControlStateNormal];
    [self.open setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.open setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
    [self.open.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold]];
    [self.open.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.open addTarget:self action:@selector(openPanel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.open];

    self.panel = [[RRHitOutsideView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 400)];
    self.panel.backgroundColor = HEXCOLORA(0x1A1A1A, 0.7);
    [self.view addSubview:self.panel];
    
    self.fav = [[UIButton alloc] initWithFrame:CGRectMake(16, -(10+28), 70, 28)];
    [self.fav setTitle:@"收藏" forState:UIControlStateNormal];
    [self.fav setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.fav.titleLabel.font = [UIFont systemFontOfSize:14];
    UIImage *iconNorml = [UIImage imageNamed:@"fav_normal.png"];
    iconNorml = [UIImage resizeImage:iconNorml withNewSize:CGSizeMake(16, 16) scale:0];
    [self.fav setImage:iconNorml forState:UIControlStateNormal];
    [self.fav setTitle:@"已收藏" forState:UIControlStateSelected];
    UIImage *iconSelected = [UIImage imageNamed:@"fav_selected.png"];
    iconSelected = [UIImage resizeImage:iconSelected withNewSize:CGSizeMake(16, 16) scale:0];
    [self.fav setImage:iconSelected forState:UIControlStateSelected];
    [self.fav.titleLabel sizeToFit];
    self.fav.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.fav.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.fav.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fav.imageEdgeInsets = UIEdgeInsetsMake(6, 10, 6, -10);
    self.fav.titleEdgeInsets = UIEdgeInsetsMake(4, 14, 4, -14);
    [self.fav setBackgroundColor:HEXCOLORA(0x2F2F2F, 0.8)];
    self.fav.layer.masksToBounds = YES;
    self.fav.layer.cornerRadius = 14;
    self.fav.hidden = YES;
    [self.fav addTarget:self action:@selector(addFav) forControlEvents:UIControlEventTouchUpInside];

    [self.panel addSubview:self.fav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)openPanel {
    self.open.selected = !self.open.selected;
    if (self.open.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.panel.top = self.view.height - 400;
        } completion:^(BOOL finished) {
            self.fav.hidden = NO;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.panel.top = self.view.height;
        } completion:^(BOOL finished) {
            self.fav.hidden = YES;
        }];
    }
}

- (void)addFav {
    self.fav.selected = !self.fav.selected;
    self.fav.width = self.fav.selected ? 84 : 70;
}

@end

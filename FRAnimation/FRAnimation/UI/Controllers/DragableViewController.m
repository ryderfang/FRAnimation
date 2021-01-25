//
//  DragableViewController.m
//  FRAnimation
//
//  Created by YiMu on 2018/9/21.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "DragableViewController.h"
#import "DragView.h"
#import "QQHotPicSwitchBar.h"

#define color1 HEXCOLOR(0xEFF9FF)
#define color2 HEXCOLOR(0xF6FCF2)
#define color_line HEXCOLOR(0xFF6524)

@interface DragableViewController ()

@property (nonatomic, strong) DragView *firstLine;
@property (nonatomic, strong) CALayer *afterLayer;
@property (nonatomic, strong) QQHotPicSwitchBar *switchBar;

@end

@implementation DragableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;

    self.afterLayer = [[CALayer alloc] init];
    self.afterLayer.bounds = CGRectMake(0, 0, width, height / 2);
    self.afterLayer.position = CGPointMake(width / 2, height * 3 / 4);
    self.afterLayer.backgroundColor = color2.CGColor;
    
    [self.view.layer addSublayer:self.afterLayer];
    
    self.firstLine = [[DragView alloc] initWithFrame:CGRectMake(0, height / 2, width, 1)];
    self.firstLine.backgroundColor = color_line;
    [self.view addSubview:self.firstLine];
    
    [self.firstLine addObserver:self forKeyPath:@"center" options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld) context:nil];

    [self.view addSubview:self.switchBar];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", change);
}

- (QQHotPicSwitchBar *)switchBar {
    if (!_switchBar) {
        _switchBar = [[QQHotPicSwitchBar alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 37)];
    }
    return _switchBar;
}

@end


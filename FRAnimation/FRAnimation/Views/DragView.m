//
//  DragView.m
//  FRAnimation
//
//  Created by YiMu on 2018/9/21.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "DragView.h"

@interface DragView ()

@property (nonatomic, strong) UIView *tapView;

@end

@implementation DragView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tapView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 20,
                                                                frame.size.height - 10,
                                                                20, 20)];
        self.tapView.backgroundColor = [UIColor redColor];
        [self addSubview:self.tapView];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint curPt = [touch locationInView:self];
    CGPoint prePt = [touch previousLocationInView:self];
//    NSLog(@"current Point - %@", NSStringFromCGPoint(curPt));
//    NSLog(@"prevous Point - %@", NSStringFromCGPoint(prePt));
    
    CGFloat offsetY = curPt.y - prePt.y;
    
    self.transform = CGAffineTransformTranslate(self.transform, 0, offsetY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -1, -10);
    return CGRectContainsPoint(bounds, point);
}

@end

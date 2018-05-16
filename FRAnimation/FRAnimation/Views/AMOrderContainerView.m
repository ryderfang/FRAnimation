//
//  AMOrderContainerView.m
//  FRAnimation
//
//  Created by YiMu on 2018/5/16.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "AMOrderContainerView.h"
#import "AMOrderItemView.h"
#import "UIDefs.h"

// 卡片间距
const CGFloat kMargin = 12.f;
// 露出的下一张卡片宽度
const CGFloat kOffset = 36.f;

const CGFloat kTop = 24.f;

@interface AMOrderContainerView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *container;
@property (nonatomic, assign) CGFloat cardWidth;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation AMOrderContainerView

- (instancetype)initWithFrame:(CGRect)frame ItemCount:(NSUInteger)count {
    if (self = [super initWithFrame:frame]) {
        self.cardWidth = CGRectGetWidth(self.bounds) - 2 * kMargin  - kOffset;
        self.count = count;
        [self addSubview:self.container];
        [self addGestureRecognizer:self.container.panGestureRecognizer];
        self.container.delegate = self;
        for (int i = 0; i < count; i++) {
            [self.container addSubview:[self generateView:i]];
        }
        self.container.contentSize = CGSizeMake((self.cardWidth + kMargin) * count + kMargin, 0);
    }
    return self;
}

- (AMOrderItemView *)generateView:(NSUInteger)index {
    CGFloat h = CGRectGetHeight(self.bounds) -  2 * kTop;
    CGFloat x = kMargin + (self.cardWidth + kMargin) * index;
    CGFloat y = kTop;
    AMOrderItemView *v = [[AMOrderItemView alloc] initWithFrame:CGRectMake(x, y, self.cardWidth, h) Index:index];
    return v;
}


- (UIScrollView *)container {
    if (!_container) {
        CGRect newFrame = self.bounds;
        newFrame.size.width = self.cardWidth + kMargin;
        _container = [[UIScrollView alloc] initWithFrame:newFrame];
//        if (@available(iOS 11.0, *)) {
//            _container.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            // Fallback on earlier versions
//        }
        self.backgroundColor = [UIColor clearColor];
        _container.layer.borderColor = [UIColor yellowColor].CGColor;
        _container.layer.cornerRadius = 10.f;
        _container.layer.masksToBounds = YES;
        _container.layer.borderWidth = 5.0f;
//        _container.pagingEnabled = YES;
        _container.clipsToBounds = NO;
    }
    return _container;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSLog(@"scrollViewDidScroll:: %f", offset);
//    NSUInteger index = floorf((offset + self.cardWidth / 2 - kMargin) / self.cardWidth);
//    [scrollView setContentOffset:CGPointMake(kMargin + (self.cardWidth + kMargin) * index, 0)];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"scrollViewWillEndDragging: start:: %f", targetContentOffset->x);
    CGFloat offset = (self.cardWidth + kMargin) * (self.count - 1);
    NSLog(@"scrollViewWillEndDragging: shit:: %f", offset);
    if (fabs(targetContentOffset->x - offset) < FLT_EPSILON) {
        targetContentOffset->x = scrollView.contentSize.width - CGRectGetWidth(self.bounds);
    } else {
        
    }
    NSLog(@"scrollViewWillEndDragging: end:: %f", targetContentOffset->x);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSLog(@"scrollViewDidEndDecelerating:: %f", offset);
    NSUInteger index = floor(offset / (self.cardWidth + kMargin));
    NSLog(@"scrollViewDidEndDecelerating:: index:: %lu", (unsigned long)index);
    // 倒数第二页
    if (index >= self.count - 2) {
//        CGRect newFrame = self.bounds;
//        newFrame.size.width = self.cardWidth + kMargin - kOffset;
//        scrollView.frame = newFrame;
    } else {
//        CGRect newFrame = self.bounds;
//        newFrame.size.width = self.cardWidth + kMargin;
//        scrollView.frame = newFrame;
    }
}

@end

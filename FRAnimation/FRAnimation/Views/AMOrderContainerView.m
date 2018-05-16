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
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) CGFloat pageSize;

@end

@implementation AMOrderContainerView

- (instancetype)initWithFrame:(CGRect)frame ItemCount:(NSInteger)count {
    if (self = [super initWithFrame:frame]) {
        self.cardWidth = CGRectGetWidth(self.bounds) - 2 * kMargin  - kOffset;
        self.numberOfPages = count;
        self.currentPage = 0;
        self.pageSize = self.cardWidth + kMargin;
        [self addSubview:self.container];
        self.container.delegate = self;
        for (int i = 0; i < count; i++) {
            [self.container addSubview:[self generateView:i]];
        }
        self.container.contentSize = CGSizeMake(self.numberOfPages * self.pageSize + kMargin, 0);
    }
    return self;
}

- (AMOrderItemView *)generateView:(NSInteger)index {
    CGFloat h = CGRectGetHeight(self.bounds) -  2 * kTop;
    CGFloat x = kMargin + self.pageSize * index;
    CGFloat y = kTop;
    AMOrderItemView *v = [[AMOrderItemView alloc] initWithFrame:CGRectMake(x, y, self.cardWidth, h) Index:index];
    return v;
}


- (UIScrollView *)container {
    if (!_container) {
        _container = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.backgroundColor = [UIColor clearColor];
        _container.layer.borderColor = [UIColor yellowColor].CGColor;
        _container.layer.cornerRadius = 10.f;
        _container.layer.masksToBounds = YES;
        _container.layer.borderWidth = 5.0f;
        _container.showsVerticalScrollIndicator = NO;
        //_container.bounces = NO;
    }
    return _container;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSLog(@"scrollViewDidScroll:: %f", offset);
    CGFloat moveX = offset - [self pageOffset];
    if (fabs(moveX) >= self.pageSize) {

    }
}

- (CGFloat)pageOffset {
    if (self.currentPage < self.numberOfPages - 1) {
        return self.pageSize * self.currentPage;
    } else {
        return self.pageSize * self.currentPage - kOffset;
    }
}

- (CGFloat)targetOffsetForMoveX:(CGFloat)moveX velocity:(CGFloat)velocity {
    BOOL complete = (fabs(moveX) >= self.cardWidth * 0.5) ||
                     (fabs(velocity) > 0 && fabs(moveX) >= self.cardWidth * 0.1);
    BOOL isMoveRight = moveX > 0;
    if (complete) {
        if (isMoveRight) {
            self.currentPage = MIN(self.currentPage + 1, self.numberOfPages - 1);
        } else {
            self.currentPage = MAX(0, self.currentPage - 1);
        }
    } else {
        // cancel
    }
    return [self pageOffset];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat moveX = scrollView.contentOffset.x - self.pageOffset;
    NSLog(@"scrollViewWillEndDragging: moveX:: %f", moveX);
    CGFloat targetX = [self targetOffsetForMoveX:moveX velocity:velocity.x];
    if (targetX == self.pageOffset) {
        // cancel
        targetContentOffset->x = scrollView.contentOffset.x;
        [scrollView setContentOffset:CGPointMake(targetX, targetContentOffset->y) animated:YES];
    } else {
        targetContentOffset->x = targetX;
    }
    NSLog(@"scrollViewWillEndDragging: end:: %f", targetContentOffset->x);
}

@end

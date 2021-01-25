//
//  QQDouTuHeaderView.m
//  FRAnimation
//
//  Created by Ryder Fang on 2020/2/25.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import "QQDouTuHeaderView.h"
#import "QQDouTuModel.h"

const CGFloat kDouTuHeaderMinHeight = 113.0;
const CGFloat kDouTuHeaderMaxHeight = 137.0;

@interface QQDouTuFaceImageView : UIView

@property (nonatomic, strong) QQDouTuFaceModel *model;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation QQDouTuFaceImageView

- (instancetype)initWithFrame:(CGRect)frame model:(QQDouTuFaceModel *)model  {
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 4, 4)];
        self.imageView.image = model.faceImage;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.layer.borderWidth = (selected ? 2 : 0);
    self.layer.borderColor = HEXCOLOR(0x00CAFC).CGColor;
}

@end

@interface QQDouTuHeaderView ()

@property (nonatomic, strong) UIImageView *addFaceImageView;
@property (nonatomic, strong) UILabel *chooseExpressionLabel;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UIScrollView *faceScrollView;
@property (nonatomic, strong) QQDouTuFaceImageView *lastSelectedFace;
// 逆序存放，后进的在前面展示
@property (nonatomic, strong) NSMutableArray *faceImageViews;

@end

@implementation QQDouTuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.faceImageViews = [NSMutableArray array];
        [self buildUI];

        QQDouTuFaceModel *noFaceModel = [[QQDouTuFaceModel alloc] init];
        noFaceModel.faceId = kNoFaceId;
        noFaceModel.faceImage = [UIImage imageNamed:@"qqdoutu_noface.png"];
        [self addFaceModel:noFaceModel selected:YES];
    }
    return self;
}

- (void)buildUI {
    UILabel *chooseFaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 100, 16.5)];
    chooseFaceLabel.text = @"选择脸部";
    chooseFaceLabel.textColor = HEXCOLOR(0x878B99);
    chooseFaceLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:chooseFaceLabel];

    [self addSubview:self.addFaceImageView];

    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(self.addFaceImageView.right + 12.5, 37 + (self.addFaceImageView.height - 14) / 2, 0.5, 14)];
    sepLine.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self addSubview:sepLine];
    self.sepLine = sepLine;

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.faceScrollView = scrollView;

    UILabel *chooseExpressionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, self.height - 8 - 16.5, 100, 16.5)];
    chooseExpressionLabel.text = @"变身热门表情";
    chooseExpressionLabel.textColor = HEXCOLOR(0x878B99);
    chooseExpressionLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:chooseExpressionLabel];
    self.chooseExpressionLabel = chooseExpressionLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 缩放距离 24 (MAX-MIN)，头像区域最多减 17，剩下的是 label 与头像间距
    CGFloat faceOffset = MIN(kDouTuHeaderMaxHeight - self.height, 17);
    self.addFaceImageView.width = 56 - faceOffset;
    self.addFaceImageView.height = 56 - faceOffset;
    self.sepLine.left = 12 + 56 + 12.5 - faceOffset;
    self.sepLine.top = 37 + (self.addFaceImageView.height - 14) / 2;
    [self reLayoutFaceScrollView];
    self.chooseExpressionLabel.top = self.height - 8 - 16.5;
}

- (void)reLayoutFaceScrollView {
    CGFloat imageSize = self.addFaceImageView.width;

    __block CGFloat offsetX = 0;
    [self.faceImageViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QQDouTuFaceImageView *view = (QQDouTuFaceImageView *)obj;
        view.frame = CGRectMake(offsetX, 0, imageSize, imageSize);
        offsetX += (imageSize + 10);
    }];
    self.faceScrollView.frame = CGRectMake(self.addFaceImageView.right + 25, 37, self.width - self.addFaceImageView.right - 25 - 12, 56);
    self.faceScrollView.contentSize = CGSizeMake(offsetX, 56);
}

- (UIImageView *)addFaceImageView {
    if (!_addFaceImageView) {
        _addFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 37, 56, 56)];
        _addFaceImageView.image = [UIImage imageNamed:@"qqdoutu_addface.png"];
        _addFaceImageView.layer.cornerRadius = 6.0;
        _addFaceImageView.layer.masksToBounds = YES;
        _addFaceImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFaceAction:)];
        [_addFaceImageView addGestureRecognizer:tap];
    }
    return _addFaceImageView;
}

#pragma mark - Public Methods
- (void)addFaceModel:(QQDouTuFaceModel *)face selected:(BOOL)selected {
    // UI
    CGFloat imageSize = self.addFaceImageView.width;
    QQDouTuFaceImageView *faceImageView = [[QQDouTuFaceImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize) model:face];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeFaceAction:)];
    [faceImageView addGestureRecognizer:tap];
    [self.faceImageViews addObject:faceImageView];
    [self.faceScrollView addSubview:faceImageView];
    [self reLayoutFaceScrollView];
    [self selectFaceWithView:faceImageView];
}

- (void)removeFaceModel:(QQDouTuFaceModel *)face {
    __block QQDouTuFaceImageView *targetView = nil;
    [self.faceImageViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QQDouTuFaceImageView *view = (QQDouTuFaceImageView *)obj;
        if ([view.model.faceId isEqualToString:face.faceId]) {
            targetView = view;
            *stop = YES;
            return;
        }
    }];
    if (!targetView) {
        return;
    }
    [self.faceImageViews removeObject:targetView];
    BOOL reSelect = targetView.selected;
    [targetView removeFromSuperview];
    targetView = nil;
    [self reLayoutFaceScrollView];
    // 如果删除了选中的脸，重新选一张
    if (reSelect) {
        [self selectFaceWithView:self.faceImageViews.lastObject];
    }
}

- (void)selectFaceWithView:(UIView *)view {
    if (view && [view isKindOfClass:[QQDouTuFaceImageView class]]) {
        QQDouTuFaceImageView *faceImageView = (QQDouTuFaceImageView *)view;
        [faceImageView setSelected:YES];
        if (self.lastSelectedFace) {
            [self.lastSelectedFace setSelected:NO];
        }
        self.lastSelectedFace = faceImageView;
    }
}

#pragma mark - Actions
- (void)addFaceAction:(UIGestureRecognizer *)gesture {
//    NSUInteger i = random() % 10;
//    QQDouTuFaceModel *model = [QQDouTuFaceModel new];
//    model.faceId = [@(i) stringValue];
//    NSLog(@"remove: %@", model.faceId);
//    [self removeFaceModel:model];
}

- (void)changeFaceAction:(UIGestureRecognizer *)gesture {
    [self selectFaceWithView:gesture.view];
}

@end

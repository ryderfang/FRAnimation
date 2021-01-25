//
//  QQDouTuView.m
//  FRAnimation
//
//  Created by Ryder Fang on 2020/2/25.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import "QQDouTuView.h"
#import "QQDouTuHeaderView.h"
#import "QQDouTuModel.h"

static NSString * const kDouTuHeaderReuseIdentifier = @"kDouTuHeaderReuseIdentifier";
static NSString * const kDouTuCellReuseIdentifier = @"kDouTuCellReuseIdentifier";

@interface QQDouTuViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *gifView;

@end

@implementation QQDouTuViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.gifView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.gifView.image = [UIImage imageNamed:@"icon_balloon.png"];
        self.gifView.contentMode = UIViewContentModeScaleAspectFit;
        self.gifView.layer.cornerRadius = 6;
        self.gifView.layer.masksToBounds = YES;
        [self addSubview:self.gifView];
    }
    return self;
}

@end

@interface QQDouTuView () <
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UIScrollViewDelegate
>

@property (nonatomic, strong) QQDouTuHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation QQDouTuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self addSubview:self.headerView];

        UIImage *image = [UIImage imageNamed:@"test3.png"];
        for (int i = 0; i < 10; i ++) {
            QQDouTuFaceModel *faceModel = [QQDouTuFaceModel new];
            faceModel.faceId = [@(i) stringValue];
            faceModel.faceImage = image;
            [self.headerView addFaceModel:faceModel selected:YES];
        }
    }
    return self;
}

- (QQDouTuHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QQDouTuHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, kDouTuHeaderMaxHeight)];
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 12.0;
        flowLayout.estimatedItemSize = CGSizeMake(79, 79);
        flowLayout.minimumInteritemSpacing = 11.5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        flowLayout.sectionHeadersPinToVisibleBounds = YES;
        flowLayout.headerReferenceSize = CGSizeMake(self.width, kDouTuHeaderMaxHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[QQDouTuViewCell class] forCellWithReuseIdentifier:kDouTuCellReuseIdentifier];
    }
    return _collectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY: %f", offsetY);
    CGFloat offsetHeight = MAX(kDouTuHeaderMaxHeight - offsetY, kDouTuHeaderMinHeight);
    offsetHeight = MIN(offsetHeight, kDouTuHeaderMaxHeight);
    self.headerView.height = offsetHeight;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QQDouTuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDouTuCellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

@end

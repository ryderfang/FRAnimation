//
//  AECropView.m
//  FRAnimation
//
//  Created by ryderfang on 2020/4/9.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "AECropView.h"

static const CGFloat kCropViewWidth = 250.f;
static const CGFloat kCropViewTopMargin = 170.f;

@interface AECropView () <UIScrollViewDelegate> {
    UIImage *_image;
    NSArray *_regions;
    // 图片初始缩放比例
    CGFloat _imageRatio;
    BOOL _disableZoom;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *zoomingView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *singleCropView;
@property (nonatomic, strong) CAShapeLayer *singleCropMask;
@property (nonatomic, strong) CAShapeLayer *multiCropMask;
@property (nonatomic, strong) UIButton *smartBtn;
@property (nonatomic, strong) UIButton *freeBtn;
@property (nonatomic, strong) NSMutableArray *cropControls;

@end

@implementation AECropView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cropControls = [NSMutableArray array];
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.zoomingView];
    [self.zoomingView addSubview:self.imageView];
    [self addSubview:self.singleCropView];
    [self addSubview:self.smartBtn];
    [self addSubview:self.freeBtn];
}

- (void)setImage:(UIImage *)image withRegins:(NSArray<NSValue *> *)regions merged:(BOOL)merged {
    // reset
    [self resetSubViews];

    _image = image;
    _regions = regions;
    CGRect maxRect = [self getMaxRect:regions];
    // TEST
    CGImageRef croppedImage = CGImageCreateWithImageInRect(_image.CGImage, maxRect);
    UIImage *testImage = [UIImage imageWithCGImage:croppedImage scale:1.0f orientation:_image.imageOrientation];
    CGImageRelease(croppedImage);

    // 图片缩放到裁剪框正好包含框选区域
    _imageRatio = kCropViewWidth / MAX(maxRect.size.width, maxRect.size.height);
    CGSize zoomingSize = CGSizeMake(_image.size.width * _imageRatio, _image.size.height * _imageRatio);
    _zoomingView.frame = CGRectMake(0, 0, zoomingSize.width, zoomingSize.height);
    _imageView.frame = _zoomingView.bounds;
    _imageView.image = image;

    CGRect square = [self getSquareRect:maxRect];
    _scrollView.contentSize = zoomingSize;
    // 最小缩放到裁剪框区域
    _scrollView.minimumZoomScale = MIN(1.0, kCropViewWidth / MIN(zoomingSize.width, zoomingSize.height));
    _scrollView.contentOffset = CGPointMake(square.origin.x * _imageRatio, square.origin.y * _imageRatio);
    
    if (merged || regions.count <= 1) {
        _disableZoom = NO;
        self.scrollView.scrollEnabled = YES;
        self.singleCropView.hidden = NO;
        [self.layer addSublayer:self.singleCropMask];
    } else {
        // 多个框，允许点击，不可缩放
        _disableZoom = YES;
        __weak typeof(self) weakSelf = self;
        [regions enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(self) self = weakSelf;
            if (obj && [obj isKindOfClass:[NSValue class]]) {
                CGRect rt = [obj CGRectValue];
                CGRect zoomRt = CGRectApplyAffineTransform(rt, CGAffineTransformMakeScale(_imageRatio, _imageRatio));
                UIControl *ctrl = [[UIControl alloc] initWithFrame:zoomRt];
                ctrl.backgroundColor = [UIColor clearColor];
                [ctrl addTarget:self action:@selector(cropViewTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.zoomingView addSubview:ctrl];
                [self.cropControls addObject:ctrl];
                [self addBorderLayer:ctrl];
            }
        }];
//        [self.layer addSublayer:self.multiCropMask];
        self.smartBtn.selected = YES;
    }
    self.smartBtn.hidden = (regions.count <= 1);
    self.freeBtn.hidden = (regions.count <= 1);
}

- (UIImage *)croppedImage {
    CGRect region = [self convertRect:_singleCropView.frame toView:_zoomingView];
    return [self croppedImageOfRegion:region];
}

#pragma mark - Private Methods
- (void)resetSubViews {
    [self.cropControls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *v = (UIView *)obj;
        if (v && [v isKindOfClass:[UIView class]]) {
            [v removeFromSuperview];
        }
    }];
    [self.cropControls removeAllObjects];
    self.singleCropView.hidden = YES;
    [self.singleCropMask removeFromSuperlayer];
    [self.multiCropMask removeFromSuperlayer];
    self.scrollView.zoomScale = 1.0;
    self.scrollView.scrollEnabled = NO;
}

// 取图片区域 region 的最小外接正方形 (有可能部分在图片外)
- (CGRect)getSquareRect:(CGRect)region {
    if (CGRectEqualToRect(region, CGRectZero)) {
        // 图片正中区域
        if (_image.size.width > _image.size.height) {
            return CGRectMake((_image.size.width - _image.size.height) / 2, 0, _image.size.height, _image.size.height);
        } else {
            return CGRectMake(0, (_image.size.height - _image.size.width) / 2, _image.size.width, _image.size.width);
        }
    }
    
    CGSize regionSize = region.size;
    CGFloat squareSideLength = MAX(regionSize.width, regionSize.height);
    CGRect square = CGRectMake(region.origin.x, region.origin.y, squareSideLength, squareSideLength);
    if (regionSize.width > regionSize.height) {
        square.origin.y = region.origin.y - (regionSize.width - regionSize.height) / 2;
    } else {
        square.origin.x = region.origin.x - (regionSize.height - regionSize.width) / 2;
    }
    return square;
}

// 多个矩形区域的最小外接矩形
- (CGRect)getMaxRect:(NSArray *)regions {
    if (regions.count == 0) {
        // 图片正中区域
        if (_image.size.width > _image.size.height) {
            return CGRectMake((_image.size.width - _image.size.height) / 2, 0, _image.size.height, _image.size.height);
        } else {
            return CGRectMake(0, (_image.size.height - _image.size.width) / 2, _image.size.width, _image.size.width);
        }
    }
    if (regions.count == 1) {
        if (regions[0] && [regions[0] isKindOfClass:[NSValue class]]) {
            CGRect rt = [regions[0] CGRectValue];
            return rt;
        }
        return CGRectZero;
    }
    __block CGFloat minX = FLT_MAX;
    __block CGFloat minY = FLT_MAX;
    __block CGFloat maxX = FLT_MIN;
    __block CGFloat maxY = FLT_MIN;
    [regions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSValue *v = (NSValue *)obj;
        if (v && [v isKindOfClass:[NSValue class]]) {
            CGRect rt = [v CGRectValue];
            minX = MIN(rt.origin.x, minX);
            minY = MIN(rt.origin.y, minY);
            maxX = MAX(CGRectGetMaxX(rt), maxX);
            maxY = MAX(CGRectGetMaxY(rt), maxY);
        }
    }];
    CGRect maxRect = CGRectMake(minX, minY, maxX - minX, maxY - minY);
    return maxRect;
}

// 图片短边跟裁剪框对齐时图片位置
//- (CGRect)getAspectFitRect {
//    CGSize imageSize = _image.size;
//    if (imageSize.width <= 0 || imageSize.height <= 0) {
//        return CGRectZero;
//    }
//    CGRect cropRect = CGRectZero;
//    if (imageSize.width > imageSize.height) {
//        cropRect.size.height = kCropViewWidth;
//        cropRect.size.width = kCropViewWidth * imageSize.width / imageSize.height;
//        cropRect.origin.x = (cropRect.size.width - kCropViewWidth) / 2;
//    } else {
//        cropRect.size.width = kCropViewWidth;
//        cropRect.size.height = kCropViewWidth * imageSize.height / imageSize.width;
//        cropRect.origin.y = (cropRect.size.height - kCropViewWidth) / 2;
//    }
//    return cropRect;
//}

- (void)cropViewTouched:(UIView *)view {
    UIImage *croppedView = [self croppedImageOfRegion:view.frame];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cropViewTouched:)]) {
        [self.delegate cropViewTouched:croppedView];
    }
}

- (UIImage *)croppedImageOfRegion:(CGRect)region {
    CGRect zoomRect = region;
    CGRect zoomedCropRect = CGRectMake(zoomRect.origin.x / _imageRatio, zoomRect.origin.y / _imageRatio,
                                       zoomRect.size.width / _imageRatio, zoomRect.size.height / _imageRatio);
    CGImageRef croppedImage = CGImageCreateWithImageInRect(_image.CGImage, zoomedCropRect);
    UIImage *image = [UIImage imageWithCGImage:croppedImage scale:1.0f orientation:_image.imageOrientation];
    CGImageRelease(croppedImage);
    return image;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self.smartBtn] || [view isEqual:self.freeBtn]) {
        return view;
    }
    if (_disableZoom) {
        if ([self.cropControls containsObject:view]) {
            return view;
        }
        return nil;
    } else {
        CGPoint locationInImageView = [self convertPoint:point toView:_zoomingView];
        CGPoint zoomedPoint = CGPointMake(locationInImageView.x * _scrollView.zoomScale, locationInImageView.y * _scrollView.zoomScale);
        if (CGRectContainsPoint(_zoomingView.frame, zoomedPoint)) {
            return _scrollView;
        }
    
        return [super hitTest:point withEvent:event];
    }
}

//- (void)addCropMask:(NSArray<UIView *> *)views {
//    __block UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
//    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGRect viewFrame = [self convertRect:obj.frame fromView:obj.superview];
//        UIBezierPath *cropPath = [UIBezierPath bezierPathWithRoundedRect:viewFrame cornerRadius:15.0];
//        [path appendPath:cropPath];
//    }];
//    [path setUsesEvenOddFillRule:YES];
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.path = path.CGPath;
//    maskLayer.fillRule = kCAFillRuleEvenOdd;
//    maskLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.73].CGColor;
//    [self.layer addSublayer:maskLayer];
//}

- (void)addBorderLayer:(UIView *)view {
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.fillColor = nil;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:15.0].CGPath;
    borderLayer.lineWidth = 1.0;
    borderLayer.lineCap = kCALineCapRound;
    borderLayer.lineDashPattern = @[@6, @8];
    [view.layer addSublayer:borderLayer];
}

- (void)smartBtnClicked:(UIButton *)btn {
    _smartBtn.selected = YES;
    _freeBtn.selected = NO;
    [self setImage:_image withRegins:_regions merged:NO];
}

- (void)freeBtnClicked:(UIButton *)btn {
    _smartBtn.selected = NO;
    _freeBtn.selected = YES;
    [self setImage:_image withRegins:_regions merged:YES];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _zoomingView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}

#pragma mark - Lazy init
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((self.width - kCropViewWidth) / 2, kCropViewTopMargin, kCropViewWidth, kCropViewWidth)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.maximumZoomScale = 5.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        // 关键属性
        _scrollView.clipsToBounds = NO;
    }
    return _scrollView;
}

- (UIView *)zoomingView {
    if (!_zoomingView) {
        _zoomingView = [[UIView alloc] init];
        _zoomingView.backgroundColor = [UIColor clearColor];
    }
    return _zoomingView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (UIView *)singleCropView {
    if (!_singleCropView) {
        _singleCropView = [[UIView alloc] initWithFrame:CGRectMake((self.width - kCropViewWidth) / 2, kCropViewTopMargin, kCropViewWidth, kCropViewWidth)];
        _singleCropView.backgroundColor = [UIColor clearColor];
        [self addBorderLayer:_singleCropView];
    }
    return _singleCropView;
}

- (CAShapeLayer *)singleCropMask {
    if (!_singleCropMask) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        UIBezierPath *cropPath = [UIBezierPath bezierPathWithRoundedRect:_singleCropView.frame cornerRadius:15.0];
        [path appendPath:cropPath];
        UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.height - 62, self.width, 62)];
        [path appendPath:bottomPath];
        [path setUsesEvenOddFillRule:YES];
        _singleCropMask = [CAShapeLayer layer];
        _singleCropMask.path = path.CGPath;
        _singleCropMask.fillRule = kCAFillRuleEvenOdd;
        _singleCropMask.fillColor = [UIColor colorWithWhite:0 alpha:0.73].CGColor;
    }
    return _singleCropMask;
}

- (CAShapeLayer *)multiCropMask {
    if (!_multiCropMask) {
        __block UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        [self.cropControls enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect viewFrame = [self convertRect:obj.frame fromView:obj.superview];
            UIBezierPath *cropPath = [UIBezierPath bezierPathWithRoundedRect:viewFrame cornerRadius:15.0];
            [path appendPath:cropPath];
        }];
        UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.height - 62, self.width, 62)];
        [path appendPath:bottomPath];
        [path setUsesEvenOddFillRule:YES];
        _multiCropMask = [CAShapeLayer layer];
        _multiCropMask.path = path.CGPath;
        _multiCropMask.fillRule = kCAFillRuleEvenOdd;
        _multiCropMask.fillColor = [UIColor colorWithWhite:0 alpha:0.73].CGColor;
    }
    return _multiCropMask;
}



- (UIButton *)smartBtn {
    if (!_smartBtn) {
        _smartBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height - 62, self.width / 2, 62)];
        [_smartBtn setTitle:@"智能选脸" forState:UIControlStateNormal];
        [_smartBtn setTitleColor:HEXCOLOR(0x878B99) forState:UIControlStateNormal];
        [_smartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _smartBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.73];
        _smartBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _smartBtn.contentMode = UIViewContentModeCenter;
        [_smartBtn addTarget:self action:@selector(smartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _smartBtn.hidden = YES;
    }
    return _smartBtn;
}

- (UIButton *)freeBtn {
    if (!_freeBtn) {
        _freeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width / 2, self.height - 62, self.width / 2, 62)];
        [_freeBtn setTitle:@"自由裁剪" forState:UIControlStateNormal];
        [_freeBtn setTitleColor:HEXCOLOR(0x878B99) forState:UIControlStateNormal];
        [_freeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _freeBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.73];
        _freeBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _freeBtn.contentMode = UIViewContentModeCenter;
        [_freeBtn addTarget:self action:@selector(freeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _freeBtn.hidden = YES;
    }
    return _freeBtn;
}

@end

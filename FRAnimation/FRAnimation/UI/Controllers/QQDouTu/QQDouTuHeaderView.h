//
//  QQDouTuHeaderView.h
//  FRAnimation
//
//  Created by Ryder Fang on 2020/2/25.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kDouTuHeaderMinHeight;
extern const CGFloat kDouTuHeaderMaxHeight;

@class QQDouTuFaceModel;

@protocol QQDouTuHeaderViewDelegate <NSObject>

- (void)faceImageSelected:(QQDouTuFaceModel *)face;

@end

@interface QQDouTuHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<QQDouTuHeaderViewDelegate> delegate;

- (void)addFaceModel:(QQDouTuFaceModel *)face selected:(BOOL)selected;

- (void)removeFaceModel:(QQDouTuFaceModel *)face;

@end

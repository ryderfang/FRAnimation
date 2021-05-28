//
//  AECropView.h
//  FRAnimation
//
//  Created by Rui on 2020/4/9.
//  Copyright © 2020 ryderfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AECropViewDelegate <NSObject>

- (void)cropViewTouched:(UIImage *)croppedImage;

@end

@interface AECropView : UIView

@property (nonatomic, weak) id<AECropViewDelegate> delegate;

/*
 * @param image 输入图片
 * @param regions 多个框中的区域，可能是矩形
 * @param merged 是否需要将所有区域合并，框选最大外接矩形
 */
- (void)setImage:(UIImage *)image withRegins:(NSArray<NSValue *> *)regions merged:(BOOL)merged;

/*
 * 单区域裁剪图
 */
- (UIImage *)croppedImage;

@end

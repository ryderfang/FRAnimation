//
//  FRBubbleView.h
//  FRAnimation
//
//  Created by Ryder Fang on 2020/7/22.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRBubbleView : UIView

@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) UIEdgeInsets imageInset;

@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, assign) UIEdgeInsets labelInset;

+ (void)showBubble:(FRBubbleView *)bubble inView:(UIView *)superView fullScreenMask:(BOOL)fullScreenMask;

@end

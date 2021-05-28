//
//  QQHotPicSwitchBar.h
//  QQMainProject
//
//  Created by Rui on 2020/2/24.
//  Copyright © 2018年 ryderfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QQHotPicSwitchBarDelegate <NSObject>

// 0: 热图 1: DIY 斗图
- (void)hotPicSwitchBarSelected:(NSUInteger)index;

@end

@interface QQHotPicSwitchBar : UIView

@property (nonatomic, weak) id<QQHotPicSwitchBarDelegate> delegate;

- (void)doSelectIndex:(NSUInteger)index;

@end

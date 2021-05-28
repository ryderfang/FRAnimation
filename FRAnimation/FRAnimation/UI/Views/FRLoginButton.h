//
//  FRLoginButton.h
//  FRAnimation
//
//  Created by Rui on 2016/12/26.
//  Copyright © 2016年 ryderfang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)(void);

@interface FRLoginButton : UIView

@property (nonatomic, copy) completeBlock block;

- (void)show;

@end

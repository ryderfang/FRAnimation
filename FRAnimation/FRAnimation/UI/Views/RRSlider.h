//
//  RRSlider.h
//  FRAnimation
//
//  Created by Rui on 2021/5/28.
//  Copyright © 2021 ryderfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRSlider : UISlider

// default is 0.5
@property (nonatomic, assign) float defaultValue;

- (void)setDefaultValueHidden:(BOOL)isHidden;

@end

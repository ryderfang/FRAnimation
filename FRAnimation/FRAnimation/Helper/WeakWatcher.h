//
//  WeakWatcher.h
//  FRAnimation
//
//  Created by ryderfang on 2021/5/10.
//  Copyright © 2021 Ray Fong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const s_key = @"myWeakWatcher";

/*!
 [WeakWatcher watch:delegate block:^{
     NSLog(@"dealloc");
 }];
 */
@interface WeakWatcher : NSObject

@property (nonatomic, copy) dispatch_block_t myBlock;

@end

NS_ASSUME_NONNULL_END

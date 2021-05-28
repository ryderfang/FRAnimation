//
//  WeakWatcher.m
//  FRAnimation
//
//  Created by Rui on 2021/5/10.
//  Copyright © 2021 ryderfang. All rights reserved.
//

#import "WeakWatcher.h"
#import <objc/runtime.h>

@implementation WeakWatcher

- (instancetype)initWithBlock:(dispatch_block_t)block {
    if (self = [super init]) {
        self.myBlock = block;
    }
    return self;
}

+ (void)watch:(id)obj block:(dispatch_block_t)block {
    objc_setAssociatedObject(obj, &s_key, [[WeakWatcher alloc] initWithBlock:block], OBJC_ASSOCIATION_RETAIN);
}

- (void)dealloc {
    self.myBlock();
}

@end

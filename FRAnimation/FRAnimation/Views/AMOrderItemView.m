//
//  AMOrderItemView.m
//  FRAnimation
//
//  Created by YiMu on 2018/5/16.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "AMOrderItemView.h"

@interface AMOrderItemView ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation AMOrderItemView

- (instancetype)initWithFrame:(CGRect)frame Index:(NSInteger)index {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = HEXCOLOR(0x888888).CGColor;
        
        self.index = index;
        // test
        UILabel *lbl = [[UILabel alloc] initWithFrame:self.bounds];
        lbl.text = [NSString stringWithFormat:@"%ld", (long)index];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:48];
        lbl.textColor = [UIColor redColor];
        [self addSubview:lbl];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationGot:) name:kGlobalNotification object:nil];
    }
    return self;
}

- (void)notificationGot:(NSNotification *)notification {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"$YM$ %@ Get Notification.", NSStringFromClass(self.class));
    });
    sleep(5);
//    if (self.index == 1) {
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
//        [array insertObject:@1 atIndex:2];
//    }
}

@end

//
//  ScrollViewController.m
//  FRAnimation
//
//  Created by Rui on 2018/5/16.
//  Copyright © 2018年 ryderfang. All rights reserved.
//

#import "ScrollViewController.h"
#import "AMOrderContainerView.h"

@interface ScrollViewController ()

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, FR_NavStatusHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - FR_NavStatusHeight);
    AMOrderContainerView *container = [[AMOrderContainerView alloc] initWithFrame:frame ItemCount:3];
    [self.view addSubview:container];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalNotification object:nil];
//            NSNotification *notification = [NSNotification notificationWithName:kGlobalNotification object:nil];
//            [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostWhenIdle];
        } @catch (NSException *exception) {
            NSLog(@"$YM$ PostLoginNotification exception %@", exception);
            [[NSNotificationCenter defaultCenter] postNotificationName:kGlobalNotification object:nil];
        }
        NSLog(@"$YM$ After Post Notification.");
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


@end

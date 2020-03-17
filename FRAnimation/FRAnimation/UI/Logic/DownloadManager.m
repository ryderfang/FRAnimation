//
//  DownloadManager.m
//  FRAnimation
//
//  Created by ryderfang on 2020/3/17.
//  Copyright © 2020 tencent. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static DownloadManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[DownloadManager alloc] init];
    });
    return instance;
}

- (void)addDownload:(DownloadModel *)model withPriority:(long)priority {
    
}

- (BOOL)isDownloading:(DownloadModel *)model {
    return YES;
}

@end

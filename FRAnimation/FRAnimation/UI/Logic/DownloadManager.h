//
//  DownloadManager.h
//  FRAnimation
//
//  Created by ryderfang on 2020/3/17.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModel.h"

#define DOWNLOAD_PRIORITY_HIGH 2
#define DOWNLOAD_PRIORITY_DEFAULT 0
#define DOWNLOAD_PRIORITY_LOW (-2)

@interface DownloadManager : NSObject

+ (instancetype)defaultManager;

- (void)addDownload:(DownloadModel *)model withPriority:(long)priority;

- (BOOL)isDownloading:(DownloadModel *)model;

@end

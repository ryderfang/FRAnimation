//
//  DownloadModel.h
//  FRAnimation
//
//  Created by ryderfang on 2020/3/17.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadModel : NSObject

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *url;

- (BOOL)isFileExist;

@end

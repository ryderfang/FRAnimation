//
//  DownloadModel.h
//  FRAnimation
//
//  Created by ryderfang on 2020/3/17.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadModel : NSObject

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong, readonly) NSString *testReadonly;

- (BOOL)isFileExist;

@end

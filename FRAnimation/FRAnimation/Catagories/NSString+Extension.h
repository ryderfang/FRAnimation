//
//  NSString+Extension.h
//  Pin
//
//  Created by cyan on 15/9/12.
//  Copyright © 2015年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, PINSegmentationOptions) {
    PINSegmentationOptionsNone              = 0,
    PINSegmentationOptionsDeduplication     = 1 << 0,
    PINSegmentationOptionsKeepEnglish       = 1 << 1,
    PINSegmentationOptionsKeepSymbols       = 1 << 2,
};

@interface NSString (Extension)

- (NSArray<NSString *> *)segment:(PINSegmentationOptions)options;

@end

//
//  FRImageHelper.h
//  FRAnimation
//
//  Created by ryderfang on 2020/4/13.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FRImageHelper : NSObject

+ (UIImage*)image:(UIImage*)image scaleAspectFitSize:(CGSize)size;
+ (UIImage*)image:(UIImage*)image scaleAspectFitSize:(CGSize)size withOrientation:(UIImageOrientation)imageOrientation;

@end

NS_ASSUME_NONNULL_END

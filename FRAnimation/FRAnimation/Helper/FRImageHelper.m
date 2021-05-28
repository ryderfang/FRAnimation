//
//  FRImageHelper.m
//  FRAnimation
//
//  Created by Rui on 2020/4/13.
//  Copyright © 2020 ryderfang. All rights reserved.
//

#import "FRImageHelper.h"

@implementation FRImageHelper

+ (UIImage*)image:(UIImage*)image scaleAspectFitSize:(CGSize)size {
    return [FRImageHelper image:image scaleAspectFitSize:size withOrientation:UIImageOrientationUp];
}

+ (UIImage*)image:(UIImage*)image scaleAspectFitSize:(CGSize)size withOrientation:(UIImageOrientation)imageOrientation {
    if (!image) {
        return nil;
    }
    
    CGSize imageSize = image.size;
    
    //如果原图大小已经比目标size 小，就不缩放了。 ximilu
    if (imageSize.width * imageSize.height <= size.width * size.height && image.imageOrientation == imageOrientation) {
        return image;
    }

    float s_defatult = size.width * size.height;
    float s_image     = imageSize.width * imageSize.height;
    
    float hv = fabs(sqrtf(s_image / s_defatult));
    
    //    if (hv <= 1.0f) return image;
    if (hv <= 1.0f) {
        hv = 1.0f;
    }
    
    int width = image.size.width / hv;
    int height = image.size.height / hv;
    CGSize n_size = {width, height};

    if ((imageOrientation == UIImageOrientationLeft) || (imageOrientation == UIImageOrientationLeftMirrored) || (imageOrientation == UIImageOrientationRight) || (imageOrientation == UIImageOrientationRightMirrored)) {
        n_size = CGSizeMake(height, width);
    }
    
    UIImage* n_image = nil;
    
    UIGraphicsBeginImageContextWithOptions(n_size, NO, image.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // Rotate as needed
    switch(imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformRotate(transform, M_PI / 2.0f);
            transform = CGAffineTransformTranslate(transform, 0.0f, -n_size.width);
            n_size = CGSizeMake(n_size.height, n_size.width);
            CGContextConcatCTM(context, transform);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformRotate(transform, -M_PI / 2.0f);
            transform = CGAffineTransformTranslate(transform, -n_size.height, 0.0f);
            n_size = CGSizeMake(n_size.height, n_size.width);
            CGContextConcatCTM(context, transform);
            break;
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformRotate(transform, M_PI);
            transform = CGAffineTransformTranslate(transform, -n_size.width, -n_size.height);
            CGContextConcatCTM(context, transform);
            break;
        default:
            break;
    }
    
    [image drawInRect:CGRectMake(0, 0, n_size.width, n_size.height)];
    n_image = UIGraphicsGetImageFromCurrentImageContext();
    
    if (imageOrientation != UIImageOrientationUp) {
        n_image = [UIImage imageWithCGImage:n_image.CGImage scale:n_image.scale orientation:imageOrientation];
    }
    UIGraphicsEndImageContext();

    return n_image;
}

@end

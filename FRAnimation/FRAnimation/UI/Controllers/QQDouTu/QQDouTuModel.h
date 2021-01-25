//
//  QQDouTuModel.h
//  FRAnimation
//
//  Created by Ryder Fang on 2020/2/26.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kNoFaceId;

@interface QQDouTuFaceModel : NSObject

@property (nonatomic, strong) NSString *faceId;
@property (nonatomic, strong) UIImage *faceImage;

@end

@interface QQDouTuExpressionModel : NSObject

@end

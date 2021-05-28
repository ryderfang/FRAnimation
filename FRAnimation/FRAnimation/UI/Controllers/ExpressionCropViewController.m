//
//  ExpressionCropViewController.m
//  FRAnimation
//
//  Created by Rui on 2020/4/9.
//  Copyright © 2020 ryderfang. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ExpressionCropViewController.h"
#import "AECropView.h"
//#import "PECropViewController.h"
#import "ResultViewController.h"
#import "UIImage+FixOrientation.h"
#import <Photos/Photos.h>

@interface ExpressionCropViewController () <
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
//    PECropViewControllerDelegate,
    AECropViewDelegate
>

@property (nonatomic, strong) AECropView *cropView;

@end

@implementation ExpressionCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"移动和缩放";
    
    self.cropView = [[AECropView alloc] initWithFrame:CGRectMake(0, 88, self.view.width, self.view.height - 88)];
    self.cropView.delegate = self;
    [self.view addSubview:self.cropView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *albumBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
    [albumBtn setTitle:@"相册" forState:UIControlStateNormal];
    [albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    albumBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [albumBtn setBackgroundColor:HEXCOLOR(0x87CEEB)];
    albumBtn.layer.cornerRadius = 12;
    albumBtn.layer.masksToBounds = YES;
    [albumBtn addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(0, 0, 60, 24);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [rightButton setBackgroundColor:HEXCOLOR(0x87CEEB)];
    rightButton.layer.cornerRadius = 12;
    rightButton.layer.masksToBounds = YES;
    [rightButton addTarget:self action:@selector(doCrop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:rightButton],
                                                [[UIBarButtonItem alloc] initWithCustomView:albumBtn]];
}

- (void)showPicker:(UIButton *)btn {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    [self.navigationController presentViewController:pickerController animated:YES completion:^{
        
    }];
}

- (void)doCrop:(UIButton *)btn {
    UIImage *croppedImage = [self.cropView croppedImage];
    ResultViewController *vc = [[ResultViewController alloc] init];
    [vc showImage:croppedImage];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    UIImage *result = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGImageRef cgImage = result.CGImage;
    CGSize sz = result.size;
//    typedef NS_ENUM(NSInteger, UIImageOrientation) {
//        UIImageOrientationUp,            // default orientation
//        UIImageOrientationDown,          // 180 deg rotation
//        UIImageOrientationLeft,          // 90 deg CCW
//        UIImageOrientationRight,         // 90 deg CW
//        UIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
//        UIImageOrientationDownMirrored,  // horizontal flip
//        UIImageOrientationLeftMirrored,  // vertical flip
//        UIImageOrientationRightMirrored, // vertical flip
//    };
    NSLog(@"origin image size: %f %f, orientation: %d", sz.width, sz.height, (int)result.imageOrientation);
    UIImage *test = [UIImage imageWithCGImage:result.CGImage scale:result.scale orientation:UIImageOrientationRight];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSLog(@"fixed orientation: %d", (int)test.imageOrientation);
        [PHAssetChangeRequest creationRequestForAssetFromImage:test];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
    }];
    // image
    CGRect face1 = CGRectMake(549, 379, 390, 390);
    CGRect face2 = CGRectMake(154, 606, 213, 213);
//    [self.cropView setImage:result withRegins:nil merged:NO];
//    [self.cropView setImage:result withRegins:@[[NSValue valueWithCGRect:face2]] merged:NO];
//    [self.cropView setImage:result withRegins:@[[NSValue valueWithCGRect:face1],
//                                                [NSValue valueWithCGRect:face2]] merged:YES];
    [self.cropView setImage:result withRegins:@[[NSValue valueWithCGRect:face1],
                                                [NSValue valueWithCGRect:face2]] merged:NO];

    // QQ
    return;
//    PECropViewController *vc = [[PECropViewController alloc] init];
//    vc.image = result;
//    vc.cropSize = CGSizeMake(1080, 1080);
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PECropViewControllerDelegate
//- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
//    self.cropView.image = croppedImage;
//}

//- (void)cropViewController:(PECropViewController *)controller didFinishOriginImage:(UIImage *)originImage withClipRect:(CGRect)clipRect {
//
//}

#pragma mark - AECropViewDelegate
- (void)cropViewTouched:(UIImage *)croppedImage {
    ResultViewController *vc = [[ResultViewController alloc] init];
    [vc showImage:croppedImage];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

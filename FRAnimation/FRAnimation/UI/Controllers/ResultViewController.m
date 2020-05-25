//
//  ResultViewController.m
//  FRAnimation
//
//  Created by ryderfang on 2020/4/14.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88 + 200, self.view.width, self.view.width)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

@end

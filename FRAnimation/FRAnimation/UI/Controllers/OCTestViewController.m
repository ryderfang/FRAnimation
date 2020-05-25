//
//  OCTestViewController.m
//  FRAnimation
//
//  Created by ryderfang on 2020/5/25.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import "OCTestViewController.h"
#import <YYModel/YYModel.h>
#import "DownloadModel.h"

@interface OCTestViewController ()

@end

@implementation OCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"探索 Objc 奥秘";
    self.view.backgroundColor = HEXCOLOR(0xadc6ff);
    
    [self testYYModel];
}

- (void)testYYModel {
    DownloadModel *model = [[DownloadModel alloc] init];
    model.itemId = @"test1";
    model.url = @"https://www.ww.www";
    NSString *json = [model yy_modelToJSONString];
    NSLog(@"%@", json);
}

@end

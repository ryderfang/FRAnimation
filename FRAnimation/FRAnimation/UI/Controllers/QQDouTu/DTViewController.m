//
//  DTViewController.m
//  FRAnimation
//
//  Created by Ryder Fang on 2020/2/25.
//  Copyright © 2020 Ray Fong. All rights reserved.
//

#import "DTViewController.h"
#import "QQDouTuView.h"
#import "AEEditorMusicPanel.h"

const CGFloat kDouTuHeight = 441.f;

@interface DTViewController () <AEEditorMusicPanelDelegate>

@property (nonatomic, strong) QQDouTuView *dtView;
@property (nonatomic, strong) UIButton *musicBtn;
@property (nonatomic, strong) AEEditorMusicPanel *panel;

@end

@implementation DTViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

//    self.dtView = [[QQDouTuView alloc] initWithFrame:CGRectMake(0, self.view.height - kDouTuHeight, self.view.width, kDouTuHeight)];
//    [self.view addSubview:self.dtView];

    [self.view addSubview:self.musicBtn];
    self.panel = [[AEEditorMusicPanel alloc] initWithFrame:self.view.bounds];
    self.panel.delegate = self;
    [self.view addSubview:self.panel];
    for (int i = 0; i < 10; i++) {
        [self.panel addMusic:@(i)];
    }
    [self.panel present];
}

- (void)musicPanelShow:(UIButton *)btn {
    [self.panel present];
}

- (void)musicSelected:(id)musicModel {
    NSLog(@"$ryderfang$ %s %zd", __FUNCTION__, [musicModel integerValue]);
}

- (void)voiceSelected:(BOOL)selected {
    NSLog(@"$ryderfang$ %s %d", __FUNCTION__, selected ? 1 : 0);
}

- (UIButton *)musicBtn {
    if (!_musicBtn) {
        _musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60 - 12, self.view.height / 2, 60, 60)];
        [_musicBtn setImage:[UIImage imageNamed:@"qqcircle_ae_music_btn"] forState:UIControlStateNormal];
        [_musicBtn addTarget:self action:@selector(musicPanelShow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _musicBtn;
}

@end

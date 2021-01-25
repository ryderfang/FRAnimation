//
//  AEEditorMusicPanel.m
//  FRAnimation
//
//  Created by ryderfang on 2020/2/27.
//  Copyright © 2020 tencent. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "AEEditorMusicPanel.h"

const CGFloat kMusicPanelViewHeight = 300.0;

@class AEEditorMusicView;
@protocol AEEditorMusicViewDelegate <NSObject>

- (void)musicView:(AEEditorMusicView *)view selected:(BOOL)selected;

@end

@interface AEEditorMusicView : UIView {
    BOOL _selected;
}

- (void)setSelected:(BOOL)selected triggerDelegate:(BOOL)triggered;

@property (nonatomic, weak) id<AEEditorMusicViewDelegate> delegate;
@property (nonatomic, strong) id musicModel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *lrcLabel;

@end

@implementation AEEditorMusicView

- (instancetype)initWithFrame:(CGRect)frame withModel:(id)musicModel {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, self.width - 12 * 2, 20)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.lrcLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, self.height - 12 - 20, self.width - 12 * 2, 20)];
        self.lrcLabel.font = [UIFont systemFontOfSize:14];
        self.lrcLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.lrcLabel];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [self addGestureRecognizer:tap];
        [self setSelected:NO triggerDelegate:NO];
        _musicModel = musicModel;
    }
    return self;
}

- (void)setSelected:(BOOL)selected triggerDelegate:(BOOL)triggered {
    _selected = selected;
    self.backgroundColor = selected ? HEXCOLOR(0x00CAFC) : [UIColor grayColor];
    if (triggered && _delegate && [_delegate respondsToSelector:@selector(musicView:selected:)]) {
        [_delegate musicView:self selected:selected];
    }
}

- (void)tapped {
    [self setSelected:!_selected triggerDelegate:YES];
}

@end

@interface AEEditorMusicPanel () <AEEditorMusicViewDelegate>

@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *musicCheckBox;
@property (nonatomic, strong) UIButton *voiceCheckBox;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *musicViews;
@property (nonatomic, strong) AEEditorMusicView *selectedView;

@end

@implementation AEEditorMusicPanel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.panelView];
        [self setupPanelView];
        self.musicViews = [NSMutableArray array];
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        self.hidden = YES;

        // TODO get music list
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self musicListFetched];
        });
    }
    return self;
}

- (void)setupPanelView {
    [self.panelView addSubview:self.searchBtn];
    self.searchBtn.frame = CGRectMake(12, 20, 110, 30);
    CGFloat btnY = 20 + 30.0 / 2;
    self.musicCheckBox = [self createCheckBoxBtnWithTitle:@"配乐" selector:@selector(musicChecked:)];
    [self.panelView addSubview:self.musicCheckBox];
    self.voiceCheckBox = [self createCheckBoxBtnWithTitle:@"视频原声" selector:@selector(voiceChecked:)];
    [self.panelView addSubview:self.voiceCheckBox];
    self.voiceCheckBox.frame = CGRectMake(self.panelView.width - 12 - self.voiceCheckBox.width, btnY - self.voiceCheckBox.height / 2, self.voiceCheckBox.width, self.voiceCheckBox.height);
    self.musicCheckBox.frame = CGRectMake(self.voiceCheckBox.left - 20 - self.musicCheckBox.width, btnY - self.musicCheckBox.height / 2, self.musicCheckBox.width, self.musicCheckBox.height);

    [self.panelView addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(12, self.searchBtn.bottom + 40, self.width - 12, 76);
}

#pragma mark - Public Methods
- (void)setDelegate:(id<AEEditorMusicPanelDelegate>)delegate {
    _delegate = delegate;
    [self voiceChecked:self.voiceCheckBox];
}

- (void)present {
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.top = self.height - kMusicPanelViewHeight;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.panelView.top = self.height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)addMusic:(id)musicModel {
    NSUInteger musicNums = self.musicViews.count;
    AEEditorMusicView *musicView = [[AEEditorMusicView alloc] initWithFrame:CGRectMake(musicNums * (120 + 10), 0, 120, 76) withModel:musicModel];
    // TEST: Mock Data
    musicView.delegate = self;
    musicView.titleLabel.text = @"小桥流水-华语群星";
    musicView.lrcLabel.text = @"此歌曲无歌词";
    [self.scrollView addSubview:musicView];
    [self.musicViews addObject:musicView];
    self.scrollView.contentSize = CGSizeMake(self.musicViews.count * (120 + 10), 76);
}

#pragma mark - AEEditorMusicViewDelegate
- (void)musicView:(AEEditorMusicView *)view selected:(BOOL)selected {
    if (selected) {
        for (AEEditorMusicView *v in self.musicViews) {
            if (![v isEqual:view]) {
                [v setSelected:NO triggerDelegate:NO];
            }
        }
        self.selectedView = view;
        self.musicCheckBox.selected = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(musicSelected:)]) {
            [self.delegate musicSelected:view.musicModel];
        }
    } else {
        self.musicCheckBox.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(musicSelected:)]) {
            [self.delegate musicSelected:nil];
        }
    }
}

#pragma mark - Private Methods
- (void)musicListFetched {
    // 默认选中第一首
    [self musicChecked:self.musicCheckBox];
}

- (void)musicChecked:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        // 上次选过，选上次的，否则选第一个
        AEEditorMusicView *selectView = self.selectedView ?: self.musicViews.firstObject;
        [selectView setSelected:YES triggerDelegate:YES];
    } else {
        [self.selectedView setSelected:NO triggerDelegate:YES];
    }
}

- (void)voiceChecked:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceSelected:)]) {
        [self.delegate voiceSelected:btn.isSelected];
    }
}

- (UIButton *)createCheckBoxBtnWithTitle:(NSString *)title selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(2.0, -10, 2.0, 0.0)];
    UIImage *unselectImg = [UIImage imageNamed:@"common_checkbox_no_44px.png"];
    UIImage *selectedImg = [UIImage imageNamed:@"common_checkbox_yes_44px.png"];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn setImage:unselectImg forState:UIControlStateNormal];
    [btn setImage:selectedImg forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn sizeToFit];
    return btn;
}

#pragma mark - Lazy Init
- (UIView *)panelView {
    if (!_panelView) {
        _panelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, kMusicPanelViewHeight)];
        _panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    }
    return _panelView;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage imageNamed:@"qqcircle_ae_music_search_btn"] forState:UIControlStateNormal];
        [_searchBtn setImage:[UIImage imageNamed:@"qqcircle_ae_music_search_btn"] forState:UIControlStateHighlighted];
        _searchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _searchBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        _searchBtn.layer.backgroundColor = [UIColor grayColor].CGColor;
        [_searchBtn setTitle:@"搜索音乐库" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.0] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _searchBtn.layer.cornerRadius = 15;
        _searchBtn.layer.masksToBounds = YES;
    }
    return _searchBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end

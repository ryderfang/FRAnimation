//
//  AEEditorMusicPanel.h
//  FRAnimation
//
//  Created by ryderfang on 2020/2/27.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AEEditorMusicPanelDelegate <NSObject>

// 配乐选择
- (void)musicSelected:(id)musicModel;
// 视频原声
- (void)voiceSelected:(BOOL)selected;

@end

@interface AEEditorMusicPanel : UIControl

@property (nonatomic, weak) id <AEEditorMusicPanelDelegate> delegate;

- (void)present;
- (void)dismiss;

- (void)addMusic:(id)musicModel;

@end

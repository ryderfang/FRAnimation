//
//  SpeechViewController.m
//  FRAnimation
//
//  Created by YiMu on 2018/6/23.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "SpeechViewController.h"
#import <Speech/Speech.h>
#import <Lottie/Lottie.h>

// 仅 iOS 10 及以上有效
// API_AVAILABLE(ios(10.0))

@interface SpeechViewController () <SFSpeechRecognizerDelegate>

@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *tipBtn;
@property (nonatomic, strong) LOTAnimationView *voiceTip;
@property (nonatomic, strong) LOTAnimationView *speechBtn;
@property (nonatomic, assign) BOOL isRecoding;

@end

@implementation SpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// UI
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tipBtn];
    [self.view addSubview:self.voiceTip];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.speechBtn];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@300);
        make.height.equalTo(@18);
    }];
    
    [self.voiceTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.tipBtn);
        make.width.equalTo(@53);
        make.height.equalTo(@40);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipBtn.mas_bottom).offset(10);
        make.left.equalTo(self.tipBtn);
        make.height.equalTo(@400);
        make.centerX.equalTo(self.view);
    }];
    
    [self.speechBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(0);
        make.width.and.height.equalTo(@200);
        make.centerX.equalTo(self.view);
    }];
    
    
    // 麦克风权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"AVAuthorizationStatusAuthorized");
        } else {
            
        }
    }];
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
            case SFSpeechRecognizerAuthorizationStatusDenied:
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                break;
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"SFSpeechRecognizerAuthorizationStatusAuthorized");
                break;
        }
    }];
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![self checkSpeechStatus]) {
        [self.tipBtn setTitle:@"语音识别权限未开启，点击前往设置" forState:UIControlStateNormal];
        self.tipBtn.enabled = YES;
        return;
    }
    if (![self checkAudioStatus]) {
        [self.tipBtn setTitle:@"麦克风权限未开启，点击前往设置" forState:UIControlStateNormal];
        self.tipBtn.enabled = YES;
    }
    [self.tipBtn setTitle:@"点击下方按钮开始语音识别" forState:UIControlStateNormal];
    self.tipBtn.enabled = NO;

    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    self.speechRecognizer.delegate = self;
}

- (void)tapped:(id)sender {
    if (self.isRecoding) {
        [self stopRecoding];
        return;
    }
    [self startRecoding];
    
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = [self.audioEngine inputNode];
    if (!inputNode) {
        NSLog(@"Audio engine has no input node");
    }
    AVAudioFormat *recodingFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100 channels:1];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recodingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        if (result != nil) {
            self.textView.text = result.bestTranscription.formattedString;
            isFinal = result.isFinal;
        }
        if (error || isFinal) {
            [self stopRecoding];
        }
    }];
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:nil];
}

- (void)startRecoding {
    self.isRecoding = YES;
    
    [self.speechBtn play];
    [self.voiceTip play];
    [self.tipBtn setTitle:@"我在听着呢，请讲。 :)" forState:UIControlStateNormal];
}

- (void)stopRecoding {
    self.isRecoding = NO;
    
    AVAudioInputNode *inputNode = [self.audioEngine inputNode];
    if (!inputNode) {
        NSLog(@"Audio engine has no input node");
    }
    // ! important
    [inputNode removeTapOnBus:0];
    // !! important
    [self.recognitionRequest endAudio];
    
    // will stop it
    [self.speechBtn setProgressWithFrame:@0];
    [self.voiceTip setProgressWithFrame:@0];
    [self.tipBtn setTitle:@"识别结束" forState:UIControlStateNormal];
    self.textView.text = nil;
    [self.audioEngine stop];
    self.recognitionRequest = nil;
    self.recognitionTask = nil;
}

- (void)goSetting:(id)sender {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - Utils
- (BOOL)checkAudioStatus {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return (authStatus == AVAuthorizationStatusAuthorized);
}

- (BOOL)checkSpeechStatus {
    SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
    return (status == SFSpeechRecognizerAuthorizationStatusAuthorized);
}

#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    if (available) {
        
    } else {
        
    }
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.layer.borderColor = [UIColor blueColor].CGColor;
        _textView.layer.borderWidth = 2.f;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5.f;
    }
    return _textView;
}

- (LOTAnimationView *)voiceTip {
    if (!_voiceTip) {
        _voiceTip = [LOTAnimationView animationNamed:@"voice_indicator"];
        [_voiceTip setLoopAnimation:YES];
    }
    return _voiceTip;
}

- (UIButton *)tipBtn {
    if (!_tipBtn) {
        _tipBtn = [[UIButton alloc] init];
        _tipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_tipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_tipBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _tipBtn.layer.borderWidth = 0;
        [_tipBtn addTarget:self action:@selector(goSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}

- (LOTAnimationView *)speechBtn {
    if (!_speechBtn) {
        _speechBtn = [LOTAnimationView animationNamed:@"voice"];
        [_speechBtn setLoopAnimation:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [_speechBtn addGestureRecognizer:tap];
    }
    return _speechBtn;
}

@end

//
//  SpeechViewController.m
//  FRAnimation
//
//  Created by YiMu on 2018/6/23.
//  Copyright © 2018年 Ray Fong. All rights reserved.
//

#import "SpeechViewController.h"
#import <Speech/Speech.h>

@interface SpeechViewController () <SFSpeechRecognizerDelegate>

@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;

@end

@implementation SpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"SFSpeechRecognizerAuthorizationStatusNotDetermined");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"SFSpeechRecognizerAuthorizationStatusDenied");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"SFSpeechRecognizerAuthorizationStatusRestricted");
                break;
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                
                NSLog(@"SFSpeechRecognizerAuthorizationStatusAuthorized");
                break;
        }
    }];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    self.speechRecognizer.delegate = self;
}

#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    
}

@end

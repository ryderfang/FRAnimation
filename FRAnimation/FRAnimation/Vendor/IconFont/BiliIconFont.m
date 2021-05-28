//
//  BiliIconFont.m
//  FRAnimation
//
//  Created by Rui on 2017/6/15.
//  Copyright © 2017年 ryderfang. All rights reserved.
//

#import "BiliIconFont.h"
#import <CoreText/CoreText.h>

#pragma mark - BiliIconFont
@implementation BiliIconFont

static NSString *_fontName;

+ (void)registerFontWithURL:(NSURL *)url {
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Font file doesn't exist.");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    // https://stackoverflow.com/questions/24900979/cgfontcreatewithdataprovider-hangs-in-airplane-mode
    [UIFont familyNames];
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(newFont, nil);
    CGFontRelease(newFont);
}

+ (void)initWithName:(NSString *)fontName {
    _fontName = fontName;
    NSURL *fontURL = [[NSBundle mainBundle] URLForResource:fontName withExtension:@"ttf"];
    [self registerFontWithURL:fontURL];
}

+ (UIFont *)fontWithSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:[self fontName] size:fontSize];
    if (!font) {
        NSURL *fontURL = [[NSBundle mainBundle] URLForResource:[self fontName] withExtension:@"ttf"];
        [self registerFontWithURL:fontURL];
        font = [UIFont fontWithName:[self fontName] size:fontSize];
        NSAssert(font, @"UIFont object should not be nil, check if font file exists or font name is corrent.");
    }
    return font;
}

+ (BOOL)isIconFont:(UIFont *)font {
    return [font.fontName isEqualToString:[self fontName]];
}

+ (NSString *)fontName {
    return _fontName ?: @"iconfont";
}

@end

#pragma mark - BiliIconInfo
@interface BiliIconInfo()

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, strong) UIColor *color;

@end

@implementation BiliIconInfo

+ (instancetype)iconInfoWithText:(const char *)text size:(CGFloat)size color:(UIColor *)color {
    BiliIconInfo *iconInfo = [[BiliIconInfo alloc] init];
    iconInfo.text = [NSString stringWithUTF8String:text];
    iconInfo.size = size;
    iconInfo.color = color;
    return iconInfo;
}

@end

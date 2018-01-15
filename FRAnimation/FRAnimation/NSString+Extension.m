//
//  NSString+Extension.m
//  Pin
//
//  Created by cyan on 15/9/12.
//  Copyright © 2015年 cyan. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSArray<NSString *> *)segment:(PINSegmentationOptions)options {
    
    BOOL deduplication = options & PINSegmentationOptionsDeduplication;
    BOOL keepSymbols = options & PINSegmentationOptionsKeepSymbols;
    CFOptionFlags flags = keepSymbols ? kCFStringTokenizerUnitWordBoundary : kCFStringTokenizerUnitWord;
    
    NSMutableArray<NSString *> *results = [NSMutableArray array];
    CFRange textRange = CFRangeMake(0, self.length);
    CFLocaleRef currentRef = CFLocaleCopyCurrent();
    CFStringTokenizerRef tokenizerRef = CFStringTokenizerCreate(NULL, (CFStringRef)self, textRange, flags, currentRef);
    CFStringTokenizerAdvanceToNextToken(tokenizerRef);
    NSMutableSet *resultSet = [NSMutableSet set];
    
    while (YES) {
        
        CFRange tokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizerRef);
        
        if (tokenRange.location == kCFNotFound && tokenRange.length == 0) {
            break;
        }
        
        NSString *token = [self substringWithRange:NSMakeRange(tokenRange.location, tokenRange.length)];
        NSString *item = [token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (item.length > 0) {
            if (deduplication) {
                if (![resultSet containsObject:item]) {
                    [results addObject:item];
                }
                [resultSet addObject:item];
            } else {
                [results addObject:item];
            }
        }
        
        CFStringTokenizerAdvanceToNextToken(tokenizerRef);
    }
    
    CFRelease(tokenizerRef);
    CFRelease(currentRef);
    
    return results;
}

@end

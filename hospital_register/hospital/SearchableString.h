//
// Created by Zhao yang on 3/15/14.
//

#import <Foundation/Foundation.h>

@interface SearchableString : NSObject

@property (nonatomic, strong) NSString *sourceString;
@property (nonatomic, strong, readonly) NSString *fullPinyinString;
@property (nonatomic, strong, readonly) NSString *shortPinyinString;

- (id)initWithString:(NSString *)string;
- (BOOL)isMatchesString:(NSString *)string;

@end
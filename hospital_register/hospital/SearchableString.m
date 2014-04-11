//
// Created by Zhao yang on 3/15/14.
//

#import "SearchableString.h"
#import "HanyuPinyinOutputFormat.h"
#import "PinyinHelper.h"


@implementation SearchableString {

}

@synthesize sourceString = _sourceString_;
@synthesize shortPinyinString = _shortPinyinString_;
@synthesize fullPinyinString = _fullPinyinString_;

- (id)init {
    self = [super init];
    if(self) {
    }
    return self;
}

- (id)initWithString:(NSString *)string {
    self = [self init];
    if(self) {
       self.sourceString = string;
    }
    return self;
}

- (void)setSourceString:(NSString *)sourceString {
    _sourceString_ = sourceString;
    if(_sourceString_ == nil || [@"" isEqualToString:_sourceString_]) {
       _shortPinyinString_ = _sourceString_;
       _fullPinyinString_ = _sourceString_;
    } else {
        HanyuPinyinOutputFormat *pinyinOutputFormat = [[HanyuPinyinOutputFormat alloc] init];
        pinyinOutputFormat.toneType = ToneTypeWithoutTone;
        pinyinOutputFormat.caseType = CaseTypeLowercase;
        pinyinOutputFormat.vCharType = VCharTypeWithV;

        NSString *string = [PinyinHelper toHanyuPinyinStringWithNSString:_sourceString_ withHanyuPinyinOutputFormat:pinyinOutputFormat withNSString:@"_"];
        NSArray *strings = [string componentsSeparatedByString:@"_"];
        if(strings != nil && strings.count != 0) {
            NSMutableString *mString = [NSMutableString string];
            for(NSString *str in strings) {
                NSString *firstLetter = [str substringToIndex:1];
                [mString appendString:firstLetter];
            }
            _shortPinyinString_ = mString;
            _fullPinyinString_ = [strings componentsJoinedByString:@""];
        }
    }
}

- (BOOL)isMatchesString:(NSString *)string {
    if(self.sourceString == nil) return NO;
    if(string == nil) return NO;

    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *stringToMatches = string.lowercaseString;

    if([self.sourceString.lowercaseString rangeOfString:stringToMatches].location != NSNotFound) return YES;

    if([self.shortPinyinString rangeOfString:stringToMatches].location != NSNotFound) return YES;

    if(string.length > 1) {
        return [self.fullPinyinString rangeOfString:stringToMatches].location != NSNotFound;
    }

    return NO;
}

- (NSString *)description {
    return self.sourceString == nil ? @"" : self.sourceString;
}

@end
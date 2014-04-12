//
// Created by Zhao yang on 3/14/14.
//

#import <Foundation/Foundation.h>

@interface Configs : NSObject

@property (nonatomic, strong) NSTimeZone *defaultTimeZone;

+ (instancetype)defaultConfigs;

@end
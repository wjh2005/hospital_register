//
//  UIDevice+Extension.m
//  SmartHome
//
//  Created by Zhao yang on 9/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UIDevice+SystemVersion.h"

@implementation UIDevice (SystemVersion)

+ (BOOL)systemVersionIsMoreThanOrEuqal7 {
    return [UIDevice currentDevice].systemVersion.floatValue >= 7.0f;
}

@end

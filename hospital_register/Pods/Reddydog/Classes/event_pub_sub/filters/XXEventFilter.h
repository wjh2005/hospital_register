//
//  XXEventFilter.h
//  XXToolKit
//
//  Created by Zhao yang on 12/11/13.
//  Copyright (c) 2013 xuxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXEvent.h"

@interface XXEventFilter : NSObject

- (BOOL)apply:(XXEvent *)event;

@end

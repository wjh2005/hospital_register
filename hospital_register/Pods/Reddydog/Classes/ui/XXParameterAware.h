//
//  ParameterExtentions.h
//  SmartHome
//
//  Created by Zhao yang on 9/18/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XXParameterAware <NSObject>

- (void)setParameter:(id)parameter forKey:(NSString *)key;
- (id)parameterForKey:(NSString *)key;

@end

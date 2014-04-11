//
//  XXButton.h
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXParameterAware.h"

@protocol LongPressDelegate;

@interface XXButton : UIButton<XXParameterAware>

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) id userObject;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (nonatomic, weak) id<LongPressDelegate> longPressDelegate;

@end

@protocol LongPressDelegate <NSObject>

- (void)xxButtonLongPressed:(XXButton *)button;

@end



//
//  XXTopbarView.h
//  funding
//
//  Created by Zhao yang on 12/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+SystemVersion.h"

@interface XXTopbarView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *backgroundImage;

+ (XXTopbarView *)topbar;

@end

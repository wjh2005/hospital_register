//
//  UIImage+wiRoundedRectImage.h
//  hospital
//
//  Created by Zhao yang on 4/15/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (wiRoundedRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end

//
// Created by Zhao yang on 3/20/14.
//

#import <Foundation/Foundation.h>

@interface CellStyleButton : UIButton

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic) BOOL disclosureAccessoryShows;

+ (CellStyleButton *)buttonWithPoint:(CGPoint)point;

@end
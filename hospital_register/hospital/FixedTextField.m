//
//  FixedTextField.m
//  hospital
//
//  Created by Zhao yang on 4/15/14.
//
//

#import "FixedTextField.h"
#import "UIDevice+SystemVersion.h"

@implementation FixedTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
        return CGRectMake(bounds.origin.x, bounds.origin.y + 9, bounds.size.width - 35, bounds.size.height);
    }
    return [super textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end

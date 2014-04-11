//
// Created by Zhao yang on 3/19/14.
//

#import "PaperBackgroundView.h"

@implementation PaperBackgroundView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, 292, frame.size.height);
    self = [super initWithFrame:newFrame];
    if(self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 292, 19)];
    imgTop.image = [UIImage imageNamed:@"paper_top"];

    UIImageView *imgCenter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 19, 292, self.bounds.size.height - 19 - 25)];
    imgCenter.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_single"]];

    UIImageView *imgBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgCenter.frame.origin.y + imgCenter.bounds.size.height, 292, 25)];
    imgBottom.image = [UIImage imageNamed:@"paper_bottom"];

    [self addSubview:imgTop];
    [self addSubview:imgCenter];
    [self addSubview:imgBottom];
}

@end
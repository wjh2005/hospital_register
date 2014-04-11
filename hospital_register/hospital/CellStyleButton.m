//
// Created by Zhao yang on 3/20/14.
//

#import <Reddydog/UIDevice+SystemVersion.h>
#import "CellStyleButton.h"

@implementation CellStyleButton {
    UIImageView *imgDisclosure;
}

@synthesize textLabel;
@synthesize detailTextLabel;
@synthesize selectedBackgroundColor;
@synthesize disclosureAccessoryShows = _disclosureAccessoryShows_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initUI];
    }
    return self;
}

+ (CellStyleButton *)buttonWithPoint:(CGPoint)point {
    CellStyleButton *button = [[CellStyleButton alloc] initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, 44)];
    return button;
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithRed:127.f / 255.f green:174.f / 255.f blue:231.f / 255.f alpha:1];
    UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 20, 20)];
    imgLeft.image = [UIImage imageNamed:@"icon_search"];
    [self addSubview:imgLeft];

    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgLeft.frame.origin.x + 25, 7, 100, 30)];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:self.textLabel];

    self.detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 7, 145, 30)];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    self.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:self.detailTextLabel];

    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        imgDisclosure = [[UIImageView alloc] initWithFrame:CGRectMake(294, 15, 15, 15)];
        imgDisclosure.image = [UIImage imageNamed:@"disclosre_flat"];
    } else {
        imgDisclosure = [[UIImageView alloc] initWithFrame:CGRectMake(298, 15, 15, 15)];
        imgDisclosure.image = [UIImage imageNamed:@"disclosre_quasiphysical"];
    }
    [self addSubview:imgDisclosure];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if(highlighted) {
        self.backgroundColor = [UIColor colorWithRed:157.f / 255.f green:197.f / 255.f blue:241.f / 255.f alpha:1];
    } else {
        self.backgroundColor = [UIColor colorWithRed:127.f / 255.f green:174.f / 255.f blue:231.f / 255.f alpha:1];
    }
}

- (BOOL)disclosureAccessoryShows {
    return imgDisclosure.hidden;
}

- (void)setDisclosureAccessoryShows:(BOOL)disclosureAccessoryShows {
    imgDisclosure.hidden = disclosureAccessoryShows;
}

@end
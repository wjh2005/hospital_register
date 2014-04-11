//
// Created by Zhao yang on 3/19/14.
//

#import "ExpertCell.h"
#import "UIColor+MoreColor.h"
#import "UIImageView+WebCache.h"
#import "XXStringUtils.h"

#define DEFAULT_AVATAR_IMAGE_NAME @"paper_bottom"

@implementation ExpertCell {
    UIImageView *imgAvatar;
    UILabel *lblPost;
    UILabel *lblName;
    UILabel *lblIntroduce;
}

@synthesize expert = _expert_;
@synthesize expertCellType = _expertCellType_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.expertCellType = ExpertCellTypeNormal;
        [self initUI];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier expertCellType:(ExpertCellType)expertCellType {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.expertCellType = expertCellType;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView.backgroundColor = [UIColor appBackgroundYellow];

    imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 60, 70)];
    imgAvatar.image = [UIImage imageNamed:DEFAULT_AVATAR_IMAGE_NAME];
    [self.contentView addSubview:imgAvatar];

    lblPost = [[UILabel alloc] initWithFrame:CGRectMake(220, 13, 70, 27)];
    lblPost.backgroundColor = [UIColor clearColor];
    lblPost.font = [UIFont systemFontOfSize:14.f];
    lblPost.textAlignment = NSTextAlignmentRight;
    lblPost.textColor = [UIColor appFontGreen];
    [self.contentView addSubview:lblPost];

    lblName = [[UILabel alloc] initWithFrame:CGRectMake(80, 9, 135, 30)];
    lblName.backgroundColor = [UIColor clearColor];
    lblName.font = [UIFont systemFontOfSize:18.f];
    [self.contentView addSubview:lblName];

    lblIntroduce = [[UILabel alloc] initWithFrame:CGRectMake(80, 41, 210, 45)];
    lblIntroduce.backgroundColor = [UIColor clearColor];
    lblIntroduce.numberOfLines = 2;
    lblIntroduce.textColor = [UIColor lightGrayColor];
    lblIntroduce.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:lblIntroduce];
}

- (void)setExpert:(Expert *)expert withIdleDate:(ExpertIdleDate)expertIdleDate {
    _expert_ = expert;
    if(_expert_ != nil) {
        if(ExpertCellTypeIdleTime == self.expertCellType) {
            if(_expert_.name == nil) {
                lblName.text = [XXStringUtils emptyString];
            } else {
                NSMutableAttributedString *nameAndIdleTime = [[NSMutableAttributedString alloc] init];

                NSAttributedString *name = [[NSAttributedString alloc]
                        initWithString:_expert_.name.sourceString
                        attributes:@{
                           NSFontAttributeName : [UIFont systemFontOfSize:18.f],
                           NSForegroundColorAttributeName : [UIColor blackColor]
                        }];
                [nameAndIdleTime appendAttributedString:name];
                BOOL idleAM = [_expert_ isIdleForExpertIdleDate:expertIdleDate expertIdleTime:ExpertIdleTimeMorning];
                BOOL idlePM = [_expert_ isIdleForExpertIdleDate:expertIdleDate expertIdleTime:ExpertIdleTimeAfternoon];
                if(idleAM || idlePM) {
                    NSString *idleString = nil;
                    if(idleAM && idlePM) {
                        idleString = [NSString stringWithFormat:@"  (%@ | %@)", NSLocalizedString(@"morning", @""), NSLocalizedString(@"afternoon", @"")];
                    } else if(idleAM) {
                        idleString = [NSString stringWithFormat:@"  (%@)", NSLocalizedString(@"morning", @"")];
                    } else {
                        idleString = [NSString stringWithFormat:@"  (%@)", NSLocalizedString(@"afternoon", @"")];
                    }
                    NSAttributedString *idleTime = [[NSAttributedString alloc]
                            initWithString:idleString
                            attributes:@{
                                       NSFontAttributeName : [UIFont systemFontOfSize:12.f],
                                       NSForegroundColorAttributeName : [UIColor grayColor]
                            }];
                    [nameAndIdleTime appendAttributedString:idleTime];
                }
                lblName.attributedText = nameAndIdleTime;
            }
        } else {
            lblName.text = _expert_.name == nil ? [XXStringUtils emptyString] : _expert_.name.sourceString;
        }
        lblIntroduce.text = _expert_.shortIntroduce == nil ? [XXStringUtils emptyString] : _expert_.shortIntroduce;
        lblPost.text = _expert_.post == nil ? [XXStringUtils emptyString] : _expert_.post;
        if(![XXStringUtils isBlank:_expert_.imageUrl]) {
            [imgAvatar setImageWithURL:[NSURL URLWithString:_expert_.imageUrl] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR_IMAGE_NAME]];
        } else {
            imgAvatar.image = [UIImage imageNamed:DEFAULT_AVATAR_IMAGE_NAME];
        }
    } else {
        lblName.text = [XXStringUtils emptyString];
        lblIntroduce.text = [XXStringUtils emptyString];
        lblPost.text = [XXStringUtils emptyString];
        imgAvatar.image = [UIImage imageNamed:DEFAULT_AVATAR_IMAGE_NAME];
    }
}

- (void)setExpert:(Expert *)expert {
    _expert_ = expert;
    if(_expert_ != nil) {
        if(ExpertCellTypeIdleTime == self.expertCellType) {
            if(_expert_.name == nil) {
                lblName.text = [XXStringUtils emptyString];
            } else {
                NSMutableAttributedString *nameAndIdleTime = [[NSMutableAttributedString alloc] init];
                NSAttributedString *name = [[NSAttributedString alloc] initWithString:_expert_.name.sourceString
                  attributes:@{
                          NSFontAttributeName : [UIFont systemFontOfSize:18.f],
                          NSForegroundColorAttributeName : [UIColor blackColor]
                  }];
                [nameAndIdleTime appendAttributedString:name];
                lblName.attributedText = nameAndIdleTime;
            }
        } else {
            lblName.text = _expert_.name == nil ? [XXStringUtils emptyString] : _expert_.name.sourceString;
        }
        lblIntroduce.text = _expert_.shortIntroduce == nil ? [XXStringUtils emptyString] : _expert_.shortIntroduce;
        lblPost.text = _expert_.post == nil ? [XXStringUtils emptyString] : _expert_.post;
        if(![XXStringUtils isBlank:_expert_.imageUrl]) {
            [imgAvatar setImageWithURL:[NSURL URLWithString:_expert_.imageUrl] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR_IMAGE_NAME]];
        } else {
            imgAvatar.image = [UIImage imageNamed:DEFAULT_AVATAR_IMAGE_NAME];
        }
    } else {
        lblName.text = [XXStringUtils emptyString];
        lblIntroduce.text = [XXStringUtils emptyString];
        lblPost.text = [XXStringUtils emptyString];
        imgAvatar.image = [UIImage imageNamed:DEFAULT_AVATAR_IMAGE_NAME];
    }
}

@end
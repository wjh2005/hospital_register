//
// Created by Zhao yang on 3/19/14.
//

#import <Foundation/Foundation.h>
#import "Expert.h"

static CGFloat kExpertCellHeight = 88;

typedef enum {
    ExpertCellTypeNormal,
    ExpertCellTypeIdleTime
} ExpertCellType;

@interface ExpertCell : UITableViewCell

@property (nonatomic, strong) Expert *expert;
@property (nonatomic) ExpertCellType expertCellType;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier expertCellType:(ExpertCellType)expertCellType;

- (void)setExpert:(Expert *)expert withIdleDate:(ExpertIdleDate)expertIdleDate;

@end
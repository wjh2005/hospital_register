//
// Created by Zhao yang on 3/25/14.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface RegisterNumber : Entity

@property (nonatomic) NSInteger number;
@property (nonatomic, strong) NSDate *updateDate;

- (instancetype)initWithNumber:(NSInteger)number updateDate:(NSDate *)updateDate;

@end
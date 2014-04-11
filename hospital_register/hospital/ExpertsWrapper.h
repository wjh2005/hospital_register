//
//  ExpertsWrapper.h
//  hospital
//
//  Created by Zhao yang on 3/27/14.
//
//

#import <Foundation/Foundation.h>

@interface ExpertsWrapper : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *dateWellFormatString;
@property (nonatomic) NSInteger weekDay;
@property (nonatomic, strong) NSArray *experts;
@property (nonatomic) BOOL isToday;

@end

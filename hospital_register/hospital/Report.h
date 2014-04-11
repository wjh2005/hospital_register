//
// Created by Zhao yang on 3/30/14.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface Report : Entity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *reportUrl;
@property (nonatomic) BOOL hasRead;

@end
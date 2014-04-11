//
// Created by Zhao yang on 3/15/14.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Expert.h"
#import "SearchableString.h"

typedef enum {
   DepartmentTypeNormalOutpatient = 1 << 0,
   DepartmentTypeExpertOutpatient = 1 << 1,
   DepartmentTypeAll              = (1 << 0) | (1 << 1)
} DepartmentType;

@interface Department : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) SearchableString *name;
@property (nonatomic, strong) NSMutableArray *experts;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic) DepartmentType departmentType;
@property (nonatomic) float registerPrice;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name departmentType:(DepartmentType)departmentType;

- (NSArray *)idleExpertsForExpertIdleDate:(ExpertIdleDate)expertIdleDate;

- (BOOL)isNormalOutpatient;
- (BOOL)isExpertOutpatient;

@end
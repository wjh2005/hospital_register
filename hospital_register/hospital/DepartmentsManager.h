//
// Created by Zhao yang on 3/17/14.
//

#import <Foundation/Foundation.h>
#import "Department.h"

/*
 * It's a Singleton class.
 *
 * Outpatient departments and experts manager
 */
@interface DepartmentsManager : NSObject

/*
 * Get a Singleton Departments Manager
 */
+ (instancetype)manager;

/*
 * Departments list that includes normal outpatient && expert outpatient
 */
- (NSArray *)departments;

/*
 * Departments list for normal outpatient
 */
- (NSArray *)normalOutpatientDepartments;

/*
 * Departments list for expert outpatient
 */
- (NSArray *)expertOutpatientDepartments;

/*
 * Departments list with DepartmentType
 */
- (NSArray *)departmentsWithDepartmentType:(DepartmentType)departmentType;

/*
 * Department with identifier
 */
- (Department *)deparmentForIdentifier:(NSString *)departmentIdentifier;

/*
 * All experts
 */
- (NSArray *)experts;

/*
 * Experts list with department id
 */
- (NSArray *)expertsForDepartmentIdentifier:(NSString *)departmentIdentifier;

/*
 * Idle experts list with date
 */
- (NSArray *)idleExpertsForExpertIdleDate:(ExpertIdleDate)expertIdleDate;

@end
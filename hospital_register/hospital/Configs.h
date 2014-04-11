//
// Created by Zhao yang on 3/14/14.
//

#import <Foundation/Foundation.h>

const static NSString *kConfigContactPhoneNumber = @"config.contact.phonenumber";

@interface Configs : NSObject

@property (nonatomic, strong, readonly) NSString *appContactPhoneNumber;

+ (instancetype)defaultConfigs;

@end
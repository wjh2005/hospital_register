//
//  GlobalUserAppData.h
//  hospital
//
//  Created by Zhao yang on 4/16/14.
//
//

#import <Foundation/Foundation.h>

@interface GlobalUserAppData : NSObject

@property (nonatomic, strong) NSString *loginAccount;

+ (instancetype)current;
- (void)save;
- (void)clearAuthInfo;
- (BOOL)hasLogin;

@end

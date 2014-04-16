//
//  GlobalUserAppData.m
//  hospital
//
//  Created by Zhao yang on 4/16/14.
//
//

#import "GlobalUserAppData.h"
#import "XXStringUtils.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

static NSString * const GLOBAL_USER_APP_DATA_KEY       =     @"app.key";
static NSString * const LOGIN_ACCOUNT_KEY              =     @"app.account.key";

@implementation GlobalUserAppData

@synthesize loginAccount;

+ (instancetype)current {
    static GlobalUserAppData *globalUserAppData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalUserAppData = [[[self class] alloc] init];
    });
    return globalUserAppData;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *settings = [defaults objectForKey:GLOBAL_USER_APP_DATA_KEY];
        if(settings == nil) {
            //no settings file before
            self.loginAccount = [XXStringUtils emptyString];
        } else {
            //already have a setting file
            //need to fill object property
            self.loginAccount = [settings noNilStringForKey:LOGIN_ACCOUNT_KEY];
        }
    }
    return self;
}

- (void)save {
    @synchronized(self) {
        [self saveInternal];
    }
}

- (void)clearAuthInfo {
    @synchronized(self) {
        self.loginAccount = [XXStringUtils emptyString];
        [self saveInternal];
    }
}

- (void)saveInternal {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self toDictionary] forKey:GLOBAL_USER_APP_DATA_KEY];
    [defaults synchronize];
}

- (NSDictionary *)toDictionary {
    //convert self to a dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setMayBlankString:self.loginAccount forKey:LOGIN_ACCOUNT_KEY];
    return dictionary;
}

- (BOOL)hasLogin {
    return ![XXStringUtils isBlank:self.loginAccount];
}

@end

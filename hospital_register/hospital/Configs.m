//
// Created by Zhao yang on 3/14/14.
//

#import "Configs.h"
#import "NSDictionary+Extension.h"

@implementation Configs {
    NSMutableDictionary *_configs_;
}

@synthesize defaultTimeZone;

+ (instancetype)defaultConfigs {
    static Configs *configs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configs = [[[self class] alloc] init];
    });
    return configs;
}

- (id)init {
    self = [super init];
    if(self) {
        _configs_ = [NSMutableDictionary dictionary];
        [self loadFromDisk];
    }
    return self;
}


- (void)loadFromDisk {
    [self loadFromDiskInternal];
}

- (void)loadFromDiskInternal {
    @synchronized (self) {
        [_configs_ removeAllObjects];
        // will really load from disk later .
        self.defaultTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    }
}


@end
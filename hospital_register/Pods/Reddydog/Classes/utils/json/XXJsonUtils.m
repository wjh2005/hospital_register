//
//  XXJsonUtils.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXJsonUtils.h" 

@implementation XXJsonUtils

+ (id)createDictionaryOrArrayFromJsonData:(NSData *)jsonData {
    if(jsonData == nil) return nil;
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if(object != nil && error == nil) {
        return object;
    }
    return nil;
}

+ (NSData *)createJsonDataFromDictionary:(NSDictionary *)dictionary {
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error) return nil;
    return json;
}

+ (NSData *)createJsonDataFromArray:(NSArray *)array {
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if(error) return nil;
    return json;
}

+ (void)printJsonData:(NSData *)data {
    if(data != nil) {
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"[Printer:] %@", json);
    }
}

+ (void)printDictionaryAsJsonFormat:(NSDictionary *)dictionary {
    if(dictionary != nil) {
        NSData *_json_data_ = [[self class] createJsonDataFromDictionary:dictionary];
        [[self class] printJsonData:_json_data_];
    }
}

+ (void)printArrayAsJsonFormat:(NSArray *)array {
    if(array != nil) {
        NSData *_json_data_ = [[self class] createJsonDataFromArray:array];
        [[self class] printJsonData:_json_data_];
    }
}

@end

//
//  XXJsonUtils.h
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXJsonUtils : NSObject

+ (id)createDictionaryOrArrayFromJsonData:(NSData *)jsonData;

+ (NSData *)createJsonDataFromDictionary:(NSDictionary *)dictionary;
+ (NSData *)createJsonDataFromArray:(NSArray *)array;

+ (void)printJsonData:(NSData *)data;

+ (void)printDictionaryAsJsonFormat:(NSDictionary *)dictionary;
+ (void)printArrayAsJsonFormat:(NSArray *)array;

@end

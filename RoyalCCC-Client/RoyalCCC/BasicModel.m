//
//  BasicModel.m
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-12.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "BasicModel.h"
#import <objc/runtime.h>
@implementation BasicModel
- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            SEL se = NSSelectorFromString(key);
            if ([self respondsToSelector:se]) {
                [self setValue:obj forKey:key];
            }
        }];
    }
    return self;
}
- (void)update:(NSDictionary *)dict{
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        SEL se = NSSelectorFromString(key);
        if ([self respondsToSelector:se]) {
            [self setValue:obj forKey:key];
        }
    }];
}
- (NSString *)debugDescription{

    NSString *className = NSStringFromClass([self class]);
    
    const char *cClassName = [className UTF8String];
    
    Class theClass = objc_getClass(cClassName);
    unsigned count = 0;
    objc_property_t * a = class_copyPropertyList(theClass,&count);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for(int i = 0 ;i <count; i++){
        objc_property_t t = a[i];
        const char * ch = property_getName(t);
        NSString *str = [NSString stringWithUTF8String:ch];
        [dic setValue:[self valueForKey:str] forKey:str];
    }
    NSString *res = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
    return res;
}
- (NSString *)description{
    NSString *className = NSStringFromClass([self class]);
    
    const char *cClassName = [className UTF8String];
    
    Class theClass = objc_getClass(cClassName);
    unsigned count = 0;
    objc_property_t * a = class_copyPropertyList(theClass,&count);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for(int i = 0 ;i <count; i++){
        objc_property_t t = a[i];
        const char * ch = property_getName(t);
        NSString *str = [NSString stringWithUTF8String:ch];
        id value = [self valueForKey:str];
        [dic setValue:value forKey:str];
    }
    NSString *res = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
    return res;
}
@end

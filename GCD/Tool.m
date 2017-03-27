//
//  Tool.m
//  GCD
//
//  Created by Cnw on 2017/3/27.
//  Copyright © 2017年 Cnw. All rights reserved.
//

#import "Tool.h"

@implementation Tool

// 1. 设置全局变量
  static Tool * _instance;
// 2.重写alloc-->allocWithZone
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
// 第一种方法
//    @synchronized (self) { // 加锁防止多个线程共享一块资源,出现安全问题
//        if (_instance == nil) {
//            _instance = [super allocWithZone:zone];
//        }
//    }
//    return _instance;
    
// 第二种方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+(instancetype)shareTool
{
    return [[self alloc] init];
}
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}
@end

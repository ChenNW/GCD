//
//  Tool.h
//  GCD
//
//  Created by Cnw on 2017/3/27.
//  Copyright © 2017年 Cnw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject<NSCopying,NSMutableCopying>
/** 创建个类方法 */
+(instancetype)shareTool;
@end

//
//  NSObject+AGCoding.m
//  CodingExample
//
//  Created by 吴书敏 on 15/12/2.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import "NSObject+AGCoding.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

/*
 成员变量类型
 获取 实例变量的类型 方法
 NSLog(@"%s", ivar_getTypeEncoding(array[i]));
 */
static NSString *intType     = @"i"; // int
static NSString *integerType = @"q"; // long
static NSString *floatType   = @"f"; // float
static NSString *doubleType  = @"d"; // double
static NSString *boolType    = @"B"; // bool
static NSString *imageType   = @"UIImage"; // UIImage 类型
static NSString *stringType  = @"NSString"; // NSString 类型



// 定义属性字典，用来存储 属性名（key）  类型（value）
// 比如：               age            q
static NSMutableDictionary *proDic = nil;

@implementation NSObject (AGCoding)

// 归档是一个编码的过程
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // (1). 给字典分配空间
    proDic = [NSMutableDictionary dictionary];
    
    // (2). 获取类中所有实例变量
    unsigned int count; // 属性个数
    // 定义Ivar, copy
    Ivar *varArray = class_copyIvarList([self class], &count);
    
    // (3). for循环，获取属性名称 属性类型
    for (int i = 0; i < count; i++) {
        
        Ivar var = varArray[i];
        
        // 1. 获取属性名称 : age      name       image
        const char *cName = ivar_getName(var); // 属性名c字符串
        NSString *proName = [[NSString stringWithUTF8String:cName] substringFromIndex:1]; // OC字符串,并且去掉下划线 _
        
        // 2. 获取属性类型 : NSInteger NSString  UIImage 等类型
        const char *cType = ivar_getTypeEncoding(var); // 获取变量类型， c 字符串
        
        
        // 3. kvc 取值， 用于 （5） 中判断是否为 object 类型
        id value = [self valueForKey:proName];
        
        
        // 4. 把属性类型 从 c 转化为 oc 字符串
        // c 字符串 转化为 oc 字符串，会加上 @""
        // 属性类型
        NSString *proType = [NSString stringWithUTF8String:cType]; // oc 字符串
        
        
        // 5. 如果是OC类型数据，且不属于 NSNumber类，把 @"" 去掉
        if ([value isKindOfClass:[NSObject class]] && ![value isKindOfClass:[NSNumber class]]) {
            
            // 截取前： @"@\"NSString\""
            // 截取后： @\"NSString\"
            NSUInteger length = proType.length;
            proType = [proType substringWithRange:NSMakeRange(2, length - 3)];
            
        }
        
        
        // (4). proDic字典赋值 : 属性名（key)_属性类型（value）
        if (![proName isEqualToString:@"proDic"]) {
            
            [proDic setValue:proType forKey:proName];
        }
        
        
        // (5). 根据类型进行编码
        if ([proType isEqualToString:integerType]) { // integer 类型
            
            [aCoder encodeInteger:[value integerValue] forKey:proName];
        } else if ([proType isEqualToString:imageType]) { // image 类型
            
            [aCoder encodeDataObject:UIImagePNGRepresentation( value)];
        } else if ([proType isEqualToString:stringType]) { // string 类型
            
            [aCoder encodeObject:value forKey:proName];
        }
        // 若再有类型添加即可
        
        
    } // for 循环，获取结束
    
    
    // 释放varArray
    free(varArray);
}




// 反归档，是一个解码的过程。
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [self init];
    
    
    if (self) {
        
        //  解码，给 属性赋值
        // 注意： 根据属性类型解码，根据属性名 kvc 赋值
        
        // (1) 获取 字典中的属性名
        for (NSString *proName in proDic) {
            
            // (2) 获取 属性类型
            NSString *proType = proDic[proName];
            
            // (3) 解码， kvc 赋值
            if ([proType isEqualToString:integerType]) { // integer 类型
                
                // 解码
                NSInteger number = [aDecoder decodeIntegerForKey:proName];
                // 赋值
                [self setValue:@(number) forKey:proName];
                
            } else if ([proType isEqualToString:imageType]) { // image 类型
                
                UIImage *image = [UIImage imageWithData:[aDecoder decodeDataObject]];
                [self setValue:image forKey:proName];
                
            } else if ([proType isEqualToString:stringType]) { // string 类型
                
                NSString *string = [aDecoder decodeObjectForKey:proName];
                [self setValue:string forKey:proName];
               
            }
            
            // 若再有类型添加即可

            
        } // for 循环结束
        
        
        
    }
    
    
    return self;
}



@end

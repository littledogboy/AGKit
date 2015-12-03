//
//  Person.h
//  CodingExample
//
//  Created by 吴书敏 on 15/12/3.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface Person : NSObject

@property (nonatomic,assign) NSInteger age; // 年龄integer类型

@property (nonatomic,copy) NSString *name; // 姓名，oc类型

@property (nonatomic,strong) UIImage *image; // 图片，UIImage类型

@end

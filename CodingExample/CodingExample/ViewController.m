//
//  ViewController.m
//  CodingExample
//
//  Created by 吴书敏 on 15/12/2.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Student.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p1 = [[Person alloc] init];
    p1.age = 16;
    p1.name = @"吴书敏";
    p1.image = [UIImage imageNamed:@"avatar.jpg"];
    
    
    
    
    // 归档
    NSMutableData *data1 = [NSMutableData data];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data1];
    
//    NSString *varName =  varString(p1);
    
    [archiver encodeObject:p1 forKey:@"p1"];
    
    [archiver finishEncoding];
    
    //    NSLog(@"%@", data1);
//    NSLog(@"%@", varName);
    
    
    // 反归档
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
    
    Person *p2 = [unArchiver decodeObjectForKey:@"p1"];
    
    [unArchiver finishDecoding];
    
    NSLog(@"%@", p2);
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRectMake(100, 100, 200, 200))];
    imageView.image = p2.image;
    [self.view addSubview:imageView];
    
    NSLog(@"%ld", p2.age);
    NSLog(@"%@", p2.name);
    
    
    
    // 非内存归档反归档问题测试
    Person *p3 = [[Person alloc] init];
    p3.age = 13;
    p3.name = @"吴书敏3";
    p3.image = [UIImage imageNamed:@"avatar.jpg"];
    
    Person *p4 = [[Person alloc] init];
    p4.age = 14;
    p4.name = @"吴书敏4";
    p4.image = [UIImage imageNamed:@"avatar.jpg"];
    
    NSString *filePath3 = [NSHomeDirectory() stringByAppendingPathComponent:@"p3"];
    NSString *filePath4 = [NSHomeDirectory() stringByAppendingPathComponent:@"p4"];

    
    // 归档
//    [self encodingObject:p3 toFile:filePath3];
//    [self encodingObject:p4 toFile:filePath4];

    
    // 反归档
    p3 = [self decodingWithFile:filePath3];
    NSLog(@"%ld  %@ %@", p3.age, p3.name, p3.image);
    
    p4 = [self decodingWithFile:filePath4];
    NSLog(@"%ld  %@ %@", p4.age, p4.name, p4.image);
    
    
    
//     多模型归档反归档测试
    Student *stu1 = [[Student alloc] init];
    stu1.name = @"student1";
    stu1.gender = @"girl";
    
    NSString *filePath5 = [NSHomeDirectory() stringByAppendingPathComponent:@"stu1"];
//    [self encodingObject:stu1 toFile:filePath5];
    
    stu1 = [self decodingWithFile:filePath5];
    NSLog(@"%@ %@", stu1.name, stu1.gender);
    
    
    
    // 打印沙盒地址
    NSLog(@"%@", NSHomeDirectory());


    
    // Do any additional setup after loading the view, typically from a nib.
}



// 归档
- (void)encodingObject:(id )object toFile:(NSString *)filePath
{
    
    [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

// 反归档
- (id)decodingWithFile:(NSString *)filePath
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

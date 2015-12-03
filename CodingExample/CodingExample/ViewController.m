//
//  ViewController.m
//  CodingExample
//
//  Created by 吴书敏 on 15/12/2.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

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
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

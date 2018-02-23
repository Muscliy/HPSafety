//
//  ViewController.m
//  HPSafety
//
//  Created by LeeHu on 2/22/18.
//  Copyright © 2018 LeeHu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_queue_t _serialQueue = dispatch_queue_create("com.example.name", DISPATCH_QUEUE_SERIAL);            //异步立刻返回.放打印放入到后台执行
    dispatch_async(_serialQueue, ^{ NSLog(@"1");});            NSLog(@"2");            dispatch_async(_serialQueue, ^{
        sleep(2);
        
        NSLog(@"3");
        
    });            NSLog(@"4");
    //同步等待block的代码执行完.放打印放入到后台执行
    dispatch_sync(_serialQueue, ^{ NSLog(@"11");});            NSLog(@"12");            dispatch_sync(_serialQueue, ^{ NSLog(@"13");});            NSLog(@"14");
    dispatch_async(_serialQueue, ^{ NSLog(@"23");});
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

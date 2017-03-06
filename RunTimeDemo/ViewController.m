//
//  ViewController.m
//  RunTimeDemo
//
//  Created by lidaojian on 2017/3/1.
//  Copyright © 2017年 lidaojian. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Person *person = [[Person alloc] initWithUserName:@"小王"];
    [person logUserName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

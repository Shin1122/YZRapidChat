//
//  ViewController.m
//  YZRapidChat
//
//  Created by Shin on 2017/3/10.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import "ViewController.h"
#import "YZRapidChatViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 100, 100)];
    [but setTitle:@"hello" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:but];
    
    [but addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)change{
    
    YZRapidChatViewController *controller = [[YZRapidChatViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

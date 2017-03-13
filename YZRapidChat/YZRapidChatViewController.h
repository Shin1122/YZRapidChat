//
//  YZRapidChatViewController.h
//  YZRapidChat
//
//  Created by Shin on 2017/3/10.
//  Copyright © 2017年 Shin. All rights reserved.
//

// 聊天页面

#import <UIKit/UIKit.h>
#import "YZInputBar.h"


@interface YZRapidChatViewController : UIViewController

/**
 输入框
 */
@property (nonatomic, strong) YZInputBar *inputBar ;

/**
 聊天内容
 */
@property (nonatomic, strong) UITableView *chatTableView ;




@end

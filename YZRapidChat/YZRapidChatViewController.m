//
//  YZRapidChatViewController.m
//  YZRapidChat
//
//  Created by Shin on 2017/3/10.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import "YZRapidChatViewController.h"
#import "YZRapidChatCell.h"
#import "YZEmotionKeyboard.h"
#import "YYTextView+YZEmotion.h"
#import "UITextView+YZEmotion.h"

#define InputBarHeight 50
#define SCREENHEIGHT self.view.frame.size.height
#define SCREENWIDTH self.view.frame.size.width

@interface YZRapidChatViewController ()<UITableViewDelegate,UITableViewDataSource,YZInputBarDelegate>{
    
    NSInteger recordingTime;
    NSTimer *recordingTimer;
    
    
}


/**
 表情键盘
 */
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;

@end

@implementation YZRapidChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载视图
    [self setupViews];
    
    //键盘监听
    //键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
}

//加载视图
- (void)setupViews{
    
    //输入框
    _inputBar = ({
    
      YZInputBar *_ = [[YZInputBar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-InputBarHeight, SCREENWIDTH, InputBarHeight)];
        [self.view addSubview:_];
        _.delegate = self;
        _;
    });
    
    //聊天视图
    _chatTableView =({
    
        UITableView *_=[[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64-InputBarHeight) style:UITableViewStylePlain];
        _.delegate = self;
        _.dataSource = self;
        [self.view addSubview:_];
        _;
    
    
    });
    
}


/**
 开始录音的回调
 */
- (void)startRecording{
   
    recordingTime = 0;
    recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countRecordingTime) userInfo:nil repeats:YES];
    
}

/**
 结束录音的回调
 */
- (void)endRecording{
    if (recordingTimer) {
        [recordingTimer invalidate];
        recordingTimer = nil;
    }
    
}


/**
 开始记录录音时间
 */
- (void)countRecordingTime{
    
    recordingTime ++;
    
    NSLog(@"%ld", (long)recordingTime);
    if (recordingTime>=60) {
        
    }
    
}


#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    YZRapidChatCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[YZRapidChatCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    return  cell;
    
}

#pragma mark- tableview delegate




#pragma mark-  懒加载键盘
- (YZEmotionKeyboard *)emotionKeyboard{
    // 创建表情键盘
    if (_emotionKeyboard == nil) {
        
        YZEmotionKeyboard *emotionKeyboard = [YZEmotionKeyboard emotionKeyboard];
        
        emotionKeyboard.sendContent = ^(NSString *content){
            // 点击发送会调用，自动把文本框内容返回
            
            NSLog(@"%@",content);
        };
        
        _emotionKeyboard = emotionKeyboard;
        
        [_inputBar.textInputView becomeFirstResponder];
    }
    return _emotionKeyboard;
}

//点击表情按钮的点击事件
- (void)emojiKeyboardShow:(UIButton *)sender{
    
    if (sender.superview == _inputBar) {
        
        if (_inputBar.textInputView.inputView == nil) {
            _inputBar.textInputView.yz_emotionKeyboard = self.emotionKeyboard;
            [sender setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
            
        } else {
            _inputBar.textInputView.inputView = nil;
            [sender setImage:[UIImage imageNamed:@"emoji"] forState:UIControlStateNormal];
            [_inputBar.textInputView reloadInputViews];
            
        }
        
    }
}

//键盘弹出
- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    // 获取键盘弹出后的rect
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [_inputBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -50-keyboardRect.size.height , self.view.frame.size.width, 50)];
        [ _chatTableView setFrame:CGRectMake(0, 64 , self.view.frame.size.width, self.view.frame.size.height-64-50-keyboardRect.size.height)];
    }];
     
}
//键盘收起
- (void)keyboardWillHide:(NSNotification *)notification {
    
    // 获取通知信息字典
    NSDictionary* userInfo = [notification userInfo];
    
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [_inputBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -50, self.view.frame.size.width, 50)];
        
        [_chatTableView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-50)];
        
    }];
    

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  YZInputBar.h
//  YZRapidChat
//
//  Created by Shin on 2017/3/10.
//  Copyright © 2017年 Shin. All rights reserved.
//
//  聊天输入框 --图
#import <UIKit/UIKit.h>
#import "YYTextView.h"


typedef enum : NSUInteger {
    YZInputBarVoiceMode,        //语音模式
    YZInputBarTextMode,         //文字模式
} YZInputBarMode;



@protocol YZInputBarDelegate <NSObject>


/**
 开始录音
 */
- (void)startRecording;


/**
 结束录音
 */
- (void)endRecording;





/**
 展开表情键盘
 */
- (void)emojiKeyboardShow:(UIButton *)sender;

/**
 切换到录音
 */
//- (void)changeToRecordingState;




@end



/* 
 聊天输入框包含:
 1.输入框 UITextfield +placeholder
 2.发送按钮 UIButton 可以变成添加图片按钮,也可以
 3.语音按钮
 4.表情键盘按钮
 */

@interface YZInputBar : UIView

/**
 输入框
 */
@property (nonatomic, strong) UITextView *textInputView ;

/**
 发送/切换图片选择按钮
 */
@property (nonatomic, strong) UIButton *messageSendButton ;

/**
 切换成语音输入按钮
 */
@property (nonatomic, strong) UIButton *voiceButton ;

/**
 表情键盘按钮
 */
@property (nonatomic, strong) UIButton *enterEmojiButton ;

/**
 录音按钮
 */
@property (nonatomic, strong) UIButton *voiceRecordButton ;

/**
 Bar的模式
 */
@property (nonatomic, assign) YZInputBarMode inputBarMode ;


/**
 代理
 */
@property (nonatomic, weak) id <YZInputBarDelegate>delegate ;






@end

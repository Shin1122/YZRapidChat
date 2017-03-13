//
//  YZInputBar.m
//  YZRapidChat
//
//  Created by Shin on 2017/3/10.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import "YZInputBar.h"
#import "YZRecordingHUD.h"

#define Bar_Width self.frame.size.width     //栏宽
#define Bar_Height self.frame.size.height       //栏高
#define ButtonWidth 30

@interface YZInputBar (){
    
    //使用用了emoji键盘
    BOOL emojiKeyboardShow;
}

@end


@implementation YZInputBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpViews];
        self.inputBarMode = YZInputBarTextMode;
        
    }
    return self;
}


//视图布局
- (void)setUpViews{
    
    self.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.96 alpha:1.0];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0].CGColor;
    
    
    //1.语音按钮
    _voiceButton = ({
        UIButton *_ = [[UIButton alloc]initWithFrame:CGRectMake(5, 8, Bar_Height-16, Bar_Height-16)];
        [_ setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        
        [_ addTarget:self action:@selector(switchVoiceAndText:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_];
        _;
        
    });
    
    //2.发送/图片按钮
    _messageSendButton = ({
        UIButton *_=[[UIButton alloc]initWithFrame:CGRectMake(Bar_Width-10-ButtonWidth, 8, Bar_Height-16, Bar_Height-16)];
        [_ setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
        
        [self addSubview:_];
        _;
    });
    
    //3.表情按钮
    _enterEmojiButton = ({
        UIButton *_ = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_messageSendButton.frame)-8-ButtonWidth, 8, Bar_Height-16, Bar_Height-16)];
        [_ setImage:[UIImage imageNamed:@"emoji"] forState:UIControlStateNormal];
        [_ addTarget:self action:@selector(emojiKeyboardshow:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_];
        _;
    });
    
    //4.输入框
    _textInputView = ({
        UITextView *_=[[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_voiceButton.frame)+8, 8, CGRectGetMinX(_enterEmojiButton.frame)-8-(CGRectGetMaxX(_voiceButton.frame)+8), Bar_Height-16)];
        _.backgroundColor = [UIColor whiteColor];
        _.layer.masksToBounds = YES;
        _.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor;
        _.layer.borderWidth = 0.5;
        _.layer.cornerRadius = M_PI*2;
        _.font = [UIFont systemFontOfSize:18];
        [self addSubview:_];
        _;
    });
    
    //5.录音按钮
    _voiceRecordButton = ({
        UIButton *_ = [[UIButton alloc]initWithFrame:_textInputView.frame];
        [self addSubview:_];
        
        [_ setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_ setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_ setTitle:@"按住说话" forState:UIControlStateNormal];
        [_ setTitle:@"松开发送" forState:UIControlStateHighlighted];

        _.layer.cornerRadius = M_PI *2;
        _.layer.borderWidth = 0.8;
        _.layer.borderColor =[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor;
        _.backgroundColor =[UIColor colorWithRed:0.96 green:0.95 blue:0.96 alpha:1.0];
        _.hidden = YES;
        
        //长按录音
        [_ addTarget:self action:@selector(beginRecording:) forControlEvents:UIControlEventTouchDown];
        
        //松开完成
        [_ addTarget:self action:@selector(endRecording:) forControlEvents:UIControlEventTouchUpInside];
        
        //松开取消录音
        [_ addTarget:self action:@selector(cancelRecording:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        //滑出
        [_ addTarget:self action:@selector(dragExit:) forControlEvents:UIControlEventTouchDragExit];
        
        //滑回
        [_ addTarget:self action:@selector(dragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        _;
    
    });
    
}


/**
 长按开始录音

 @param sender 按钮
 */
- (void)beginRecording:(UIButton *)sender{
    
    [_delegate startRecording];
    
    [YZRecordingHUD show];
    
}


/**
 录音完成

 @param sender 按钮
 */
- (void)endRecording:(UIButton *)sender{
    
    [_delegate endRecording];
    
    [YZRecordingHUD dismissWithSuccess:@"发送成功"];
}


/**
 取消录音

 @param sender 按钮
 */
- (void)cancelRecording:(UIButton *)sender{
   
    [YZRecordingHUD dismissWithError:@"取消发送"];
    
    
}


/**
 滑到按钮外面 提醒

 @param sender 按钮
 */
- (void)dragExit:(UIButton *)sender{
    [YZRecordingHUD changeSubTitle:@"松开手指,取消发送"];
    
}


/**
 滑回到按钮上 提醒

 @param sender 按钮
 */
- (void)dragEnter:(UIButton *)sender{
    
    [YZRecordingHUD changeSubTitle:@"上滑手指,取消发送"];
}


- (void)emojiKeyboardshow:(UIButton *)sender{
    
    [_delegate emojiKeyboardShow:sender];
    
    if (_inputBarMode == YZInputBarVoiceMode) {
        _inputBarMode = YZInputBarTextMode;
        _voiceRecordButton.hidden = YES;
        [_textInputView becomeFirstResponder];
        [_voiceButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        
    }
    
}

/**
 切换语音和文字
 @param sender 按钮
 */
- (void)switchVoiceAndText:(UIButton *)sender{
    //切成语音模式
    if (_inputBarMode == YZInputBarTextMode) {
        [sender setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        _inputBarMode = YZInputBarVoiceMode;
        _voiceRecordButton.hidden = NO;
        [_textInputView resignFirstResponder];
        //切成文本模式
    }else if (_inputBarMode == YZInputBarVoiceMode){
        [sender setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        _inputBarMode = YZInputBarTextMode;
        _voiceRecordButton.hidden = YES;
        [_textInputView becomeFirstResponder];
    }else{
        
    }
    
}



@end

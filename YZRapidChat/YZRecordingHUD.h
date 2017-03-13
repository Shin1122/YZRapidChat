//
//  YZRecordingHUD.h
//  YZRapidChat
//
//  Created by Shin on 2017/3/13.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    YZRapidChatStartRecoding = 0,       //开始录音的状态
    
    YZRapidChatWillCancelRecording, //松开即将取消的状态
    
    YZRapidChatCancelRecording,     //取消发送的状态
    
    YZRapidChatWrongRecording       //时间太短
    
    
} YZRapidChatRecodingState;

@interface YZRecordingHUD : UIView

@property (nonatomic, strong) UILabel *subTitleLabel;

@property(nonatomic,strong) UIView *HUDView;

/**
 状态图片
 */

@property(nonatomic,strong) UIImageView *statusImageView ;


/**
 是否可以监听音量()
 */
@property(nonatomic,assign) BOOL canHearVolum ;



+ (void)show;

+ (void)dismissWithSuccess:(NSString *)str;

+ (void)dismissWithError:(NSString *)str;

+ (void)changeSubTitle:(NSString *)str;



@end

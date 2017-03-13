//
//  YYTextView+YZEmotion.m
//  YZRapidChat
//
//  Created by Shin on 2017/3/13.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import "YYTextView+YZEmotion.h"

@implementation YYTextView (YZEmotion)

- (void)setYz_emotionKeyboard:(YZEmotionKeyboard *)yz_emotionKeyboard
{
    self.inputView = yz_emotionKeyboard;
    [self reloadInputViews];
    yz_emotionKeyboard.textView = self;
    
}
- (YZEmotionKeyboard *)yz_emotionKeyboard
{
    return (YZEmotionKeyboard *)self.inputView;
}

@end

//
//  WPPopClockAddTagView.m
//  WPHealth
//
//  Created by justone on 15/6/2.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPPopClockAddTagView.h"

#define kMaxLength 80
#define kMaxCharLength 80

#define IMAGE_WIDTH     251.
#define IMAGE_HEIGHT    421.

@interface WPPopClockAddTagView () <UIGestureRecognizerDelegate,
UITextViewDelegate>

@property (nonatomic, strong) UIImageView *popImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITextView *contentTextView ;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, strong) NSString *default_content;

@end

@implementation WPPopClockAddTagView

#pragma mark - custom Methods

- (void)configSubviewsFrame
{
    self.iconImageView.frame = CGRectMake(self.popImageView.frame.origin.x+(self.popImageView.frame.size.width/2-40./2), self.popImageView.frame.origin.y+30, 40., 40.);
    self.contentTextView.frame = CGRectMake(self.popImageView.frame.origin.x+30., self.popImageView.frame.origin.y+110., self.popImageView.frame.size.width-30.*2, 200.);
    self.cancelBtn.frame = CGRectMake(self.popImageView.frame.origin.x+25., self.contentTextView.frame.origin.y+self.contentTextView.frame.size.height+29., 82, 40.);
    self.finishBtn.frame = CGRectMake(self.cancelBtn.frame.origin.x+self.cancelBtn.frame.size.width+5., self.contentTextView.frame.origin.y+self.contentTextView.frame.size.height+30., 116, 38.);
}

#pragma mark - keyboard

- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    //获取键盘高度与动画时间
    //CGSize keybordSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    double dur = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (dur<0.25) {
        dur = 0.25;
    }
    
    [UIView animateWithDuration:dur animations:^(void){
        
        self.popImageView.frame = CGRectMake((self.bounds.size.width-IMAGE_WIDTH)/2, (self.bounds.size.height-IMAGE_HEIGHT)/2-130, IMAGE_WIDTH, IMAGE_HEIGHT);

        [self configSubviewsFrame];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillDisappear:(NSNotification *) notification
{
    NSDictionary* info = [notification userInfo];
    double dur = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (dur<0.25) {
        dur = 0.25;
    }
    
    [UIView animateWithDuration:dur animations:^(void){
        
        self.popImageView.frame = CGRectMake((self.bounds.size.width-IMAGE_WIDTH)/2, (self.bounds.size.height-IMAGE_HEIGHT)/2, IMAGE_WIDTH, IMAGE_HEIGHT);
        
        [self configSubviewsFrame];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITextFieldTextDidChangeNotification

-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    
    NSString *toBeString = textView.text;
    
    NSArray *currentArray = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentArray firstObject];
    NSString *lang = [current primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
                [APP_DELEGATE showInfoPanelInView:APP_DELEGATE.window title:[NSString stringWithFormat:@"最多只允许输入%d个汉字",kMaxLength] hideAfter:1];
            }
        } else {
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxCharLength) {
            textView.text = [toBeString substringToIndex:kMaxCharLength];
            [APP_DELEGATE showInfoPanelInView:APP_DELEGATE.window title:[NSString stringWithFormat:@"最多只允许输入%d个字符",kMaxCharLength] hideAfter:1];
        }
    }
}

#pragma mark - buttonAction

- (void)handleCancelBtnEvent:(UIButton *)aBtn
{
    [self dismiss];
}

- (void)handleFinishBtnEvent:(UIButton *)aBtn
{
    if (self.finishedBlock) {
        self.finishedBlock(self.contentTextView.text);
    }
    
    [self dismiss];
}

#pragma mark - GestureRecognizer

- (void)handletap
{
    [self dismiss];
}

#pragma mark - init

- (void)createGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletap)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (id)initWithOldTag:(NSString *)aOldTag
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, WPMAINSCREEN_SIZE.width, WPMAINSCREEN_SIZE.height)];
    if ( self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.default_content = aOldTag;
        
        self.popImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-IMAGE_WIDTH)/2, (self.bounds.size.height-IMAGE_HEIGHT)/2, IMAGE_WIDTH, IMAGE_HEIGHT)];
        self.popImageView.image = [[UIImage imageNamed:@"add_tag_bg.png"] stretchableImageWithLeftCapWidth:30. topCapHeight:30.];
        self.popImageView.userInteractionEnabled = YES;
        [self addSubview:self.popImageView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+(self.popImageView.frame.size.width/2-40./2), self.popImageView.frame.origin.y+30, 40., 40.)];
        self.iconImageView.image = [UIImage imageNamed:@"add_tag_icon.png"];
        self.iconImageView.userInteractionEnabled = YES;
        [self addSubview:self.iconImageView];
        
        self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+30., self.popImageView.frame.origin.y+110., self.popImageView.frame.size.width-30.*2, 200.)];
        [self.contentTextView setFont:[UIFont boldSystemFontOfSize:13.]];
        self.contentTextView.textAlignment = NSTextAlignmentLeft;
        self.contentTextView.backgroundColor = [UIColor clearColor];
        self.contentTextView.textColor = [UIColor lightGrayColor];
        self.contentTextView.text = self.default_content;
        self.contentTextView.delegate = self;
        
        [self addSubview:self.contentTextView];
        
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.popImageView.frame.origin.x+25., self.contentTextView.frame.origin.y+self.contentTextView.frame.size.height+29., 82, 40.)];
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel_btn.png"] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(handleCancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];
        
        self.finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cancelBtn.frame.origin.x+self.cancelBtn.frame.size.width+5., self.contentTextView.frame.origin.y+self.contentTextView.frame.size.height+30., 116, 38.)];
        [self.finishBtn setBackgroundImage:[UIImage imageNamed:@"add_finish_btn.png"] forState:UIControlStateNormal];
        [self.finishBtn addTarget:self action:@selector(handleFinishBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.finishBtn];
        
        [self createGestureRecognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)
                                                    name:@"UITextViewTextDidChangeNotification"
                                                  object:self.contentTextView];
    }
    return self;
}

- (void)show
{
    self.alpha = 0.0;
    [APP_DELEGATE.window addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]]) {
        [self.contentTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.default_content] ||
        textView.text == nil) {
        textView.textColor = [UIColor blackColor];
        textView.text = nil;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        self.contentTextView.text = self.default_content;
        self.contentTextView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

@end

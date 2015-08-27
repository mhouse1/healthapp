//
//  WPForgetPasswordViewController.m
//  WPHealthBank
//
//  Created by justone on 14-11-4.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPForgetPasswordViewController.h"
#import "WPLoginViewController.h"
#define kMaxLength 24
#define kMaxCharLength 24

@interface WPForgetPasswordViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WPForgetPasswordViewController

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"忘记密码";//forgot password
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - UITextFieldTextDidChangeNotification

-(void)textFieldEditChanged:(NSNotification *)obj
{
    NSLog(@"entered something into forget password field");
    UITextView *textView = (UITextView *)obj.object;
    NSLog(@"textView %@",textView.text);
    NSString *toBeString = textView.text;
    NSArray *currentArray = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentArray firstObject];
    NSString *lang = [current primaryLanguage]; // 键盘输入模式 keyboard input mode
    if ([lang isEqualToString:@"zh-Hans"]) {
        NSLog(@" chinese input mode");
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        //Simplified Chinese input , including English alphabet , fitness Wubi, English handwriting

        UITextRange *selectedRange = [textView markedTextRange];
        // 获取高亮部分
        // get whats highlighted
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            //No highlight the word , then the word has been inputted word count and restrictions
            if (toBeString.length > kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
                [APP_DELEGATE showInfoPanelInView:self.view
                                            //内容字数不能超过%d个汉字
                                            //Content words can not exceed % d characters
                                            title:[NSString stringWithFormat:@"内容字数不能超过%d个汉字",kMaxLength]
                                        hideAfter:2];
            }
        } else {
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            // the letters highlighted set limit on letters
        }
    } else {
        //non chinese input mode, will need to adjust kMaxCharLength to what we think should be the limit
        //of characters to input
        if (toBeString.length > kMaxCharLength) {
            textView.text = [toBeString substringToIndex:kMaxCharLength];
            NSLog(@"cannot exceed %d chars",kMaxCharLength);
            [APP_DELEGATE showInfoPanelInView:self.view
                                        //Content words can not exceed % d special characters
                                        //eg: ~!@#$%^&*()_+
                                        title:[NSString stringWithFormat:@"内容字数不能超过%d个字符 words cannot exceed x chars",kMaxCharLength]
                                    hideAfter:2];
        }
    }
    
    

}

#pragma mark - buttonAction

- (IBAction)handleFindPwdBtnEvent:(id)sender
{
    NSLog(@"click find password button");
    [self.navigationController popViewControllerAnimated:YES];
    self.view=nil;
    [self willMoveToParentViewController:nil];
    //[self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)handleBackBtnEvent:(id)sender
{
    NSLog(@"mhouse back to last vc");
    //[APP_DELEGATE setRootTabBarController];
    //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
}


#pragma makr - UITapGestureRecognizer

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)aTapGestureRecognizer
{
    [self.accountTextField resignFirstResponder];
}

#pragma mark - loadView

- (void)createTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
}

- (void)configNavigationView
{
    NSLog(@"configuring navigation view");

    //self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTapGestureRecognizer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.accountTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"forgot password view will appear");
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.accountTextField];
    

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self handleTapGestureRecognizer:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];

    //[self.navigationController popViewControllerAnimated:YES];
    //pop to desired view
//    WPLoginViewController *baseTabBarVC = [[WPLoginViewController alloc] init];
//    [self.navigationController popToViewController:baseTabBarVC animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ( [gestureRecognizer.view isKindOfClass:[UIButton class]]
        || [gestureRecognizer.view isKindOfClass:[UITextField class]]) {
        return NO;
    }
    return YES;
}

@end

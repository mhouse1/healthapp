//
//  WPRegisterViewController.m
//  WPHealthBank
//
//  Created by justone on 14-10-27.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPRegisterViewController.h"
#import "WPRegisterCommand.h"

#define kMaxLength 24
#define kMaxCharLength 24

@interface WPRegisterViewController ()<UITextFieldDelegate,
UIGestureRecognizerDelegate>

@end

@implementation WPRegisterViewController

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"注 册";//registration
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - keyboard

- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    //获取键盘高度与动画时间
    //get keyboard height and animation time
    CGSize keybordSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    double dur = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (dur<0.25) {
        dur = 0.25;
    }
    
    [UIView animateWithDuration:dur animations:^(void) {
        
        self.bgScrollView.frame = CGRectMake(0.0,
                                             self.bgScrollView.frame.origin.y,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height-keybordSize.height-self.bgScrollView.frame.origin.y);
        
        self.bgScrollView.contentOffset = CGPointMake(0.0, 100.0);
        
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
        
        self.bgScrollView.frame = CGRectMake(0.0,
                                             self.bgScrollView.frame.origin.y,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height);
        
        self.bgScrollView.contentOffset = CGPointMake(0.0, 0.0);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITextFieldTextDidChangeNotification

-(void)textFieldEditChanged:(NSNotification *)obj
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
                [APP_DELEGATE showInfoPanelInView:self.view
                                            title:[NSString stringWithFormat:@"内容字数不能超过%d个汉字",kMaxLength]
                                        hideAfter:2];
            }
        } else {
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxCharLength) {
            textView.text = [toBeString substringToIndex:kMaxCharLength];
            [APP_DELEGATE showInfoPanelInView:self.view
                                        title:[NSString stringWithFormat:@"内容字数不能超过%d个字符",kMaxCharLength]
                                    hideAfter:2];
        }
    }
}

#pragma mark - custom Methods

- (NSString *)dateToStringDate:(NSDate *)Date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:Date];
    destDateString = [destDateString substringToIndex:10];
    
    return destDateString;
}

- (void)resignAllFirstResponder
{
    [self.accountTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    [self.enterPwdTextField resignFirstResponder];
}

#pragma mark - buttonAction

- (IBAction)handleRegisterBtnEvent:(id)sender
{
    if ([self.accountTextField.text length] == 0) {
        [APP_DELEGATE showInfoPanelInView:self.view title:@"您好像没有输入手机号/邮箱哦？" hideAfter:2];
        return;
    }
    if (!isValidateEmail(self.accountTextField.text)) {
        if (!isValidatePhoneNumber(self.accountTextField.text)) {
            [APP_DELEGATE showInfoPanelInView:self.view title:@"您的手机号/邮箱格式不正确，请核对后重新输入" hideAfter:2];
            return;
        }
    }
    if ([self.pwdTextField.text length] == 0 || [self.enterPwdTextField.text length] == 0) {
        [APP_DELEGATE showInfoPanelInView:self.view title:@"您还未输入密码哦！" hideAfter:2];
        return;
    }
    if (!isValidatePassWord(self.pwdTextField.text) || !isValidatePassWord(self.enterPwdTextField.text)) {
        [APP_DELEGATE showInfoPanelInView:self.view title:@"密码应为4-16位不含空格、单引号、双引号的字符组合" hideAfter:2];
        return;
    }
    if (![self.pwdTextField.text isEqualToString:self.enterPwdTextField.text]) {
        [APP_DELEGATE showInfoPanelInView:self.view title:@"两次输入的密码不一致，请重新核对" hideAfter:2];
        return;
    }
    
    WPRegisterCommand *registerCmd = [[WPRegisterCommand alloc] init];
    
    registerCmd.nickName = @"";
    registerCmd.firstName = @"";
    registerCmd.lastName = @"";
    registerCmd.username = self.accountTextField.text;
    registerCmd.password = self.enterPwdTextField.text;
    registerCmd.height = @(0);
    registerCmd.weight = @(0);
    registerCmd.birthday = @"";
    registerCmd.address = @"";
    registerCmd.avatar = @"";
    registerCmd.scope = @"";

    [registerCmd postCommandWithSuccess:^(NSDictionary *aResponseDict){
        NSLog(@"aResponseDict: %@", aResponseDict);
        
        if (aResponseDict == nil) {
            [APP_DELEGATE showInfoPanelInView:self.view
                                        title:@"注册失败：未返回数据"
                                    hideAfter:2];
            return ;
        }
        
        NSString *token = [aResponseDict objectForKey:@"access_token"];
        if (token) {
            [[WPGlobalConfig shared] setToken:token];
        }
        
        NSDictionary *profileDict = [aResponseDict objectForKey:@"user"];
        if (profileDict) {
            [[WPContentService shared] contentCurrentUser].user_id = [NSString stringWithFormat:@"%@", [profileDict objectForKey:@"id"]];
            [[WPContentService shared] contentCurrentUser].user_name = [NSString stringWithFormat:@"%@", [profileDict objectForKey:@"username"]];
            [[WPContentService shared] contentCurrentUser].password = self.pwdTextField.text;
            
            [[WPContentService shared] contentCurrentUser].user_nick = [profileDict objectForKey:@"nickName"];
            [[WPContentService shared] contentCurrentUser].icon = @"http://h.hiphotos.baidu.com/image/pic/item/d52a2834349b033b9c6e45d017ce36d3d439bdd2.jpg";
            [[WPContentService shared] contentCurrentUser].gender = [[profileDict objectForKey:@"gender"] integerValue] < 0?@"1":[profileDict objectForKey:@"gender"];
            [[WPContentService shared] contentCurrentUser].height = [NSString stringWithFormat:@"%@", [[profileDict objectForKey:@"height"] integerValue] < 0?@"170":[profileDict objectForKey:@"height"]];
            [[WPContentService shared] contentCurrentUser].weight = [NSString stringWithFormat:@"%@", [[profileDict objectForKey:@"weight"] integerValue] < 0?@"65":[profileDict objectForKey:@"weight"]];
            [[WPContentService shared] contentCurrentUser].area =  [profileDict objectForKey:@"area"];
            [[WPContentService shared] contentCurrentUser].birthday = [profileDict objectForKey:@"birthday"];
            
            if ([[[WPContentService shared] contentCurrentUser].area length] > 0) {
                [[WPGlobalConfig shared] setWaitReplacedCity:[[WPContentService shared] contentCurrentUser].area];
            } else {
                [[WPGlobalConfig shared] setWaitReplacedCity:@""];
            }
        }
        
        NSArray *planArray = [aResponseDict objectForKey:@"plans"];
        if (planArray) {
            // 登陆后需将计划列表插入本地数据库表
            for (NSInteger index = 0; index < [planArray count]; index++) {
                NSDictionary *planDict = [planArray objectAtIndex:index];
                WPContentPlan *contentPlan = convertToContentPlan(planDict);
                contentPlan.user_id = [[WPContentService shared] contentCurrentUser].user_id;
                [[WPContentDB shared] insertContentPlan:contentPlan];
            }
        }
        
        [[WPContentService shared] contentCurrentUser].continueDayCount = @"0";
        [[WPContentService shared] contentCurrentUser].lastWorkDate = WPCurrentDateString();
        [[WPContentService shared] contentCurrentUser].coinCountOfEveryDay = @"";
        [[WPContentService shared] contentCurrentUser].totalCoinCount = @"";
        
        [[WPContentService shared] contentCurrentUser].wakeUpAndSleepSwitch = @"1";
        [[WPContentService shared] contentCurrentUser].waterSwitch = @"0";
        [[WPContentService shared] contentCurrentUser].eatSwitch = @"1";
        [[WPContentService shared] contentCurrentUser].sportsSwitch = @"0";
        [[WPContentService shared] contentCurrentUser].caredPersonSwitch = @"1";
        
        [[WPContentService shared] insertContentCurrentUser];
        
        [[WPContentService shared] startTimer];
        
        [APP_DELEGATE setRootTabBarController];
        
    } failure:^(NSError *aError){
        NSDictionary *userInfoDict = [aError userInfo];
        NSString *localizedRecoverySuggestion = [userInfoDict objectForKey:@"NSLocalizedRecoverySuggestion"];
        NSDictionary *localizedRecoverySuggestionDict = WPJsonStringToDictionary(localizedRecoverySuggestion);
        NSString *message = [localizedRecoverySuggestionDict objectForKey:@"message"];
        
        [APP_DELEGATE showInfoPanelInView:self.view
                                    title:[NSString stringWithFormat:@"注册失败：%@", message]
                                hideAfter:2];
    }];
}

- (IBAction)handleWeiBoBtnEvent:(id)sender
{
    
}

- (IBAction)handleWeiXinBtnEvent:(id)sender
{
    
}

#pragma makr - UITapGestureRecognizer

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)aTapGestureRecognizer
{
    [self resignAllFirstResponder];
}

#pragma mark - loadView

- (void)createTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    tap.delegate = self;
    
    [self.bgScrollView addGestureRecognizer:tap];
}

- (void)configNavigationView
{
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configNavigationView];
    
    self.bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-64);
    
    [self createTapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.accountTextField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.pwdTextField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.enterPwdTextField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!IS_RETINA_SCREEN) {
        self.bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self handleTapGestureRecognizer:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.accountTextField.textColor = [UIColor blackColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.accountTextField.text length] == 0) {
        [APP_DELEGATE showInfoPanelInView:self.view title:@"您好像没有输入手机号/邮箱哦？" hideAfter:2];
        return;
    }
    if (!isValidateEmail(self.accountTextField.text)) {
        if (!isValidatePhoneNumber(self.accountTextField.text)) {
            [APP_DELEGATE showInfoPanelInView:self.view title:@"您的手机号/邮箱格式不正确，请核对后重新输入" hideAfter:2];
            return;
        }
    }
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

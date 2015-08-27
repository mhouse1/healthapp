//
//  WPRegisterViewController.h
//  WPHealthBank
//
//  Created by justone on 14-10-27.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPRegisterViewController : WPBaseViewController

@property (nonatomic, strong) IBOutlet UIScrollView *bgScrollView;

@property (nonatomic, strong) IBOutlet UITextField *accountTextField;
@property (nonatomic, strong) IBOutlet UITextField *pwdTextField;
@property (nonatomic, strong) IBOutlet UITextField *enterPwdTextField;

@property (nonatomic, strong) IBOutlet UIButton *registerBtn;

- (IBAction)handleRegisterBtnEvent:(id)sender;

- (IBAction)handleWeiBoBtnEvent:(id)sender;

- (IBAction)handleWeiXinBtnEvent:(id)sender;

@end

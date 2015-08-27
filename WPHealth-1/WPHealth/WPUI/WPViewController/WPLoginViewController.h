//
//  WPLoginViewController.h
//  WPHealthBank
//
//  Created by justone on 14-10-27.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPLoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *bgScrollView;

@property (nonatomic, strong) IBOutlet UITextField *accountTextField;
@property (nonatomic, strong) IBOutlet UITextField *pwdTextField;

@property (nonatomic, strong) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) IBOutlet UIButton *forgetPwdBtn;
@property (nonatomic, strong) IBOutlet UIButton *registerBtn;

- (IBAction)handleLoginBtnEvent:(id)sender;

- (IBAction)handleForgetPwdBtnEvent:(id)sender;

- (IBAction)handleRegisterBtnEvent:(id)sender;

@end

//
//  WPForgetPasswordViewController.h
//  WPHealthBank
//
//  Created by justone on 14-11-4.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import "WPBaseViewController.h"


@interface WPForgetPasswordViewController : WPBaseViewController

@property (nonatomic, strong) IBOutlet UITextField *accountTextField;
@property (nonatomic, strong) IBOutlet UIButton *findPwdBtn;
@property (nonatomic, strong) IBOutlet UIButton *backBtnFp;

- (IBAction)handleFindPwdBtnEvent:(id)sender;

- (IBAction)handleBackBtnEvent:(id)sender;

@end

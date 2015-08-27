//
//  WPLittleSaidViewController.m
//  WPHealth
//
//  Created by justone on 15/5/29.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPLittleSaidViewController.h"

@interface WPLittleSaidViewController ()

@property (strong, nonatomic) UIWebView *contentWebView;

@end

@implementation WPLittleSaidViewController

#pragma mark - loadView

- (void)createContentWebView
{
    self.contentWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    
    NSURL *url = [NSURL URLWithString:@"http://www.youku.com"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.contentWebView loadRequest:request];
    
    [self.view addSubview:self.contentWebView];
    [self.contentWebView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackItem];
    self.title = @"点点说";
    
    [self createContentWebView];
}

@end

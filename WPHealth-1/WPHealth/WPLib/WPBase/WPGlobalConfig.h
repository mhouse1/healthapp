//
//  WPGlobalConfig.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WPBASEURL   @"https://jiankangdianer.azure-mobile.net"//"http://52.4.12.26:8888"

@interface WPGlobalConfig : NSObject

+ (WPGlobalConfig *)shared;

// 服务器返回的token
- (void)setToken:(NSString *)aToken;

- (NSString *)token;

// 需上传服务器的备用的token
- (void)setAuthorization:(NSString *)aAuthorization;

- (NSString *)authorization;

// 推送需上传服务器的设备时区
- (void)setDeviceSystemTimeZone:(NSString *)aSystemTimeZone;

- (NSString *)deviceSystemTimeZone;

// 推送需上传服务器的deviceToken
- (void)setDeviceToken:(NSString *)aDeviceToken;

- (NSString *)deviceToken;

// 推送需上传服务器的deviceToken是否需要重新注册
- (void)setDeviceTokenNeedRegister:(NSString *)aNeedRegister;

- (NSString *)deviceTokenNeedRegister;

// 需要替换城市
- (void)setNeedReplaceCity:(NSString *)aNeedReplaceCity;

- (NSString *)needReplaceCity;

// 等待被替换的城市
- (void)setWaitReplacedCity:(NSString *)aWaitReplacedCity;

- (NSString *)waitReplacedCity;

@end

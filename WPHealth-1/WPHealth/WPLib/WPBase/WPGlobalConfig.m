//
//  WPGlobalConfig.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPGlobalConfig.h"

@implementation WPGlobalConfig
{
    NSString *_token;
    NSString *_authorization;
    NSString *_deviceSystemTimeZone;
    NSString *_deviceToken;
    NSString *_deviceTokenNeedRegister;
    NSString *_needReplaceCity;
    NSString *_waitReplacedCity;
}

+ (WPGlobalConfig *)shared
{
    static WPGlobalConfig *globalConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalConfig = [[WPGlobalConfig alloc] init];
    });
    return globalConfig;
}

- (id)init
{
    self = [super init];
    if (self) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        _authorization = [[NSUserDefaults standardUserDefaults] objectForKey:@"authorization"];
        _deviceSystemTimeZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceSystemTimeZone"];
        _deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        _deviceTokenNeedRegister = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceTokenNeedRegister"];
        _needReplaceCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"needReplaceCity"];
        _waitReplacedCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"waitReplacedCity"];
    }
    return self;
}

- (void)setToken:(NSString *)aToken
{
    _token = aToken;
    
    [[NSUserDefaults standardUserDefaults] setObject:aToken forKey:@"token"];
}

- (NSString *)token
{
    return _token;
}

// 需上传服务器的备用的token
- (void)setAuthorization:(NSString *)aAuthorization
{
    _authorization = aAuthorization;
    
    [[NSUserDefaults standardUserDefaults] setObject:aAuthorization forKey:@"authorization"];
}

- (NSString *)authorization
{
    return _authorization;
}

- (void)setDeviceSystemTimeZone:(NSString *)aSystemTimeZone
{
    _deviceSystemTimeZone = aSystemTimeZone;
    
    [[NSUserDefaults standardUserDefaults] setObject:aSystemTimeZone forKey:@"deviceSystemTimeZone"];
}

- (NSString *)deviceSystemTimeZone
{
    return _deviceSystemTimeZone;
}

- (void)setDeviceToken:(NSString *)aDeviceToken
{
    _deviceToken = aDeviceToken;
    
    [[NSUserDefaults standardUserDefaults] setObject:aDeviceToken forKey:@"deviceToken"];
}

- (NSString *)deviceToken
{
    return _deviceToken;
}

- (void)setDeviceTokenNeedRegister:(NSString *)aNeedRegister
{
    _deviceTokenNeedRegister = aNeedRegister;
    
    [[NSUserDefaults standardUserDefaults] setObject:aNeedRegister forKey:@"deviceTokenNeedRegister"];
}

- (NSString *)deviceTokenNeedRegister
{
    return _deviceTokenNeedRegister;
}

- (void)setNeedReplaceCity:(NSString *)aNeedReplaceCity
{
    _needReplaceCity = aNeedReplaceCity;
    
    [[NSUserDefaults standardUserDefaults] setObject:aNeedReplaceCity forKey:@"needReplaceCity"];
}

- (NSString *)needReplaceCity
{
    return _needReplaceCity;
}

- (void)setWaitReplacedCity:(NSString *)aWaitReplacedCity
{
    _waitReplacedCity = aWaitReplacedCity;
    
    [[NSUserDefaults standardUserDefaults] setObject:aWaitReplacedCity forKey:@"waitReplacedCity"];
}

- (NSString *)waitReplacedCity
{
    return _waitReplacedCity;
}

@end

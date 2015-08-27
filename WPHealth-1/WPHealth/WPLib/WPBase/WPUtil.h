//
//  WPUtil.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <Foundation/Foundation.h>

// 当前时间
double WPCurrentTime(void);

// 当前时间 @"MM-dd HH:mm:ss"
NSString *WPCurrentTimeString(void);

// 当前日期 @"yyyy-MM-dd"
NSString *WPCurrentDateString(void);

// 当前年份 @"yyyy"
NSString *WPCurrentYearString(void);

// 计算某一日期距离今天当前时间的秒数 aTimeStringFormat可以形如：@"yyyy-MM-dd"
NSInteger numberOfSecondsFromTodayByTime(NSString *aDate, NSString*aTimeStringFormat);

// 计算某一日期距离今天当前时间的分钟数 aTimeStringFormat可以形如：@"yyyy-MM-dd"
NSInteger numberOfMinutesFromTodayByTime(NSString *aDate, NSString*aTimeStringFormat);

// 计算某一日期距离今天当前时间的天数 aTimeStringFormat可以形如：@"yyyy-MM-dd"
NSInteger numberOfDaysFromTodayByTime(NSString *aDate, NSString*aTimeStringFormat);

// json 转 dictionary
NSDictionary *WPJsonStringToDictionary(NSString *aJsonString);

// NSDictionary to jsonString || 对象转json格式
NSString *WPDataToJsonString(id aObject);

// url编码
NSString *WPEncodeURL(NSString*aUnescapedString);

// 验证邮箱格式是否合法
BOOL isValidateEmail(NSString *aEmail);

// 验证手机号格式是否合法
BOOL isValidatePhoneNumber(NSString *aPhoneNumber);

// 规则：4-16位不能含有空格、单引号、双引号特殊字符。
BOOL isValidatePassWord(NSString *aPassWord);

// 创建指定颜色的图片
UIImage *createImageWithColor(UIColor *color, CGSize size);

UIImage *imageByScalingToMaxSize(UIImage *sourceImage);

UIImage *imageByScalingAndCroppingForSourceImage(UIImage *sourceImage, CGSize targetSize);

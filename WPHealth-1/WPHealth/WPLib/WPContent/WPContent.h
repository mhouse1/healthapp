//
//  WPContent.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WPCoinCountOfEveryPlan   1

extern NSString *const kWPNotificationHomePageUpadteNotify;

// 计划
@interface WPContentPlan : NSObject

@property (nonatomic, strong) NSString *plan_id;                //标识
@property (nonatomic, strong) NSString *user_id;                //设备唯一码
@property (nonatomic, strong) NSString *iconNameColor;          //彩色图标
@property (nonatomic, strong) NSString *iconNameWhite;          //白色图标
@property (nonatomic, strong) NSString *planName;               //名称
@property (nonatomic, strong) NSString *selectedTime;           //选中的时间
@property (nonatomic, strong) NSArray *canSelectedTimeArray;    //可选的时间列表

@property (nonatomic, strong) NSString *isPlanFinished;         //是否完成
@property (nonatomic, strong) NSString *summary;                //介绍

@property (nonatomic, strong) NSString *sportTime;              //运动时长
@property (nonatomic, strong) NSString *dayOfWeek;              //星期计划
@property (nonatomic, strong) NSString *notifyStatus;           //通知提醒

@end

// 当前用户
@interface WPContentCurrentUser : NSObject

@property (nonatomic, strong) NSString *user_id;    //设备唯一码
@property (nonatomic, strong) NSString *user_name;  //用户名，邮箱或电话号
@property (nonatomic, strong) NSString *password;   //密码
@property (nonatomic, strong) NSString *user_nick;  //昵称
@property (nonatomic, strong) NSString *icon;       //头像
@property (nonatomic, strong) NSString *gender;     //性别 0:女，1:男
@property (nonatomic, strong) NSString *height;     //身高
@property (nonatomic, strong) NSString *weight;     //体重
@property (nonatomic, strong) NSString *area;       //地区
@property (nonatomic, strong) NSString *birthday;   //生日

@property (nonatomic, strong) NSString *continueDayCount;     //连续天数
@property (nonatomic, strong) NSString *lastWorkDate;         //上一次使用的日期
@property (nonatomic, strong) NSArray *planFinishedDateArray; //计划完成的日期列表

@property (nonatomic, strong) NSString *coinCountOfEveryDay;  //每天金币个数
@property (nonatomic, strong) NSString *totalCoinCount;       //总金币个数

@property (nonatomic, strong) NSString *wakeUpCoinCount;      //起床金币个数
@property (nonatomic, strong) NSString *breakfastCoinCount;   //早餐金币个数
@property (nonatomic, strong) NSString *lunchCoinCount;       //午餐金币个数
@property (nonatomic, strong) NSString *dinnerCoinCount;      //晚餐金币个数
@property (nonatomic, strong) NSString *waterCoinCount;       //喝水金币个数
@property (nonatomic, strong) NSString *bianbianCoinCount;    //便便金币个数
@property (nonatomic, strong) NSString *sleepCoinCount;       //睡觉金币个数
@property (nonatomic, strong) NSString *youyangSportCoinCount;//有氧运动金币个数
@property (nonatomic, strong) NSString *wuyangSportCoinCount; //无氧运动金币个数

@property (nonatomic, strong) NSString *wakeUpAndSleepSwitch; //"起床/睡眠"提醒开关
@property (nonatomic, strong) NSString *waterSwitch;          //"喝水"提醒开关
@property (nonatomic, strong) NSString *eatSwitch;            //"一日三餐"提醒开关
@property (nonatomic, strong) NSString *sportsSwitch;         //"运动"提醒开关
@property (nonatomic, strong) NSString *caredPersonSwitch;    //"来自关心的人"提醒开关

@end

// 每日推荐
@interface WPContentNews : NSObject

@property (nonatomic, strong) NSString *title;            //设备唯一码
@property (nonatomic, strong) NSString *summary;          //昵称
@property (nonatomic, strong) NSString *url;               //头像

@end


//
//  ZHPickView.h
//  ZHpickView
//
//  Created by liudianling on 14-11-18.
//  Copyright (c) 2014年 赵恒志. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHPickView;

@protocol ZHPickViewDelegate <NSObject>

@optional
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString;

@end

@interface ZHPickView : UIView

@property(nonatomic,weak) id<ZHPickViewDelegate> delegate;

-(instancetype)initPickviewWithPlistName:(NSString *)plistName;

-(instancetype)initPickviewWithArray:(NSArray *)array;

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode;

-(void)remove;

-(void)show;

-(void)setPickViewColer:(UIColor *)color;

-(void)setTintColor:(UIColor *)color;

-(void)setToolbarTintColor:(UIColor *)color;

- (void)setTitleLabelWithString:(NSString *)aTitle;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

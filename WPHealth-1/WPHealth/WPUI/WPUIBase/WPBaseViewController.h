//
//  WPBaseViewController.h
//  WPHealthBank
//
//  Created by justone on 14-8-24.
//  Copyright (c) 2014年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPBaseViewController : UIViewController

@property (nonatomic, strong) UIViewController* parentVC;
@property (nonatomic, assign) BOOL needHideBack;

- (void)setBackItem;
- (void)setTitleBackItem;
- (void)back;

- (void)showText:(NSString *)aText;
- (void)showTextInView:(UIView *)aParentView
                  text:(NSString *)aText
             hideAfter:(NSInteger)aInterval;

- (NSString *)key;
- (BOOL)checkSameCanGoBack:(NSString *)aKey;

- (void)checkMemoryLeak;

- (void)reloadData;

@end

@interface WPBaseViewController (Key)

- (NSString *)wpViewControllerKey:(NSString *)aUserID;
- (NSString *)wpViewControllerKey;

@end

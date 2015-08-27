//
//  WPPopClockAddTagView.h
//  WPHealth
//
//  Created by justone on 15/6/2.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPopClockAddTagView : UIView

@property (nonatomic, strong) void (^finishedBlock)(NSString *aTag);

- (id)initWithOldTag:(NSString *)aOldTag;

- (void)show;

- (void)dismiss;

@end

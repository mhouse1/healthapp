//
//  WPPopClockCardBackView.h
//  WPHealth
//
//  Created by justone on 15/6/2.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPopClockCardBackView : UIView

- (id)initWithImageName:(NSString *)aImageName content:(NSString *)aContent;

- (void)show;

- (void)dismiss;

@end

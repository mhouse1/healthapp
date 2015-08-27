//
//  UIImage+WP.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageExpansionMethods)

+ (CGSize)fitSize:(CGSize)orgSize toFitSize:(CGSize)fitSize;

+ (CGRect)fitFrame:(CGSize)orgSize toFitSize:(CGSize)fitSize;

- (UIImage*)scaleImageToSize:(CGSize)newSize;

- (UIImage*)ratioScaleImageToSize:(CGSize)newSize;

- (UIImage *)ratioConfigImageToSize:(CGSize)newSize;//不会产生白边（区别于ratioScaleImageToSize）
//在最大和最小区域内裁剪图片
- (UIImage *)cutImageWithMaxSize:(CGSize)aMax andMinSize:(CGSize)aMin;

- (UIImage *)imageAtRect:(CGRect)rect;

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (BOOL)hasAlpha;

- (UIImage *)imageWithAlpha;

- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

- (UIImage *)setCorner;

// 缩放到aKBSize KB大小
- (NSData *)scaleSizeToKB:(int)aKBSize;

-(UIImage *)imageFromText:(NSString *)text;

@end

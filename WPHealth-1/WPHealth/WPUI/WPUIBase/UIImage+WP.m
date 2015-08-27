//
//  UIImage+WP.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "UIImage+WP.h"

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
}

CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180/M_PI;
}

@implementation UIImage (ImageExpansionMethods)

+ (CGSize)fitSize:(CGSize)orgSize toFitSize:(CGSize)fitSize
{
    CGFloat scale;
    CGSize  newsize = orgSize;
    
    if (newsize.height && (newsize.height > fitSize.height))
    {
        scale = fitSize.height / newsize.height;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    if (newsize.width && (newsize.width > fitSize.width))
    {
        scale = fitSize.width / newsize.width;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    
    return newsize;
}


+ (CGRect)fitFrame:(CGSize)orgSize toFitSize:(CGSize)fitSize
{
    CGRect newFrame;
    CGSize newsize = [UIImage fitSize:orgSize toFitSize:fitSize];
    
    newFrame.size = newsize;
    newFrame.origin.x = (fitSize.width - newsize.width)/2;
    newFrame.origin.y = (fitSize.height - newsize.height)/2;
    
    return newFrame;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    if(newSize.width >= newSize.height)
    {
        UIGraphicsBeginImageContext(CGSizeMake(newSize.width, newSize.width));
        [image drawInRect:CGRectMake(0,(newSize.width-newSize.height)/2,newSize.width,newSize.height)];
    }
    else
    {
        UIGraphicsBeginImageContext(CGSizeMake(newSize.height, newSize.height));
        [image drawInRect:CGRectMake((newSize.height-newSize.width)/2,0,newSize.width,newSize.height)];
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*)ratioImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    float ratio = image.size.width /image.size.height;
    if (newSize.height >= newSize.width/ratio)
    {
        UIGraphicsBeginImageContext(CGSizeMake(newSize.width, newSize.height));
        [image drawInRect:CGRectMake(0, (newSize.height-newSize.width/ratio)/2, newSize.width, newSize.width/ratio)];
    }
    else
    {
        UIGraphicsBeginImageContext(CGSizeMake(newSize.width, newSize.height));
        [image drawInRect:CGRectMake((newSize.width-newSize.height*ratio)/2, 0, newSize.height*ratio, newSize.height)];
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (UIImage*)scaleImageToSize:(CGSize)newSize
{
    return [UIImage imageWithImage:self scaledToSize:newSize];
}

- (UIImage*)ratioScaleImageToSize:(CGSize)newSize
{
    return [UIImage ratioImageWithImage:self scaledToSize:newSize];
}

- (UIImage *)ratioConfigImageToSize:(CGSize)newSize
{
    float width = self.size.width;
    float height = self.size.height;
    
    float newWidth = newSize.width;
    float newHeight = newSize.height;
    
    if (width > newWidth || height > newHeight)
    {
        
    }
    
    if (self.size.width>=self.size.height)
    {
        if (self.size.width >= newHeight ||self.size.height >= newWidth)
        {
            if (height >newWidth)
            {
                float ratio = self.size.width /self.size.height;
                height = newWidth;
                width = ratio*height;
            }
        }
    }
    else
    {
       	if (self.size.width >= newWidth ||self.size.height >= newHeight)
        {
            if (width>newWidth)
            {
                float ratio = self.size.height /self.size.width;
                width = newWidth;
                height = ratio*width;
            }
        }
    }
    
    return [self ratioScaleImageToSize:CGSizeMake(width,height)];
}

- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return image;
}

- (UIImage *)cutImageWithMaxSize:(CGSize)aMax andMinSize:(CGSize)aMin
{
    float width = self.size.width;
    float height = self.size.height;
    
    if (width == 0 && height == 0)
    {
        return self;
    }
    
    BOOL needCut = NO;
    float cutWidth = 0;
    float cutHeight = 0;
    
    if (width > aMax.width)
    {
        float ratio = height/width;
        width = aMax.width;
        height = width*ratio;
    }
    
    if (height > aMax.height)
    {
        float ratio = width/height;
        height = aMax.height;
        width = height*ratio;
    }
    
    if (width < aMin.width)
    {
        float ratio = height/width;
        width = aMin.width;
        height = width*ratio;
        
        needCut = YES;
        cutWidth = width;
        cutHeight = aMax.height;
    }
    
    if (height < aMin.height)
    {
        float ratio = width/height;
        height = aMin.height;
        width = height*ratio;
        
        needCut = YES;
        cutWidth = aMax.width;
        cutHeight = height;
    }
    
    UIImage *scaleImage = [self ratioScaleImageToSize:CGSizeMake(width,height)];
    
    if (needCut)
    {
        float pointX = 0;//(width-cutWidth)/2;
        float pointY = 0;//(height-cutHeight)/2;
        
        scaleImage = [scaleImage cropImageWithX:pointX
                                              y:pointY
                                          width:cutWidth
                                         height:cutHeight];
    }
    
    return scaleImage;
}

-(UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize
{
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}

// Returns true if the image has an alpha layer
- (BOOL)hasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha
{
    if ([self hasAlpha])
    {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize
{
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

- (UIImage *)setCorner
{
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          self.size.width,
                                                                          self.size.height)];
    tempView.image = self;
    tempView.layer.cornerRadius = self.size.width/15;
    tempView.clipsToBounds = YES;
    
    UIGraphicsBeginImageContext(tempView.bounds.size);
    //    UIGraphicsBeginImageContextWithOptions(tempView.bounds.size, NO, 0.0);
    
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    tempView.image = nil;
    
    //    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    return image;
}

- (NSData *)scaleSizeToKB:(int)aKBSize
{
    CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIImage *selectImage = [self ratioConfigImageToSize:CGSizeMake(screenSize.width/scale, screenSize.height/scale)];
    
    float originScale = 1.0;
    NSUInteger minLength = 1024*aKBSize; // 30KB
    NSData *imageData = UIImageJPEGRepresentation(selectImage, originScale);
    while ([imageData length] > minLength && originScale > 0.01) {
        originScale *= 0.9;
        imageData = UIImageJPEGRepresentation(selectImage, originScale);
    }
    
    return imageData;
}

-(UIImage *)imageFromText:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:14.0];
    
    CGSize size = CGSizeMake(self.size.width-3.*2, self.size.height-3.*2);
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    UIGraphicsBeginImageContext(size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(2.0, -2.0), 5.0, [[UIColor grayColor] CGColor]);
    
    [text drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)
      withAttributes:@{NSFontAttributeName: font,
                       NSForegroundColorAttributeName: [UIColor whiteColor]
                       }];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

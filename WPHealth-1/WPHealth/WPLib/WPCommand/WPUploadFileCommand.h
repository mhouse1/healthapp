//
//  WPUploadFileCommand.h
//  WPHealth
//
//  Created by justone on 15-1-11.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPCommand.h"

// 上传图片
@interface WPUploadFileCommand : NSObject

@property (nonatomic, strong) NSData *fileData;

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure;

@end

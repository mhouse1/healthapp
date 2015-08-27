//
//  WPUploadFileCommand.m
//  WPHealth
//
//  Created by justone on 15-1-11.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPUploadFileCommand.h"
#import "WPAFNetwokClient.h"
#import "WPUtil.h"

@implementation WPUploadFileCommand

- (void)postCommandWithSuccess:(void (^)(NSDictionary *aResponseDict))aSuccess
                       failure:(void (^)(NSError *aError))aFailure
{
    NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"/file/upload"];
    NSString *properlyEscapedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[WPAFNetwokClient shared] multipartFormRequestWithMethod:@"POST" path:properlyEscapedURL parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:self.fileData name:@"file" fileName:@"image.png" mimeType:@"image/png"];
    }];
    
    NSDictionary *res = [request allHTTPHeaderFields];
    NSLog(@"request: %@", res);
    
    AFHTTPRequestOperation *operation = [[WPAFNetwokClient shared] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *res = [[operation response] allHeaderFields];
        NSLog(@"response: %@", res);
        
        //        if (aSuccess) {
        //            aSuccess(stringToDic(operation.responseString));
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@ Request failure with error:%@", [self class], error);
        if (aFailure) {
            aFailure(error);
        }
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"%@",WPJsonStringToDictionary(operation.responseString));
        if (aSuccess) {
            aSuccess(WPJsonStringToDictionary(operation.responseString));
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@ Request failure with error:%@", [self class], error);
        if (aFailure) {
            aFailure(error);
        }
    }];
    
    [[WPAFNetwokClient shared] enqueueHTTPRequestOperation:operation];
}

@end

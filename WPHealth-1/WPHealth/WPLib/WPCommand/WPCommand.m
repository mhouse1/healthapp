//
//  WPCommand.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPCommand.h"
#import "WPAFNetwokClient.h"
#import <objc/runtime.h>

@implementation WPCommand
{
    NSMutableDictionary *_postDict;
}

- (id)init
{
    self = [super init];
    if (self) {
        _postDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)constructCustomPostDict
{
    if (![NSStringFromClass([self class]) isEqualToString:@"WPLoginCommand"]
        || ![NSStringFromClass([self class]) isEqualToString:@"WPRegisterCommand"]) {
        NSString *token = [[WPGlobalConfig shared] token];
        if (token && [token length]) {
            [[WPAFNetwokClient shared] setDefaultHeader:@"rememberMe" value:token];
        }
        NSString *authorization = [[WPGlobalConfig shared] authorization];
        if (authorization && [authorization length]) {
            
        }
    }
    
    [[WPAFNetwokClient shared] setDefaultHeader:@"Authorization" value:@"Basic dGVzdDEyMzpzZWNyZXQxMjM="];
}

- (NSMutableDictionary *)constructExternPostDict
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (NSInteger index = 0; index < outCount; index++) {
        NSString *tmpName = [NSString stringWithFormat:@"%s",property_getName(properties[index])];
        NSObject *tmpValue = [self valueForKey:tmpName];
        if ([tmpValue isKindOfClass:[NSString class]] || [tmpValue isKindOfClass:[NSNumber class]]) {
            if (tmpValue) {
                if ([NSStringFromClass([self class]) isEqualToString:@"WPModifyPasswordCommand"]) {
                    // 真坑爹，new是关键字
                    if ([tmpName isEqualToString:@"nowPassword"]) {
                        tmpName = @"newPassword";
                    }
                }
                [_postDict setObject:tmpValue forKey:tmpName];
            } else {
                NSLog(@"%@ postDict key: %@, value: nil", NSStringFromClass([self class]), tmpName);
            }
        } else if ([tmpValue isKindOfClass:[NSDictionary class]]) {
            [_postDict setDictionary:(NSDictionary *)tmpValue];
        }
    }
    
    NSLog(@"%@  sending postDict: %@", NSStringFromClass([self class]), _postDict);
    
    return _postDict;
}


- (void)getCommandWithRequestPath:(NSString *)aRequestPath
                          success:(void (^)(NSDictionary *aResponseDict))aSuccess
                          failure:(void (^)(NSError *aError))aFailure
{
    [self constructCustomPostDict];
    [self constructExternPostDict];
    
    [[WPAFNetwokClient shared] getPath:aRequestPath
                            parameters:_postDict
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   if (aSuccess) {
                                       aSuccess(WPJsonStringToDictionary(operation.responseString));
                                   }
                                   
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   
                                   NSLog(@"%@ Request failure :%@", [self class], error);
                                   if (aFailure) {
                                       aFailure(error);
                                   }
                                   
                               }];
}

- (void)postCommandWithRequestPath:(NSString *)aRequestPath
                           success:(void (^)(NSDictionary *aResponseDict))aSuccess
                           failure:(void (^)(NSError *aError))aFailure
{
    [self constructCustomPostDict];
    [self constructExternPostDict];
    
    [[WPAFNetwokClient shared] postPath:aRequestPath
                             parameters:_postDict
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    if (aSuccess) {
                                        aSuccess(WPJsonStringToDictionary(operation.responseString));
                                    }
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                    NSLog(@"%@ Request failure mhouse :%@", [self class], error);
                                    if (aFailure) {
                                        aFailure(error);
                                    }
                                    
                                }];
}

@end

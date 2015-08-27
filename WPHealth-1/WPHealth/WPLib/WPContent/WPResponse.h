//
//  WPResponse.h
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WPResponseCodeSuccess,
    WPResponseCodeFailed
}WPResponseCode;

@interface WPResponse : NSObject

@property (nonatomic, assign) WPResponseCode responseCode;
@property (nonatomic, strong) NSString *responseMessage;

@end

// 推送提醒 http://54.86.106.253:8080/notification/form
// 每日推荐 http://54.86.106.253:8080/news/form


//http://52.4.12.26:8888/apidoc/


/*
/file/upload  没有上传头像的协议
 
 /users/update
 
 WPUpdateUserInfoCommand Request failure :Error Domain=AFNetworkingErrorDomain Code=-1011 "Expected status code in (200-299), got 401" UserInfo=0x7f9239f05ac0 {NSLocalizedRecoverySuggestion=Unauthorized, NSErrorFailingURLKey=http://52.4.12.26:8888/users/update, AFNetworkingOperationFailingURLRequestErrorKey=<NSMutableURLRequest: 0x7f923b034cc0> { URL: http://52.4.12.26:8888/users/update }, AFNetworkingOperationFailingURLResponseErrorKey=<NSHTTPURLResponse: 0x7f9239e4cd40> { URL: http://52.4.12.26:8888/users/update } { status code: 401, headers {
 Connection = "keep-alive";
 Date = "Tue, 23 Jun 2015 14:26:27 GMT";
 "Transfer-Encoding" = Identity;
 "Www-Authenticate" = "Bearer realm=\"Users\"";
 "X-Powered-By" = Express;
 } }, NSLocalizedDescription=Expected status code in (200-299), got 401}
 */






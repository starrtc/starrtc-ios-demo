//
//  InterfaceUrls.m
//  monitor_001
//
//  Created by  Admin on 2017/11/4.
//  Copyright © 2017年 ndp_001_Tommy. All rights reserved.
//

#import "InterfaceUrls.h"

@implementation InterfaceUrls
{

    NSString *BASE_URL;
    NSString *LOGIN_URL;
    NSString *MEETING_LIST_URL;
    NSString *LIVE_LIST_URL;
    NSString *CHATROOM_LIST_URL;
    NSString *GROUP_LIST_URL ;
    NSString *GROUP_MEMBERS_URL;
    NSString *LIVE_SET_CHAT_URL;
}

//重写init  方法
-(id)init{
    //初始化父类拥有的成员变量
    if (self=[super init])
    {
        BASE_URL = @"https://api.starrtc.com";
        LOGIN_URL = [BASE_URL stringByAppendingString:@"/se/user/login.php"];
        MEETING_LIST_URL = [BASE_URL stringByAppendingString:@"/demo/meeting/list"];
        LIVE_LIST_URL = [BASE_URL stringByAppendingString:@"/demo/live/list"];
        CHATROOM_LIST_URL = [BASE_URL stringByAppendingString:@"/demo/chat/list"];
        GROUP_LIST_URL = [BASE_URL stringByAppendingString:@"/demo/group/list_all"];
        GROUP_MEMBERS_URL = [BASE_URL stringByAppendingString:@"/demo/group/members"];
        LIVE_SET_CHAT_URL =  [BASE_URL stringByAppendingString:@"/demo/live/set_chat"];  //上报直播间使用的聊天室ID（直播里的文字聊天用了一个聊天室）
    }
    
    return self;
}

- (NSString *)absolutePath:(NSString *)relativePath {
    return [BASE_URL stringByAppendingString:relativePath];
}

- (void)reportMeeting:(NSString *)name ID:(NSString *)ID creator:(NSString *)creator {
    NSString *urlStr =  [NSString stringWithFormat:@"%@?ID=%@&Name=%@&Creator=%@",[self absolutePath:@"/demo/meeting/store"], ID, [self URLEncodeString:name], [self URLEncodeString:creator]];
    
    [self get:urlStr callback:^(id result, NSError *error) {
        
    }];
}
- (void)demoRequestMeetingList:(NSString *)agentID {
    NSString *urlStr =  [NSString stringWithFormat:@"%@%@%@",MEETING_LIST_URL,@"?agentId=",agentID];
    
    [self get:urlStr callback:^(id result, NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(getMeetingListResponse:)])
        {
            // 收到呼叫
            [_delegate getMeetingListResponse:result];
        }
    }];
}

//上报互动直播列表信息
-(void)demoReportChatAndLive:(NSString *) channelId
                  chatroomId:(NSString *)chatroomId
{
    
    
    NSString *mrequestURL=  [NSString stringWithFormat:@"%@?%@%@%@%@",LIVE_SET_CHAT_URL,@"channel_id=",channelId,@"&chatroom_id=",chatroomId];
    
    NSURL *url = [NSURL URLWithString:mrequestURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置POST请求
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 60;
    //设置请求体
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:channelId,@"channel_id",chatroomId,@"chatroom_id", nil];
//    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
//    request.HTTPBody = bodyData;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSString *jsonString = [NSString stringWithFormat:@"%@", dic];
//
        
        //获取响应包
        //将response 转化为一个子类的HTTPURLResponse
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        //打印状态码
        NSLog(@"状态码:%li", httpResponse.statusCode);
        //获取响应头
        NSDictionary *responseHeader = httpResponse.allHeaderFields;
        NSLog(@"响应头:%@", responseHeader);
    }];
    
    
    //开始网络任务
    [dataTask resume];
}

- (void)reportLive:(NSString *)name ID:(NSString *)ID creator:(NSString *)creator {
    NSString *urlStr =  [NSString stringWithFormat:@"%@?ID=%@&Name=%@&Creator=%@",[self absolutePath:@"/demo/live/store"], ID, [self URLEncodeString:name], [self URLEncodeString:creator]];
    
    [self get:urlStr callback:^(id result, NSError *error) {
        
    }];
}
//互动直播列表
- (void)demoRequestLiveList:(NSString *)agentID
{
    //1.创建一个web路径
    NSString *urlStr =  [NSString stringWithFormat:@"%@%@%@",LIVE_LIST_URL,@"?agentId=",agentID];
    
    [self get:urlStr callback:^(id result, NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(getLiveListResponse:)])
        {
            // 收到呼叫
            [_delegate getLiveListResponse:result];
        }
    }];
}

- (void)reportChatroom:(NSString *)name ID:(NSString *)ID creator:(NSString *)creator {
//    [name url]
    NSString *urlStr =  [NSString stringWithFormat:@"%@?ID=%@&Name=%@&Creator=%@",[self absolutePath:@"/demo/chat/store"], ID, [self URLEncodeString:name], [self URLEncodeString:creator]];
    
    [self get:urlStr callback:^(id result, NSError *error) {
        
    }];
}
//聊天室列表
- (void)demoRequestChatroomList:(NSString *)agentID {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",CHATROOM_LIST_URL,@"?agentId=",agentID];
    [self get:urlStr callback:^(id result, NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(getChatRoomListResponse:)])
        {
            // 收到呼叫
            [_delegate getChatRoomListResponse:result];
        }
    }];
}

 //群列表
- (void)demoRequestGroupList:(NSString *)userid
{
    NSString *urlStr=  [NSString stringWithFormat:@"%@%@%@",GROUP_LIST_URL,@"?userid=",userid];
    [self get:urlStr callback:^(id result, NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(getMessageGroupListResponse:)])
        {
            [_delegate getMessageGroupListResponse:result];
        }
    }];
}

//群成员列表
- (void)demoRequestGroupMembers:(NSString *)groupID {
    NSString *urlStr =  [NSString stringWithFormat:@"%@%@%@",GROUP_MEMBERS_URL,@"?groupId=",groupID];
    [self get:urlStr callback:^(id result, NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(getMessageGroupMemberResponse:)])
        {
            [_delegate getMessageGroupMemberResponse:result];
        }
    }];
}

- (void)get:(NSString *)urlStr callback:(void(^)(id result, NSError *error))callback {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString* errorString = [error localizedDescription];
        NSLog(@"errorString = %@",errorString);
        /*
         对从服务器获取到的数据data进行相应的处理：
         */
        if(data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            if(dict != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(dict, nil);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil, error);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil,error);
            });
        }
    }];
    [sessionDataTask resume];
}

+ (void)getAuthKey:(NSString *)userID
             appid:(NSString *)appid
               url:(NSString *)url
          callback:(void(^)(BOOL status, NSString *data))callback
{
    //NSString    *strUrl = [NSString stringWithFormat:@"https://cloud.starconnect.cn/demo/authKey?userid=%@",userID];
    NSString *strUrl = [NSString stringWithFormat:@"%@?userid=%@",url,userID];
    NSURL *authkeyURL = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:authkeyURL];
    urlRequest.timeoutInterval = 15;
    __block NSString *authkey;
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"从服务器获取到数据");
        NSString* errorString = [error localizedDescription];
        NSLog(@"errorString = %@",errorString);
        /*
         对从服务器获取到的数据data进行相应的处理：
         */
        if(data != nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            if(dict != nil)
            {
                authkey= [dict objectForKey:@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(true,authkey);
                });
                
                //NSArray *array = [data componentsSeparatedByString:@"@"];
                //authkey = (NSString *)[array objectAtIndex:1];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(false,@"");
                });
                
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(false,@"");
            });
            
        }
//        dispatch_semaphore_signal(semaphore);   //发送信号
        
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];
    
//    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    return;
}
+(void)getAppConfigUrlParameter:(NSString*)parameter success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure{
    
    NSURL *configURL = [NSURL URLWithString:[AppConfigURL stringByAppendingString:parameter]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:configURL];
    urlRequest.timeoutInterval = 15;
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"从服务器获取到数据");
        NSString* errorString = [error localizedDescription];
        NSLog(@"errorString = %@",errorString);
        /*
         对从服务器获取到的数据data进行相应的处理：
         */
        if(data != nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            if(dict)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success ? success(dict) : nil;
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure ? failure(nil) : nil;
                });
                
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure ? failure(nil) : nil;
            });
            
        }
        
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];
}

- (NSString *)URLEncodeString:(NSString *)URLString {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!*'();:,.@&=+$/?%#[]_-{}|\""]];
    } else {
        return [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}
@end

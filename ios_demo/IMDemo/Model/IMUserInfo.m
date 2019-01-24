//
//  IMUserInfo.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/2.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IMUserInfo.h"

@interface IMUserInfo ()
@property (nonatomic, strong) NSMutableDictionary *colorMutDic;
@end

@implementation IMUserInfo

+ (instancetype)shareInstance
{
    static IMUserInfo * staticUserInfo = nil;
    static dispatch_once_t onceTime;
    dispatch_once(&onceTime, ^{
        
        staticUserInfo = [[self alloc] init];
        
    });
    return staticUserInfo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userID = [self setMyUserID];
        
        _colorMutDic = [ILGLocalData unArchiverObject:[ILGLocalData filePathFromDocuments:@"IFListIconColorKey"]];
        if (!_colorMutDic) {
            _colorMutDic = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

- (NSMutableArray *)c2cSessionList {
    if (!_c2cSessionList) {
        _c2cSessionList = [NSMutableArray array];
    }
    return _c2cSessionList;
}

-(NSString *)setMyUserID
{
    
    //读取存入的数组 打印
    
    
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    if(userid == nil)
    {
        int value = arc4random() % 1000000 + 100000;
        
        NSString *newString = [NSString stringWithFormat:@"%d",value];
        
        userid = [NSString stringWithString:newString];
        
        NSLog(@"setMyUserID %@ \n", newString);
        
        //存入数组并同步
        
        [[NSUserDefaults standardUserDefaults] setObject:newString forKey:@"USERID"];

        [[NSUserDefaults standardUserDefaults] synchronize];
        return newString;
    }
    else
    {
        return userid;
        
    }
    
    
}

- (UIColor *)listIconColor:(NSString *)key {
    if (self.colorMutDic[key]) {
        
    } else {
        self.colorMutDic[key] = [UIColor ilg_randomColor];
        [ILGLocalData archiverSave:_colorMutDic path:[ILGLocalData filePathFromDocuments:@"IFListIconColorKey"]];
    }
    return self.colorMutDic[key];
}
@end

//
//  IFNetworkingInterfaceDefine.h
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2017/11/9.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

#ifndef IFNetworkingInterfaceDefine_h
#define IFNetworkingInterfaceDefine_h

#define ISVEnvironmentType 1 //1代表正式环境，0代表测试环境

#if ISVEnvironmentType

#define IFDefaultBaseURL @"https://api.starrtc.com"

#else

#define IFDefaultBaseURL @"https://api.starrtc.com"

#endif



#endif /* IFNetworkingInterfaceDefine_h */

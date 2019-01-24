//
//  AssignToObject.h
//  GainProperty
//
//  Created by yangyichuang on 14-7-18.
//  Copyright (c) 2014年 yangyichuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface AssignToObject : NSObject

//这个方法可以直接把从json中得到的数组中的字典转化为具体的对象，其里面都是封装好的具体对象。
+ (NSMutableArray *)customModel:(NSString *)modelClass ToArray:(id)jsonArray;

//这个方法可以直接把从json中得到的数组中的字典转化为具体的对象，其里面都是封装好的具体对象。
+ (NSMutableArray *)QGCustomModel:(NSString *)modelClass ToArray:(id)jsonArray;

//获取类的各个属性，存到数组中
+ (id)propertyKeysWithString:(NSString *)classStr;
//对象转字典
+ (NSDictionary*)objectToDictionary:(id)object;

@end

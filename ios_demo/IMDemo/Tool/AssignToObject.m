//
//  AssignToObject.m
//  GainProperty
//
//  Created by yangyichuang on 14-7-18.
//  Copyright (c) 2014年 yangyichuang. All rights reserved.
//

#import "AssignToObject.h"


@implementation AssignToObject

//获取类的各个属性，存到数组中
+ (id)propertyKeysWithString:(NSString *)classStr

{
    unsigned int outCount, i;
    
    //获取一个类的各个成员变量存放在properties[]数组中
    objc_property_t *properties = class_copyPropertyList([NSClassFromString(classStr) class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    
    free(properties);
    
    return keys;
}

+ (NSDictionary*)objectToDictionary:(id)object {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:20];
    
    unsigned int outCount, i;
    
    //获取一个类的各个成员变量存放在properties[]数组中
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [dictionary setObject:[object valueForKey:propertyName] forKey:propertyName];
    }
    
    free(properties);
    
    return dictionary;
}

+ (NSMutableArray *)customModel:(NSString *)modelClass ToArray:(id)jsonArray
{
    
    //用来存放一个类中有几个成员变量。
    unsigned int outCount = 0;
    
    //这句话执行之后outCount的值就会是当前类中属性的个数。整体返回的是一个指针数组，里面包含对应类的各个属性信息。
    objc_property_t *properties = class_copyPropertyList(NSClassFromString(modelClass), &outCount);//通过class_copyPropertyList这个方法可以获得一个类中有多少个属性，此时可得到outCount的值
   
    
    //创建一个数组用来存放对象；
    NSMutableArray *objectArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int i = 0; i < [jsonArray count]; i++)
    {
        //取出数组中的一个对象
        id jsonDic = [jsonArray objectAtIndex:i];
        
        //若数组中的对象不是字典对象就跳过它。继续下一个。
        if(![jsonDic isKindOfClass:[NSDictionary class]])
        {
            continue;
        }
        
        //创建一个传过来字符串（类名）相应的对象
        id model = [[NSClassFromString(modelClass) alloc] init];
        
//        [model setValuesForKeysWithDictionary:jsonDic];
        //判断类中的每一个属性
        for (int j = 0; j < outCount; j++)
        {
            //获取类中的第j个成员变量信息
            objc_property_t property = properties[j];
            
            //获取类中的第j个成员变量将其转化为字符串
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
            //获得json串中的键对应的值
            id value = [jsonDic objectForKey:propertyName];
            
            //判断上面取得的值是否存在，不存在就去转换下一个属性
            if(!value || [value isKindOfClass:[NSNull class]])
            {
                continue;
            }
            
            [model setValue:value forKey:propertyName];
            
        }
        //把转化完成的对象加到一个数组中。
        [objectArr addObject:model];
        
    }
    return objectArr;
}
//这个方法可以直接把从json中得到的数组中的字典转化为具体的对象，其里面都是封装好的具体对象。
+ (NSMutableArray *)QGCustomModel:(NSString *)modelClass ToArray:(id)jsonArray
{
    //创建一个数组用来存放对象；
    NSMutableArray *objectArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (id jsonDic in jsonArray)  //json中有多少个对象
    {
        //若数组中的对象不是字典对象就跳过它。继续下一个。
        
        if(![jsonDic isKindOfClass:[NSDictionary class]])
        {
            continue;
        }
        
        //创建一个传过来字符串（类名）相应的对象
        
        id model = [[NSClassFromString(modelClass) alloc] init];
        [model setValuesForKeysWithDictionary:jsonDic];
        //        NSLog(@"%@",jsonDic);
        
        //        //给model中的属性赋值
        //        [model  setValuesForKeysWithDictionary:jsonDic];
        
        //把转化完成的对象加到一个数组中。
        [objectArr addObject:model];
    }
    return objectArr;

}
@end

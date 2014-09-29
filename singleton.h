//
//  singleton.h
//  RegisterWithIBeacon
//
//  Created by Zhu Lizhe on 14-2-22.
//  Copyright (c) 2014年 HuiBei. All rights reserved.
//

#ifndef RegisterWithIBeacon_singleton_h
#define RegisterWithIBeacon_singleton_h

#define singleton_for_interface(className) +(className*)shared##className ;



#define single_for_implementation(className) static className* _instance ;\
+(id)allocWithZone:(NSZone *)zone{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
+(className *)shared##className{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[className alloc]init];\
    });\
    return _instance ;\
}







#endif

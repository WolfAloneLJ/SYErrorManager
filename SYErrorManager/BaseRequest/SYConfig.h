//
//  SYConfig.h
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//



//网络模块 Block回调
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureValueBlock)(id  failCode);
typedef void (^NetWorkBlock) (BOOL netConnectState);





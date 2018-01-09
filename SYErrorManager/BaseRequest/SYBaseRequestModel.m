//
//  SYBaseRequestModel.m
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import "SYBaseRequestModel.h"

@implementation SYBaseRequestModel


-(void)setBlockWithReturnBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureValueBlock)failureBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}
@end

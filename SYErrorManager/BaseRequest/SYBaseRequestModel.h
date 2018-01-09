//
//  SYBaseRequestModel.h
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYConfig.h"


@interface SYBaseRequestModel : NSObject
@property(strong,nonatomic)ReturnValueBlock returnBlock;
@property(strong,nonatomic)ErrorCodeBlock errorBlock;
@property(strong,nonatomic)FailureValueBlock failureBlock;

// 传入交互的Block块
-(void)setBlockWithReturnBlock:(ReturnValueBlock)returnBlock
                withErrorBlock:(ErrorCodeBlock)errorBlock
              withFailureBlock:(FailureValueBlock)failureBlock;

@end

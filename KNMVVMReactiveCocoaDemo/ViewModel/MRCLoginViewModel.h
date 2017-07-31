//
//  MRCLoginViewModel.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "MRCViewModel.h"

@interface MRCLoginViewModel : MRCViewModel

/// The avatar URL of the user.当用户输入的用户名发生变化时，调用 model 层的方法查询本地数据库中缓存的用户数据，并返回 avatarURL 属性;
@property (nonatomic, copy, readonly) NSURL *avatarURL;

/// The username entered by the user.
@property (nonatomic, copy) NSString *username;

/// The password entered by the user.
@property (nonatomic, copy) NSString *password;

/**
 属性代表的是登录按钮是否可用，它将会与 view 中登录按钮的 enabled 属性进行绑定
 */
@property (nonatomic, strong, readonly) RACSignal *validLoginSignal;

/// The command of login button.
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

/// The command of uses browser to login button.
@property (nonatomic, strong, readonly) RACCommand *browserLoginCommand;
@property (nonatomic, strong, readonly) RACCommand *exchangeTokenCommand;

@end

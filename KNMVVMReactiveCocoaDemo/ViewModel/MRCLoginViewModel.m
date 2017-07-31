//
//  MRCLoginViewModel.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "MRCLoginViewModel.h"
//#import "MRCHomepageViewModel.h"
//#import "MRCOAuthViewModel.h"

@interface MRCLoginViewModel ()

@property (nonatomic, copy, readwrite) NSURL *avatarURL;

@property (nonatomic, strong, readwrite) RACSignal *validLoginSignal;
@property (nonatomic, strong, readwrite) RACCommand *loginCommand;
@property (nonatomic, strong, readwrite) RACCommand *browserLoginCommand;
@property (nonatomic, strong, readwrite) RACCommand *exchangeTokenCommand;

@end

@implementation MRCLoginViewModel

- (void)initialize {
    [super initialize];
    //1、当用户输入的用户名发生变化时，调用 model 层的方法查询本地数据库中缓存的用户数据，并返回 avatarURL 属性;
    RAC(self, avatarURL) = [[RACObserve(self, username)
        map:^(NSString *username) {
            return [[OCTUser mrc_fetchUserWithRawLogin:username] avatarURL];
        }]
        distinctUntilChanged];// distinctUntilChanged  如果当前的值跟上一次的值一样,就不会被订阅到
    //2、用户输入的用户名或密码发生变化时，判断用户名和密码的长度是否均大于 0 ，如果是则登录按钮可用，否则不可用;
    self.validLoginSignal = [[RACSignal
    	combineLatest:@[ RACObserve(self, username), RACObserve(self, password) ]
        reduce:^(NSString *username, NSString *password) {
        	return @(username.length > 0 && password.length > 0);
        }]
        distinctUntilChanged];
    /**
     3、
     当 loginCommand 或 browserLoginCommand 命令执行成功时，调用 doNext 代码块，使用服务总线中的方法 resetRootViewModel: 进入首页
     */
    @weakify(self)
    void (^doNext)(OCTClient *) = ^(OCTClient *authenticatedClient) {
        @strongify(self)
        [[MRCMemoryCache sharedInstance] setObject:authenticatedClient.user forKey:@"currentUser"];

        self.services.client = authenticatedClient;

        [authenticatedClient.user mrc_saveOrUpdate];
        [authenticatedClient.user mrc_updateRawLogin]; // The only place to update rawLogin, I hate the logic of rawLogin.
        
        SSKeychain.rawLogin = authenticatedClient.user.rawLogin;
        SSKeychain.password = self.password;
        SSKeychain.accessToken = authenticatedClient.token;
        
//        MRCHomepageViewModel *viewModel = [[MRCHomepageViewModel alloc] initWithServices:self.services params:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.services resetRootViewModel:viewModel];
        });
    };
    
    [OCTClient setClientID:MRC_CLIENT_ID clientSecret:MRC_CLIENT_SECRET];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^(NSString *oneTimePassword) {
    	@strongify(self)
        OCTUser *user = [OCTUser userWithRawLogin:self.username server:OCTServer.dotComServer];
        return [[OCTClient
        	signInAsUser:user password:self.password oneTimePassword:oneTimePassword scopes:OCTClientAuthorizationScopesUser | OCTClientAuthorizationScopesRepository note:nil noteURL:nil fingerprint:nil]
            doNext:doNext];
    }];

    self.browserLoginCommand = [[RACCommand alloc] initWithSignalBlock:^(id input) {
        @strongify(self)
        
//        MRCOAuthViewModel *viewModel = [[MRCOAuthViewModel alloc] initWithServices:self.services params:nil];
        
//        viewModel.callback = ^(NSString *code) {
//            @strongify(self)
//            [self.services popViewModelAnimated:YES];
//            [self.exchangeTokenCommand execute:code];
//        };
//        
//        [self.services pushViewModel:viewModel animated:YES];
        
        return [RACSignal empty];
    }];
    
//    self.exchangeTokenCommand = [[RACCommand alloc] initWithSignalBlock:^(NSString *code) {
//        OCTClient *client = [[OCTClient alloc] initWithServer:[OCTServer dotComServer]];
//        
//        return [[[[[client
//            exchangeAccessTokenWithCode:code]
//            doNext:^(OCTAccessToken *accessToken) {
//                [client setValue:accessToken.token forKey:@"token"];
//            }]
//            flattenMap:^(id value) {
//                return [[client
//                    fetchUserInfo]
//                    doNext:^(OCTUser *user) {
//                        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
//                        
//                        [mutableDictionary addEntriesFromDictionary:user.dictionaryValue];
//                        
//                        if (user.rawLogin.length == 0) {
//                            mutableDictionary[@keypath(user.rawLogin)] = user.login;
//                        }
//                        
//                        user = [OCTUser modelWithDictionary:mutableDictionary error:NULL];
//                        
//                        [client setValue:user forKey:@"user"];
//                    }];
//            }]
//            mapReplace:client]
//            doNext:doNext];
//    }];
}

- (void)setUsername:(NSString *)username {
    _username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

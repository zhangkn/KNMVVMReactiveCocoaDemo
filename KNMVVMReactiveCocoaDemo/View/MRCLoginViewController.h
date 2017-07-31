//
//  MRCLoginViewController.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "MRCViewController.h"

/**
 将 MRCLoginViewController 中的展示逻辑抽取到 MRCLoginViewModel 中后，使得 MRCLoginViewController 中的代码更加简洁和清晰。实践 MVVM 的关键点在于，我们要能够分析清楚 viewModel 需要暴露给 view 的数据和命令，这些数据和命令能够代表 view 当前的状态。
 */
@interface MRCLoginViewController : MRCViewController

@end

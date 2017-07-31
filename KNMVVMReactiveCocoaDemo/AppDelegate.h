//
//  AppDelegate.h
//  KNMVVMReactiveCocoaDemo
//
//  Created by devzkn on 31/07/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCViewModelServicesImpl.h"
#import "MRCNavigationControllerStack.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MRCViewModelServicesImpl *services;
@property (nonatomic, strong, readwrite) MRCNavigationControllerStack *navigationControllerStack;



@end


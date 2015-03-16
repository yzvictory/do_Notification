//
//  TYPEID_SM.h
//  DoExt_API
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Notification_ISM.h"
#import <UIKit/UIKit.h>
#import "doUIModule.h"
#import "doIUIModuleView.h"
#import "doSingletonModule.h"

@interface do_Notification_SM : doSingletonModule<do_Notification_ISM>

@end

@interface doConfirmView : UIAlertView <UIAlertViewDelegate>
@property (nonatomic, strong)NSString *myCallBackName;
@property (nonatomic, strong)id<doIScriptEngine> myScritEngine;
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles callbackName  :(NSString *)_callbackName scriptEngine:(id<doIScriptEngine>)_scritEngine;
- (void)Dispose;
@end

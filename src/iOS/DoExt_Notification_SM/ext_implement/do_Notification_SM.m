//
//  do_Notification_SM.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Notification_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doUIModuleHelper.h"
#import "doJsonNode.h"

@implementation do_Notification_SM
#pragma mark -
#pragma mark - 同步异步方法的实现
/*
 1.参数节点
 doJsonNode *_dictParas = [parms objectAtIndex:0];
 a.在节点中，获取对应的参数
 NSString *title = [_dictParas GetOneText:@"title" :@"" ];
 说明：第一个参数为对象名，第二为默认值
 
 2.脚本运行时的引擎
 id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
 
 同步：
 3.同步回调对象(有回调需要添加如下代码)
 doInvokeResult *_invokeResult = [parms objectAtIndex:2];
 回调信息
 如：（回调一个字符串信息）
 [_invokeResult SetResultText:((doUIModule *)_model).UniqueKey];
 异步：
 3.获取回调函数名(异步方法都有回调)
 NSString *_callbackName = [parms objectAtIndex:2];
 在合适的地方进行下面的代码，完成回调
 新建一个回调对象
 doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
 填入对应的信息
 如：（回调一个字符串）
 [_invokeResult SetResultText: @"异步方法完成"];
 [_scritEngine Callback:_callbackName :_invokeResult];
 */
//同步
//异步
- (void)alert:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    NSString *_title = [_dictParas GetOneText:@"title" :@"" ];
    NSString *_text = [_dictParas GetOneText:@"text" :@"" ];
    [doUIModuleHelper Alert:_title msg:_text];
    
}
- (void)confirm:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    NSString *_callbackName = [parms objectAtIndex:2];
    
    NSString *_title = [_dictParas GetOneText:@"title" :@"" ];
    NSString *_text = [_dictParas GetOneText:@"text" :@"" ];
    NSString *_button1text = [_dictParas GetOneText:@"button1text" :@"" ];
    NSString *_button2text = [_dictParas GetOneText:@"button2text" :@"" ];
    
    if (0 == _button1text.length)
    {
        _button1text = @"确定";
    }
    if (0 == _button2text.length)
    {
        _button2text = @"取消";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        doConfirmView *confirmView = [[doConfirmView alloc]initWithTitle:_title message:_text delegate:self cancelButtonTitle:_button1text otherButtonTitles:_button2text  callbackName:_callbackName scriptEngine:_scritEngine];
        
        [confirmView show];
    });
    
}
- (void)toast:(NSArray *)parms
{
    doJsonNode *_dictParas = [parms objectAtIndex:0];
    NSString *_text = [_dictParas GetOneText:@"text" :@"" ];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect _frame = [[UIScreen mainScreen]bounds];
        
        NSDictionary *_attributeDict = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        NSStringDrawingOptions _drawingOptions = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        //    CGSize strsize = [text sizeWithFont:[UIFont systemFontOfSize:12] forWidth:frame.size.width*0.75 lineBreakMode:NSLineBreakByCharWrapping];
        CGSize _strsize = [_text boundingRectWithSize:CGSizeMake(_frame.size.width*0.75, CGFLOAT_MAX) options:_drawingOptions attributes:_attributeDict context:nil].size;
        UIView *_mainView = [[UIView alloc] initWithFrame:_frame];
        float _tostWidth = 200;
        UIView *_showView = [[UIView alloc] initWithFrame:CGRectMake((_mainView.frame.size.width-(_tostWidth+20))/2, (_mainView.frame.size.height-(_strsize.height+20)-40), _tostWidth+20, _strsize.height+20)];
        _showView.backgroundColor = [UIColor blackColor];
        _showView.layer.cornerRadius = 6;
        UILabel *_showLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, _showView.frame.size.width-20, _showView.frame.size.height-10)];
        _showLabel.font = [UIFont systemFontOfSize:15];
        _showLabel.textColor = [UIColor whiteColor];
        _showLabel.text = _text;
        _showLabel.numberOfLines = 0;
        _showLabel.textAlignment = 1;
        _showLabel.backgroundColor = [UIColor clearColor];
        [_showView addSubview:_showLabel];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_showView];
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _showView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_showView removeFromSuperview];
        }];
    });
    
}

@end


@implementation doConfirmView
- (void)Dispose
{
    _myCallBackName = nil;
    _myScritEngine = nil;
}

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles callbackName  :(NSString *)_callbackName scriptEngine:(id<doIScriptEngine>)_scritEngine
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    self.myCallBackName = _callbackName;
    self.myScritEngine = _scritEngine;
    return self;
}

- (void)alertView:(doConfirmView *)confirmView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    doJsonNode *_node = [[doJsonNode alloc]init];
    
    if (buttonIndex == confirmView.cancelButtonIndex)
    {
        [_node SetOneInteger:@"index" :2];
    }
    else
    {
        [_node SetOneInteger:@"index" :1];
    }
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init:nil];
    [_invokeResult SetResultNode: _node];
    [confirmView.myScritEngine Callback:confirmView.myCallBackName :_invokeResult];
    [confirmView Dispose];
}
@end

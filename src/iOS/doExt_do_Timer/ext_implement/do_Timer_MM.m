//
//  do_Timer_MM.m
//  DoExt_MM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Timer_MM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"

@implementation do_Timer_MM {
    dispatch_source_t _timer;
    BOOL _isOn;
}

#pragma mark - 注册属性（--属性定义--）
/*
 [self RegistProperty:[[doProperty alloc]init:@"属性名" :属性类型 :@"默认值" : BOOL:是否支持代码修改属性]];
 */
-(void)OnInit
{
    [super OnInit];
    //注册属性
    [self RegistProperty:[[doProperty alloc]init:@"interval" :Number :@"1000" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"delay" :Number :@"0" :NO]];
}

//销毁所有的全局对象
-(void)Dispose
{
    //自定义的全局属性
    if(_isOn) dispatch_suspend(_timer);
    _timer = nil;
}
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
 - (void)start:(NSArray *)parms
 {
//     doJsonNode *_dictParas = [parms objectAtIndex:0];
     doInvokeResult * _invokeResult = [parms objectAtIndex:2];
//     id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
     //自己的代码实现
     
     NSString *intervalStr = [self GetPropertyValue:@"interval"];
     if(!intervalStr || [intervalStr isEqualToString:@""])
         intervalStr = [self GetProperty:@"interval"].DefaultValue;
     
     NSString *delay = [self GetPropertyValue:@"delay"];
     if(!delay || [delay isEqualToString:@""])
         delay = [self GetProperty:@"delay"].DefaultValue;
     
     uint64_t interval = [intervalStr intValue] * USEC_PER_SEC;
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
     dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
     dispatch_source_set_event_handler(_timer, ^()
     {
         NSLog(@"Timer %@", [NSThread currentThread]);
         [self.EventCenter FireEvent:@"tick" :_invokeResult];
     });
     [self performSelector:@selector(onTimeStart:) withObject:_invokeResult afterDelay:[delay intValue]*1.0/1000];
 }

- (void)onTimeStart:(doInvokeResult *)_invokeResult {
    [_invokeResult SetResultText:@"start"];
    dispatch_resume(_timer);
    _isOn = YES;
}

 - (void)stop:(NSArray *)parms
 {
//     doJsonNode *_dictParas = [parms objectAtIndex:0];
//     id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
     //自己的代码实现
     
     dispatch_suspend(_timer);
     doInvokeResult * _invokeResult = [parms objectAtIndex:2];
     [_invokeResult SetResultText:@"stop"];
     _isOn = NO;
 }
//异步

@end
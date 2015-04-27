//
//  doModuleBase.h
//  DoCore
//
//  Created by 刘吟 on 15/2/26.
//  Copyright (c) 2015年 DongXian. All rights reserved.
//

#import "doModule.h"
#import "doProperty.h"
@protocol doIPage;

@interface doModuleBase : doModule
{
    @protected
    NSMutableDictionary* dictProperties;//处理成员属性
}
#pragma mark -
//当前所属页面
@property (nonatomic,weak) id<doIPage> CurrentPage;
@property (nonatomic,readonly) id<doIScriptEngine> CurrentScriptEngine;

//protected
- (void) RegistProperty: (doProperty*) _property;
- (void) SetPropertyValue: (NSString*) _key : (NSString*) _val;//设置属性值
- (NSString*) GetPropertyValue: (NSString*) _key;//获取属性值
- (doProperty*) GetProperty: (NSString*) _key;//获取属性

#pragma mark -
//virtual
- (BOOL) OnPropertiesChanging:(NSMutableDictionary*) _changedValues;
- (void) OnPropertiesChanged:(NSMutableDictionary*) _changedValues;
- (void) LoadModel: (doJsonNode*) _moduleNode;//装载配置
- (void) SetModelData:(NSMutableDictionary*) _bindParas :(doJsonValue*) _jsonValue;
@end

//
//  Header.h
//  CooperHybrid
//
//  Created by sunleepy on 12-8-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#ifndef CooperHybrid_Header_h
#define CooperHybrid_Header_h

#import <Availability.h>

#ifndef __IPHONE_4_0
#warning "This project uses features only available in iOS SDK 4.0 and later."
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#endif

#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

#ifdef DEBUG
#   define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NSLog(...)
#endif

#import "CodesharpSDK/Tools.h"
#import "CodesharpSDK/MBProgressHUD.h"
#import "SysConfig.h"
#import "CodesharpSDK/NetworkManager.h"

#define RELEASE(_ptr_) if((_ptr_) != nil) {[_ptr_ release]; _ptr_ = nil;}  

//模拟器/设备名称
#define MODEL_NAME                      [[UIDevice currentDevice] model]
#define MODEL_VERSION                   [[[UIDevice currentDevice] systemVersion] floatValue]

//获取任务列表路径
#define GETTASKLISTS_URL                @"/Personal/GetTasklists"
//同步任务列表路径
#define CREATETASKLIST_URL               @"/Personal/CreateTasklist"
//优先级获取路径
#define TASK_GETBYPRIORITY_URL          @"/Personal/GetByPriority"
//同步路径
#define TASK_SYNC_URL                   @"/Personal/Sync"
//注销路径
#define LOGOUT_URL                      @"/Account/logout"

//标题栏
#define APP_TITLE                       @"cooper:task"
//背景图片（条纹）
#define APP_BACKGROUNDIMAGE             @"bg-line.png"
//背景主色调
#define APP_BACKGROUNDCOLOR             [UIColor colorWithRed:47.0/255 green:157.0/255 blue:216.0/255 alpha:1]
//导航背景图片
#define NAVIGATIONBAR_BG_IMAGE          @"navigationbar_bg.png"
//底部栏背景图片
#define TABBAR_BG_IMAGE                 @"tabbar_bg.png"
//编辑按钮图片
#define EDIT_IMAGE                      @"edit.png"
//同步按钮图片
#define REFRESH_IMAGE                   @"refresh.png"
//设置按钮图片
#define SETTING_IMAGE                   @"setting.png"
//后退按钮图片
#define BACK_IMAGE                      @"back.png"

#define PRIORITY_TITLE_1                @"尽快完成"
#define PRIORITY_TITLE_2                @"稍后完成"
#define PRIORITY_TITLE_3                @"迟些再说"
//加载文本
#define LOADING_TITLE                   @"加载中"

#define SYSTEM_REQUEST_TIMEOUT          30.0f
//TODO:半个小时定时器更新一次
#define TIMER_INTERVAL                  0.5 * 60 * 60
//TODO:默认每天早上8点钟推送通知
#define LOCALPUSH_TIME                  8 * 60 * 60

//本地数据库名称
#define STORE_DBNAME                    @"TaskModel.sqlite"

//当前网络提示
#define NOT_NETWORK_MESSAGE             @"当前网络不可用"

//任务列表请求类型
typedef enum {
    FirstGetTasklistsValue,
    GetTasklistsValue,
    CreateTasklistValue
} TasklistRequestType;

//任务请求类型
typedef enum{
    SyncTaskValue,
    GetTasksValue
} TaskRequestType;

//用户相关请求类型
typedef enum {
    LoginValue,
    GoogleLoginValue,
    LogoutValue,
    SyncAllValue,
    GetTasksValue1
} AccountRequestType;

#define MAXLENGTH                       8
#define AES_KEY                         @""

#endif

/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  CooperGap
//
//  Created by sunleepy on 12-7-18.
//  Copyright codesharp 2012年. All rights reserved.
//

//HACK:加上这个很重要的，不然有可能无法运行PhoneGap
NSString * const NSURLIsExcludedFromBackupKey = @"NSURLIsExcludedFromBackupKey";

#import "AppDelegate.h"

#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVPlugin.h>
    #import <Cordova/CDVURLProtocol.h>
#else
    #import "CDVPlugin.h"
    #import "CDVURLProtocol.h"
#endif


@implementation AppDelegate

@synthesize window;
@synthesize viewController;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistantStoreCoordiantor;

- (id) init
{	
	/** If you need to do any extra app-specific initialization, you can do it here
	 *  -jm
	 **/
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage]; 
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
    [CDVURLProtocol registerURLProtocol];
    
    return [super init];
}

#pragma UIApplicationDelegate implementation

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{    
    [ConstantClass loadFromCache]; 
    
    //TODO:为了能够初始化刷新数据库产生的延迟
    [self managedObjectContext];
    //[ContextManager instance];
    
    if([[ConstantClass instance] rootPath] == nil)
    {
        [[ConstantClass instance] setRootPath:[[[SysConfig instance] keyValue] objectForKey: @"env_path"]];
        [ConstantClass savePathToCache];
    }
    
    NSLog(@"当前网络根路径: %@",[[ConstantClass instance] rootPath]);
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
    self.window.autoresizesSubviews = YES;
    
    self.viewController = [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
//    NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
//    NSString* invokeString = nil;
//    
//    if (url && [url isKindOfClass:[NSURL class]]) {
//        invokeString = [url absoluteString];
//		NSLog(@"CooperGap launchOptions = %@", url);
//    }    
//    
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
//    self.window.autoresizesSubviews = YES;
//    
//    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
//    
//    self.viewController = [[[TaskListViewController alloc] init] autorelease];
//    self.viewController.useSplashScreen = YES;
//    self.viewController.wwwFolderName = @"www";
//    self.viewController.startPage = @"index.html";
//    self.viewController.invokeString = invokeString;
//    self.viewController.view.frame = viewBounds;
//    
//    // check whether the current orientation is supported: if it is, keep it, rather than forcing a rotation
//    BOOL forceStartupRotation = YES;
//    UIDeviceOrientation curDevOrientation = [[UIDevice currentDevice] orientation];
//    
//    if (UIDeviceOrientationUnknown == curDevOrientation) {
//        // UIDevice isn't firing orientation notifications yet… go look at the status bar
//        curDevOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
//    }
//    
//    if (UIDeviceOrientationIsValidInterfaceOrientation(curDevOrientation)) {
//        for (NSNumber *orient in self.viewController.supportedOrientations) {
//            if ([orient intValue] == curDevOrientation) {
//                forceStartupRotation = NO;
//                break;
//            }
//        }
//    } 
//    
//    if (forceStartupRotation) {
//        NSLog(@"supportedOrientations: %@", self.viewController.supportedOrientations);
//        // The first item in the supportedOrientations array is the start orientation (guaranteed to be at least Portrait)
//        UIInterfaceOrientation newOrient = [[self.viewController.supportedOrientations objectAtIndex:0] intValue];
//        NSLog(@"AppDelegate forcing status bar to: %d from: %d", newOrient, curDevOrientation);
//        [[UIApplication sharedApplication] setStatusBarOrientation:newOrient];
//    }
//    
//    [self.window addSubview:self.viewController.view];
//    [self.window makeKeyAndVisible];
    
    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if CooperGap-Info.plist specifies a protocol to handle
- (BOOL) application:(UIApplication*)application handleOpenURL:(NSURL*)url 
{
    if (!url) { 
        return NO; 
    }
    
//	// calls into javascript global function 'handleOpenURL'
//    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
//    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];
//    
//    // all plugins will get the notification, and their handlers will be called 
//    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];
    
    return YES;    
}

- (void) dealloc
{
    [managedObjectModel release];
    [managedObjectContext release];
    [persistentStoreCoordinator release];

	[super dealloc];
}

#pragma mark - Core Data 相关

//返回托管对象上下文，如果不存在，将从持久化存储协调器创建它
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}
//返回托管的对象模型，如果模型不存在，将在application bundle找到所有的模型创建它
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}
//返回应用程序的持久化存储协调器，如果不存在，从应用程序的store创建它
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: STORE_DBNAME]];
    NSLog(@"storeurl: %@", [storeUrl relativeString]);
    //HACK:可以保持数据库自动兼容
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		NSLog(@"sqlite数据库异常解析： %@, %@", error, [error userInfo]);
		abort();
    }    
    
    return persistentStoreCoordinator;
}
//应用程序的Documents目录路径
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end

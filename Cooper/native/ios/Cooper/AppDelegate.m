//
//  AppDelegate.m
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize timer;

#pragma mark - application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //load from cache to get user info
    [Constant loadFromCache]; 
    
    NSLog(@"pth3:%@", [[Constant instance] path]);
    if([[Constant instance] path] == nil)
    {
        NSLog(@"path:%@", ENV_PATH);
        [[Constant instance] setPath:ENV_PATH];
        [Constant savePathToCache];
    }
    else {
        NSLog(@"pth2:%@", [[Constant instance] path]);
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //the controller of first load page
    self.mainViewController = [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    navController.navigationBar.tintColor = [UIColor redColor];
    self.window.backgroundColor = [UIColor redColor];
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];  
//    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];  
//    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];  
//    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];  
//    NSString *label = [NSString stringWithFormat:@"%@ v%@ (build %@)", name, version, build];
//    
//    NSLog(@"version:%@", label);
    
    //init timer
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    
    //NSSetUncaughtExceptionHandler(handleRootException);
    
    return YES;
}
     
//static void hadnleRootExcetion(NSException *exception)
//{
//    
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"saveToCache");
    //background process save NSUserDefaults cache
    //[Constant saveToCache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //重新激活程序时触发
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //chear managedObjectContext
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

//处理提交同步，每30秒
//- (void)handleTimer:(NSTimer*)timer
//{
//}

- (void)dealloc
{
    [managedObjectModel release];
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    //[timer release];
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
    NSLog(@"storeUrl: %@", [storeUrl relativeString]);
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
    return persistentStoreCoordinator;
}
//应用程序的Documents目录路径
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end

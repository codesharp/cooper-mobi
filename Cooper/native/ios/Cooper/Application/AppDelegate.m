//
//  AppDelegate.m
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AppDelegate.h"
#import "Task.h"

@class TaskDao;

@implementation AppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize timer;

#pragma mark - 应用程序生命周期

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ConstantClass loadFromCache]; 
    
    //TODO:为了能够初始化刷新数据库产生的延迟
    [self managedObjectContext];
    
    if([[ConstantClass instance] rootPath] == nil)
    {
        [[ConstantClass instance] setRootPath:[[[SysConfig instance] keyValue] objectForKey: @"env_path"]];
        [ConstantClass savePathToCache];
    }
    
    NSLog(@"当前网络根路径: %@",[[ConstantClass instance] rootPath]);
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    self.mainViewController = [[[MainViewController alloc] init] autorelease];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];

    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    //应用徽章数字置零
    application.applicationIconBadgeNumber = 0; 
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];  
//    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];  
//    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];  
//    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];  
//    NSString *label = [NSString stringWithFormat:@"%@ v%@ (build %@)", name, version, build];
//    
//    NSLog(@"version:%@", label);
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
//    [self.timer fire];
    //NSSetUncaughtExceptionHandler(handleRootException);
    
    //[self localPush];
    
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
    NSLog(@"进入后台运行程序");
    [ConstantClass saveToCache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"重新激活程序");
    
    if([[ConstantClass instance] isLocalPush])
        [self localPush];
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

//处理提交同步,本地通知等等
//- (void)handleTimer:(NSTimer*)timer
//{
//    [self localPush];
//}

- (void)dealloc
{
    [managedObjectModel release];
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [mainViewController release];
    NSLog(@"dealloc app");
    //[timer release];
    [super dealloc];
}

//本地推送通知
- (void)localPush
{
    NSLog(@"开始执行本地推送通知");
    
    TaskDao *taskDao = [[[TaskDao alloc] init] autorelease];
    
    NSMutableArray *tasks = [taskDao getTaskByToday];
    
    NSString *todayString = [Tools ShortNSDateToNSString:[NSDate date]];
    NSDate *today = [Tools NSStringToShortNSDate:todayString];
    NSLog(@"当前日期: %@", [Tools NSDateToNSString:today]);
    NSLog(@"今天有 %d 个未完成的任务", tasks.count);
    
    if(tasks.count == 0)
        return;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    int interval = LOCALPUSH_TIME;
    interval = (9 * 60 * 60 + 9 * 60 + 0);
    
    NSDate *fireDate = [[NSDate alloc] initWithTimeInterval:interval 
                                                  sinceDate:today];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if(localNotification == nil)
    {
        NSLog(@"localNotification创建为空");
        return nil;
    }
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:@"您有%d条未完成的任务即将过期，请及时处理", tasks.count]; 
    localNotification.alertAction = @"查看详情";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = tasks.count;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];  
    [localNotification release];  
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

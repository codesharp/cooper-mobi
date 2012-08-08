//
//  ContextManager.h
//  CooperCore
//
//  Created by sunleepy on 12-8-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CodesharpSDK/NetworkManager.h"
//#import "NetworkManager.h"

@interface ContextManager : NSObject
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

+ (id)instance;

@property (retain, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (retain, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic, readonly) NSPersistentStoreCoordinator *persistantStoreCoordiantor;

@end

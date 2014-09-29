//
//  AppDelegate.h
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSManagedObjectModel *)managedObjectModel;
-(NSManagedObjectContext *)managedObjectContext;
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

-(void)saveContext;
-(NSURL *)applicationDocumentDictionary;

@end

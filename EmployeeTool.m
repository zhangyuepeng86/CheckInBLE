 //
//  EmployeeTool.m
//  CheckInBLE
//
//  Created by onemade on 14-9-11.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import "EmployeeTool.h"

@implementation EmployeeTool
single_for_implementation(EmployeeTool)

-(AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

-(BOOL)isEmployeeExist:(int)identifier
{
    NSError *error = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",[NSNumber numberWithInteger:identifier]];
    NSFetchRequest *request = [self requestWithPredicate:predicate];
    [request setFetchLimit:1];
    
    NSUInteger existCount = [[[self appDelegate] managedObjectContext] countForFetchRequest:request error:&error];
    if (existCount > 0) {
        return YES;
    }
    return  NO;
}

-(BOOL)addEmployee:(Employee *)emp
{
    NSError *error = nil;
    
    BOOL isSaveSuccess = [[[self appDelegate] managedObjectContext] save:&error];
    if (!isSaveSuccess) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加失败" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    return isSaveSuccess;
}

-(BOOL)updateEmployee:(Employee *)curEmp
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",curEmp.identifier];
    NSFetchRequest *request = [self requestWithPredicate:predicate];
    [request setFetchLimit:1];
    
    NSError * error = nil;
    NSMutableArray *mutableFetchResult = [[[self appDelegate].managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
        return NO;
    }
    
    for (Employee *employee in mutableFetchResult) {
        employee.identifier = curEmp.identifier;
        [[self appDelegate].managedObjectContext save:&error];
        return YES;
    }
    
    return NO;
}

#pragma mark - 返回一个查询请求
-(NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:[self appDelegate].managedObjectContext];
    [request setEntity:entity];
    [request setPredicate:predicate];
    return request;
}

-(BOOL)deleteEmployee:(Employee *)curEmp
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", curEmp.identifier];
    NSFetchRequest *request = [self requestWithPredicate:predicate];
    [request setPredicate:predicate];
    [request setFetchLimit:1];
    
    NSError * error = nil;
    
    NSMutableArray * mutableFetchResult = [[[self appDelegate].managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
        return NO;
    }
    for (Employee * employee in mutableFetchResult) {
        [[self appDelegate].managedObjectContext deleteObject:employee];
        [[self appDelegate].managedObjectContext save:&error];
        return YES;
    }
    
    return NO;
}

-(NSMutableArray *)fetchAllEmployees
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError * error = nil;
    
    return [[[self appDelegate].managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
}

-(Employee *)findEmployeeById:(int)identifier
{
    NSMutableArray *allEmployees = [self fetchAllEmployees];
    for (Employee *employee in allEmployees) {
        if ([employee.identifier intValue] == identifier) {
            return employee;
        }
    }
    return nil;
}

@end

//
//  EmployeeTool.h
//  CheckInBLE
//
//  Created by onemade on 14-9-11.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Employee.h"

@interface EmployeeTool : NSObject

//单例
singleton_for_interface(EmployeeTool)

@property(strong,nonatomic) Employee *curEmp;

-(BOOL)isEmployeeExist:(int)identifier;
-(BOOL)addEmployee:(Employee *)emp;
-(BOOL)updateEmployee:(Employee *)curEmp;
-(BOOL)deleteEmployee:(Employee *)curEmp;
-(NSMutableArray *)fetchAllEmployees;
-(Employee *)findEmployeeById:(int)indentifier;

@end

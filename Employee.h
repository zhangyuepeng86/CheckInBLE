//
//  Employee.h
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject

@property (nonatomic, retain) NSData * headImage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSNumber * identifier;

@end

//
//  RootTableViewController.h
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEmployeeController.h"
#import "EditEmployeeViewController.h"
#import "CheckInViewController.h"
#import "SendDataViewController.h"
#import "EmployeeTool.h"
#import "EmployeeInfoCell.h"
#import "AppDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface RootTableViewController : UITableViewController<CBCentralManagerDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *optionSegmentControl;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary * beaconData;
@property (strong, nonatomic) NSMutableArray * employees;

@end

//
//  CheckInViewController.h
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface CheckInViewController : UIViewController<CBPeripheralManagerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *containerScroll;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *identifierTextField;
@property (weak, nonatomic) IBOutlet UILabel *checkStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkInBTN;

@property (strong, nonatomic) CBPeripheralManager * peripheralManager;
@property (strong, nonatomic) CLBeaconRegion * beaconRegion;
@property (strong, nonatomic) NSDictionary * beaconData;


- (IBAction)checkInBTNPress:(id)sender;
@end

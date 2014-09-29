//
//  CheckInViewController.m
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import "CheckInViewController.h"

@interface CheckInViewController ()

@end

@implementation CheckInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//        [self.containerScroll setContentSize:self.view.frame.size-self.navigationController.navigationBar.frame.size];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initPeripheralBeaconWithMajor:(int)major withMinor:(int)minor
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:iBeacon_UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:major minor:minor identifier:iBeacon_Identifier];
    self.beaconData = [self.beaconRegion peripheralDataWithMeasuredPower:@-59];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}


#pragma mark - CBPeripheralManagerDelegate
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"start advertising");
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        self.checkStatusLabel.text = @"签到中。。。";
        [self.peripheralManager startAdvertising:self.beaconData];
    }else if (peripheral.state == CBPeripheralManagerStatePoweredOff){
        self.checkStatusLabel.text = @"请检查蓝牙状态";
    }else if (peripheral.state == CBPeripheralManagerStateUnsupported){
        self.checkStatusLabel.text = @"该设备不支持";
    }
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:1.0 animations:^{
    [self.containerScroll setContentSize:CGSizeMake(self.containerScroll.frame.size.width, self.view.frame.size.height-70)];
    }];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.containerScroll setContentSize:CGSizeMake(self.containerScroll.frame.size.width, self.view.frame.size.height+200)];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1004) {
        [UIView animateWithDuration:1.0 animations:^{
            [self.containerScroll setContentSize:CGSizeMake(self.containerScroll.frame.size.width, self.view.frame.size.height-70)];
        }];
    }
}

-(void)broadcasting
{
    [self.peripheralManager stopAdvertising];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)checkInBTNPress:(id)sender {
    if (self.identifierTextField.text == nil || self.identifierTextField.text.length==0) {
        [self.identifierTextField becomeFirstResponder];
        return;
    }
    [self initPeripheralBeaconWithMajor:1 withMinor:[self.identifierTextField.text intValue]];
}
@end

//
//  RootTableViewController.m
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import "RootTableViewController.h"

@interface RootTableViewController ()<UIActionSheetDelegate>
{
    NSMutableArray *allEmployees;
    NSMutableArray *laterEmployees;
    NSMutableArray *checkInEmployees;
    NSInteger currCount;
}

@end

@implementation RootTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initLocationManager
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:iBeacon_UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:iBeacon_Identifier];
    self.beaconData = [[NSDictionary alloc] init];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}


-(void)startCallTheRoll
{
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)stopCallTheRoll
{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self loadAllEmployees];
    [self initLocationManager];
    [self startCallTheRoll];
    
    [self.optionSegmentControl addTarget:self action:@selector(changeOptions:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.optionSegmentControl.selectedSegmentIndex = -1;
        [self loadAllEmployees];
     [self.tableView reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self loadAllEmployees];
//        [self initLocationManager];
//        [self startCallTheRoll];
//        [self.tableView reloadData];
//    });
}

-(void)changeOptions:(UISegmentedControl *)seg
{
    if (seg.selectedSegmentIndex == 0) {
        [self stopCallTheRoll];
        CheckInViewController *checkInCOntroller = [self.storyboard instantiateViewControllerWithIdentifier:@"checkin"];
        [self.navigationController pushViewController:checkInCOntroller animated:YES];
    }
    else{
        
        UIMenuItem *broadcast = [[UIMenuItem alloc] initWithTitle:@"服务器端"action:@selector(advertiser:)];
        UIMenuItem *reciever = [[UIMenuItem alloc] initWithTitle:@"客户端"action:@selector(browser:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:broadcast, reciever, nil]];
        [menu setTargetRect:self.optionSegmentControl.frame inView:self.optionSegmentControl];
        [menu setMenuVisible:YES animated:YES];
//        SendDataViewController *sendDataController = [self.storyboard instantiateViewControllerWithIdentifier:@"sendData"];
//        [self.navigationController pushViewController:sendDataController animated:YES];
    }
}
- (void)advertiser:(id)sender {
    SendDataViewController *sendDataController = [self.storyboard instantiateViewControllerWithIdentifier:@"sendData"];
    [self.navigationController presentViewController:sendDataController animated:YES completion:^{
        [sendDataController initAdvertiser];
    }];
}

- (void)browser:(id)sender {
    SendDataViewController *sendDataController = [self.storyboard instantiateViewControllerWithIdentifier:@"sendData"];

//    [self.navigationController pushViewController:sendDataController animated:YES];
//        [sendDataController initBrowser];
    
    [self.navigationController presentViewController:sendDataController animated:YES completion:^{
        [sendDataController initBrowser];
    }];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *headerLabel = [[UIButton alloc] initWithFrame:CGRectZero];
    if (section == 0) {
//        headerLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//        headerLabel.backgroundColor = [UIColor lightGrayColor];
//        headerLabel.text = @"  签到人员";
//        headerLabel.textColor = [UIColor blackColor];
        
//        headerLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [headerLabel setBackgroundColor:[UIColor lightGrayColor]];
        [headerLabel setTitle:@"  签到人员" forState:UIControlStateNormal];
        [headerLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [headerLabel addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        return headerLabel;
    }else if (section==1){
//        headerLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//        headerLabel.backgroundColor = [UIColor redColor];
//        headerLabel.text = @"  未到人员";
//        headerLabel.textColor = [UIColor blackColor];
//        headerLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        
        [headerLabel setBackgroundColor:[UIColor redColor]];
        [headerLabel setTitle:@"  未到人员" forState:UIControlStateNormal];
        [headerLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        return headerLabel;
    }
    return headerLabel;
}
-(void)click:(UIButton *)btn
{
    NSLog(@"click");
    laterEmployees = [allEmployees mutableCopy];
    checkInEmployees = [NSMutableArray array];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return checkInEmployees.count;
    }else if (section == 1){
        return  laterEmployees.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
//    NSString *cellIdentifier = @"employeeInfo";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
//    }
//    
//    Employee *emp =[allEmployees objectAtIndex:[indexPath row]];
//    cell.textLabel.text = emp.name;
//    cell.detailTextLabel.text = emp.position;
//    cell.imageView.image = [UIImage imageWithData:emp.headImage];
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"EmployeeInfoCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"EmployeeInfoCell"];
        nibsRegistered = YES;        
    }
    
    
    EmployeeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeInfoCell" forIndexPath:indexPath];
    Employee *emp = nil;
    
    if (section == 1) {
        emp =[laterEmployees objectAtIndex:row];
    }else{
        if (checkInEmployees.count>0) {
            emp = [checkInEmployees objectAtIndex:row];
        }
    }
    cell.name.text = emp.name;
    cell.position.text = emp.position;
    cell.headImage.image = [UIImage imageWithData:emp.headImage];
    cell.identifier.text = [emp.identifier stringValue];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableView.isEditing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    Employee *emp = nil;
    if (section == 0&&checkInEmployees.count>0) {
        
        emp = [checkInEmployees objectAtIndex:row];
        [checkInEmployees removeObject:emp];
        
    }else if(laterEmployees.count>0){
        
        emp = [laterEmployees objectAtIndex:row];
        [laterEmployees removeObject:emp];
    }
    
    
    if (emp != nil) {

     [allEmployees removeObject:emp];
    [[EmployeeTool sharedEmployeeTool] deleteEmployee:emp];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Employee *emp = nil;
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    if (section == 0&&checkInEmployees.count>0) {
        emp = [checkInEmployees objectAtIndex:row];
    }else if(laterEmployees.count>0){
        emp = [laterEmployees objectAtIndex:row];
    }
    
    if (emp != nil) {
        EditEmployeeViewController *editEmployeeController = [self.storyboard instantiateViewControllerWithIdentifier:@"editEmployee"];
        [self.navigationController presentViewController:editEmployeeController animated:YES completion:^{
            editEmployeeController.currEmp = emp;
            [editEmployeeController.headImageBTN setBackgroundImage:[UIImage imageWithData:emp.headImage] forState:UIControlStateNormal];
            editEmployeeController.nameField.text = emp.name;
            editEmployeeController.positionField.text = emp.position;
            editEmployeeController.departmentField.text = emp.department;
            editEmployeeController.identifierField.text = [emp.identifier stringValue];
        }];
    }

}

#pragma mark - centralManager delegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请打开蓝牙" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil,nil];
        [actionSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0) {
//         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]; //for ios8 only
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Bluetooth"]];
    }
}

#pragma mark - LocationManager delegate
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self startCallTheRoll];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
    [self stopCallTheRoll];
}



-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
//    for (CLBeacon * beacon in beacons) {
//        for (Employee* emp in allEmployees) {
//            if ([emp.identifier intValue] == [beacon.minor intValue]) {
//                [checkInEmployees addObject:emp];
////                [laterEmployees removeObject:emp];
//            
//            if (beacon.proximity == CLProximityFar||beacon.proximity == CLProximityUnknown) {
//                [checkInEmployees removeObject:emp];
//            }}
//        }
//    }
////    laterEmployees = allEmployees;
//    [laterEmployees removeObjectsInArray:checkInEmployees];
//    [self.tableView reloadData];
    NSMutableArray* employeesToDelete = [NSMutableArray array];
    for (CLBeacon* beacon in beacons) {
        for (Employee* emp in allEmployees) {
            if ([beacon.minor intValue] == [emp.identifier intValue]) {
                for (Employee* emp in laterEmployees) {
                    if ([emp.identifier intValue] == [beacon.minor intValue]) {
                        [employeesToDelete addObject:emp];
                    }
                }
            }
        }
    }
    if (employeesToDelete.count>0) {
        [laterEmployees removeObjectsInArray:employeesToDelete];
        checkInEmployees = [allEmployees mutableCopy] ;
        [checkInEmployees removeObjectsInArray:laterEmployees];
        [self.tableView reloadData];
    }
   
}


//- (NSIndexPath *)tableView:(UITableView *)tableView
//  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadAllEmployees
{
    allEmployees = [[EmployeeTool sharedEmployeeTool] fetchAllEmployees];
    currCount = allEmployees.count;
    if (checkInEmployees == nil) {
        checkInEmployees = [NSMutableArray array];
    }
    if (laterEmployees == nil||checkInEmployees.count==0) {
        laterEmployees = [allEmployees mutableCopy];
    }
    
    [self.tableView reloadData];
}

@end

//
//  AddEmployeeController.h
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import "EmployeeTool.h"
#import "AppDelegate.h"

@interface AddEmployeeController : UIViewController<UINavigationControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property(strong,nonatomic) Employee *currEmp;

@property (weak, nonatomic) IBOutlet UIScrollView *containScrollView;

@property (weak, nonatomic) IBOutlet UIButton *headImageBTN;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *departmentField;
@property (weak, nonatomic) IBOutlet UITextField *positionField;
@property (weak, nonatomic) IBOutlet UITextField *identifierField;

@property (weak, nonatomic) IBOutlet UIButton *addBTN;
@property (weak, nonatomic) IBOutlet UIButton *cancelBTN;
- (IBAction)getHeadImage:(id)sender;
- (IBAction)addBTNPress:(id)sender;

- (IBAction)cancelBTNPress:(id)sender;
@end

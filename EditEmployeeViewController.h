//
//  EditEmployeeViewController.h
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import "EmployeeTool.h"

@interface EditEmployeeViewController : UIViewController<UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate, UITextFieldDelegate>

@property(strong,nonatomic) Employee *currEmp;
@property (weak, nonatomic) IBOutlet UIScrollView *containScrollView;

@property (weak, nonatomic) IBOutlet UIButton *headImageBTN;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *departmentField;
@property (weak, nonatomic) IBOutlet UITextField *positionField;
@property (strong, nonatomic) IBOutlet UITextField *identifierField;
@property (weak, nonatomic) IBOutlet UIButton *updataBTN;
@property (weak, nonatomic) IBOutlet UIButton *deleteBTN;
@property (weak, nonatomic) IBOutlet UIButton *cancelBTN;

- (IBAction)updateHeadImage:(id)sender;
- (IBAction)updateBTNPress:(id)sender;
- (IBAction)deleteBTNPress:(id)sender;
- (IBAction)cancelBTNPress:(id)sender;

@end

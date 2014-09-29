//
//  EditEmployeeViewController.m
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import "EditEmployeeViewController.h"

@interface EditEmployeeViewController ()
{
    UIImage *selectImage;
}
@end

@implementation EditEmployeeViewController

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
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)updateHeadImage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"编辑头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"图片库", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)updateBTNPress:(id)sender {
    NSString *name = self.nameField.text;
    NSString *position  = self.positionField.text;
    NSData *headImage= nil;
    NSString *department = self.departmentField.text;
    NSInteger identifier = [self.identifierField.text intValue];
    if (selectImage != nil) {
        headImage = UIImagePNGRepresentation(selectImage);
    }else{
        headImage = UIImagePNGRepresentation([self.headImageBTN backgroundImageForState:UIControlStateNormal]);
    }
    
    self.currEmp.name = name;
    self.currEmp.headImage = headImage;
    self.currEmp.position = position;
    self.currEmp.department = department;
    self.currEmp.identifier = [NSNumber numberWithInteger:identifier];
    
    [EmployeeTool sharedEmployeeTool].curEmp  = self.currEmp;
   BOOL isUpdateSuccess = [[EmployeeTool sharedEmployeeTool] updateEmployee:self.currEmp];
    if (isUpdateSuccess) {
        [self cancelBTNPress:nil];
    }
}

- (IBAction)deleteBTNPress:(id)sender {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"删除该员工信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
}
    
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [EmployeeTool sharedEmployeeTool].curEmp = self.currEmp ;
        BOOL isDeleteSuccess = [[EmployeeTool sharedEmployeeTool] deleteEmployee:self.currEmp];
        if (isDeleteSuccess) {
            [self cancelBTNPress:nil];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setEditing:YES];
    
    if (buttonIndex == 0) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else{
        return;
    }
    [self presentViewController:imagePicker animated:YES completion:^{}];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        selectImage = info[@"UIImagePickerControllerOriginalImage"];
        [self.headImageBTN setBackgroundImage:selectImage forState:UIControlStateNormal];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:1.0 animations:^{
        [self.containScrollView setContentSize:CGSizeMake(self.containScrollView.frame.size.width, self.view.frame.size.height)];
    }];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.containScrollView setContentSize:CGSizeMake(self.containScrollView.frame.size.width, self.view.frame.size.height+200)];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1004) {
        [UIView animateWithDuration:1.0 animations:^{
            [self.containScrollView setContentSize:CGSizeMake(self.containScrollView.frame.size.width, self.view.frame.size.height)];
        }];
    }
}

- (IBAction)cancelBTNPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end

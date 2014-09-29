//
//  AddEmployeeController.m
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import "AddEmployeeController.h"

@interface AddEmployeeController ()
{
    UIImage * selectImage;
}
@end

@implementation AddEmployeeController

-(AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

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
    [self.containScrollView setContentSize:self.view.frame.size];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//      [self animateTextField:textField up:YES];
//    [self.containScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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

//      [self animateTextField:textField up:NO];
//    [self.containScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 80;
    const float movementDuration = 0.3f;
    int movement = (up?-movementDistance:movementDistance);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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

- (IBAction)addBTNPress:(id)sender {
    if (self.identifierField.text== nil || [self.identifierField.text isEqualToString:@""]) {
        [self.identifierField becomeFirstResponder];
        return;
    }else if (self.nameField.text == nil || [self.nameField.text isEqualToString:@""]){
        [self.identifierField becomeFirstResponder];
        return;
    }
    
    NSString *name = self.nameField.text;
    NSString *position = self.positionField.text;
    NSString *department = self.departmentField.text;
    int identifier  =[self.identifierField.text intValue];
    
    NSData * headImage;
    if (selectImage == nil) {
        UIImage *img = [self.headImageBTN backgroundImageForState:UIControlStateNormal];
        headImage = UIImagePNGRepresentation(img);
    }else{
        headImage = UIImagePNGRepresentation(selectImage);
    }
    
    Employee *employee = nil;
    BOOL isExist = NO;
    BOOL isSaveSuccess = NO;

    isExist = [[EmployeeTool sharedEmployeeTool] isEmployeeExist:identifier];
 

    if (isExist) {
        employee = [[EmployeeTool sharedEmployeeTool] findEmployeeById:identifier];
        employee.headImage = headImage;
        employee.name = name;
        employee.position = position;
        employee.department = department;
        employee.identifier = [NSNumber numberWithInteger:identifier];
       isSaveSuccess = [[EmployeeTool sharedEmployeeTool] updateEmployee:employee];
    }else{
        employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:[self appDelegate].managedObjectContext];
        employee.headImage = headImage;
        employee.name = name;
        employee.position = position;
        employee.department = department;
        employee.identifier = [NSNumber numberWithInteger:identifier];
        [EmployeeTool sharedEmployeeTool].curEmp = employee;
       isSaveSuccess = [[EmployeeTool sharedEmployeeTool] addEmployee:employee];
    }    

    if (isSaveSuccess) {
        [self cancelBTNPress:nil];
    }
}

- (IBAction)getHeadImage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"编辑头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"图片库", nil];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    
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
        selectImage = info[@"UIImagePickerControllerEditedImage"];
        [self.headImageBTN setBackgroundImage:selectImage forState:UIControlStateNormal];
    }];
}

- (IBAction)cancelBTNPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end

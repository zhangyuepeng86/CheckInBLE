//
//  SendDataViewController.m
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import "SendDataViewController.h"

@interface SendDataViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,MPMediaPickerControllerDelegate>
{
    UIImage *selectImage;
}
@end

@implementation SendDataViewController

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
    [self.optionSegment addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    self.optionSegment.selectedSegmentIndex = -1;
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
//    [self stopAdvertising];
//    [self stopBrowser];
    [super viewDidDisappear:animated];
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

#pragma mark - UITextView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    //设置style
    [topView setBarStyle:UIBarStyleDefault];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    
    [textView setInputAccessoryView:topView];
    return YES;
}

//隐藏键盘
- (void)resignKeyboard {
    [self.stringToSend resignFirstResponder];
}

#pragma mark - UISegmentControl target
-(void)valueChanged:(UISegmentedControl *)seg
{
    [self.resourceBTN setHidden:YES];
    [self.stringToSend setHidden:NO];
    NSData *data = nil;
    NSError *error = nil;
    if (seg.selectedSegmentIndex==0) {
        [self.stringToSend setText:@""];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"编辑头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"图片库", nil];
        [actionSheet showInView:self.view];
    }else if (seg.selectedSegmentIndex == 1){
        if ([self.stringToSend.text isEqualToString:@""]) {
            [self.stringToSend becomeFirstResponder];
        }
        data = [self.stringToSend.text dataUsingEncoding:NSUTF8StringEncoding];
        [self.dataSession sendData:data toPeers:self.dataSession.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    }else if (seg.selectedSegmentIndex == 2){
        
        MPMediaPickerController *mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMovie];
        mpc.delegate = self;//委托
        mpc.prompt =@"请选择文件";//提示文字
        mpc.allowsPickingMultipleItems=NO;//是否允许一次选择多个
        [self presentViewController:mpc animated:YES completion:^{
            
        }];
        
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            [self stopAdvertising];
            [self stopBrowser];
        }];
    }
    self.optionSegment.selectedSegmentIndex = -1;
}

- (IBAction)getResource:(id)sender {

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


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        selectImage = info[@"UIImagePickerControllerOriginalImage"];
        [self.resourceBTN setHidden:NO];
        [self.stringToSend setHidden:YES];
        [self.resourceBTN setBackgroundImage:selectImage forState:UIControlStateNormal];
        
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
//        UIImage *smallerPhoto = [self rescaleImage:image toSize:CGSizeMake(600,800)];
        NSData *jpeg = UIImageJPEGRepresentation(selectImage, 0.2);
        NSError *error = nil;
        [self.dataSession sendData:jpeg toPeers:[self.dataSession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
    }];
}

#pragma mark - MPMediaPickerController Delegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    /*insert your code*/
    for ( MPMediaItem* item in [mediaItemCollection items]) {
        
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    /*insert your code*/
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)sendInfo:(id)sender {
    
}

#pragma mark - init advertiser
-(void)initAdvertiser
{
    self.advertiserPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.advertiserPeerID discoveryInfo:nil serviceType:svcType];
    self.advertiser.delegate = self;
    self.dataSession = [[MCSession alloc] initWithPeer:self.advertiserPeerID];
    self.dataSession.delegate = self;
    
    [self.advertiser startAdvertisingPeer];
}
-(void)stopAdvertising
{
    [self.advertiser stopAdvertisingPeer];
}

#pragma mark - init browser
-(void)initBrowser
{
    self.browserPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.dataSession = [[MCSession alloc] initWithPeer:self.browserPeerID];
    self.dataSession.delegate = self;
    self.brower = [[MCNearbyServiceBrowser alloc] initWithPeer:self.browserPeerID serviceType:svcType];
    self.brower.delegate = self;
    
    [self.brower startBrowsingForPeers];
}

-(void)stopBrowser
{
    [self.brower stopBrowsingForPeers];
}

#pragma mark - MCNearbyServiceBrowserDelegate
-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [browser invitePeer:peerID
              toSession:self.dataSession
            withContext:nil
                timeout:1000000.0];
}
-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
}
#pragma mark - MCNearByServiceAdvertiserDelegate
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    if ([self.mutableBlockPeers containsObject:peerID]) {
        invitationHandler(NO,nil);
    }
    invitationHandler(YES,self.dataSession);
}
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark - MCSessionDelegate
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSString * status = nil;
    switch (state) {
        case MCSessionStateConnected:
            status = @"Connected";
            break;
        case MCSessionStateConnecting:
            status=@"Connecting";
            break;
        case MCSessionStateNotConnected:
            status = @"DisConnected";
            break;
            
        default:
            break;
    }
    
    NSLog(@"%@",status);
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSString * message = [[NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
    UIImage *image = [UIImage imageWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (image) {
            [self.resourceBTN setHidden:NO];
            [self.stringToSend setHidden:YES];
            [self.resourceBTN setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            [self.resourceBTN setHidden:YES];
            [self.stringToSend setHidden:NO];
            [self.stringToSend setText:message];
        }                                        
    });
}
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}
-(void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler
{
    certificateHandler(YES);
}

#pragma mark - Send Data Option
-(void)sendMessage
{
    
}
-(void)sendImage
{
    
}
-(UIImage*)rescaleImage:(UIImage*)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end

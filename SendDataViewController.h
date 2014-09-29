//
//  SendDataViewController.h
//  CheckInBLE
//
//  Created by onemade on 14-9-10.
//  Copyright (c) 2014年 CNPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <MediaPlayer/MPMediaPickerController.h>

@interface SendDataViewController : UIViewController<UINavigationControllerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate>
@property (strong, nonatomic) MCPeerID * advertiserPeerID;
@property (strong, nonatomic) MCSession * dataSession;
@property (strong, nonatomic) MCNearbyServiceAdvertiser * advertiser;
@property (strong, nonatomic) NSMutableArray * mutableBlockPeers;

@property (strong, nonatomic) MCPeerID *browserPeerID;
@property (strong, nonatomic) MCNearbyServiceBrowser *brower;

@property (strong, nonatomic) IBOutlet UISegmentedControl *optionSegment;
@property (strong, nonatomic) IBOutlet UITextView *stringToSend;

@property (weak, nonatomic) IBOutlet UIButton *resourceBTN;


-(void)initAdvertiser;
-(void)initBrowser;

@end

//
//  BroadcastSetupViewController.h
//  BroadcastSetupUI
//
//  Created by Apple on 2018/6/6.
//  Copyright © 2018年 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReplayKit/ReplayKit.h>

@interface BroadcastSetupViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *channelTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;

@end

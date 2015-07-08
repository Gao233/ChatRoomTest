//
//  SettingsViewController.h
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/22/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <QuartzCore/QuartzCore.h>


@interface SettingsViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) UIImagePickerController *imagepicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecongnizer;

- (IBAction)logout:(id)sender;

@end

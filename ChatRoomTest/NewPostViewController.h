//
//  NewPostViewController.h
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 8/20/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface NewPostViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *theTitle;
@property (weak, nonatomic) IBOutlet UITextView *theContent;
@property (weak, nonatomic) IBOutlet UIButton *choosePic;
@property (strong, nonatomic) IBOutlet PFImageView *image1;
@property (strong, nonatomic) IBOutlet PFImageView *image2;
@property (strong, nonatomic) IBOutlet PFImageView *image3;

- (IBAction)send:(id)sender;

@end

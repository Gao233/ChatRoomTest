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

@interface NewPostViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *theCourse;
@property (weak, nonatomic) IBOutlet UITextField *theCourseNumber;
@property (weak, nonatomic) IBOutlet UITextField *theTitle;
@property (weak, nonatomic) IBOutlet UITextField *theAuthor;
@property (weak, nonatomic) IBOutlet UITextField *thePrice;
@property (weak, nonatomic) IBOutlet UITextField *theProfessor;


- (IBAction)send:(id)sender;

@end

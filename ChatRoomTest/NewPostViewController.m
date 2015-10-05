//
//  NewPostViewController.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 8/20/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController ()

@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    self.theTitle.delegate = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
//    [[self.theContent layer] setBorderColor:[[UIColor grayColor] CGColor]];
//    [[self.theContent  layer] setBorderWidth:2.3];
//    [[self.theContent layer] setCornerRadius:15];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
  

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)send:(id)sender{

    PFObject *post = [PFObject objectWithClassName:@"Post"];
    post[@"course"] = self.theCourse.text;
    post[@"courseNumber"] = self.theCourseNumber.text;
    post[@"title"] = self.theTitle.text;
    post[@"author"] = self.theAuthor.text;
    post[@"price"] = self.thePrice.text;
    post[@"professor"] = self.theProfessor.text;
    post[@"sender"] = [[PFUser currentUser] objectId];
    post[@"senderName"] = [[PFUser currentUser] username];
    post[@"sold"] = @"0";

  if([self.theCourse.text length] == 0 || [self.theCourseNumber.text length] == 0 || [self.theTitle.text length] == 0|| [self.theAuthor.text length] == 0|| [self.thePrice.text length] == 0 )
  {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"Except for Professor, other options should not be blank" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful!" message:@"Your post is sent successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
        }
    }];
  }

}

#pragma mark - dismiss keyboard
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end

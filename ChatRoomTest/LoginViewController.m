//
//  LoginViewController.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/22/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    [self.navigationController setNavigationBarHidden:YES];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
}

- (IBAction)login:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([username length] == 0 || [password length] == 0 ){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"You should enter all correct information" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
        
        [PFUser logInWithUsernameInBackground:username password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if(error){
                                                
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                [alertView show];
                                                
                                            } else {
                                                [self.navigationController setNavigationBarHidden:NO];
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            }
                                        }];
        
        
        
    }
}



#pragma mark - keyboard dismiss
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

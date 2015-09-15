//
//  SettingsViewController.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/22/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet PFImageView *ParseImage;
@property (strong, nonatomic) IBOutlet UILabel *labelName;


//TODO: Finish the Tableview Cell

@end

@implementation SettingsViewController

@synthesize ParseImage, labelName;
//@synthesize cellBlocked, cellPrivacy, cellTerms, cellLogout;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
    
    [ParseImage setUserInteractionEnabled:YES];
    
    self.tapRecongnizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(changeProfile)];
    self.tapRecongnizer.numberOfTapsRequired = 1;

}

- (void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
  
    
    if ([PFUser currentUser] != nil)
    {
        labelName.text = [[PFUser currentUser] username];

        PFFile *userImageFile = self.currentUser[@"profilePic"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    self.image = [UIImage imageWithData:imageData];
                    ParseImage.image = self.image;
                }
            }];
        
        self.image = [UIImage imageNamed:@"blankProfile"];
        ParseImage.image = self.image;
        
//        ParseImage.layer.cornerRadius = ParseImage.frame.size.width/2;
        ParseImage.layer.masksToBounds = YES;
        ParseImage.clipsToBounds = YES;
    
        [ParseImage addGestureRecognizer:self.tapRecongnizer];
        
    }else{
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark - Profile picture

-(void)changeProfile{
        self.imagepicker = [[UIImagePickerController alloc] init];
        self.imagepicker.delegate = self;
        self.imagepicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self presentViewController:self.imagepicker animated:NO completion:nil];

}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:2];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadProfilePicture];
}

#pragma mark - Backend methods
-(void)uploadProfilePicture{
    
    UIImage *newImage = [self resizeImage:self.image toWidth:50.0f andHeight:50.0f];
    NSData *fileData = UIImagePNGRepresentation(newImage);
    PFFile *file = [PFFile fileWithName:@"image.png" data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(error){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured" message:@"Please try to send again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }];
    
    PFUser *user = [PFUser currentUser];
    [user setObject:file forKey:@"profilePic"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(error){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured" message:@"Please try to send again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

#pragma mark - Helper Methods
-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
    
    
}

- (IBAction)logout:(id)sender {

    
    self.currentUser = nil;
    self.image = nil;
    self.ParseImage = nil;
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLoginFromSettings" sender:self];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showLoginFromSettings"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
    }
}

#pragma mark - Table view delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 3;
    if (section == 1) return 1;
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{

}

@end

//
//  ViewPostViewController.h
//  Tango
//
//  Created by Gaoyuan Chen on 8/27/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ViewPostViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

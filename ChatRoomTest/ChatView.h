//
//  ChatView.h
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/30/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"
#import "JSQMessagesBubbleImage.h"
#import <Parse/Parse.h>
#import <ParseUI.h>

@interface ChatView : JSQMessagesViewController<UIActionSheetDelegate, JSQMessageBubbleImageDataSource>

@property (strong, nonatomic) PFUser *reciever;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

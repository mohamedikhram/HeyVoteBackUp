//
//  FollowFollowingViewController.h
//  HeyVote
//
//  Created by Ikhram Khan on 7/29/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowFollowingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray* searchResult;
}
@property (weak, nonatomic) IBOutlet UITableView *phoneTableView;

@property (weak, nonatomic) IBOutlet UITableView *followingTableView;



@property (weak, nonatomic) IBOutlet UIButton *phoneContacts;
- (IBAction)phoneContacts:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *followingContacts;
- (IBAction)followingContacts:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *followingView;

- (IBAction)followCloseButton:(id)sender;



@end

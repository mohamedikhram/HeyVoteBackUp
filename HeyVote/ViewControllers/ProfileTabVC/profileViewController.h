//
//  profileViewController.h
//  HeyVote
//
//  Created by Ikhram Khan on 6/3/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface profileViewController : UIViewController
- (IBAction)myProfileButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *myHeyVoteList;
- (IBAction)myHeyVoteList:(id)sender;
- (IBAction)Notifications:(id)sender;
- (IBAction)myBlockList:(id)sender;
- (IBAction)HeyVoteWeb:(id)sender;
- (IBAction)homeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *contactsButton;
- (IBAction)contactsButton:(id)sender;
- (IBAction)centerButton:(id)sender;
- (IBAction)searchButton:(id)sender;
- (IBAction)profileButton:(id)sender;
- (IBAction)flagPostsButton:(id)sender;

@end

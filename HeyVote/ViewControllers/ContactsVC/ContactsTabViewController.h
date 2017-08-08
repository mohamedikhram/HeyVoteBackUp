//
//  ContactsTabViewController.h
//  HeyVote
//
//  Created by Ikhram Khan on 4/28/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ContactsTabViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate,UISearchDisplayDelegate,UISearchBarDelegate>{
    
    NSArray* searchResult;
}
@property (weak, nonatomic) IBOutlet UITableView *phoneTableView;

- (IBAction)homeButton:(id)sender;
- (IBAction)contactButton:(id)sender;
- (IBAction)centerButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *followingTableView;

- (IBAction)searchButton:(id)sender;

- (IBAction)profileButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *phoneContacts;
- (IBAction)phoneContacts:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *followingContacts;
- (IBAction)followingContacts:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *followingView;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchbar;


@end

//
//  profileViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 6/3/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "profileViewController.h"
#import "myFlagListViewController.h"
#import "homeViewController.h"
#import "searchTabViewController.h"
#import "CameraViewController.h"
#import "ContactsTabViewController.h"
#import "profileDetailsViewController.h"
#import "notificationsViewController.h"

#import "myBlockListViewController.h"

#import "scannerViewController.h"

@interface profileViewController ()

@end

@implementation profileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainMenu:)
                                                 name:@"loginComplete" object:nil];
 
}
- (void)showMainMenu:(NSNotification *)note {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeViewController *myVC = (homeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)myProfileButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    profileDetailsViewController *myVC = (profileDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"profileDetailsViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
}
- (IBAction)myHeyVoteList:(id)sender {
}

- (IBAction)Notifications:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    notificationsViewController *myVC = (notificationsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"notificationsViewController"];
    
   
     [self presentViewController:myVC animated:YES completion:nil];
}

- (IBAction)myBlockList:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myBlockListViewController *myVC = (myBlockListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"myBlockListViewController"];
    
    
    [self presentViewController:myVC animated:YES completion:nil];
}

- (IBAction)HeyVoteWeb:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    scannerViewController *myVC = (scannerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"scannerViewController"];
    
    
    [self presentViewController:myVC animated:YES completion:nil];
}

- (IBAction)homeButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeViewController *myVC = (homeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
}
- (IBAction)contactsButton:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactsTabViewController *myVC = (ContactsTabViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ContactsTabViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
    
}

- (IBAction)centerButton:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraViewController *myVC = (CameraViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    
    
    
    [self presentViewController:myVC animated:YES completion:nil];
}

- (IBAction)searchButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    searchTabViewController *myVC = (searchTabViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchTabViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
}

- (IBAction)profileButton:(id)sender {
    

}

- (IBAction)flagPostsButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myFlagListViewController *myVC = (myFlagListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"myFlagListViewController"];
    
    
    [self presentViewController:myVC animated:YES completion:nil];
    
}


-(void)PushAnimation
{
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.0f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
}





@end

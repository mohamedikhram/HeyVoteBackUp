//
//  CommentVC.m
//  HeyVote
//
//  Created by Ikhram Khan on 5/19/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "CommentVC.h"
#import "UIImageView+WebCache.h"

@interface CommentVC (){
    
    CGRect  replyrect;
}

@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    replyrect =CGRectMake(self.replyInnerView.frame.origin.x, self.replyInnerView.frame.origin.y , self.replyInnerView.frame.size.width, self.replyInnerView.frame.size.height);
    
    
    [_myTableView reloadData];
    
    
    
    [_replyView setHidden:YES];
    [_blurView setAlpha:0];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.replyView addGestureRecognizer:singleFingerTap];
    
    
    
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [UIView animateWithDuration:0.3 animations:^{
                             _blurView.alpha = 0;
                         }];
                         
                         self.replyInnerView.frame = CGRectMake(self.replyInnerView.frame.origin.x, self.replyInnerView.frame.origin.y + self.replyInnerView.frame.size.height, self.replyInnerView.frame.size.width, self.replyInnerView.frame.size.height);
                         
                       
                         
                         
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             
                             [_replyView setHidden:YES];
                             
                             
                         }
                             
                     }];
   
    
    
    //Do stuff here...
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [_arrayVal count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[_arrayVal valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[_arrayVal valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
    
    UIImageView * imgOne = (UIImageView*)[cell viewWithTag:10];
    [imgOne  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"imagesPerson.jpeg"]];
    
    UILabel * labOne = (UILabel*)[cell viewWithTag:11];
    labOne.text =[[_arrayVal valueForKey:@"DisplayName"] objectAtIndex:indexPath.row];
    
    UILabel * labOnee = (UILabel*)[cell viewWithTag:12];
    labOnee.text =[[_arrayVal valueForKey:@"Comment"] objectAtIndex:indexPath.row];

    

    return cell;
}

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  
    
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                           [_replyView setHidden:NO];
                         [UIView animateWithDuration:0.3 animations:^{
                             _blurView.alpha = 0.5;
                         }];
                         
                      
                         self.replyInnerView.frame = replyrect;
                         
                      
                         
                     }
                     completion:^(BOOL finished){
                         
                       
                         
                     }];
    
    
    
}


- (IBAction)cloaseButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)replyyyButton:(id)sender {
    
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [UIView animateWithDuration:0.3 animations:^{
                             _blurView.alpha = 0;
                         }];
                         
                         self.replyInnerView.frame = CGRectMake(self.replyInnerView.frame.origin.x, self.replyInnerView.frame.origin.y + self.replyInnerView.frame.size.height, self.replyInnerView.frame.size.width, self.replyInnerView.frame.size.height);
                         
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             
                             [_replyView setHidden:YES];
                             
                               [_commentTextView becomeFirstResponder];
                         }
                         
                     }];
}

- (IBAction)reporttButton:(id)sender {
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [UIView animateWithDuration:0.3 animations:^{
                             _blurView.alpha = 0;
                         }];
                         
                         self.replyInnerView.frame = CGRectMake(self.replyInnerView.frame.origin.x, self.replyInnerView.frame.origin.y + self.replyInnerView.frame.size.height, self.replyInnerView.frame.size.width, self.replyInnerView.frame.size.height);
                         
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             
                             [_replyView setHidden:YES];
                             
                           
                             
                             
                         }
                         
                     }];
}

- (IBAction)cancelllButton:(id)sender {
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [UIView animateWithDuration:0.3 animations:^{
                             _blurView.alpha = 0;
                         }];
                         
                         self.replyInnerView.frame = CGRectMake(self.replyInnerView.frame.origin.x, self.replyInnerView.frame.origin.y + self.replyInnerView.frame.size.height, self.replyInnerView.frame.size.width, self.replyInnerView.frame.size.height);
                         
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             
                             [_replyView setHidden:YES];
                             
                             
                         }
                         
                     }];
}

- (IBAction)commentSendingButton:(id)sender {
    
    _commentTextView.text = @"";
}
@end

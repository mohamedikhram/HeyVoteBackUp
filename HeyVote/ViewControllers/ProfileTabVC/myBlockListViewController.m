//
//  myBlockListViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 6/5/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "myBlockListViewController.h"

#import "UIImageView+WebCache.h"

#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "WebServiceUrl.h"

@interface myBlockListViewController ()
{
    
    
    NSMutableArray * arrayVal;
    int newVal;
}

@end

@implementation myBlockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    arrayVal = [[NSMutableArray alloc]init];
    
    
    if (arrayVal.count == 0) {
        newVal = 0;
        [self callWebService];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [arrayVal count];
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
    
       
    
    NSString *imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[[[arrayVal valueForKey:@"lstContacts"]objectAtIndex:indexPath.row]valueForKey:@"ImageIdf"]objectAtIndex:0],[[[[arrayVal valueForKey:@"lstContacts"]objectAtIndex:indexPath.row]valueForKey:@"FolderPath"]objectAtIndex:0]];
    
    
  
    
    
    
    
    
    UIImageView * imgOne = (UIImageView*)[cell viewWithTag:10];
    [imgOne  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"imagesPerson.jpeg"]];
    
    UILabel * labOne = (UILabel*)[cell viewWithTag:11];
    labOne.text =[[[[arrayVal valueForKey:@"lstContacts"]objectAtIndex:indexPath.row]valueForKey:@"Name"]objectAtIndex:0];
 
    UIButton *button = (UIButton*)[cell viewWithTag:12];
    [button addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


-(void)unblock:(NSString*)contackToke


{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
if (interNetCheck==YES ) {
    //
    //                    UIView *newView = [[UIView alloc]init];
    //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //                    [self.view addSubview:newView];
    //
    //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
    //
    
    
    
    NSDictionary *jsonDictionary =@{
                                    
                                    @"isWeb":@"false",
                                    @"allowed":[NSNumber numberWithInteger:1],
                                    @"contactToken":contackToke
                                    
                                    };
    
    
    
    
    
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                        
                                                       options:0
                        
                                                         error:&error];
    
    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON OUTPUT: %@",JSONString);
    
    NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/blockunblockuser"]];
    
    
    
    [requestPost setHTTPMethod:@"POST"];
    
    
    
    [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    
    
    
    NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    [requestPost setHTTPBody: requestData];
    
    
    [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
    
    
    
    [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            //do something with error
        } else {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (dic==nil) {
                    
                    
                    
                    
                }
                else{
                    
                    
                    NSLog(@"hjfshjfhs%@",dic);
                    
                    
                    [self showToast:@"Unblocked successfully"];
                    
               
                    
                    
                }
                
                
                
                
            });
        }
    }];
}

else{
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
   
    
}

}






- (void)checkButtonTapped:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
       
        NSLog(@"firstCell %@",indexPath);
        
        
       
        
        [self unblock:[[[[arrayVal valueForKey:@"lstContacts"]objectAtIndex:indexPath.row]valueForKey:@"ContactToken"]objectAtIndex:0]];
        
        
        [arrayVal removeObjectAtIndex:indexPath.row];
        [_myTableView reloadData];
        
        
        
        
        
        
    }
}

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(void)showToast:(NSString*)msg{
    
    [self.view makeToast:msg
                duration:1.0
                position:CSToastPositionCenter];
}


-(void)callWebService{
    
    
    
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false",
                                        @"isBlockedList":[NSNumber numberWithInt:1]
                                       
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/contacts/GetBlockedUserList"]];
        
        
        
        [requestPost setHTTPMethod:@"POST"];
        
        
        
        [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        
        
        
        NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        [requestPost setHTTPBody: requestData];
        
        
        [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
        
        
        
        [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                //do something with error
            } else {
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (dic==nil) {
                        
                        
                        [GMDCircleLoader hideFromView:newView animated:YES];
                        [newView removeFromSuperview];
                        
                        
                    }
                    else{
                        
                        NSLog(@"%@",dic);
                        
                        
                        [arrayVal addObjectsFromArray:[[dic objectForKey:@"GetBlockedUserListResult"] allObjects]];
                        
               
                            [_myTableView reloadData];
               
                 
                        
                        
                        [GMDCircleLoader hideFromView:newView animated:YES];
                        [newView removeFromSuperview];
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                });
            }
        }];
    }
    
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
    
    
    
    
    
    
}



@end

//
//  notificationsViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 6/5/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "notificationsViewController.h"

#import "UIImageView+WebCache.h"

#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "WebServiceUrl.h"

@interface notificationsViewController (){
    
    
    NSMutableArray * arrayVal;
    int newVal;
}

@end

@implementation notificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayVal = [[NSMutableArray alloc]init];
    
    
    if (arrayVal.count == 0) {
        newVal = 0;
        [self callWebService:newVal];
    }
    
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    if (newVal == 1000) {
        
    }
    
    else{
        
        if (indexPath.row == [arrayVal count]-1 ) {
            
            
            int plusVal = newVal+1;
            newVal = plusVal;
            
            [self callWebService:plusVal];
            
            
        }
    }

    
    
    NSString *imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[arrayVal valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[arrayVal valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
    
    
    
    NSString *imageStrPost = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[arrayVal valueForKey:@"Image1Idf"] objectAtIndex:indexPath.row],[[arrayVal valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
    
    
    UIImageView * imgOnePost = (UIImageView*)[cell viewWithTag:13];
    [imgOnePost  sd_setImageWithURL:[NSURL URLWithString:imageStrPost] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    

    
    
    UIImageView * imgOne = (UIImageView*)[cell viewWithTag:10];
    [imgOne  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"imagesPerson.jpeg"]];
    
    UILabel * labOne = (UILabel*)[cell viewWithTag:11];
    labOne.text =[[arrayVal valueForKey:@"DisplayName"] objectAtIndex:indexPath.row];
    
    UILabel * labOnee = (UILabel*)[cell viewWithTag:12];
    if ([[[arrayVal valueForKey:@"TypeId"] objectAtIndex:indexPath.row] integerValue] == 1) {
          labOnee.text = @"Has posted on HeyVote";
    }
    
    else{
        
        labOnee.text = @"Has ReHeyVoted a post on HeyVote";
    }
    

    
    return cell;
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


-(void)callWebService:(int)indexVal{
    
    
    
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false",
                                        @"pageId":[NSNumber numberWithInt:indexVal],
                                        @"pageSize":[NSNumber numberWithInt:40]
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/GetNotificationByUser_New"]];
        
        
        
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
                        
                        NSMutableArray* dataArray = [[NSMutableArray alloc]init];
                        
                        
                        [dataArray addObjectsFromArray:[[dic objectForKey:@"GetNotificationByUser_NewResult"]valueForKey:@"m_Item1"]];
                        
                        if (dataArray.count > 0) {
                            [arrayVal addObjectsFromArray:dataArray];
                            
                       [_myTableView reloadData];
                                
                            }

                    
                        
                        else{
                            
                            [self showToast:@"You dont have notifications right now"];
                            
                            newVal = 1000;
                        }
                        
                        

                        
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

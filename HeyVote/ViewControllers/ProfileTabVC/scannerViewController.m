//
//  scannerViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 6/5/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "scannerViewController.h"
#import "UIView+Toast.h"

@interface scannerViewController ()

@end

@implementation scannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Set verbose logging to YES so we can see exactly what's going on
    [_scannerView setVerboseLogging:YES];
    
    // Set animations to YES for some nice effects
    [_scannerView setAnimateScanner:YES];
    
    // Set code outline to YES for a box around the scanned code
    [_scannerView setDisplayCodeOutline:YES];
    
    // Start the capture session when the view loads - this will also start a scan session
    [_scannerView startCaptureSession];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showToast:(NSString*)msg{
    
    [self.view makeToast:msg
                duration:1.0
                position:CSToastPositionCenter];
}

- (void)didScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType {
    NSLog(@"codeType%@",scannedCode);
    
    
    if (scannedCode.length >0) {
    
            
            BOOL interNetCheck=[WebServiceUrl InternetCheck];
            if (interNetCheck==YES ) {
        
                UIView *newView = [[UIView alloc]init];
                newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                [self.view addSubview:newView];
                
                [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                
                
                
                
                NSDictionary *jsonDictionary =@{
                                                
                                                @"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"],
                                                @"signalRIdf":scannedCode
                                                
                                                
                                                };
                
  
                NSError *error;
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                    
                                                                   options:0
                                    
                                                                     error:&error];
                
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"JSON OUTPUT: %@",JSONString);
                
                NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/LoginWeb"]];
                
                
                
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
             
                                
                                [GMDCircleLoader hideFromView:newView animated:YES];
                                [newView removeFromSuperview];
                                
                                
                                [self dismissViewControllerAnimated:YES completion:nil];
                                
                                [self showToast:@"Logged in HeyVote Web Successfully"];
                                
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

}

- (void)errorGeneratingCaptureSession:(NSError *)error {
    [_scannerView stopCaptureSession];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsupported Device" message:@"This device does not have a camera. Run this app on an iOS device that has a camera." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
   
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
     [_scannerView stopScanSession];
    
}

- (IBAction)backButton:(id)sender {
     [_scannerView stopScanSession];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)errorAcquiringDeviceHardwareLock:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Focus Unavailable" message:@"Tap to focus is currently unavailable. Try again in a little while." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)shouldEndSessionAfterFirstSuccessfulScan {
    // Return YES to only scan one barcode, and then finish - return NO to continually scan.
    // If you plan to test the return NO functionality, it is recommended that you remove the alert view from the "didScanCode:" delegate method implementation
    // The Display Code Outline only works if this method returns NO
    return YES;
}


@end

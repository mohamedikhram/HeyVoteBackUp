//
//  WebServiceUrl.m
//  Kwala
//
//  Created by GItesh on 22/12/14.
//  Copyright (c) 2014 Anushaktinath. All rights reserved.
//

#import "WebServiceUrl.h"
#import "AppDelegate.h"
#import "Reachability.h"

BOOL internetActive;  // object for class method
BOOL hostActive;   // object for class method

NSString * access_tokenString;  // object for class method
NSString * Key;                    // object for class method
NSMutableDictionary* keysAndAuth_tokens;      // object for class method

id jsonResponseData;


Reachability* internetReachable;
Reachability* hostReachable;

@implementation WebServiceUrl

+(BOOL)InternetCheck
{
    internetReachable=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            internetActive = NO;
            return internetActive;
            break;
        }
        case ReachableViaWiFi:
        {
            
            NSLog(@"The internet is working via WiFi");
            internetActive = YES;
            return internetActive;
        }
            break;
            
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via lan");
            
            internetActive = YES;
            
            return internetActive;
            
            break;
        }
            
    }
/*
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            internetActive = YES;
            
            break;
        }
    }
  */
}

+(void)InternetFailErrorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error!"
                                                    message:@"Device is currently not connected to service.Please verify you are connected to a WIFI or 3G enabled Network."
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}


+(NSMutableDictionary*)Authentication_TokenAndKeys
{
    
    keysAndAuth_tokens=[[NSMutableDictionary alloc]init];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"SignUPtoken"]&& [[NSUserDefaults standardUserDefaults]objectForKey:@"SignUP_Key"])
    {
        access_tokenString=[[NSUserDefaults standardUserDefaults]objectForKey:@"SignUPtoken"];
        Key=[[NSUserDefaults standardUserDefaults]objectForKey:@"SignUP_Key"];
    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"SignIntoken"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"SignIn_Key"])
    {
        access_tokenString=[[NSUserDefaults standardUserDefaults]objectForKey:@"SignIntoken"];
        Key=[[NSUserDefaults standardUserDefaults]objectForKey:@"SignIn_Key"];
    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"FACEBOOKauthentication_token"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"fbkey"])
    {
        access_tokenString=[[NSUserDefaults standardUserDefaults]objectForKey:@"FACEBOOKauthentication_token"];
        Key=[[NSUserDefaults standardUserDefaults]objectForKey:@"fbkey"];
    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"Twitter_Authentication_token"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"Twitter_Key"])
    {
        access_tokenString=[[NSUserDefaults standardUserDefaults]objectForKey:@"Twitter_Authentication_token"];
        Key=[[NSUserDefaults standardUserDefaults]objectForKey:@"Twitter_Key"];
    }
    
    [keysAndAuth_tokens setObject:Key forKey:@"key"];
    [keysAndAuth_tokens setObject:access_tokenString forKey:@"access_tokenString"];
   
    return keysAndAuth_tokens;
}



+(id)GetDataFromWebService:(NSString *)urlString withRequestType:(NSString*)RequestType
{
	

    NSMutableString *postString = [NSMutableString stringWithFormat:@"%@%@",Site_URL,urlString];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"string : %@",postString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:RequestType];
    NSHTTPURLResponse *response;
    NSError *error=nil ;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];

  //  NSLog(@"Response code: %ld", (long)[response statusCode]);
    if ([response statusCode] >=200 && [response statusCode] <=400)
    {
       // NSString* resData = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
      
        //NSLog(@"Response ==> %@", resData);
        
        jsonResponseData = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
        
      //  NSLog(@"JSON data posted!)");
        
        if (error)
        {
            NSLog(@"Error : %@",error);
            [self connectionFailed:error];
            return error;
        }
        else
        {
            NSLog(@"jsonResponse DATA : %@",jsonResponseData);
            return jsonResponseData;
        }

    }
    else if (receivedData == nil )
    {
         NSLog(@"jsonResponse is nil  : %@",jsonResponseData);
        return jsonResponseData;
    }
    else
    {
       jsonResponseData =  [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
			if (jsonResponseData==nil)
			{
				NSLog(@"error");
			}
        return jsonResponseData;
    }
 
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	NSLog(@"faild");
	//[ self connectionFailed:error ];
}
+(id)connectionFailed:(NSError *) error
{
	return self;
}

@end

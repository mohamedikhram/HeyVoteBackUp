//
//  WebServiceUrl.h
//  Kwala
//
//  Created by GItesh on 22/12/14.
//  Copyright (c) 2014 Anushaktinath. All rights reserved.
//
#import <Foundation/Foundation.h>
#define Site_URL @"http://travelibro.com/"

//#define Site_URL @"http://travelibro.com/"
//#define Site_URL @"http://staticmagick.in/test/travellibro_app/"
//#define Site_URL @"http://travelibro.com/travelibrojson/"
//http://54.169.27.223:8090/

@class Reachability;
@interface WebServiceUrl : NSObject
{
    Reachability* internetReachable;
    
    Reachability* hostReachable;
    
}

+(BOOL)InternetCheck;
+(void)InternetFailErrorMessage;


+(id)connectionFailed:(NSError *) error;
+(NSMutableDictionary*)Authentication_TokenAndKeys;

//+(id)GetDataFromPOSTWebService:(NSString *)urlString;
+(id)GetDataFromWebService:(NSString *)urlString withRequestType:(NSString*)RequestType;

@end

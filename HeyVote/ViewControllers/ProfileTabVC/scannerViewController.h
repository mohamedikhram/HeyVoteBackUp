//
//  scannerViewController.h
//  HeyVote
//
//  Created by Ikhram Khan on 6/5/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMScannerView.h"

#import "GMDCircleLoader.h"

#import "WebServiceUrl.h"

@interface scannerViewController : UIViewController<RMScannerViewDelegate>
@property (weak, nonatomic) IBOutlet RMScannerView *scannerView;

@end

//
//  homeViewController.h
//  HeyVote
//
//  Created by Ikhram Khan on 5/5/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "WebServiceUrl.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CollectionViewCell.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "THCircularProgressView.h"

@interface GetPostDetailsViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,AVAudioPlayerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    UIActivityIndicatorView *activityIndicator;
    UILabel *footerLabel;
    int secondsLeft;
}
@property (weak, nonatomic) IBOutlet UIView *secondHeader;
@property (weak, nonatomic) IBOutlet UISlider *homeSliderTwo;
- (IBAction)homwSliderTwo:(id)sender;
- (IBAction)funButton:(id)sender;
- (IBAction)seriousButton:(id)sender;
- (IBAction)generalButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *funButton;
@property (weak, nonatomic) IBOutlet UIButton *seriousButton;
@property (weak, nonatomic) IBOutlet UIButton *generalButton;


- (IBAction)CheckInButton:(id)sender;


- (IBAction)newHeyVotes:(id)sender;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIView *noPostView;
@property (strong, nonatomic) MPMoviePlayerController* mc;
@property (nonatomic, weak) NSTimer *timerCalc;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIView *previewYouHaveVoted;
@property (weak, nonatomic) IBOutlet UILabel *previewYouVotedText;
@property (weak, nonatomic) IBOutlet UIView *previewButtonView;

@property (weak, nonatomic) IBOutlet UIButton *globalButton;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (weak, nonatomic) IBOutlet UIView *previewView;
- (IBAction)previewCloseButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *previewTitle;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
- (IBAction)previewLeftButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *previewRightButton;
- (IBAction)previewRightButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *previewLeftButton;
@property(retain,nonatomic)UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *globalArray;
- (IBAction)zoomCloseButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *zoomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollZoomView;
@property (weak, nonatomic) IBOutlet UIImageView *zoomImageView;


- (IBAction)backWholeButton:(id)sender;

@property (weak, nonatomic) NSString *postIdVal;

//Global

- (IBAction)buttonOverImage:(id)sender;
- (IBAction)doubleVoicePlayLeftButton:(id)sender;
- (IBAction)doubleVoicePlayRightButton:(id)sender;
- (IBAction)leftButton:(id)sender;
- (IBAction)rightButton:(id)sender;
- (IBAction)showMoreComments:(id)sender;
- (IBAction)reHeyVote:(id)sender;
- (IBAction)shareButton:(id)sender;
- (IBAction)moreButton:(id)sender;
- (IBAction)moreFollow:(id)sender;
- (IBAction)moreBlock:(id)sender;
- (IBAction)moreReport:(id)sender;
- (IBAction)commentSendButton:(id)sender;
- (IBAction)singleVoicePlayButton:(id)sender;

- (IBAction)deleteButton:(id)sender;
- (IBAction)firstCommentButton:(id)sender;
- (IBAction)secondCommentButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *thirdCommentButton;
- (IBAction)thirdCommentButton:(id)sender;

@end

//
//  CameraViewController.h
//  HeyVote
//
//  Created by Ikhram Khan on 4/30/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YMCAudioPlayer.h"
#import "MZTimerLabel.h"
#import "CRColorPicker.h"
#import "UITextFieldLimit.h"
#import <MediaPlayer/MediaPlayer.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>

#import <QuartzCore/QuartzCore.h>


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate,UITextFieldDelegate,MZTimerLabelDelegate,CRColorPickerDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextFieldLimitDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    
     MZTimerLabel *timerExample8;
}
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (weak, nonatomic) IBOutlet UIImageView *finalViewImage;
- (IBAction)finalViewPostButton:(id)sender;
- (IBAction)finalViewBackButton:(id)sender;
- (IBAction)finalViewCancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *doubleImageTextView;
@property (weak, nonatomic) IBOutlet UIView *voiceFinalView;
@property (strong, nonatomic) IBOutlet UIPickerView *voicePickerView;

@property (weak, nonatomic) IBOutlet UIView *finalView;
- (IBAction)secondCameraOrGalleryButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *myTimerProgress;
@property (weak, nonatomic) IBOutlet UIView *voiceDoubleView;
@property (weak, nonatomic) IBOutlet UITextFieldLimit *voiceDoubleLeftText;
@property (weak, nonatomic) IBOutlet UITextFieldLimit *voiceDoubleRightText;
- (IBAction)voicePlayOneButton:(id)sender;
- (IBAction)voicePlayTwoButton:(id)sender;
@property (strong, nonatomic) MPMoviePlayerController* mc;

@property (weak, nonatomic) IBOutlet UIView *singleImageView;
@property (weak, nonatomic) IBOutlet UIView *doubleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *secondscrollView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIButton *secondCameraOrGallery;
@property (weak, nonatomic) IBOutlet UITextFieldLimit *secondLeftTextField;
@property (weak, nonatomic) IBOutlet UITextFieldLimit *secondRightTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *firstScrollView;

@property (weak, nonatomic) IBOutlet UIView *detailCollectionView;

- (IBAction)camerViewOpenButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *finalViewWithGestures;
@property (weak, nonatomic) IBOutlet UILabel *finalTitleLabelText;
@property (weak, nonatomic) IBOutlet UIView *finalTitleLabelView;
@property (weak, nonatomic) IBOutlet UITextField *voiceTypeYourQuestionTitle;
@property (weak, nonatomic) IBOutlet CRColorPicker *imageViewColourPicker;
@property (weak, nonatomic) IBOutlet UITextField *imageViewTypeYourQuestionText;
@property (weak, nonatomic) IBOutlet UIView *imageViewTypeYourQuestion;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;
@property (weak, nonatomic) IBOutlet UILabel *galleryLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;
- (IBAction)cameraButton:(id)sender;
- (IBAction)galleryButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
- (IBAction)voiceButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *cameraButtonsView;
- (IBAction)cameraFunButton:(id)sender;
- (IBAction)closeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImageView;
@property (weak, nonatomic) IBOutlet UIView *capturedView;
@property (weak, nonatomic) IBOutlet UIButton *voiceDoublePlayRightButton;
@property (weak, nonatomic) IBOutlet UIView *extraView;
- (IBAction)postButton:(id)sender;
- (IBAction)privateViewCloseButton:(id)sender;
- (IBAction)privateViewRightArrowButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *privateView;
@property (weak, nonatomic) IBOutlet UIView *audioVideoTagView;

- (IBAction)cameraSeriousButton:(id)sender;
- (IBAction)cameraGeneralButton:(id)sender;
- (IBAction)cameraPrivateButton:(id)sender;
- (IBAction)cameraQatarButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIButton *voiceRecordButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
- (IBAction)dismissButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *checkInView;
- (IBAction)checkInCloseButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *locationAudioVideoText;
@property (weak, nonatomic) IBOutlet UIView *cameraThumbnailView;
- (IBAction)galleryDetailPageBackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (weak, nonatomic) IBOutlet UIView *voicePlayerView;

- (IBAction)voiceRecordButton:(id)sender;

- (IBAction)cameraGlobalButton:(id)sender;

- (IBAction)locationButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hashtagsButton;
- (IBAction)hashTagsButton:(id)sender;

@property (nonatomic, strong) YMCAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *locationText;

@property (weak, nonatomic) IBOutlet UISlider *funSlider;
- (IBAction)funSlider:(id)sender;
- (IBAction)cameraViewBackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *galleryTableView;
@property (weak, nonatomic) IBOutlet UIView *galleryView;

@property (weak, nonatomic) IBOutlet UISlider *privateSlider;
@property BOOL isPaused;
@property BOOL scrubbing;
- (IBAction)privateSlider:(id)sender;
@property (weak, nonatomic) IBOutlet UITextFieldLimit *singleImageLeftText;
@property (weak, nonatomic) IBOutlet UITextFieldLimit *singleImageRightText;
- (IBAction)heyMoodButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *heyMoodLabel;

@property (weak, nonatomic) IBOutlet UITextFieldLimit *singleVoiceLeftText;
@property (weak, nonatomic) IBOutlet UITextFieldLimit *singleVoiceRightText;

@property (weak, nonatomic) IBOutlet UIView *singleImageTextView;
@property NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *videoView;


@property (strong, nonatomic) IBOutlet UITableView *checkInTableView;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)searchButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *heyMoodView;

@property (weak, nonatomic) IBOutlet UIView *heyMoodInnerView;

@property (weak, nonatomic) IBOutlet UITextView *heyMoodTextView;
@property (weak, nonatomic) IBOutlet UIImageView *heyMoodPic;
@property (weak, nonatomic) IBOutlet UIImageView *smallStickyNoteImage;
@property (weak, nonatomic) IBOutlet UIView *hashTagsView;
@property (weak, nonatomic) IBOutlet UITextView *hashTagsTextView;
- (IBAction)postHashTags:(id)sender;
- (IBAction)hashTagsCloseButton:(id)sender;

@end



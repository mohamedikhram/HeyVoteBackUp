//
//  CameraViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 4/30/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//


@import AVFoundation;
@import Photos;

@import AVKit;


static int count = 0;

#import <MobileCoreServices/MobileCoreServices.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "CameraViewController.h"
#import "AAPLPreviewView.h"
#import "MZTimerLabel.h"
#import "UIView+Toast.h"
#import "GMDCircleLoader.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WebServiceUrl.h"
#import "UIImageView+WebCache.h"
#import "NSData+Base64.h"
#import "Base64.h"
#import "homeViewController.h"

#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>


#define CAPTURE_FRAMES_PER_SECOND		20

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * SessionRunningContext = &SessionRunningContext;


typedef NS_ENUM( NSInteger, AVCamSetupResult ) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
    
    
};


@interface CameraViewController ()<AVCaptureFileOutputRecordingDelegate>
    



// For use in the storyboards.

@property (strong,nonatomic) NSArray *theData;
@property (nonatomic, weak) IBOutlet AAPLPreviewView *previewView;

@property (nonatomic, weak) IBOutlet UILabel *cameraUnavailableLabel;
@property (nonatomic, weak) IBOutlet UIButton *resumeButton;
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UIButton *stillButton;
@property (nonatomic, weak) IBOutlet UIButton *flashButton;
@property (nonatomic, weak) IBOutlet AAPLPreviewView *thumbNailCameraView;

@property (nonatomic, weak) IBOutlet UIButton *cameraFunButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraSeriousButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraGeneralButton;

@property (nonatomic, weak) IBOutlet UIButton *cameraPrivateButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraQatarButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraGlobalButton;


@property (nonatomic, weak) IBOutlet UILabel *cameraFunLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraSeriousLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraGeneralLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraPrivateLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraQatarLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraGlobalLabel;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;

@property(nonatomic,strong) AVCaptureDevice *captureDevice;



// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;


// Utilities.
@property (nonatomic) AVCamSetupResult setupResult;
@property (nonatomic, getter=isSessionRunning) BOOL sessionRunning;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;



@end

@implementation CameraViewController{
    UIView *newView;
    CLLocationCoordinate2D center;
    NSString*placesId;
    CLLocationManager *locationManagerMap;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation * mapCurrentPlace;
    NSTimer* myTimer;
    NSString * currentlatitude;
    NSString * currentlongitude;
    id data;
    NSString *latLong;
    NSString * finalLat;
    NSString* finalLong;
    NSMutableArray* places;
    NSMutableArray * searchPlaces;
    NSMutableArray * didSelectPlaces;
    NSString *str;
    NSMutableArray *friendListArray;
     NSString *hashTagsArray;
    AVCaptureSession *sessionNew;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;

    ////////////////////////
    
    
     MPMoviePlayerController *moviePlayerController;
        BOOL WeAreRecording;
    UIImage *capturedImageSingle;
    UIImage *capturedImageDouble;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSMutableArray*finalArray;
    NSString * flashString;
    NSString*cameraVal;
    NSString * savedVideo;
    NSDictionary *jsonDictionary;
    
    NSString*voiceVal;
    NSMutableArray *cellSelected;
    NSString * stop;
    NSString * moodString;
    NSString * privateCategory;
    
    NSString * imageLeftTitle;
    NSString * imageRightTitle;
    NSString * voiceLeftTitle;
    NSString * voiceRightTitle;
    NSString * durationVal;
    
    NSString* whichMedia;
    NSData*firstVoice;
    NSData * secondVoice;
    
   // CGRect * storePreviewView;
    
}


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


- (void)viewDidLoad {
    [super viewDidLoad];
      screenRect = [[UIScreen mainScreen] bounds];
   
   
    
    [_galleryView setHidden:NO];
    [_detailCollectionView setHidden:YES];
    
    
    
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    
//       sessionNew = [[AVCaptureSession alloc] init];
//        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        if (videoDevice)
//        {
//            NSError *error;
//            _videoDeviceInputTwo = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
//            if (!error)
//            {
//                if ([sessionNew canAddInput:_videoDeviceInputTwo])
//                {
//                    [sessionNew addInputWithNoConnections:_videoDeviceInputTwo];
//                    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:sessionNew];
//                    previewLayer.frame = _cameraThumbnailView.bounds;
//                    [_cameraThumbnailView.layer addSublayer:previewLayer];
//                    
//                    //  [_session stopRunning];
//                    [sessionNew startRunning];
//                }
//            }
//        }
//        
//    });
    
    


    
    
    if (self.assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    if (self.groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    } else {
        [self.groups removeAllObjects];
    }
    
    // setup our failure view controller in case enumerateGroupsWithTypes fails
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        //        AssetsDataIsInaccessibleViewController *assetsDataInaccessibleViewController =
        //            [self.storyboard instantiateViewControllerWithIdentifier:@"inaccessibleViewController"];
        
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        
        //        assetsDataInaccessibleViewController.explanation = errorMessage;
        //        [self presentViewController:assetsDataInaccessibleViewController animated:NO completion:nil];
    };
    
    // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        // [group setAssetsFilter:[ALAssetsFilter allVideos]];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            [self.groups addObject:group];
        }
        else
        {
            [self.galleryTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos | ALAssetsGroupLibrary | ALAssetsGroupAll;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];

    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
  _locationText.text = @"";
    _locationAudioVideoText.text = @"";
    _hashTagsTextView.text = @"";
    finalLat = @"";
    finalLong = @"";
    [_checkInView setHidden:YES];
    [_hashTagsView setHidden:YES];
    
     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savedVideo"];
    stop = @"";
     whichMedia = @"camera";
    cellSelected = [[NSMutableArray alloc] init];
    finalArray = [[NSMutableArray alloc] init];
     hashTagsArray = @"";
    [_voiceFinalView setHidden:YES];
    [_audioVideoTagView setHidden:YES];
    flashString = @"";
    [_videoView setHidden:YES];
    [_heyMoodView setHidden:YES];
   self.theData = @[@"1 mins",@"2 mins",@"3 mins",@"4 mins",@"5 mins",@"6 mins",@"7 mins",@"8 mins",@"9 mins",@"10 mins",@"11 mins",@"12 mins",@"13 mins",@"14 mins",@"15 mins",@"16 mins",@"17 mins",@"18 mins",@"19 mins",@"20 mins",@"21 mins",@"22 mins",@"23 mins",@"24 mins",@"25 mins",@"26 mins",@"27 mins",@"28 mins",@"29 mins",@"30 mins",@"31 mins",@"32 mins",@"33 mins",@"34 mins",@"35 mins",@"36 mins",@"37 mins",@"38 mins",@"39 mins",@"40 mins",@"41 mins",@"42 mins",@"43 mins",@"44 mins",@"45 mins",@"46 mins",@"47 mins",@"48 mins",@"49 mins",@"50 mins",@"51 mins",@"52 mins",@"53 mins",@"54 mins",@"55 mins",@"56 mins",@"57 mins",@"58 mins",@"59 mins",@"1 hour",@"2 hours",@"3 hours",@"4 hours",@"5 hours",@"6 hours",@"7 hours",@"8 hours",@"9 hours",@"10 hours",@"11 hours",@"12 hours",@"13 hours",@"14 hours",@"15 hours",@"16 hours",@"17 hours",@"18 hours",@"19 hours",@"20 hours",@"21 hours",@"22 hours",@"23 hours",@"24 hours"];
    
    
    
    
    
    
    [self.funSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    [self.funSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateHighlighted];
    
    
    [self.privateSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    [self.privateSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateHighlighted];
    
    
    _funSlider.value = 0;
    _privateSlider.value = 0;
    
    cameraVal = @"";
    
    moodString = @"Fun";
    privateCategory = @"Private";
      [_finalView setHidden:YES];
    voiceVal=@"";
    [_privateView setHidden:YES];
    
    [_extraView setHidden:YES];
    [_voiceDoubleView setHidden:YES];
    
 
    
    [_doubleImageView setHidden:YES];
    
     [_imageViewColourPicker setDelegate:self];
    
    [_imageViewColourPicker setHidden:YES];
     [_finalViewWithGestures setHidden:YES];
    
    _cameraQatarLabel.text = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] allObjects] valueForKey:@"Country"] objectAtIndex:0];
    
  
    
 
    

    

    
    
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [_singleImageView addGestureRecognizer:swipeleft];
    
    
    UISwipeGestureRecognizer * swipelefttt=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipelefttt:)];
    swipelefttt.direction=UISwipeGestureRecognizerDirectionLeft;
     [_voicePlayerView addGestureRecognizer:swipelefttt];
   
    

    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [_doubleImageView addGestureRecognizer:swiperight];
    
    
    UISwipeGestureRecognizer * swiperighttt=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperighttt:)];
    swiperighttt.direction=UISwipeGestureRecognizerDirectionRight;
    
    [_voiceDoubleView addGestureRecognizer:swiperighttt];
//
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    rotationGesture.delegate = self;
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate = self;
    
    [_finalViewWithGestures addGestureRecognizer:panGesture];
    [_finalViewWithGestures addGestureRecognizer:rotationGesture];
    [_finalViewWithGestures addGestureRecognizer:pinchGesture];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_finalViewWithGestures addGestureRecognizer:singleTap];
    
    UIColor *color = [UIColor whiteColor];
    _imageViewTypeYourQuestionText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type your question here" attributes:@{NSForegroundColorAttributeName: color}];
    
     _voiceTypeYourQuestionTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type your question here" attributes:@{NSForegroundColorAttributeName: color}];
    
    
    
    [_cameraLabel setHidden:NO];
    [_galleryLabel setHidden:YES];
    [_voiceLabel setHidden:YES];
     [_heyMoodLabel setHidden:YES];
    [_capturedView setHidden:YES];
    [_recordView setHidden:YES];
    [_voicePlayerView setHidden:YES];
    
    // Disable UI. The UI is enabled if and only if the session starts running.
    self.cameraButton.enabled = NO;
    self.recordButton.enabled = NO;
    self.stillButton.enabled = NO;
    
    // Create the AVCaptureSession.
    self.session = [[AVCaptureSession alloc] init];
    
    self.session.sessionPreset = AVCaptureSessionPresetPhoto ;

    
    
    // Setup the preview view.
    self.previewView.session = self.session;
    
    // Communicate with the session and other session objects on this queue.
    self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
    
    self.setupResult = AVCamSetupResultSuccess;
    
    // Check video authorization status. Video access is required and audio access is optional.
    // If audio access is denied, audio is not recorded during movie recording.
    switch ( [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] )
    {
        case AVAuthorizationStatusAuthorized:
        {
            // The user has previously granted access to the camera.
            break;
        }
        case AVAuthorizationStatusNotDetermined:
        {
            // The user has not yet been presented with the option to grant video access.
            // We suspend the session queue to delay session setup until the access request has completed to avoid
            // asking the user for audio access if video access is denied.
            // Note that audio access will be implicitly requested when we create an AVCaptureDeviceInput for audio during session setup.
            dispatch_suspend( self.sessionQueue );
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^( BOOL granted ) {
                if ( ! granted ) {
                    self.setupResult = AVCamSetupResultCameraNotAuthorized;
                }
                dispatch_resume( self.sessionQueue );
            }];
            break;
        }
        default:
        {
            // The user has previously denied access.
            self.setupResult = AVCamSetupResultCameraNotAuthorized;
            break;
        }
    }
    
    // Setup the capture session.
    // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
    // Why not do all of this on the main queue?
    // Because -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue
    // so that the main queue isn't blocked, which keeps the UI responsive.
    dispatch_async( self.sessionQueue, ^{
        if ( self.setupResult != AVCamSetupResultSuccess ) {
            return;
        }
        
        self.backgroundRecordingID = UIBackgroundTaskInvalid;
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [CameraViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if ( ! videoDeviceInput ) {
            NSLog( @"Could not create video device input: %@", error );
        }
        
        [self.session beginConfiguration];
        
        if ( [self.session canAddInput:videoDeviceInput] ) {
            [self.session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
            
            dispatch_async( dispatch_get_main_queue(), ^{
                // Why are we dispatching this to the main queue?
                // Because AVCaptureVideoPreviewLayer is the backing layer for AAPLPreviewView and UIView
                // can only be manipulated on the main thread.
                // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes
                // on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                
                // Use the status bar orientation as the initial video orientation. Subsequent orientation changes are handled by
                // -[viewWillTransitionToSize:withTransitionCoordinator:].
                UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
                AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
                if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
                    initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
                }
                
                AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
                
//                  UIView * firstView = (UIView*)[self.view viewWithTag:105];
//                previewLayer = (AVCaptureVideoPreviewLayer *)firstView.layer;
                
                
//                UIView * firstView = (UIView*)[self.view viewWithTag:105];
//                
//                firstView =(AVCaptureVideoPreviewLayer *)self.previewView.layer;
//                
                previewLayer.connection.videoOrientation = initialVideoOrientation;
                
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                
         
            } );
        }
        else {
            NSLog( @"Could not add video device input to the session" );
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }
        
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if ( ! audioDeviceInput ) {
            NSLog( @"Could not create audio device input: %@", error );
        }
        
        if ( [self.session canAddInput:audioDeviceInput] ) {
            [self.session addInput:audioDeviceInput];
        }
        else {
            NSLog( @"Could not add audio device input to the session" );
        }
        
        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ( [self.session canAddOutput:movieFileOutput] ) {
            [self.session addOutput:movieFileOutput];
            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if ( connection.isVideoStabilizationSupported ) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }
            self.movieFileOutput = movieFileOutput;
        }
        else {
            NSLog( @"Could not add movie file output to the session" );
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ( [self.session canAddOutput:stillImageOutput] ) {
            stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
            [self.session addOutput:stillImageOutput];
            self.stillImageOutput = stillImageOutput;
        }
        else {
            NSLog( @"Could not add still image output to the session" );
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }
        
        [self.session commitConfiguration];
    } );
    


    UILongPressGestureRecognizer *longPressss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressss:)];
    [_stillButton addGestureRecognizer:longPressss];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_voiceRecordButton addGestureRecognizer:longPress];
    
    
    
    
    ////////////////////
    
    
    [_searchTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    //In ViewDidLoad
    if(IS_OS_8_OR_LATER)
    {
        [locationManagerMap requestAlwaysAuthorization];
        //   [locationManagerMap requestWhenInUseAuthorization];
        
    }
    
    
    
    
 
    
    
   }




-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:NO];
  NSString*rtest  =   [[NSUserDefaults standardUserDefaults]valueForKey:@"savedVideo"];

}


-(void) callAfterTwoSecond:(NSTimer*) t
{
    
    if ([currentlatitude isEqual:nil] || [currentlatitude isEqualToString:@"(null)"] || currentlatitude == (id)[NSNull null] || [currentlatitude isKindOfClass:[NSNull class]] || [currentlatitude length] == 0 ) {
    }
    
    else{
        
        
        [myTimer invalidate];
        
        latLong = [NSString stringWithFormat:@"%@,%@",currentlatitude,currentlongitude];
        
        [self callWebservice];
        
    }
    
    
    
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.theData.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {


    return self.theData[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.myPickerView = self.theData[row];
     self.voicePickerView = self.theData[row];
    
    durationVal =self.theData[row];
    
   
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 30;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width + 30, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    label.text = self.theData[row];
    label.textAlignment = NSTextAlignmentCenter;
   
    return label;    
}





- (void)handlePinch:(UIPinchGestureRecognizer *)pinchRecognizer
{
    UIGestureRecognizerState state = [pinchRecognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [pinchRecognizer scale];
        [pinchRecognizer.view setTransform:CGAffineTransformScale(pinchRecognizer.view.transform, scale, scale)];
        [pinchRecognizer setScale:1.0];
    }
}


- (void)handleRotate:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    
    UIGestureRecognizerState state = [rotationGestureRecognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat rotation = [rotationGestureRecognizer rotation];
        [rotationGestureRecognizer.view setTransform:CGAffineTransformRotate(rotationGestureRecognizer.view.transform, rotation)];
        [rotationGestureRecognizer setRotation:0];
    }
}





- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer {
    
    UIGestureRecognizerState state = [panRecognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panRecognizer translationInView:panRecognizer.view];
        [panRecognizer.view setTransform:CGAffineTransformTranslate(panRecognizer.view.transform, translation.x, translation.y)];
        [panRecognizer setTranslation:CGPointZero inView:panRecognizer.view];
    }
}


- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    
    
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press end");
        
        [recorder stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        
        self.audioPlayer = [[YMCAudioPlayer alloc] init];
        
            
             [self setupAudioPlayer:recorder.url];
            
            
      
      
       
        
        [_capturedView setHidden:NO];
        [_voicePlayerView setHidden:NO];
        [_recordView setHidden:YES];
        [_extraView setHidden:YES];
        [timerExample8 pause];
         [timerExample8 reset];
     
        
        
    }
    
    else if (gesture.state == UIGestureRecognizerStateBegan){
        
        
        timerExample8 = [[MZTimerLabel alloc] initWithLabel:_timerLabel];
        timerExample8.timeFormat = @"mm:ss";
        timerExample8.delegate = self;
        [timerExample8 start];
        
        NSLog(@"Long Press  start");
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
 
        // Start recording
        [recorder record];
        
   
    }
    
    
}

//********** VIEW DID UNLOAD **********
- (void)viewDidUnload
{
    [super viewDidUnload];
    
   
    _session = nil;
   
    _movieFileOutput = nil;
  
    _videoDeviceInput = nil;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *playerrr = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:playerrr];
    
    if ([playerrr
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [playerrr.view removeFromSuperview];
    }
}



- (NSURL*)grabFileURL:(NSString *)fileName {
    
    // find Documents directory
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    // append a file name to it
    documentsURL = [documentsURL URLByAppendingPathComponent:fileName];
    
    return documentsURL;
}

- (void)updateUI:(NSTimer *)timer
{
      count++;
 if (count <=30)
    {
       
        self.progressView.progress = (float)count/30.0f;
    } else
    {
         self.session.sessionPreset = AVCaptureSessionPresetPhoto ;
        count = 0;
        [self.myTimerProgress invalidate];
        self.myTimerProgress = nil;
        self.progressView.progress = 0.0f;

        [_progressView setHidden:YES];
        [_movieFileOutput stopRecording];
        
        [_capturedView setHidden:NO];
        [_voicePlayerView setHidden:NO];
        [_recordView setHidden:YES];
        [_extraView setHidden:YES];
        [_videoView setHidden:NO];

    }
}

- (void)longPressss:(UILongPressGestureRecognizer*)gesture {
    
    
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        
        
         self.session.sessionPreset = AVCaptureSessionPresetPhoto ;
        count = 0;
        
        NSLog(@"Long Press  end");
        //----- STOP RECORDING -----
        NSLog(@"STOP RECORDING");
        WeAreRecording = NO;
        
      //  count = 0;
        [self.myTimerProgress invalidate];
        self.myTimerProgress = nil;
        self.progressView.progress = 0.0f;
 
        
         [_progressView setHidden:YES];
        [_movieFileOutput stopRecording];
        
        [_capturedView setHidden:NO];
        [_voicePlayerView setHidden:NO];
        [_recordView setHidden:YES];
        [_extraView setHidden:YES];
        [_videoView setHidden:NO];
       

        
    }
    
    else if (gesture.state == UIGestureRecognizerStateBegan){
        
        
        NSLog(@"Long Press  start");
        
         self.session.sessionPreset = AVCaptureSessionPresetMedium ;
        
         self.myTimerProgress = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
        
        
        [_progressView setHidden:NO];
        
//        if (!WeAreRecording)
//        {
//            //----- START RECORDING -----
//            NSLog(@"START RECORDING");
//            WeAreRecording = YES;
//            
//            //Create temporary URL to record to
//            NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
//            NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            if ([fileManager fileExistsAtPath:outputPath])
//            {
//                NSError *error;
//                if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
//                {
//                    //Error - handle if requried
//                }
//            }
//            
//            //Start recording
//            [_movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
//
//            
//            
//        }
//
        
        dispatch_async( self.sessionQueue, ^{
            if ( ! self.movieFileOutput.isRecording ) {
                if ( [UIDevice currentDevice].isMultitaskingSupported ) {
                    // Setup background task. This is needed because the -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:]
                    // callback is not received until AVCam returns to the foreground unless you request background execution time.
                    // This also ensures that there will be time to write the file to the photo library when AVCam is backgrounded.
                    // To conclude this background execution, -endBackgroundTask is called in
                    // -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:] after the recorded file has been saved.
                    self.backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                }
                
                // Update the orientation on the movie file output video connection before starting recording.
                AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
                AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
                connection.videoOrientation = previewLayer.connection.videoOrientation;
                
                // Turn OFF flash for video recording.
                [CameraViewController setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
                
                // Start recording to a temporary file.
              //  NSString *outputFileName = [NSProcessInfo processInfo].globallyUniqueString;
                NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"video.mov"];
                [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
            }
            else {
                [self.movieFileOutput stopRecording];
            }
        } );

        
        
        
        
  }
    
    
}




-(void)swipelefttt:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
     NSString*rtest  =   [[NSUserDefaults standardUserDefaults]valueForKey:@"savedVideo"];
    if ([rtest length] == 0) {
        
        [_voiceDoubleView setHidden:NO];
        
        CATransition *animation=[CATransition animation];
        [animation setDelegate:self];
        [animation setDuration:0.8];
        [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
        [animation setType:@"rippleEffect"];
        
        [animation setFillMode:kCAFillModeRemoved];
        animation.endProgress=0.99;
        [animation setRemovedOnCompletion:NO];
        [_voicePlayerView.layer addAnimation:animation forKey:nil];
        
    }
    
    else{
    
  
    }
    
}



-(void)swiperighttt:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    
    [_voiceDoubleView setHidden:YES];
    
    
    CATransition *animation=[CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:0.8];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation setType:@"rippleEffect"];
    
    [animation setFillMode:kCAFillModeRemoved];
    animation.endProgress=0.99;
    [animation setRemovedOnCompletion:NO];
    [_voiceDoubleView.layer addAnimation:animation forKey:nil];
}





-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    
    if ([_heyMoodView isHidden]) {
        
   
    _finalTitleLabelText.text = @"";
        
        _singleImageLeftText.text = @"";
        _singleImageRightText.text = @"";
        
    
   
    [_imageViewTypeYourQuestion setHidden:NO];
    
    [_finalViewWithGestures setHidden:YES];
    
    [_doubleImageView setHidden:NO];
    

    
            CATransition *animation=[CATransition animation];
            [animation setDelegate:self];
            [animation setDuration:0.8];
            [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
            [animation setType:@"rippleEffect"];
    
            [animation setFillMode:kCAFillModeRemoved];
            animation.endProgress=0.99;
            [animation setRemovedOnCompletion:NO];
            [_singleImageView.layer addAnimation:animation forKey:nil];
    
     }
}




-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    
    [_doubleImageView setHidden:YES];
    _finalTitleLabelText.text = @"";
    
    _singleImageLeftText.text = @"";
    _singleImageRightText.text = @"";
    
    CATransition *animation=[CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:0.8];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation setType:@"rippleEffect"];
    
    [animation setFillMode:kCAFillModeRemoved];
    animation.endProgress=0.99;
    [animation setRemovedOnCompletion:NO];
    [_doubleImageView.layer addAnimation:animation forKey:nil];
 
    
}
- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer
{

    [_imageViewTypeYourQuestionText becomeFirstResponder];
    [_imageViewTypeYourQuestion setHidden:NO];
    [_imageViewColourPicker setHidden:NO];
      [_finalViewWithGestures setHidden:YES];
    
}



#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
   
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
}



-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
    [super viewWillAppear:YES];
    
     screenWidth = screenRect.size.width;
    
    if (screenWidth == 320) {
        
        _heyMoodTextView.textContainer.maximumNumberOfLines = 9;
      
        
    }
    
    else{
        _heyMoodTextView.textContainer.maximumNumberOfLines = 10;

    }
    
    
      _heyMoodTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [[self heyMoodTextView] setTextAlignment:NSTextAlignmentNatural];
  
    

    _finalViewImage.image = nil;
  
    [self.mc prepareToPlay];
    
  //  [controller play]; //Start playing
    
  

    
    	WeAreRecording = NO;
    
    
    [_cameraLabel setHidden:NO];
    [_galleryLabel setHidden:YES];
    [_voiceLabel setHidden:YES];
    [_heyMoodLabel setHidden:YES];
    dispatch_async( self.sessionQueue, ^{
        switch ( self.setupResult )
        {
            case AVCamSetupResultSuccess:
            {
                
                
                // Only setup observers and start the session running if setup succeeded.
                [self addObservers];
                [self.session startRunning];
                
          
                
                
                
                self.sessionRunning = self.session.isRunning;
                break;
                
         
            }
            case AVCamSetupResultCameraNotAuthorized:
            {
                dispatch_async( dispatch_get_main_queue(), ^{
                    NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    // Provide quick access to Settings.
                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                    [alertController addAction:settingsAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                } );
                break;
            }
            case AVCamSetupResultSessionConfigurationFailed:
            {
                dispatch_async( dispatch_get_main_queue(), ^{
                    NSString *message = NSLocalizedString( @"Unable to capture media", @"Alert message when something goes wrong during capture session configuration" );
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                } );
                break;
            }
        }
    } );

}

- (void)viewDidDisappear:(BOOL)animated
{
       [super viewDidDisappear:animated];
    
 //   [myTimer invalidate];
    dispatch_async( self.sessionQueue, ^{
        if ( self.setupResult == AVCamSetupResultSuccess ) {
            [self.session stopRunning];
            [self removeObservers];
        }
    } );
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flashButton:(id)sender
{
  
    if ([flashString isEqualToString:@""]) {
        
        flashString = @"success";
        
        // Flash set to Auto for Still Capture.
        [CameraViewController setFlashMode:AVCaptureFlashModeOn forDevice:self.videoDeviceInput.device];
        
        [sender setTintColor:[UIColor blueColor]];
        [sender setSelected:YES];

        
    }
    
    else{
        flashString = @"";
        // Flash set to Auto for Still Capture.
        [CameraViewController setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
        
        [sender setTintColor:[UIColor grayColor]];
        [sender setSelected:NO];

        
    }
    

    
}

#pragma mark Orientation

- (BOOL)shouldAutorotate
{
    // Disable autorotation of the interface when recording is in progress.
    return ! self.movieFileOutput.isRecording;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Note that the app delegate controls the device orientation notifications required to use the device orientation.
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if ( UIDeviceOrientationIsPortrait( deviceOrientation ) || UIDeviceOrientationIsLandscape( deviceOrientation ) ) {
        AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
        previewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
        
         previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
}

#pragma mark KVO and Notifications

- (void)addObservers
{
    [self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:SessionRunningContext];
    [self.stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:CapturingStillImageContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.videoDeviceInput.device];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:self.session];
    // A session can only run when the app is full screen. It will be interrupted in a multi-app layout, introduced in iOS 9,
    // see also the documentation of AVCaptureSessionInterruptionReason. Add observers to handle these session interruptions
    // and show a preview is paused message. See the documentation of AVCaptureSessionWasInterruptedNotification for other
    // interruption reasons.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionWasInterrupted:) name:AVCaptureSessionWasInterruptedNotification object:self.session];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruptionEnded:) name:AVCaptureSessionInterruptionEndedNotification object:self.session];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.session removeObserver:self forKeyPath:@"running" context:SessionRunningContext];
    [self.stillImageOutput removeObserver:self forKeyPath:@"capturingStillImage" context:CapturingStillImageContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == CapturingStillImageContext ) {
        BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
        
        if ( isCapturingStillImage ) {
            dispatch_async( dispatch_get_main_queue(), ^{
                self.previewView.layer.opacity = 0.0;
                [UIView animateWithDuration:0.25 animations:^{
                    self.previewView.layer.opacity = 1.0;
                }];
            } );
        }
    }
    else if ( context == SessionRunningContext ) {
        BOOL isSessionRunning = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Only enable the ability to change camera if the device has more than one camera.
            self.cameraButton.enabled = isSessionRunning && ( [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 1 );
            self.recordButton.enabled = isSessionRunning;
            self.stillButton.enabled = isSessionRunning;
        } );
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)subjectAreaDidChange:(NSNotification *)notification
{
    CGPoint devicePoint = CGPointMake( 0.5, 0.5 );
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

- (void)sessionRuntimeError:(NSNotification *)notification
{
    NSError *error = notification.userInfo[AVCaptureSessionErrorKey];
    NSLog( @"Capture session runtime error: %@", error );
    
    // Automatically try to restart the session running if media services were reset and the last start running succeeded.
    // Otherwise, enable the user to try to resume the session running.
    if ( error.code == AVErrorMediaServicesWereReset ) {
        dispatch_async( self.sessionQueue, ^{
            if ( self.isSessionRunning ) {
                [self.session startRunning];
                self.sessionRunning = self.session.isRunning;
            }
            else {
                dispatch_async( dispatch_get_main_queue(), ^{
                    self.resumeButton.hidden = NO;
                } );
            }
        } );
    }
    else {
        self.resumeButton.hidden = NO;
    }
}

- (void)sessionWasInterrupted:(NSNotification *)notification
{
    // In some scenarios we want to enable the user to resume the session running.
    // For example, if music playback is initiated via control center while using AVCam,
    // then the user can let AVCam resume the session running, which will stop music playback.
    // Note that stopping music playback in control center will not automatically resume the session running.
    // Also note that it is not always possible to resume, see -[resumeInterruptedSession:].
    BOOL showResumeButton = NO;
    
    // In iOS 9 and later, the userInfo dictionary contains information on why the session was interrupted.
    if ( &AVCaptureSessionInterruptionReasonKey ) {
        AVCaptureSessionInterruptionReason reason = [notification.userInfo[AVCaptureSessionInterruptionReasonKey] integerValue];
        NSLog( @"Capture session was interrupted with reason %ld", (long)reason );
        
        if ( reason == AVCaptureSessionInterruptionReasonAudioDeviceInUseByAnotherClient ||
            reason == AVCaptureSessionInterruptionReasonVideoDeviceInUseByAnotherClient ) {
            showResumeButton = YES;
        }
        else if ( reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps ) {
            // Simply fade-in a label to inform the user that the camera is unavailable.
            self.cameraUnavailableLabel.hidden = NO;
            self.cameraUnavailableLabel.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                self.cameraUnavailableLabel.alpha = 1.0;
            }];
        }
    }
    else {
        NSLog( @"Capture session was interrupted" );
        showResumeButton = ( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive );
    }
    
    if ( showResumeButton ) {
        // Simply fade-in a button to enable the user to try to resume the session running.
        self.resumeButton.hidden = NO;
        self.resumeButton.alpha = 0.0;
        [UIView animateWithDuration:0.25 animations:^{
            self.resumeButton.alpha = 1.0;
        }];
    }
}

- (void)sessionInterruptionEnded:(NSNotification *)notification
{
    NSLog( @"Capture session interruption ended" );
    
    if ( ! self.resumeButton.hidden ) {
        [UIView animateWithDuration:0.25 animations:^{
            self.resumeButton.alpha = 0.0;
        } completion:^( BOOL finished ) {
            self.resumeButton.hidden = YES;
        }];
    }
    if ( ! self.cameraUnavailableLabel.hidden ) {
        [UIView animateWithDuration:0.25 animations:^{
            self.cameraUnavailableLabel.alpha = 0.0;
        } completion:^( BOOL finished ) {
            self.cameraUnavailableLabel.hidden = YES;
        }];
    }
}

#pragma mark Actions

- (IBAction)resumeInterruptedSession:(id)sender
{
    dispatch_async( self.sessionQueue, ^{
        // The session might fail to start running, e.g., if a phone or FaceTime call is still using audio or video.
        // A failure to start the session running will be communicated via a session runtime error notification.
        // To avoid repeatedly failing to start the session running, we only try to restart the session running in the
        // session runtime error handler if we aren't trying to resume the session running.
        [self.session startRunning];
        self.sessionRunning = self.session.isRunning;
        if ( ! self.session.isRunning ) {
            dispatch_async( dispatch_get_main_queue(), ^{
                NSString *message = NSLocalizedString( @"Unable to resume", @"Alert message when unable to resume the session running" );
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            } );
        }
        else {
            dispatch_async( dispatch_get_main_queue(), ^{
                self.resumeButton.hidden = YES;
            } );
        }
    } );
}

- (IBAction)toggleMovieRecording:(id)sender
{
    // Disable the Camera button until recording finishes, and disable the Record button until recording starts or finishes. See the
    // AVCaptureFileOutputRecordingDelegate methods.
    self.cameraButton.enabled = NO;
    self.recordButton.enabled = NO;
    
    dispatch_async( self.sessionQueue, ^{
        if ( ! self.movieFileOutput.isRecording ) {
            if ( [UIDevice currentDevice].isMultitaskingSupported ) {
                // Setup background task. This is needed because the -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:]
                // callback is not received until AVCam returns to the foreground unless you request background execution time.
                // This also ensures that there will be time to write the file to the photo library when AVCam is backgrounded.
                // To conclude this background execution, -endBackgroundTask is called in
                // -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:] after the recorded file has been saved.
                self.backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            
            // Update the orientation on the movie file output video connection before starting recording.
            AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
            connection.videoOrientation = previewLayer.connection.videoOrientation;
            
            // Turn OFF flash for video recording.
            [CameraViewController setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
            
            // Start recording to a temporary file.
            NSString *outputFileName = [NSProcessInfo processInfo].globallyUniqueString;
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[outputFileName stringByAppendingPathExtension:@"mov"]];
            [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
        }
        else {
            [self.movieFileOutput stopRecording];
        }
    } );
}

- (IBAction)changeCamera:(id)sender
{
    self.cameraButton.enabled = NO;
    self.recordButton.enabled = NO;
    self.stillButton.enabled = NO;
    
    dispatch_async( self.sessionQueue, ^{
        AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        AVCaptureDevicePosition currentPosition = currentVideoDevice.position;
        
        switch ( currentPosition )
        {
            case AVCaptureDevicePositionUnspecified:
            case AVCaptureDevicePositionFront:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
            case AVCaptureDevicePositionBack:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
        }
        
        AVCaptureDevice *videoDevice = [CameraViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        [self.session beginConfiguration];
        
        // Remove the existing device input first, since using the front and back camera simultaneously is not supported.
        [self.session removeInput:self.videoDeviceInput];
        
        if ( [self.session canAddInput:videoDeviceInput] ) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
            
            [CameraViewController setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
            
            [self.session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
        }
        else {
            [self.session addInput:self.videoDeviceInput];
        }
        
        AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ( connection.isVideoStabilizationSupported ) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        [self.session commitConfiguration];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            self.cameraButton.enabled = YES;
            self.recordButton.enabled = YES;
            self.stillButton.enabled = YES;
        } );
    } );
}

- (IBAction)snapStillImage:(id)sender
{
    dispatch_async( self.sessionQueue, ^{
        AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
        
        // Update the orientation on the still image output video connection before capturing.
        connection.videoOrientation = previewLayer.connection.videoOrientation;
        // Flash set to Auto for Still Capture.
        
         previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [CameraViewController setFlashMode:AVCaptureFlashModeAuto forDevice:self.videoDeviceInput.device];
       
        
        // Capture a still image.
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^( CMSampleBufferRef imageDataSampleBuffer, NSError *error ) {
            if ( imageDataSampleBuffer ) {
                // The sample buffer is not retained. Create image data before saving the still image to the photo library asynchronously.
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                
                UIImage *image = [UIImage imageWithData:imageData];
        
                [_capturedView setHidden:NO];
                [_firstImageView setImage:image];
                [_capturedImageView setImage:image];
                [_session stopRunning];
                [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
                    if ( status == PHAuthorizationStatusAuthorized ) {
                        // To preserve the metadata, we create an asset from the JPEG NSData representation.
                        // Note that creating an asset from a UIImage discards the metadata.
                        // In iOS 9, we can use -[PHAssetCreationRequest addResourceWithType:data:options].
                        // In iOS 8, we save the image to a temporary file and use +[PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:].
                        if ( [PHAssetCreationRequest class] ) {
                            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
                            } completionHandler:^( BOOL success, NSError *error ) {
                                if ( ! success ) {
                                    NSLog( @"Error occurred while saving image to photo library: %@", error );
                                }
                            }];
                        }
                        else {
                            
                            
                            NSString *temporaryFileName = [NSProcessInfo processInfo].globallyUniqueString;
                            NSString *temporaryFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[temporaryFileName stringByAppendingPathExtension:@"jpg"]];
                            NSURL *temporaryFileURL = [NSURL fileURLWithPath:temporaryFilePath];
                            
                            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                NSError *error = nil;
                                [imageData writeToURL:temporaryFileURL options:NSDataWritingAtomic error:&error];
                                if ( error ) {
                                    NSLog( @"Error occured while writing image data to a temporary file: %@", error );
                                }
                                else {
                                    [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:temporaryFileURL];
                                }
                            } completionHandler:^( BOOL success, NSError *error ) {
                                if ( ! success ) {
                                    NSLog( @"Error occurred while saving image to photo library: %@", error );
                                }
                                
                                // Delete the temporary file.
                                [[NSFileManager defaultManager] removeItemAtURL:temporaryFileURL error:nil];
                            }];
                        }
                    }
                }];
            }
            else {
                NSLog( @"Could not capture still image: %@", error );
            }
        }];
    } );
}

- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)self.previewView.layer captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

#pragma mark File Output Recording Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    // Enable the Record button to let the user stop the recording.
    dispatch_async( dispatch_get_main_queue(), ^{
        self.recordButton.enabled = YES;
        [self.recordButton setTitle:NSLocalizedString( @"Stop", @"Recording button stop title") forState:UIControlStateNormal];
    });
}



- (void)doneButtonClick:(NSNotification*)aNotification
{
    if (self.mc.playbackState == MPMoviePlaybackStatePaused)
    {
        NSLog(@"done button tapped");
    }
    else
    {
        NSLog(@"minimize tapped");
    }
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    // Note that currentBackgroundRecordingID is used to end the background task associated with this recording.
    // This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's isRecording property
    // is back to NO — which happens sometime after this method returns.
    // Note: Since we use a unique file path for each recording, a new recording will not overwrite a recording currently being saved.

    if (![[outputFileURL absoluteString] isEqualToString:@""]) {

      
       
        
        NSData * dataVal = [NSData dataWithContentsOfURL:outputFileURL];
        
       
           [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savedVideo"];
         [[NSUserDefaults standardUserDefaults]setObject:dataVal  forKey:@"savedVideo"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
   
   
    UIBackgroundTaskIdentifier currentBackgroundRecordingID = self.backgroundRecordingID;
    self.backgroundRecordingID = UIBackgroundTaskInvalid;
    
    dispatch_block_t cleanup = ^{
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
        if ( currentBackgroundRecordingID != UIBackgroundTaskInvalid ) {
            [[UIApplication sharedApplication] endBackgroundTask:currentBackgroundRecordingID];
        }
    };
    
    BOOL success = YES;
    
    if ( error ) {
        NSLog( @"Movie file finishing error: %@", error );
        success = [error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] boolValue];
    }
    if ( success ) {
        
 
        MPMoviePlayerController *controller = [[MPMoviePlayerController alloc]
                                               initWithContentURL:outputFileURL];
        
        self.mc = controller; //Super important
        [controller prepareToPlay];
        controller.repeatMode = YES;
        [controller setControlStyle:MPMovieControlStyleNone];
        controller.view.userInteractionEnabled =YES;
        controller.scalingMode = MPMovieScalingModeAspectFill;
        [self.videoView addSubview:controller.view]; //Show the view
        controller.view.frame = self.videoView.bounds; //Set the size
    
        [controller play]; //Start playing

        
        // Check authorization status.
        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
            if ( status == PHAuthorizationStatusAuthorized ) {
                // Save the movie file to the photo library and cleanup.
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    // In iOS 9 and later, it's possible to move the file into the photo library without duplicating the file data.
                    // This avoids using double the disk space during save, which can make a difference on devices with limited free disk space.
                    if ( [PHAssetResourceCreationOptions class] ) {
                        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                        options.shouldMoveFile = YES;
                        PHAssetCreationRequest *changeRequest = [PHAssetCreationRequest creationRequestForAsset];
                        [changeRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:outputFileURL options:options];
                    }
                    else {
                        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
                    }
                } completionHandler:^( BOOL success, NSError *error ) {
                    if ( ! success ) {
                        NSLog( @"Could not save movie to photo library: %@", error );
                    }
                    cleanup();
                }];
            }
            else {
                cleanup();
            }
        }];
    }
    else {
        cleanup();
    }
    
    // Enable the Camera and Record buttons to let the user switch camera and start another recording.
    dispatch_async( dispatch_get_main_queue(), ^{
        // Only enable the ability to change camera if the device has more than one camera.
        self.cameraButton.enabled = ( [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 1 );
        self.recordButton.enabled = YES;
        [self.recordButton setTitle:NSLocalizedString( @"Record", @"Recording button record title" ) forState:UIControlStateNormal];
    });
    
    
    
    
    
    
    
    
}

//- (void)playerDidExitFullscreen:(NSNotification *)notification
//{
//    self.mc.scalingMode = MPMovieScalingModeNone;
//    self.mc.scalingMode = MPMovieScalingModeAspectFill;
//}
//




-(void)moviePlayerDidEnterFullscreen :(id)sender
{
    NSLog(@"fullscreen");
    [self.mc play];
    self.mc.scalingMode =MPMovieScalingModeFill;
    
}

- (void) moviePlayerDidExitFullScreen:(id)sender {
    
    NSLog(@"exit full screen");
    [self.mc play];
    self.mc.scalingMode =MPMovieScalingModeFill;
    
}

#pragma mark Device Configuration

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async( self.sessionQueue, ^{
        AVCaptureDevice *device = self.videoDeviceInput.device;
        NSError *error = nil;
        if ( [device lockForConfiguration:&error] ) {
            // Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
            // Call -set(Focus/Exposure)Mode: to apply the new point of interest.
            if ( device.isFocusPointOfInterestSupported && [device isFocusModeSupported:focusMode] ) {
                device.focusPointOfInterest = point;
                device.focusMode = focusMode;
            }
            
            if ( device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode] ) {
                device.exposurePointOfInterest = point;
                device.exposureMode = exposureMode;
            }
            
            device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange;
            [device unlockForConfiguration];
        }
        else {
            NSLog( @"Could not lock device for configuration: %@", error );
        }
    } );
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ( device.hasFlash && [device isFlashModeSupported:flashMode] ) {
        NSError *error = nil;
        if ( [device lockForConfiguration:&error] ) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        }
        else {
            NSLog( @"Could not lock device for configuration: %@", error );
        }
    }
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cameraButton:(id)sender {
    
    [_galleryView setHidden:NO];
    [_detailCollectionView setHidden:YES];
    
      _finalViewImage.image = nil;
    [_cameraLabel setHidden:NO];
    [_galleryLabel setHidden:YES];
    [_voiceLabel setHidden:YES];
    [_heyMoodLabel setHidden:YES];
    [_recordView setHidden:YES];
    
    whichMedia = @"camera";
    
}

- (IBAction)galleryButton:(id)sender {
      _finalViewImage.image = nil;
     whichMedia = @"gallery";
    [_cameraLabel setHidden:YES];
    [_galleryLabel setHidden:NO];
    [_voiceLabel setHidden:YES];
    [_heyMoodLabel setHidden:YES];
    [_recordView setHidden:YES];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   picker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
    picker.videoMaximumDuration = 60; // duration in seconds
    
    picker.allowsEditing = YES;
    
   picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
        NSLog(@"imageeeee");
        
        
        
        if ([cameraVal isEqualToString:@""]) {
            [_capturedView setHidden:NO];
            
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            
            [_firstImageView setImage:image];
            [_capturedImageView setImage:image];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        else{
            
            [_capturedView setHidden:NO];
            [_secondCameraOrGallery setHidden:YES];
            
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            
            [_secondImageView setImage:image];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        

    }
    
    else{
        
         NSLog(@"videoooo");
        [_progressView setHidden:YES];
       
        
        [_capturedView setHidden:NO];
        [_voicePlayerView setHidden:NO];
        [_recordView setHidden:YES];
        [_extraView setHidden:YES];
        [_videoView setHidden:NO];
        
        NSData * dataVal = [NSData dataWithContentsOfURL:[info valueForKey:@"UIImagePickerControllerMediaURL"]];
        
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savedVideo"];
        [[NSUserDefaults standardUserDefaults]setObject:dataVal  forKey:@"savedVideo"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        

        MPMoviePlayerController *controller = [[MPMoviePlayerController alloc]
                                               initWithContentURL:[info valueForKey:@"UIImagePickerControllerMediaURL"]];
        
        self.mc = controller; //Super important
        [controller prepareToPlay];
        controller.repeatMode = YES;
        [controller setControlStyle:MPMovieControlStyleNone];
        controller.view.userInteractionEnabled =YES;
        controller.scalingMode = MPMovieScalingModeAspectFit;
        [self.videoView addSubview:controller.view]; //Show the view
        controller.view.frame = self.videoView.bounds; //Set the size
        
        [controller play]; //Start playing
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
    
  
    
  
}


- (IBAction)voiceButton:(id)sender {
    
    
    [_galleryView setHidden:NO];
    [_detailCollectionView setHidden:YES];
    _finalViewImage.image = nil;
    
     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savedVideo"];
     whichMedia = @"voice";
    [_cameraLabel setHidden:YES];
    [_galleryLabel setHidden:YES];
    [_voiceLabel setHidden:NO];
    [_heyMoodLabel setHidden:YES];
    [_recordView setHidden:NO];
    
    
    // Voice Recorder
    
    _capturedImageView.image = nil;
      _firstImageView.image = nil;
 
    
    NSString*strVal = [NSString stringWithFormat:@"MyAudioMemokjkhjkhjk.m4a"];
    
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               strVal,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    // Setup audio session
    //    AVAudioSession *session = [AVAudioSession sharedInstance];
    //    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //
    
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [recordSetting setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    
    
    
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    

    
    
}
- (IBAction)cameraFunButton:(id)sender {
    moodString = @"Fun";
   
    _funSlider.value = 0;
//    [_cameraFunButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
//    [_cameraSeriousButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_cameraGeneralButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    self.cameraFunLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
    self.cameraSeriousLabel.textColor = [UIColor whiteColor];
    self.cameraGeneralLabel.textColor = [UIColor whiteColor];
    
    
}

- (IBAction)closeButton:(id)sender {
    
    [_galleryView setHidden:NO];
    [_detailCollectionView setHidden:YES];
    
    [_heyMoodView setHidden:YES];
    [_heyMoodLabel setHidden:YES];
    _locationText.text = @"";
      _locationAudioVideoText.text = @"";
    _finalViewImage.image = nil;
    finalLat = @"";
    finalLong = @"";
     stop = @"";
     [self.mc stop];
    [_videoView setHidden:YES];
    _capturedImageView.image = nil;
      _firstImageView.image = nil;
    _finalTitleLabelText.text=@"";
    [_voiceLabel setHidden:YES];
     [_cameraLabel setHidden:NO];
    
    [_voiceTypeYourQuestionTitle resignFirstResponder];
    [_imageViewTypeYourQuestionText resignFirstResponder];
    _singleVoiceLeftText.text = @"";
    _singleVoiceRightText.text = @"";
    _singleImageLeftText.text = @"";
    _singleImageRightText.text = @"";
    _voiceTypeYourQuestionTitle.text = @"";
    _imageViewTypeYourQuestionText.text = @"";
    
    [_doubleImageView setHidden:YES];
    [_finalViewWithGestures setHidden:YES];
    
    [_imageViewTypeYourQuestion setHidden:NO];
    [_capturedView setHidden:YES];
    [_voicePlayerView setHidden:YES];
     [_voiceDoubleView setHidden:YES];
    
    _timerLabel.text = @"00:00";
     [self.audioPlayer pauseAudio];
    
    
    _secondImageView.image = [UIImage imageNamed:@""];
    
    [_secondCameraOrGallery setHidden:NO];
    
    cameraVal = @"";
    
    voiceVal=@"";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VoiceOne"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VoiceTwo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_voiceDoublePlayRightButton setTitle: @"New Voice" forState: UIControlStateNormal];

    [_voiceFinalView setHidden:YES];
     [_audioVideoTagView setHidden:YES];
    
     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savedVideo"];
    
    
   [_session startRunning];
    
}


- (IBAction)cameraSeriousButton:(id)sender {
    
    moodString = @"Serious";
   _funSlider.value = 50;
    
//    [_cameraFunButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_cameraSeriousButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
//    [_cameraGeneralButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    self.cameraFunLabel.textColor = [UIColor whiteColor];
    self.cameraSeriousLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
    self.cameraGeneralLabel.textColor = [UIColor whiteColor];
}

- (IBAction)cameraGeneralButton:(id)sender {
    
    moodString = @"General";
    
    _funSlider.value = 100;
//    [_cameraFunButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_cameraSeriousButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_cameraGeneralButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    
    self.cameraFunLabel.textColor = [UIColor whiteColor];
    self.cameraSeriousLabel.textColor = [UIColor whiteColor];
    self.cameraGeneralLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
}

- (IBAction)cameraPrivateButton:(id)sender {
    
    _privateSlider.value = 0;
    privateCategory = @"Private";
    
//    [_cameraPrivateButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
//    [_cameraQatarButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_cameraGlobalButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    self.cameraPrivateLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
    self.cameraQatarLabel.textColor = [UIColor whiteColor];
    self.cameraGlobalLabel.textColor = [UIColor whiteColor];
}

- (IBAction)cameraQatarButton:(id)sender {
    
    _privateSlider.value = 50;
    privateCategory = @"Country";
    
    
//    [_cameraPrivateButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_cameraQatarButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
//    [_cameraGlobalButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    self.cameraPrivateLabel.textColor = [UIColor whiteColor];
    self.cameraQatarLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
    self.cameraGlobalLabel.textColor = [UIColor whiteColor];
}



- (IBAction)voiceRecordButton:(id)sender {
}

- (IBAction)cameraGlobalButton:(id)sender {
    
   _privateSlider.value = 100;
    privateCategory = @"Global";
//    
//    [_cameraPrivateButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_cameraQatarButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_cameraGlobalButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    
    self.cameraPrivateLabel.textColor = [UIColor whiteColor];
    self.cameraQatarLabel.textColor = [UIColor whiteColor];
    self.cameraGlobalLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
}



//VOice Audio Player


- (void)setupAudioPlayer:(NSURL*)fileName
{
    //insert Filename & FileExtension
    
    
    if ([voiceVal isEqualToString:@""]) {
        
      
        
        NSString * testVal = [NSString stringWithFormat:@"%@",fileName];
        [[NSUserDefaults standardUserDefaults] setObject:testVal forKey:@"VoiceOne"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        //init the Player to get file properties to set the time labels
        [self.audioPlayer initPlayer:fileName];
        self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
        
        //init the current timedisplay and the labels. if a current time was stored
        //for this player then take it and update the time display
        self.timeElapsed.text = @"0:00";
        
        self.duration.text = [NSString stringWithFormat:@"-%@",
                              [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];

        
        
    }
    
    else{
        
        
         NSString * testVal = [NSString stringWithFormat:@"%@",fileName];
        [[NSUserDefaults standardUserDefaults] setObject:testVal forKey:@"VoiceTwo"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        //init the Player to get file properties to set the time labels
        [self.audioPlayer initPlayer:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VoiceOne"] ]];
        self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
        
        //init the current timedisplay and the labels. if a current time was stored
        //for this player then take it and update the time display
        self.timeElapsed.text = @"0:00";
        
        self.duration.text = [NSString stringWithFormat:@"-%@",
                              [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    }
   
   
    
}

/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playAudioPressed:(id)playButton
{
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_pause.png"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer playAudio];
        self.isPaused = TRUE;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                   forState:UIControlStateNormal];
        
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        self.currentTimeSlider.value = [self.audioPlayer getCurrentAudioTime];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]]];
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
    
    //When resetted/ended reset the playButton
    if (![self.audioPlayer isPlaying]) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                   forState:UIControlStateNormal];
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.audioPlayer setCurrentAudioTime:self.currentTimeSlider.value];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)dismissButton:(id)sender {
    
    [_galleryView setHidden:NO];
    [_detailCollectionView setHidden:YES];
    
     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savedVideo"];
    flashString = @"";
     voiceVal=@"";
    
    _finalTitleLabelText.text=@"";
    
      [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - CRColorPicker delegate

//Action when user is choosing color
-(void)colorIsChanging:(UIColor *)color{
    [_imageViewTypeYourQuestionText setTextColor:color];
    
     [_finalTitleLabelText setTextColor:color];
}

//Action when user finished to select a color
-(void)colorSelected:(UIColor *)color{
    [_imageViewTypeYourQuestionText setTextColor:color];
    [_finalTitleLabelText setTextColor:color];
}


#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (![_heyMoodView isHidden]) {
        
    }
    
    else{
    
    if ([_checkInView isHidden]) {
   
    
    
    if ([whichMedia isEqualToString:@"video"]) {
        
        
        
        
        if (![_videoView isHidden]){
            
       
            if ([_singleVoiceLeftText.text length] == 0 || [_singleVoiceRightText.text length] == 0){
                
                [self showToast:@"Please enter voice captions!"];
                [textField resignFirstResponder];
                
            }
            
            
            
        }
        
    }
    
    
   else if ([whichMedia isEqualToString:@"voice"]) {
        
        
        
        if ([_voiceDoubleView isHidden]){
            
            if ([_singleVoiceLeftText.text length] == 0 || [_singleVoiceRightText.text length] == 0){
                
                [self showToast:@"Please enter voice captions!"];
                [textField resignFirstResponder];
                
            }
            
            
            
        }
        
        else{
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"VoiceTwo"] == nil){
                [self showToast:@"Please record your secondary audio"];
                [textField resignFirstResponder];
                
            }
            
            
            
            else if ([_voiceDoubleLeftText.text length] == 0 || [_voiceDoubleRightText.text length] == 0){
                
                [self showToast:@"Please enter voice captions!"];
                [textField resignFirstResponder];
                
            }
            
            
        }
        
    }
    

    
    else{
    
    NSLog(@"Text field did begin editing");
    [_imageViewColourPicker setHidden:NO];
    
    if (![_doubleImageView isHidden]) {
        
        if (_secondImageView.image == nil) {
            [self showToast:@"Please select your second image!"];
            [textField resignFirstResponder];
            
            
            
        }
        
        
        else if ([_secondLeftTextField.text length] == 0 || [_secondRightTextField.text length] == 0){
            
            [self showToast:@"Please enter image captions!"];
            [textField resignFirstResponder];
            
            
        }

        
    }
    
    else{
        if (_capturedImageView.image != nil) {
            
            
            if ([_singleImageLeftText.text length] == 0 || [_singleImageRightText.text length] == 0){
                
                [self showToast:@"Please enter image captions!"];
                [textField resignFirstResponder];
                
                
            }

            
            
            
        }

        
       
        
        
    }
        
    }
        
    }
    
    
    else{
        
        if ([_searchTextField.text length]== 0 ) {
            [self callWebservice];
        }
        
        else{
            [self callWebserviceSearch];
        }
        
    }
    }
  }

-(void)showToast:(NSString*)msg{
    
    [self.view makeToast:msg
                duration:1.0
                position:CSToastPositionCenter];
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
    if ([_checkInView isHidden]) {
        
   

    _finalTitleLabelText.text = _imageViewTypeYourQuestionText.text;
     [_imageViewTypeYourQuestion setHidden:YES];
      [_imageViewColourPicker setHidden:YES];
      [_finalViewWithGestures setHidden:NO];
    
    
    if (![_doubleImageView isHidden]) {
        
        if (_secondImageView.image == nil) {
          //  [self showToast:@"Please select your second image!"];
            [textField resignFirstResponder];
            
            
            [_imageViewTypeYourQuestion setHidden:NO];
            [_imageViewColourPicker setHidden:YES];
            [_finalViewWithGestures setHidden:YES];
            
        }
        
//        
//        else if ([_secondLeftTextField.text length] == 0 || [_secondRightTextField.text length] == 0){
//            
//            [self showToast:@"Please enter image captions!"];
//            [textField resignFirstResponder];
//            
//            [_imageViewTypeYourQuestion setHidden:NO];
//            [_imageViewColourPicker setHidden:YES];
//            [_finalViewWithGestures setHidden:YES];
//            
//        }
        
        
    }
    
    
    
    
     }
    
    else if ([_searchTextField.text length]== 0 ) {
        [self callWebservice];
    }
    
    else{
        [self callWebserviceSearch];
    }

    
    
}


-(void)textChanged:(UITextField *)textField
{
    if (![_checkInView isHidden]) {
        
        if ([_searchTextField.text length]== 0 ) {
            [self callWebservice];
        }
        
        else{
            [self callWebserviceSearch];
        }
        
        
        
    }
    
 
}



//ZOOM IMAGE VIEW INSIDE SCROLL VIEW


-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if (scrollView == _firstScrollView) {
        
    
    
    CGSize boundsSize = _firstScrollView.bounds.size;
    CGRect contentsFrame = _firstImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    _firstImageView.frame = contentsFrame;
    
    }
    
   else{
        
       if(_secondImageView.image == nil){
           
           
       }
       
       else{
           
           CGSize boundsSize = _secondscrollView.bounds.size;
           CGRect contentsFrame = _secondImageView.frame;
           
           if (contentsFrame.size.width < boundsSize.width) {
               contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
           } else {
               contentsFrame.origin.x = 0.0f;
           }
           
           if (contentsFrame.size.height < boundsSize.height) {
               contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
           } else {
               contentsFrame.origin.y = 0.0f;
           }
           
           _secondImageView.frame = contentsFrame;
       }
           
       
           
   }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    if (scrollView == _firstScrollView) {
         return self.firstImageView;
    }
    
    else{
       return self.secondImageView;
        
    }
    return nil;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}



- (IBAction)secondCameraOrGalleryButton:(id)sender {
    
    
    cameraVal = @"RightImage";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate:self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];

    
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
        
            
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}



- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];    }
}


-(void)choosePhotoFromExistingImages{
    
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}





- (IBAction)voicePlayOneButton:(id)sender {
    
    
    
    NSURL * newUrl =[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VoiceOne"] ] ;
    
    if (newUrl == nil) {
        NSLog(@"firsttttt");
    }
    else{
        
        
        
//        
//        NSString *soundFilePath = [NSString stringWithFormat:@"%@/test.m4a",
//                                   [[NSBundle mainBundle] resourcePath]];
//        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:newUrl
                                                                       error:nil];
     //  player.numberOfLoops = -1; //Infinite
       // [player prepareToPlay];
       [player play];
        
        NSLog(@"content there fir firsttttt");
    }
    
    
    
}

- (IBAction)voicePlayTwoButton:(id)sender {
    
    NSURL * newUrl = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VoiceTwo"] ] ;
    
    if (newUrl == nil) {
        
        voiceVal = @"second";
        [_recordView setHidden:NO];
        [_extraView setHidden:NO];
        
        
        // Voice Recorder
        
        
        
        NSString*strVal = [NSString stringWithFormat:@"MyAudioMemofsdfsdfsd.m4a"];
        
        
        // Set the audio file
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   strVal,
                                   nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        // Setup audio session
        //    AVAudioSession *session = [AVAudioSession sharedInstance];
        //    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        //
        
        
        // Define the recorder setting
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        [recordSetting setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
        
        
        
        
        // Initiate and prepare the recorder
        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
        

        
        
        
         [_voiceDoublePlayRightButton setTitle: @"Play Voice 2" forState: UIControlStateNormal];
        [self.view bringSubviewToFront:_recordView];
        
    }
    
    else{
     
         [_voiceDoublePlayRightButton setTitle: @"Play Voice 2" forState: UIControlStateNormal];
        
        NSLog(@"seconggggg");
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:newUrl
                                                                         error:nil];
        //  playerrr.numberOfLoops = -1; //Infinite
        
        [player play];

       
      
    }
   
    
}



- (IBAction)postButton:(id)sender {
    
    [self.mc pause];
    


    if (![_heyMoodView isHidden]) {
        _finalViewImage.image = nil;
        
        
        if ([_singleImageLeftText.text length] == 0 || [_singleImageRightText.text length] == 0){
            
            [self showToast:@"Please enter captions"];
            
            
        }
        
        else if ([_heyMoodTextView.text length] == 0){
            
                [self showToast:@"Describe your mood !"];
        }
        
        else if( _finalViewImage.image == nil){
    
       if ([privateCategory isEqualToString:@"Private"]) {
                
                
                
           
                
                [_privateView setHidden:NO];
                

                
                
                CGRect rect = [_heyMoodInnerView bounds];
                UIGraphicsBeginImageContextWithOptions(rect.size,_heyMoodInnerView.opaque,0.0f);
                CGContextRef context = UIGraphicsGetCurrentContext();
                [_heyMoodInnerView.layer renderInContext:context];
              UIImage * screenshot  = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
           
           /* Render the screen shot at custom resolution */
           CGRect cropRect = CGRectMake(0 ,0 ,750 ,750);
           UIGraphicsBeginImageContextWithOptions(cropRect.size, _heyMoodInnerView.opaque, 1.0f);
           [screenshot drawInRect:cropRect];
          capturedImageSingle= UIGraphicsGetImageFromCurrentImageContext();
           UIGraphicsEndImageContext();
           
           
           
                 _finalViewImage.image =capturedImageSingle;
                
   
            }
            
            else{
                
                
                CGRect rect = [_heyMoodInnerView bounds];
                UIGraphicsBeginImageContextWithOptions(rect.size,_heyMoodInnerView.opaque,0.0f);
                CGContextRef context = UIGraphicsGetCurrentContext();
                [_heyMoodInnerView.layer renderInContext:context];
                UIImage * screenshot  = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                /* Render the screen shot at custom resolution */
                CGRect cropRect = CGRectMake(0 ,0 ,750 ,750);
                UIGraphicsBeginImageContextWithOptions(cropRect.size, _heyMoodInnerView.opaque, 1.0f);
                [screenshot drawInRect:cropRect];
                capturedImageSingle= UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                
                _finalViewImage.image =capturedImageSingle;
                [_finalView setHidden:NO];

            }
     
        
        }
        else{
            
            
            NSLog(@"Finall entereeeeed");
            
           // [self callProfileView:@"heymood"];
        }
        

        
        
        
        
    }
    else{
    NSString*rtest  =   [[NSUserDefaults standardUserDefaults]valueForKey:@"savedVideo"];

    if ([rtest length]>0) {
        
    
        if (![_voicePlayerView isHidden]){
            
            if (![_voiceFinalView isHidden]) {
                
//                if (![_voiceDoubleView isHidden]) {
//                    
//                    if ([_voiceDoubleLeftText.text length] == 0 || [_voiceDoubleRightText.text length] == 0){
//                        
//                        [self showToast:@"Please enter captions"];
//                        
//                        
//                    }
//                    
//                    else{
//                        
//                        [self callProfileView:@"voice"];
//                    }
//                    
//                    
//                }
                
             
                    
                    if ([_singleVoiceLeftText.text length] == 0 || [_singleVoiceRightText.text length] == 0){
                        
                        [self showToast:@"Please enter captions"];
                        
                        
                    }
                    
                    else{
                        
                        [self callProfileView:@"video"];
                    }
                    
         
            }
            
            
            else if ([_voiceDoubleView isHidden]) {
                if ([_voiceTypeYourQuestionTitle.text length] == 0) {
                    
                    [self showToast:@"Please enter the post title"];
                    
                }
                
                
                
                else if ([privateCategory isEqualToString:@"Private"]){
                    
                    [_privateView setHidden:NO];
                }
                
                else{
                    
                    [_voiceFinalView setHidden:NO];
                     [_audioVideoTagView setHidden:NO];
                }
                
            }
            
//            else if(![_voiceDoubleView isHidden]){
//                
//                if ([_voiceTypeYourQuestionTitle.text length] == 0) {
//                    
//                    [self showToast:@"Please enter the post title"];
//                    
//                }
//                
//                
//                else if ([privateCategory isEqualToString:@"Private"]){
//                    
//                    [_privateView setHidden:NO];
//                    
//                    
//                }
//                
//                else{
//                    
//                    [_voiceFinalView setHidden:NO];
//                    
//                }
//                
//                
//            }
            
        }
        
    }
    
    else{
    
    if ([_voicePlayerView isHidden]) {
        

    if ([_finalTitleLabelText.text length] == 0) {
        [self showToast:@"Please enter the post title"];
    
    }
    
    else{
        
        if ([_doubleImageView isHidden]) {
        
        if ([privateCategory isEqualToString:@"Private"]) {
            
            [_privateView setHidden:NO];
            
            
            CGRect rectt = [_singleImageView bounds];
            UIGraphicsBeginImageContextWithOptions(rectt.size,_singleImageView.opaque,0.0f);
            CGContextRef contextt = UIGraphicsGetCurrentContext();
            [_singleImageView.layer renderInContext:contextt];
            UIImage *capturedImaget = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
            _finalViewImage.image =capturedImaget;
            
            [_singleImageTextView setHidden:YES];
           
            
            
            CGRect rect = [_singleImageView bounds];
            UIGraphicsBeginImageContextWithOptions(rect.size,_singleImageView.opaque,0.0f);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [_singleImageView.layer renderInContext:context];
           UIImage * capturedImageSingleeee = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            /* Render the screen shot at custom resolution */
            CGRect cropRect = CGRectMake(0 ,0 ,750 ,750);
            UIGraphicsBeginImageContextWithOptions(cropRect.size, _singleImageView.opaque, 1.0f);
            [capturedImageSingleeee drawInRect:cropRect];
            capturedImageSingle= UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            
        
            
       
           [_singleImageTextView setHidden:NO];
            
            
        }
        
        else{
            
 
            
            CGRect rectt = [_singleImageView bounds];
            UIGraphicsBeginImageContextWithOptions(rectt.size,_singleImageView.opaque,0.0f);
            CGContextRef contextt = UIGraphicsGetCurrentContext();
            [_singleImageView.layer renderInContext:contextt];
            UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            _finalViewImage.image =capturedImage;
            
            
            [_singleImageTextView setHidden:YES];
            
            [_finalView setHidden:NO];
            
            
            
            CGRect rect = [_singleImageView bounds];
            UIGraphicsBeginImageContextWithOptions(rect.size,_singleImageView.opaque,0.0f);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [_singleImageView.layer renderInContext:context];
           UIImage* capturedImageSingleeee = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            /* Render the screen shot at custom resolution */
            CGRect cropRect = CGRectMake(0 ,0 ,750 ,750);
            UIGraphicsBeginImageContextWithOptions(cropRect.size, _singleImageView.opaque, 1.0f);
            [capturedImageSingleeee drawInRect:cropRect];
            capturedImageSingle= UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            

            
            
            [_singleImageTextView setHidden:NO];
            
        }
    }
        
        
        else{
            
            {
                
                
                
                
                if ([privateCategory isEqualToString:@"Private"]) {
                    
            
                    
                    
                    
                    [_privateView setHidden:NO];
                    
                    
                    CGRect rectt = [_singleImageView bounds];
                    UIGraphicsBeginImageContextWithOptions(rectt.size,_singleImageView.opaque,0.0f);
                    CGContextRef contextt = UIGraphicsGetCurrentContext();
                    [_singleImageView.layer renderInContext:contextt];
                    UIImage *capturedImaget = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    
                    _finalViewImage.image =capturedImaget;
                    
                    
                    [_doubleImageTextView setHidden:YES];
                    
                    
                    
                    CGRect rect = [_singleImageView bounds];
                    UIGraphicsBeginImageContextWithOptions(rect.size,_singleImageView.opaque,0.0f);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    [_singleImageView.layer renderInContext:context];
                   UIImage* capturedImageDoubleeee = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    /* Render the screen shot at custom resolution */
                    CGRect cropRect = CGRectMake(0 ,0 ,750 ,750);
                    UIGraphicsBeginImageContextWithOptions(cropRect.size, _singleImageView.opaque, 1.0f);
                    [capturedImageDoubleeee drawInRect:cropRect];
                    capturedImageDouble= UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();

                    
                    
                     [_doubleImageTextView setHidden:NO];
                    
                    
                }
                
                else{
                    
                    
                   
                    
                    CGRect rectt = [_singleImageView bounds];
                    UIGraphicsBeginImageContextWithOptions(rectt.size,_singleImageView.opaque,0.0f);
                    CGContextRef contextt = UIGraphicsGetCurrentContext();
                    [_singleImageView.layer renderInContext:contextt];
                    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    _finalViewImage.image =capturedImage;
                    
                    
                    
                 
                    
                    [_finalView setHidden:NO];
                    
                     [_doubleImageTextView setHidden:YES];
                    
                    CGRect rect = [_singleImageView bounds];
                    UIGraphicsBeginImageContextWithOptions(rect.size,_singleImageView.opaque,0.0f);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    [_singleImageView.layer renderInContext:context];
                  UIImage*  capturedImageDoubleeee = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    /* Render the screen shot at custom resolution */
                    CGRect cropRect = CGRectMake(0 ,0 ,750 ,750);
                    UIGraphicsBeginImageContextWithOptions(cropRect.size, _singleImageView.opaque, 1.0f);
                    [capturedImageDoubleeee drawInRect:cropRect];
                    capturedImageDouble= UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    
                 [_doubleImageTextView setHidden:NO];
                    
                }
            }
            
        }
        
        
           }
        
    }

    
    else if (![_voicePlayerView isHidden]){
        
        if (![_voiceFinalView isHidden]) {
            
            if (![_voiceDoubleView isHidden]) {
                
                if ([_voiceDoubleLeftText.text length] == 0 || [_voiceDoubleRightText.text length] == 0){
                    
                    [self showToast:@"Please enter captions"];
                    
                    
                }
                
                else{
                    
                    [self callProfileView:@"voice"];
                }

                
            }
            
            else{
       
                if ([_singleVoiceLeftText.text length] == 0 || [_singleVoiceRightText.text length] == 0){
                    
                    [self showToast:@"Please enter captions"];
                    
                    
                }
                
                else{
                    
                    [self callProfileView:@"voice"];
                }

            }
            
            
            
           
            
     
 }
    
        
       else if ([_voiceDoubleView isHidden]) {
            if ([_voiceTypeYourQuestionTitle.text length] == 0) {
                
                [self showToast:@"Please enter the post title"];
                
            }
       
           
            
            else if ([privateCategory isEqualToString:@"Private"]){
                
                  [_privateView setHidden:NO];
            }
            
            else{
                
                [_voiceFinalView setHidden:NO];
                 [_audioVideoTagView setHidden:NO];
            }

        }
        
        else if(![_voiceDoubleView isHidden]){
            
            if ([_voiceTypeYourQuestionTitle.text length] == 0) {
                
                [self showToast:@"Please enter the post title"];
                
            }
            
            
            else if ([privateCategory isEqualToString:@"Private"]){
                
                [_privateView setHidden:NO];
                
                
            }
            
            else{
                
                [_voiceFinalView setHidden:NO];
                 [_audioVideoTagView setHidden:NO];

            }

            
        }
        
    }
        
    }

    }
           }
    


- (IBAction)privateViewCloseButton:(id)sender {
    [self.mc play];
    [_privateView setHidden:YES];
    
    cellSelected = [[NSMutableArray alloc]init];
    
    
    [[self.myTableView visibleCells] makeObjectsPerformSelector:@selector(setAccessoryType:) withObject:UITableViewCellAccessoryNone];

}

- (IBAction)privateViewRightArrowButton:(id)sender {
    if ([_voicePlayerView isHidden]) {
        
        if (cellSelected.count == 0) {
            
           [self showToast:@"Please select from list"];
            
        }
        
        else{
    [_privateView setHidden:YES];
    
  [[self.myTableView visibleCells] makeObjectsPerformSelector:@selector(setAccessoryType:) withObject:UITableViewCellAccessoryNone];
    
    
   
    
    [_finalView setHidden:NO];
        }
        
         }
    
    else if(![_voicePlayerView isHidden]){
        
        
        if (cellSelected.count == 0) {
            
            [self showToast:@"Please select from list"];
            
        }
        
        else{
        
        [_privateView setHidden:YES];
        
        [[self.myTableView visibleCells] makeObjectsPerformSelector:@selector(setAccessoryType:) withObject:UITableViewCellAccessoryNone];
        
         [_voiceFinalView setHidden:NO];
             [_audioVideoTagView setHidden:NO];

        }
        
    }

}


- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
    original = nil;
    
}


-(void)callProfileView:(NSString*)strVal{
   
    NSInteger categoryID;
    
    NSMutableArray * contactVal;
    
    NSString * hashArrrray;
    
    NSInteger durationInt = 0;
    
    hashArrrray = @"";
    
    
    if ([hashTagsArray length] >0) {
        hashArrrray = hashTagsArray;
    }
    
    else{
        
        hashArrrray = (NSString *)[NSNull null];
    }
    
    
    
    if ([moodString isEqualToString:@"Fun"]) {
        categoryID = 1;
    }
    
    else if ([moodString isEqualToString:@"Serious"]){
        
        categoryID = 2;
        
    }
    
    else{
        
        categoryID = 3;
    }

    if ([durationVal containsString:@"hours"] || [durationVal containsString:@"hour"] ) {
        
        NSArray * arr = [durationVal componentsSeparatedByString:@" "];
        
        durationInt = [[arr objectAtIndex:0] integerValue] * 60;
        
    }
    
    else if ([durationVal containsString:@"mins"]){
          NSArray * arr = [durationVal componentsSeparatedByString:@" "];
        durationInt = [[arr objectAtIndex:0] integerValue];
    }
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        UIView *newVieww = [[UIView alloc]init];
        newVieww.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newVieww];
        
        [GMDCircleLoader setOnView:newVieww withTitle:@"Posting..." animated:YES];
        
        if (![_heyMoodView isHidden]) {
            NSString* latVall  ;
            NSString* longVall ;
            NSString* placeName;
    
            if ([_locationText.text length]>0 && [finalLat length]>0 && [finalLong length]>0) {
                latVall = finalLat;
                longVall = finalLong;
                placeName = _locationText.text;
            }
            
            else{
                
                latVall = (NSString *)[NSNull null];
                longVall = (NSString *)[NSNull null];
                placeName = (NSString *)[NSNull null];
            }
            
            
    
                NSString*   base64StringSingle = [UIImageJPEGRepresentation([self compressForUpload:capturedImageSingle scale:1.0f],1.0)
                                                  base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                
                base64StringSingle = [base64StringSingle stringByReplacingOccurrencesOfString:@"/"
                                                                                   withString:@"_"];
                
                base64StringSingle = [base64StringSingle stringByReplacingOccurrencesOfString:@"+"
                                                                                   withString:@"-"];
                
                
                
                //                NSString*   base64StringDouble = [UIImagePNGRepresentation([self compressForUpload:capturedImageDouble scale:0.1f])
                //                                                  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                //
                //
                
                
                if ([privateCategory isEqualToString:@"Private"]) {
                    
                    if(cellSelected.count > 0){
                        
                        contactVal = [[NSMutableArray alloc]init];
                        
                        
                        
                        
                        for (int i = 0; i<cellSelected.count; i++) {
                            
                            NSMutableDictionary * testVal = [[NSMutableDictionary alloc]init];
                            
                            
                            [testVal setObject:[[cellSelected objectAtIndex:i] valueForKey:@"ContactToken"] forKey:@"ContactToken"];
                            
                            
                            [contactVal addObject:testVal];
                            
                            
                        }
                        
                        
                        
                    }
                    
        
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                   
                                              @"IsPublic":[NSNumber numberWithInt:0], // i ll explain this by call
                                              @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                              @"Title":@":)", // title text
                                              @"Caption1":_singleImageLeftText.text, //  button 1 text
                                              @"Caption2":_singleImageRightText.text, // button2 text
                                              @"ToContacts":[NSNumber numberWithInt:1], // ill explain this by call
                                              @"ToSelectedContacts":[NSNumber numberWithInt:1], //ill explain this by call
                                              @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                              @"CategoryId":[NSNumber numberWithInteger:categoryID],
                                               //1 /2 /3
                                              @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                              @"Lat":latVall, //location latitude
                                              @"Long":longVall, //location longitude
                                              @"LocationName":placeName, //location name text
                                              @"HashTags":hashArrrray, //hashtags text with comma separated
                                              @"lstUsers":[NSNull null] //tagged users token with comma separated
                                              // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringSingle
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":contactVal,
                                      @"isPicture":[NSNumber numberWithInt:1],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                       @"postTypeId":[NSNumber numberWithInteger:2]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else if ([privateCategory isEqualToString:@"Country"]){
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                              @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                              @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                              @"Title":@":)", // title text
                                              @"Caption1":_singleImageLeftText.text, //  button 1 text
                                              @"Caption2":_singleImageRightText.text, // button2 text
                                              @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                              @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                              @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                              @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                              @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                              @"Lat":latVall, //location latitude
                                              @"Long":longVall, //location longitude
                                              @"LocationName":placeName, //location name text
                                              @"HashTags":hashArrrray, //hashtags text with comma separated
                                              @"lstUsers":[NSNull null] //tagged users token with comma separated
                                              // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringSingle
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:1],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                       @"postTypeId":[NSNumber numberWithInteger:2]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else{
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                              
                                              @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                              @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                              @"Title":@":)", // title text
                                              @"Caption1":_singleImageLeftText.text, //  button 1 text
                                              @"Caption2":_singleImageRightText.text, // button2 text
                                              @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                              @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                              @"IsGlobal":[NSNumber numberWithInt:1],  // ill explain this by call
                                              @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                              @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                              @"Lat":latVall, //location latitude
                                              @"Long":longVall, //location longitude
                                              @"LocationName":placeName, //location name text
                                              @"HashTags":hashArrrray, //hashtags text with comma separated
                                              @"lstUsers":[NSNull null] //tagged users token with comma separated
                                              // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringSingle
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:1],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                       @"postTypeId":[NSNumber numberWithInteger:2]
                                      
                                      
                                      };
                }
                

            
        }
        
        else{
        
        if ([strVal isEqualToString:@"image"]) {
            NSString* latVall  ;
            NSString* longVall ;
            NSString* placeName;
            
            
            if ([_locationText.text length]>0 && [finalLat length]>0 && [finalLong length]>0) {
                latVall = finalLat;
                longVall = finalLong;
                placeName = _locationText.text;
            }
            
            else{
                
                latVall = (NSString *)[NSNull null];
                longVall = (NSString *)[NSNull null];
                placeName = (NSString *)[NSNull null];
            }
            
            
            if ([_secondLeftTextField.text length]>0 && [_secondRightTextField.text length]>0) {
//                
//             NSString*   base64StringSingle = [UIImagePNGRepresentation([self compressForUpload:capturedImageDouble scale:1.0f])
//                               base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                
                NSString*   base64StringDouble = [UIImageJPEGRepresentation([self compressForUpload:capturedImageDouble scale:1.0f],1.0)
                                                  base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                
                
                
                
                
//                base64StringDouble = [base64StringDouble stringByReplacingOccurrencesOfString:@"/"
//                                                                             withString:@"_"];
//                
//                base64StringDouble = [base64StringDouble stringByReplacingOccurrencesOfString:@"+"
//                                                                             withString:@"-"];
//                



                
                
                if ([privateCategory isEqualToString:@"Private"]) {
                    
                    if(cellSelected.count > 0){
                        
                       contactVal = [[NSMutableArray alloc]init];
                        
                    
                        
                        
                        for (int i = 0; i<cellSelected.count; i++) {
                            
                           NSMutableDictionary * testVal = [[NSMutableDictionary alloc]init];
                            
                            
                            [testVal setObject:[[cellSelected objectAtIndex:i] valueForKey:@"ContactToken"] forKey:@"ContactToken"];
                            
                            
                             [contactVal addObject:testVal];
                            
                            
                        }
                        
                       
                        
                    }
                    
                    
                    
                    
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                          
                                                      @"IsPublic":[NSNumber numberWithInt:0], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_finalTitleLabelText.text, // title text
                                                      @"Caption1":_secondLeftTextField.text, //  button 1 text
                                                      @"Caption2":_secondRightTextField.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:1], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:1], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                     // finish infoObj
                                              
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringDouble
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":contactVal,
                                      @"isPicture":[NSNumber numberWithInt:1],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                      @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    

                    
                }
                
                else if ([privateCategory isEqualToString:@"Country"]){
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                        
                                                      @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_finalTitleLabelText.text, // title text
                                                      @"Caption1":_secondLeftTextField.text, //  button 1 text
                                                      @"Caption2":_secondRightTextField.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                   // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringDouble
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:1],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                       @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else{
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                             
                                                      @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_finalTitleLabelText.text, // title text
                                                      @"Caption1":_secondLeftTextField.text, //  button 1 text
                                                      @"Caption2":_secondRightTextField.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:1],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                     // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringDouble
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:1],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                       @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                }
                
                
                
                
                

                
            }
            
            else{
                
                NSString*   base64StringSingle = [UIImageJPEGRepresentation([self compressForUpload:capturedImageSingle scale:1.0f],1.0)
                                                  base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                
                base64StringSingle = [base64StringSingle stringByReplacingOccurrencesOfString:@"/"
                                                                                   withString:@"_"];
                
                base64StringSingle = [base64StringSingle stringByReplacingOccurrencesOfString:@"+"
                                                                                   withString:@"-"];
                
                
                
//                NSString*   base64StringDouble = [UIImagePNGRepresentation([self compressForUpload:capturedImageDouble scale:0.1f])
//                                                  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//                
//                
                
                
                if ([privateCategory isEqualToString:@"Private"]) {
                    
                    if(cellSelected.count > 0){
                        
                        contactVal = [[NSMutableArray alloc]init];
                        
                        
                        
                        
                        for (int i = 0; i<cellSelected.count; i++) {
                            
                            NSMutableDictionary * testVal = [[NSMutableDictionary alloc]init];
                            
                            
                            [testVal setObject:[[cellSelected objectAtIndex:i] valueForKey:@"ContactToken"] forKey:@"ContactToken"];
                            
                            
                            [contactVal addObject:testVal];
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                            
                                                      @"IsPublic":[NSNumber numberWithInt:0], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_finalTitleLabelText.text, // title text
                                                      @"Caption1":_singleImageLeftText.text, //  button 1 text
                                                      @"Caption2":_singleImageRightText.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:1], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:1], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                      // finish infoObj
                                              
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringSingle
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":contactVal,
                                      @"isPicture":[NSNumber numberWithInt:1],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                      @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else if ([privateCategory isEqualToString:@"Country"]){
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                           
                                                      @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_finalTitleLabelText.text, // title text
                                                      @"Caption1":_singleImageLeftText.text, //  button 1 text
                                                      @"Caption2":_singleImageRightText.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                     // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringSingle
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:1],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                       @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else{
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                             
                                                      @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_finalTitleLabelText.text, // title text
                                                      @"Caption1":_singleImageLeftText.text, //  button 1 text
                                                      @"Caption2":_singleImageRightText.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:1],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                    // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringSingle
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:1],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                       @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                }
                
                
                
                
                
                
                
            }
            
            
            

            
        }
        
        else if([strVal isEqualToString:@"voice"]){
            
            NSString* latVall  ;
            NSString* longVall ;
            NSString* placeName;
            
            
            if ([_locationAudioVideoText.text length]>0 && [finalLat length]>0 && [finalLong length]>0) {
                latVall = finalLat;
                longVall = finalLong;
                placeName = _locationAudioVideoText.text;
            }
            
            else{
                
                latVall = (NSString *)[NSNull null];
                longVall = (NSString *)[NSNull null];
                placeName = (NSString *)[NSNull null];
            }

            
            
            
            if ([_voiceDoubleLeftText.text length]>0 && [_voiceDoubleRightText.text length]>0) {
          
                firstVoice = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VoiceOne"] ]];
                
                NSString *base64StringOne = [firstVoice base64EncodedStringWithOptions:0];
                
                base64StringOne = [base64StringOne stringByReplacingOccurrencesOfString:@"/"
                                                                       withString:@"_"];
                
                base64StringOne = [base64StringOne stringByReplacingOccurrencesOfString:@"+"
                                                                       withString:@"-"];
                
                
                
                secondVoice = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VoiceTwo"] ]];
                
                NSString *base64StringTWo = [secondVoice base64EncodedStringWithOptions:0];
                
                base64StringTWo = [base64StringTWo stringByReplacingOccurrencesOfString:@"/"
                                                                             withString:@"_"];
                
                base64StringTWo = [base64StringTWo stringByReplacingOccurrencesOfString:@"+"
                                                                             withString:@"-"];
                


                
                
                if ([privateCategory isEqualToString:@"Private"]) {
                    
                    if(cellSelected.count > 0){
                        
                        contactVal = [[NSMutableArray alloc]init];
                        
                        
                        
                        
                        for (int i = 0; i<cellSelected.count; i++) {
                            
                            NSMutableDictionary * testVal = [[NSMutableDictionary alloc]init];
                            
                            
                            [testVal setObject:[[cellSelected objectAtIndex:i] valueForKey:@"ContactToken"] forKey:@"ContactToken"];
                            
                            
                            [contactVal addObject:testVal];
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                            
                                                      @"IsPublic":[NSNumber numberWithInt:0], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_voiceTypeYourQuestionTitle.text, // title text
                                                      @"Caption1":_voiceDoubleLeftText.text, //  button 1 text
                                                      @"Caption2":_voiceDoubleRightText.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:1], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:1], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                  // finish infoObj
                                                   
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                              
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringOne
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":base64StringTWo
                                              },
                                      @"lstContacts":contactVal,
                                      @"isPicture":[NSNumber numberWithInt:0],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:1],
                                         @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else if ([privateCategory isEqualToString:@"Country"]){
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                           
                                                      @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_voiceTypeYourQuestionTitle.text, // title text
                                                      @"Caption1":_voiceDoubleLeftText.text, //  button 1 text
                                                      @"Caption2":_voiceDoubleRightText.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                   // finish infoObj
                                              
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringOne
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":base64StringTWo
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:0],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:1],
                                      @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else{
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                           
                                                      @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_voiceTypeYourQuestionTitle.text, // title text
                                                      @"Caption1":_voiceDoubleLeftText.text, //  button 1 text
                                                      @"Caption2":_voiceDoubleRightText.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:1],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                      // finish infoObj
                                              
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringOne
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":base64StringTWo
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:0],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:1],
                                      @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                }
                
                
                
                
                
                
                
            }
            
            else{
                
                
                
             NSData*   firstVoiceee = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VoiceOne"] ]];
                
                NSString *base64StringOne = [firstVoiceee base64EncodedStringWithOptions:0];
                
                base64StringOne = [base64StringOne stringByReplacingOccurrencesOfString:@"/"
                                                                             withString:@"_"];
                
                base64StringOne = [base64StringOne stringByReplacingOccurrencesOfString:@"+"
                                                                             withString:@"-"];
                
                
                
                
                if ([privateCategory isEqualToString:@"Private"]) {
                    
                    if(cellSelected.count > 0){
                        
                        contactVal = [[NSMutableArray alloc]init];
                        
                        
                        
                        
                        for (int i = 0; i<cellSelected.count; i++) {
                            
                            NSMutableDictionary * testVal = [[NSMutableDictionary alloc]init];
                            
                            
                            [testVal setObject:[[cellSelected objectAtIndex:i] valueForKey:@"ContactToken"] forKey:@"ContactToken"];
                            
                            
                            [contactVal addObject:testVal];
                            
                            
                        }
                        
                        
                        
                    }
                    
        
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                    
                                                      @"IsPublic":[NSNumber numberWithInt:0], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_voiceTypeYourQuestionTitle.text, // title text
                                                      @"Caption1":_singleVoiceLeftText.text, //  button 1 text
                                                      @"Caption2":_singleVoiceRightText.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:1], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:1], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                      // finish infoObj
                                              
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringOne
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":contactVal,
                                      @"isPicture":[NSNumber numberWithInt:0],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:1],
                                      @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else if ([privateCategory isEqualToString:@"Country"]){
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                           
                                                      @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_voiceTypeYourQuestionTitle.text, // title text
                                                      @"Caption1":_singleVoiceLeftText.text, //  button 1 text
                                                      @"Caption2":_singleVoiceRightText.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                    // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringOne
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:0],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:1],
                                       @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else{
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                            
                                                      @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                                      @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                                      @"Title":_voiceTypeYourQuestionTitle.text, // title text
                                                      @"Caption1":_singleVoiceLeftText.text, //  button 1 text
                                                      @"Caption2":_singleVoiceRightText.text, // button2 text
                                                      @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                                      @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                                      @"IsGlobal":[NSNumber numberWithInt:1],  // ill explain this by call
                                                      @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                                      @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                                      @"Lat":latVall, //location latitude
                                                      @"Long":longVall, //location longitude
                                                      @"LocationName":placeName, //location name text
                                                      @"HashTags":hashArrrray, //hashtags text with comma separated
                                                      @"lstUsers":[NSNull null] //tagged users token with comma separated
                                                      // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringOne
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:0],
                                      @"isVideo":[NSNumber numberWithInt:0],
                                      @"isAudio":[NSNumber numberWithInt:1],
                                       @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                }
                
                
                
                
                
                

                
                
            }
            
            
            
            
            
        }
        
        
        
        else{
            NSString* latVall  ;
            NSString* longVall ;
            NSString* placeName;
            
            
            if ([_locationAudioVideoText.text length]>0 && [finalLat length]>0 && [finalLong length]>0) {
                latVall = finalLat;
                longVall = finalLong;
                placeName = _locationAudioVideoText.text;
            }
            
            else{
                
                latVall = (NSString *)[NSNull null];
                longVall = (NSString *)[NSNull null];
                placeName = (NSString *)[NSNull null];
            }
            

            
            if ([_voiceDoubleLeftText.text length]>0 && [_voiceDoubleRightText.text length]>0) {
                
//                firstVoice = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VoiceOne"] ]];
//                
//                NSString *base64StringOne = [firstVoice base64EncodedStringWithOptions:0];
//                
//                base64StringOne = [base64StringOne stringByReplacingOccurrencesOfString:@"/"
//                                                                             withString:@"_"];
//                
//                base64StringOne = [base64StringOne stringByReplacingOccurrencesOfString:@"+"
//                                                                             withString:@"-"];
//                
//                
//                
//                secondVoice = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VoiceTwo"] ]];
//                
//                NSString *base64StringTWo = [secondVoice base64EncodedStringWithOptions:0];
//                
//                base64StringTWo = [base64StringTWo stringByReplacingOccurrencesOfString:@"/"
//                                                                             withString:@"_"];
//                
//                base64StringTWo = [base64StringTWo stringByReplacingOccurrencesOfString:@"+"
//                                                                             withString:@"-"];
//                
//                
//                
//                
//                
//                if ([privateCategory isEqualToString:@"Private"]) {
//                    
//                    if(cellSelected.count > 0){
//                        
//                        contactVal = [[NSMutableArray alloc]init];
//                        
//                        
//                        
//                        
//                        for (int i = 0; i<cellSelected.count; i++) {
//                            
//                            NSMutableDictionary * testVal = [[NSMutableDictionary alloc]init];
//                            
//                            
//                            [testVal setObject:[[cellSelected objectAtIndex:i] valueForKey:@"ContactToken"] forKey:@"ContactToken"];
//                            
//                            
//                            [contactVal addObject:testVal];
//                            
//                            
//                        }
//                        
//                        
//                        
//                    }
//                    
//                    
//                    
//                    
//                    
//                    jsonDictionary =@{
//                                      
//                                      @"isWeb":@"false",
//                                      
//                                      @"info":@{
//                                              
//                                              
//                                              
//                                              @"IsPublic":[NSNumber numberWithInt:0], // i ll explain this by call
//                                              @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
//                                              @"Title":_voiceTypeYourQuestionTitle.text, // title text
//                                              @"Caption1":_voiceDoubleLeftText.text, //  button 1 text
//                                              @"Caption2":_voiceDoubleRightText.text, // button2 text
//                                              @"ToContacts":[NSNumber numberWithInt:1], // ill explain this by call
//                                              @"ToSelectedContacts":[NSNumber numberWithInt:1], //ill explain this by call
//                                              @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
//                                              @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
//                                              @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
//                                              @"Lat":[NSNull null], //location latitude
//                                              @"Long":[NSNull null], //location longitude
//                                              @"LocationName":[NSNull null], //location name text
//                                              @"HashTags":[NSNull null], //hashtags text with comma separated
//                                              @"lstUsers":[NSNull null] //tagged users token with comma separated
//                                              // finish infoObj
//                                              
//                                              
//                                              },
//                                      @"resource1Info":@{
//                                              @"DataUrl":base64StringOne
//                                              },
//                                      @"resource2Info":@{
//                                              @"DataUrl":base64StringTWo
//                                              },
//                                      @"lstContacts":contactVal,
//                                      @"isPicture":[NSNumber numberWithInt:0],
//                                      @"isVideo":[NSNumber numberWithInt:0],
//                                      @"isAudio":[NSNumber numberWithInt:1]
//                                      
//                                      
//                                      };
//                    
//                    
//                    
//                }
//                
//                else if ([privateCategory isEqualToString:@"Country"]){
//                    
//                    jsonDictionary =@{
//                                      
//                                      @"isWeb":@"false",
//                                      
//                                      @"info":@{
//                                              
//                                              
//                                              
//                                              @"IsPublic":[NSNumber numberWithInt:0], // i ll explain this by call
//                                              @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
//                                              @"Title":_voiceTypeYourQuestionTitle.text, // title text
//                                              @"Caption1":_voiceDoubleLeftText.text, //  button 1 text
//                                              @"Caption2":_voiceDoubleRightText.text, // button2 text
//                                              @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
//                                              @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
//                                              @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
//                                              @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
//                                              @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
//                                              @"Lat":[NSNull null], //location latitude
//                                              @"Long":[NSNull null], //location longitude
//                                              @"LocationName":[NSNull null], //location name text
//                                              @"HashTags":[NSNull null], //hashtags text with comma separated
//                                              @"lstUsers":[NSNull null] //tagged users token with comma separated
//                                              // finish infoObj
//                                              
//                                              
//                                              },
//                                      @"resource1Info":@{
//                                              @"DataUrl":base64StringOne
//                                              },
//                                      @"resource2Info":@{
//                                              @"DataUrl":base64StringTWo
//                                              },
//                                      @"lstContacts":@[],
//                                      @"isPicture":[NSNumber numberWithInt:0],
//                                      @"isVideo":[NSNumber numberWithInt:0],
//                                      @"isAudio":[NSNumber numberWithInt:1]
//                                      
//                                      
//                                      };
//                    
//                    
//                    
//                }
//                
//                else{
//                    
//                    jsonDictionary =@{
//                                      
//                                      @"isWeb":@"false",
//                                      
//                                      @"info":@{
//                                              
//                                              
//                                              
//                                              @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
//                                              @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
//                                              @"Title":_voiceTypeYourQuestionTitle.text, // title text
//                                              @"Caption1":_voiceDoubleLeftText.text, //  button 1 text
//                                              @"Caption2":_voiceDoubleRightText.text, // button2 text
//                                              @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
//                                              @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
//                                              @"IsGlobal":[NSNumber numberWithInt:1],  // ill explain this by call
//                                              @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
//                                              @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
//                                              @"Lat":[NSNull null], //location latitude
//                                              @"Long":[NSNull null], //location longitude
//                                              @"LocationName":[NSNull null], //location name text
//                                              @"HashTags":[NSNull null], //hashtags text with comma separated
//                                              @"lstUsers":[NSNull null] //tagged users token with comma separated
//                                              // finish infoObj
//                                              
//                                              
//                                              },
//                                      @"resource1Info":@{
//                                              @"DataUrl":base64StringOne
//                                              },
//                                      @"resource2Info":@{
//                                              @"DataUrl":base64StringTWo
//                                              },
//                                      @"lstContacts":@[],
//                                      @"isPicture":[NSNumber numberWithInt:0],
//                                      @"isVideo":[NSNumber numberWithInt:0],
//                                      @"isAudio":[NSNumber numberWithInt:1]
//                                      
//                                      
//                                      };
//                }
//                
//                
//                
//                
//                
//                
                
            }
            
       
            else{
                

                
                NSString *base64StringOne = [[[NSUserDefaults standardUserDefaults]valueForKey:@"savedVideo"] base64EncodedStringWithOptions:0];
                
                base64StringOne = [base64StringOne stringByReplacingOccurrencesOfString:@"/"
                                                                             withString:@"_"];
                
                base64StringOne = [base64StringOne stringByReplacingOccurrencesOfString:@"+"
                                                                             withString:@"-"];
                
                
                
                
                if ([privateCategory isEqualToString:@"Private"]) {
                    
                    if(cellSelected.count > 0){
                        
                        contactVal = [[NSMutableArray alloc]init];
                        
                        
                        
                        
                        for (int i = 0; i<cellSelected.count; i++) {
                            
                            NSMutableDictionary * testVal = [[NSMutableDictionary alloc]init];
                            
                            
                            [testVal setObject:[[cellSelected objectAtIndex:i] valueForKey:@"ContactToken"] forKey:@"ContactToken"];
                            
                            
                            [contactVal addObject:testVal];
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                              
                                              @"IsPublic":[NSNumber numberWithInt:0], // i ll explain this by call
                                              @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                              @"Title":_voiceTypeYourQuestionTitle.text, // title text
                                              @"Caption1":_singleVoiceLeftText.text, //  button 1 text
                                              @"Caption2":_singleVoiceRightText.text, // button2 text
                                              @"ToContacts":[NSNumber numberWithInt:1], // ill explain this by call
                                              @"ToSelectedContacts":[NSNumber numberWithInt:1], //ill explain this by call
                                              @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                              @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                              @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                              @"Lat":latVall, //location latitude
                                              @"Long":longVall, //location longitude
                                              @"LocationName":placeName, //location name text
                                              @"HashTags":hashArrrray, //hashtags text with comma separated
                                              @"lstUsers":[NSNull null] //tagged users token with comma separated
                                              // finish infoObj
                                             
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringOne
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":contactVal,
                                      @"isPicture":[NSNumber numberWithInt:0],
                                      @"isVideo":[NSNumber numberWithInt:1],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                       @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    
                    
                    
                    
                    
                    
                }
                
                else if ([privateCategory isEqualToString:@"Country"]){
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                              
                                              @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                              @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                              @"Title":_voiceTypeYourQuestionTitle.text, // title text
                                              @"Caption1":_singleVoiceLeftText.text, //  button 1 text
                                              @"Caption2":_singleVoiceRightText.text, // button2 text
                                              @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                              @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                              @"IsGlobal":[NSNumber numberWithInt:0],  // ill explain this by call
                                              @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                              @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                              @"Lat":latVall, //location latitude
                                              @"Long":longVall, //location longitude
                                              @"LocationName":placeName, //location name text
                                              @"HashTags":hashArrrray, //hashtags text with comma separated
                                              @"lstUsers":[NSNull null] //tagged users token with comma separated
                                              // finish infoObj
                                              
                                              
                                              },
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringOne
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:0],
                                      @"isVideo":[NSNumber numberWithInt:1],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                      @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                    
                    
                    
                }
                
                else{
                    
                    jsonDictionary =@{
                                      
                                      @"isWeb":@"false",
                                      
                                      @"info":@{
                                              
                                              
                                              
                                              @"IsPublic":[NSNumber numberWithInt:1], // i ll explain this by call
                                              @"TerritoryId":[NSNumber numberWithInt:0], //send always 0
                                              @"Title":_voiceTypeYourQuestionTitle.text, // title text
                                              @"Caption1":_singleVoiceLeftText.text, //  button 1 text
                                              @"Caption2":_singleVoiceRightText.text, // button2 text
                                              @"ToContacts":[NSNumber numberWithInt:0], // ill explain this by call
                                              @"ToSelectedContacts":[NSNumber numberWithInt:0], //ill explain this by call
                                              @"IsGlobal":[NSNumber numberWithInt:1],  // ill explain this by call
                                              @"CategoryId":[NSNumber numberWithInteger:categoryID], //1 /2 /3
                                              @"Duration":[NSNumber numberWithInteger:durationInt], //duration converted to minutes
                                              @"Lat":latVall, //location latitude
                                              @"Long":longVall, //location longitude
                                              @"LocationName":placeName, //location name text
                                              @"HashTags":hashArrrray, //hashtags text with comma separated
                                              @"lstUsers":[NSNull null] //tagged users token with comma separated
                                              // finish infoObj
                                              
                                              
                                              },
                                      @"resource1Info":@{
                                              @"DataUrl":base64StringOne
                                              },
                                      @"resource2Info":@{
                                              @"DataUrl":@""
                                              },
                                      @"lstContacts":@[],
                                      @"isPicture":[NSNumber numberWithInt:0],
                                      @"isVideo":[NSNumber numberWithInt:1],
                                      @"isAudio":[NSNumber numberWithInt:0],
                                      @"postTypeId":[NSNumber numberWithInteger:0]
                                      
                                      
                                      };
                }
                
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
        }
        
        }
        
             NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/addpost_N4"]];
        
        
        [requestPost setHTTPMethod:@"POST"];
        [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        
        
        
        NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        [requestPost setHTTPBody: requestData];
        
        //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
        
        
        
        [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
        
        // NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requestPost delegate:self];
        
        [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *dataa, NSError *error) {
            if (error) {
                //do something with error
            } else {
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:dataa options:0 error:nil];
                //            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
                //            NSString *newLineStr = @"\n";
                //            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (dic==nil) {
                        
                        
                        [self showToast:@"Network Issue! Please Try Again."];
                        
                        [GMDCircleLoader hideFromView:newVieww animated:YES];
                        [newVieww removeFromSuperview];
                        
                        
                    }
                    else{
                        
                       
                        NSLog(@"hjfshjfhs%@",dic);
                        [self showToast:@"Posted Successfully"];
                        _locationText.text = @"";
                          _locationAudioVideoText.text = @"";
                        finalLat = @"";
                        finalLong = @"";
                         flashString = @"";
                        _finalTitleLabelText.text=@"";
                        [_voiceLabel setHidden:YES];
                        [_cameraLabel setHidden:NO];
                        
                        [_voiceTypeYourQuestionTitle resignFirstResponder];
                        [_imageViewTypeYourQuestionText resignFirstResponder];
                        
                        _voiceTypeYourQuestionTitle.text = @"";
                        _imageViewTypeYourQuestionText.text = @"";
                        
                        [_doubleImageView setHidden:YES];
                        [_finalViewWithGestures setHidden:YES];
                        
                        [_imageViewTypeYourQuestion setHidden:NO];
                        [_capturedView setHidden:YES];
                        [_voicePlayerView setHidden:YES];
                        [_voiceDoubleView setHidden:YES];
                        
                        _timerLabel.text = @"00:00";
                        [self.audioPlayer pauseAudio];
                        
                        
                        _secondImageView.image = [UIImage imageNamed:@""];
                        
                        [_secondCameraOrGallery setHidden:NO];
                        
                        cameraVal = @"";
                        
                        voiceVal=@"";
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VoiceOne"];
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VoiceTwo"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [_voiceDoublePlayRightButton setTitle: @"New Voice" forState: UIControlStateNormal];
                        
                        [_voiceFinalView setHidden:YES];
                         [_audioVideoTagView setHidden:YES];

                        [_finalView setHidden:YES];
                        
                   
                        [GMDCircleLoader hideFromView:newVieww animated:YES];
                        [newVieww removeFromSuperview];
                        
                        
                        voiceVal=@"";
                        
                        _finalTitleLabelText.text=@"";
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
              
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginComplete" object:nil];

                        
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


-(void)PushAnimation
{
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.0f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
}



#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    
    if ([_checkInView isHidden]) {
        
        
        if (![_galleryView isHidden]) {
            
       
               return self.groups.count;
           
        }
        
        else{
        
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"greenValue"] count];
        }
        
    }
    
    else{
        
        if (searchPlaces.count == 0) {
            return [places count];
        }
        else{
            return [searchPlaces count];
        }

    }

    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    if ([_checkInView isHidden]) {
        
     if (![_galleryView isHidden]) {
         
        
         static NSString *CellIdentifierFirstSecondCell = @"secondCell";
         
         
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFirstSecondCell];
             
             if (cell == nil) {
                 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierFirstSecondCell];
             }
             
             
           
             
             
             
//             
//             AVCaptureSession *session = [[AVCaptureSession alloc] init];
//             AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//             if (videoDevice)
//             {
//                 NSError *error;
//                 AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
//                 if (!error)
//                 {
//                     if ([session canAddInput:videoInput])
//                     {
//                         [session addInput:videoInput];
//                         AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//                         previewLayer.frame = firstView.bounds;
//                         [firstView.layer addSublayer:previewLayer];
//                         
//                         [session beginConfiguration];
//                         [session startRunning];
//                     }
//                 }
//             }
//             
//             
             
             
//             UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
//             AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
//             if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
//                 initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
//             }
//               firstView.session = self.session;
//             
//             
//             AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)firstView.layer;
//             
//             //                  UIView * firstView = (UIView*)[self.view viewWithTag:105];
//             //                previewLayer = (AVCaptureVideoPreviewLayer *)firstView.layer;
//             
//             
//             //                UIView * firstView = (UIView*)[self.view viewWithTag:105];
//             //
//             //                firstView =(AVCaptureVideoPreviewLayer *)self.previewView.layer;
//             //
//             previewLayer.connection.videoOrientation = initialVideoOrientation;
//             
//             previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//             
             
     
//             
//             
//             AVCaptureSession *captureSession = _session;
//             AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
//             
//             previewLayer.frame = firstView.bounds; // Assume you want the preview layer to fill the view.
//             [firstView.layer addSublayer:previewLayer];
//             
             
             ALAssetsGroup *groupForCell = self.groups[indexPath.row];
             CGImageRef posterImageRef = [groupForCell posterImage];
             UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
             
             UIImageView * firstImage = (UIImageView*)[cell viewWithTag:1];
             firstImage.image = posterImage;
              UILabel * firstLabel = (UILabel*)[cell viewWithTag:2];
             firstLabel.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
              UILabel * secondLabel = (UILabel*)[cell viewWithTag:3];
             secondLabel.text =[@(groupForCell.numberOfAssets) stringValue];
//             cell.imageView.image = posterImage;
//             cell.textLabel.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
//             cell.detailTextLabel.text = [@(groupForCell.numberOfAssets) stringValue];
//             
             return cell;
         
         
     }
        
     else{

        static NSString *simpleTableIdentifier = @"myCell";
        
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    
    
 
    if ([cellSelected containsObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"greenValue"] objectAtIndex:indexPath.row]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    
    
    
    NSString *imgStr;
    UILabel*labOne = (UILabel*)[cell viewWithTag:200];
    
    labOne.text = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"greenValue"] valueForKey:@"Name"] objectAtIndex:indexPath.row];
    
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"greenValue"] valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row] == nil) {
        
    }
    
    else{
        
       imgStr  = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[[[NSUserDefaults standardUserDefaults] objectForKey:@"greenValue"] valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[[[NSUserDefaults standardUserDefaults] objectForKey:@"greenValue"] valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
        
    }
   
    
     UIImageView*imgOne = (UIImageView*)[cell viewWithTag:300];
    [imgOne  sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"userContacts.png"]];
        
        return cell;
     }
        
    }
    else{
        
        static NSString *cellIdentifier = @"checkInCell";
        static NSString *cellIdentifierOne = @"checkInSearchCell";
        
        
        
        if (searchPlaces.count == 0) {
            
            
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:
                        UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            
            if ([[places valueForKey:@"name"]objectAtIndex:indexPath.row]  == [NSNull null] || [[places valueForKey:@"vicinity"] objectAtIndex:indexPath.row]  == [NSNull null] ||  [[places valueForKey:@"icon"] objectAtIndex:indexPath.row]  == [NSNull null]) {
                
                return cell;
                
            }
            
            else{
                
                
                
                UILabel *label = (UILabel *)[cell viewWithTag:102];
                label.text = [[places valueForKey:@"name"] objectAtIndex:indexPath.row];
                
                
                
                UILabel *label1 = (UILabel *)[cell viewWithTag:103];
                label1.text = [[places valueForKey:@"vicinity"] objectAtIndex:indexPath.row];
                
                
                
                
                
                UIImageView *imageviews = (UIImageView *)[cell viewWithTag:101];
                
             //   [imageviews.layer setCornerRadius:imageviews.frame.size.width/2];
                 [imageviews.layer setCornerRadius:10];
                imageviews.clipsToBounds = YES;
                imageviews.layer.borderColor=(__bridge CGColorRef)([UIColor clearColor]);
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    if ([places valueForKey:@"icon"] == [NSNull null]) {
                        
                    }
                    
                    else {
                        
                        
                        NSString *imgURL = [[places valueForKey:@"icon"] objectAtIndex:indexPath.row];
                        
                        
                        
                        if ([imgURL isEqualToString:@""] || [imgURL isEqualToString:@"<null>"]) {
                            
                        }
                        else{
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                
                                imageviews.layer.cornerRadius=10;
                                
                                imageviews.layer.borderWidth=0;
                                imageviews.layer.masksToBounds = YES;
                                [imageviews  sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
                            });
                            
                        }
                    }
                    
                });
                
                return cell;
            }
            
        }
        
        else{
            
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     cellIdentifierOne];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:
                        UITableViewCellStyleDefault reuseIdentifier:cellIdentifierOne];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            
            
            UILabel *label = (UILabel *)[cell viewWithTag:101];
            label.text = [[searchPlaces valueForKey:@"description"] objectAtIndex:indexPath.row];
            
            
            
            
            return cell;
        }
        
        
    }
    return nil;

}



// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (![_galleryView isHidden]) {
        return 1;
    }
    
    else{
        
        return 1;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView
                      cellForRowAtIndexPath:indexPath];
    
    
        CGRect screenRectt = [[UIScreen mainScreen] bounds];
        CGFloat screenWidthh = screenRectt.size.width;
       // NSInteger newValF;
      //  NSInteger tabHeight = 68;
    
    
    
    
    
        if (screenWidthh == 320) {
            return cell.frame.size.height ;
        }
    
        else{
            return cell.frame.size.height + 20;
            
        }
    
    
    
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//    if (![_galleryView isHidden]) {
//        
//   
//    
//    CGRect screenRectt = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidthh = screenRectt.size.width;
//    NSInteger newValF;
//    NSInteger tabHeight = 68;
//    
//    
//        
//
//    
//    if (screenWidthh == 320) {
//        
//        tabHeight = tabHeight;
//        
//    }
//    
//    else{
//        newValF = screenWidthh - 320;
//        
//        tabHeight = tabHeight + newValF;
//    }
//    
//    
//    return tabHeight;
//        
//       }
//    
//    return 0;
//}


#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    if ([_checkInView isHidden]) {
        
 
        if (![_galleryView isHidden]) {
            
            
            if (!self.assets) {
                _assets = [[NSMutableArray alloc] init];
            } else {
                [self.assets removeAllObjects];
            }
       
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result) {
                    
                 //    ALAssetRepresentation *rep = [result defaultRepresentation];
                    
                    [self.assets addObject:result];
                
                }
            };
            
            NSIndexPath *selectedIndexPath = [self.galleryTableView indexPathForSelectedRow];
            if (self.groups.count > (NSUInteger)selectedIndexPath.row) {
                
                
                self.assetsGroup = self.groups[selectedIndexPath.row];

                
            }

            
                      ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
            [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
           
            
            [_galleryView setHidden:YES];
            [_detailCollectionView setHidden:NO];
            
            
            
            
 [_myCollectionView reloadData];
            
            NSInteger section = [self.myCollectionView numberOfSections] - 1;
            NSInteger item = [self.myCollectionView numberOfItemsInSection:section] - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [self.myCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:NO];
            
        }
        else{
    
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
  //  UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    
    
    NSLog(@"Section:%ld Row:%ld selected and its data",
          (long)indexPath.section,(long)indexPath.row);
    
    if ([cellSelected containsObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"greenValue"] objectAtIndex:indexPath.row]]) {
         [cellSelected removeObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"greenValue"] objectAtIndex:indexPath.row]];
        
        
         [tableView  cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    
    else{
    
    
    [cellSelected addObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"greenValue"] objectAtIndex:indexPath.row]];
        
          [tableView  cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    //  NSLog(@”Arr Value : %@”,SelectArr);
  
           }
        
    }
    
    else{
        
        if (searchPlaces.count == 0) {
            
            
            
            
        //    UIStoryboard * signUpBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //    checkInCategoryViewController *  CountryScrolling = [signUpBoard instantiateViewControllerWithIdentifier:@"checkInCategoryViewController"];
            
         _locationText.text= [NSString stringWithFormat:@"%@",[[places valueForKey:@"name"] objectAtIndex:indexPath.row] ] ;
            
              _locationAudioVideoText.text = [NSString stringWithFormat:@"%@",[[places valueForKey:@"name"] objectAtIndex:indexPath.row] ];
            
            [_checkInView setHidden:YES];
            
            finalLat = currentlatitude;
            finalLong = currentlongitude;
            
            
            _searchTextField.text = @"";
            [_searchTextField resignFirstResponder];
            
            
         //   [self.navigationController pushViewController: CountryScrolling animated:YES];
            
        }
        
        else{
            
            BOOL interNetCheck=[WebServiceUrl InternetCheck];
            if (interNetCheck==YES ) {
                
                
                
                //        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%@&radius=100000&sensor=true&query=%@&key=AIzaSyDC14veVa3LW5O5sNsgU7WYF3nLxyemJLM",latLong,_searchTextField.text];
                
                NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=AIzaSyDC14veVa3LW5O5sNsgU7WYF3nLxyemJLM",[[searchPlaces objectAtIndex:indexPath.row] valueForKey:@"description"]];
                
                NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:
                                        NSUTF8StringEncoding];
                
                //Formulate the string as URL object.
                NSURL *googleRequestURL=[NSURL URLWithString:encodedUrl];
                
                
                // Retrieve the results of the URL.
                dispatch_async(kBgQueue, ^{
                    NSData * dataResult = [NSData dataWithContentsOfURL: googleRequestURL];
                    [self performSelectorOnMainThread:@selector(fetchedDataSearchDidSelect:) withObject:dataResult waitUntilDone:YES];
                });
                
                
                
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
        
        
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageViewTwo = (UIImageView *)[cell viewWithTag:2];

     [imageViewTwo setHidden:YES];
    // load the asset for this cell
    ALAsset *asset = self.assets[indexPath.row];
    //  CGImageRef thumbnailImageRef = [asset aspectRatioThumbnail];
    
    CGImageRef thumbnailImageRef = [asset aspectRatioThumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    
    // apply the image to the cell
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
    
    
    if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
        // asset is a video
        
        [imageViewTwo setHidden:NO];
    }
    
    else{
         [imageViewTwo setHidden:YES];
    }
    
    imageView.image = thumbnail;
    
    return cell;
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    screenHeight = screenRect.size.height;

    
    if (screenHeight==736.000000)
        
    {
        
        
        return CGSizeMake(136.66, 136.66);
        
        
    }
    
    else if (screenHeight==667.000000)
        
    {
        
        return CGSizeMake(123.66, 123.66);
        
        
        
    }
    
    else if(screenHeight==568.000000)
        
    {
        
        return CGSizeMake(105.33, 105.33);
        
        
    }
    
    
    return CGSizeMake(105.33, 105.33);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedCell = [self.myCollectionView indexPathsForSelectedItems][0];
   
    
    if ([[[_assets objectAtIndex:indexPath.row] valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
    
  
            
            [_galleryView setHidden:YES];
            [_detailCollectionView setHidden:YES];
            
            [_capturedView setHidden:NO];
    
    
    ALAssetRepresentation *rep = [[_assets objectAtIndex:indexPath.row] defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage] ;
    if (iref) {
        _capturedImageView.image = [UIImage imageWithCGImage:iref scale:[rep scale]
                                                 orientation:UIImageOrientationUp];
        _firstImageView.image = [UIImage imageWithCGImage:iref scale:[rep scale]
                                              orientation:UIImageOrientationUp];
    }
    
    }
    
    else{
    NSLog(@"videoooo");
 
     AVURLAsset *assetUrl = [[AVURLAsset alloc] initWithURL:[[_assets objectAtIndex:indexPath.row] valueForProperty:ALAssetPropertyAssetURL] options:nil];
            NSTimeInterval  durationInSeconds = CMTimeGetSeconds(assetUrl.duration);
        
        
        NSLog(@"%f",durationInSeconds);
       
        if (durationInSeconds > 20) {
            [self showToast:@"Your file is too large !"];
        }
        
        else{
            
            
            [_progressView setHidden:YES];
            
            
            [_capturedView setHidden:NO];
            [_voicePlayerView setHidden:NO];
            [_recordView setHidden:YES];
            [_extraView setHidden:YES];
            [_videoView setHidden:NO];
            
            
        ALAssetRepresentation *rep = [[_assets objectAtIndex:indexPath.row] defaultRepresentation];
        Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
        NSData *dataVal = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:NO];
        
        
  //  NSData * dataVal = [NSData dataWithContentsOfURL:[[_assets objectAtIndex:indexPath.row] valueForProperty:ALAssetPropertyAssetURL]];
    
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savedVideo"];
    [[NSUserDefaults standardUserDefaults]setObject:dataVal  forKey:@"savedVideo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
    MPMoviePlayerController *controller = [[MPMoviePlayerController alloc]
                                           initWithContentURL:[[_assets objectAtIndex:indexPath.row] valueForProperty:ALAssetPropertyAssetURL]];
    
    self.mc = controller; //Super important
    [controller prepareToPlay];
    controller.repeatMode = YES;
    [controller setControlStyle:MPMovieControlStyleNone];
    controller.view.userInteractionEnabled =YES;
    controller.scalingMode = MPMovieScalingModeAspectFit;
    [self.videoView addSubview:controller.view]; //Show the view
    controller.view.frame = self.videoView.bounds; //Set the size
    
    [controller play]; //Start playing
    
    }
        
        
    }
    NSLog(@"didselect %ld",(long)selectedCell.row);
}


- (IBAction)finalViewPostButton:(id)sender {
    
    [self callProfileView:@"image"];
    
}

- (IBAction)finalViewBackButton:(id)sender {
      _finalViewImage.image = nil;
     [_finalView setHidden:YES];
    
  
}

- (IBAction)finalViewCancelButton:(id)sender {
      _finalViewImage.image = nil;
     [_finalView setHidden:YES];
  
}
- (IBAction)funSlider:(id)sender {
    
    if (_funSlider.value > 15 && _funSlider.value < 60) {
        _funSlider.value = 50;
        
        moodString = @"Serious";
        
        
        //    [_cameraFunButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //    [_cameraSeriousButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
        //    [_cameraGeneralButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.cameraFunLabel.textColor = [UIColor whiteColor];
        self.cameraSeriousLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
        self.cameraGeneralLabel.textColor = [UIColor whiteColor];
        

        
        
    }
   else if (_funSlider.value > 60 && _funSlider.value < 100) {
        _funSlider.value = 100;
       
       
       moodString = @"General";
       
       
       //    [_cameraFunButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
       //    [_cameraSeriousButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
       //    [_cameraGeneralButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
       
       self.cameraFunLabel.textColor = [UIColor whiteColor];
       self.cameraSeriousLabel.textColor = [UIColor whiteColor];
       self.cameraGeneralLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
       
       
       

    }
    
   else if(_funSlider.value <40){
       
       _funSlider.value = 0;
       
       
       moodString = @"Fun";
       
       
       //    [_cameraFunButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
       //    [_cameraSeriousButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
       //    [_cameraGeneralButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
       
       self.cameraFunLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
       self.cameraSeriousLabel.textColor = [UIColor whiteColor];
       self.cameraGeneralLabel.textColor = [UIColor whiteColor];
   }
    
}

- (IBAction)cameraViewBackButton:(id)sender {
    
    [_galleryView setHidden:NO];
    [_detailCollectionView setHidden:YES];
    
}
- (IBAction)privateSlider:(id)sender {
    
    
    
    if (_privateSlider.value > 15 && _privateSlider.value < 60) {
        _privateSlider.value = 50;
        
        privateCategory = @"Country";
        
        
        //    [_cameraPrivateButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //    [_cameraQatarButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
        //    [_cameraGlobalButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.cameraPrivateLabel.textColor = [UIColor whiteColor];
        self.cameraQatarLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
        self.cameraGlobalLabel.textColor = [UIColor whiteColor];
    }
    else if (_privateSlider.value > 60 && _privateSlider.value < 100) {
        _privateSlider.value = 100;
        
        privateCategory = @"Global";
        //
        //    [_cameraPrivateButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //    [_cameraQatarButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //    [_cameraGlobalButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
        
        self.cameraPrivateLabel.textColor = [UIColor whiteColor];
        self.cameraQatarLabel.textColor = [UIColor whiteColor];
        self.cameraGlobalLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
        

    }
    
    else if(_privateSlider.value <40){
        
        _privateSlider.value = 0;
        
        
        privateCategory = @"Private";
        
        //    [_cameraPrivateButton setImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
        //    [_cameraQatarButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //    [_cameraGlobalButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.cameraPrivateLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
        self.cameraQatarLabel.textColor = [UIColor whiteColor];
        self.cameraGlobalLabel.textColor = [UIColor whiteColor];
        

    }
}
- (IBAction)checkInCloseButton:(id)sender {
    
    [_checkInView setHidden:YES];
    places = [[NSMutableArray alloc]init];
    searchPlaces = [[NSMutableArray alloc]init];
    didSelectPlaces = [[NSMutableArray alloc]init];
    [_checkInTableView reloadData];
}
- (IBAction)hashTagsButton:(id)sender {
    
     [_hashTagsView setHidden:NO];
    
    _hashTagsTextView.text = @"";
    
    
}


- (IBAction)locationButton:(id)sender {
    myTimer = [NSTimer scheduledTimerWithTimeInterval: 0.2 target: self
                                             selector: @selector(callAfterTwoSecond:) userInfo: nil repeats: YES];

    [_checkInView setHidden:NO];
    
    
    places = [[NSMutableArray alloc]init];
    searchPlaces = [[NSMutableArray alloc]init];
    didSelectPlaces = [[NSMutableArray alloc]init];
    

    
    locationManagerMap = [[CLLocationManager alloc] init];
    locationManagerMap.delegate = self;
    locationManagerMap.desiredAccuracy = kCLLocationAccuracyBest;
    locationManagerMap.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER)
    {
        [locationManagerMap requestAlwaysAuthorization];
        //   [locationManagerMap requestWhenInUseAuthorization];
        
    }
    
    [locationManagerMap startUpdatingLocation];
    //[_locationManeger stopUpdatingLocation];
    mapCurrentPlace = [locationManagerMap location];
    didSelectPlaces = [[NSMutableArray alloc]init];
    
    geocoder = [[CLGeocoder alloc] init];
    

   
    
  
    
    screenHeight = screenRect.size.height;
    
    
    
    if(screenHeight==568.000000)
    {
        
        UIView * testVal = [self.view viewWithTag:100];
        CGRect  T_height;
        T_height=testVal.frame;
        
        T_height.origin.y = 50;
        
        testVal.frame=T_height;
        
        CGRect tableHeight;
        tableHeight = _checkInTableView.frame;
        
        tableHeight.origin.y = 90;
        
        _checkInTableView.frame = tableHeight;
        
    }
    else if (screenHeight == 480){
        
        
        UIView * testVal = [self.view viewWithTag:100];
        CGRect  T_height;
        T_height=testVal.frame;
        
        T_height.origin.y = 50;
        
        testVal.frame=T_height;
        
        CGRect tableHeight;
        tableHeight = _checkInTableView.frame;
        
        tableHeight.origin.y = 90;
        
        _checkInTableView.frame = tableHeight;
        
        
        
    }
    
    
    
    
}



-(void) callWebservice
{
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
                newView = [[UIView alloc]init];
                newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                [self.view addSubview:newView];
        
                [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                
        
        
        
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@&radius=200&types=Cairport&Caquarium&Cart_gallery&Cbar&Cbeauty_salon&Cbicycle_store&Cbook_store&Cbowling_alley&Cbus_station&Ccafe&Ccampground&Ccar_dealer&Ccar_rental&Ccar_repair&Ccar_wash&Ccasino&Cchurch&Ccity_hall&Cclothing_store&Cconvenience_store&Cdepartment_store&Cdoctor&Celectrician&Celectronics_store&Cembassy&Cflorist&Cfood&Cfurniture_store&Cgas_station&Cgeneral_contractor&Cgrocery_or_supermarket&Cgym&Chair_care&Chardware_store&Chealth&Chindu_temple&Chome_goods_store&Chospital&Cjewelry_store&Clibrary&Cliquor_store&Clocksmith&Clodging&Cmeal_delivery&Cmosque&Cmovie_rental&Cmovie_theater&Cmuseum&Cnight_club&Cpark&Cparking&Cplace_of_worship&Cpolice&Cpost_office&Crestaurant&Crv_park&Cshoe_store&Cshopping_mall&Cspa&Cstadium&Cstore&Csubway_station&Ctaxi_stand&Ctrain_station&Ctravel_agency&Cuniversity&Czoo&rankBy=null&key=AIzaSyDC14veVa3LW5O5sNsgU7WYF3nLxyemJLM&sensor=true",latLong];
        
        
        //Formulate the string as URL object.
        NSURL *googleRequestURL=[NSURL URLWithString:url];
        
        
        // Retrieve the results of the URL.
        dispatch_async(kBgQueue, ^{
            NSData * dataResult = [NSData dataWithContentsOfURL: googleRequestURL];
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:dataResult waitUntilDone:YES];
        });
 
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

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    // [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    // [RKiOS7Loading hideHUDForView:self.view animated:YES];
    // [RKiOS7Loading hideHUDForView:self.view animated:YES];
    
    if ([[json objectForKey:@"results"] count] == 0 || [[json objectForKey:@"results"] isEqual:nil]) {
        //  [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        // [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Details Available"
        //                                                        message:@"Please try again!"
        //                                                       delegate:nil
        //                                              cancelButtonTitle:@"OK"
        //                                              otherButtonTitles:nil];
        //        [alert show];
        //
        
        
                                [GMDCircleLoader hideFromView:newView animated:YES];
                                [newView removeFromSuperview];

    }
    
    else{
        
                                [GMDCircleLoader hideFromView:newView animated:YES];
                                [newView removeFromSuperview];

        places = [[NSMutableArray alloc]init];
        searchPlaces = [[NSMutableArray alloc]init];
        
        places = [json objectForKey:@"results"];
      //  [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        [_checkInTableView reloadData];
        
        // [RKiOS7Loading hideHUDForView:self.view animated:YES];
    }
    
    
  //  [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
    
    
    
}


-(void) callWebserviceSearch
{
   
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        
        //        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%@&radius=100000&sensor=true&query=%@&key=AIzaSyDC14veVa3LW5O5sNsgU7WYF3nLxyemJLM",latLong,_searchTextField.text];
        
        NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&location=%@&radius=200&key=AIzaSyDC14veVa3LW5O5sNsgU7WYF3nLxyemJLM&sensor=true",_searchTextField.text,latLong];
        
        NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
        
        //Formulate the string as URL object.
        NSURL *googleRequestURL=[NSURL URLWithString:encodedUrl];
        
        
        // Retrieve the results of the URL.
        dispatch_async(kBgQueue, ^{
            NSData * dataResult = [NSData dataWithContentsOfURL: googleRequestURL];
            [self performSelectorOnMainThread:@selector(fetchedDataSearch:) withObject:dataResult waitUntilDone:YES];
        });
        
        
        
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

- (void)fetchedDataSearch:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    // [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    // [RKiOS7Loading hideHUDForView:self.view animated:YES];
    // [RKiOS7Loading hideHUDForView:self.view animated:YES];
    
    if ([[json objectForKey:@"predictions"] count] == 0 || [[json objectForKey:@"predictions"] isEqual:nil]) {
        //  [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        // [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Details Available"
        //                                                        message:@"Please try again!"
        //                                                       delegate:nil
        //                                              cancelButtonTitle:@"OK"
        //                                              otherButtonTitles:nil];
        //        [alert show];
        
    }
    
    else{
        
        
        places = [[NSMutableArray alloc]init];
        searchPlaces = [[NSMutableArray alloc]init];
        
        searchPlaces = [json objectForKey:@"predictions"];
     //   [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        [_checkInTableView reloadData];
        
        // [RKiOS7Loading hideHUDForView:self.view animated:YES];
    }
    
    
   // [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
    
    
    
}




- (void)fetchedDataSearchDidSelect:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    // [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    // [RKiOS7Loading hideHUDForView:self.view animated:YES];
    // [RKiOS7Loading hideHUDForView:self.view animated:YES];
    
    if ([[json objectForKey:@"results"] count] == 0 || [[json objectForKey:@"results"] isEqual:nil]) {
        //  [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        // [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Details Available"
        //                                                        message:@"Please try again!"
        //                                                       delegate:nil
        //                                              cancelButtonTitle:@"OK"
        //                                              otherButtonTitles:nil];
        //        [alert show];
        
    }
    
    else{
        
        
        places = [[NSMutableArray alloc]init];
        searchPlaces = [[NSMutableArray alloc]init];
        didSelectPlaces = [[NSMutableArray alloc]init];
        
        didSelectPlaces = [json objectForKey:@"results"];
       // [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        
        
        if (didSelectPlaces.count >0) {
            [self didSelectedValue];
        }
        
        
        // [RKiOS7Loading hideHUDForView:self.view animated:YES];
    }
    
    
  //  [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
    
    
    
}


-(void)didSelectedValue{
    
    
 
    
    NSString * locationCity = [NSString stringWithFormat:@"%@,%@",[[[[didSelectPlaces valueForKey:@"geometry"]objectAtIndex:0] valueForKey:@"location"]valueForKey:@"lat"],[[[[didSelectPlaces valueForKey:@"geometry"]objectAtIndex:0] valueForKey:@"location"]valueForKey:@"lng"]];
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@&sensor=false",locationCity];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    
    NSData *dataa = [locationString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonn = [NSJSONSerialization JSONObjectWithData:dataa options:0 error:nil];
    
    NSDictionary *dic = [[jsonn objectForKey:@"results"] objectAtIndex:0];
    NSArray* arr = [dic objectForKey:@"address_components"];
    //Iterate each result of address components - find locality and country
    NSString *cityName;
    NSString *countryName;
    for (NSDictionary* d in arr)
    {
        NSArray* typesArr = [d objectForKey:@"types"];
        NSString* firstType = [typesArr objectAtIndex:0];
        if([firstType isEqualToString:@"locality"])
            cityName = [d objectForKey:@"long_name"];
        if([firstType isEqualToString:@"country"])
            countryName = [d objectForKey:@"long_name"];
        
    }
    
    NSString* locationFinalll = [NSString stringWithFormat:@"%@,%@",cityName,countryName];
    
    _locationText.text = [[didSelectPlaces valueForKey:@"name"] objectAtIndex:0];
    
    _locationAudioVideoText.text =[[didSelectPlaces valueForKey:@"name"] objectAtIndex:0];
    
    
    [_checkInView setHidden:YES];
    
 
    
    
    NSString*latId =[NSString stringWithFormat:@"%@",[[[[didSelectPlaces valueForKey:@"geometry"]objectAtIndex:0] valueForKey:@"location"]valueForKey:@"lat"]];
    
    NSString*longId =[NSString stringWithFormat:@"%@",[[[[didSelectPlaces valueForKey:@"geometry"]objectAtIndex:0] valueForKey:@"location"]valueForKey:@"lng"]];
    
    finalLat = latId;
    finalLong = longId;
    

    
//    UIStoryboard * signUpBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    checkInCategoryViewController *  CountryScrolling = [signUpBoard instantiateViewControllerWithIdentifier:@"checkInCategoryViewController"];
//    
//    CountryScrolling.checkInAddress = [NSString stringWithFormat:@" - %@",[[didSelectPlaces objectAtIndex:0] valueForKey:@"name"]] ;
    
    _searchTextField.text = @"";
    [_searchTextField resignFirstResponder];
    
  //  [self.navigationController pushViewController: CountryScrolling animated:YES];
    
    
    
}




#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    mapCurrentPlace= newLocation;
    
    if (mapCurrentPlace != nil) {
        currentlongitude = [NSString stringWithFormat:@"%.8f", mapCurrentPlace.coordinate.longitude];
        currentlatitude = [NSString stringWithFormat:@"%.8f", mapCurrentPlace.coordinate.latitude];
        
          }
    
    [self reverseGeocode:mapCurrentPlace];
}


- (void)reverseGeocode:(CLLocation *)location {
    
    
    
    
    // tell the geocoder to reverse geocode the user's location
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        // if there was an error
        if (error) {
            // handle error here...
            return;
        }
        
        // get the first "placemark" object from the result array
        CLPlacemark *firstPlacemark = [placemarks firstObject];
        
        // get the address dictionary from the placemark object
        NSDictionary *addressDictionary = firstPlacemark.addressDictionary;
        
        // break the dictionary into components for display if you'd like
        //   NSString *street = addressDictionary[@"Street"];
        NSString *city = addressDictionary[@"City"];
        NSString *state = addressDictionary[@"State"];
        NSString*country = addressDictionary[@"Country"];
        
        //  NSString *zip = addressDictionary[@"Zip"];
        str = [NSString stringWithFormat:@"%@,%@",city,state];
        
        
        
        
        // Store the data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:city forKey:@"currentLocation"];
        [defaults synchronize];
        
        
        
        NSUserDefaults * cityPref = [NSUserDefaults standardUserDefaults];
        [cityPref setObject:city forKey:@"cityName"];
        [cityPref synchronize];
        
        NSUserDefaults * countryPref = [NSUserDefaults standardUserDefaults];
        [countryPref setObject:country forKey:@"countryName"];
        [countryPref synchronize];
        
        
        
        
     //   [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:0];
        
        [locationManagerMap stopUpdatingLocation];
        
        
        
        
        
    }];
    
    
}



-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    center.latitude=latitude;
    center.longitude = longitude;
    
    
    
    
    
    latLong = [NSString stringWithFormat:@"%f,%f",center.latitude,center.longitude];
    
    [self callWebservice];
    
    [_searchTextField resignFirstResponder];
    
  
    return center;
    
}



- (IBAction)heyMoodButton:(id)sender {
    
    [_galleryView setHidden:YES];
    [_detailCollectionView setHidden:YES];
    

    NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] allObjects] valueForKey:@"ImageIdf"] objectAtIndex:0],[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] allObjects] valueForKey:@"FolderPath"] objectAtIndex:0]];
    
    
    
   [_heyMoodPic  sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
    _heyMoodTextView.text = @"";
      _finalViewImage.image = nil;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"savedVideo"];
    whichMedia = @"heymood";
    [_cameraLabel setHidden:YES];
    [_galleryLabel setHidden:YES];
    [_voiceLabel setHidden:YES];
    [_heyMoodLabel setHidden:NO];
    [_recordView setHidden:YES];
    _firstImageView.image = nil;
    
    // Voice Recorder
    
    _capturedImageView.image = nil;
    
    
    
      [_capturedView setHidden:NO];
    [_heyMoodView setHidden:NO];
    [_finalViewWithGestures setHidden:YES];
    [_imageViewTypeYourQuestion setHidden:YES];
    
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (screenWidth == 320) {
         return textView.text.length + (text.length - range.length) <= 150;
    }
    
    else{
         return textView.text.length + (text.length - range.length) <= 150;
    }
    return 0;
}


- (IBAction)postHashTags:(id)sender {
    
    
    
    if ([_hashTagsTextView.text length] == 0) {
        [self showToast:@"Please enter your #Tags"];
    }
    
    else{
         [_hashTagsView setHidden:YES];
        
        
        hashTagsArray = @"";
        
        
        NSString *newStr = [_hashTagsTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        NSString *finalStr = [newStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        
        
        NSString *valHash = [finalStr stringByReplacingOccurrencesOfString:@"#" withString:@","];
        
        if ([valHash hasPrefix:@","] && [valHash length] > 1) {
            valHash = [valHash substringFromIndex:1];
        }

        hashTagsArray = valHash;

        
    }
    
}

- (IBAction)hashTagsCloseButton:(id)sender {
    
     [_hashTagsView setHidden:YES];
}
- (IBAction)galleryDetailPageBackButton:(id)sender {
    
    [_galleryView setHidden:NO];
    [_detailCollectionView setHidden:YES];
    
}
- (IBAction)camerViewOpenButton:(id)sender {

    
    [_galleryView setHidden:YES];
    [_detailCollectionView setHidden:YES];
    
}
@end

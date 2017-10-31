//
//  ViewController.m
//  kxmovieapp
//
//  Created by Kolyvan on 11.10.12.
//  Copyright (c) 2012 Konstantin Boukreev . All rights reserved.
//
//  https://github.com/kolyvan/kxmovie
//  this file is part of KxMovie
//  KxMovie is licenced under the LGPL v3, see lgpl-3.0.txt

#import "KxMovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "KxMovieDecoder.h"
#import "KxAudioManager.h"
#import "KxMovieGLView.h"
#import "KxLogger.h"

#import "ZRTSpecialCell.h"
#import "LGAlertView.h"
#import "ZRTGradeView.h"
#import "ZRTCommentController.h"
#import "ZRTGradeSuccess.h"
#import "ZRTVideoModel.h"
#import "AFNetworking.h"

#import "ZRTCaseCommentNumberTableViewCell.h"
#import "ZRTConsultationDetailCommentTableViewCell.h"
#import "Interface.h"

NSString * const KxMovieParameterMinBufferedDuration = @"KxMovieParameterMinBufferedDuration";
NSString * const KxMovieParameterMaxBufferedDuration = @"KxMovieParameterMaxBufferedDuration";
NSString * const KxMovieParameterDisableDeinterlacing = @"KxMovieParameterDisableDeinterlacing";

////////////////////////////////////////////////////////////////////////////////

static NSString * formatTimeInterval(CGFloat seconds, BOOL isLeft)
{
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;

    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%ld:%0.2ld", (long)h, (long)m];
    else        [format appendFormat:@"%ld", (long)m];
    [format appendFormat:@":%0.2ld", (long)s];

    return format;
}

////////////////////////////////////////////////////////////////////////////////

enum {

    KxMovieInfoSectionGeneral,
    KxMovieInfoSectionVideo,
    KxMovieInfoSectionAudio,
    KxMovieInfoSectionSubtitles,
    KxMovieInfoSectionMetadata,    
    KxMovieInfoSectionCount,
};

enum {

    KxMovieInfoGeneralFormat,
    KxMovieInfoGeneralBitrate,
    KxMovieInfoGeneralCount,
};

////////////////////////////////////////////////////////////////////////////////

static NSMutableDictionary * gHistory;

#define LOCAL_MIN_BUFFERED_DURATION   0.2
#define LOCAL_MAX_BUFFERED_DURATION   0.4
#define NETWORK_MIN_BUFFERED_DURATION 2.0
#define NETWORK_MAX_BUFFERED_DURATION 4.0

@interface KxMovieViewController () <ZRTGradeViewDelegate,ZRTCommentControllerDelegate>
{

    KxMovieDecoder      *_decoder;
    dispatch_queue_t    _dispatchQueue;
    NSMutableArray      *_videoFrames;
    NSMutableArray      *_audioFrames;
    NSMutableArray      *_subtitles;
    NSData              *_currentAudioFrame;
    NSUInteger          _currentAudioFramePos;
    CGFloat             _moviePosition;
    BOOL                _disableUpdateHUD;
    NSTimeInterval      _tickCorrectionTime;
    NSTimeInterval      _tickCorrectionPosition;
    NSUInteger          _tickCounter;
    BOOL                _fullscreen;
    BOOL                _hiddenHUD;
    BOOL                _fitMode;
    BOOL                _infoMode;
    BOOL                _restoreIdleTimer;
    BOOL                _interrupted;

    KxMovieGLView       *_glView;
    UIImageView         *_imageView;
    UIView              *_topHUD;
    UIToolbar           *_topBar;
    UIToolbar           *_bottomBar;
    UISlider            *_progressSlider;

//    UIBarButtonItem     *_playBtn;
//    UIBarButtonItem     *_pauseBtn;
    
    UIButton            *_playBtn;
    UIButton            *_pauseBtn;
    UIBarButtonItem     *_rewindBtn;
    UIBarButtonItem     *_fforwardBtn;
    UIBarButtonItem     *_spaceItem;
    UIBarButtonItem     *_fixedSpaceItem;

    UIButton            *_doneButton;
    UILabel             *_progressLabel;
    UILabel             *_leftLabel;
    UIButton            *_infoButton;
    
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel             *_subtitlesLabel;
    
    UITapGestureRecognizer *_tapGestureRecognizer;
    UITapGestureRecognizer *_doubleTapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
        
#ifdef DEBUG
    UILabel             *_messageLabel;
    NSTimeInterval      _debugStartTime;
    NSUInteger          _debugAudioStatus;
    NSDate              *_debugAudioStatusTS;
#endif

    CGFloat             _bufferedDuration;
    CGFloat             _minBufferedDuration;
    CGFloat             _maxBufferedDuration;
    BOOL                _buffered;
    
    BOOL                _savedIdleTimer;
    
    NSDictionary        *_parameters;
    
    UIView              *_coverView;
    
    UIButton            *_playPauseBtn;
    
    UIView              *_bottomHUD;
    
    UIButton            *_fullScreenButton;
    
}

@property (readwrite) BOOL playing;
@property (readwrite) BOOL decoding;
@property (readwrite, strong) KxArtworkFrame *artworkFrame;

@property (nonatomic, assign) CGRect originFrame;


// 数据源
@property (nonatomic,strong) NSMutableArray *dataSource1;
@property (nonatomic,strong) NSMutableArray *dataSource2;
@property (nonatomic,strong) NSMutableArray *dataSource3;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UITableView *tableView2;
@property (nonatomic, weak) UITableView *tableView3;

@property (nonatomic,assign) CGFloat font;

@property (nonatomic,strong) UIView *BtnView;
@property (nonatomic,strong) UIButton *detailBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *specialBtn;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *detailView;  // 详情

@property (nonatomic,strong) UIBarButtonItem *gradeItem;
@property (nonatomic,strong) UIBarButtonItem *collectItem;

@property (nonatomic,strong) UIToolbar *toolbar;

@property (nonatomic,strong) UIView *tempView;

@property (nonatomic,assign) CGRect tempFrame;

@property (nonatomic,weak) ZRTGradeSuccess *success;

@property (nonatomic,assign) CGFloat fen;

@property (nonatomic,strong) NSArray *specailArray;

@property (nonatomic,strong) UIImageView *starImageView; // 显示评分星

@property (nonatomic,strong) UIImageView *image;

@property (nonatomic,assign) CGFloat imageW;

@property (nonatomic,assign) BOOL isSendGrade;

@end

@implementation KxMovieViewController




+ (void)initialize
{
    if (!gHistory)
        gHistory = [NSMutableDictionary dictionary];
}

- (BOOL)prefersStatusBarHidden { return YES; }

+ (id) movieViewControllerWithContentPath: (NSString *) path
                               parameters: (NSDictionary *) parameters
{    
    id<KxAudioManager> audioManager = [KxAudioManager audioManager];
    [audioManager activateAudioSession];    
    return [[KxMovieViewController alloc] initWithContentPath: path parameters: parameters];
}

- (id) initWithContentPath: (NSString *) path
                parameters: (NSDictionary *) parameters
{
    NSAssert(path.length > 0, @"empty path");
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        _moviePosition = 0;
//        self.wantsFullScreenLayout = YES;

        _parameters = parameters;
        
        __weak KxMovieViewController *weakSelf = self;
        
        KxMovieDecoder *decoder = [[KxMovieDecoder alloc] init];
        
        decoder.interruptCallback = ^BOOL(){
            
            __strong KxMovieViewController *strongSelf = weakSelf;
            return strongSelf ? [strongSelf interruptDecoder] : YES;
        };
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
            NSError *error = nil;
            [decoder openFile:path error:&error];
                        
            __strong KxMovieViewController *strongSelf = weakSelf;
            if (strongSelf) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [strongSelf setMovieDecoder:decoder withError:error];                    
                });
            }
        });
    }
    return self;
}

- (void) dealloc
{
    [self pause];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_dispatchQueue) {
        // Not needed as of ARC.
//        dispatch_release(_dispatchQueue);
        _dispatchQueue = NULL;
    }
    
    LoggerStream(1, @"%@ dealloc", self);
}


#pragma mark 加载view

- (void)loadView
{
    // LoggerStream(1, @"loadView");
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];

    CGFloat MovieW = bounds.size.width;
    CGFloat MovieH = MovieW/4*3;
//
//    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MovieW, MovieH)];
    self.view = [[UIView alloc] initWithFrame:bounds];
    self.view.backgroundColor = [UIColor whiteColor];
  //  self.view.tintColor = [UIColor whiteColor];
    
    
    
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MovieW, MovieH)];
    
    _coverView.backgroundColor = [UIColor blackColor];
    
    [self setUpToolsWithView:_coverView];
    
    [self.view addSubview:_coverView];
    
 
    
    [self setUpContentView];
    
    

    if (_decoder) {
        
        [self setupPresentView];
        
        
        
    } else {
        
        _progressLabel.hidden = YES;
        _progressSlider.hidden = YES;
        _leftLabel.hidden = YES;
        _infoButton.hidden = YES;
    }
  
    
    
}


#pragma mark 设置工具栏


-(void)setUpToolsWithView:(UIView *)view
{

    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.center = view.center;
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    
    
    [view addSubview:_activityIndicatorView];
    
    CGFloat width = bounds.size.width;
  //  CGFloat height = bounds.size.height;
    
    
    CGFloat MovieW = bounds.size.width;
    CGFloat MovieH = MovieW/4*3;
    
    
#ifdef DEBUG
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,40,width-40,40)];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = [UIColor redColor];
    _messageLabel.hidden = YES;
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.numberOfLines = 2;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [view addSubview:_messageLabel];
#endif
    
    CGFloat topH = 40;
    CGFloat botH = 40;
    
    _topHUD    = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    _topBar    = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 30, width, topH)];
    
    _topHUD.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
//    _topBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    _topBar.hidden = YES;
   
    
    _bottomHUD = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    _bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, MovieH-botH, width, botH)];
    
    _bottomHUD.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _bottomBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    _topHUD.frame = CGRectMake(0,30,width,_topBar.frame.size.height);
    _bottomHUD.frame = _bottomBar.frame;
    
    
    
    _topHUD.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bottomBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    
    
    
    [view addSubview:_topBar];
    [view addSubview:_topHUD];
    [view addSubview:_bottomBar];
    [view addSubview:_bottomHUD];
    
    // top hud
    
    [self addDoneButton];
    
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 1, 50, topH)];
    _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.opaque = NO;
    _progressLabel.adjustsFontSizeToFitWidth = NO;
    _progressLabel.textAlignment = NSTextAlignmentRight;
    _progressLabel.textColor = [UIColor whiteColor];
    //    _progressLabel.text = @"progress";
    _progressLabel.font = [UIFont systemFontOfSize:12];
    
//    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, 2, width-197, topH)];
//    _progressSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    _progressSlider.continuous = NO;
//    _progressSlider.value = 0;
    //    [_progressSlider setThumbImage:[UIImage imageNamed:@"kxmovie.bundle/sliderthumb"]
    //                          forState:UIControlStateNormal];
    
    
    _progressSlider = [[UISlider alloc] init];
    _progressSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_progressSlider setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
    [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_progressSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
    _progressSlider.value = 0.f;
    _progressSlider.continuous = NO;
   
   
    
    
    
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.backgroundColor = [UIColor clearColor];
    _leftLabel.opaque = NO;
    _leftLabel.adjustsFontSizeToFitWidth = NO;
    _leftLabel.textAlignment = NSTextAlignmentLeft;
    _leftLabel.textColor = [UIColor whiteColor];
    //    _leftLabel.text = @"leftLabel";
    _leftLabel.font = [UIFont systemFontOfSize:12];
    _leftLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    
#warning 右上角信息按钮，已隐藏
    //    _infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    //    _infoButton.frame = CGRectMake(width-31, (topH-20)/2+1, 20, 20);
    //    _infoButton.showsTouchWhenHighlighted = YES;
    //    _infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    //    [_infoButton addTarget:self action:@selector(infoDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [_topHUD addSubview:_doneButton];
  //  [_topHUD addSubview:_progressLabel];
   // [_topHUD addSubview:_progressSlider];
   // [_topHUD addSubview:_leftLabel];
    //   [_topHUD addSubview:_infoButton];


    
    
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    _playBtn.bounds = CGRectMake(0, 0, 40, 40);
    
    [_playBtn addTarget:self action:@selector(playDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    

    
    _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_pauseBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    
    _pauseBtn.bounds = CGRectMake(0, 0, 40, 40);

    [_pauseBtn addTarget:self action:@selector(playDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
 
    
//    _fforwardBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
//                                                                 target:self
//                                                                 action:@selector(forwardDidTouch:)];
    
    [self updateBottomBar];
    
    
    
    
    _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullScreenButton setImage:[UIImage imageNamed:@"fangda"] forState:UIControlStateNormal];
    _fullScreenButton.bounds = CGRectMake(0, 0, 40, 40);
    [_fullScreenButton addTarget:self action:@selector(didClickFullButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    [_bottomHUD addSubview:_fullScreenButton];
    [_bottomHUD addSubview:_progressSlider];
    [_bottomHUD addSubview:_leftLabel];
    [_bottomHUD addSubview:_progressLabel];
    
    
    
    _fullScreenButton.frame = CGRectMake(CGRectGetWidth(_bottomBar.bounds) - CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_bottomBar.bounds)/2 - CGRectGetHeight(_fullScreenButton.bounds)/2, CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_fullScreenButton.bounds));
    
    
    
    _progressSlider.frame = CGRectMake(CGRectGetMaxX(_playBtn.frame), CGRectGetHeight(_bottomBar.bounds)/2 - CGRectGetHeight(_progressSlider.bounds)/2, CGRectGetMinX(_fullScreenButton.frame) - CGRectGetMaxX(_playBtn.frame), CGRectGetHeight(_progressSlider.bounds));
    
    _leftLabel.frame = CGRectMake(_fullScreenButton.x-40, CGRectGetMaxY(_progressSlider.frame)-10, 40, 10);
    
    _progressLabel.frame = CGRectMake(_progressSlider.x, _leftLabel.y, 40, 10);
}









-(void)addDoneButton
{
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(0, 1, 40, 40);
 //   _doneButton.backgroundColor = [UIColor clearColor];
    //    _doneButton.backgroundColor = [UIColor redColor];
//    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_doneButton setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
    
    [_doneButton setImage:[UIImage imageNamed:@"back_Video"] forState:UIControlStateNormal];
    
  //  _doneButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _doneButton.showsTouchWhenHighlighted = YES;
    [_doneButton addTarget:self action:@selector(doneDidTouch:)
          forControlEvents:UIControlEventTouchUpInside];
    //    [_doneButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    
  //  NSLog(@"未旋转  %@",NSStringFromCGRect(_doneButton.frame));

    [_topHUD addSubview:_doneButton];

}


#pragma mark  内存泄露
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (self.playing) {
        
        [self pause];
        [self freeBufferedFrames];
        
        if (_maxBufferedDuration > 0) {
            
            _minBufferedDuration = _maxBufferedDuration = 0;
            
//            NSLog(@"应该不是这里，应该不是这里");
            
            [self play];
            
            LoggerStream(0, @"didReceiveMemoryWarning, disable buffering and continue playing");
            
        } else {
            
            // force ffmpeg to free allocated memory
            [_decoder closeFile];
            [_decoder openFile:nil error:nil];
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
                                        message:NSLocalizedString(@"内存不足", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"返回", nil)
                              otherButtonTitles:nil] show];
        }
        
    } else {
        
        [self freeBufferedFrames];
        [_decoder closeFile];
        [_decoder openFile:nil error:nil];
    }
}



- (void) viewDidAppear:(BOOL)animated
{
    // LoggerStream(1, @"viewDidAppear");
    
    [super viewDidAppear:animated];
    
    if (self.isReplay) {
        
        
    }else{
    
        [self getSpecial];
    
    }
    
    
    
   
//    CGRect bounds = self.view.bounds;
//    
//    CGFloat MovieW = bounds.size.width;
//    CGFloat MovieH = MovieW/4*3;
//
//    _glView = [[KxMovieGLView alloc] initWithFrame:CGRectMake(0, 0, MovieW, MovieH) decoder:_decoder];
//
    
//    NSLog(@" 老子到底是不是进来了");
   
        
    if (self.presentingViewController)
        
         //全屏
       // [self fullscreenMode:YES];
    
    [self fullscreenMode:NO];
    _fullscreen = NO;
    
    
    
//    if (_infoMode)
//        [self showInfoView:NO animated:NO];
//    
//    _savedIdleTimer = [[UIApplication sharedApplication] isIdleTimerDisabled];
//    
//    [self showHUD: YES];
    
//    NSLog(@" 所以是老子没进来咯");
    
    
//    NSLog(@"找的就是你 %@",_decoder);
    
    if (_decoder) {
        
        
//        NSLog(@" 所以是在这里开始的咯");

        [self restorePlay];
        
    } else {

        [_activityIndicatorView startAnimating];
    }
   
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
    
    
    [self ListeningRotating];
    
}









- (void) viewWillDisappear:(BOOL)animated
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
    
    [_activityIndicatorView stopAnimating];
    
    if (_decoder) {
        
        [self pause];
        
        if (_moviePosition == 0 || _decoder.isEOF)
            [gHistory removeObjectForKey:_decoder.path];
        else if (!_decoder.isNetwork)
            [gHistory setValue:[NSNumber numberWithFloat:_moviePosition]
                        forKey:_decoder.path];
    }
    
    if (_fullscreen)
        [self fullscreenMode:NO];
        
    [[UIApplication sharedApplication] setIdleTimerDisabled:_savedIdleTimer];
    
    [_activityIndicatorView stopAnimating];
    _buffered = NO;
    _interrupted = YES;
    
    LoggerStream(1, @"viewWillDisappear %@", self);
}

#pragma mark 屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) applicationWillResignActive: (NSNotification *)notification
{
    [self showHUD:YES];
    [self pause];
    
    LoggerStream(1, @"applicationWillResignActive");
}

#pragma mark - 手势

- (void) handleTap: (UITapGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (sender == _tapGestureRecognizer) {

            [self showHUD: _hiddenHUD];
            
        } else if (sender == _doubleTapGestureRecognizer) {
                
            UIView *frameView = [self frameView];
            
            if (frameView.contentMode == UIViewContentModeScaleAspectFit)
                frameView.contentMode = UIViewContentModeScaleAspectFill;
            else
                frameView.contentMode = UIViewContentModeScaleAspectFit;
            
        }        
    }
}

- (void) handlePan: (UIPanGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        const CGPoint vt = [sender velocityInView:self.view];
        const CGPoint pt = [sender translationInView:self.view];
        const CGFloat sp = MAX(0.1, log10(fabsf(vt.x)) - 1.0);
        const CGFloat sc = fabsf(pt.x) * 0.33 * sp;
        if (sc > 10) {
            
            const CGFloat ff = pt.x > 0 ? 1.0 : -1.0;
            [self setMoviePosition: _moviePosition + ff * MIN(sc, 600.0)];
        }
        //LoggerStream(2, @"pan %.2f %.2f %.2f sec", pt.x, vt.x, sc);
    }
}

#pragma mark - 播放暂停小方法


-(void) play
{
    if (self.playing){
        
//        NSLog(@"老子是1");
        
        [_activityIndicatorView stopAnimating];
        
        return;
    }
    
    
    if (!_decoder.validVideo &&
        !_decoder.validAudio) {
        
//        NSLog(@"老子是2");
        
        return;
    }
 
#warning 出现弹出评论回来后会无法播放的问题，故而屏蔽这里，具体原因不明
//    if (_interrupted){
//        
//         NSLog(@"老子是3");
//        
//        return;
//    }
    
    
//    NSLog(@"老子到底是多大 %@",NSStringFromCGRect(_glView.frame));
//    
//    NSLog(@"进入开始播放进入开始播放");
    
//    NSLog(@"应该有才对 %@",_decoder);
    
    
    [_activityIndicatorView stopAnimating];
    
    self.playing = YES;
    _interrupted = NO;
    _disableUpdateHUD = NO;
    _tickCorrectionTime = 0;
    _tickCounter = 0;

#ifdef DEBUG
    
//    NSLog(@" 出错了出错了");
    
    _debugStartTime = -1;
#endif

    [self asyncDecodeFrames];
    [self updatePlayButton];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self tick];
    });

    if (_decoder.validAudio)
        [self enableAudio:YES];

    LoggerStream(1, @"play movie");
}


- (void) pause
{
    if (!self.playing)
        return;

    self.playing = NO;
    //_interrupted = YES;
    [self enableAudio:NO];
    [self updatePlayButton];
    LoggerStream(1, @"pause movie");
}

 
 

- (void) setMoviePosition: (CGFloat) position
{
    BOOL playMode = self.playing;
    
    self.playing = NO;
    _disableUpdateHUD = YES;
    [self enableAudio:NO];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [self updatePosition:position playMode:playMode];
    });
}

#pragma mark - 点击事件

- (void) doneDidTouch: (id) sender
{
    
  //  NSLog(@"done");
    
    if ([self.delegate respondsToSelector:@selector(reloadDataAfterBack)]) {
        
        [self.delegate reloadDataAfterBack];
    }
    
    if (self.presentingViewController || !self.navigationController)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}


//- (void) infoDidTouch: (id) sender
//{
//    [self showInfoView: !_infoMode animated:YES];
//}

- (void) playDidTouch: (id) sender
{
    if (self.playing)
        [self pause];
    else
        [self play];
}

- (void) forwardDidTouch: (id) sender
{
    [self setMoviePosition: _moviePosition + 10];
}

- (void) rewindDidTouch: (id) sender
{
    [self setMoviePosition: _moviePosition - 10];
}

- (void) progressDidChange: (id) sender
{
    NSAssert(_decoder.duration != MAXFLOAT, @"bugcheck");
    UISlider *slider = sender;
    [self setMoviePosition:slider.value * _decoder.duration];
}



-(void)didClickFullButton
{

    if (_fullscreen) {
        
        
        [self backOrientationPortrait];
        
        
    }else{
    
        [self setDeviceOrientationLandscapeRight];
    
    
    }



}












#pragma mark - private

- (void) setMovieDecoder: (KxMovieDecoder *) decoder
               withError: (NSError *) error
{
    LoggerStream(2, @"setMovieDecoder");
            
    if (!error && decoder) {
        
        NSLog(@" 我知道你没来没来没来");
        
        _decoder        = decoder;
        _dispatchQueue  = dispatch_queue_create("KxMovie", DISPATCH_QUEUE_SERIAL);
        _videoFrames    = [NSMutableArray array];
        _audioFrames    = [NSMutableArray array];
        
        if (_decoder.subtitleStreamsCount) {
            _subtitles = [NSMutableArray array];
        }
    
        if (_decoder.isNetwork) {
            
            _minBufferedDuration = NETWORK_MIN_BUFFERED_DURATION;
            _maxBufferedDuration = NETWORK_MAX_BUFFERED_DURATION;
            
        } else {
            
            _minBufferedDuration = LOCAL_MIN_BUFFERED_DURATION;
            _maxBufferedDuration = LOCAL_MAX_BUFFERED_DURATION;
        }
        
        if (!_decoder.validVideo)
            _minBufferedDuration *= 10.0; // increase for audio
                
        // allow to tweak some parameters at runtime
        if (_parameters.count) {
            
            id val;
            
            val = [_parameters valueForKey: KxMovieParameterMinBufferedDuration];
            if ([val isKindOfClass:[NSNumber class]])
                _minBufferedDuration = [val floatValue];
            
            val = [_parameters valueForKey: KxMovieParameterMaxBufferedDuration];
            if ([val isKindOfClass:[NSNumber class]])
                _maxBufferedDuration = [val floatValue];
            
            val = [_parameters valueForKey: KxMovieParameterDisableDeinterlacing];
            if ([val isKindOfClass:[NSNumber class]])
                _decoder.disableDeinterlacing = [val boolValue];
            
            if (_maxBufferedDuration < _minBufferedDuration)
                _maxBufferedDuration = _minBufferedDuration * 2;
        }
        
        LoggerStream(2, @"buffered limit: %.1f - %.1f", _minBufferedDuration, _maxBufferedDuration);
        
        if (self.isViewLoaded) {
           
            
                
                [self setupPresentView];
                
            
            
            
            _progressLabel.hidden   = NO;
            _progressSlider.hidden  = NO;
            _leftLabel.hidden       = NO;
            _infoButton.hidden      = NO;
            
            NSLog(@" 错误的开始，错误的开始");
            
            NSLog(@"是TM的有多蛋疼 %@ ",_decoder);
            
          //  if (_activityIndicatorView.isAnimating) {
                
                
                
                
                [_activityIndicatorView stopAnimating];
               //if (self.view.window)

                
//                NSLog(@" 从这里开始从这里开始");
            
                [self restorePlay];
          //  }
        }
        
    } else {
        
         if (self.isViewLoaded && self.view.window) {
        
             [_activityIndicatorView stopAnimating];
             
             NSLog(@" 出错了？");
             
             if (!_interrupted){
                 
                 NSLog(@" 是这个出错了?");
                 [self handleDecoderMovieError: error];
                 
             }
         }
    }
}


#pragma mark 

- (void) restorePlay
{
    NSNumber *n = [gHistory valueForKey:_decoder.path];
    if (n){
        
        NSLog(@"是不是这里是不是这里");
        
        [self updatePosition:n.floatValue playMode:YES];
    }else{
        
        NSLog(@"是不是这里是不是这里 OK");
        
        [self play];
        
    }
}


#pragma mark 播放view的大小
- (void) setupPresentView
{
    CGRect bounds = self.view.bounds;
    
    CGFloat MovieW = bounds.size.width;
    CGFloat MovieH = MovieW/4*3;
    
    
    
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    
    
    if (_decoder.validVideo) {
        
//        if (_fullscreen) {
//            
//            CGFloat height = [[UIScreen mainScreen] bounds].size.width;
//            CGFloat width = [[UIScreen mainScreen] bounds].size.height;
//            
//            NSLog(@" 现在是全屏");
//            
//            if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//                
//                NSLog(@" 电池在右");
//                
//                NSLog(@"到底是多大  %@",NSStringFromCGRect(self.view.frame));
//                
//                _glView = [[KxMovieGLView alloc] initWithFrame:CGRectMake(0, 0, width, height) decoder:_decoder];
//                
//                [self setUpToolsWithView:_glView];
//                
//                NSLog(@"到底是多大2  %@",NSStringFromCGRect(_glView.frame));
//                
//                _bottomBar.frame = CGRectMake(0, height-40, width, 40);
//                _bottomHUD.frame = _bottomBar.frame;
//                
//                _fullScreenButton.frame = CGRectMake(CGRectGetWidth(_bottomBar.bounds) - CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_bottomBar.bounds)/2 - CGRectGetHeight(_fullScreenButton.bounds)/2, CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_fullScreenButton.bounds));
//                
//                _topBar.hidden = NO;
//                
//                _topHUD.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//                _topBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//                
//                [_doneButton setImage:[UIImage imageNamed:@"arrow_Video"] forState:UIControlStateNormal];
//                
//                
//                [self.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
//                _fullscreen = YES;
//
//                
//                
//            }else{
//                
//                NSLog(@" 电池在左");
//                
//               
//               
//                NSLog(@"到底是多大  %@",NSStringFromCGRect(self.view.frame));
//                
//                _glView = [[KxMovieGLView alloc] initWithFrame:CGRectMake(0, 0, width, height) decoder:_decoder];
//                
//                [self setUpToolsWithView:_glView];
//                
//                NSLog(@"到底是多大2  %@",NSStringFromCGRect(_glView.frame));
//                
//                _bottomBar.frame = CGRectMake(0, height-40, width, 40);
//                _bottomHUD.frame = _bottomBar.frame;
//                
//                _fullScreenButton.frame = CGRectMake(CGRectGetWidth(_bottomBar.bounds) - CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_bottomBar.bounds)/2 - CGRectGetHeight(_fullScreenButton.bounds)/2, CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_fullScreenButton.bounds));
//                
//                _topBar.hidden = NO;
//                
//                _topHUD.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//                _topBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//                
//                [_doneButton setImage:[UIImage imageNamed:@"arrow_Video"] forState:UIControlStateNormal];
//                
//                
//                [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
//                _fullscreen = YES;
//            
//
//                
//            }
//            
//            
//            
//            
//        }else{
        
        NSLog(@" 创建了没有");
        
        
        
            _glView = [[KxMovieGLView alloc] initWithFrame:CGRectMake(0, 0, MovieW, MovieH) decoder:_decoder];
            
            
            [self setUpToolsWithView:_glView];
        
//        }
        
        if (_coverView) {
            
            [_coverView removeFromSuperview];
            
        }
        
        
        
 
    }
    
    if (!_glView) {
        
        LoggerVideo(0, @"fallback to use RGB video frame and UIKit");
        [_decoder setupVideoFrameFormat:KxVideoFrameFormatRGB];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MovieW, MovieH)];
        _imageView.backgroundColor = [UIColor blackColor];
    }
    
    UIView *frameView = [self frameView];
    frameView.contentMode = UIViewContentModeScaleAspectFit;
    frameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view insertSubview:frameView atIndex:0];
    
    if (_decoder.validVideo) {
    
        [self setupUserInteraction];   // 交互
    
    } else {
       
        _imageView.image = [UIImage imageNamed:@"kxmovie.bundle/music_icon.png"];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    
   // self.view.backgroundColor = [UIColor clearColor]; 之前是这样，但是会出现闪一下的问题
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_decoder.duration == MAXFLOAT) {
        
        _leftLabel.text = @"\u221E"; // infinity
        _leftLabel.font = [UIFont systemFontOfSize:14];
        
        CGRect frame;
        
        frame = _leftLabel.frame;
        frame.origin.x += 40;
        frame.size.width -= 40;
        _leftLabel.frame = frame;
        
        frame =_progressSlider.frame;
        frame.size.width += 40;
        _progressSlider.frame = frame;
        
    } else {
        
        [_progressSlider addTarget:self
                            action:@selector(progressDidChange:)
                  forControlEvents:UIControlEventValueChanged];
    }
    
    if (_decoder.subtitleStreamsCount) {
        
        CGSize size = self.view.bounds.size;
        
        _subtitlesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height, size.width, 0)];
        _subtitlesLabel.numberOfLines = 0;
        _subtitlesLabel.backgroundColor = [UIColor clearColor];
        _subtitlesLabel.opaque = NO;
        _subtitlesLabel.adjustsFontSizeToFitWidth = NO;
        _subtitlesLabel.textAlignment = NSTextAlignmentCenter;
        _subtitlesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _subtitlesLabel.textColor = [UIColor whiteColor];
        _subtitlesLabel.font = [UIFont systemFontOfSize:16];
        _subtitlesLabel.hidden = YES;

        [self.view addSubview:_subtitlesLabel];
    }
}

- (void) setupUserInteraction
{
    UIView * view = [self frameView];
    view.userInteractionEnabled = YES;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    _tapGestureRecognizer.numberOfTapsRequired = 1;
    
//    _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    
  //  [_tapGestureRecognizer requireGestureRecognizerToFail: _doubleTapGestureRecognizer];
    
   // [view addGestureRecognizer:_doubleTapGestureRecognizer];
    [view addGestureRecognizer:_tapGestureRecognizer];
    
//    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    _panGestureRecognizer.enabled = NO;
//    
//    [view addGestureRecognizer:_panGestureRecognizer];
}

- (UIView *) frameView
{
    return _glView ? _glView : _imageView;
}

- (void) audioCallbackFillData: (float *) outData
                     numFrames: (UInt32) numFrames
                   numChannels: (UInt32) numChannels
{
    //fillSignalF(outData,numFrames,numChannels);
    //return;

    if (_buffered) {
        memset(outData, 0, numFrames * numChannels * sizeof(float));
        return;
    }

    @autoreleasepool {
        
        while (numFrames > 0) {
            
            if (!_currentAudioFrame) {
                
                @synchronized(_audioFrames) {
                    
                    NSUInteger count = _audioFrames.count;
                    
                    if (count > 0) {
                        
                        KxAudioFrame *frame = _audioFrames[0];

#ifdef DUMP_AUDIO_DATA
                        LoggerAudio(2, @"Audio frame position: %f", frame.position);
#endif
                        if (_decoder.validVideo) {
                        
                            const CGFloat delta = _moviePosition - frame.position;
                            
                            if (delta < -0.1) {
                                
                                memset(outData, 0, numFrames * numChannels * sizeof(float));
#ifdef DEBUG
                                LoggerStream(0, @"desync audio (outrun) wait %.4f %.4f", _moviePosition, frame.position);
                                _debugAudioStatus = 1;
                                _debugAudioStatusTS = [NSDate date];
#endif
                                break; // silence and exit
                            }
                            
                            [_audioFrames removeObjectAtIndex:0];
                            
                            if (delta > 0.1 && count > 1) {
                                
#ifdef DEBUG
                                LoggerStream(0, @"desync audio (lags) skip %.4f %.4f", _moviePosition, frame.position);
                                _debugAudioStatus = 2;
                                _debugAudioStatusTS = [NSDate date];
#endif
                                continue;
                            }
                            
                        } else {
                            
                            [_audioFrames removeObjectAtIndex:0];
                            _moviePosition = frame.position;
                            _bufferedDuration -= frame.duration;
                        }
                        
                        _currentAudioFramePos = 0;
                        _currentAudioFrame = frame.samples;                        
                    }
                }
            }
            
            if (_currentAudioFrame) {
                
                const void *bytes = (Byte *)_currentAudioFrame.bytes + _currentAudioFramePos;
                const NSUInteger bytesLeft = (_currentAudioFrame.length - _currentAudioFramePos);
                const NSUInteger frameSizeOf = numChannels * sizeof(float);
                const NSUInteger bytesToCopy = MIN(numFrames * frameSizeOf, bytesLeft);
                const NSUInteger framesToCopy = bytesToCopy / frameSizeOf;
                
                memcpy(outData, bytes, bytesToCopy);
                numFrames -= framesToCopy;
                outData += framesToCopy * numChannels;
                
                if (bytesToCopy < bytesLeft)
                    _currentAudioFramePos += bytesToCopy;
                else
                    _currentAudioFrame = nil;                
                
            } else {
                
                memset(outData, 0, numFrames * numChannels * sizeof(float));
                //LoggerStream(1, @"silence audio");
#ifdef DEBUG
                _debugAudioStatus = 3;
                _debugAudioStatusTS = [NSDate date];
#endif
                break;
            }
        }
    }
}

- (void) enableAudio: (BOOL) on
{
    id<KxAudioManager> audioManager = [KxAudioManager audioManager];
            
    if (on && _decoder.validAudio) {
                
        audioManager.outputBlock = ^(float *outData, UInt32 numFrames, UInt32 numChannels) {
            
            [self audioCallbackFillData: outData numFrames:numFrames numChannels:numChannels];
        };
        
        
        
        
//        NSLog(@"是不是这里是不是这里2.0");
        
        [audioManager play];
        
        LoggerAudio(2, @"audio device smr: %d fmt: %d chn: %d",
                    (int)audioManager.samplingRate,
                    (int)audioManager.numBytesPerSample,
                    (int)audioManager.numOutputChannels);
        
    } else {
        
        [audioManager pause];
        audioManager.outputBlock = nil;
    }
}

- (BOOL) addFrames: (NSArray *)frames
{
    if (_decoder.validVideo) {
        
        @synchronized(_videoFrames) {
            
            for (KxMovieFrame *frame in frames)
                if (frame.type == KxMovieFrameTypeVideo) {
                    [_videoFrames addObject:frame];
                    _bufferedDuration += frame.duration;
                }
        }
    }
    
    if (_decoder.validAudio) {
        
        @synchronized(_audioFrames) {
            
            for (KxMovieFrame *frame in frames)
                if (frame.type == KxMovieFrameTypeAudio) {
                    [_audioFrames addObject:frame];
                    if (!_decoder.validVideo)
                        _bufferedDuration += frame.duration;
                }
        }
        
        if (!_decoder.validVideo) {
            
            for (KxMovieFrame *frame in frames)
                if (frame.type == KxMovieFrameTypeArtwork)
                    self.artworkFrame = (KxArtworkFrame *)frame;
        }
    }
    
    if (_decoder.validSubtitles) {
        
        @synchronized(_subtitles) {
            
            for (KxMovieFrame *frame in frames)
                if (frame.type == KxMovieFrameTypeSubtitle) {
                    [_subtitles addObject:frame];
                }
        }
    }
    
    return self.playing && _bufferedDuration < _maxBufferedDuration;
}

- (BOOL) decodeFrames
{
    //NSAssert(dispatch_get_current_queue() == _dispatchQueue, @"bugcheck");
    
    NSArray *frames = nil;
    
    if (_decoder.validVideo ||
        _decoder.validAudio) {
        
        frames = [_decoder decodeFrames:0];
    }
    
    if (frames.count) {
        return [self addFrames: frames];
    }
    return NO;
}

- (void) asyncDecodeFrames
{
    if (self.decoding)
        return;
    
    __weak KxMovieViewController *weakSelf = self;
    __weak KxMovieDecoder *weakDecoder = _decoder;
    
    const CGFloat duration = _decoder.isNetwork ? .0f : 0.1f;
    
    self.decoding = YES;
    dispatch_async(_dispatchQueue, ^{
        
        {
            __strong KxMovieViewController *strongSelf = weakSelf;
            if (!strongSelf.playing)
                return;
        }
        
        BOOL good = YES;
        while (good) {
            
            good = NO;
            
            @autoreleasepool {
                
                __strong KxMovieDecoder *decoder = weakDecoder;
                
                if (decoder && (decoder.validVideo || decoder.validAudio)) {
                    
                    NSArray *frames = [decoder decodeFrames:duration];
                    if (frames.count) {
                        
                        __strong KxMovieViewController *strongSelf = weakSelf;
                        if (strongSelf)
                            good = [strongSelf addFrames:frames];
                    }
                }
            }
        }
                
        {
            __strong KxMovieViewController *strongSelf = weakSelf;
            if (strongSelf) strongSelf.decoding = NO;
        }
    });
}

- (void) tick
{
    if (_buffered && ((_bufferedDuration > _minBufferedDuration) || _decoder.isEOF)) {
        
        _tickCorrectionTime = 0;
        _buffered = NO;
        [_activityIndicatorView stopAnimating];        
    }
    
    CGFloat interval = 0;
    if (!_buffered)
        interval = [self presentFrame];
    
    if (self.playing) {
        
        const NSUInteger leftFrames =
        (_decoder.validVideo ? _videoFrames.count : 0) +
        (_decoder.validAudio ? _audioFrames.count : 0);
        
        if (0 == leftFrames) {
            
            if (_decoder.isEOF) {
                
                [self pause];
                [self updateHUD];
                return;
            }
            
            if (_minBufferedDuration > 0 && !_buffered) {
                                
                _buffered = YES;
                [_activityIndicatorView startAnimating];
            }
        }
        
        if (!leftFrames ||
            !(_bufferedDuration > _minBufferedDuration)) {
            
            [self asyncDecodeFrames];
        }
        
        const NSTimeInterval correction = [self tickCorrection];
        const NSTimeInterval time = MAX(interval + correction, 0.01);
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self tick];
        });
    }
    
    if ((_tickCounter++ % 3) == 0) {
        [self updateHUD];
    }
}

- (CGFloat) tickCorrection
{
    if (_buffered)
        return 0;
    
    const NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    
    if (!_tickCorrectionTime) {
        
        _tickCorrectionTime = now;
        _tickCorrectionPosition = _moviePosition;
        return 0;
    }
    
    NSTimeInterval dPosition = _moviePosition - _tickCorrectionPosition;
    NSTimeInterval dTime = now - _tickCorrectionTime;
    NSTimeInterval correction = dPosition - dTime;
    
    //if ((_tickCounter % 200) == 0)
    //    LoggerStream(1, @"tick correction %.4f", correction);
    
    if (correction > 1.f || correction < -1.f) {
        
        LoggerStream(1, @"tick correction reset %.2f", correction);
        correction = 0;
        _tickCorrectionTime = 0;
    }
    
    return correction;
}

- (CGFloat) presentFrame
{
    CGFloat interval = 0;
    
    if (_decoder.validVideo) {
        
        KxVideoFrame *frame;
        
        @synchronized(_videoFrames) {
            
            if (_videoFrames.count > 0) {
                
                frame = _videoFrames[0];
                [_videoFrames removeObjectAtIndex:0];
                _bufferedDuration -= frame.duration;
            }
        }
        
        if (frame)
            interval = [self presentVideoFrame:frame];
        
    } else if (_decoder.validAudio) {

        //interval = _bufferedDuration * 0.5;
                
        if (self.artworkFrame) {
            
            _imageView.image = [self.artworkFrame asImage];
            self.artworkFrame = nil;
        }
    }

    if (_decoder.validSubtitles)
        [self presentSubtitles];
    
#ifdef DEBUG
    if (self.playing && _debugStartTime < 0)
        _debugStartTime = [NSDate timeIntervalSinceReferenceDate] - _moviePosition;
#endif

    return interval;
}

- (CGFloat) presentVideoFrame: (KxVideoFrame *) frame
{
    if (_glView) {
        
        [_glView render:frame];
        
    } else {
        
        KxVideoFrameRGB *rgbFrame = (KxVideoFrameRGB *)frame;
        _imageView.image = [rgbFrame asImage];
    }
    
    _moviePosition = frame.position;
        
    return frame.duration;
}

- (void) presentSubtitles
{
    NSArray *actual, *outdated;
    
    if ([self subtitleForPosition:_moviePosition
                           actual:&actual
                         outdated:&outdated]){
        
        if (outdated.count) {
            @synchronized(_subtitles) {
                [_subtitles removeObjectsInArray:outdated];
            }
        }
        
        if (actual.count) {
            
            NSMutableString *ms = [NSMutableString string];
            for (KxSubtitleFrame *subtitle in actual.reverseObjectEnumerator) {
                if (ms.length) [ms appendString:@"\n"];
                [ms appendString:subtitle.text];
            }
            
            if (![_subtitlesLabel.text isEqualToString:ms]) {
                
                CGSize viewSize = self.view.bounds.size;
                CGSize size = [ms sizeWithFont:_subtitlesLabel.font
                             constrainedToSize:CGSizeMake(viewSize.width, viewSize.height * 0.5)
                                 lineBreakMode:NSLineBreakByTruncatingTail];
                _subtitlesLabel.text = ms;
                _subtitlesLabel.frame = CGRectMake(0, viewSize.height - size.height - 10,
                                                   viewSize.width, size.height);
                _subtitlesLabel.hidden = NO;
            }
            
        } else {
            
            _subtitlesLabel.text = nil;
            _subtitlesLabel.hidden = YES;
        }
    }
}

- (BOOL) subtitleForPosition: (CGFloat) position
                      actual: (NSArray **) pActual
                    outdated: (NSArray **) pOutdated
{
    if (!_subtitles.count)
        return NO;
    
    NSMutableArray *actual = nil;
    NSMutableArray *outdated = nil;
    
    for (KxSubtitleFrame *subtitle in _subtitles) {
        
        if (position < subtitle.position) {
            
            break; // assume what subtitles sorted by position
            
        } else if (position >= (subtitle.position + subtitle.duration)) {
            
            if (pOutdated) {
                if (!outdated)
                    outdated = [NSMutableArray array];
                [outdated addObject:subtitle];
            }
            
        } else {
            
            if (pActual) {
                if (!actual)
                    actual = [NSMutableArray array];
                [actual addObject:subtitle];
            }
        }
    }
    
    if (pActual) *pActual = actual;
    if (pOutdated) *pOutdated = outdated;
    
    return actual.count || outdated.count;
}


#pragma mark 底部工具栏

- (void) updateBottomBar
{
    
    _playBtn.frame = CGRectMake(CGRectGetMinX(_bottomBar.bounds), CGRectGetHeight(_bottomBar.bounds)/2 - CGRectGetHeight(_playBtn.bounds)/2, CGRectGetWidth(_playBtn.bounds), CGRectGetHeight(_playBtn.bounds));
    
    _pauseBtn.frame = _playBtn.frame;
    
    
    
    [_playPauseBtn removeFromSuperview];
    
    _playPauseBtn = self.playing ? _pauseBtn : _playBtn;
//    [_bottomBar setItems:@[_spaceItem, _rewindBtn, _fixedSpaceItem, playPauseBtn,
//                           _fixedSpaceItem, _fforwardBtn, _spaceItem] animated:NO];
    
    
    
    
    [_bottomHUD addSubview:_playPauseBtn];
    
    
    
}

- (void) updatePlayButton
{
    [self updateBottomBar];
}

- (void) updateHUD
{
    if (_disableUpdateHUD)
        return;
    
    const CGFloat duration = _decoder.duration;
    const CGFloat position = _moviePosition -_decoder.startTime;
    
    if (_progressSlider.state == UIControlStateNormal)
        _progressSlider.value = position / duration;
    _progressLabel.text = formatTimeInterval(position, NO);
    
    if (_decoder.duration != MAXFLOAT)
        _leftLabel.text = formatTimeInterval(duration - position, YES);

#ifdef DEBUG
    const NSTimeInterval timeSinceStart = [NSDate timeIntervalSinceReferenceDate] - _debugStartTime;
    NSString *subinfo = _decoder.validSubtitles ? [NSString stringWithFormat: @" %d",_subtitles.count] : @"";
    
    NSString *audioStatus;
    
    if (_debugAudioStatus) {
        
        if (NSOrderedAscending == [_debugAudioStatusTS compare: [NSDate dateWithTimeIntervalSinceNow:-0.5]]) {
            _debugAudioStatus = 0;
        }
    }
    
    if      (_debugAudioStatus == 1) audioStatus = @"\n(audio outrun)";
    else if (_debugAudioStatus == 2) audioStatus = @"\n(audio lags)";
    else if (_debugAudioStatus == 3) audioStatus = @"\n(audio silence)";
    else audioStatus = @"";

    _messageLabel.text = [NSString stringWithFormat:@"%d %d%@ %c - %@ %@ %@\n%@",
                          _videoFrames.count,
                          _audioFrames.count,
                          subinfo,
                          self.decoding ? 'D' : ' ',
                          formatTimeInterval(timeSinceStart, NO),
                          //timeSinceStart > _moviePosition + 0.5 ? @" (lags)" : @"",
                          _decoder.isEOF ? @"- END" : @"",
                          audioStatus,
                          _buffered ? [NSString stringWithFormat:@"buffering %.1f%%", _bufferedDuration / _minBufferedDuration * 100] : @""];
#endif
}

- (void) showHUD: (BOOL) show
{
    
    
    
    _hiddenHUD = !show;    
    _panGestureRecognizer.enabled = _hiddenHUD;
        
    [[UIApplication sharedApplication] setIdleTimerDisabled:_hiddenHUD];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                     animations:^{
                         
                         CGFloat alpha = _hiddenHUD ? 0 : 1;
                         _topBar.alpha = alpha;
                         _topHUD.alpha = alpha;
                         _bottomBar.alpha = alpha;
                         _bottomHUD.alpha = alpha;
                     }
                     completion:nil];
    
}

- (void) fullscreenMode: (BOOL) on
{
    _fullscreen = on;
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:on withAnimation:UIStatusBarAnimationNone];
    // if (!self.presentingViewController) {
    //[self.navigationController setNavigationBarHidden:on animated:YES];
    //[self.tabBarController setTabBarHidden:on animated:YES];
    // }
}

- (void) setMoviePositionFromDecoder
{
    _moviePosition = _decoder.position;
}

- (void) setDecoderPosition: (CGFloat) position
{
    _decoder.position = position;
}

- (void) enableUpdateHUD
{
    _disableUpdateHUD = NO;
}

- (void) updatePosition: (CGFloat) position
               playMode: (BOOL) playMode
{
    [self freeBufferedFrames];
    
    position = MIN(_decoder.duration - 1, MAX(0, position));
    
    __weak KxMovieViewController *weakSelf = self;

    dispatch_async(_dispatchQueue, ^{
        
        if (playMode) {
        
            {
                __strong KxMovieViewController *strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf setDecoderPosition: position];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
        
                __strong KxMovieViewController *strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf setMoviePositionFromDecoder];
                    
                    
//                    NSLog(@" 是不是这里 是不是这里 3.0");
                    
                    [strongSelf play];
                }
            });
            
        } else {

            {
                __strong KxMovieViewController *strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf setDecoderPosition: position];
                [strongSelf decodeFrames];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                __strong KxMovieViewController *strongSelf = weakSelf;
                if (strongSelf) {
                
                    [strongSelf enableUpdateHUD];
                    [strongSelf setMoviePositionFromDecoder];
                    [strongSelf presentFrame];
                    [strongSelf updateHUD];
                }
            });
        }        
    });
}

- (void) freeBufferedFrames
{
    @synchronized(_videoFrames) {
        [_videoFrames removeAllObjects];
    }
    
    @synchronized(_audioFrames) {
        
        [_audioFrames removeAllObjects];
        _currentAudioFrame = nil;
    }
    
    if (_subtitles) {
        @synchronized(_subtitles) {
            [_subtitles removeAllObjects];
        }
    }
    
    _bufferedDuration = 0;
}




#pragma mark 右上角信息表，让其隐藏
- (void) showInfoView: (BOOL) showInfo animated: (BOOL)animated
{
    if (!_tableView)
        [self createTableView];

    [self pause];
    
    CGSize size = self.view.bounds.size;
    CGFloat Y = _topHUD.bounds.size.height;
    
    if (showInfo) {
        
        _tableView.hidden = NO;
        
        if (animated) {
        
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                             animations:^{
                                 
                                 _tableView.frame = CGRectMake(0,Y,size.width,size.height - Y);
                             }
                             completion:nil];
        } else {
            
            _tableView.frame = CGRectMake(0,Y,size.width,size.height - Y);
        }
    
    } else {
        
        if (animated) {
            
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                             animations:^{
                                 
                                 _tableView.frame = CGRectMake(0,size.height,size.width,size.height - Y);
                                 
                             }
                             completion:^(BOOL f){
                                 
                                 if (f) {
                                     _tableView.hidden = YES;
                                 }
                             }];
        } else {
        
            _tableView.frame = CGRectMake(0,size.height,size.width,size.height - Y);
            _tableView.hidden = YES;
        }
    }
    
    _infoMode = showInfo;    
}

- (void) createTableView
{    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    
    CGSize size = self.view.bounds.size;
    CGFloat Y = _topHUD.bounds.size.height;
    _tableView.frame = CGRectMake(0,size.height,size.width,size.height - Y);
    
    [self.view addSubview:_tableView];   
}

- (void) handleDecoderMovieError: (NSError *) error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"返回", nil)
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (BOOL) interruptDecoder
{
    //if (!_decoder)
    //    return NO;
    return _interrupted;
}





//监听设备旋转方向
- (void)ListeningRotating{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];

}


- (void)onDeviceOrientationChange{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
            /**        case UIInterfaceOrientationUnknown:
             NSLog(@"未知方向");
             break;
             */
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
          //  [self backOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
          //   [self backOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在右");
            
            [self setDeviceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            
            NSLog(@"第1个旋转方向---电池栏在左");
            
            [self setDeviceOrientationLandscapeRight];
            
        }
            break;
            
        default:
            break;
    }
    
}


//返回小屏幕
- (void)backOrientationPortrait{
    if (!_fullscreen) {
        return;
    }

    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
        

        self.view.frame = CGRectMake(0, 0, width, height);
        _glView.frame = self.originFrame;
        
        NSLog(@"旋转后的_glView %@",NSStringFromCGRect(_glView.frame));
        
         _bottomHUD.frame = _bottomBar.frame;
        
        _fullScreenButton.frame = CGRectMake(CGRectGetWidth(_bottomBar.bounds) - CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_bottomBar.bounds)/2 - CGRectGetHeight(_fullScreenButton.bounds)/2, CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_fullScreenButton.bounds));
        
        
        _topBar.hidden = YES;
        
        _topBar.y = 30;
        _topHUD.y = 30;
        _topHUD.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        _topBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        
        [_doneButton setImage:[UIImage imageNamed:@"back_Video"] forState:UIControlStateNormal];
        

        
        self.contentView.hidden = NO;
  
        self.toolbar.hidden = NO;
        
        

        
       
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    } completion:^(BOOL finished) {
        _fullscreen = NO;
//        self.videoControl.fullScreenButton.hidden = NO;
//        self.videoControl.shrinkScreenButton.hidden = YES;
        if (self.willBackOrientationPortrait) {
            self.willBackOrientationPortrait();
        }
    }];
}

//电池栏在左全屏
- (void)setDeviceOrientationLandscapeRight{
    
    if (_fullscreen) {
        return;
    }
    

    if (!_glView) {
        
        return;
    }
    
    
    if (_glView) {
        
        self.originFrame = _glView.frame;
    }else{
    
        self.originFrame = _coverView.frame;
    }
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
    [UIView animateWithDuration:0.3f animations:^{

        
        self.contentView.hidden = YES;
        self.toolbar.hidden = YES;
        
        self.view.frame =frame;
        
        _coverView.frame = CGRectMake(0, 0, width, height);
        
        if (_glView) {
            
            _glView.frame = _coverView.frame;
        }

        NSLog(@"旋转全屏后的_glView %@",NSStringFromCGRect(_glView.frame));
        
        
        _bottomBar.frame = CGRectMake(0, height-40, width, 40);
        _bottomHUD.frame = _bottomBar.frame;
        
        _fullScreenButton.frame = CGRectMake(CGRectGetWidth(_bottomBar.bounds) - CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_bottomBar.bounds)/2 - CGRectGetHeight(_fullScreenButton.bounds)/2, CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_fullScreenButton.bounds));
        
        _topBar.hidden = NO;
        
        _topBar.y = 0;
        _topHUD.y = 0;
        _topHUD.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _topBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        [_doneButton setImage:[UIImage imageNamed:@"arrow_Video"] forState:UIControlStateNormal];
        
        
        
    //    NSLog(@"左全屏  %@", NSStringFromCGRect(_glView.frame));
        
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    } completion:^(BOOL finished) {
        _fullscreen = YES;
//        self.videoControl.fullScreenButton.hidden = YES;
//        self.videoControl.shrinkScreenButton.hidden = NO;
        if (self.willChangeToFullscreenMode) {
            self.willChangeToFullscreenMode();
        }
    }];
    
}
//电池栏在右全屏
- (void)setDeviceOrientationLandscapeLeft{
    
   
    if (_fullscreen) {
        return;
    }
  //  self.originFrame = self.view.frame;
    
    
    if (!_glView) {
        
        return;
    }
    
    
    if (_glView) {
        
        self.originFrame = _glView.frame;
    }else{
        
        self.originFrame = _coverView.frame;
    }
    
    
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
    
  
    [UIView animateWithDuration:0.3f animations:^{
        
        self.contentView.hidden = YES;
        self.toolbar.hidden = YES;
      
        self.view.frame =frame;
        
        
        
        _coverView.frame = CGRectMake(0, 0, width, height);
        
        if (_glView) {
            
            _glView.frame = _coverView.frame;
        }
        
        
        _glView.frame = CGRectMake(0, 0, width, height);
        
        
        _bottomBar.frame = CGRectMake(0, height-40, width, 40);
        _bottomHUD.frame = _bottomBar.frame;
        
        _fullScreenButton.frame = CGRectMake(CGRectGetWidth(_bottomBar.bounds) - CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_bottomBar.bounds)/2 - CGRectGetHeight(_fullScreenButton.bounds)/2, CGRectGetWidth(_fullScreenButton.bounds), CGRectGetHeight(_fullScreenButton.bounds));

  
        _topBar.hidden = NO;
        
        _topBar.y = 0;
        _topHUD.y = 0;
        _topHUD.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _topBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        [_doneButton setImage:[UIImage imageNamed:@"arrow_Video"] forState:UIControlStateNormal];
        
        

        
        [self.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    } completion:^(BOOL finished) {
        _fullscreen = YES;
//        self.videoControl.fullScreenButton.hidden = YES;
//        self.videoControl.shrinkScreenButton.hidden = NO;
        if (self.willChangeToFullscreenMode) {
            self.willChangeToFullscreenMode();
        }
    }];
}



#pragma mark 设置视频内的内容

-(void)setUpContentView
{
    
    [self createArray];
    
    [self getVideoCommentData];
    
    [self OSD];
    
    [self setUpBtns];
    
    [self setUpToolBar];
    
    if (self.isReplay) {
        
        [self didClickspecial];
    }else{
    
        [self didClickDetail];
    }
    
    

}



- (void)createArray {
    
    self.dataSource1 = [[NSMutableArray alloc] init];
    self.dataSource2 = [[NSMutableArray alloc] init];
    self.dataSource3 = [[NSMutableArray alloc] init];

}


#pragma mark 屏幕适配
-(void)OSD
{
    
    if (KScreenHeight == 480) {  // 4s
        
        _font = 16;
        
        
    }else if (KScreenHeight == 568){  // 5s
        _font = 17;
        
        
    }else if (KScreenHeight == 667){  // 6
        
        _font = 18;
        
        
    }else{  // 6p
        
        _font = 22;
    }
    
    
    
}


#pragma mark 设置toolbar

#define titleColor [UIColor colorWithRed:102/256.0 green:102/256.0 blue:102/256.0 alpha:1]
#define VlineColor [UIColor colorWithRed:226/256.0 green:226/256.0 blue:226/256.0 alpha:1]
#define disabledColor [UIColor colorWithRed:157/256.0 green:157/256.0 blue:157/256.0 alpha:1]


-(void)setUpToolBar
{
    
   
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, KScreenHeight-44, KScreenWidth, 44)];
    
    
    
    CGFloat toolW = self.toolbar.width;
    CGFloat toolH = self.toolbar.height;
    
    CGFloat marginFen = 10;
    
    CGFloat fengeX = toolW/3 -25;
    CGFloat fengeH = toolH - 2*marginFen;
    
    
    
    UIButton *grade = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, fengeX , toolH)];
    
    
    
    [grade setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    
    [grade setTitle:@" 评分" forState:UIControlStateNormal];
    
    [grade setImage:[UIImage imageNamed:@"love_information_list_ful_"] forState:UIControlStateDisabled];
    
    [grade setTitle:@" 评分" forState:UIControlStateDisabled];
    
    [grade setTitleColor:titleColor forState:UIControlStateNormal];
    
    [grade setTitleColor:disabledColor forState:UIControlStateDisabled];
    
    [grade addTarget:self action:@selector(didClickGrade) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *gradeItem = [[UIBarButtonItem alloc] initWithCustomView:grade];
    
    self.gradeItem = gradeItem;
    
    if ([self.model.havescore isEqual:@"1"]) {
        
        self.gradeItem.enabled = NO;
    }
    
    
    
    
    UIButton *collect = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, fengeX, toolH)];
    
    
    
    [collect setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    
    [collect setTitle:@" 收藏" forState:UIControlStateNormal];
    
    [collect setImage:[UIImage imageNamed:@"gstar"] forState:UIControlStateDisabled];
    
    [collect setTitle:@" 收藏" forState:UIControlStateDisabled];

    
    [collect setTitleColor:titleColor forState:UIControlStateNormal];
    
    [collect setTitleColor:disabledColor forState:UIControlStateDisabled];
    
    [collect addTarget:self action:@selector(didClickcollect) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithCustomView:collect];
    
    self.collectItem = collectItem;
    
    if ([self.model.havecollect isEqual:@"1"]) {
        
        self.collectItem.enabled = NO;
    }
    
    
    
    
    UIButton *comment = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, fengeX, toolH)];
    
    
    
    [comment setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    
    [comment setTitle:@" 评论" forState:UIControlStateNormal];
    
    [comment setTitleColor:titleColor forState:UIControlStateNormal];
    
    [comment addTarget:self action:@selector(didClickcomment) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithCustomView:comment];
    
    
    
    
    
    UIButton *line = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, 1, fengeH)];
    
    line.backgroundColor = VlineColor;
    
    
    UIButton *line1 = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, 1, fengeH)];
    
    line1.backgroundColor = VlineColor;
    
    
    
    UIBarButtonItem *lineItem = [[UIBarButtonItem alloc] initWithCustomView:line];
    
    UIBarButtonItem *lineItem1 = [[UIBarButtonItem alloc] initWithCustomView:line1];
    
  
    
    [self.toolbar setItems:[NSArray arrayWithObjects:gradeItem,lineItem,collectItem,lineItem1,commentItem,nil]];
    
    [self.view addSubview:self.toolbar];
    
    
    
}



#pragma mark 添加三个模块


#define lineColor [UIColor colorWithRed:226/256.0 green:226/256.0 blue:226/256.0 alpha:1]

-(void)setUpBtns
{

    
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat MovieW = bounds.size.width;
    CGFloat MovieH = MovieW/4*3;
    
    
    CGFloat btnW = MovieW/3;
    
    CGFloat viewH = btnW *0.5;
    
    
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, MovieH, KScreenWidth, KScreenHeight - MovieH)];
    
//     self.contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:self.contentView];
    
    
    self.BtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, viewH)];
    
    self.BtnView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.BtnView];
    
    
    
    
    //  详情
    
    self.detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, self.BtnView.height)];
    
    [self.detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    
    [self.detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.detailBtn.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.detailBtn addTarget:self action:@selector(didClickDetail) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnView addSubview:self.detailBtn];
      
    
    
    
    
    // 评论
    
    self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW, 0, btnW, self.BtnView.height)];
    
    [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    
    [self.commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.commentBtn addTarget:self action:@selector(didClickComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnView addSubview:self.commentBtn];
    
    
    
    
    
    // 专辑
    
    self.specialBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW *2, 0, btnW, self.BtnView.height)];
    
    [self.specialBtn setTitle:@"相关视频" forState:UIControlStateNormal];
    
    [self.specialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.specialBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    self.specialBtn.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.specialBtn addTarget:self action:@selector(didClickspecial) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnView addSubview:self.specialBtn];
    
  
    
    // 分隔线
    
    CGFloat lineH = 20;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(btnW, (viewH-lineH)/2, 1, lineH)];
    line1.backgroundColor = lineColor;
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(btnW*2, (viewH-lineH)/2, 1, lineH)];
    line2.backgroundColor = lineColor;
    
    [self.BtnView addSubview:line1];
    [self.BtnView addSubview:line2];
    
    
    // 分割线
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, viewH-1, MovieW, 1)];
    line.backgroundColor = lineColor;
    
    [self.BtnView addSubview:line];
    
    
    
    
}



#define margin 10
#define backColor [UIColor colorWithRed:237/256.0 green:237/256.0 blue:237/256.0 alpha:1]
#define playColor [UIColor colorWithRed:102/256.0 green:102/256.0 blue:102/256.0 alpha:1]


-(void)didClickDetail
{
    
    if (self.isSendGrade) {
        
        [self.detailView removeFromSuperview];
        
    }
    
    [self.detailBtn setTitleColor:KMainColor forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.specialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [self.tableView2 removeFromSuperview];
    [self.tableView3 removeFromSuperview];
    
    
    CGFloat ViewY = CGRectGetMaxY(self.BtnView.frame);
    
    self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewY, KScreenWidth, KScreenHeight-ViewY)];
    self.detailView.backgroundColor = backColor;
    [self.contentView addSubview:self.detailView];
    
    

    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, KScreenWidth-margin*2, 0)];
    
    label.numberOfLines = 0;
    
    label.text = self.model.Title;
    
    label.font = [UIFont systemFontOfSize:18];
    
    [self.detailView addSubview:label];
    
    [label sizeToFit];
    
    CGFloat labelH = label.height;
    
    label.frame = CGRectMake(margin, margin, KScreenWidth-margin*2, labelH);
    
   // NSLog(@" %f",labelH);
    
    
    
    
    
    UILabel *play = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin + CGRectGetMaxY(label.frame), 0, 0)];
    
    play.text = @"播放：";
    
  //  play.text = [NSString stringWithFormat:@"播放：%@",self.model.Click];
    
    play.textColor = playColor;
    
    play.font = [UIFont systemFontOfSize:16];
    
    [self.detailView addSubview:play];
    
    [play sizeToFit];
    
    CGFloat playW = play.width;
    CGFloat playH = play.height;
    
    play.frame = CGRectMake(margin, margin + CGRectGetMaxY(label.frame), playW, playH);
    
    
    
    
    UILabel *playCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(play.frame), play.y, 0, 0)];
    
//    playCount.text = @"18.3万";  // 数据接入
    
  
    
    NSLog(@" %@  %ld",self.model.Click,(long)[self.model.Click integerValue]);
    
    
    if ([self.model.Click integerValue]<10000) {
        
        playCount.text = self.model.Click;
    }else{
    
        NSInteger count = [self.model.Click integerValue];
        
        playCount.text = [NSString stringWithFormat:@"%ld万",(long)count];
        
        
    }
    
   
    
    
    playCount.textColor = playColor;
    
    playCount.font = [UIFont systemFontOfSize:16];
    
    [self.detailView addSubview:playCount];
    
    [playCount sizeToFit];
    
    CGFloat countW = playCount.width;
    CGFloat countH = playCount.height;
    
    playCount.frame = CGRectMake(CGRectGetMaxX(play.frame), play.y, countW, countH);
    
    
    // 显示分
    
    UIView *gradeView = [[UIView alloc] init];
    
    [self.detailView addSubview:gradeView];
    
    
    
    
    self.image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"love-half-up"]];
    
    [self.image sizeToFit];
    
    self.imageW = self.image.width ;
    CGFloat imageH = self.image.height ;
    
    gradeView.frame = CGRectMake(CGRectGetMaxX(playCount.frame)+margin, 0, self.imageW, imageH);
    
    
    self.image.frame = CGRectMake(0, 0, self.imageW, imageH);
    
    [gradeView addSubview:self.image];
    
    gradeView.center = playCount.center;
    
    CGFloat gradeViewY = gradeView.y;
    
    gradeView.frame = CGRectMake(CGRectGetMaxX(playCount.frame)+margin, gradeViewY, self.imageW, imageH);
    
    
    
    self.starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"love-ful-up"]];
    
    self.starImageView.frame = CGRectMake(0, 0, 0, imageH);
    self.starImageView.contentMode=UIViewContentModeLeft;
    self.starImageView.clipsToBounds=YES;
    
    [gradeView addSubview:self.starImageView];
    
    //  starImageView.frame = CGRectMake(CGRectGetMaxX(labelTime.frame)+maginX, imageY, 0, imageH);
    
    CGFloat halfWidth = self.imageW/10-3;
    
    CGFloat score = [self.model.score floatValue];
    
    NSLog(@"打分 %@",self.model.score);
    
    CGFloat starWidth;
    
    CGFloat marginStar = 7;
    
    if (score == 0) {
        
        starWidth = 0;
        
    }else if (score == 0.5){
        
        starWidth = halfWidth;
        
    }else if (score == 1){
        
        starWidth = halfWidth*2;
        
    }else if (score == 1.5){
        
        starWidth = halfWidth*3 +marginStar;
    }else if (score == 2){
        
        starWidth = halfWidth*4 +marginStar;
    }else if (score == 2.5){
        
        starWidth = halfWidth*5 +marginStar*2;
    }else if (score == 3){
        
        starWidth = halfWidth*6 +marginStar*2;
    }else if (score == 3.5){
        
        starWidth = halfWidth*7 +marginStar*3;
    }else if (score == 4){
        
        starWidth = halfWidth*8 +marginStar*3;
    }else if (score == 4.5){
        
        starWidth = halfWidth*9 +marginStar*4;
    }else{
        
        starWidth = halfWidth*10 +marginStar*4 +1;
    }
    
    self.starImageView.frame = CGRectMake(0, 0, starWidth, self.image.height);
    
    
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradeView.frame)+margin/2, gradeView.y-2, 0, gradeView.height)];
    
    
    count.text = [NSString stringWithFormat:@"(%.1f)",score];
    count.textColor = KMainColor;
    count.font = [UIFont systemFontOfSize:10];
    
    [count sizeToFit];
    
    [self.detailView addSubview:count];
    
    
}





-(void)didClickComment
{

    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat MovieW = bounds.size.width;
    CGFloat MovieH = MovieW/4*3;
    
    
    [self.detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:KMainColor forState:UIControlStateNormal];
    [self.specialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.detailView removeFromSuperview];
    [self.tableView3 removeFromSuperview];
    
    if (self.tableView2) {
        
        return;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.BtnView.frame), KScreenWidth, KScreenHeight-CGRectGetMaxY(self.BtnView.frame)-MovieH-44)];
    
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    

    UIView *clearView = [[UIView alloc] init];
    clearView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = clearView;
    
    [self.contentView addSubview:tableView];
    self.tableView2 = tableView;


}



-(void)didClickspecial
{

   // [self.dataSource3 removeAllObjects];
    
#pragma mark 加载专辑数据
    
    if (self.isReplay) {
        
        [self getSpecial];
        
    }
    
    
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat MovieW = bounds.size.width;
    CGFloat MovieH = MovieW/4*3;
    
    
    [self.detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.specialBtn setTitleColor:KMainColor forState:UIControlStateNormal];

    [self.detailView removeFromSuperview];
    [self.tableView2 removeFromSuperview];
    
    
    if (self.tableView3) {
        
        return;
    }
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.BtnView.frame), KScreenWidth, KScreenHeight-CGRectGetMaxY(self.BtnView.frame)-MovieH -44)];
    
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    
    [self.contentView addSubview:tableView];
    self.tableView3= tableView;
    

}



#pragma mark 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        
        
        return self.dataSource1.count;
        
    }
    else if(tableView == self.tableView2){
        
        NSLog(@"------------------>%ld",(unsigned long)self.dataSource2.count);
        
        return self.dataSource2.count;
        
    }else{
        
        return self.specailArray.count;
        
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView){
        
        
        
    }else if(tableView == self.tableView2){
        
        if (indexPath.row == 0) {
            
            ZRTCaseCommentNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseCommentNumberCell"];
            
            for (UIView *obj in cell.contentView.subviews) {
                [obj removeFromSuperview];
            }
            
            if (cell == nil) {
                
                cell = [[ZRTCaseCommentNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VideoCommentNumberCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            }
            
            cell.height = [cell fillVideoCellWithData:[NSString stringWithFormat:@"%ld",(unsigned long)[self.dataSource2[indexPath.row] count]]];
            
            
            return cell;
        }
        else {
            
            ZRTConsultationDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
            
            if (cell == nil) {
                
                cell = [[ZRTConsultationDetailCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            for (UIView *obj in cell.contentView.subviews) {
                [obj removeFromSuperview];
            }
            
            cell.height = [cell fillVideoCommentCellWithData:self.dataSource2[indexPath.row]] + 10;
            
            
            return cell;
        }

        
    }else{
    
        ZRTSpecialCell *cell = [ZRTSpecialCell cellWithTableView:tableView];
        
        
        for (UIView *obj in cell.contentView.subviews) {
            [obj removeFromSuperview];
        }
        
        
        
        [cell setAllView];
        
        ZRTVideoModel *model = [ZRTVideoModel videoModelWithDict:self.specailArray[indexPath.row]];
   
        cell.model = model;
   
        cell.height = [cell CellHight];
        
    
        return cell;
        
    }
    
    return nil;
    
}







-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == self.tableView2) {
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.height;

    }else if(tableView == self.tableView3){
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

        return cell.height;
    
    }else{
    
        return 44;
    }
    
    
    
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.tableView3) {
        
       
        
        ZRTVideoModel *model = [ZRTVideoModel videoModelWithDict:self.specailArray[indexPath.row]];
        
       
        
        NSString *path = [NSString stringWithFormat:@"%@%@",KMainInterface,model.VideoPath];

        
        if (self.presentingViewController || !self.navigationController)
            [self dismissViewControllerAnimated:NO completion:nil];
        else
            [self.navigationController popViewControllerAnimated:NO];
        
        
        
        if ([self.delegate respondsToSelector:@selector(rePlayVideoPath:AndModel:isReplay:)]) {
            
            [self.delegate rePlayVideoPath:path AndModel:model isReplay:YES];
            
        }
        
        
        
//        [self freeBufferedFrames];
        
      //  [self pause];
        
//        [_decoder closeFile];
//        
//        NSError *error = nil;
//        
//        [_decoder openFile:path error:&error];
//        
//        
//        
//        
//        [self play];
        
        
        
//        [self freeBufferedFrames];
//        
//        [_decoder closeFile];
//        
//        [_glView removeFromSuperview];
//        
//        NSError *error = nil;
//        
//        [_decoder openFile:path error:&error];
//        
//        [self setMovieDecoder:_decoder withError:error];
//        
//        
//         [self play];
        
        
        
        
        
        
        
    }

}






#pragma mark toolbar点击方法

// 点击评分
-(void)didClickGrade
{
    
    ZRTGradeView *grade = [[ZRTGradeView alloc] init];
    
    grade.delegate = self;
    
    
    
    LGAlertView *alert = [LGAlertView alertViewWithViewStyleWithTitle:@"评分" message:nil view:grade buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" actionHandler:nil cancelHandler:nil destructiveHandler:^(LGAlertView *alertView) {
        
        
        [self sendGrade];
        
        
    }];
    
    
    [alert showAnimated:YES completionHandler:nil];
    
    
   // NSLog(@"评分");
    
}


-(void)sendGrade
{
    
    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Video.asmx/AddVideoScore";
    
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDict"];
    
    NSString *UserID = [dic objectForKey:@"Id"];
    
    NSString *VideoID = self.model.Id;
    
    NSString *score = [NSString stringWithFormat:@"%f",self.fen];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSLog(@"fen %@",score);
    
    
    [manager POST:url parameters:@{@"UserID":UserID,@"VideoID":VideoID,@"score":score} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"评分成功");
        
        self.model.score = score;
        
        self.isSendGrade = YES;
        
        [self didClickDetail];
        
        
        [self performSelector:@selector(cover) withObject:nil afterDelay:0.6];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        [self performSelector:@selector(cover1) withObject:nil afterDelay:0.6];
        
    }];
    
    
    
    
}




// 点击收藏
-(void)didClickcollect
{
    
    
    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Video.asmx/AddVideoCollect";
    
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDict"];
    
    NSString *UserID = [dic objectForKey:@"Id"];
    
    NSString *VideoID = self.model.Id;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    [manager POST:url parameters:@{@"UserID":UserID,@"VideoID":VideoID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.collectItem.enabled = NO;
        
        NSLog(@"收藏成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"收藏失败");
        
    }];
//
    
    NSLog(@"收藏");
}

// 点击评论
-(void)didClickcomment
{
    
    ZRTCommentController *comment = [[ZRTCommentController alloc] init];
    
    comment.delegate = self;
    
    comment.isCase = NO;
    
    comment.videoModel = self.model;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:comment];
    
    
  //  [self.navigationController pushViewController:comment animated:YES];
    
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
    NSLog(@"评论");
}



#pragma mark 发表评论代理方法(刷表)

-(void)commentReload
{

    [self.dataSource2 removeAllObjects];
    
    do {
        [self getVideoCommentData];
    } while (self.dataSource2.count != 0);
    

}



// 蒙版隐藏
-(void)cover
{
    self.success = [ZRTGradeSuccess initWithSuccess:YES];
    
    
    
    
    
    self.gradeItem.enabled = NO;
}


-(void)cover1
{
    self.success =[ZRTGradeSuccess initWithSuccess:NO];
    
    self.gradeItem.enabled = YES;
}



#pragma mark gradeView代理方法


// 选择分数
-(void)chooseGrade:(CGFloat)grade
{
    
    self.fen = grade;
    
}




#pragma mark 获取专辑网络请求


-(void)getSpecial
{

    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Video.asmx/GetVideoAlbum";
    
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDict"];
    
    NSString *UserID = [dic objectForKey:@"Id"];
    
    NSString *VideoID = self.model.Id;
    
    NSLog(@"special %@ %@",UserID,VideoID);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:url parameters:@{@"userID":UserID,@"videoID":VideoID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        
        
       self.specailArray = jsonDict[@"ds"];
        
        
       
        [self.tableView3 reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        
    }];



}



- (NSDictionary *)StringToJsonDictWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        //NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#pragma mark 懒加载

-(NSArray *)specailArray
{

    if (!_specailArray) {
        
        _specailArray = [[NSArray alloc] init];
    }


    return _specailArray;
}

#pragma mark - 网络请求
- (void)getVideoCommentData {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getVideoCommentDataWithvideoID:self.model.Id andPageIndex:@"1" andPageSize:@"10000" andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [weakSelf fillDataSource2WithJsonDict:jsonDict];
        
        [self.tableView2 reloadData];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        NSLog(@"获取视频评论 error == %@",error);
    }];
}

- (void)fillDataSource2WithJsonDict:(NSDictionary *)jsonDict {
    
    
    if (jsonDict.count != 0) {
        [self.dataSource2 addObject:jsonDict[@"ds"]];
        [self.dataSource2 addObjectsFromArray:jsonDict[@"ds"]];
    }
    else {
        [self.dataSource2 addObject:@[]];
    }

}
@end


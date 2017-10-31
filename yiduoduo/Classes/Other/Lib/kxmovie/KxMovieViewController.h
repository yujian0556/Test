//
//  ViewController.h
//  kxmovieapp
//
//  Created by Kolyvan on 11.10.12.
//  Copyright (c) 2012 Konstantin Boukreev . All rights reserved.
//
//  https://github.com/kolyvan/kxmovie
//  this file is part of KxMovie
//  KxMovie is licenced under the LGPL v3, see lgpl-3.0.txt

#import <UIKit/UIKit.h>



@class KxMovieDecoder;
@class ZRTVideoModel;

extern NSString * const KxMovieParameterMinBufferedDuration;    // Float
extern NSString * const KxMovieParameterMaxBufferedDuration;    // Float
extern NSString * const KxMovieParameterDisableDeinterlacing;   // BOOL


@protocol KxMovieViewControllerDelegate <NSObject>

- (void)reloadDataAfterBack;

- (void)rePlayVideoPath:(NSString *)path AndModel:(ZRTVideoModel*)model isReplay:(BOOL)isreplay;

@end

@interface KxMovieViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

+ (id) movieViewControllerWithContentPath: (NSString *) path
                               parameters: (NSDictionary *) parameters;

@property (readonly) BOOL playing;



/** 进入最小化状态 */
@property (nonatomic, copy)void(^willBackOrientationPortrait)(void);
/** 进入全屏状态 */
@property (nonatomic, copy)void(^willChangeToFullscreenMode)(void);

@property (nonatomic, assign) CGRect frame;

@property (nonatomic,weak) id <KxMovieViewControllerDelegate> delegate;

- (void) play;
- (void) pause;


@property (nonatomic,strong) ZRTVideoModel *model;

@property (nonatomic,assign) BOOL isReplay;

@end

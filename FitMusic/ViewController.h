//
//  ViewController.h
//  FitMusic
//
//  Created by Morten Ydefeldt on 07/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "fitModel.h"
@interface ViewController : UIViewController <UINavigationControllerDelegate, fitDelegate>{
    
    MPMusicPlayerController *musicPlayController;
    BOOL format;
}

@property (nonatomic) fitModel* fitModel;

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (strong, nonatomic) MPMusicPlayerController *musicPlayController;
@property (strong, nonatomic) MPMediaPlaylist *playList;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic) BOOL format;

- (IBAction)playButton:(id)sender;
- (IBAction)nextButton:(id)sender;
- (IBAction)previousButton:(id)sender;

- (IBAction)DisplayPlayNextSongs:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *playListView;
@property (weak, nonatomic) IBOutlet UITextView *nextSongsTextField;

@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;

@property (weak, nonatomic) IBOutlet UIButton *playlistButton;
@property (nonatomic) NSTimer *uiTimer;

@property (weak, nonatomic) IBOutlet UILabel *nextTrackLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *playProgressSlider;

@end

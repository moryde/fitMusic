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

@interface ViewController : UIViewController <MPMediaPickerControllerDelegate>{
    
    MPMusicPlayerController *musicPlayController;
    BOOL format;
}

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (strong, nonatomic) MPMusicPlayerController *musicPlayController;
@property (strong, nonatomic) MPMediaPlaylist *playList;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic) BOOL format;

- (IBAction)libraryButton:(id)sender;
- (IBAction)playButton:(id)sender;
- (IBAction)nextButton:(id)sender;
- (IBAction)previousButton:(id)sender;

- (void) registerMediaPlayerNotifications;

@property (weak, nonatomic) IBOutlet UIView *volumeView;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;

@property (weak, nonatomic) IBOutlet UIButton *playlistButton;
@property (nonatomic) NSTimer *uiTimer;
@property (weak, nonatomic) IBOutlet UILabel *playlistLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTrackLabel;

@end

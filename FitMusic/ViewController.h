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

@interface ViewController : UIViewController <MPMediaPickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDataSource>{
    
    MPMusicPlayerController *musicPlayController;
    
}

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (strong, nonatomic) MPMusicPlayerController *musicPlayController;
@property (strong, nonatomic) MPMediaPlaylist *playList;

- (IBAction)libraryButton:(id)sender;
- (IBAction)playButton:(id)sender;
- (IBAction)nextButton:(id)sender;
- (IBAction)previousButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (void) registerMediaPlayerNotifications;
@property (weak, nonatomic) IBOutlet UIView *volumeView;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;

@property (nonatomic) NSTimer *uiTimer;
@property (weak, nonatomic) IBOutlet UILabel *playlistLabel;

@end

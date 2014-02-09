//
//  ViewController.m
//  FitMusic
//
//  Created by Morten Ydefeldt on 07/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController
@synthesize musicPlayController;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    musicPlayController = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];
    
    [self displayVolumeView];
    
    AppDelegate *delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [musicPlayController setQueueWithItemCollection:delegate.playList];
    [musicPlayController setShuffleMode:MPMusicShuffleModeOff];
    [musicPlayController setRepeatMode:MPMusicRepeatModeNone];
    
    self.playlistLabel.text = [delegate.playList valueForProperty:MPMediaPlaylistPropertyName];
}

-(void)updateUI{
    NSNumber *totalTrackTime = [musicPlayController.nowPlayingItem valueForProperty:(MPMediaItemPropertyPlaybackDuration)];
    NSTimeInterval currentPlaybackTime = [musicPlayController currentPlaybackTime];
    int timeRemaining = totalTrackTime.intValue - currentPlaybackTime;
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%i",timeRemaining];
}


-(void) displayVolumeView
{
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame: self.volumeView.bounds];
    [self.volumeView addSubview: myVolumeView];
}

- (void) registerMediaPlayerNotifications
{
    

    [[NSNotificationCenter defaultCenter] addObserver: self
                           selector: @selector (handleNowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayController];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                            selector: @selector (handlePlayBackStateChanged:)
                            name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                            object: musicPlayController];
    
    [musicPlayController beginGeneratingPlaybackNotifications];

}


- (void)handleNowPlayingItemChanged: (id) notification{
    self.artistLabel.text = [musicPlayController.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    self.trackLabel.text = [musicPlayController.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    self.commentsTextView.text = [musicPlayController.nowPlayingItem valueForProperty:MPMediaItemPropertyComments];
}


- (void)handlePlayBackStateChanged: (id) notification{
    if ([musicPlayController playbackState] == MPMusicPlaybackStatePlaying) {
        [self.playButton setTitle:@"▷" forState:UIControlStateNormal];
        self.uiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        [self handleNowPlayingItemChanged:Nil];
    } else {
        [self.playButton setTitle:@"►" forState:UIControlStateNormal];
        [self.uiTimer invalidate];
    }
}



- (IBAction)playButton:(id)sender {
    if ([musicPlayController playbackState] == MPMusicPlaybackStatePlaying) {
        [musicPlayController pause];
        
    } else {
        [musicPlayController play];
    }
    
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        
        [musicPlayController setQueueWithItemCollection: mediaItemCollection];
        [musicPlayController play];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextButton:(id)sender {
    
    [musicPlayController skipToNextItem];
}

- (IBAction)previousButton:(id)sender {
    
    [musicPlayController skipToPreviousItem];
}
- (IBAction)libraryButton:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

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
    AppDelegate *delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"VIEW DID LOAD");
	// Do any additional setup after loading the view, typically from a nib.
    musicPlayController = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];
    
    //[self displayVolumeView];
    
    [musicPlayController setQueueWithItemCollection:delegate.playList];
    [musicPlayController play];
    [musicPlayController setShuffleMode:MPMusicShuffleModeOff];
    [musicPlayController setRepeatMode:MPMusicRepeatModeNone];
    [self handlePlayBackStateChanged:nil];
    [self handleNowPlayingItemChanged:nil];
    [self.playlistButton setTitle:[delegate.playList valueForProperty:MPMediaPlaylistPropertyName] forState:UIControlStateNormal];
}

-(void)updateUI{
    NSNumber *totalTrackTime = [musicPlayController.nowPlayingItem valueForProperty:(MPMediaItemPropertyPlaybackDuration)];
    NSTimeInterval currentPlaybackTime = [musicPlayController currentPlaybackTime];
    int timeRemaining = totalTrackTime.intValue - currentPlaybackTime;
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%i",timeRemaining];

    int hour = timeRemaining / 3600;
    int minutes = timeRemaining / 60 - hour * 60;
    int seconds = timeRemaining - (hour * 3600 + minutes * 60);
    
    NSString *stringTime = [NSString stringWithFormat:@"%i:%i",minutes,seconds];
    if (self.format == 0) {
        self.timeLeftLabel.text = stringTime;
    } else {
        self.timeLeftLabel.text = [NSString stringWithFormat:@"%i",timeRemaining];

    }
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

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
    
    if (touch.view.tag == 2){
        self.format = !self.format;
        [self updateUI];
    }
    
    
}

- (void) changeTimeLabel{

    
    
}


- (void)handleNowPlayingItemChanged: (id) notification{
    int i =  [musicPlayController indexOfNowPlayingItem];

    if (i > 0) {
        NSLog([NSString stringWithFormat:@"%i",i]);
        
        AppDelegate *delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        
        if (delegate.playList) {
            NSLog([NSString stringWithFormat:@"%i", [delegate.playList count]]);
            
            NSArray *songs = [delegate.playList items];
            
            
            if ([songs objectAtIndex:i]) {
                MPMediaItem *song = [songs objectAtIndex:i+1];

                self.nextTrackLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
            }else{
                self.nextTrackLabel.text =  @"NO NEXT SONG";
            }
            
        }
    }
    

    
    self.artistLabel.text = [musicPlayController.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    self.trackLabel.text = [musicPlayController.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    
    if ([musicPlayController.nowPlayingItem valueForProperty:MPMediaItemPropertyComments]) {
        self.commentsTextView.text = [musicPlayController.nowPlayingItem valueForProperty:MPMediaItemPropertyComments];
    }else {
        self.commentsTextView.text = @"No comments availible for this song";
        [musicPlayController.nowPlayingItem valueForProperty:MPMediaPlaylistPropertyName];
    }
    

}


- (void)handlePlayBackStateChanged: (id) notification{
    if ([musicPlayController playbackState] == MPMusicPlaybackStatePlaying) {
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
        self.uiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        [self handleNowPlayingItemChanged:Nil];
    } else {
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
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
    
    if ([musicPlayController currentPlaybackTime] < 3) {
        [musicPlayController skipToPreviousItem];
    }else{
        [musicPlayController skipToBeginning];

    }
    
}
- (IBAction)libraryButton:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
@synthesize musicPlayController, format;



- (void)viewDidLoad
{
    [super viewDidLoad];
    _fitModel = [fitModel getInstance];
    _fitModel.delegate = self;
    NSLog(@"VIEW DID LOAD");
	// Do any additional setup after loading the view, typically from a nib.
    [self updateUI];
    
    //[self displayVolumeView];
    AppDelegate *delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    self.playList = delegate.playList;
    [self.nextSongsTextField setText:@""];
    
    NSArray *a = [self.playList items];
    for (MPMediaItem *song in a) {
        
        
        NSString *title =  [self.nextSongsTextField.text stringByAppendingString:[song valueForProperty:MPMediaItemPropertyTitle]];
        NSString *title2 = [title stringByAppendingString:@"\n"];
        [self.nextSongsTextField setText:title2];
        musicPlayController = [MPMusicPlayerController iPodMusicPlayer];
        
        
        [musicPlayController setQueueWithItemCollection:delegate.playList];
        [musicPlayController setShuffleMode:MPMusicShuffleModeOff];
        [musicPlayController setRepeatMode:MPMusicRepeatModeAll];
        
        [self updateUI];
        [musicPlayController play];
    }
}

-(void)viewDidAppear:(BOOL)animated{

    NSLog(@"VIEW DID APPEAR");
    [super viewDidAppear:YES];
    _fitModel.delegate = self;
    [self updateUI];
    
}

-(void)newInformation {
    NSLog(@"TIMER");
    [self updateUI];
}

-(void)playStateChanged:(NSString *)playString{
    
    [self.playButton setTitle:playString forState:UIControlStateNormal];
}

-(void)updateUI{

    if ((_fitModel.currentPlaylist)) {
        [self.playlistButton setTitle:[_fitModel.currentPlaylist valueForProperty:MPMediaPlaylistPropertyName] forState:UIControlStateNormal];
        self.trackLabel.text = [_fitModel.currentSong valueForProperty:MPMediaItemPropertyTitle];
        
        if (self.commentsTextView.tag == 0) {
            self.commentsTextView.text = [_fitModel.currentSong valueForProperty:MPMediaItemPropertyComments];
            if ([[_fitModel.currentSong valueForProperty:MPMediaItemPropertyComments] isEqualToString:@""]) {
                self.commentsTextView.text = @"No comments availible";
            }
        }
        
        NSNumber *totalTrackTime = [_fitModel.currentSong valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSTimeInterval currentPlaybackTime = [_fitModel.musicController currentPlaybackTime];
        int timeRemaining = totalTrackTime.intValue - currentPlaybackTime;
        
        [self.playProgressSlider setProgress:(currentPlaybackTime/[totalTrackTime integerValue]) animated:YES];
        self.nextTrackLabel.text = [_fitModel getNextTrack];
        self.timeLeftLabel.text = [NSString stringWithFormat:@"%i",timeRemaining];
        
        NSLog(@"%f",self.playProgressSlider.progress);
        int hour = timeRemaining / 3600;
        int minutes = timeRemaining / 60 - hour * 60;
        int seconds = timeRemaining - (hour * 3600 + minutes * 60);
        NSString *stringTime = [NSString stringWithFormat:@"%i:%@",minutes,[NSString stringWithFormat:@"%02d", seconds]];
        
        if (self.format == 0) {
            self.timeLeftLabel.text = stringTime;
        } else {
            self.timeLeftLabel.text = [NSString stringWithFormat:@"%i",timeRemaining];
            
        }
        
    }else
    {
        self.trackLabel.text = @"Please select a playlist";
        [self.playlistButton setTitle:@"Please press here" forState:UIControlStateNormal];
    }
    
    //[self.playProgressSlider setContentScaleFactor:[totalTrackTime floatValue]];


}


-(void) displayVolumeView
{
    //MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame: self.volumeView.bounds];
    //[self.volumeView addSubview: myVolumeView];
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

- (IBAction)playButton:(id)sender {
    NSLog(@"PlayButtonPressed");
    if (_fitModel.currentPlaylist) {
        if ([_fitModel.musicController playbackState] == MPMusicPlaybackStatePlaying) {
            [_fitModel.musicController pause];
        } else {
            [_fitModel startMusic];
        }
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

    [_fitModel.musicController skipToNextItem];
}

- (IBAction)previousButton:(id)sender {
    
    if ([_fitModel.musicController currentPlaybackTime] < 3) {
        [_fitModel.musicController skipToPreviousItem];
    }else{
        [_fitModel.musicController skipToBeginning];

    }
    
}


- (IBAction)DisplayPlayNextSongs:(id)sender {

    if (self.commentsTextView.tag == 1) {
        self.commentsTextView.tag = 0;
        self.commentsTextView.text = [[_fitModel currentSong] valueForProperty:MPMediaItemPropertyComments];

    }else{
        self.commentsTextView.tag = 1;
        self.commentsTextView.text = [_fitModel songsInQueue];

    }
    
    
}

- (IBAction)displayPlaylitsStop:(id)sender {
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

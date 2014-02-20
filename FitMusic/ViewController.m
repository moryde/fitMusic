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
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _fitModel = [fitModel getInstance];
    _fitModel.delegate = self;

	// Do any additional setup after loading the view, typically from a nib.

    [self updateUI];
    UIColor * color = [UIColor colorWithRed:17/255.0f green:168/255.0f blue:170/255.0f alpha:1.0f];

    //[self.navigationController.navigationBar setBackgroundColor:[UIColor greenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:color];

    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               [UIColor blackColor], NSShadowAttributeName,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], NSShadowAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [self setTitle:@"fitMusic"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"NUMBER OF CELLS RETURN");
    
    NSLog(@"%i", [_fitModel.commentsOfCurrentSong count]);
    return [_fitModel.commentsOfCurrentSong count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"LOOL");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    UIProgressView *progress;
    
    progress = (UIProgressView*)[cell viewWithTag:1];
    NSDictionary *d = [_fitModel.commentsOfCurrentSong objectAtIndex:indexPath.row];
    
    NSString *s = [d objectForKey:@"comment"];
    
    int endTime = [[[_fitModel.commentsOfCurrentSong objectAtIndex:indexPath.row+1] objectForKey:@"time"] intValue];
    
    
    if ([_fitModel.musicController currentPlaybackTime] >= [[d objectForKey:@"time"] intValue] && [_fitModel.musicController currentPlaybackTime] < endTime) {
        float progressInt = endTime - [_fitModel.musicController currentPlaybackTime];
        [progress setProgress:progressInt/[_fitModel.musicController currentPlaybackTime] animated:YES];
    }
    
    [progress setProgress:0.1 animated:YES];

    cell.textLabel.text = s;
    
    

    return cell;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:25.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    [self.tableView reloadData];
    NSLog(@"View did appear");
    _fitModel.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void)newInformation {

    [self updateUI];
}

-(void)playStateChanged:(NSString *)playString{
    
    [self.playButton setTitle:playString forState:UIControlStateNormal];
}

-(void)updateUI{

    if ((_fitModel.currentPlaylist)) {
        [self.tableView reloadData];
        //[[self.navigationController topViewController] setTitle:[_fitModel.currentPlaylist valueForProperty:MPMediaPlaylistPropertyName]];
        [self.playlistButton setTitle:[_fitModel.currentPlaylist valueForProperty:MPMediaPlaylistPropertyName] forState:UIControlStateNormal];
        self.trackLabel.text = [_fitModel.currentSong valueForProperty:MPMediaItemPropertyTitle];
        
        if (self.commentsTextView.tag == 0) {
            self.commentsTextView.attributedText = [_fitModel getComments];

        }
        
        NSNumber *totalTrackTime = [_fitModel.currentSong valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSTimeInterval currentPlaybackTime = [_fitModel.musicController currentPlaybackTime];
        //int timeRemaining = totalTrackTime.intValue - currentPlaybackTime;
        int timeRemaining = currentPlaybackTime;
        [self.playProgressSlider setProgress:(currentPlaybackTime/[totalTrackTime integerValue]) animated:YES];
        self.nextTrackLabel.text = [_fitModel getNextTrack];
        self.timeLeftLabel.text = [NSString stringWithFormat:@"%i",timeRemaining];
        

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

    if (_fitModel.currentPlaylist) {
        if ([_fitModel.musicController playbackState] == MPMusicPlaybackStatePlaying) {
            [_fitModel stopMusic];
        } else {
            [_fitModel startMusic];
        }
    }
}


- (IBAction)nextButton:(id)sender {
   // [_fitModel.musicController setCurrentPlaybackRate:1.5];
[_fitModel.musicController skipToNextItem];
    
    //[_fitModel.currentSong setValue:@"loool" forKey:MPMediaItemPropertyComments];
                                                            
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

        self.commentsTextView.attributedText = [_fitModel getComments];

    }else{
        self.commentsTextView.tag = 1;

        self.commentsTextView.attributedText = [_fitModel songsInQueue];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

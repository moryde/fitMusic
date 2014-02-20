//
//  ViewController.m
//  bikeBot
//
//  Created by Morten Ydefeldt on 18/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    

}

@property (nonatomic) UIColor *mainColor;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mainColor = [UIColor colorWithRed:17/255.0f green:168/255.0f blue:170/255.0f alpha:1.0f];
    
    _fitModel = [FitModel getInstance];
    _fitModel.delegate = self;
    [_tableView reloadData];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:_mainColor];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               [UIColor blackColor], NSShadowAttributeName,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], NSShadowAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView.textColor = [UIColor whiteColor]; // Change to desired color
    self.navigationItem.titleView = titleView;

    [self setTitle:@"fitMusic"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_nextInQueueButton isSelected]) {
        return [[_fitModel.mediaCollection items] count];
    }else {
        return [_fitModel.getCommentsForCurrentItem count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    [self.tableView setTintColor:_mainColor];

    if ([_nextInQueueButton isSelected]) {
        if ([_fitModel.musicController.nowPlayingItem isEqual:[[_fitModel getSongsInQueue] objectAtIndex:indexPath.row]]) {
            //cell.backgroundColor = _mainColor;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = [[[_fitModel getSongsInQueue] objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyTitle];
        cell.detailTextLabel.text = [[[[_fitModel getSongsInQueue] objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyPlaybackDuration] stringValue];
        
    } else{
        cell.textLabel.text = [[_fitModel.getCommentsForCurrentItem objectAtIndex:indexPath.row] objectForKey:@"comment"];
        cell.detailTextLabel.text = [[_fitModel.getCommentsForCurrentItem objectAtIndex:indexPath.row] objectForKey:@"time"];
        if ([[[_fitModel.getCommentsForCurrentItem objectAtIndex:indexPath.row] objectForKey:@"time"] integerValue] <= [_fitModel.musicController currentPlaybackTime]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        NSLog(@"comment");
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_nextInQueueButton isSelected]) {
        return @"Next songs in queue";
    }else{
        return @"Next actions";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_nextInQueueButton isSelected]) {
        [_fitModel.musicController setNowPlayingItem:[[_fitModel.mediaCollection items] objectAtIndex:indexPath.row]];
        [_fitModel.musicController play];
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

- (IBAction)addTempo:(UIButton *)sender {
    [_fitModel.musicController setCurrentPlaybackRate:_fitModel.musicController.currentPlaybackRate+0.2];
    NSLog(@"%f",_fitModel.musicController.currentPlaybackRate);
}

- (IBAction)subtractTempo:(UIButton *)sender {
    [_fitModel.musicController setCurrentPlaybackRate:_fitModel.musicController.currentPlaybackRate-0.2];
}

- (IBAction)QueueButton:(UIButton*)sender {
    if ([_nextInQueueButton isSelected]) {
        [_nextInQueueButton setSelected:NO];
        [_nextInQueueButton setBackgroundColor:[UIColor whiteColor]];
        [_nextInQueueButton setTitleColor:_mainColor forState:UIControlStateNormal];


    }else{
        [_nextInQueueButton setSelected:YES];
        [_nextInQueueButton setBackgroundColor:_mainColor];
        [_nextInQueueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}

- (IBAction)nextSongButton:(UIButton*)sender {
    [_fitModel.musicController skipToNextItem];
}

- (IBAction)previousSongButton:(UIButton*)sender {
    if ([_fitModel.musicController currentPlaybackTime] < 3) {
        [_fitModel.musicController skipToPreviousItem];
    }else{
        [_fitModel.musicController skipToBeginning];
    }

}

- (IBAction)playPauseButton:(UIButton *)sender {
    [_fitModel togglePlayPause];
}

- (void) playStateChanged:(MPMusicPlaybackState)playState {

    if (_fitModel.musicController.playbackState == MPMusicPlaybackStatePlaying) {
        [_playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];

        [_playPauseButton setTitleColor:_mainColor forState:UIControlStateNormal];
        [_playPauseButton setBackgroundColor:[UIColor whiteColor]];
        if (!self.progressTimer) {
            self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressUpdate) userInfo:nil repeats:YES];
        }
    }else{
        [_playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        [_playPauseButton setBackgroundColor:_mainColor];
        [_playPauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        NSLog(@"Play");

        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}

- (void)playingItemChanged:(MPMediaItem *)songItem{
    [_tableView reloadData];
    [_currentSongButton setTitle:[_fitModel.musicController.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle] forState:UIControlStateNormal];
    [self progressUpdate];
    if (_fitModel.musicController.indexOfNowPlayingItem < [_fitModel.mediaCollection count]-1) {
       NSString *s = [[[_fitModel.mediaCollection items] objectAtIndex:_fitModel.musicController.indexOfNowPlayingItem+1]valueForKeyPath:MPMediaItemPropertyTitle];
        [_nextInQueueButton setTitle:s forState:UIControlStateNormal];
    }else{
        NSString *s = [[[_fitModel.mediaCollection items] firstObject] valueForProperty:MPMediaItemPropertyTitle];
        [_nextInQueueButton setTitle:s forState:UIControlStateNormal];
    }
    [self progressUpdate];
}

-(void)progressUpdate {
    self.timeLabel.text = [NSString stringWithFormat:@"%f",[_fitModel.musicController currentPlaybackTime]];
    
    NSNumber *totalTrackTime = [_fitModel.musicController.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    NSTimeInterval currentPlaybackTime = [_fitModel.musicController currentPlaybackTime];
    int timeRemaining = currentPlaybackTime;
    [_currentSongProgressBar setProgress:(currentPlaybackTime/[totalTrackTime integerValue]) animated:YES];

    self.timeLabel.text = [NSString stringWithFormat:@"%i",timeRemaining];
    
    int hour = timeRemaining / 3600;
    int minutes = timeRemaining / 60 - hour * 60;
    int seconds = timeRemaining - (hour * 3600 + minutes * 60);
    
    NSString *stringTime = [NSString stringWithFormat:@"%i:%@",minutes,[NSString stringWithFormat:@"%02d", seconds]];
    
    self.timeLabel.text = stringTime;
    [_tableView reloadData];
}
@end

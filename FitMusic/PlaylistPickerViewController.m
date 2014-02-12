//
//  PlaylistPickerViewController.m
//  FitMusic
//
//  Created by Morten Ydefeldt on 07/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "PlaylistPickerViewController.h"

@interface PlaylistPickerViewController ()

@end


@implementation PlaylistPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
    self.playlists = [playlistsQuery collections];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return self.playlists.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.playlists[row] valueForProperty:MPMediaPlaylistPropertyName];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    AppDelegate *delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    delegate.playList = self.playlists[row];
    
}

@end

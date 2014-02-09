//
//  PlaylistPickerViewController.h
//  FitMusic
//
//  Created by Morten Ydefeldt on 07/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PlaylistPickerViewController : ViewController <UIPickerViewDataSource,UIPickerViewDelegate>

{
    UIPickerView *playlistPickerview;
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *playlistPickerView;
@property (nonatomic) NSArray *playlists;
@end

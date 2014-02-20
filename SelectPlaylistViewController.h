//
//  SelectPlaylistViewController.h
//  bikeBot
//
//  Created by Morten Ydefeldt on 18/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"
#import "FitModel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SelectPlaylistViewController: ViewController <UITableViewDataSource,UITableViewDelegate, MPMediaPickerControllerDelegate> {
    
}

@property (nonatomic) FitModel *fitModel;
@property (weak, nonatomic) IBOutlet UITableView *playlistTabelView;
@property (nonatomic) NSArray *playlists;
@end
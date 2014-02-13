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
#import "fitModel.h"

@interface PlaylistPickerViewController : ViewController <UITableViewDataSource,UITableViewDelegate>

{
    
}
@property (strong, nonatomic) fitModel *fitmodel;
@property (weak, nonatomic) IBOutlet UITableViewCell *playListCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
//
//  ViewController.h
//  bikeBot
//
//  Created by Morten Ydefeldt on 18/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitModel.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, FitModelDelegate>{
    
}

@property (nonatomic) FitModel *fitModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextInQueueButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *currentSongProgressBar;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak,nonatomic) NSTimer *progressTimer;
@property (weak, nonatomic) IBOutlet UIButton *currentSongButton;
@property (weak, nonatomic) IBOutlet UIButton *tempeButton;

- (IBAction)addTempo:(UIButton *)sender;
- (IBAction)subtractTempo:(UIButton *)sender;

- (IBAction)QueueButton:(UIButton *)sender;
- (IBAction)nextSongButton:(UIButton *)sender;
- (IBAction)previousSongButton:(UIButton *)sender;
- (IBAction)playPauseButton:(UIButton *)sender;

@end

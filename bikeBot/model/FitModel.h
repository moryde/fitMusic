//
//  FitModel.h
//  bikeBot
//
//  Created by Morten Ydefeldt on 18/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol FitModelDelegate;

@interface FitModel : NSObject <MPMediaPickerControllerDelegate> {
    
    
}

@property (nonatomic,strong) id <FitModelDelegate> delegate;
@property (nonatomic) MPMusicPlayerController *musicController;
@property (nonatomic) MPMediaItemCollection *mediaCollection;
@property (nonatomic) NSArray *songs;


+ (FitModel*) getInstance;


- (NSArray*) getCommentsForCurrentItem;
- (NSArray*) getSongsInQueue;

-(void) togglePlayPause;


@end

@protocol FitModelDelegate
-(void) playStateChanged:(MPMusicPlaybackState)playState;
-(void) playingItemChanged:(MPMediaItem*)songItem;
@end

//
//  fitModel.h
//  FitMusic
//
//  Created by Morten Ydefeldt on 12/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol fitDelegate;

@interface fitModel : NSObject <MPMediaPickerControllerDelegate>{
    

}

@property (nonatomic, assign) id <fitDelegate> delegate;
@property (nonatomic, strong) MPMusicPlayerController *musicController;
@property (strong, nonatomic) MPMediaPlaylist *currentPlaylist;
@property (nonatomic) MPMediaItem *currentSong;
@property (nonatomic) NSArray *playLists;

- (void) registerMediaPlayerNotifications;
- (void) startMusic;
- (void) stopMusic;

- (NSAttributedString*) songsInQueue;
- (NSString*) getNextTrack;


+(fitModel*) getInstance;

@end

@protocol fitDelegate
@required

-(void)playStateChanged:(NSString*)playString;
-(void)newInformation;

@end
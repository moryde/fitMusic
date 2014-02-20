//
//  FitModel.m
//  bikeBot
//
//  Created by Morten Ydefeldt on 18/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "FitModel.h"

@implementation FitModel

static FitModel *singletonInstance;

+ (FitModel*)getInstance {

    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    return singletonInstance;
}

-(id)init {
    
    if (self = [super init]) {
        
        self.musicController = [MPMusicPlayerController iPodMusicPlayer];
        [self registerMediaPlayerNotifications];
        [_musicController stop];

    }

    return self;
}

- (void)setMediaCollection:(MPMediaItemCollection *)mediaCollection {
    _mediaCollection = mediaCollection;
    [self.musicController setQueueWithItemCollection:mediaCollection];
    [self.musicController setShuffleMode:MPMusicShuffleModeOff];
    [self.musicController setRepeatMode:MPMusicRepeatModeAll];
    [self.musicController setNowPlayingItem:[[mediaCollection items] firstObject]];
}

-(void)registerMediaPlayerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector (nowPlayItemChanged:)
                                                 name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object: self.musicController];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector (nowPlayStateChanged:)
                                                 name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object: self.musicController];
    
    [self.musicController beginGeneratingPlaybackNotifications];
    
}

- (void) nowPlayItemChanged: (id) notification {
    
    [self.delegate playingItemChanged:_musicController.nowPlayingItem];
}


- (void) nowPlayStateChanged: (id) notification {

    [self.delegate playStateChanged:_musicController.playbackState];
}

- (void) togglePlayPause {

        if ([_musicController playbackState] == MPMusicPlaybackStatePlaying) {
            [_musicController pause];
        } else {
            [_musicController play];
        }
}


- (NSArray*)getSongsInQueue {
    
    return [_mediaCollection items];
}

- (NSArray*) getCommentsForCurrentItem {
    MPMediaItem *song = [[MPMediaItem alloc] init];
    if (self.mediaCollection) {
        if (self.musicController.playbackState == MPMusicPlaybackStatePlaying) {
            song = self.musicController.nowPlayingItem;
        }else{
            song = [[self.mediaCollection items] firstObject];
        }
        song = _musicController.nowPlayingItem;
        NSString *commentString = [song valueForProperty:MPMediaItemPropertyComments];
        NSArray *commentsPair = [commentString componentsSeparatedByString:@"&"];
        if (commentsPair.count > 1) {
            NSMutableArray *comments = [[NSMutableArray alloc] init];
            
            for (NSString *keyValuePair in commentsPair) {
                NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
                
                NSString *time = [pairComponents objectAtIndex:0];
                NSString *comment = [pairComponents objectAtIndex:1];
                
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:time,@"time",comment,@"comment", nil];
                [comments addObject:dict];
            }
            return comments;
        } else {
            if (commentString) {
                return @[@{@"comment": commentString,@"time": @"0"}];
            }else
            {
                return @[@{@"comment": @"No Comments for this song",@"time": @"0"}];
            }
        }

    }
    return nil;
}


@end

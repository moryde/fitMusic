//
//  fitModel.m
//  FitMusic
//
//  Created by Morten Ydefeldt on 12/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "fitModel.h"

@implementation fitModel

@synthesize  delegate;

static fitModel *singletonInstance;

-(id)init{
    
    if (self = [super init])
    {
        
        [self registerMediaPlayerNotifications];
        
        MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
        self.playLists = [playlistsQuery collections];
        self.musicController = [MPMusicPlayerController iPodMusicPlayer];
        
        [self.musicController stop];
        NSLog(@"Singleton Init");
    }
    return self;
    
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    NSLog(@"LOOOL");
}

+(fitModel*) getInstance {
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    
    return singletonInstance;
}

- (void)setCurrentPlaylist:(MPMediaPlaylist *)currentPlaylist {
    _currentPlaylist = currentPlaylist;
    _currentSong = [[currentPlaylist items] firstObject];
    
    [self.musicController setQueueWithItemCollection:currentPlaylist];
    [self.musicController setShuffleMode:MPMusicShuffleModeOff];
    [self.musicController setRepeatMode:MPMusicRepeatModeAll];
    [self.musicController skipToBeginning];
}

- (NSString*)getNextTrack{

    long i = _musicController.indexOfNowPlayingItem;

    if (i = -1) {
        i = 0;
    }
    
    if (i >= 0) {
        NSArray *songs = [_currentPlaylist items];
        
        if ([songs count]-1 <= i) {
            return @"NO NEXT SONG";
        }else{
            MPMediaItem *song = [_currentPlaylist.items objectAtIndex:i+1];
            return [song valueForProperty:MPMediaItemPropertyTitle];
        }
    }
    return @"Please select playlist";

}

+ (NSDictionary*)getDictonaryFromComment: (NSString*) string{
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [string componentsSeparatedByString:@"&"];
    if (urlComponents.count > 1) {
        for (NSString *keyValuePair in urlComponents)
        {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents objectAtIndex:0];
            NSString *value = [pairComponents objectAtIndex:1];
            
            [queryStringDictionary setObject:value forKey:key];
        }
        return queryStringDictionary;
    }
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:[urlComponents objectAtIndex:0],@"0", nil];
}

- (NSAttributedString*) getComments {
    
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]init];
    UIColor * color = [UIColor colorWithRed:17/255.0f green:168/255.0f blue:170/255.0f alpha:1.0f];
    NSDictionary *comments = [fitModel getDictonaryFromComment:[_currentSong valueForProperty:MPMediaItemPropertyComments]];
    if (comments.count > 0)
    {

    for (NSString *key in comments) {
        
        int i = _musicController.currentPlaybackTime;
        
        if (key.intValue > i) {
            
            NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor],NSForegroundColorAttributeName,
                                                       [UIColor grayColor], NSShadowAttributeName,
                                                       [UIFont boldSystemFontOfSize:20] ,NSFontAttributeName,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], NSShadowAttributeName, nil];
            NSString *stringWithNewLine = [NSString stringWithFormat:@"[%@ Sec] %@\n",key, [comments objectForKey:key]];
            NSAttributedString *appendString = [[NSAttributedString alloc] initWithString:stringWithNewLine attributes:navbarTitleTextAttributes];
            [as appendAttributedString:appendString];

        } else {
            NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       color,NSForegroundColorAttributeName,
                                                       [UIColor grayColor], NSShadowAttributeName,
                                                       [UIFont boldSystemFontOfSize:20] ,NSFontAttributeName,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], NSShadowAttributeName, nil];
        
            NSString *stringWithNewLine = [NSString stringWithFormat:@"[%@ Sec] %@\n",key, [comments objectForKey:key]];
            NSAttributedString *appendString = [[NSAttributedString alloc] initWithString:stringWithNewLine attributes:navbarTitleTextAttributes];
            [as appendAttributedString:appendString];
    
        }
    }
        return as;
    }
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               color,NSForegroundColorAttributeName,
                                               [UIColor grayColor], NSShadowAttributeName,
                                               [UIFont boldSystemFontOfSize:20] ,NSFontAttributeName,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], NSShadowAttributeName, nil];
    
    return [[NSAttributedString alloc] initWithString:@"No comment availible for this song, please add them in iTunes" attributes:navbarTitleTextAttributes];

    
}

- (NSAttributedString*)songsInQueue{
    
   // NSAttributedString *s = [[NSAttributedString alloc] init];
    NSMutableString *myString = [[NSMutableString alloc] init];
    
    UIColor * color = [UIColor colorWithRed:17/255.0f green:168/255.0f blue:170/255.0f alpha:1.0f];
    
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]init];

    for (MPMediaItem* song in [_currentPlaylist items]) {
        


        if ([song isEqual: [_currentPlaylist.items objectAtIndex:_musicController.indexOfNowPlayingItem]] ) {
            NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor],NSForegroundColorAttributeName,
                                                       [UIColor grayColor], NSShadowAttributeName,
                                                       [UIFont boldSystemFontOfSize:20] ,NSFontAttributeName,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], NSShadowAttributeName, nil];
            
            NSString *stringWithNewLine = [NSString stringWithFormat:@"%@\n", [song valueForProperty:MPMediaItemPropertyTitle]];
            NSAttributedString *appendString = [[NSAttributedString alloc] initWithString:stringWithNewLine attributes:navbarTitleTextAttributes];
            [as appendAttributedString:appendString];
        }else
        {
            NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       color,NSForegroundColorAttributeName,
                                                       [UIColor grayColor], NSShadowAttributeName,
                                                       [UIFont systemFontOfSize:20] ,NSFontAttributeName,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], NSShadowAttributeName, nil];
            NSString *stringWithNewLine = [NSString stringWithFormat:@"%@\n", [song valueForProperty:MPMediaItemPropertyTitle]];
            NSAttributedString *appendString = [[NSAttributedString alloc] initWithString:stringWithNewLine attributes:navbarTitleTextAttributes];
            
            [as appendAttributedString:appendString];
        }

    }
    return as;
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


-(void) nowPlayItemChanged: (id) notification{

    _currentSong = [[_currentPlaylist items]objectAtIndex: _musicController.indexOfNowPlayingItem];
    [delegate newInformation];
}

-(void) nowPlayStateChanged: (id) notification{
    if (_musicController.playbackState == MPMusicPlaybackStatePaused) {
        [delegate playStateChanged:@"Play"];
    }else {
        [delegate playStateChanged:@"Pause"];
    }
    
}

- (void) timerUpdated{
    [delegate newInformation];
}

- (void) startMusic {

    [self registerMediaPlayerNotifications];
    [_musicController play];
    NSTimer *uiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdated) userInfo:nil repeats:YES];
}

- (void) stopMusic {
    [_musicController pause];
}

@end

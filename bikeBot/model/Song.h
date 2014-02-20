//
//  Song.h
//  bikeBot
//
//  Created by Morten Ydefeldt on 18/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface Song : MPMediaItem

@property (nonatomic) NSArray *comments;

@end
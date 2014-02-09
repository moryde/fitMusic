//
//  AppDelegate.h
//  FitMusic
//
//  Created by Morten Ydefeldt on 07/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MPMediaPlaylist *playList;

@end

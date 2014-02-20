//
//  SelectPlaylistViewController.m
//  bikeBot
//
//  Created by Morten Ydefeldt on 18/02/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "SelectPlaylistViewController.h"

@interface SelectPlaylistViewController ()

@end

@implementation SelectPlaylistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.fitModel = [FitModel getInstance];
    MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
    _playlists = [playlistsQuery collections];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _playlists.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [[_playlists objectAtIndex:indexPath.row] valueForProperty:MPMediaPlaylistPropertyName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MPMediaItemCollection *collection = [_playlists objectAtIndex:indexPath.row];
    self.fitModel.mediaCollection = collection;

    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

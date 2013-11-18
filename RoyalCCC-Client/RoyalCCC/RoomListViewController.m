//
//  RoomListViewController.m
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-12.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "RoomListViewController.h"
#import "GameManager.h"
#import "AppDelegate.h"
#import "Player.h"
#import "Room.h"
#import "RoomViewController.h"
@interface RoomListViewController ()

@end

@implementation RoomListViewController

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
    // Do any additional setup after loading the view from its nib.
    


    self.rooms  = [NSMutableArray array];
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    NSString *path =  [thisBundle pathForResource:@"room" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *protosTemp =  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    for (NSDictionary *dic in protosTemp) {
        Room *room1 = [[Room alloc] initWithDict:dic];
        [self.rooms addObject:room1];
    }

    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lblCoin.text = [NSString stringWithFormat:@"%@",[GameManager sharedGameManager].player.coin];
    self.lblScore.text = [NSString stringWithFormat:@"%@",[GameManager sharedGameManager].player.score];
    
    [[GameManager sharedGameManager].player addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [[GameManager sharedGameManager].player addObserver:self forKeyPath:@"coin" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[GameManager sharedGameManager].player removeObserver:self forKeyPath:@"score"];
    [[GameManager sharedGameManager].player removeObserver:self forKeyPath:@"coin"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"coin"]) {
        self.lblCoin.text = [NSString stringWithFormat:@"%@",[GameManager sharedGameManager].player.score];
    }
    if ([keyPath isEqualToString:@"score"]) {
        self.lblScore.text = [NSString stringWithFormat:@"%@",[GameManager sharedGameManager].player.score];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    [[GameManager sharedGameManager] logout:^{
        AppDelegate *del =[[UIApplication sharedApplication] delegate];
        [del.navController popViewControllerAnimated:YES];
    }];
}
- (IBAction)enterRoom:(UIButton *)sender {
    //Room *room = [self.rooms objectAtIndex:indexPath.row];
    
    NSString *roomkey = nil;
    if (sender == self.btn2people) {
        roomkey = @"room2";
    }else if (sender == self.btn3people){
        roomkey = @"room3";
    }else{
        roomkey = @"room5";
    }
    [[GameManager sharedGameManager]enterRoom:roomkey andSuccess:^(RoomViewController *roomPh){
        AppDelegate *del =[[UIApplication sharedApplication] delegate];
        [del.navController pushViewController:roomPh animated:NO];
    }];
}




@end

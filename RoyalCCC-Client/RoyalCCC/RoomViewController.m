//
//  RoomViewController.m
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-13.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "RoomViewController.h"
#import "GameManager.h"
#import "AppDelegate.h"
#import "PlayerInfoView.h"
#import "RoomControl.h"
#import "AnswerCellView.h"
#import "GameOverView.h"
#import "Player.h"
#import "RoomPlayer.h"
@implementation RoomViewController




- (void)addPlayer:(Player *)pl andRoomPlayer:(RoomPlayer *)rpl andSeat:(NSString *)seat{
    NSString *tepStr =[NSString stringWithFormat:@"player%@",seat];
    PlayerInfoView *pv = [self valueForKey:tepStr];
    pv.hidden  = NO;
    [pv updateInfo:pl andRoomPlayer:rpl];
}

- (void)removePlayerAtSeat:(NSString *)seat{
    NSString *tepStr =[NSString stringWithFormat:@"player%@",seat];
    PlayerInfoView *pv = [self valueForKey:tepStr];
    pv.hidden  = YES;
}
- (void)updatePlayerInfoView:(RoomPlayer *)roomPlayer{
    NSString *tepStr =[NSString stringWithFormat:@"player%@",roomPlayer.seat];
    PlayerInfoView *pv = [self valueForKey:tepStr];
    pv.hidden  = NO;
    [pv updateInfo:nil andRoomPlayer:roomPlayer];
}
- (void)showQuestion:(NSDictionary *)dic{
    self.lblQuestion.hidden = NO;
    self.lblQuestion.text = [dic objectForKey:@"question"];
    [self.answerA updateInfo:[dic objectForKey:@"answerA"] andTag:[dic objectForKey:@"tagA"]];
    [self.answerB updateInfo:[dic objectForKey:@"answerB"] andTag:[dic objectForKey:@"tagB"]];
    [self.answerC updateInfo:[dic objectForKey:@"answerC"] andTag:[dic objectForKey:@"tagC"]];
    [self.answerD updateInfo:[dic objectForKey:@"answerD"] andTag:[dic objectForKey:@"tagD"]];
}


- (IBAction)exitRoom:(id)sender { 
    [[GameManager sharedGameManager] exitRoomSuccess:^{
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app.navController popViewControllerAnimated:YES];
    }];
    
}
- (IBAction)clickHelp:(UIButton *)sender {
//    self.btnDaAn.tag = 1;
//    self.btnChuCuo.tag = 2;
//    self.btnJiaXue.tag = 3;
//    self.btnPass.tag = 4;
//    self.btnZheDang.tag = 5;
    [[GameManager sharedGameManager].roomControl userHelp:@1 success:^{
        NSLog(@"使用道具成功");
    }];
    [self disableHelpBtn];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.player1 = [PlayerInfoView createPlayerInfoIsLeft:YES];
        [self.player1 setFrame:CGRectMake(2, 164, 72, 56)];
        [self.view insertSubview:self.player1 atIndex:5];
        
        
        self.player2 = [PlayerInfoView createPlayerInfoIsLeft:NO];
        [self.player2 setFrame:CGRectMake(238, 164, 72, 56)];
        [self.view insertSubview:self.player2 atIndex:5];

        
        self.player3 = [PlayerInfoView createPlayerInfoIsLeft:YES];
        [self.player3 setFrame:CGRectMake(2, 258, 72, 56)];
        [self.view insertSubview:self.player3 atIndex:5];

        
        
        self.player4 = [PlayerInfoView createPlayerInfoIsLeft:NO];
        [self.player4 setFrame:CGRectMake(238, 258, 72, 56)];
        [self.view insertSubview:self.player4 atIndex:5];

        

        self.player0 = [PlayerInfoView createPlayerInfoIsLeft:YES];
        [self.player0 setFrame:CGRectMake(120, 347, 72, 56)];
        [self.view insertSubview:self.player0 atIndex:5];
        
        self.answerA = [AnswerCellView createView];
        [self.answerA setFrame:CGRectMake(56, 145, 208, 48)];
        [self.view addSubview:self.answerA];
        
        self.answerB = [AnswerCellView createView];
        [self.answerB setFrame:CGRectMake(56, 195, 208, 48)];
        [self.view addSubview:self.answerB];
        
        self.answerC = [AnswerCellView createView];

        [self.answerC setFrame:CGRectMake(56, 245, 208, 48)];
        [self.view addSubview:self.answerC];
        
        self.answerD = [AnswerCellView createView];
        
        [self.answerD setFrame:CGRectMake(56, 295, 208, 48)];
        [self.view addSubview:self.answerD];
        
        
        self.btnDaAn.tag = 1;
        self.btnChuCuo.tag = 2;
        self.btnJiaXue.tag = 3;
        self.btnPass.tag = 4;
        self.btnZheDang.tag = 5;
        
    }
    return self;
}

- (void)disableAnswerBtn{
    self.answerA.btnAnswer.enabled = NO;
    self.answerB.btnAnswer.enabled = NO;
    self.answerC.btnAnswer.enabled = NO;
    self.answerD.btnAnswer.enabled = NO;
}
- (void)enableAnswerBtn{
    self.answerA.btnAnswer.enabled = YES;
    self.answerB.btnAnswer.enabled = YES;
    self.answerC.btnAnswer.enabled = YES;
    self.answerD.btnAnswer.enabled = YES;
}

- (void)disableHelpBtn{
    self.btnChuCuo.enabled = NO;
    self.btnDaAn.enabled = NO;
    self.btnJiaXue.enabled = NO;
    self.btnPass.enabled = NO;
    self.btnZheDang.enabled = NO;
}
- (void)enableHelpBtn{
    self.btnChuCuo.enabled = YES;
    self.btnDaAn.enabled = YES;
    self.btnJiaXue.enabled = YES;
    self.btnPass.enabled = YES;
    self.btnZheDang.enabled = YES;
}

- (void)endGame:(NSArray *)paiming{
    self.answerA.hidden = YES;
    self.answerB.hidden = YES;
    self.answerC.hidden = YES;
    self.answerD.hidden = YES;
    self.lblQuestion.text = @"";
    GameOverView *gameOverView = [GameOverView createView:paiming];
    [gameOverView setCenter:CGPointMake(160, 240)];
    [self.view addSubview:gameOverView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.answerA.delegate = [GameManager sharedGameManager].roomControl;
    self.answerB.delegate = [GameManager sharedGameManager].roomControl;
    
    self.answerC.delegate = [GameManager sharedGameManager].roomControl;
    self.answerD.delegate = [GameManager sharedGameManager].roomControl;
    
    self.lblCoin.text = [NSString stringWithFormat:@"%@",[GameManager sharedGameManager].player.coin];
    
    
    self.lblScore.text = [NSString stringWithFormat:@"%@",[GameManager sharedGameManager].player.score];
    [[GameManager sharedGameManager].player addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [[GameManager sharedGameManager].player addObserver:self forKeyPath:@"coin" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];


}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"coin"]) {
        self.lblCoin.text = [NSString stringWithFormat:@"%@",[GameManager sharedGameManager].player.coin];
    }
    if ([keyPath isEqualToString:@"score"]) {
        self.lblScore.text = [NSString stringWithFormat:@"%@",[GameManager sharedGameManager].player.score];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[GameManager sharedGameManager].player removeObserver:self forKeyPath:@"score"];
    [[GameManager sharedGameManager].player removeObserver:self forKeyPath:@"coin"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end

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
- (void)endGame:(NSArray *)paiming{
    self.answerA.hidden = YES;
    self.answerB.hidden = YES;
    self.answerC.hidden = YES;
    self.answerD.hidden = YES;
    self.lblQuestion.text = @"";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.answerA.delegate = [GameManager sharedGameManager].roomControl;
    self.answerB.delegate = [GameManager sharedGameManager].roomControl;
    
    self.answerC.delegate = [GameManager sharedGameManager].roomControl;
    self.answerD.delegate = [GameManager sharedGameManager].roomControl;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSArray *players = [GameManager sharedGameManager].roomControl.players;
//    self.player1 = [PlayerInfoView createPlayerInfoView:nil];
    // Do any additional setup after loading the view from its nib.
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

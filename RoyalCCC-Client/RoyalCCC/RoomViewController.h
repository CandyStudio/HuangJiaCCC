//
//  RoomViewController.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-13.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayerInfoView;
@class Player;
@class RoomPlayer;
@class AnswerCellView;
@interface RoomViewController : UIViewController
@property (strong, nonatomic)  PlayerInfoView *player1;
@property (strong, nonatomic)  PlayerInfoView *player2;
@property (strong, nonatomic)  PlayerInfoView *player3;
@property (strong, nonatomic)  PlayerInfoView *player4;
@property (strong, nonatomic)  PlayerInfoView *player0;
@property (strong, nonatomic)  AnswerCellView *answerA;
@property (strong, nonatomic)  AnswerCellView *answerB;
@property (strong, nonatomic)  AnswerCellView *answerC;
@property (strong, nonatomic)  AnswerCellView *answerD;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UILabel *lblCoin;
- (void)addPlayer:(Player *)pl andRoomPlayer:(RoomPlayer *)rpl andSeat:(NSString *)seat;
- (void)removePlayerAtSeat:(NSString *)seat;
- (void)showQuestion:(NSDictionary *)dic;

- (void)updatePlayerInfoView:(RoomPlayer *)roomPlayer;



- (void)disableAnswerBtn;
- (void)enableAnswerBtn;
- (void)endGame:(NSArray *)paiming;
@end

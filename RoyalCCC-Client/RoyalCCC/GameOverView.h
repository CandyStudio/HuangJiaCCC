//
//  GameOverView.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-16.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOverView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer1;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer3;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer4;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer5;

+ (GameOverView *)createView:(NSArray *)player;
- (void)showPlayer:(NSArray *)players;

@end

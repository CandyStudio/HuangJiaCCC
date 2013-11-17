//
//  PlayerInfoView.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-15.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;
@class RoomPlayer;
@interface PlayerInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageHp;
@property (weak, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imagebg;
@property (assign, nonatomic) BOOL isLeft;

+ (PlayerInfoView *)createPlayerInfoIsLeft:(BOOL)is;
- (void)updateInfo:(Player *)dict andRoomPlayer:(RoomPlayer *)roomPlayer;
@end

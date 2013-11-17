//
//  Player.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-12.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//


#import  "BasicModel.h"
@interface Player : BasicModel
@property (nonatomic,strong)NSNumber *playerid;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,strong)NSNumber *coin;
@property (nonatomic,strong)NSNumber *score;
@end

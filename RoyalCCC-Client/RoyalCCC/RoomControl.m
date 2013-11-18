//
//  RoomControl.m
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-14.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "RoomControl.h"
#import "RoomViewController.h"
#import "Player.h"
#import "GameManager.h"
#import "PomeloClient.h"
#import "RoomPlayer.h"
@implementation RoomControl


- (RoomControl *)initAndMakeView:(RoomViewController **)viewController  andRoomInfo:(NSDictionary *)info{
    if (self = [super init]) {
        NSLog(@"%@",info);
        self.players = [NSMutableDictionary dictionaryWithCapacity:5];
        self.roomPlayers = [NSMutableDictionary dictionaryWithCapacity:5];
        if (viewController) {
            *viewController = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:nil];
            _roomController = *viewController;
        }
        self.seatDict = [NSMutableDictionary dictionaryWithCapacity:5];
        NSDictionary *playersDict = [info objectForKey:@"players"];
        [playersDict enumerateKeysAndObjectsUsingBlock:^(NSString *playerid, NSDictionary *pDic, BOOL *stop) {
            Player *temPlayer = [[Player alloc] initWithDict:pDic];
            [self.players setObject:temPlayer forKey:[NSString stringWithFormat:@"%@",playerid]];
            
        }];
        NSDictionary *roomplayersDict = [info objectForKey:@"roomplayers"];
        __block int index = 0;
        
        [roomplayersDict enumerateKeysAndObjectsUsingBlock:^(NSString *playerid, NSDictionary *pDic, BOOL *stop) {
            RoomPlayer *temPlayer = [[RoomPlayer alloc] initWithDict:pDic];
            [self.roomPlayers setObject:temPlayer forKey:[NSString stringWithFormat:@"%@",playerid]];
            if ([temPlayer.playerid intValue] != [[GameManager sharedGameManager].player.playerid intValue]) {
                //不是自己
                temPlayer.seat = [NSString stringWithFormat:@"%d",++index];
            }else{
                temPlayer.seat = @"0";
            }
            [self.seatDict setObject:temPlayer.playerid forKey:temPlayer.seat];
            
            [_roomController addPlayer:[self.players objectForKey:[NSString stringWithFormat:@"%@",temPlayer.playerid] ] andRoomPlayer:temPlayer andSeat:temPlayer.seat];
        }];
        
        
        NSLog(@"加route 之前");
        [self addRote];
                    NSLog(@"加route 之后");
        NSLog(@"%@",self.players);
        NSLog(@"%@",self.roomPlayers);
    }
    return self;
}

- (void)addRote{
    NSLog(@"加Rote");
    [[GameManager sharedGameManager].pomelo onRoute:@"onRoomEnter" withCallback:^(id arg) {
        NSDictionary *tPlayer = [arg objectForKey:@"player"];
        NSDictionary *trp = [arg objectForKey:@"roomplayer"];
        Player *p = [[Player alloc] initWithDict:tPlayer];
        RoomPlayer *rp = [[RoomPlayer alloc] initWithDict:trp];
        [self.players setObject:p forKey:[NSString stringWithFormat:@"%@",p.playerid]];
        [self.roomPlayers setObject:rp forKey:[NSString stringWithFormat:@"%@",rp.playerid]];
        NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
        [self.seatDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *tstr = nil;
            for (NSString *s in tempArr) {
                if ([s isEqualToString:key]) {
                    tstr = s;
                }
            }
            [tempArr removeObject:tstr];
        }];
        NSString *theSeat = [tempArr firstObject];
        rp.seat = theSeat;
        [self.seatDict setObject:rp.playerid forKey:theSeat];
        [_roomController addPlayer:p andRoomPlayer:rp andSeat:theSeat];
        
        NSLog(@"进入房间 : %@",arg);
        NSLog(@"%@",self.players);
        NSLog(@"%@",self.roomPlayers);
    }];
    [[GameManager sharedGameManager].pomelo onRoute:@"onRoomExit" withCallback:^(id arg) {
        NSString *pid = [NSString stringWithFormat:@"%@",[arg objectForKey:@"playerid"]];
        RoomPlayer *rp = [self.roomPlayers objectForKey:pid];
        [self.players removeObjectForKey:pid];
        [self.roomPlayers removeObjectForKey:pid];
        [self.seatDict removeObjectForKey:rp.seat];
        NSLog(@"onRoomExit  :%@",arg);
        NSLog(@"%@",self.players);
        NSLog(@"%@",self.roomPlayers);
        [_roomController removePlayerAtSeat:rp.seat];
    }];
    [[GameManager sharedGameManager].pomelo onRoute:@"onQuestion" withCallback:^(id arg) {
        [_roomController enableAnswerBtn];
        NSLog(@"onQuestion  :%@",arg);
        
        NSString *questionId =  [NSString stringWithFormat:@"%@",[arg objectForKey:@"questionid"]];
        NSNumber *answerid = [arg objectForKey:@"answerid"];
        NSDictionary *quesiton = [[GameManager sharedGameManager].qusetionDict objectForKey:questionId];
        
        NSMutableArray *ranArr = [NSMutableArray arrayWithObjects:@{@"tag": answerid,
                                                                    @"answer":[quesiton objectForKey:@"answer"]},
                                  @{@"tag": @0,
                                    @"answer":[quesiton objectForKey:@"Error1"]},
                                  @{@"tag": @0,
                                    @"answer":[quesiton objectForKey:@"Error2"]},
                                  @{@"tag": @0,
                                    @"answer":[quesiton objectForKey:@"Error3"]},nil];
        NSLog(@"%@",ranArr);
        for (int i = 3; i>=0 ; i--) {
            int rint = arc4random()%(i+1);
            NSDictionary *td = [ranArr objectAtIndex:i];
            [ranArr replaceObjectAtIndex:i withObject:[ranArr objectAtIndex:rint]];
            [ranArr replaceObjectAtIndex:rint withObject:td];
        }
        NSLog(@"%@",ranArr);
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[quesiton objectForKey:@"question"],@"question",
                              [[ranArr objectAtIndex:0] objectForKey:@"answer"],@"answerA",
                              [[ranArr objectAtIndex:0] objectForKey:@"tag"],@"tagA",
                              [[ranArr objectAtIndex:1] objectForKey:@"answer"],@"answerB",
                              [[ranArr objectAtIndex:1] objectForKey:@"tag"],@"tagB",
                              [[ranArr objectAtIndex:2] objectForKey:@"answer"],@"answerC",
                              [[ranArr objectAtIndex:2] objectForKey:@"tag"],@"tagC",
                              [[ranArr objectAtIndex:3] objectForKey:@"answer"],@"answerD",
                              [[ranArr objectAtIndex:3] objectForKey:@"tag"],@"tagD",
                              nil];
        [_roomController showQuestion:info];
    }];
    [[GameManager sharedGameManager].pomelo onRoute:@"onAnswer" withCallback:^(id arg) {
        NSLog(@"onAnswer  :%@",arg);
        [self updateTablePlayers:[arg objectForKey:@"players"]];
    }];
    
    [[GameManager sharedGameManager].pomelo onRoute:@"onHelp" withCallback:^(id arg) {
        NSLog(@"onHelp  :%@",arg);
        [self updateTablePlayers:[arg objectForKey:@"players"]];
    }];
    [[GameManager sharedGameManager].pomelo onRoute:@"onGemeover" withCallback:^(id arg) {
        NSLog(@"onGemeover  :%@",arg);
        NSDictionary *players = [arg objectForKey:@"players"];
        NSArray *playerarr = [players allValues];
        NSLog(@"playerarr :%@",playerarr);
        NSArray *sortPlayers =  [playerarr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            int ps1 = [[obj1 objectForKey:@"score"] intValue];
            int ps2 = [[obj2 objectForKey:@"score"] intValue];
            if (ps1 > ps2) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        NSLog(@"sortPlayers : %@",sortPlayers);
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0,length = sortPlayers.count; i < length; i++) {
            NSString *username = [[sortPlayers objectAtIndex:i] objectForKey:@"username"];
            if (!username) {
                Player *tplayer = [self.players objectForKey:[NSString stringWithFormat:@"%@",[[sortPlayers objectAtIndex:i] objectForKey:@"playerid"]] ];
                username = tplayer.username;
            }

            NSString *srt = [NSString stringWithFormat:@"%@  %@",username ,[[sortPlayers objectAtIndex:i] objectForKey:@"score"]];
            [result addObject:srt];
        }
        NSLog(@"%@",result);
        [_roomController endGame:result];
    }];
    
    [[GameManager sharedGameManager].pomelo onRoute:@"onGameStart" withCallback:^(id arg) {
        [[GameManager sharedGameManager] showAlert:@"开始游戏"];
        [self updateTablePlayers:[arg objectForKey:@"players"]];
    }];
}
- (void)offRote{
        NSLog(@"offRote");
    [[GameManager sharedGameManager].pomelo offRoute:@"onRoomEnter"];
    [[GameManager sharedGameManager].pomelo offRoute:@"onRoomExit"];
    [[GameManager sharedGameManager].pomelo offRoute:@"onQuestion"];
    [[GameManager sharedGameManager].pomelo offRoute:@"onAnswer"];
    [[GameManager sharedGameManager].pomelo offRoute:@"onAnswer"];
    [[GameManager sharedGameManager].pomelo offRoute:@"onHelp"];
    [[GameManager sharedGameManager].pomelo offRoute:@"onGemeover"];
    [[GameManager sharedGameManager].pomelo offRoute:@"onGameStart"];

}


- (void)updateTablePlayers:(NSDictionary *)dict{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *playerId = [NSString stringWithFormat:@"%@",key];
        RoomPlayer *trp = [self.roomPlayers objectForKey:playerId];
        [trp update:obj];
        
        
        [_roomController updatePlayerInfoView:trp];
    }];
}


- (void)answerClick:(NSNumber *)tag{
    
    [_roomController disableAnswerBtn];
    if (!tag) {
        tag = [NSNumber numberWithInt:0];
    }
    
    
    [[GameManager sharedGameManager].pomelo requestWithRoute:@"room.roomHandler.answer" andParams:@{@"answerid": tag} andCallback:^(id arg) {
        if ([[arg objectForKey:@"code"] intValue]== 200) {
            NSLog(@"回答正确");
            [[GameManager sharedGameManager] showAlert:@"回答正确"];
        }else{
            [[GameManager sharedGameManager] showAlert:[arg objectForKey:@"desc"]];
        }
    }];
    
}



- (void)dealloc{
//    [self offRote];
    NSLog(@"%s",__FUNCTION__);
}
@end

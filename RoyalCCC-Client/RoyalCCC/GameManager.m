//
//  GameNanager.m
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-12.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "GameManager.h"
#import "PomeloClient.h"
#import "Player.h"
#import "AppDelegate.h"
#import "RoomControl.h"
@interface GameManager(){

}
@end
@implementation GameManager

+ (GameManager *)sharedGameManager
{
    static dispatch_once_t onceToken;
    static GameManager *_gameManager = nil;
    dispatch_once(&onceToken, ^{
        _gameManager = [[self alloc] init];
        
    });
    return _gameManager;
    
}


- (GameManager *)init{
    if (self = [super init]) {
        self.pomelo = [[PomeloClient alloc] initWithDelegate:self];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        _scheduleDict = [NSMutableDictionary dictionaryWithCapacity:10];
        NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
        self.qusetionDict = [NSMutableDictionary dictionary];
        
        
        NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
        NSString *path =  [thisBundle pathForResource:@"question" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSArray *protosTemp =  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [protosTemp enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [self.qusetionDict setObject:obj forKey:[NSString stringWithFormat:@"%@",[obj objectForKey:@"id"]]];
        }];
        
        [self.pomelo onRoute:@"onPlayerInfo" withCallback:^(id arg) {
            [self upDatePlayer:[arg objectForKey:@"player"]];
        }];
        
    }
    return self;
}
- (void)dealloc{
    [self.pomelo offRoute:@"onPlayerInfo"];
}
- (void)update{
    NSArray *allSce = [_scheduleDict allValues];
    [allSce enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ScheduldBloc blcok = obj;
        blcok();
    }];
}

- (void)upDatePlayer:(NSDictionary *)dict{
    if (self.player) {
        [self.player update:dict];
    }else{
        self.player = [[Player alloc] initWithDict:dict];
    }
}


- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andSuccsess:(void(^)())succ{
    if (username.length>0 && password.length>0) {
        [self.pomelo connectToHost:@"10.0.1.8" onPort:@"3010" params:@{@"username": username,@"password":password} withCallback:^(id arg) {
            if ([[arg objectForKey:@"code"]intValue] == 200) {
                [[GameManager sharedGameManager] upDatePlayer:[arg objectForKey:@"player"]];
                [self.pomelo requestWithRoute:@"connector.entryHandler.entry" andParams:@{@"playerid": self.player.playerid} andCallback:^(id arg1) {
                    if ([[arg1 objectForKey:@"code"]intValue] == 200) {
                        succ();
                    }else{
                        [self showAlert:[arg1 objectForKey:@"desc"]];
                        [self.pomelo disconnect];
                    }
                }];
            }
            else{
                [self showAlert:[arg objectForKey:@"desc"]];
            }
        }]; 
    
    }else{
        [self showAlert:@"输入错误"];
    }
}
- (void)logout:(void(^)())succ{
    [self.pomelo disconnectWithCallback:^(id arg) {
        self.player = nil;
        succ();
    }];
}


- (void)enterRoom:(NSString *)roomid andSuccess:(void(^)(id))succ{
    [self.pomelo notifyWithRoute:@"room.roomHandler.roomEnter" andParams:@{@"roomid": roomid}];
    [self.pomelo onRoute:@"onRoomInfo" withCallback:^(id arg) {
        if ([[arg objectForKey:@"code"] intValue] == 200) {
            id roomController = nil;
            self.roomControl = [[RoomControl alloc] initAndMakeView:&roomController andRoomInfo:arg];
            succ(roomController);
        }else{
            [self showAlert:[arg objectForKey:@"desc"]];
        }
        [self.pomelo offRoute:@"onRoomInfo"];
    }];
}
- (void)exitRoomSuccess:(void(^)())succ{
    [self.pomelo requestWithRoute:@"room.roomHandler.roomExit" andParams:[NSDictionary dictionary] andCallback:^(id arg) {
        if ([[arg objectForKey:@"code"] intValue] == 200) {
            [self.roomControl offRote];
            self.roomControl = nil;
            succ();
        }else{
            [self showAlert:[arg objectForKey:@"desc"]];
        }

    }];
}

- (void)showAlert:(NSString *)info{
    UIAlertView *laer = [[UIAlertView alloc] initWithTitle:@"提示" message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [laer show];
}


- (void)addScheduleForKey:(NSString *)key andSchedule:(ScheduldBloc)sch{
    [_scheduleDict setObject:sch forKey:key];
}


- (void)removerScheduleForKey:(NSString *)key{
    [_scheduleDict removeObjectForKey:key];
}


- (void)removeAllSchedule{
    [_scheduleDict removeAllObjects];
}



#pragma mark -
#pragma nark pomelo delegate

- (void)pomeloDisconnect:(PomeloClient *)pomelo withError:(NSError *)error{
    AppDelegate *del =[[UIApplication sharedApplication] delegate];
    [del.navController popToRootViewControllerAnimated:YES];
}

@end

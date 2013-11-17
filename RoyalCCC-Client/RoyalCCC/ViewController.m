//
//  ViewController.m
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-12.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "ViewController.h"
#include "GameManager.h"

#include "RoomListViewController.h"
#include "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtPassword.delegate = self;
    self.txtUsername.delegate = self;
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    self.txtPassword.text = password;
    self.txtUsername.text = username;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender{

    [[GameManager sharedGameManager] loginWithUsername:self.txtUsername.text andPassword:self.txtPassword.text andSuccsess:^{
        RoomListViewController *roomPh = [[RoomListViewController alloc] initWithNibName:@"RoomListViewController" bundle:nil];
        AppDelegate *del =[[UIApplication sharedApplication] delegate];
        [del.navController pushViewController:roomPh animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:self.txtUsername.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:@"password"];
    }];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtUsername) {
        return [self.txtPassword becomeFirstResponder];
    }
    [self login:nil];
    [textField resignFirstResponder];
    return YES;
}

@end

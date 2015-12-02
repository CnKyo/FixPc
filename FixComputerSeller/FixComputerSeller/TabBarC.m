//
//  TabBarC.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/19.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "TabBarC.h"

@interface TabBarC ()

@end

@implementation TabBarC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = M_CO;
    
    [self getData];
}
- (void)getData{
    [[SUser currentUser] getMsgStatus:^(SResBase *resb, BOOL bhavenew) {
        if (resb.msuccess) {
            [self setBadgeValue:@"1" atTabIndex:1];
            MLLog(@"%@",resb.mmsg);
        }
        else{
        
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setBadgeValue:(NSString*)val atTabIndex:(int)index

{
    
    // UITabBarItem* tab = [ objectAtIndex:2*index];
    
    UITabBarItem* tab = [[self.tabBar items] objectAtIndex:index];
    
    if ([val integerValue] <= 0) {
        
        tab.badgeValue = nil;
        
    }
    
    else
        
    {
        
        tab.badgeValue = val;
        
    }
    
}




-(NSString*)getBadgeValueAtIndex:(int)index

{
    
    UITabBarItem* tab = [[self.tabBar items] objectAtIndex:index];
    
    return tab.badgeValue;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

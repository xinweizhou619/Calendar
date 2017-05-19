//
//  ViewController.m
//  XWZCalendar
//
//  Created by XinWeizhou on 2017/5/18.
//  Copyright © 2017年 XinWeizhou. All rights reserved.
//

#import "ViewController.h"
#import "XWZCalenderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    XWZCalenderView *calendar = [[XWZCalenderView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    calendar.backgroundColor = [UIColor grayColor];
    [self.view addSubview:calendar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

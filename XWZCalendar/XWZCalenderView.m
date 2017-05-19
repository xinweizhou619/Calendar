//
//  XWZCalenderView.m
//  XWZCalendar
//
//  Created by XinWeizhou on 2017/5/18.
//  Copyright © 2017年 XinWeizhou. All rights reserved.
//

#import "XWZCalenderView.h"
#import "UIView+Extension.h"
@interface XWZCalenderView()
@property(nonatomic,strong) NSArray *weekNames;
@property(nonatomic,strong) UIButton *middelBtn;
@property(nonatomic,strong) UIView *daysView;
@property(nonatomic,strong) NSDate *date;
@end
@implementation XWZCalenderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (UIView *)daysView {
    if (_daysView == nil) {
        _daysView = [UIView new];
        [self addSubview:_daysView];
        _daysView.backgroundColor = [UIColor greenColor];
    }
    return _daysView;
}
- (NSArray *)weekNames {
    if (_weekNames == nil) {
        _weekNames = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    }
    return _weekNames;
}
- (void)setUp {
    CGFloat width = self.frame.size.width/3.0;
    CGFloat height = 30;
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    leftBtn.tag = 0;
    [leftBtn setTitle:@"previous" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self addSubview:leftBtn];
    
    UIButton *middleBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftBtn.maxX, 0, width, height)];
    middleBtn.tag = 1;
    [middleBtn setTitle:@"now" forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [middleBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self addSubview:middleBtn];
    self.middelBtn = middleBtn;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(middleBtn.maxX, 0, width, height)];
    rightBtn.tag = 2;
    [rightBtn setTitle:@"next" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self addSubview:rightBtn];
    
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Vilnius"]];
    
    [self setWeek];
    
    [self btnClicked:middleBtn];
    
    
}
- (void)reloadWithDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [self.middelBtn setTitle:[NSString stringWithFormat:@"%ld年%ld月",components.year,components.month] forState:UIControlStateNormal];
    
    
    NSInteger index = [self indexInWeekForDate:date];
    NSInteger days = [self totaldaysInMonthForDate:date];
    NSInteger numberOfWeeks = [self numberOfWeeksInCurrentMonthForDate:date];
    NSInteger totalCell = numberOfWeeks * 7;
    
    
    CGFloat width = self.width/7.0;
    self.daysView.frame = CGRectMake(0, 80, self.width, width*numberOfWeeks);
    [self.daysView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger column = 0;
    NSInteger row = 0;
    
    
    NSDateComponents *componentsNow = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    if (components.year == componentsNow.year && components.month == componentsNow.month) {
        for (int i = 0; i < totalCell; i++) {
            column = i%7;
            row = i/7;
            if (i + 1 >= index && i + 1 < days + index) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(column * width, row * width, width, width)];
                label.text = [NSString stringWithFormat:@"%ld",i - index + 2];
                label.textAlignment = NSTextAlignmentCenter;
                [self.daysView addSubview:label];
                
                if (i - index + 2 == componentsNow.day) {
                    label.backgroundColor = [UIColor redColor];
                    label.layer.cornerRadius = width*0.5;
                    label.layer.masksToBounds = YES;
                }
            }
            
        }

    } else {
        for (int i = 0; i < totalCell; i++) {
            column = i%7;
            row = i/7;
            if (i + 1 >= index && i + 1 < days + index) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(column * width, row * width, width, width)];
                label.text = [NSString stringWithFormat:@"%ld",i - index + 2];
                label.textAlignment = NSTextAlignmentCenter;
                [self.daysView addSubview:label];
            }
            
        }

    }
    
}

// 设置一周视图
- (void)setWeek {
    UIView *volumn = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.width, 30)];
    [self addSubview:volumn];
    volumn.backgroundColor = [UIColor redColor];
    
    CGFloat x = 0;
    CGFloat width = volumn.width/self.weekNames.count;
    for (int i = 0; i < self.weekNames.count; i++) {
        x = i * width;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width, volumn.height)];
        label.text = self.weekNames[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [volumn addSubview:label];
    }

//    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Vilnius"]];
//    NSTimeZone *defaultTimeZone = [NSTimeZone defaultTimeZone];
//    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    
}

- (NSInteger)totaldaysInMonthForDate:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date]; // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的范围
    return daysInOfMonth.length;
}

- (NSInteger)indexInWeekForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSLog(@"FirstWeekday = %ld",calendar.firstWeekday);//默认值 是 1。
    [calendar setFirstWeekday:1];

    NSLog(@"date = %@",date); // 如果是5月31号21:00到6.1号21点（不包括）
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSLog(@"dateComponet = %ld",comp.day);// 打印结果是1，component 是6.1
    
    // newDate
    NSDate *newDate = [calendar dateFromComponents:comp];
    NSLog(@"newDate = %@",newDate);// 这里的结果会是5月31号 21:00:00 +0000
    
    // 设置为这个月的第一天
    [comp setDay:1]; // 把comp的day属性设置为一号，即comp是6月1号
    NSLog(@"dateComponet = %ld",comp.day);// 打印结果是1
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSLog(@"date = %@",firstDayOfMonthDate);// 05-31 21:00:00 +0000
    
    // 经测试firstDayOfMonthDate 取值在2017-04-40 21:00:00 +0000 ~ 2017-05-01 21:00:00 +0000（不包括）之间，下面方法返回结果都一样。date会加3个小时，变成6月份的日历。
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的顺序位置（索引值）
    
    // 这里值是2，因为前面设置的周日是第一位置，所以这里的索引2，对应的应该是周一。
    NSLog(@"firstWeekday = %ld",firstWeekday);
    
    
    // 当前时间对应的周是当前年中的第几周
    [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:[NSDate date]];
    
    return firstWeekday;
    
    
}

- (NSUInteger)numberOfWeeksInCurrentMonthForDate:(NSDate *)date {
    NSInteger days = [self totaldaysInMonthForDate:date];
    NSInteger index = [self indexInWeekForDate:date];
    
    NSInteger weeks = 0;
    weeks += 1;
    days = days - (7 - index + 1);
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    return weeks;
}


- (void)btnClicked:(UIButton *)btn {
    
    if (btn.tag == 0) {
        self.date = [self lastMonthDate:self.date];
    } else if (btn.tag == 1) {
        self.date = [NSDate date];
    } else {
        self.date = [self nextMonthDate:self.date];
    }

    [self reloadWithDate:self.date];
}

#pragma mark 获取左右两个月的中间日期

- (NSDate *)lastMonthDate:(NSDate*)date {
    NSDateComponents *components = [self nearByDateComponents:date]; // 定位到当月中间日子
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    } else {
        components.month -= 1;
    }
    NSDate *lastDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return lastDate;
}
- (NSDate *)nextMonthDate:(NSDate*)date {
    NSDateComponents *components = [self nearByDateComponents:date]; // 定位到当月中间日子
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    } else {
        components.month += 1;
    }
    NSDate *nextDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return nextDate;
}


- (NSDateComponents *)nearByDateComponents:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.day = 15; // 定位到当月中间日子
    return components;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

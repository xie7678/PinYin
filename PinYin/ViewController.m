//
//  ViewController.m
//  PinYin
//
//  Created by sam on 17/2/16.
//  Copyright © 2016年 xie. All rights reserved.
//

#import "ViewController.h"
#import "cityObj.h"
#import "ICConvert.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cityMA;
@property (nonatomic, strong) NSMutableArray *cityIC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cityIC = [NSMutableArray array];
    //    [self onGetData];
//    typedef myself(self) = self;
    __weak typeof(self) mySelf = self;
    [self onGetData:^(NSArray *array) {
        if (array.count != 0) {
            [ICConvert convertToICPinyinFlagWithArray:self.cityMA key:@"name" UsingBlock:^(NSArray *array) {
                for (ICPinyinFlag *ip in array) {
                    [self.cityIC addObject:ip];
                }
                [mySelf.tableView reloadData];
            }];
            
        }
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void) onGetData:(void(^) (NSArray *array))array {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    _cityMA = [NSMutableArray array];
    NSArray *cityA = [file componentsSeparatedByString:@"\n"];
    for (NSString *city in cityA) {
        NSArray * arr = [city componentsSeparatedByString:@","];
        cityObj *cityO = [[cityObj alloc] init];
        cityO.name = arr[0];
        cityO.code = [arr[1] intValue];
        [_cityMA addObject:cityO];
    }
    array(_cityMA);
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityIC.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ICPinyinFlag *icP = self.cityIC[section];
    return icP.contents.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell" forIndexPath:indexPath];
    ICPinyinFlag *icp = self.cityIC[indexPath.section];
    NSString *name = icp.contents[indexPath.row];
    cityObj *ci = [self onGetCityOb:name];
    cell.textLabel.text = [NSString stringWithFormat:@"%@,%d",ci.name,ci.code];
    return cell;
}
-(cityObj *) onGetCityOb: (NSString *)name{
    cityObj *cityO = [[cityObj alloc] init];
    for (cityObj * city in self.cityMA) {
        if (name == city.name) {
            cityO = city;
        }
    }
    return cityO;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ICPinyinFlag *icP = self.cityIC[section];
    return icP.flag;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

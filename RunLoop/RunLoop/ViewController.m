//
//  ViewController.m
//  RunLoop
//
//  Created by peace on 2018/3/26.
//  Copyright © 2018 peace. All rights reserved.
//

#import "ViewController.h"
#import "SpaceCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSThread *thread;

@end

@implementation ViewController

#pragma mark -
#pragma mark -- Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self defaultRunLoopButton:0];
    [self trackingRunLoopButton:1];
    [self commonRunLoopButton:2];
    [self observerRunLoopButton:3];
    [self strongeThreadButton:4];
    [self tableView:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -- Active
//只在闲时
- (void)timerAction {
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerRunAction) userInfo:nil repeats:YES];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerRunAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)timerRunAction {
    NSLog(@"Timer run! = %f",[NSDate date].timeIntervalSince1970);
}

//只在滚动时
- (void)trackAction {
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(trackRunAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
}
- (void)trackRunAction {
    NSLog(@"Track timer run! = %f",[NSDate date].timeIntervalSince1970);
}

//同时处理闲时和滚动时
- (void)commonAction {
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(commonRunAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)commonRunAction {
    NSLog(@"Track timer run! = %f",[NSDate date].timeIntervalSince1970);
}

//观察者
- (void)observerAction {
    //typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    //    kCFRunLoopEntry = (1UL << 0),               // 即将进入Loop：1
    //    kCFRunLoopBeforeTimers = (1UL << 1),        // 即将处理Timer：2
    //    kCFRunLoopBeforeSources = (1UL << 2),       // 即将处理Source：4
    //    kCFRunLoopBeforeWaiting = (1UL << 5),       // 即将进入休眠：32
    //    kCFRunLoopAfterWaiting = (1UL << 6),        // 即将从休眠中唤醒：64
    //    kCFRunLoopExit = (1UL << 7),                // 即将从Loop中退出：128
    //    kCFRunLoopAllActivities = 0x0FFFFFFFU       // 监听全部状态改变
    //};
    // 创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"RunLoop Changed Activity---%zd",activity);
    });
    // 添加观察者到当前RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRelease(observer);
}

- (void)strongeThreadAction {
    if (!self.thread) {
        self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(strongeThread) object:nil];
        [self.thread start];
    }
    else {
        [self performSelector:@selector(addActionToThread) onThread:self.thread withObject:nil waitUntilDone:NO];
    }
}

- (void)strongeThread {
    NSLog(@"----add run loop-----");
    
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

- (void)addActionToThread {
    NSDate *date = [NSDate date];
    NSLog(@"----Do Action1-----%f",date.timeIntervalSince1970);
    sleep(3);
    NSLog(@"----Do Action2-----%f",date.timeIntervalSince1970);
}

#pragma mark -
#pragma mark -- UI
- (void)defaultRunLoopButton:(int)index {
    float y = 20+index*50;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor brownColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 40)];
    [button setTitle:@"NSDefaultRunLoopMode" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(timerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)trackingRunLoopButton:(int)index {
    float y = 20+index*50;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor brownColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 40)];
    [button setTitle:@"UITrackingRunLoopMode" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(trackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)commonRunLoopButton:(int)index {
    float y = 20+index*50;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor brownColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 40)];
    [button setTitle:@"NSRunLoopCommonModes" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)observerRunLoopButton:(int)index {
    float y = 20+index*50;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor brownColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 40)];
    [button setTitle:@"RunLoopObserver" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(observerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)strongeThreadButton:(int)index {
    float y = 20+index*50;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor brownColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 40)];
    [button setTitle:@"Stronge Thread" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(strongeThreadAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark -
#pragma mark -- TableView
- (void)tableView:(int)index {
    float y = 20 + index * 50;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height-y) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 165;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 500;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TableViewCell";
    SpaceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SpaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.topLabel.text =  [NSString stringWithFormat:@"%zd - show the title ", indexPath.row];
    cell.bottomLabel.text = [NSString stringWithFormat:@"%zd - show the bottom title text.", indexPath.row];
    
    [cell.imgV1 setImage:nil];
    [cell.imgV2 setImage:nil];
    [cell.imgV3 setImage:nil];
    
    [cell.imgV1 performSelector:@selector(setImage:) withObject:getImg() afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
    [cell.imgV2 performSelector:@selector(setImage:) withObject:getImg() afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
    [cell.imgV3 performSelector:@selector(setImage:) withObject:getImg() afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
    
//    cell.imgV1.image = getImg();
//    cell.imgV2.image = getImg();
//    cell.imgV3.image = getImg();
    
    return cell;
}

UIImage *getImg() {
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"beauty" ofType:@"jpg"];
    UIImage *img = [UIImage imageWithContentsOfFile:path1];
    return img;
}

@end

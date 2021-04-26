//
//  ViewController.m
//  GCD_Demo
//
//  Created by huangxin on 2021/4/25.
//

#import "ViewController.h"

@interface ViewController ()

/// 车票总数
@property (nonatomic , assign) int ticketSurplusCount;

/// 车票加锁
@property (nonatomic , strong) dispatch_semaphore_t semaphore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、异步+串行
    //    [self creat_async_SERIAL_GCD];
    
    //2、异步+并行
    //    [self creat_async_CONCURRENT_GCD];
    
    //3、同步+串行
    //    [self creat_sync_SERIAL_GCD];
    
    //4、同步+并行
    //    [self creat_sync_CONCURRENT_GCD];
    /**
     结论：除了异步+并行以外，其他三种执行的顺序都是一样的，区别在于异步可以创建新线程，同步不能创建新线程
     */
    
    //5、队列组
    //    [self creat_group_GCD];
    
    //6、dispatch_group_enter和dispatch_group_leave搭配使用
    //    [self creat_group_enter_GCD];
    
    //7、信号量
//        [self creat_semaphore_GCD];
    
    //8、使用信号量模拟买车票
    [self buyTicket];
    
}

/// 异步+串行
-(void)creat_async_SERIAL_GCD{
    //1、创建串行队列
    //第一个参数唯一标识符，第二个参数 DISPATCH_QUEUE_SERIAL 代表串行, DISPATCH_QUEUE_CONCURRENT 代表并行
    //    dispatch_queue_t queue = dispatch_queue_create("com.demo.test", DISPATCH_QUEUE_SERIAL);
    //串行的第二种创建方法
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2、创建异步任务
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"异步串行任务1执行%d",i);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"异步串行任务2执行%d",i);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"异步串行任务3执行%d",i);
        }
    });
    
}

/// 异步并行
-(void)creat_async_CONCURRENT_GCD{
    //1、创建并行队列
    //第一个参数唯一标识符，第二个参数 DISPATCH_QUEUE_SERIAL 代表串行, DISPATCH_QUEUE_CONCURRENT 代表并行
    //    dispatch_queue_t queue = dispatch_queue_create("com.demo.test", DISPATCH_QUEUE_CONCURRENT);
    //并行的第二种创建方法
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2、创建异步任务
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"异步并行任务1执行%d",i);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"异步并行任务2执行%d",i);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"异步并行任务3执行%d",i);
        }
    });
}

/// 同步+串行
-(void)creat_sync_SERIAL_GCD{
    //1、创建串行队列
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2、创建同步任务
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"同步串行任务1执行%d",i);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"同步串行任务2执行%d",i);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"同步串行任务3执行%d",i);
        }
    });
}

/// 同步+并行
-(void)creat_sync_CONCURRENT_GCD{
    //1、创建并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2、创建同步任务
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"同步并行任务1执行%d",i);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"同步并行任务2执行%d",i);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"同步并行任务3执行%d",i);
        }
    });
}

/// 队列组
-(void)creat_group_GCD{
    
    //1、创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2、创建并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //3、创建任务
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"队列组任务1执行%d",i);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"队列组任务2执行%d",i);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"队列组任务3执行%d",i);
        }
    });
    //上面执行完在执行这个
    dispatch_group_notify(group, queue, ^{
        NSLog(@"执行完队列组后执行");
    });
    
}

/// dispatch_group_enter 和 dispatch_group_leave 执行
-(void)creat_group_enter_GCD{
    //1、创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2、创建并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //3、模拟网络耗操作队列
    dispatch_queue_t networkqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //任务1
    //等待
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"网络1新开线程开始请求数据");
        dispatch_async(networkqueue, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"网络1回调到数据");
            dispatch_group_leave(group);
        });
    });
    //任务2
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"网络2新开线程开始请求数据");
        dispatch_async(networkqueue, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"网络2回调到数据");
            dispatch_group_leave(group);
        });
    });
    //任务3
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"网络3新开线程开始请求数据");
        dispatch_async(networkqueue, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"网络3回调到数据");
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"上述网络都请求到数据后");
    });
    
}

/// 信号量
-(void)creat_semaphore_GCD{
    //创建信号量 当信号量大于等于0的时候会执行代码，小于0等待 里面的值也代表最多开几个线程,因为小于0才会等待，所以为0的时候相当于开一个线程
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    //    //使信号量+1
    //    dispatch_semaphore_signal(semaphore);
    //    //使信号量-1
    //    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //创建并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行1完毕");
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行2完毕");
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行3完毕");
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    NSLog(@"上述代码执行完毕");
    
}

/// 买车票
-(void)buyTicket{
    //车票总数
    self.ticketSurplusCount = 50;
    //窗口数
    int windows = 3;
    
    self.semaphore = dispatch_semaphore_create(windows);
    
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("net.bujige.testQueue3", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue4 = dispatch_queue_create("net.bujige.testQueue4", DISPATCH_QUEUE_SERIAL);

    __weak typeof(self) weakself = self;
    dispatch_async(queue1, ^{
        [weakself creatSysDrawer:0];
    });
    dispatch_async(queue2, ^{
        [weakself creatSysDrawer:1];
    });
    dispatch_async(queue3, ^{
        [weakself creatSysDrawer:2];
    });
    dispatch_async(queue4, ^{
        [weakself creatSysDrawer:3];
    });

    
}

/// 系统出票
-(void)creatSysDrawer:(int)nowint{
    
    while (1) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        if (self.ticketSurplusCount > 0) {
            self.ticketSurplusCount--;
            NSLog(@"%d窗口还剩%d张票",nowint,self.ticketSurplusCount);
            dispatch_semaphore_signal(self.semaphore);
        }else{
            NSLog(@"票卖完了");
            dispatch_semaphore_signal(self.semaphore);
            break;
        }
        
    }
}


@end

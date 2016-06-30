//
//  ViewController.m
//  gcd learn
//
//  Created by 瑶波波 on 16/6/30.
//  Copyright © 2016年 dengbowc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 把任务放入主队列同步执行会造成死锁
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"ahha");
//    });
//    
//    NSLog(@"111");
//    self.view.backgroundColor = [UIColor redColor];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test2];
}

/**
 *  队列和同步、异步的介绍
 */
- (void)test1 {
    // 创建队列
    // 最好给队列起一个名字，便于调试
    dispatch_queue_t queue = dispatch_queue_create("com.dengbo.cn", NULL);
    NSLog(@"%@",queue);
    
    /**
     *  向队列提交job(异步，即这个方法会立即返回，任务会在后台等待异步执行)
     *
     *  @param queue#> 队列 description#>
     *  @param void    job的block
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 在这个block里面写入你需要执行的job，队列会在轮到这个block时执行这个block里面的代码。
        // doSomeThing async
        // 然而大部分情况下，我们都需要异步执行完操作后再来更新我们的UI界面，这就意味着需要在主线程执行一些代码，使用dispatch嵌套可以很轻松地完成
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在这里写入更新UI的操作
        });
    });
    // 上文中我们用到了dispatch_async这个函数，和dispatch_async一样，它也是将任务放入队列中，但不同的是它会等待block中的代码执行完毕后才会返回。
}

/**
 *  串行。并发队列和同步、异步的混合使用
 */
- (void)test2 {
    // 主队列，串行
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // 全局队列，并发
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 自定义队列(串行)
    dispatch_queue_t myQueue = dispatch_queue_create("com.dengbo.cn", DISPATCH_QUEUE_SERIAL);
    // 自定义队列(并发)
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.dengbo.con", DISPATCH_QUEUE_CONCURRENT);
    
    // 把任务放入串行队列同步执行
    dispatch_sync(myQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    NSLog(@"over");
    
    // 把任务放入串行队列异步执行
//    for (int i = 1 ; i <= 10; i++) {
//        dispatch_async(myQueue, ^{
//            NSLog(@"%d___%@",i,[NSThread currentThread]);
//        });
//
//    }

    // 把任务放入并发队列同步执行
//    dispatch_sync(concurrentQueue, ^{
//        NSLog(@"%@",[NSThread currentThread]);
//    });
//    NSLog(@"over");
    for (int i = 1; i < 10; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"%d___%@",i, [NSThread currentThread]);
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

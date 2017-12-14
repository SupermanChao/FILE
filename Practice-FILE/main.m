//
//  main.m
//  Practice-FILE
//
//  Created by 刘超 on 2017/12/14.
//  Copyright © 2017年 刘超. All rights reserved.
//

#import <Foundation/Foundation.h>

///获取文件路径
const char* getCFilepath(NSString *type) {
    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"temp.%@",type]];
    const char *cFilepath = [filepath cStringUsingEncoding:NSUTF8StringEncoding];
    return cFilepath;
}

#pragma mark --- 单个字符写入文件 和 获取文件单个字符
/// 单个字符写入文件
void test1() {
    FILE *fp = fopen(getCFilepath(@"txt"), "w");
    if (fp == NULL) {
        printf("打开文件失败\n");
    }else {
        const char ch = 'B';
        fputc(ch, fp);
        printf("写入字符完成\n");
    }
    fclose(fp);
}
/// 从文件中获取单个字符
void test2() {
    FILE *fp = fopen(getCFilepath(@"txt"), "r");
    if (fp == NULL) {
        printf("打开文件失败\n");
    }else {
        char ch = fgetc(fp);
        printf("获取文件单个字符完成：%c \n",ch);
    }
    fclose(fp);
}

#pragma mark --- 字符串写入文件 和 获取文件中的字符串
/// 字符串写入文件
void test3() {
    FILE *fp = fopen(getCFilepath(@"txt"), "w");
    if (fp == NULL) {
        printf("打开文件失败\n");
    }else {
        printf("请输入想要存储的字符串\n");
        char ch[20];
        scanf("%s",ch);
        if (strlen(ch) > 0 && strlen(ch) < 20) {
            fputs(ch, fp);
            printf("写入字符完成\n");
        }else {
            printf("写入字符格式不对");
        }
    }
    fclose(fp);
}

/// 获取文件中的字符串
void test4() {
    FILE *fp = fopen(getCFilepath(@"txt"), "r");
    if (fp == NULL) {
        printf("打开文件失败\n");
    }else {
        char ch[20];
        fgets(ch, sizeof(ch), fp);
        printf("获取文件字符串完成：%s \n",ch);
    }
    fclose(fp);
}

#pragma mark --- 数据流的操作
/// 首先定义一个结构体
struct Person {
    char    name[30];
    int     age;
    float   height;
};

///数据流的写入
void test5(struct Person *p) {
    FILE *fp = fopen(getCFilepath(@"data"), "ab"); //追加写入二进制文件
    if (fp == NULL) {
        printf("打开文件失败\n");
    }else {
        fwrite(p, sizeof(struct Person), 1, fp);
        printf("~~~~~~~~~~存入成功~~~~~~~~~~\n");
    }
    fclose(fp);
}

///数据流读取
void test6() {
    FILE *fp = fopen(getCFilepath(@"data"), "rb"); //读取二进制文件
    if (fp == NULL) {
        printf("打开文件失败\n");
    }else {
        struct Person p[2]; //声明一个结构体数组
        for (int i = 0; i < 2; i++) {
            fread(&p[i], sizeof(struct Person), 1, fp);
            printf("    %s  %d  %f\n",p[i].name,p[i].age,p[i].height);
        }
    }
    fclose(fp);
}

#pragma mark --- 文件的定位
/// 文件指针位置偏移
void test7() {
    
    FILE *fp = fopen(getCFilepath(@"data"), "rb"); //读取二进制文件
    if (fp == NULL) {
        printf("打开文件失败\n");
    }else {
        struct Person p;
        
        //将fp指针偏移到存储的第二个结构体前（也就是从文件首移动一个Person结构体大小的字节）
        fseek(fp, sizeof(struct Person), SEEK_SET);
        
        fread(&p, sizeof(struct Person), 1, fp);
        printf("%s  %d  %f\n",p.name,p.age,p.height);
    }
    fclose(fp);
}

/// 文件指针位置重置
void test8() {
    FILE *fp = fopen(getCFilepath(@"data"), "rb"); //读取二进制文件
    if (fp == NULL) {
        printf("打开文件失败\n");
    }else {
        struct Person p[2]; //声明一个结构体数组
        for (int i = 0; i < 2; i++) {
            fread(&p[i], sizeof(struct Person), 1, fp);
            printf(" %s  %d  %f\n",p[i].name,p[i].age,p[i].height);
            
            //每次取完数值都回到文件首，重置取完文件后的偏移
            rewind(fp);
        }
    }
    fclose(fp);
}

/// 通过计算文件指针偏移量来计算文件大小
void test9() {
    FILE *fp = fopen(getCFilepath(@"data"), "rb"); //读取二进制文件
    if (fp == NULL) {
        printf("打开文件失败\n");
    }else {
        //1.首先将文件指针移到文件末尾
        fseek(fp, 0L, SEEK_END);
        //1.计算出偏移量，就是文件大小
        long offsetSize = ftell(fp);
        if (offsetSize != EOF) {
            printf("文件大小是： %ld \n",offsetSize);
        }else {
            printf("计算出现了问题\n");
        }
        
    }
    fclose(fp);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //test1();
        //test2();
        //test3();
        //test4();
        
        /*
         for (int i = 0; i < 2; i++) {
         struct Person p;
         printf("请输入第 %d 个人的名字\n",i+1);
         scanf("%s",p.name);
         printf("请输入第 %d 个人的年龄\n",i+1);
         scanf("%d",&p.age);
         printf("请输入第 %d 个人的身高\n",i+1);
         scanf("%f",&p.height);
         
         test5(&p); //这里传入结构体指针，一个是为了方便，一个是为了节省参数传递栈的开销
         }
         */
        
        //test6();
        //test7();
        //test8();
        //test9();
        printf("\n\n\n");
    }
    return 0;
}

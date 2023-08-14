#Lab3 PageTable 
##speed up system calls (easy)
###要求：
一些操作系统（比如Linux）通过在用户与内核之间只读的一块区域共享数据来加速系统调用。这能消减执行这些系统调用时用户态与内核态切换的开销。为了帮助你们理解如何在页表中插入映射，你的第一个任务是为getpid实现这种优化。

每当一个进程被创建时，在USYSCALL（在memlayout.h中定义）位置建立一个只读内存页的映射。在这页开始，存储一个struct usyscall，并初始化该结构体以保存当前进程ID。实验中的ugetpid()已在用户空间提供且会自动使用USYSCALL映射。

提示：

你可以在kernel/proc.c的proc_pagetable()中实现映射
选择合适的权限置位以满足用户只读此页
mappages()是有用的工具
切记在allocproc()中开辟内存页的空间并初始化
确保在freeproc()中释放该内存页

###实现：
1.在proc.h struct proc中添加struct usyscall指针字段
2.在proc.c proc_pagetable()中添加usyscall物理地址到虚拟地址的映射
3.同样，建立映射后还需要有对应的位置解除映射（在free_pagetable()中）
4.在allocproc()中开辟空间并初始化
5.在freeproc()中释放内存页
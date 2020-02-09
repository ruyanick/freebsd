#!/bin/sh

# panic: mutex process lock not owned at ../../../kern/kern_time.c:261
# cpuid = 17
# time = 1580844484
# KDB: stack backtrace:
# db_trace_self_wrapper() at db_trace_self_wrapper+0x2b/frame 0xfffffe01387b7920
# vpanic() at vpanic+0x185/frame 0xfffffe01387b7980
# panic() at panic+0x43/frame 0xfffffe01387b79e0
# __mtx_assert() at __mtx_assert+0xb0/frame 0xfffffe01387b79f0
# kern_thread_cputime() at kern_thread_cputime+0x99/frame 0xfffffe01387b7a30
# kern_clock_gettime() at kern_clock_gettime+0x2a6/frame 0xfffffe01387b7a90
# sys_clock_gettime() at sys_clock_gettime+0x17/frame 0xfffffe01387b7ac0
# amd64_syscall() at amd64_syscall+0x2f1/frame 0xfffffe01387b7bf0
# fast_syscall_common() at fast_syscall_common+0x101/frame 0xfffffe01387b7bf0
# --- syscall (0, FreeBSD ELF64, nosys), rip = 0x80041b8ca, rsp = 0x7fffffffe9f8, rbp = 0x7fffffffea10 ---

# $FreeBSD$

. ../default.cfg
cat > /tmp/syzkaller3.c <<EOF
// https://syzkaller.appspot.com/bug?id=6245c550ba855e94618dbc1dec0a21e9e89a2ddd
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <pwd.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/endian.h>
#include <sys/syscall.h>
#include <unistd.h>

int main(void)
{
  syscall(SYS_mmap, 0x20000000ul, 0x1000000ul, 3ul, 0x1012ul, -1, 0ul);
  syscall(SYS_clock_gettime, 0xeul, 0ul);
  return 0;
}
EOF
mycc -o /tmp/syzkaller3 -Wall -Wextra -O2 /tmp/syzkaller3.c ||
    exit 1

(cd /tmp; ./syzkaller3)

rm /tmp/syzkaller3 /tmp/syzkaller3.c
exit 0

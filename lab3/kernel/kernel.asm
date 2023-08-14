
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	e8010113          	add	sp,sp,-384 # 80019e80 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6f0050ef          	jal	80005706 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	sll	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	f5078793          	add	a5,a5,-176 # 80021f80 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	sll	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8c090913          	add	s2,s2,-1856 # 80008910 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	094080e7          	jalr	148(ra) # 800060ee <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	134080e7          	jalr	308(ra) # 800061a2 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	add	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	add	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b2c080e7          	jalr	-1236(ra) # 80005bb6 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	add	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	add	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	add	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	add	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	82250513          	add	a0,a0,-2014 # 80008910 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	f68080e7          	jalr	-152(ra) # 8000605e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	e7e50513          	add	a0,a0,-386 # 80021f80 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	add	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	add	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7ec48493          	add	s1,s1,2028 # 80008910 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	fc0080e7          	jalr	-64(ra) # 800060ee <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7d450513          	add	a0,a0,2004 # 80008910 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	05c080e7          	jalr	92(ra) # 800061a2 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	add	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	7a850513          	add	a0,a0,1960 # 80008910 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	032080e7          	jalr	50(ra) # 800061a2 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	add	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	sll	a2,a2,0x20
    80000186:	9201                	srl	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	add	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	add	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	add	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	sll	a3,a3,0x20
    800001aa:	9281                	srl	a3,a3,0x20
    800001ac:	0685                	add	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	add	a0,a0,1
    800001be:	0585                	add	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	add	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	add	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	sll	a2,a2,0x20
    800001e4:	9201                	srl	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	add	a1,a1,1
    800001ee:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd081>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	add	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	sll	a3,a2,0x20
    80000206:	9281                	srl	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addw	a5,a2,-1
    80000216:	1782                	sll	a5,a5,0x20
    80000218:	9381                	srl	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	add	a4,a4,-1
    80000222:	16fd                	add	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	add	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	add	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	add	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addw	a2,a2,-1
    80000262:	0505                	add	a0,a0,1
    80000264:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	add	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	add	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	87aa                	mv	a5,a0
    8000028e:	86b2                	mv	a3,a2
    80000290:	367d                	addw	a2,a2,-1
    80000292:	00d05963          	blez	a3,800002a4 <strncpy+0x1e>
    80000296:	0785                	add	a5,a5,1
    80000298:	0005c703          	lbu	a4,0(a1)
    8000029c:	fee78fa3          	sb	a4,-1(a5)
    800002a0:	0585                	add	a1,a1,1
    800002a2:	f775                	bnez	a4,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	873e                	mv	a4,a5
    800002a6:	9fb5                	addw	a5,a5,a3
    800002a8:	37fd                	addw	a5,a5,-1
    800002aa:	00c05963          	blez	a2,800002bc <strncpy+0x36>
    *s++ = 0;
    800002ae:	0705                	add	a4,a4,1
    800002b0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002b4:	40e786bb          	subw	a3,a5,a4
    800002b8:	fed04be3          	bgtz	a3,800002ae <strncpy+0x28>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	add	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	add	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addw	a3,a2,-1
    800002d0:	1682                	sll	a3,a3,0x20
    800002d2:	9281                	srl	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	add	a1,a1,1
    800002de:	0785                	add	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	add	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	add	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	add	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	86be                	mv	a3,a5
    80000306:	0785                	add	a5,a5,1
    80000308:	fff7c703          	lbu	a4,-1(a5)
    8000030c:	ff65                	bnez	a4,80000304 <strlen+0x10>
    8000030e:	40a6853b          	subw	a0,a3,a0
    80000312:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	add	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	add	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	afc080e7          	jalr	-1284(ra) # 80000e22 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	5b270713          	add	a4,a4,1458 # 800088e0 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ae0080e7          	jalr	-1312(ra) # 80000e22 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	add	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	8ac080e7          	jalr	-1876(ra) # 80005c00 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	816080e7          	jalr	-2026(ra) # 80001b7a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	d54080e7          	jalr	-684(ra) # 800050c0 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	05e080e7          	jalr	94(ra) # 800013d2 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	74a080e7          	jalr	1866(ra) # 80005ac6 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a5c080e7          	jalr	-1444(ra) # 80005de0 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	add	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	86c080e7          	jalr	-1940(ra) # 80005c00 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	add	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	85c080e7          	jalr	-1956(ra) # 80005c00 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	add	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	84c080e7          	jalr	-1972(ra) # 80005c00 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d22080e7          	jalr	-734(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	99c080e7          	jalr	-1636(ra) # 80000d70 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	776080e7          	jalr	1910(ra) # 80001b52 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	796080e7          	jalr	1942(ra) # 80001b7a <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	cbe080e7          	jalr	-834(ra) # 800050aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	ccc080e7          	jalr	-820(ra) # 800050c0 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	ecc080e7          	jalr	-308(ra) # 800022c8 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	56a080e7          	jalr	1386(ra) # 8000296e <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	4e0080e7          	jalr	1248(ra) # 800038ec <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	db4080e7          	jalr	-588(ra) # 800051c8 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d98080e7          	jalr	-616(ra) # 800011b4 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	4af72b23          	sw	a5,1206(a4) # 800088e0 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	add	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	4aa7b783          	ld	a5,1194(a5) # 800088e8 <kernel_pagetable>
    80000446:	83b1                	srl	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	sll	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	add	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	add	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	add	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srl	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	add	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	72c080e7          	jalr	1836(ra) # 80005bb6 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c84080e7          	jalr	-892(ra) # 8000011a <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd4080e7          	jalr	-812(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srl	a5,s1,0xc
    800004b2:	07aa                	sll	a5,a5,0xa
    800004b4:	0017e793          	or	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd077>
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	and	s2,s2,511
    800004ca:	090e                	sll	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	and	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srl	s1,s1,0xa
    800004da:	04b2                	sll	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srl	a0,s3,0xc
    800004e2:	1ff57513          	and	a0,a0,511
    800004e6:	050e                	sll	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	add	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srl	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	add	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	and	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	add	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	83a9                	srl	a5,a5,0xa
    8000053a:	00c79513          	sll	a0,a5,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	add	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	777d                	lui	a4,0xfffff
    80000562:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000566:	fff58993          	add	s3,a1,-1
    8000056a:	99b2                	add	s3,s3,a2
    8000056c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000570:	893e                	mv	s2,a5
    80000572:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	and	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srl	s1,s1,0xc
    80000594:	04aa                	sll	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	or	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	add	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	606080e7          	jalr	1542(ra) # 80005bb6 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	add	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	5f6080e7          	jalr	1526(ra) # 80005bb6 <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	add	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	add	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	add	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	add	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	add	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	5aa080e7          	jalr	1450(ra) # 80005bb6 <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	add	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	afa080e7          	jalr	-1286(ra) # 8000011a <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4c080e7          	jalr	-1204(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	add	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	add	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	sll	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	sll	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	add	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c6:	05b2                	sll	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	608080e7          	jalr	1544(ra) # 80000cdc <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	add	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	add	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	1ea7b723          	sd	a0,494(a5) # 800088e8 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	add	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	add	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	sll	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	sll	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	add	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	add	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	45e080e7          	jalr	1118(ra) # 80005bb6 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	add	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	44e080e7          	jalr	1102(ra) # 80005bb6 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	add	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	43e080e7          	jalr	1086(ra) # 80005bb6 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	add	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	42e080e7          	jalr	1070(ra) # 80005bb6 <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	and	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	and	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	sll	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	add	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	942080e7          	jalr	-1726(ra) # 8000011a <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	992080e7          	jalr	-1646(ra) # 8000017a <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	add	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	add	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	902080e7          	jalr	-1790(ra) # 8000011a <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	954080e7          	jalr	-1708(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	990080e7          	jalr	-1648(ra) # 800001d6 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	add	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	add	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	350080e7          	jalr	848(ra) # 80005bb6 <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	add	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	76fd                	lui	a3,0xfffff
    8000088a:	8f75                	and	a4,a4,a3
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff5                	and	a5,a5,a3
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	add	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	add	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	add	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	add	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	add	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	add	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a829                	j	8000099c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000986:	00c79513          	sll	a0,a5,0xc
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	fde080e7          	jalr	-34(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000992:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000996:	04a1                	add	s1,s1,8
    80000998:	03248163          	beq	s1,s2,800009ba <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099e:	00f7f713          	and	a4,a5,15
    800009a2:	ff3701e3          	beq	a4,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a6:	8b85                	and	a5,a5,1
    800009a8:	d7fd                	beqz	a5,80000996 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009aa:	00007517          	auipc	a0,0x7
    800009ae:	74e50513          	add	a0,a0,1870 # 800080f8 <etext+0xf8>
    800009b2:	00005097          	auipc	ra,0x5
    800009b6:	204080e7          	jalr	516(ra) # 80005bb6 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ba:	8552                	mv	a0,s4
    800009bc:	fffff097          	auipc	ra,0xfffff
    800009c0:	660080e7          	jalr	1632(ra) # 8000001c <kfree>
}
    800009c4:	70a2                	ld	ra,40(sp)
    800009c6:	7402                	ld	s0,32(sp)
    800009c8:	64e2                	ld	s1,24(sp)
    800009ca:	6942                	ld	s2,16(sp)
    800009cc:	69a2                	ld	s3,8(sp)
    800009ce:	6a02                	ld	s4,0(sp)
    800009d0:	6145                	add	sp,sp,48
    800009d2:	8082                	ret

00000000800009d4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d4:	1101                	add	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	add	s0,sp,32
    800009de:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e0:	e999                	bnez	a1,800009f6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e2:	8526                	mv	a0,s1
    800009e4:	00000097          	auipc	ra,0x0
    800009e8:	f84080e7          	jalr	-124(ra) # 80000968 <freewalk>
}
    800009ec:	60e2                	ld	ra,24(sp)
    800009ee:	6442                	ld	s0,16(sp)
    800009f0:	64a2                	ld	s1,8(sp)
    800009f2:	6105                	add	sp,sp,32
    800009f4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f6:	6785                	lui	a5,0x1
    800009f8:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fa:	95be                	add	a1,a1,a5
    800009fc:	4685                	li	a3,1
    800009fe:	00c5d613          	srl	a2,a1,0xc
    80000a02:	4581                	li	a1,0
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	d06080e7          	jalr	-762(ra) # 8000070a <uvmunmap>
    80000a0c:	bfd9                	j	800009e2 <uvmfree+0xe>

0000000080000a0e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0e:	c679                	beqz	a2,80000adc <uvmcopy+0xce>
{
    80000a10:	715d                	add	sp,sp,-80
    80000a12:	e486                	sd	ra,72(sp)
    80000a14:	e0a2                	sd	s0,64(sp)
    80000a16:	fc26                	sd	s1,56(sp)
    80000a18:	f84a                	sd	s2,48(sp)
    80000a1a:	f44e                	sd	s3,40(sp)
    80000a1c:	f052                	sd	s4,32(sp)
    80000a1e:	ec56                	sd	s5,24(sp)
    80000a20:	e85a                	sd	s6,16(sp)
    80000a22:	e45e                	sd	s7,8(sp)
    80000a24:	0880                	add	s0,sp,80
    80000a26:	8b2a                	mv	s6,a0
    80000a28:	8aae                	mv	s5,a1
    80000a2a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a2e:	4601                	li	a2,0
    80000a30:	85ce                	mv	a1,s3
    80000a32:	855a                	mv	a0,s6
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	a28080e7          	jalr	-1496(ra) # 8000045c <walk>
    80000a3c:	c531                	beqz	a0,80000a88 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a3e:	6118                	ld	a4,0(a0)
    80000a40:	00177793          	and	a5,a4,1
    80000a44:	cbb1                	beqz	a5,80000a98 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a46:	00a75593          	srl	a1,a4,0xa
    80000a4a:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a4e:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	6c8080e7          	jalr	1736(ra) # 8000011a <kalloc>
    80000a5a:	892a                	mv	s2,a0
    80000a5c:	c939                	beqz	a0,80000ab2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85de                	mv	a1,s7
    80000a62:	fffff097          	auipc	ra,0xfffff
    80000a66:	774080e7          	jalr	1908(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6a:	8726                	mv	a4,s1
    80000a6c:	86ca                	mv	a3,s2
    80000a6e:	6605                	lui	a2,0x1
    80000a70:	85ce                	mv	a1,s3
    80000a72:	8556                	mv	a0,s5
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	ad0080e7          	jalr	-1328(ra) # 80000544 <mappages>
    80000a7c:	e515                	bnez	a0,80000aa8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a7e:	6785                	lui	a5,0x1
    80000a80:	99be                	add	s3,s3,a5
    80000a82:	fb49e6e3          	bltu	s3,s4,80000a2e <uvmcopy+0x20>
    80000a86:	a081                	j	80000ac6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	68050513          	add	a0,a0,1664 # 80008108 <etext+0x108>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	126080e7          	jalr	294(ra) # 80005bb6 <panic>
      panic("uvmcopy: page not present");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	add	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	116080e7          	jalr	278(ra) # 80005bb6 <panic>
      kfree(mem);
    80000aa8:	854a                	mv	a0,s2
    80000aaa:	fffff097          	auipc	ra,0xfffff
    80000aae:	572080e7          	jalr	1394(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab2:	4685                	li	a3,1
    80000ab4:	00c9d613          	srl	a2,s3,0xc
    80000ab8:	4581                	li	a1,0
    80000aba:	8556                	mv	a0,s5
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	c4e080e7          	jalr	-946(ra) # 8000070a <uvmunmap>
  return -1;
    80000ac4:	557d                	li	a0,-1
}
    80000ac6:	60a6                	ld	ra,72(sp)
    80000ac8:	6406                	ld	s0,64(sp)
    80000aca:	74e2                	ld	s1,56(sp)
    80000acc:	7942                	ld	s2,48(sp)
    80000ace:	79a2                	ld	s3,40(sp)
    80000ad0:	7a02                	ld	s4,32(sp)
    80000ad2:	6ae2                	ld	s5,24(sp)
    80000ad4:	6b42                	ld	s6,16(sp)
    80000ad6:	6ba2                	ld	s7,8(sp)
    80000ad8:	6161                	add	sp,sp,80
    80000ada:	8082                	ret
  return 0;
    80000adc:	4501                	li	a0,0
}
    80000ade:	8082                	ret

0000000080000ae0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae0:	1141                	add	sp,sp,-16
    80000ae2:	e406                	sd	ra,8(sp)
    80000ae4:	e022                	sd	s0,0(sp)
    80000ae6:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae8:	4601                	li	a2,0
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	972080e7          	jalr	-1678(ra) # 8000045c <walk>
  if(pte == 0)
    80000af2:	c901                	beqz	a0,80000b02 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af4:	611c                	ld	a5,0(a0)
    80000af6:	9bbd                	and	a5,a5,-17
    80000af8:	e11c                	sd	a5,0(a0)
}
    80000afa:	60a2                	ld	ra,8(sp)
    80000afc:	6402                	ld	s0,0(sp)
    80000afe:	0141                	add	sp,sp,16
    80000b00:	8082                	ret
    panic("uvmclear");
    80000b02:	00007517          	auipc	a0,0x7
    80000b06:	64650513          	add	a0,a0,1606 # 80008148 <etext+0x148>
    80000b0a:	00005097          	auipc	ra,0x5
    80000b0e:	0ac080e7          	jalr	172(ra) # 80005bb6 <panic>

0000000080000b12 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b12:	c6bd                	beqz	a3,80000b80 <copyout+0x6e>
{
    80000b14:	715d                	add	sp,sp,-80
    80000b16:	e486                	sd	ra,72(sp)
    80000b18:	e0a2                	sd	s0,64(sp)
    80000b1a:	fc26                	sd	s1,56(sp)
    80000b1c:	f84a                	sd	s2,48(sp)
    80000b1e:	f44e                	sd	s3,40(sp)
    80000b20:	f052                	sd	s4,32(sp)
    80000b22:	ec56                	sd	s5,24(sp)
    80000b24:	e85a                	sd	s6,16(sp)
    80000b26:	e45e                	sd	s7,8(sp)
    80000b28:	e062                	sd	s8,0(sp)
    80000b2a:	0880                	add	s0,sp,80
    80000b2c:	8b2a                	mv	s6,a0
    80000b2e:	8c2e                	mv	s8,a1
    80000b30:	8a32                	mv	s4,a2
    80000b32:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b34:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b36:	6a85                	lui	s5,0x1
    80000b38:	a015                	j	80000b5c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3a:	9562                	add	a0,a0,s8
    80000b3c:	0004861b          	sext.w	a2,s1
    80000b40:	85d2                	mv	a1,s4
    80000b42:	41250533          	sub	a0,a0,s2
    80000b46:	fffff097          	auipc	ra,0xfffff
    80000b4a:	690080e7          	jalr	1680(ra) # 800001d6 <memmove>

    len -= n;
    80000b4e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b52:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b54:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b58:	02098263          	beqz	s3,80000b7c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b60:	85ca                	mv	a1,s2
    80000b62:	855a                	mv	a0,s6
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	99e080e7          	jalr	-1634(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b6c:	cd01                	beqz	a0,80000b84 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b6e:	418904b3          	sub	s1,s2,s8
    80000b72:	94d6                	add	s1,s1,s5
    80000b74:	fc99f3e3          	bgeu	s3,s1,80000b3a <copyout+0x28>
    80000b78:	84ce                	mv	s1,s3
    80000b7a:	b7c1                	j	80000b3a <copyout+0x28>
  }
  return 0;
    80000b7c:	4501                	li	a0,0
    80000b7e:	a021                	j	80000b86 <copyout+0x74>
    80000b80:	4501                	li	a0,0
}
    80000b82:	8082                	ret
      return -1;
    80000b84:	557d                	li	a0,-1
}
    80000b86:	60a6                	ld	ra,72(sp)
    80000b88:	6406                	ld	s0,64(sp)
    80000b8a:	74e2                	ld	s1,56(sp)
    80000b8c:	7942                	ld	s2,48(sp)
    80000b8e:	79a2                	ld	s3,40(sp)
    80000b90:	7a02                	ld	s4,32(sp)
    80000b92:	6ae2                	ld	s5,24(sp)
    80000b94:	6b42                	ld	s6,16(sp)
    80000b96:	6ba2                	ld	s7,8(sp)
    80000b98:	6c02                	ld	s8,0(sp)
    80000b9a:	6161                	add	sp,sp,80
    80000b9c:	8082                	ret

0000000080000b9e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b9e:	caa5                	beqz	a3,80000c0e <copyin+0x70>
{
    80000ba0:	715d                	add	sp,sp,-80
    80000ba2:	e486                	sd	ra,72(sp)
    80000ba4:	e0a2                	sd	s0,64(sp)
    80000ba6:	fc26                	sd	s1,56(sp)
    80000ba8:	f84a                	sd	s2,48(sp)
    80000baa:	f44e                	sd	s3,40(sp)
    80000bac:	f052                	sd	s4,32(sp)
    80000bae:	ec56                	sd	s5,24(sp)
    80000bb0:	e85a                	sd	s6,16(sp)
    80000bb2:	e45e                	sd	s7,8(sp)
    80000bb4:	e062                	sd	s8,0(sp)
    80000bb6:	0880                	add	s0,sp,80
    80000bb8:	8b2a                	mv	s6,a0
    80000bba:	8a2e                	mv	s4,a1
    80000bbc:	8c32                	mv	s8,a2
    80000bbe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc2:	6a85                	lui	s5,0x1
    80000bc4:	a01d                	j	80000bea <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc6:	018505b3          	add	a1,a0,s8
    80000bca:	0004861b          	sext.w	a2,s1
    80000bce:	412585b3          	sub	a1,a1,s2
    80000bd2:	8552                	mv	a0,s4
    80000bd4:	fffff097          	auipc	ra,0xfffff
    80000bd8:	602080e7          	jalr	1538(ra) # 800001d6 <memmove>

    len -= n;
    80000bdc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be6:	02098263          	beqz	s3,80000c0a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bea:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bee:	85ca                	mv	a1,s2
    80000bf0:	855a                	mv	a0,s6
    80000bf2:	00000097          	auipc	ra,0x0
    80000bf6:	910080e7          	jalr	-1776(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bfa:	cd01                	beqz	a0,80000c12 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfc:	418904b3          	sub	s1,s2,s8
    80000c00:	94d6                	add	s1,s1,s5
    80000c02:	fc99f2e3          	bgeu	s3,s1,80000bc6 <copyin+0x28>
    80000c06:	84ce                	mv	s1,s3
    80000c08:	bf7d                	j	80000bc6 <copyin+0x28>
  }
  return 0;
    80000c0a:	4501                	li	a0,0
    80000c0c:	a021                	j	80000c14 <copyin+0x76>
    80000c0e:	4501                	li	a0,0
}
    80000c10:	8082                	ret
      return -1;
    80000c12:	557d                	li	a0,-1
}
    80000c14:	60a6                	ld	ra,72(sp)
    80000c16:	6406                	ld	s0,64(sp)
    80000c18:	74e2                	ld	s1,56(sp)
    80000c1a:	7942                	ld	s2,48(sp)
    80000c1c:	79a2                	ld	s3,40(sp)
    80000c1e:	7a02                	ld	s4,32(sp)
    80000c20:	6ae2                	ld	s5,24(sp)
    80000c22:	6b42                	ld	s6,16(sp)
    80000c24:	6ba2                	ld	s7,8(sp)
    80000c26:	6c02                	ld	s8,0(sp)
    80000c28:	6161                	add	sp,sp,80
    80000c2a:	8082                	ret

0000000080000c2c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2c:	c2dd                	beqz	a3,80000cd2 <copyinstr+0xa6>
{
    80000c2e:	715d                	add	sp,sp,-80
    80000c30:	e486                	sd	ra,72(sp)
    80000c32:	e0a2                	sd	s0,64(sp)
    80000c34:	fc26                	sd	s1,56(sp)
    80000c36:	f84a                	sd	s2,48(sp)
    80000c38:	f44e                	sd	s3,40(sp)
    80000c3a:	f052                	sd	s4,32(sp)
    80000c3c:	ec56                	sd	s5,24(sp)
    80000c3e:	e85a                	sd	s6,16(sp)
    80000c40:	e45e                	sd	s7,8(sp)
    80000c42:	0880                	add	s0,sp,80
    80000c44:	8a2a                	mv	s4,a0
    80000c46:	8b2e                	mv	s6,a1
    80000c48:	8bb2                	mv	s7,a2
    80000c4a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6985                	lui	s3,0x1
    80000c50:	a02d                	j	80000c7a <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c52:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c56:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c58:	37fd                	addw	a5,a5,-1
    80000c5a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c5e:	60a6                	ld	ra,72(sp)
    80000c60:	6406                	ld	s0,64(sp)
    80000c62:	74e2                	ld	s1,56(sp)
    80000c64:	7942                	ld	s2,48(sp)
    80000c66:	79a2                	ld	s3,40(sp)
    80000c68:	7a02                	ld	s4,32(sp)
    80000c6a:	6ae2                	ld	s5,24(sp)
    80000c6c:	6b42                	ld	s6,16(sp)
    80000c6e:	6ba2                	ld	s7,8(sp)
    80000c70:	6161                	add	sp,sp,80
    80000c72:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c74:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c78:	c8a9                	beqz	s1,80000cca <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c7e:	85ca                	mv	a1,s2
    80000c80:	8552                	mv	a0,s4
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	880080e7          	jalr	-1920(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c8a:	c131                	beqz	a0,80000cce <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8c:	417906b3          	sub	a3,s2,s7
    80000c90:	96ce                	add	a3,a3,s3
    80000c92:	00d4f363          	bgeu	s1,a3,80000c98 <copyinstr+0x6c>
    80000c96:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c98:	955e                	add	a0,a0,s7
    80000c9a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c9e:	daf9                	beqz	a3,80000c74 <copyinstr+0x48>
    80000ca0:	87da                	mv	a5,s6
    80000ca2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ca8:	96da                	add	a3,a3,s6
    80000caa:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd080>
    80000cb4:	df59                	beqz	a4,80000c52 <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cba:	0785                	add	a5,a5,1
    while(n > 0){
    80000cbc:	fed797e3          	bne	a5,a3,80000caa <copyinstr+0x7e>
    80000cc0:	14fd                	add	s1,s1,-1
    80000cc2:	94c2                	add	s1,s1,a6
      --max;
    80000cc4:	8c8d                	sub	s1,s1,a1
      dst++;
    80000cc6:	8b3e                	mv	s6,a5
    80000cc8:	b775                	j	80000c74 <copyinstr+0x48>
    80000cca:	4781                	li	a5,0
    80000ccc:	b771                	j	80000c58 <copyinstr+0x2c>
      return -1;
    80000cce:	557d                	li	a0,-1
    80000cd0:	b779                	j	80000c5e <copyinstr+0x32>
  int got_null = 0;
    80000cd2:	4781                	li	a5,0
  if(got_null){
    80000cd4:	37fd                	addw	a5,a5,-1
    80000cd6:	0007851b          	sext.w	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cdc:	7139                	add	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	add	s0,sp,64
    80000cf0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	06e48493          	add	s1,s1,110 # 80008d60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	00007a97          	auipc	s5,0x7
    80000d00:	304a8a93          	add	s5,s5,772 # 80008000 <etext>
    80000d04:	01000937          	lui	s2,0x1000
    80000d08:	197d                	add	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000d0a:	093a                	sll	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	0000ea17          	auipc	s4,0xe
    80000d10:	c54a0a13          	add	s4,s4,-940 # 8000e960 <tickslock>
    char *pa = kalloc();
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	406080e7          	jalr	1030(ra) # 8000011a <kalloc>
    80000d1c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d1e:	c129                	beqz	a0,80000d60 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d20:	416485b3          	sub	a1,s1,s6
    80000d24:	8591                	sra	a1,a1,0x4
    80000d26:	000ab783          	ld	a5,0(s5)
    80000d2a:	02f585b3          	mul	a1,a1,a5
    80000d2e:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d32:	4719                	li	a4,6
    80000d34:	6685                	lui	a3,0x1
    80000d36:	40b905b3          	sub	a1,s2,a1
    80000d3a:	854e                	mv	a0,s3
    80000d3c:	00000097          	auipc	ra,0x0
    80000d40:	8a8080e7          	jalr	-1880(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d44:	17048493          	add	s1,s1,368
    80000d48:	fd4496e3          	bne	s1,s4,80000d14 <proc_mapstacks+0x38>
  }
}
    80000d4c:	70e2                	ld	ra,56(sp)
    80000d4e:	7442                	ld	s0,48(sp)
    80000d50:	74a2                	ld	s1,40(sp)
    80000d52:	7902                	ld	s2,32(sp)
    80000d54:	69e2                	ld	s3,24(sp)
    80000d56:	6a42                	ld	s4,16(sp)
    80000d58:	6aa2                	ld	s5,8(sp)
    80000d5a:	6b02                	ld	s6,0(sp)
    80000d5c:	6121                	add	sp,sp,64
    80000d5e:	8082                	ret
      panic("kalloc");
    80000d60:	00007517          	auipc	a0,0x7
    80000d64:	3f850513          	add	a0,a0,1016 # 80008158 <etext+0x158>
    80000d68:	00005097          	auipc	ra,0x5
    80000d6c:	e4e080e7          	jalr	-434(ra) # 80005bb6 <panic>

0000000080000d70 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d70:	7139                	add	sp,sp,-64
    80000d72:	fc06                	sd	ra,56(sp)
    80000d74:	f822                	sd	s0,48(sp)
    80000d76:	f426                	sd	s1,40(sp)
    80000d78:	f04a                	sd	s2,32(sp)
    80000d7a:	ec4e                	sd	s3,24(sp)
    80000d7c:	e852                	sd	s4,16(sp)
    80000d7e:	e456                	sd	s5,8(sp)
    80000d80:	e05a                	sd	s6,0(sp)
    80000d82:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d84:	00007597          	auipc	a1,0x7
    80000d88:	3dc58593          	add	a1,a1,988 # 80008160 <etext+0x160>
    80000d8c:	00008517          	auipc	a0,0x8
    80000d90:	ba450513          	add	a0,a0,-1116 # 80008930 <pid_lock>
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	2ca080e7          	jalr	714(ra) # 8000605e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9c:	00007597          	auipc	a1,0x7
    80000da0:	3cc58593          	add	a1,a1,972 # 80008168 <etext+0x168>
    80000da4:	00008517          	auipc	a0,0x8
    80000da8:	ba450513          	add	a0,a0,-1116 # 80008948 <wait_lock>
    80000dac:	00005097          	auipc	ra,0x5
    80000db0:	2b2080e7          	jalr	690(ra) # 8000605e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db4:	00008497          	auipc	s1,0x8
    80000db8:	fac48493          	add	s1,s1,-84 # 80008d60 <proc>
      initlock(&p->lock, "proc");
    80000dbc:	00007b17          	auipc	s6,0x7
    80000dc0:	3bcb0b13          	add	s6,s6,956 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc4:	8aa6                	mv	s5,s1
    80000dc6:	00007a17          	auipc	s4,0x7
    80000dca:	23aa0a13          	add	s4,s4,570 # 80008000 <etext>
    80000dce:	01000937          	lui	s2,0x1000
    80000dd2:	197d                	add	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000dd4:	093a                	sll	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	0000e997          	auipc	s3,0xe
    80000dda:	b8a98993          	add	s3,s3,-1142 # 8000e960 <tickslock>
      initlock(&p->lock, "proc");
    80000dde:	85da                	mv	a1,s6
    80000de0:	8526                	mv	a0,s1
    80000de2:	00005097          	auipc	ra,0x5
    80000de6:	27c080e7          	jalr	636(ra) # 8000605e <initlock>
      p->state = UNUSED;
    80000dea:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000dee:	415487b3          	sub	a5,s1,s5
    80000df2:	8791                	sra	a5,a5,0x4
    80000df4:	000a3703          	ld	a4,0(s4)
    80000df8:	02e787b3          	mul	a5,a5,a4
    80000dfc:	00d7979b          	sllw	a5,a5,0xd
    80000e00:	40f907b3          	sub	a5,s2,a5
    80000e04:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e06:	17048493          	add	s1,s1,368
    80000e0a:	fd349ae3          	bne	s1,s3,80000dde <procinit+0x6e>
  }
}
    80000e0e:	70e2                	ld	ra,56(sp)
    80000e10:	7442                	ld	s0,48(sp)
    80000e12:	74a2                	ld	s1,40(sp)
    80000e14:	7902                	ld	s2,32(sp)
    80000e16:	69e2                	ld	s3,24(sp)
    80000e18:	6a42                	ld	s4,16(sp)
    80000e1a:	6aa2                	ld	s5,8(sp)
    80000e1c:	6b02                	ld	s6,0(sp)
    80000e1e:	6121                	add	sp,sp,64
    80000e20:	8082                	ret

0000000080000e22 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e22:	1141                	add	sp,sp,-16
    80000e24:	e422                	sd	s0,8(sp)
    80000e26:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e28:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2a:	2501                	sext.w	a0,a0
    80000e2c:	6422                	ld	s0,8(sp)
    80000e2e:	0141                	add	sp,sp,16
    80000e30:	8082                	ret

0000000080000e32 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e32:	1141                	add	sp,sp,-16
    80000e34:	e422                	sd	s0,8(sp)
    80000e36:	0800                	add	s0,sp,16
    80000e38:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3a:	2781                	sext.w	a5,a5
    80000e3c:	079e                	sll	a5,a5,0x7
  return c;
}
    80000e3e:	00008517          	auipc	a0,0x8
    80000e42:	b2250513          	add	a0,a0,-1246 # 80008960 <cpus>
    80000e46:	953e                	add	a0,a0,a5
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	add	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e4e:	1101                	add	sp,sp,-32
    80000e50:	ec06                	sd	ra,24(sp)
    80000e52:	e822                	sd	s0,16(sp)
    80000e54:	e426                	sd	s1,8(sp)
    80000e56:	1000                	add	s0,sp,32
  push_off();
    80000e58:	00005097          	auipc	ra,0x5
    80000e5c:	24a080e7          	jalr	586(ra) # 800060a2 <push_off>
    80000e60:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e62:	2781                	sext.w	a5,a5
    80000e64:	079e                	sll	a5,a5,0x7
    80000e66:	00008717          	auipc	a4,0x8
    80000e6a:	aca70713          	add	a4,a4,-1334 # 80008930 <pid_lock>
    80000e6e:	97ba                	add	a5,a5,a4
    80000e70:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e72:	00005097          	auipc	ra,0x5
    80000e76:	2d0080e7          	jalr	720(ra) # 80006142 <pop_off>
  return p;
}
    80000e7a:	8526                	mv	a0,s1
    80000e7c:	60e2                	ld	ra,24(sp)
    80000e7e:	6442                	ld	s0,16(sp)
    80000e80:	64a2                	ld	s1,8(sp)
    80000e82:	6105                	add	sp,sp,32
    80000e84:	8082                	ret

0000000080000e86 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e86:	1141                	add	sp,sp,-16
    80000e88:	e406                	sd	ra,8(sp)
    80000e8a:	e022                	sd	s0,0(sp)
    80000e8c:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e8e:	00000097          	auipc	ra,0x0
    80000e92:	fc0080e7          	jalr	-64(ra) # 80000e4e <myproc>
    80000e96:	00005097          	auipc	ra,0x5
    80000e9a:	30c080e7          	jalr	780(ra) # 800061a2 <release>

  if (first) {
    80000e9e:	00008797          	auipc	a5,0x8
    80000ea2:	9f27a783          	lw	a5,-1550(a5) # 80008890 <first.1>
    80000ea6:	eb89                	bnez	a5,80000eb8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea8:	00001097          	auipc	ra,0x1
    80000eac:	cea080e7          	jalr	-790(ra) # 80001b92 <usertrapret>
}
    80000eb0:	60a2                	ld	ra,8(sp)
    80000eb2:	6402                	ld	s0,0(sp)
    80000eb4:	0141                	add	sp,sp,16
    80000eb6:	8082                	ret
    first = 0;
    80000eb8:	00008797          	auipc	a5,0x8
    80000ebc:	9c07ac23          	sw	zero,-1576(a5) # 80008890 <first.1>
    fsinit(ROOTDEV);
    80000ec0:	4505                	li	a0,1
    80000ec2:	00002097          	auipc	ra,0x2
    80000ec6:	a2c080e7          	jalr	-1492(ra) # 800028ee <fsinit>
    80000eca:	bff9                	j	80000ea8 <forkret+0x22>

0000000080000ecc <allocpid>:
{
    80000ecc:	1101                	add	sp,sp,-32
    80000ece:	ec06                	sd	ra,24(sp)
    80000ed0:	e822                	sd	s0,16(sp)
    80000ed2:	e426                	sd	s1,8(sp)
    80000ed4:	e04a                	sd	s2,0(sp)
    80000ed6:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80000ed8:	00008917          	auipc	s2,0x8
    80000edc:	a5890913          	add	s2,s2,-1448 # 80008930 <pid_lock>
    80000ee0:	854a                	mv	a0,s2
    80000ee2:	00005097          	auipc	ra,0x5
    80000ee6:	20c080e7          	jalr	524(ra) # 800060ee <acquire>
  pid = nextpid;
    80000eea:	00008797          	auipc	a5,0x8
    80000eee:	9aa78793          	add	a5,a5,-1622 # 80008894 <nextpid>
    80000ef2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef4:	0014871b          	addw	a4,s1,1
    80000ef8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efa:	854a                	mv	a0,s2
    80000efc:	00005097          	auipc	ra,0x5
    80000f00:	2a6080e7          	jalr	678(ra) # 800061a2 <release>
}
    80000f04:	8526                	mv	a0,s1
    80000f06:	60e2                	ld	ra,24(sp)
    80000f08:	6442                	ld	s0,16(sp)
    80000f0a:	64a2                	ld	s1,8(sp)
    80000f0c:	6902                	ld	s2,0(sp)
    80000f0e:	6105                	add	sp,sp,32
    80000f10:	8082                	ret

0000000080000f12 <proc_pagetable>:
{
    80000f12:	1101                	add	sp,sp,-32
    80000f14:	ec06                	sd	ra,24(sp)
    80000f16:	e822                	sd	s0,16(sp)
    80000f18:	e426                	sd	s1,8(sp)
    80000f1a:	e04a                	sd	s2,0(sp)
    80000f1c:	1000                	add	s0,sp,32
    80000f1e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	8ae080e7          	jalr	-1874(ra) # 800007ce <uvmcreate>
    80000f28:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2a:	cd39                	beqz	a0,80000f88 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f2c:	4729                	li	a4,10
    80000f2e:	00006697          	auipc	a3,0x6
    80000f32:	0d268693          	add	a3,a3,210 # 80007000 <_trampoline>
    80000f36:	6605                	lui	a2,0x1
    80000f38:	040005b7          	lui	a1,0x4000
    80000f3c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f3e:	05b2                	sll	a1,a1,0xc
    80000f40:	fffff097          	auipc	ra,0xfffff
    80000f44:	604080e7          	jalr	1540(ra) # 80000544 <mappages>
    80000f48:	04054763          	bltz	a0,80000f96 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f4c:	4719                	li	a4,6
    80000f4e:	06093683          	ld	a3,96(s2)
    80000f52:	6605                	lui	a2,0x1
    80000f54:	020005b7          	lui	a1,0x2000
    80000f58:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f5a:	05b6                	sll	a1,a1,0xd
    80000f5c:	8526                	mv	a0,s1
    80000f5e:	fffff097          	auipc	ra,0xfffff
    80000f62:	5e6080e7          	jalr	1510(ra) # 80000544 <mappages>
    80000f66:	04054063          	bltz	a0,80000fa6 <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80000f6a:	4749                	li	a4,18
    80000f6c:	01893683          	ld	a3,24(s2)
    80000f70:	6605                	lui	a2,0x1
    80000f72:	040005b7          	lui	a1,0x4000
    80000f76:	15f5                	add	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80000f78:	05b2                	sll	a1,a1,0xc
    80000f7a:	8526                	mv	a0,s1
    80000f7c:	fffff097          	auipc	ra,0xfffff
    80000f80:	5c8080e7          	jalr	1480(ra) # 80000544 <mappages>
    80000f84:	04054463          	bltz	a0,80000fcc <proc_pagetable+0xba>
}
    80000f88:	8526                	mv	a0,s1
    80000f8a:	60e2                	ld	ra,24(sp)
    80000f8c:	6442                	ld	s0,16(sp)
    80000f8e:	64a2                	ld	s1,8(sp)
    80000f90:	6902                	ld	s2,0(sp)
    80000f92:	6105                	add	sp,sp,32
    80000f94:	8082                	ret
    uvmfree(pagetable, 0);
    80000f96:	4581                	li	a1,0
    80000f98:	8526                	mv	a0,s1
    80000f9a:	00000097          	auipc	ra,0x0
    80000f9e:	a3a080e7          	jalr	-1478(ra) # 800009d4 <uvmfree>
    return 0;
    80000fa2:	4481                	li	s1,0
    80000fa4:	b7d5                	j	80000f88 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa6:	4681                	li	a3,0
    80000fa8:	4605                	li	a2,1
    80000faa:	040005b7          	lui	a1,0x4000
    80000fae:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb0:	05b2                	sll	a1,a1,0xc
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	756080e7          	jalr	1878(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a14080e7          	jalr	-1516(ra) # 800009d4 <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	bf7d                	j	80000f88 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	040005b7          	lui	a1,0x4000
    80000fd4:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fd6:	05b2                	sll	a1,a1,0xc
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	730080e7          	jalr	1840(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fe2:	4581                	li	a1,0
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9ee080e7          	jalr	-1554(ra) # 800009d4 <uvmfree>
    return 0;
    80000fee:	4481                	li	s1,0
    80000ff0:	bf61                	j	80000f88 <proc_pagetable+0x76>

0000000080000ff2 <proc_freepagetable>:
{
    80000ff2:	7179                	add	sp,sp,-48
    80000ff4:	f406                	sd	ra,40(sp)
    80000ff6:	f022                	sd	s0,32(sp)
    80000ff8:	ec26                	sd	s1,24(sp)
    80000ffa:	e84a                	sd	s2,16(sp)
    80000ffc:	e44e                	sd	s3,8(sp)
    80000ffe:	1800                	add	s0,sp,48
    80001000:	84aa                	mv	s1,a0
    80001002:	89ae                	mv	s3,a1
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001004:	4681                	li	a3,0
    80001006:	4605                	li	a2,1
    80001008:	04000937          	lui	s2,0x4000
    8000100c:	ffd90593          	add	a1,s2,-3 # 3fffffd <_entry-0x7c000003>
    80001010:	05b2                	sll	a1,a1,0xc
    80001012:	fffff097          	auipc	ra,0xfffff
    80001016:	6f8080e7          	jalr	1784(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000101a:	4681                	li	a3,0
    8000101c:	4605                	li	a2,1
    8000101e:	197d                	add	s2,s2,-1
    80001020:	00c91593          	sll	a1,s2,0xc
    80001024:	8526                	mv	a0,s1
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	6e4080e7          	jalr	1764(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000102e:	4681                	li	a3,0
    80001030:	4605                	li	a2,1
    80001032:	020005b7          	lui	a1,0x2000
    80001036:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001038:	05b6                	sll	a1,a1,0xd
    8000103a:	8526                	mv	a0,s1
    8000103c:	fffff097          	auipc	ra,0xfffff
    80001040:	6ce080e7          	jalr	1742(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80001044:	85ce                	mv	a1,s3
    80001046:	8526                	mv	a0,s1
    80001048:	00000097          	auipc	ra,0x0
    8000104c:	98c080e7          	jalr	-1652(ra) # 800009d4 <uvmfree>
}
    80001050:	70a2                	ld	ra,40(sp)
    80001052:	7402                	ld	s0,32(sp)
    80001054:	64e2                	ld	s1,24(sp)
    80001056:	6942                	ld	s2,16(sp)
    80001058:	69a2                	ld	s3,8(sp)
    8000105a:	6145                	add	sp,sp,48
    8000105c:	8082                	ret

000000008000105e <freeproc>:
{
    8000105e:	1101                	add	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	1000                	add	s0,sp,32
    80001068:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000106a:	7128                	ld	a0,96(a0)
    8000106c:	c509                	beqz	a0,80001076 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000106e:	fffff097          	auipc	ra,0xfffff
    80001072:	fae080e7          	jalr	-82(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001076:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    8000107a:	6ca8                	ld	a0,88(s1)
    8000107c:	c511                	beqz	a0,80001088 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000107e:	68ac                	ld	a1,80(s1)
    80001080:	00000097          	auipc	ra,0x0
    80001084:	f72080e7          	jalr	-142(ra) # 80000ff2 <proc_freepagetable>
  p->pagetable = 0;
    80001088:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    8000108c:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001090:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001094:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001098:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    8000109c:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800010a0:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    800010a4:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800010a8:	0204a023          	sw	zero,32(s1)
}
    800010ac:	60e2                	ld	ra,24(sp)
    800010ae:	6442                	ld	s0,16(sp)
    800010b0:	64a2                	ld	s1,8(sp)
    800010b2:	6105                	add	sp,sp,32
    800010b4:	8082                	ret

00000000800010b6 <allocproc>:
{
    800010b6:	1101                	add	sp,sp,-32
    800010b8:	ec06                	sd	ra,24(sp)
    800010ba:	e822                	sd	s0,16(sp)
    800010bc:	e426                	sd	s1,8(sp)
    800010be:	e04a                	sd	s2,0(sp)
    800010c0:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010c2:	00008497          	auipc	s1,0x8
    800010c6:	c9e48493          	add	s1,s1,-866 # 80008d60 <proc>
    800010ca:	0000e917          	auipc	s2,0xe
    800010ce:	89690913          	add	s2,s2,-1898 # 8000e960 <tickslock>
    acquire(&p->lock);
    800010d2:	8526                	mv	a0,s1
    800010d4:	00005097          	auipc	ra,0x5
    800010d8:	01a080e7          	jalr	26(ra) # 800060ee <acquire>
    if(p->state == UNUSED) {
    800010dc:	509c                	lw	a5,32(s1)
    800010de:	cf81                	beqz	a5,800010f6 <allocproc+0x40>
      release(&p->lock);
    800010e0:	8526                	mv	a0,s1
    800010e2:	00005097          	auipc	ra,0x5
    800010e6:	0c0080e7          	jalr	192(ra) # 800061a2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ea:	17048493          	add	s1,s1,368
    800010ee:	ff2492e3          	bne	s1,s2,800010d2 <allocproc+0x1c>
  return 0;
    800010f2:	4481                	li	s1,0
    800010f4:	a0ad                	j	8000115e <allocproc+0xa8>
  p->pid = allocpid();
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	dd6080e7          	jalr	-554(ra) # 80000ecc <allocpid>
    800010fe:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80001100:	4785                	li	a5,1
    80001102:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	016080e7          	jalr	22(ra) # 8000011a <kalloc>
    8000110c:	892a                	mv	s2,a0
    8000110e:	f0a8                	sd	a0,96(s1)
    80001110:	cd31                	beqz	a0,8000116c <allocproc+0xb6>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	008080e7          	jalr	8(ra) # 8000011a <kalloc>
    8000111a:	892a                	mv	s2,a0
    8000111c:	ec88                	sd	a0,24(s1)
    8000111e:	c13d                	beqz	a0,80001184 <allocproc+0xce>
  p->pagetable = proc_pagetable(p);
    80001120:	8526                	mv	a0,s1
    80001122:	00000097          	auipc	ra,0x0
    80001126:	df0080e7          	jalr	-528(ra) # 80000f12 <proc_pagetable>
    8000112a:	eca8                	sd	a0,88(s1)
  p->usyscall->pid = p->pid;
    8000112c:	6c9c                	ld	a5,24(s1)
    8000112e:	5c98                	lw	a4,56(s1)
    80001130:	c398                	sw	a4,0(a5)
  if(p->pagetable == 0){
    80001132:	0584b903          	ld	s2,88(s1)
    80001136:	06090363          	beqz	s2,8000119c <allocproc+0xe6>
  memset(&p->context, 0, sizeof(p->context));
    8000113a:	07000613          	li	a2,112
    8000113e:	4581                	li	a1,0
    80001140:	06848513          	add	a0,s1,104
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	036080e7          	jalr	54(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000114c:	00000797          	auipc	a5,0x0
    80001150:	d3a78793          	add	a5,a5,-710 # 80000e86 <forkret>
    80001154:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001156:	64bc                	ld	a5,72(s1)
    80001158:	6705                	lui	a4,0x1
    8000115a:	97ba                	add	a5,a5,a4
    8000115c:	f8bc                	sd	a5,112(s1)
}
    8000115e:	8526                	mv	a0,s1
    80001160:	60e2                	ld	ra,24(sp)
    80001162:	6442                	ld	s0,16(sp)
    80001164:	64a2                	ld	s1,8(sp)
    80001166:	6902                	ld	s2,0(sp)
    80001168:	6105                	add	sp,sp,32
    8000116a:	8082                	ret
    freeproc(p);
    8000116c:	8526                	mv	a0,s1
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	ef0080e7          	jalr	-272(ra) # 8000105e <freeproc>
    release(&p->lock);
    80001176:	8526                	mv	a0,s1
    80001178:	00005097          	auipc	ra,0x5
    8000117c:	02a080e7          	jalr	42(ra) # 800061a2 <release>
    return 0;
    80001180:	84ca                	mv	s1,s2
    80001182:	bff1                	j	8000115e <allocproc+0xa8>
    freeproc(p);
    80001184:	8526                	mv	a0,s1
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	ed8080e7          	jalr	-296(ra) # 8000105e <freeproc>
    release(&p->lock);
    8000118e:	8526                	mv	a0,s1
    80001190:	00005097          	auipc	ra,0x5
    80001194:	012080e7          	jalr	18(ra) # 800061a2 <release>
    return 0;
    80001198:	84ca                	mv	s1,s2
    8000119a:	b7d1                	j	8000115e <allocproc+0xa8>
    freeproc(p);
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	ec0080e7          	jalr	-320(ra) # 8000105e <freeproc>
    release(&p->lock);
    800011a6:	8526                	mv	a0,s1
    800011a8:	00005097          	auipc	ra,0x5
    800011ac:	ffa080e7          	jalr	-6(ra) # 800061a2 <release>
    return 0;
    800011b0:	84ca                	mv	s1,s2
    800011b2:	b775                	j	8000115e <allocproc+0xa8>

00000000800011b4 <userinit>:
{
    800011b4:	1101                	add	sp,sp,-32
    800011b6:	ec06                	sd	ra,24(sp)
    800011b8:	e822                	sd	s0,16(sp)
    800011ba:	e426                	sd	s1,8(sp)
    800011bc:	1000                	add	s0,sp,32
  p = allocproc();
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	ef8080e7          	jalr	-264(ra) # 800010b6 <allocproc>
    800011c6:	84aa                	mv	s1,a0
  initproc = p;
    800011c8:	00007797          	auipc	a5,0x7
    800011cc:	72a7b423          	sd	a0,1832(a5) # 800088f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011d0:	03400613          	li	a2,52
    800011d4:	00007597          	auipc	a1,0x7
    800011d8:	6cc58593          	add	a1,a1,1740 # 800088a0 <initcode>
    800011dc:	6d28                	ld	a0,88(a0)
    800011de:	fffff097          	auipc	ra,0xfffff
    800011e2:	61e080e7          	jalr	1566(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    800011e6:	6785                	lui	a5,0x1
    800011e8:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ea:	70b8                	ld	a4,96(s1)
    800011ec:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011f0:	70b8                	ld	a4,96(s1)
    800011f2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011f4:	4641                	li	a2,16
    800011f6:	00007597          	auipc	a1,0x7
    800011fa:	f8a58593          	add	a1,a1,-118 # 80008180 <etext+0x180>
    800011fe:	16048513          	add	a0,s1,352
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	0c0080e7          	jalr	192(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    8000120a:	00007517          	auipc	a0,0x7
    8000120e:	f8650513          	add	a0,a0,-122 # 80008190 <etext+0x190>
    80001212:	00002097          	auipc	ra,0x2
    80001216:	0fa080e7          	jalr	250(ra) # 8000330c <namei>
    8000121a:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000121e:	478d                	li	a5,3
    80001220:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001222:	8526                	mv	a0,s1
    80001224:	00005097          	auipc	ra,0x5
    80001228:	f7e080e7          	jalr	-130(ra) # 800061a2 <release>
}
    8000122c:	60e2                	ld	ra,24(sp)
    8000122e:	6442                	ld	s0,16(sp)
    80001230:	64a2                	ld	s1,8(sp)
    80001232:	6105                	add	sp,sp,32
    80001234:	8082                	ret

0000000080001236 <growproc>:
{
    80001236:	1101                	add	sp,sp,-32
    80001238:	ec06                	sd	ra,24(sp)
    8000123a:	e822                	sd	s0,16(sp)
    8000123c:	e426                	sd	s1,8(sp)
    8000123e:	e04a                	sd	s2,0(sp)
    80001240:	1000                	add	s0,sp,32
    80001242:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001244:	00000097          	auipc	ra,0x0
    80001248:	c0a080e7          	jalr	-1014(ra) # 80000e4e <myproc>
    8000124c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000124e:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001250:	01204c63          	bgtz	s2,80001268 <growproc+0x32>
  } else if(n < 0){
    80001254:	02094663          	bltz	s2,80001280 <growproc+0x4a>
  p->sz = sz;
    80001258:	e8ac                	sd	a1,80(s1)
  return 0;
    8000125a:	4501                	li	a0,0
}
    8000125c:	60e2                	ld	ra,24(sp)
    8000125e:	6442                	ld	s0,16(sp)
    80001260:	64a2                	ld	s1,8(sp)
    80001262:	6902                	ld	s2,0(sp)
    80001264:	6105                	add	sp,sp,32
    80001266:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001268:	4691                	li	a3,4
    8000126a:	00b90633          	add	a2,s2,a1
    8000126e:	6d28                	ld	a0,88(a0)
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	646080e7          	jalr	1606(ra) # 800008b6 <uvmalloc>
    80001278:	85aa                	mv	a1,a0
    8000127a:	fd79                	bnez	a0,80001258 <growproc+0x22>
      return -1;
    8000127c:	557d                	li	a0,-1
    8000127e:	bff9                	j	8000125c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001280:	00b90633          	add	a2,s2,a1
    80001284:	6d28                	ld	a0,88(a0)
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	5e8080e7          	jalr	1512(ra) # 8000086e <uvmdealloc>
    8000128e:	85aa                	mv	a1,a0
    80001290:	b7e1                	j	80001258 <growproc+0x22>

0000000080001292 <fork>:
{
    80001292:	7139                	add	sp,sp,-64
    80001294:	fc06                	sd	ra,56(sp)
    80001296:	f822                	sd	s0,48(sp)
    80001298:	f426                	sd	s1,40(sp)
    8000129a:	f04a                	sd	s2,32(sp)
    8000129c:	ec4e                	sd	s3,24(sp)
    8000129e:	e852                	sd	s4,16(sp)
    800012a0:	e456                	sd	s5,8(sp)
    800012a2:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	baa080e7          	jalr	-1110(ra) # 80000e4e <myproc>
    800012ac:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	e08080e7          	jalr	-504(ra) # 800010b6 <allocproc>
    800012b6:	10050c63          	beqz	a0,800013ce <fork+0x13c>
    800012ba:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012bc:	050ab603          	ld	a2,80(s5)
    800012c0:	6d2c                	ld	a1,88(a0)
    800012c2:	058ab503          	ld	a0,88(s5)
    800012c6:	fffff097          	auipc	ra,0xfffff
    800012ca:	748080e7          	jalr	1864(ra) # 80000a0e <uvmcopy>
    800012ce:	04054863          	bltz	a0,8000131e <fork+0x8c>
  np->sz = p->sz;
    800012d2:	050ab783          	ld	a5,80(s5)
    800012d6:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    800012da:	060ab683          	ld	a3,96(s5)
    800012de:	87b6                	mv	a5,a3
    800012e0:	060a3703          	ld	a4,96(s4)
    800012e4:	12068693          	add	a3,a3,288
    800012e8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ec:	6788                	ld	a0,8(a5)
    800012ee:	6b8c                	ld	a1,16(a5)
    800012f0:	6f90                	ld	a2,24(a5)
    800012f2:	01073023          	sd	a6,0(a4)
    800012f6:	e708                	sd	a0,8(a4)
    800012f8:	eb0c                	sd	a1,16(a4)
    800012fa:	ef10                	sd	a2,24(a4)
    800012fc:	02078793          	add	a5,a5,32
    80001300:	02070713          	add	a4,a4,32
    80001304:	fed792e3          	bne	a5,a3,800012e8 <fork+0x56>
  np->trapframe->a0 = 0;
    80001308:	060a3783          	ld	a5,96(s4)
    8000130c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001310:	0d8a8493          	add	s1,s5,216
    80001314:	0d8a0913          	add	s2,s4,216
    80001318:	158a8993          	add	s3,s5,344
    8000131c:	a00d                	j	8000133e <fork+0xac>
    freeproc(np);
    8000131e:	8552                	mv	a0,s4
    80001320:	00000097          	auipc	ra,0x0
    80001324:	d3e080e7          	jalr	-706(ra) # 8000105e <freeproc>
    release(&np->lock);
    80001328:	8552                	mv	a0,s4
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	e78080e7          	jalr	-392(ra) # 800061a2 <release>
    return -1;
    80001332:	597d                	li	s2,-1
    80001334:	a059                	j	800013ba <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001336:	04a1                	add	s1,s1,8
    80001338:	0921                	add	s2,s2,8
    8000133a:	01348b63          	beq	s1,s3,80001350 <fork+0xbe>
    if(p->ofile[i])
    8000133e:	6088                	ld	a0,0(s1)
    80001340:	d97d                	beqz	a0,80001336 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001342:	00002097          	auipc	ra,0x2
    80001346:	63c080e7          	jalr	1596(ra) # 8000397e <filedup>
    8000134a:	00a93023          	sd	a0,0(s2)
    8000134e:	b7e5                	j	80001336 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001350:	158ab503          	ld	a0,344(s5)
    80001354:	00001097          	auipc	ra,0x1
    80001358:	7d4080e7          	jalr	2004(ra) # 80002b28 <idup>
    8000135c:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001360:	4641                	li	a2,16
    80001362:	160a8593          	add	a1,s5,352
    80001366:	160a0513          	add	a0,s4,352
    8000136a:	fffff097          	auipc	ra,0xfffff
    8000136e:	f58080e7          	jalr	-168(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001372:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    80001376:	8552                	mv	a0,s4
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	e2a080e7          	jalr	-470(ra) # 800061a2 <release>
  acquire(&wait_lock);
    80001380:	00007497          	auipc	s1,0x7
    80001384:	5c848493          	add	s1,s1,1480 # 80008948 <wait_lock>
    80001388:	8526                	mv	a0,s1
    8000138a:	00005097          	auipc	ra,0x5
    8000138e:	d64080e7          	jalr	-668(ra) # 800060ee <acquire>
  np->parent = p;
    80001392:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001396:	8526                	mv	a0,s1
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	e0a080e7          	jalr	-502(ra) # 800061a2 <release>
  acquire(&np->lock);
    800013a0:	8552                	mv	a0,s4
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	d4c080e7          	jalr	-692(ra) # 800060ee <acquire>
  np->state = RUNNABLE;
    800013aa:	478d                	li	a5,3
    800013ac:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    800013b0:	8552                	mv	a0,s4
    800013b2:	00005097          	auipc	ra,0x5
    800013b6:	df0080e7          	jalr	-528(ra) # 800061a2 <release>
}
    800013ba:	854a                	mv	a0,s2
    800013bc:	70e2                	ld	ra,56(sp)
    800013be:	7442                	ld	s0,48(sp)
    800013c0:	74a2                	ld	s1,40(sp)
    800013c2:	7902                	ld	s2,32(sp)
    800013c4:	69e2                	ld	s3,24(sp)
    800013c6:	6a42                	ld	s4,16(sp)
    800013c8:	6aa2                	ld	s5,8(sp)
    800013ca:	6121                	add	sp,sp,64
    800013cc:	8082                	ret
    return -1;
    800013ce:	597d                	li	s2,-1
    800013d0:	b7ed                	j	800013ba <fork+0x128>

00000000800013d2 <scheduler>:
{
    800013d2:	7139                	add	sp,sp,-64
    800013d4:	fc06                	sd	ra,56(sp)
    800013d6:	f822                	sd	s0,48(sp)
    800013d8:	f426                	sd	s1,40(sp)
    800013da:	f04a                	sd	s2,32(sp)
    800013dc:	ec4e                	sd	s3,24(sp)
    800013de:	e852                	sd	s4,16(sp)
    800013e0:	e456                	sd	s5,8(sp)
    800013e2:	e05a                	sd	s6,0(sp)
    800013e4:	0080                	add	s0,sp,64
    800013e6:	8792                	mv	a5,tp
  int id = r_tp();
    800013e8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ea:	00779a93          	sll	s5,a5,0x7
    800013ee:	00007717          	auipc	a4,0x7
    800013f2:	54270713          	add	a4,a4,1346 # 80008930 <pid_lock>
    800013f6:	9756                	add	a4,a4,s5
    800013f8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013fc:	00007717          	auipc	a4,0x7
    80001400:	56c70713          	add	a4,a4,1388 # 80008968 <cpus+0x8>
    80001404:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001406:	498d                	li	s3,3
        p->state = RUNNING;
    80001408:	4b11                	li	s6,4
        c->proc = p;
    8000140a:	079e                	sll	a5,a5,0x7
    8000140c:	00007a17          	auipc	s4,0x7
    80001410:	524a0a13          	add	s4,s4,1316 # 80008930 <pid_lock>
    80001414:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001416:	0000d917          	auipc	s2,0xd
    8000141a:	54a90913          	add	s2,s2,1354 # 8000e960 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000141e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001422:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001426:	10079073          	csrw	sstatus,a5
    8000142a:	00008497          	auipc	s1,0x8
    8000142e:	93648493          	add	s1,s1,-1738 # 80008d60 <proc>
    80001432:	a811                	j	80001446 <scheduler+0x74>
      release(&p->lock);
    80001434:	8526                	mv	a0,s1
    80001436:	00005097          	auipc	ra,0x5
    8000143a:	d6c080e7          	jalr	-660(ra) # 800061a2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000143e:	17048493          	add	s1,s1,368
    80001442:	fd248ee3          	beq	s1,s2,8000141e <scheduler+0x4c>
      acquire(&p->lock);
    80001446:	8526                	mv	a0,s1
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	ca6080e7          	jalr	-858(ra) # 800060ee <acquire>
      if(p->state == RUNNABLE) {
    80001450:	509c                	lw	a5,32(s1)
    80001452:	ff3791e3          	bne	a5,s3,80001434 <scheduler+0x62>
        p->state = RUNNING;
    80001456:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    8000145a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000145e:	06848593          	add	a1,s1,104
    80001462:	8556                	mv	a0,s5
    80001464:	00000097          	auipc	ra,0x0
    80001468:	684080e7          	jalr	1668(ra) # 80001ae8 <swtch>
        c->proc = 0;
    8000146c:	020a3823          	sd	zero,48(s4)
    80001470:	b7d1                	j	80001434 <scheduler+0x62>

0000000080001472 <sched>:
{
    80001472:	7179                	add	sp,sp,-48
    80001474:	f406                	sd	ra,40(sp)
    80001476:	f022                	sd	s0,32(sp)
    80001478:	ec26                	sd	s1,24(sp)
    8000147a:	e84a                	sd	s2,16(sp)
    8000147c:	e44e                	sd	s3,8(sp)
    8000147e:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001480:	00000097          	auipc	ra,0x0
    80001484:	9ce080e7          	jalr	-1586(ra) # 80000e4e <myproc>
    80001488:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000148a:	00005097          	auipc	ra,0x5
    8000148e:	bea080e7          	jalr	-1046(ra) # 80006074 <holding>
    80001492:	c93d                	beqz	a0,80001508 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001494:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001496:	2781                	sext.w	a5,a5
    80001498:	079e                	sll	a5,a5,0x7
    8000149a:	00007717          	auipc	a4,0x7
    8000149e:	49670713          	add	a4,a4,1174 # 80008930 <pid_lock>
    800014a2:	97ba                	add	a5,a5,a4
    800014a4:	0a87a703          	lw	a4,168(a5)
    800014a8:	4785                	li	a5,1
    800014aa:	06f71763          	bne	a4,a5,80001518 <sched+0xa6>
  if(p->state == RUNNING)
    800014ae:	5098                	lw	a4,32(s1)
    800014b0:	4791                	li	a5,4
    800014b2:	06f70b63          	beq	a4,a5,80001528 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014b6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ba:	8b89                	and	a5,a5,2
  if(intr_get())
    800014bc:	efb5                	bnez	a5,80001538 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014be:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014c0:	00007917          	auipc	s2,0x7
    800014c4:	47090913          	add	s2,s2,1136 # 80008930 <pid_lock>
    800014c8:	2781                	sext.w	a5,a5
    800014ca:	079e                	sll	a5,a5,0x7
    800014cc:	97ca                	add	a5,a5,s2
    800014ce:	0ac7a983          	lw	s3,172(a5)
    800014d2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014d4:	2781                	sext.w	a5,a5
    800014d6:	079e                	sll	a5,a5,0x7
    800014d8:	00007597          	auipc	a1,0x7
    800014dc:	49058593          	add	a1,a1,1168 # 80008968 <cpus+0x8>
    800014e0:	95be                	add	a1,a1,a5
    800014e2:	06848513          	add	a0,s1,104
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	602080e7          	jalr	1538(ra) # 80001ae8 <swtch>
    800014ee:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014f0:	2781                	sext.w	a5,a5
    800014f2:	079e                	sll	a5,a5,0x7
    800014f4:	993e                	add	s2,s2,a5
    800014f6:	0b392623          	sw	s3,172(s2)
}
    800014fa:	70a2                	ld	ra,40(sp)
    800014fc:	7402                	ld	s0,32(sp)
    800014fe:	64e2                	ld	s1,24(sp)
    80001500:	6942                	ld	s2,16(sp)
    80001502:	69a2                	ld	s3,8(sp)
    80001504:	6145                	add	sp,sp,48
    80001506:	8082                	ret
    panic("sched p->lock");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	c9050513          	add	a0,a0,-880 # 80008198 <etext+0x198>
    80001510:	00004097          	auipc	ra,0x4
    80001514:	6a6080e7          	jalr	1702(ra) # 80005bb6 <panic>
    panic("sched locks");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	c9050513          	add	a0,a0,-880 # 800081a8 <etext+0x1a8>
    80001520:	00004097          	auipc	ra,0x4
    80001524:	696080e7          	jalr	1686(ra) # 80005bb6 <panic>
    panic("sched running");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	c9050513          	add	a0,a0,-880 # 800081b8 <etext+0x1b8>
    80001530:	00004097          	auipc	ra,0x4
    80001534:	686080e7          	jalr	1670(ra) # 80005bb6 <panic>
    panic("sched interruptible");
    80001538:	00007517          	auipc	a0,0x7
    8000153c:	c9050513          	add	a0,a0,-880 # 800081c8 <etext+0x1c8>
    80001540:	00004097          	auipc	ra,0x4
    80001544:	676080e7          	jalr	1654(ra) # 80005bb6 <panic>

0000000080001548 <yield>:
{
    80001548:	1101                	add	sp,sp,-32
    8000154a:	ec06                	sd	ra,24(sp)
    8000154c:	e822                	sd	s0,16(sp)
    8000154e:	e426                	sd	s1,8(sp)
    80001550:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001552:	00000097          	auipc	ra,0x0
    80001556:	8fc080e7          	jalr	-1796(ra) # 80000e4e <myproc>
    8000155a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	b92080e7          	jalr	-1134(ra) # 800060ee <acquire>
  p->state = RUNNABLE;
    80001564:	478d                	li	a5,3
    80001566:	d09c                	sw	a5,32(s1)
  sched();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	f0a080e7          	jalr	-246(ra) # 80001472 <sched>
  release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	c30080e7          	jalr	-976(ra) # 800061a2 <release>
}
    8000157a:	60e2                	ld	ra,24(sp)
    8000157c:	6442                	ld	s0,16(sp)
    8000157e:	64a2                	ld	s1,8(sp)
    80001580:	6105                	add	sp,sp,32
    80001582:	8082                	ret

0000000080001584 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001584:	7179                	add	sp,sp,-48
    80001586:	f406                	sd	ra,40(sp)
    80001588:	f022                	sd	s0,32(sp)
    8000158a:	ec26                	sd	s1,24(sp)
    8000158c:	e84a                	sd	s2,16(sp)
    8000158e:	e44e                	sd	s3,8(sp)
    80001590:	1800                	add	s0,sp,48
    80001592:	89aa                	mv	s3,a0
    80001594:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	8b8080e7          	jalr	-1864(ra) # 80000e4e <myproc>
    8000159e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	b4e080e7          	jalr	-1202(ra) # 800060ee <acquire>
  release(lk);
    800015a8:	854a                	mv	a0,s2
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	bf8080e7          	jalr	-1032(ra) # 800061a2 <release>

  // Go to sleep.
  p->chan = chan;
    800015b2:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800015b6:	4789                	li	a5,2
    800015b8:	d09c                	sw	a5,32(s1)

  sched();
    800015ba:	00000097          	auipc	ra,0x0
    800015be:	eb8080e7          	jalr	-328(ra) # 80001472 <sched>

  // Tidy up.
  p->chan = 0;
    800015c2:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015c6:	8526                	mv	a0,s1
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	bda080e7          	jalr	-1062(ra) # 800061a2 <release>
  acquire(lk);
    800015d0:	854a                	mv	a0,s2
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	b1c080e7          	jalr	-1252(ra) # 800060ee <acquire>
}
    800015da:	70a2                	ld	ra,40(sp)
    800015dc:	7402                	ld	s0,32(sp)
    800015de:	64e2                	ld	s1,24(sp)
    800015e0:	6942                	ld	s2,16(sp)
    800015e2:	69a2                	ld	s3,8(sp)
    800015e4:	6145                	add	sp,sp,48
    800015e6:	8082                	ret

00000000800015e8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015e8:	7139                	add	sp,sp,-64
    800015ea:	fc06                	sd	ra,56(sp)
    800015ec:	f822                	sd	s0,48(sp)
    800015ee:	f426                	sd	s1,40(sp)
    800015f0:	f04a                	sd	s2,32(sp)
    800015f2:	ec4e                	sd	s3,24(sp)
    800015f4:	e852                	sd	s4,16(sp)
    800015f6:	e456                	sd	s5,8(sp)
    800015f8:	0080                	add	s0,sp,64
    800015fa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015fc:	00007497          	auipc	s1,0x7
    80001600:	76448493          	add	s1,s1,1892 # 80008d60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001604:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001606:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001608:	0000d917          	auipc	s2,0xd
    8000160c:	35890913          	add	s2,s2,856 # 8000e960 <tickslock>
    80001610:	a811                	j	80001624 <wakeup+0x3c>
      }
      release(&p->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	00005097          	auipc	ra,0x5
    80001618:	b8e080e7          	jalr	-1138(ra) # 800061a2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000161c:	17048493          	add	s1,s1,368
    80001620:	03248663          	beq	s1,s2,8000164c <wakeup+0x64>
    if(p != myproc()){
    80001624:	00000097          	auipc	ra,0x0
    80001628:	82a080e7          	jalr	-2006(ra) # 80000e4e <myproc>
    8000162c:	fea488e3          	beq	s1,a0,8000161c <wakeup+0x34>
      acquire(&p->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	abc080e7          	jalr	-1348(ra) # 800060ee <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000163a:	509c                	lw	a5,32(s1)
    8000163c:	fd379be3          	bne	a5,s3,80001612 <wakeup+0x2a>
    80001640:	749c                	ld	a5,40(s1)
    80001642:	fd4798e3          	bne	a5,s4,80001612 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001646:	0354a023          	sw	s5,32(s1)
    8000164a:	b7e1                	j	80001612 <wakeup+0x2a>
    }
  }
}
    8000164c:	70e2                	ld	ra,56(sp)
    8000164e:	7442                	ld	s0,48(sp)
    80001650:	74a2                	ld	s1,40(sp)
    80001652:	7902                	ld	s2,32(sp)
    80001654:	69e2                	ld	s3,24(sp)
    80001656:	6a42                	ld	s4,16(sp)
    80001658:	6aa2                	ld	s5,8(sp)
    8000165a:	6121                	add	sp,sp,64
    8000165c:	8082                	ret

000000008000165e <reparent>:
{
    8000165e:	7179                	add	sp,sp,-48
    80001660:	f406                	sd	ra,40(sp)
    80001662:	f022                	sd	s0,32(sp)
    80001664:	ec26                	sd	s1,24(sp)
    80001666:	e84a                	sd	s2,16(sp)
    80001668:	e44e                	sd	s3,8(sp)
    8000166a:	e052                	sd	s4,0(sp)
    8000166c:	1800                	add	s0,sp,48
    8000166e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001670:	00007497          	auipc	s1,0x7
    80001674:	6f048493          	add	s1,s1,1776 # 80008d60 <proc>
      pp->parent = initproc;
    80001678:	00007a17          	auipc	s4,0x7
    8000167c:	278a0a13          	add	s4,s4,632 # 800088f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001680:	0000d997          	auipc	s3,0xd
    80001684:	2e098993          	add	s3,s3,736 # 8000e960 <tickslock>
    80001688:	a029                	j	80001692 <reparent+0x34>
    8000168a:	17048493          	add	s1,s1,368
    8000168e:	01348d63          	beq	s1,s3,800016a8 <reparent+0x4a>
    if(pp->parent == p){
    80001692:	60bc                	ld	a5,64(s1)
    80001694:	ff279be3          	bne	a5,s2,8000168a <reparent+0x2c>
      pp->parent = initproc;
    80001698:	000a3503          	ld	a0,0(s4)
    8000169c:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	f4a080e7          	jalr	-182(ra) # 800015e8 <wakeup>
    800016a6:	b7d5                	j	8000168a <reparent+0x2c>
}
    800016a8:	70a2                	ld	ra,40(sp)
    800016aa:	7402                	ld	s0,32(sp)
    800016ac:	64e2                	ld	s1,24(sp)
    800016ae:	6942                	ld	s2,16(sp)
    800016b0:	69a2                	ld	s3,8(sp)
    800016b2:	6a02                	ld	s4,0(sp)
    800016b4:	6145                	add	sp,sp,48
    800016b6:	8082                	ret

00000000800016b8 <exit>:
{
    800016b8:	7179                	add	sp,sp,-48
    800016ba:	f406                	sd	ra,40(sp)
    800016bc:	f022                	sd	s0,32(sp)
    800016be:	ec26                	sd	s1,24(sp)
    800016c0:	e84a                	sd	s2,16(sp)
    800016c2:	e44e                	sd	s3,8(sp)
    800016c4:	e052                	sd	s4,0(sp)
    800016c6:	1800                	add	s0,sp,48
    800016c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016ca:	fffff097          	auipc	ra,0xfffff
    800016ce:	784080e7          	jalr	1924(ra) # 80000e4e <myproc>
    800016d2:	89aa                	mv	s3,a0
  if(p == initproc)
    800016d4:	00007797          	auipc	a5,0x7
    800016d8:	21c7b783          	ld	a5,540(a5) # 800088f0 <initproc>
    800016dc:	0d850493          	add	s1,a0,216
    800016e0:	15850913          	add	s2,a0,344
    800016e4:	02a79363          	bne	a5,a0,8000170a <exit+0x52>
    panic("init exiting");
    800016e8:	00007517          	auipc	a0,0x7
    800016ec:	af850513          	add	a0,a0,-1288 # 800081e0 <etext+0x1e0>
    800016f0:	00004097          	auipc	ra,0x4
    800016f4:	4c6080e7          	jalr	1222(ra) # 80005bb6 <panic>
      fileclose(f);
    800016f8:	00002097          	auipc	ra,0x2
    800016fc:	2d8080e7          	jalr	728(ra) # 800039d0 <fileclose>
      p->ofile[fd] = 0;
    80001700:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001704:	04a1                	add	s1,s1,8
    80001706:	01248563          	beq	s1,s2,80001710 <exit+0x58>
    if(p->ofile[fd]){
    8000170a:	6088                	ld	a0,0(s1)
    8000170c:	f575                	bnez	a0,800016f8 <exit+0x40>
    8000170e:	bfdd                	j	80001704 <exit+0x4c>
  begin_op();
    80001710:	00002097          	auipc	ra,0x2
    80001714:	dfc080e7          	jalr	-516(ra) # 8000350c <begin_op>
  iput(p->cwd);
    80001718:	1589b503          	ld	a0,344(s3)
    8000171c:	00001097          	auipc	ra,0x1
    80001720:	604080e7          	jalr	1540(ra) # 80002d20 <iput>
  end_op();
    80001724:	00002097          	auipc	ra,0x2
    80001728:	e62080e7          	jalr	-414(ra) # 80003586 <end_op>
  p->cwd = 0;
    8000172c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001730:	00007497          	auipc	s1,0x7
    80001734:	21848493          	add	s1,s1,536 # 80008948 <wait_lock>
    80001738:	8526                	mv	a0,s1
    8000173a:	00005097          	auipc	ra,0x5
    8000173e:	9b4080e7          	jalr	-1612(ra) # 800060ee <acquire>
  reparent(p);
    80001742:	854e                	mv	a0,s3
    80001744:	00000097          	auipc	ra,0x0
    80001748:	f1a080e7          	jalr	-230(ra) # 8000165e <reparent>
  wakeup(p->parent);
    8000174c:	0409b503          	ld	a0,64(s3)
    80001750:	00000097          	auipc	ra,0x0
    80001754:	e98080e7          	jalr	-360(ra) # 800015e8 <wakeup>
  acquire(&p->lock);
    80001758:	854e                	mv	a0,s3
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	994080e7          	jalr	-1644(ra) # 800060ee <acquire>
  p->xstate = status;
    80001762:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001766:	4795                	li	a5,5
    80001768:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	a34080e7          	jalr	-1484(ra) # 800061a2 <release>
  sched();
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	cfc080e7          	jalr	-772(ra) # 80001472 <sched>
  panic("zombie exit");
    8000177e:	00007517          	auipc	a0,0x7
    80001782:	a7250513          	add	a0,a0,-1422 # 800081f0 <etext+0x1f0>
    80001786:	00004097          	auipc	ra,0x4
    8000178a:	430080e7          	jalr	1072(ra) # 80005bb6 <panic>

000000008000178e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000178e:	7179                	add	sp,sp,-48
    80001790:	f406                	sd	ra,40(sp)
    80001792:	f022                	sd	s0,32(sp)
    80001794:	ec26                	sd	s1,24(sp)
    80001796:	e84a                	sd	s2,16(sp)
    80001798:	e44e                	sd	s3,8(sp)
    8000179a:	1800                	add	s0,sp,48
    8000179c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000179e:	00007497          	auipc	s1,0x7
    800017a2:	5c248493          	add	s1,s1,1474 # 80008d60 <proc>
    800017a6:	0000d997          	auipc	s3,0xd
    800017aa:	1ba98993          	add	s3,s3,442 # 8000e960 <tickslock>
    acquire(&p->lock);
    800017ae:	8526                	mv	a0,s1
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	93e080e7          	jalr	-1730(ra) # 800060ee <acquire>
    if(p->pid == pid){
    800017b8:	5c9c                	lw	a5,56(s1)
    800017ba:	01278d63          	beq	a5,s2,800017d4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	9e2080e7          	jalr	-1566(ra) # 800061a2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017c8:	17048493          	add	s1,s1,368
    800017cc:	ff3491e3          	bne	s1,s3,800017ae <kill+0x20>
  }
  return -1;
    800017d0:	557d                	li	a0,-1
    800017d2:	a829                	j	800017ec <kill+0x5e>
      p->killed = 1;
    800017d4:	4785                	li	a5,1
    800017d6:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800017d8:	5098                	lw	a4,32(s1)
    800017da:	4789                	li	a5,2
    800017dc:	00f70f63          	beq	a4,a5,800017fa <kill+0x6c>
      release(&p->lock);
    800017e0:	8526                	mv	a0,s1
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	9c0080e7          	jalr	-1600(ra) # 800061a2 <release>
      return 0;
    800017ea:	4501                	li	a0,0
}
    800017ec:	70a2                	ld	ra,40(sp)
    800017ee:	7402                	ld	s0,32(sp)
    800017f0:	64e2                	ld	s1,24(sp)
    800017f2:	6942                	ld	s2,16(sp)
    800017f4:	69a2                	ld	s3,8(sp)
    800017f6:	6145                	add	sp,sp,48
    800017f8:	8082                	ret
        p->state = RUNNABLE;
    800017fa:	478d                	li	a5,3
    800017fc:	d09c                	sw	a5,32(s1)
    800017fe:	b7cd                	j	800017e0 <kill+0x52>

0000000080001800 <setkilled>:

void
setkilled(struct proc *p)
{
    80001800:	1101                	add	sp,sp,-32
    80001802:	ec06                	sd	ra,24(sp)
    80001804:	e822                	sd	s0,16(sp)
    80001806:	e426                	sd	s1,8(sp)
    80001808:	1000                	add	s0,sp,32
    8000180a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	8e2080e7          	jalr	-1822(ra) # 800060ee <acquire>
  p->killed = 1;
    80001814:	4785                	li	a5,1
    80001816:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	988080e7          	jalr	-1656(ra) # 800061a2 <release>
}
    80001822:	60e2                	ld	ra,24(sp)
    80001824:	6442                	ld	s0,16(sp)
    80001826:	64a2                	ld	s1,8(sp)
    80001828:	6105                	add	sp,sp,32
    8000182a:	8082                	ret

000000008000182c <killed>:

int
killed(struct proc *p)
{
    8000182c:	1101                	add	sp,sp,-32
    8000182e:	ec06                	sd	ra,24(sp)
    80001830:	e822                	sd	s0,16(sp)
    80001832:	e426                	sd	s1,8(sp)
    80001834:	e04a                	sd	s2,0(sp)
    80001836:	1000                	add	s0,sp,32
    80001838:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	8b4080e7          	jalr	-1868(ra) # 800060ee <acquire>
  k = p->killed;
    80001842:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    80001846:	8526                	mv	a0,s1
    80001848:	00005097          	auipc	ra,0x5
    8000184c:	95a080e7          	jalr	-1702(ra) # 800061a2 <release>
  return k;
}
    80001850:	854a                	mv	a0,s2
    80001852:	60e2                	ld	ra,24(sp)
    80001854:	6442                	ld	s0,16(sp)
    80001856:	64a2                	ld	s1,8(sp)
    80001858:	6902                	ld	s2,0(sp)
    8000185a:	6105                	add	sp,sp,32
    8000185c:	8082                	ret

000000008000185e <wait>:
{
    8000185e:	715d                	add	sp,sp,-80
    80001860:	e486                	sd	ra,72(sp)
    80001862:	e0a2                	sd	s0,64(sp)
    80001864:	fc26                	sd	s1,56(sp)
    80001866:	f84a                	sd	s2,48(sp)
    80001868:	f44e                	sd	s3,40(sp)
    8000186a:	f052                	sd	s4,32(sp)
    8000186c:	ec56                	sd	s5,24(sp)
    8000186e:	e85a                	sd	s6,16(sp)
    80001870:	e45e                	sd	s7,8(sp)
    80001872:	e062                	sd	s8,0(sp)
    80001874:	0880                	add	s0,sp,80
    80001876:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001878:	fffff097          	auipc	ra,0xfffff
    8000187c:	5d6080e7          	jalr	1494(ra) # 80000e4e <myproc>
    80001880:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001882:	00007517          	auipc	a0,0x7
    80001886:	0c650513          	add	a0,a0,198 # 80008948 <wait_lock>
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	864080e7          	jalr	-1948(ra) # 800060ee <acquire>
    havekids = 0;
    80001892:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001894:	4a15                	li	s4,5
        havekids = 1;
    80001896:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001898:	0000d997          	auipc	s3,0xd
    8000189c:	0c898993          	add	s3,s3,200 # 8000e960 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018a0:	00007c17          	auipc	s8,0x7
    800018a4:	0a8c0c13          	add	s8,s8,168 # 80008948 <wait_lock>
    800018a8:	a0d1                	j	8000196c <wait+0x10e>
          pid = pp->pid;
    800018aa:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018ae:	000b0e63          	beqz	s6,800018ca <wait+0x6c>
    800018b2:	4691                	li	a3,4
    800018b4:	03448613          	add	a2,s1,52
    800018b8:	85da                	mv	a1,s6
    800018ba:	05893503          	ld	a0,88(s2)
    800018be:	fffff097          	auipc	ra,0xfffff
    800018c2:	254080e7          	jalr	596(ra) # 80000b12 <copyout>
    800018c6:	04054163          	bltz	a0,80001908 <wait+0xaa>
          freeproc(pp);
    800018ca:	8526                	mv	a0,s1
    800018cc:	fffff097          	auipc	ra,0xfffff
    800018d0:	792080e7          	jalr	1938(ra) # 8000105e <freeproc>
          release(&pp->lock);
    800018d4:	8526                	mv	a0,s1
    800018d6:	00005097          	auipc	ra,0x5
    800018da:	8cc080e7          	jalr	-1844(ra) # 800061a2 <release>
          release(&wait_lock);
    800018de:	00007517          	auipc	a0,0x7
    800018e2:	06a50513          	add	a0,a0,106 # 80008948 <wait_lock>
    800018e6:	00005097          	auipc	ra,0x5
    800018ea:	8bc080e7          	jalr	-1860(ra) # 800061a2 <release>
}
    800018ee:	854e                	mv	a0,s3
    800018f0:	60a6                	ld	ra,72(sp)
    800018f2:	6406                	ld	s0,64(sp)
    800018f4:	74e2                	ld	s1,56(sp)
    800018f6:	7942                	ld	s2,48(sp)
    800018f8:	79a2                	ld	s3,40(sp)
    800018fa:	7a02                	ld	s4,32(sp)
    800018fc:	6ae2                	ld	s5,24(sp)
    800018fe:	6b42                	ld	s6,16(sp)
    80001900:	6ba2                	ld	s7,8(sp)
    80001902:	6c02                	ld	s8,0(sp)
    80001904:	6161                	add	sp,sp,80
    80001906:	8082                	ret
            release(&pp->lock);
    80001908:	8526                	mv	a0,s1
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	898080e7          	jalr	-1896(ra) # 800061a2 <release>
            release(&wait_lock);
    80001912:	00007517          	auipc	a0,0x7
    80001916:	03650513          	add	a0,a0,54 # 80008948 <wait_lock>
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	888080e7          	jalr	-1912(ra) # 800061a2 <release>
            return -1;
    80001922:	59fd                	li	s3,-1
    80001924:	b7e9                	j	800018ee <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001926:	17048493          	add	s1,s1,368
    8000192a:	03348463          	beq	s1,s3,80001952 <wait+0xf4>
      if(pp->parent == p){
    8000192e:	60bc                	ld	a5,64(s1)
    80001930:	ff279be3          	bne	a5,s2,80001926 <wait+0xc8>
        acquire(&pp->lock);
    80001934:	8526                	mv	a0,s1
    80001936:	00004097          	auipc	ra,0x4
    8000193a:	7b8080e7          	jalr	1976(ra) # 800060ee <acquire>
        if(pp->state == ZOMBIE){
    8000193e:	509c                	lw	a5,32(s1)
    80001940:	f74785e3          	beq	a5,s4,800018aa <wait+0x4c>
        release(&pp->lock);
    80001944:	8526                	mv	a0,s1
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	85c080e7          	jalr	-1956(ra) # 800061a2 <release>
        havekids = 1;
    8000194e:	8756                	mv	a4,s5
    80001950:	bfd9                	j	80001926 <wait+0xc8>
    if(!havekids || killed(p)){
    80001952:	c31d                	beqz	a4,80001978 <wait+0x11a>
    80001954:	854a                	mv	a0,s2
    80001956:	00000097          	auipc	ra,0x0
    8000195a:	ed6080e7          	jalr	-298(ra) # 8000182c <killed>
    8000195e:	ed09                	bnez	a0,80001978 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001960:	85e2                	mv	a1,s8
    80001962:	854a                	mv	a0,s2
    80001964:	00000097          	auipc	ra,0x0
    80001968:	c20080e7          	jalr	-992(ra) # 80001584 <sleep>
    havekids = 0;
    8000196c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000196e:	00007497          	auipc	s1,0x7
    80001972:	3f248493          	add	s1,s1,1010 # 80008d60 <proc>
    80001976:	bf65                	j	8000192e <wait+0xd0>
      release(&wait_lock);
    80001978:	00007517          	auipc	a0,0x7
    8000197c:	fd050513          	add	a0,a0,-48 # 80008948 <wait_lock>
    80001980:	00005097          	auipc	ra,0x5
    80001984:	822080e7          	jalr	-2014(ra) # 800061a2 <release>
      return -1;
    80001988:	59fd                	li	s3,-1
    8000198a:	b795                	j	800018ee <wait+0x90>

000000008000198c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000198c:	7179                	add	sp,sp,-48
    8000198e:	f406                	sd	ra,40(sp)
    80001990:	f022                	sd	s0,32(sp)
    80001992:	ec26                	sd	s1,24(sp)
    80001994:	e84a                	sd	s2,16(sp)
    80001996:	e44e                	sd	s3,8(sp)
    80001998:	e052                	sd	s4,0(sp)
    8000199a:	1800                	add	s0,sp,48
    8000199c:	84aa                	mv	s1,a0
    8000199e:	892e                	mv	s2,a1
    800019a0:	89b2                	mv	s3,a2
    800019a2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	4aa080e7          	jalr	1194(ra) # 80000e4e <myproc>
  if(user_dst){
    800019ac:	c08d                	beqz	s1,800019ce <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019ae:	86d2                	mv	a3,s4
    800019b0:	864e                	mv	a2,s3
    800019b2:	85ca                	mv	a1,s2
    800019b4:	6d28                	ld	a0,88(a0)
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	15c080e7          	jalr	348(ra) # 80000b12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019be:	70a2                	ld	ra,40(sp)
    800019c0:	7402                	ld	s0,32(sp)
    800019c2:	64e2                	ld	s1,24(sp)
    800019c4:	6942                	ld	s2,16(sp)
    800019c6:	69a2                	ld	s3,8(sp)
    800019c8:	6a02                	ld	s4,0(sp)
    800019ca:	6145                	add	sp,sp,48
    800019cc:	8082                	ret
    memmove((char *)dst, src, len);
    800019ce:	000a061b          	sext.w	a2,s4
    800019d2:	85ce                	mv	a1,s3
    800019d4:	854a                	mv	a0,s2
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	800080e7          	jalr	-2048(ra) # 800001d6 <memmove>
    return 0;
    800019de:	8526                	mv	a0,s1
    800019e0:	bff9                	j	800019be <either_copyout+0x32>

00000000800019e2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019e2:	7179                	add	sp,sp,-48
    800019e4:	f406                	sd	ra,40(sp)
    800019e6:	f022                	sd	s0,32(sp)
    800019e8:	ec26                	sd	s1,24(sp)
    800019ea:	e84a                	sd	s2,16(sp)
    800019ec:	e44e                	sd	s3,8(sp)
    800019ee:	e052                	sd	s4,0(sp)
    800019f0:	1800                	add	s0,sp,48
    800019f2:	892a                	mv	s2,a0
    800019f4:	84ae                	mv	s1,a1
    800019f6:	89b2                	mv	s3,a2
    800019f8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019fa:	fffff097          	auipc	ra,0xfffff
    800019fe:	454080e7          	jalr	1108(ra) # 80000e4e <myproc>
  if(user_src){
    80001a02:	c08d                	beqz	s1,80001a24 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a04:	86d2                	mv	a3,s4
    80001a06:	864e                	mv	a2,s3
    80001a08:	85ca                	mv	a1,s2
    80001a0a:	6d28                	ld	a0,88(a0)
    80001a0c:	fffff097          	auipc	ra,0xfffff
    80001a10:	192080e7          	jalr	402(ra) # 80000b9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a14:	70a2                	ld	ra,40(sp)
    80001a16:	7402                	ld	s0,32(sp)
    80001a18:	64e2                	ld	s1,24(sp)
    80001a1a:	6942                	ld	s2,16(sp)
    80001a1c:	69a2                	ld	s3,8(sp)
    80001a1e:	6a02                	ld	s4,0(sp)
    80001a20:	6145                	add	sp,sp,48
    80001a22:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a24:	000a061b          	sext.w	a2,s4
    80001a28:	85ce                	mv	a1,s3
    80001a2a:	854a                	mv	a0,s2
    80001a2c:	ffffe097          	auipc	ra,0xffffe
    80001a30:	7aa080e7          	jalr	1962(ra) # 800001d6 <memmove>
    return 0;
    80001a34:	8526                	mv	a0,s1
    80001a36:	bff9                	j	80001a14 <either_copyin+0x32>

0000000080001a38 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a38:	715d                	add	sp,sp,-80
    80001a3a:	e486                	sd	ra,72(sp)
    80001a3c:	e0a2                	sd	s0,64(sp)
    80001a3e:	fc26                	sd	s1,56(sp)
    80001a40:	f84a                	sd	s2,48(sp)
    80001a42:	f44e                	sd	s3,40(sp)
    80001a44:	f052                	sd	s4,32(sp)
    80001a46:	ec56                	sd	s5,24(sp)
    80001a48:	e85a                	sd	s6,16(sp)
    80001a4a:	e45e                	sd	s7,8(sp)
    80001a4c:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a4e:	00006517          	auipc	a0,0x6
    80001a52:	5fa50513          	add	a0,a0,1530 # 80008048 <etext+0x48>
    80001a56:	00004097          	auipc	ra,0x4
    80001a5a:	1aa080e7          	jalr	426(ra) # 80005c00 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a5e:	00007497          	auipc	s1,0x7
    80001a62:	46248493          	add	s1,s1,1122 # 80008ec0 <proc+0x160>
    80001a66:	0000d917          	auipc	s2,0xd
    80001a6a:	05a90913          	add	s2,s2,90 # 8000eac0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a6e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a70:	00006997          	auipc	s3,0x6
    80001a74:	79098993          	add	s3,s3,1936 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a78:	00006a97          	auipc	s5,0x6
    80001a7c:	790a8a93          	add	s5,s5,1936 # 80008208 <etext+0x208>
    printf("\n");
    80001a80:	00006a17          	auipc	s4,0x6
    80001a84:	5c8a0a13          	add	s4,s4,1480 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a88:	00006b97          	auipc	s7,0x6
    80001a8c:	7c0b8b93          	add	s7,s7,1984 # 80008248 <states.0>
    80001a90:	a00d                	j	80001ab2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a92:	ed86a583          	lw	a1,-296(a3)
    80001a96:	8556                	mv	a0,s5
    80001a98:	00004097          	auipc	ra,0x4
    80001a9c:	168080e7          	jalr	360(ra) # 80005c00 <printf>
    printf("\n");
    80001aa0:	8552                	mv	a0,s4
    80001aa2:	00004097          	auipc	ra,0x4
    80001aa6:	15e080e7          	jalr	350(ra) # 80005c00 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aaa:	17048493          	add	s1,s1,368
    80001aae:	03248263          	beq	s1,s2,80001ad2 <procdump+0x9a>
    if(p->state == UNUSED)
    80001ab2:	86a6                	mv	a3,s1
    80001ab4:	ec04a783          	lw	a5,-320(s1)
    80001ab8:	dbed                	beqz	a5,80001aaa <procdump+0x72>
      state = "???";
    80001aba:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001abc:	fcfb6be3          	bltu	s6,a5,80001a92 <procdump+0x5a>
    80001ac0:	02079713          	sll	a4,a5,0x20
    80001ac4:	01d75793          	srl	a5,a4,0x1d
    80001ac8:	97de                	add	a5,a5,s7
    80001aca:	6390                	ld	a2,0(a5)
    80001acc:	f279                	bnez	a2,80001a92 <procdump+0x5a>
      state = "???";
    80001ace:	864e                	mv	a2,s3
    80001ad0:	b7c9                	j	80001a92 <procdump+0x5a>
  }
}
    80001ad2:	60a6                	ld	ra,72(sp)
    80001ad4:	6406                	ld	s0,64(sp)
    80001ad6:	74e2                	ld	s1,56(sp)
    80001ad8:	7942                	ld	s2,48(sp)
    80001ada:	79a2                	ld	s3,40(sp)
    80001adc:	7a02                	ld	s4,32(sp)
    80001ade:	6ae2                	ld	s5,24(sp)
    80001ae0:	6b42                	ld	s6,16(sp)
    80001ae2:	6ba2                	ld	s7,8(sp)
    80001ae4:	6161                	add	sp,sp,80
    80001ae6:	8082                	ret

0000000080001ae8 <swtch>:
    80001ae8:	00153023          	sd	ra,0(a0)
    80001aec:	00253423          	sd	sp,8(a0)
    80001af0:	e900                	sd	s0,16(a0)
    80001af2:	ed04                	sd	s1,24(a0)
    80001af4:	03253023          	sd	s2,32(a0)
    80001af8:	03353423          	sd	s3,40(a0)
    80001afc:	03453823          	sd	s4,48(a0)
    80001b00:	03553c23          	sd	s5,56(a0)
    80001b04:	05653023          	sd	s6,64(a0)
    80001b08:	05753423          	sd	s7,72(a0)
    80001b0c:	05853823          	sd	s8,80(a0)
    80001b10:	05953c23          	sd	s9,88(a0)
    80001b14:	07a53023          	sd	s10,96(a0)
    80001b18:	07b53423          	sd	s11,104(a0)
    80001b1c:	0005b083          	ld	ra,0(a1)
    80001b20:	0085b103          	ld	sp,8(a1)
    80001b24:	6980                	ld	s0,16(a1)
    80001b26:	6d84                	ld	s1,24(a1)
    80001b28:	0205b903          	ld	s2,32(a1)
    80001b2c:	0285b983          	ld	s3,40(a1)
    80001b30:	0305ba03          	ld	s4,48(a1)
    80001b34:	0385ba83          	ld	s5,56(a1)
    80001b38:	0405bb03          	ld	s6,64(a1)
    80001b3c:	0485bb83          	ld	s7,72(a1)
    80001b40:	0505bc03          	ld	s8,80(a1)
    80001b44:	0585bc83          	ld	s9,88(a1)
    80001b48:	0605bd03          	ld	s10,96(a1)
    80001b4c:	0685bd83          	ld	s11,104(a1)
    80001b50:	8082                	ret

0000000080001b52 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b52:	1141                	add	sp,sp,-16
    80001b54:	e406                	sd	ra,8(sp)
    80001b56:	e022                	sd	s0,0(sp)
    80001b58:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001b5a:	00006597          	auipc	a1,0x6
    80001b5e:	71e58593          	add	a1,a1,1822 # 80008278 <states.0+0x30>
    80001b62:	0000d517          	auipc	a0,0xd
    80001b66:	dfe50513          	add	a0,a0,-514 # 8000e960 <tickslock>
    80001b6a:	00004097          	auipc	ra,0x4
    80001b6e:	4f4080e7          	jalr	1268(ra) # 8000605e <initlock>
}
    80001b72:	60a2                	ld	ra,8(sp)
    80001b74:	6402                	ld	s0,0(sp)
    80001b76:	0141                	add	sp,sp,16
    80001b78:	8082                	ret

0000000080001b7a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b7a:	1141                	add	sp,sp,-16
    80001b7c:	e422                	sd	s0,8(sp)
    80001b7e:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b80:	00003797          	auipc	a5,0x3
    80001b84:	47078793          	add	a5,a5,1136 # 80004ff0 <kernelvec>
    80001b88:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b8c:	6422                	ld	s0,8(sp)
    80001b8e:	0141                	add	sp,sp,16
    80001b90:	8082                	ret

0000000080001b92 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b92:	1141                	add	sp,sp,-16
    80001b94:	e406                	sd	ra,8(sp)
    80001b96:	e022                	sd	s0,0(sp)
    80001b98:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001b9a:	fffff097          	auipc	ra,0xfffff
    80001b9e:	2b4080e7          	jalr	692(ra) # 80000e4e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ba6:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bac:	00005697          	auipc	a3,0x5
    80001bb0:	45468693          	add	a3,a3,1108 # 80007000 <_trampoline>
    80001bb4:	00005717          	auipc	a4,0x5
    80001bb8:	44c70713          	add	a4,a4,1100 # 80007000 <_trampoline>
    80001bbc:	8f15                	sub	a4,a4,a3
    80001bbe:	040007b7          	lui	a5,0x4000
    80001bc2:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bc4:	07b2                	sll	a5,a5,0xc
    80001bc6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc8:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bcc:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bce:	18002673          	csrr	a2,satp
    80001bd2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bd4:	7130                	ld	a2,96(a0)
    80001bd6:	6538                	ld	a4,72(a0)
    80001bd8:	6585                	lui	a1,0x1
    80001bda:	972e                	add	a4,a4,a1
    80001bdc:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bde:	7138                	ld	a4,96(a0)
    80001be0:	00000617          	auipc	a2,0x0
    80001be4:	13460613          	add	a2,a2,308 # 80001d14 <usertrap>
    80001be8:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bea:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bec:	8612                	mv	a2,tp
    80001bee:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bf4:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bf8:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bfc:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c00:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c02:	6f18                	ld	a4,24(a4)
    80001c04:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c08:	6d28                	ld	a0,88(a0)
    80001c0a:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c0c:	00005717          	auipc	a4,0x5
    80001c10:	49070713          	add	a4,a4,1168 # 8000709c <userret>
    80001c14:	8f15                	sub	a4,a4,a3
    80001c16:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c18:	577d                	li	a4,-1
    80001c1a:	177e                	sll	a4,a4,0x3f
    80001c1c:	8d59                	or	a0,a0,a4
    80001c1e:	9782                	jalr	a5
}
    80001c20:	60a2                	ld	ra,8(sp)
    80001c22:	6402                	ld	s0,0(sp)
    80001c24:	0141                	add	sp,sp,16
    80001c26:	8082                	ret

0000000080001c28 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c28:	1101                	add	sp,sp,-32
    80001c2a:	ec06                	sd	ra,24(sp)
    80001c2c:	e822                	sd	s0,16(sp)
    80001c2e:	e426                	sd	s1,8(sp)
    80001c30:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001c32:	0000d497          	auipc	s1,0xd
    80001c36:	d2e48493          	add	s1,s1,-722 # 8000e960 <tickslock>
    80001c3a:	8526                	mv	a0,s1
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	4b2080e7          	jalr	1202(ra) # 800060ee <acquire>
  ticks++;
    80001c44:	00007517          	auipc	a0,0x7
    80001c48:	cb450513          	add	a0,a0,-844 # 800088f8 <ticks>
    80001c4c:	411c                	lw	a5,0(a0)
    80001c4e:	2785                	addw	a5,a5,1
    80001c50:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c52:	00000097          	auipc	ra,0x0
    80001c56:	996080e7          	jalr	-1642(ra) # 800015e8 <wakeup>
  release(&tickslock);
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	546080e7          	jalr	1350(ra) # 800061a2 <release>
}
    80001c64:	60e2                	ld	ra,24(sp)
    80001c66:	6442                	ld	s0,16(sp)
    80001c68:	64a2                	ld	s1,8(sp)
    80001c6a:	6105                	add	sp,sp,32
    80001c6c:	8082                	ret

0000000080001c6e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c72:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c74:	0807df63          	bgez	a5,80001d12 <devintr+0xa4>
{
    80001c78:	1101                	add	sp,sp,-32
    80001c7a:	ec06                	sd	ra,24(sp)
    80001c7c:	e822                	sd	s0,16(sp)
    80001c7e:	e426                	sd	s1,8(sp)
    80001c80:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001c82:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c86:	46a5                	li	a3,9
    80001c88:	00d70d63          	beq	a4,a3,80001ca2 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001c8c:	577d                	li	a4,-1
    80001c8e:	177e                	sll	a4,a4,0x3f
    80001c90:	0705                	add	a4,a4,1
    return 0;
    80001c92:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c94:	04e78e63          	beq	a5,a4,80001cf0 <devintr+0x82>
  }
}
    80001c98:	60e2                	ld	ra,24(sp)
    80001c9a:	6442                	ld	s0,16(sp)
    80001c9c:	64a2                	ld	s1,8(sp)
    80001c9e:	6105                	add	sp,sp,32
    80001ca0:	8082                	ret
    int irq = plic_claim();
    80001ca2:	00003097          	auipc	ra,0x3
    80001ca6:	456080e7          	jalr	1110(ra) # 800050f8 <plic_claim>
    80001caa:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cac:	47a9                	li	a5,10
    80001cae:	02f50763          	beq	a0,a5,80001cdc <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001cb2:	4785                	li	a5,1
    80001cb4:	02f50963          	beq	a0,a5,80001ce6 <devintr+0x78>
    return 1;
    80001cb8:	4505                	li	a0,1
    } else if(irq){
    80001cba:	dcf9                	beqz	s1,80001c98 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cbc:	85a6                	mv	a1,s1
    80001cbe:	00006517          	auipc	a0,0x6
    80001cc2:	5c250513          	add	a0,a0,1474 # 80008280 <states.0+0x38>
    80001cc6:	00004097          	auipc	ra,0x4
    80001cca:	f3a080e7          	jalr	-198(ra) # 80005c00 <printf>
      plic_complete(irq);
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00003097          	auipc	ra,0x3
    80001cd4:	44c080e7          	jalr	1100(ra) # 8000511c <plic_complete>
    return 1;
    80001cd8:	4505                	li	a0,1
    80001cda:	bf7d                	j	80001c98 <devintr+0x2a>
      uartintr();
    80001cdc:	00004097          	auipc	ra,0x4
    80001ce0:	332080e7          	jalr	818(ra) # 8000600e <uartintr>
    if(irq)
    80001ce4:	b7ed                	j	80001cce <devintr+0x60>
      virtio_disk_intr();
    80001ce6:	00004097          	auipc	ra,0x4
    80001cea:	8fc080e7          	jalr	-1796(ra) # 800055e2 <virtio_disk_intr>
    if(irq)
    80001cee:	b7c5                	j	80001cce <devintr+0x60>
    if(cpuid() == 0){
    80001cf0:	fffff097          	auipc	ra,0xfffff
    80001cf4:	132080e7          	jalr	306(ra) # 80000e22 <cpuid>
    80001cf8:	c901                	beqz	a0,80001d08 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cfa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cfe:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d00:	14479073          	csrw	sip,a5
    return 2;
    80001d04:	4509                	li	a0,2
    80001d06:	bf49                	j	80001c98 <devintr+0x2a>
      clockintr();
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	f20080e7          	jalr	-224(ra) # 80001c28 <clockintr>
    80001d10:	b7ed                	j	80001cfa <devintr+0x8c>
}
    80001d12:	8082                	ret

0000000080001d14 <usertrap>:
{
    80001d14:	1101                	add	sp,sp,-32
    80001d16:	ec06                	sd	ra,24(sp)
    80001d18:	e822                	sd	s0,16(sp)
    80001d1a:	e426                	sd	s1,8(sp)
    80001d1c:	e04a                	sd	s2,0(sp)
    80001d1e:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d20:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d24:	1007f793          	and	a5,a5,256
    80001d28:	e3b1                	bnez	a5,80001d6c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d2a:	00003797          	auipc	a5,0x3
    80001d2e:	2c678793          	add	a5,a5,710 # 80004ff0 <kernelvec>
    80001d32:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d36:	fffff097          	auipc	ra,0xfffff
    80001d3a:	118080e7          	jalr	280(ra) # 80000e4e <myproc>
    80001d3e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d40:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d42:	14102773          	csrr	a4,sepc
    80001d46:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d48:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d4c:	47a1                	li	a5,8
    80001d4e:	02f70763          	beq	a4,a5,80001d7c <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	f1c080e7          	jalr	-228(ra) # 80001c6e <devintr>
    80001d5a:	892a                	mv	s2,a0
    80001d5c:	c151                	beqz	a0,80001de0 <usertrap+0xcc>
  if(killed(p))
    80001d5e:	8526                	mv	a0,s1
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	acc080e7          	jalr	-1332(ra) # 8000182c <killed>
    80001d68:	c929                	beqz	a0,80001dba <usertrap+0xa6>
    80001d6a:	a099                	j	80001db0 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d6c:	00006517          	auipc	a0,0x6
    80001d70:	53450513          	add	a0,a0,1332 # 800082a0 <states.0+0x58>
    80001d74:	00004097          	auipc	ra,0x4
    80001d78:	e42080e7          	jalr	-446(ra) # 80005bb6 <panic>
    if(killed(p))
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	ab0080e7          	jalr	-1360(ra) # 8000182c <killed>
    80001d84:	e921                	bnez	a0,80001dd4 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d86:	70b8                	ld	a4,96(s1)
    80001d88:	6f1c                	ld	a5,24(a4)
    80001d8a:	0791                	add	a5,a5,4
    80001d8c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d92:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d96:	10079073          	csrw	sstatus,a5
    syscall();
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	2d4080e7          	jalr	724(ra) # 8000206e <syscall>
  if(killed(p))
    80001da2:	8526                	mv	a0,s1
    80001da4:	00000097          	auipc	ra,0x0
    80001da8:	a88080e7          	jalr	-1400(ra) # 8000182c <killed>
    80001dac:	c911                	beqz	a0,80001dc0 <usertrap+0xac>
    80001dae:	4901                	li	s2,0
    exit(-1);
    80001db0:	557d                	li	a0,-1
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	906080e7          	jalr	-1786(ra) # 800016b8 <exit>
  if(which_dev == 2)
    80001dba:	4789                	li	a5,2
    80001dbc:	04f90f63          	beq	s2,a5,80001e1a <usertrap+0x106>
  usertrapret();
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	dd2080e7          	jalr	-558(ra) # 80001b92 <usertrapret>
}
    80001dc8:	60e2                	ld	ra,24(sp)
    80001dca:	6442                	ld	s0,16(sp)
    80001dcc:	64a2                	ld	s1,8(sp)
    80001dce:	6902                	ld	s2,0(sp)
    80001dd0:	6105                	add	sp,sp,32
    80001dd2:	8082                	ret
      exit(-1);
    80001dd4:	557d                	li	a0,-1
    80001dd6:	00000097          	auipc	ra,0x0
    80001dda:	8e2080e7          	jalr	-1822(ra) # 800016b8 <exit>
    80001dde:	b765                	j	80001d86 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001de4:	5c90                	lw	a2,56(s1)
    80001de6:	00006517          	auipc	a0,0x6
    80001dea:	4da50513          	add	a0,a0,1242 # 800082c0 <states.0+0x78>
    80001dee:	00004097          	auipc	ra,0x4
    80001df2:	e12080e7          	jalr	-494(ra) # 80005c00 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dfa:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dfe:	00006517          	auipc	a0,0x6
    80001e02:	4f250513          	add	a0,a0,1266 # 800082f0 <states.0+0xa8>
    80001e06:	00004097          	auipc	ra,0x4
    80001e0a:	dfa080e7          	jalr	-518(ra) # 80005c00 <printf>
    setkilled(p);
    80001e0e:	8526                	mv	a0,s1
    80001e10:	00000097          	auipc	ra,0x0
    80001e14:	9f0080e7          	jalr	-1552(ra) # 80001800 <setkilled>
    80001e18:	b769                	j	80001da2 <usertrap+0x8e>
    yield();
    80001e1a:	fffff097          	auipc	ra,0xfffff
    80001e1e:	72e080e7          	jalr	1838(ra) # 80001548 <yield>
    80001e22:	bf79                	j	80001dc0 <usertrap+0xac>

0000000080001e24 <kerneltrap>:
{
    80001e24:	7179                	add	sp,sp,-48
    80001e26:	f406                	sd	ra,40(sp)
    80001e28:	f022                	sd	s0,32(sp)
    80001e2a:	ec26                	sd	s1,24(sp)
    80001e2c:	e84a                	sd	s2,16(sp)
    80001e2e:	e44e                	sd	s3,8(sp)
    80001e30:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e32:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e36:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e3a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e3e:	1004f793          	and	a5,s1,256
    80001e42:	cb85                	beqz	a5,80001e72 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e48:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001e4a:	ef85                	bnez	a5,80001e82 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e4c:	00000097          	auipc	ra,0x0
    80001e50:	e22080e7          	jalr	-478(ra) # 80001c6e <devintr>
    80001e54:	cd1d                	beqz	a0,80001e92 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e56:	4789                	li	a5,2
    80001e58:	06f50a63          	beq	a0,a5,80001ecc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e5c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e60:	10049073          	csrw	sstatus,s1
}
    80001e64:	70a2                	ld	ra,40(sp)
    80001e66:	7402                	ld	s0,32(sp)
    80001e68:	64e2                	ld	s1,24(sp)
    80001e6a:	6942                	ld	s2,16(sp)
    80001e6c:	69a2                	ld	s3,8(sp)
    80001e6e:	6145                	add	sp,sp,48
    80001e70:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e72:	00006517          	auipc	a0,0x6
    80001e76:	49e50513          	add	a0,a0,1182 # 80008310 <states.0+0xc8>
    80001e7a:	00004097          	auipc	ra,0x4
    80001e7e:	d3c080e7          	jalr	-708(ra) # 80005bb6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e82:	00006517          	auipc	a0,0x6
    80001e86:	4b650513          	add	a0,a0,1206 # 80008338 <states.0+0xf0>
    80001e8a:	00004097          	auipc	ra,0x4
    80001e8e:	d2c080e7          	jalr	-724(ra) # 80005bb6 <panic>
    printf("scause %p\n", scause);
    80001e92:	85ce                	mv	a1,s3
    80001e94:	00006517          	auipc	a0,0x6
    80001e98:	4c450513          	add	a0,a0,1220 # 80008358 <states.0+0x110>
    80001e9c:	00004097          	auipc	ra,0x4
    80001ea0:	d64080e7          	jalr	-668(ra) # 80005c00 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ea4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ea8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eac:	00006517          	auipc	a0,0x6
    80001eb0:	4bc50513          	add	a0,a0,1212 # 80008368 <states.0+0x120>
    80001eb4:	00004097          	auipc	ra,0x4
    80001eb8:	d4c080e7          	jalr	-692(ra) # 80005c00 <printf>
    panic("kerneltrap");
    80001ebc:	00006517          	auipc	a0,0x6
    80001ec0:	4c450513          	add	a0,a0,1220 # 80008380 <states.0+0x138>
    80001ec4:	00004097          	auipc	ra,0x4
    80001ec8:	cf2080e7          	jalr	-782(ra) # 80005bb6 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ecc:	fffff097          	auipc	ra,0xfffff
    80001ed0:	f82080e7          	jalr	-126(ra) # 80000e4e <myproc>
    80001ed4:	d541                	beqz	a0,80001e5c <kerneltrap+0x38>
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	f78080e7          	jalr	-136(ra) # 80000e4e <myproc>
    80001ede:	5118                	lw	a4,32(a0)
    80001ee0:	4791                	li	a5,4
    80001ee2:	f6f71de3          	bne	a4,a5,80001e5c <kerneltrap+0x38>
    yield();
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	662080e7          	jalr	1634(ra) # 80001548 <yield>
    80001eee:	b7bd                	j	80001e5c <kerneltrap+0x38>

0000000080001ef0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ef0:	1101                	add	sp,sp,-32
    80001ef2:	ec06                	sd	ra,24(sp)
    80001ef4:	e822                	sd	s0,16(sp)
    80001ef6:	e426                	sd	s1,8(sp)
    80001ef8:	1000                	add	s0,sp,32
    80001efa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	f52080e7          	jalr	-174(ra) # 80000e4e <myproc>
  switch (n) {
    80001f04:	4795                	li	a5,5
    80001f06:	0497e163          	bltu	a5,s1,80001f48 <argraw+0x58>
    80001f0a:	048a                	sll	s1,s1,0x2
    80001f0c:	00006717          	auipc	a4,0x6
    80001f10:	4ac70713          	add	a4,a4,1196 # 800083b8 <states.0+0x170>
    80001f14:	94ba                	add	s1,s1,a4
    80001f16:	409c                	lw	a5,0(s1)
    80001f18:	97ba                	add	a5,a5,a4
    80001f1a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f1c:	713c                	ld	a5,96(a0)
    80001f1e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f20:	60e2                	ld	ra,24(sp)
    80001f22:	6442                	ld	s0,16(sp)
    80001f24:	64a2                	ld	s1,8(sp)
    80001f26:	6105                	add	sp,sp,32
    80001f28:	8082                	ret
    return p->trapframe->a1;
    80001f2a:	713c                	ld	a5,96(a0)
    80001f2c:	7fa8                	ld	a0,120(a5)
    80001f2e:	bfcd                	j	80001f20 <argraw+0x30>
    return p->trapframe->a2;
    80001f30:	713c                	ld	a5,96(a0)
    80001f32:	63c8                	ld	a0,128(a5)
    80001f34:	b7f5                	j	80001f20 <argraw+0x30>
    return p->trapframe->a3;
    80001f36:	713c                	ld	a5,96(a0)
    80001f38:	67c8                	ld	a0,136(a5)
    80001f3a:	b7dd                	j	80001f20 <argraw+0x30>
    return p->trapframe->a4;
    80001f3c:	713c                	ld	a5,96(a0)
    80001f3e:	6bc8                	ld	a0,144(a5)
    80001f40:	b7c5                	j	80001f20 <argraw+0x30>
    return p->trapframe->a5;
    80001f42:	713c                	ld	a5,96(a0)
    80001f44:	6fc8                	ld	a0,152(a5)
    80001f46:	bfe9                	j	80001f20 <argraw+0x30>
  panic("argraw");
    80001f48:	00006517          	auipc	a0,0x6
    80001f4c:	44850513          	add	a0,a0,1096 # 80008390 <states.0+0x148>
    80001f50:	00004097          	auipc	ra,0x4
    80001f54:	c66080e7          	jalr	-922(ra) # 80005bb6 <panic>

0000000080001f58 <fetchaddr>:
{
    80001f58:	1101                	add	sp,sp,-32
    80001f5a:	ec06                	sd	ra,24(sp)
    80001f5c:	e822                	sd	s0,16(sp)
    80001f5e:	e426                	sd	s1,8(sp)
    80001f60:	e04a                	sd	s2,0(sp)
    80001f62:	1000                	add	s0,sp,32
    80001f64:	84aa                	mv	s1,a0
    80001f66:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	ee6080e7          	jalr	-282(ra) # 80000e4e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f70:	693c                	ld	a5,80(a0)
    80001f72:	02f4f863          	bgeu	s1,a5,80001fa2 <fetchaddr+0x4a>
    80001f76:	00848713          	add	a4,s1,8
    80001f7a:	02e7e663          	bltu	a5,a4,80001fa6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f7e:	46a1                	li	a3,8
    80001f80:	8626                	mv	a2,s1
    80001f82:	85ca                	mv	a1,s2
    80001f84:	6d28                	ld	a0,88(a0)
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	c18080e7          	jalr	-1000(ra) # 80000b9e <copyin>
    80001f8e:	00a03533          	snez	a0,a0
    80001f92:	40a00533          	neg	a0,a0
}
    80001f96:	60e2                	ld	ra,24(sp)
    80001f98:	6442                	ld	s0,16(sp)
    80001f9a:	64a2                	ld	s1,8(sp)
    80001f9c:	6902                	ld	s2,0(sp)
    80001f9e:	6105                	add	sp,sp,32
    80001fa0:	8082                	ret
    return -1;
    80001fa2:	557d                	li	a0,-1
    80001fa4:	bfcd                	j	80001f96 <fetchaddr+0x3e>
    80001fa6:	557d                	li	a0,-1
    80001fa8:	b7fd                	j	80001f96 <fetchaddr+0x3e>

0000000080001faa <fetchstr>:
{
    80001faa:	7179                	add	sp,sp,-48
    80001fac:	f406                	sd	ra,40(sp)
    80001fae:	f022                	sd	s0,32(sp)
    80001fb0:	ec26                	sd	s1,24(sp)
    80001fb2:	e84a                	sd	s2,16(sp)
    80001fb4:	e44e                	sd	s3,8(sp)
    80001fb6:	1800                	add	s0,sp,48
    80001fb8:	892a                	mv	s2,a0
    80001fba:	84ae                	mv	s1,a1
    80001fbc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	e90080e7          	jalr	-368(ra) # 80000e4e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fc6:	86ce                	mv	a3,s3
    80001fc8:	864a                	mv	a2,s2
    80001fca:	85a6                	mv	a1,s1
    80001fcc:	6d28                	ld	a0,88(a0)
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	c5e080e7          	jalr	-930(ra) # 80000c2c <copyinstr>
    80001fd6:	00054e63          	bltz	a0,80001ff2 <fetchstr+0x48>
  return strlen(buf);
    80001fda:	8526                	mv	a0,s1
    80001fdc:	ffffe097          	auipc	ra,0xffffe
    80001fe0:	318080e7          	jalr	792(ra) # 800002f4 <strlen>
}
    80001fe4:	70a2                	ld	ra,40(sp)
    80001fe6:	7402                	ld	s0,32(sp)
    80001fe8:	64e2                	ld	s1,24(sp)
    80001fea:	6942                	ld	s2,16(sp)
    80001fec:	69a2                	ld	s3,8(sp)
    80001fee:	6145                	add	sp,sp,48
    80001ff0:	8082                	ret
    return -1;
    80001ff2:	557d                	li	a0,-1
    80001ff4:	bfc5                	j	80001fe4 <fetchstr+0x3a>

0000000080001ff6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ff6:	1101                	add	sp,sp,-32
    80001ff8:	ec06                	sd	ra,24(sp)
    80001ffa:	e822                	sd	s0,16(sp)
    80001ffc:	e426                	sd	s1,8(sp)
    80001ffe:	1000                	add	s0,sp,32
    80002000:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002002:	00000097          	auipc	ra,0x0
    80002006:	eee080e7          	jalr	-274(ra) # 80001ef0 <argraw>
    8000200a:	c088                	sw	a0,0(s1)
}
    8000200c:	60e2                	ld	ra,24(sp)
    8000200e:	6442                	ld	s0,16(sp)
    80002010:	64a2                	ld	s1,8(sp)
    80002012:	6105                	add	sp,sp,32
    80002014:	8082                	ret

0000000080002016 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002016:	1101                	add	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	1000                	add	s0,sp,32
    80002020:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002022:	00000097          	auipc	ra,0x0
    80002026:	ece080e7          	jalr	-306(ra) # 80001ef0 <argraw>
    8000202a:	e088                	sd	a0,0(s1)
}
    8000202c:	60e2                	ld	ra,24(sp)
    8000202e:	6442                	ld	s0,16(sp)
    80002030:	64a2                	ld	s1,8(sp)
    80002032:	6105                	add	sp,sp,32
    80002034:	8082                	ret

0000000080002036 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002036:	7179                	add	sp,sp,-48
    80002038:	f406                	sd	ra,40(sp)
    8000203a:	f022                	sd	s0,32(sp)
    8000203c:	ec26                	sd	s1,24(sp)
    8000203e:	e84a                	sd	s2,16(sp)
    80002040:	1800                	add	s0,sp,48
    80002042:	84ae                	mv	s1,a1
    80002044:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002046:	fd840593          	add	a1,s0,-40
    8000204a:	00000097          	auipc	ra,0x0
    8000204e:	fcc080e7          	jalr	-52(ra) # 80002016 <argaddr>
  return fetchstr(addr, buf, max);
    80002052:	864a                	mv	a2,s2
    80002054:	85a6                	mv	a1,s1
    80002056:	fd843503          	ld	a0,-40(s0)
    8000205a:	00000097          	auipc	ra,0x0
    8000205e:	f50080e7          	jalr	-176(ra) # 80001faa <fetchstr>
}
    80002062:	70a2                	ld	ra,40(sp)
    80002064:	7402                	ld	s0,32(sp)
    80002066:	64e2                	ld	s1,24(sp)
    80002068:	6942                	ld	s2,16(sp)
    8000206a:	6145                	add	sp,sp,48
    8000206c:	8082                	ret

000000008000206e <syscall>:



void
syscall(void)
{
    8000206e:	1101                	add	sp,sp,-32
    80002070:	ec06                	sd	ra,24(sp)
    80002072:	e822                	sd	s0,16(sp)
    80002074:	e426                	sd	s1,8(sp)
    80002076:	e04a                	sd	s2,0(sp)
    80002078:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	dd4080e7          	jalr	-556(ra) # 80000e4e <myproc>
    80002082:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002084:	06053903          	ld	s2,96(a0)
    80002088:	0a893783          	ld	a5,168(s2)
    8000208c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002090:	37fd                	addw	a5,a5,-1
    80002092:	4775                	li	a4,29
    80002094:	00f76f63          	bltu	a4,a5,800020b2 <syscall+0x44>
    80002098:	00369713          	sll	a4,a3,0x3
    8000209c:	00006797          	auipc	a5,0x6
    800020a0:	33478793          	add	a5,a5,820 # 800083d0 <syscalls>
    800020a4:	97ba                	add	a5,a5,a4
    800020a6:	639c                	ld	a5,0(a5)
    800020a8:	c789                	beqz	a5,800020b2 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020aa:	9782                	jalr	a5
    800020ac:	06a93823          	sd	a0,112(s2)
    800020b0:	a839                	j	800020ce <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020b2:	16048613          	add	a2,s1,352
    800020b6:	5c8c                	lw	a1,56(s1)
    800020b8:	00006517          	auipc	a0,0x6
    800020bc:	2e050513          	add	a0,a0,736 # 80008398 <states.0+0x150>
    800020c0:	00004097          	auipc	ra,0x4
    800020c4:	b40080e7          	jalr	-1216(ra) # 80005c00 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020c8:	70bc                	ld	a5,96(s1)
    800020ca:	577d                	li	a4,-1
    800020cc:	fbb8                	sd	a4,112(a5)
  }
}
    800020ce:	60e2                	ld	ra,24(sp)
    800020d0:	6442                	ld	s0,16(sp)
    800020d2:	64a2                	ld	s1,8(sp)
    800020d4:	6902                	ld	s2,0(sp)
    800020d6:	6105                	add	sp,sp,32
    800020d8:	8082                	ret

00000000800020da <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020da:	1101                	add	sp,sp,-32
    800020dc:	ec06                	sd	ra,24(sp)
    800020de:	e822                	sd	s0,16(sp)
    800020e0:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800020e2:	fec40593          	add	a1,s0,-20
    800020e6:	4501                	li	a0,0
    800020e8:	00000097          	auipc	ra,0x0
    800020ec:	f0e080e7          	jalr	-242(ra) # 80001ff6 <argint>
  exit(n);
    800020f0:	fec42503          	lw	a0,-20(s0)
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	5c4080e7          	jalr	1476(ra) # 800016b8 <exit>
  return 0;  // not reached
}
    800020fc:	4501                	li	a0,0
    800020fe:	60e2                	ld	ra,24(sp)
    80002100:	6442                	ld	s0,16(sp)
    80002102:	6105                	add	sp,sp,32
    80002104:	8082                	ret

0000000080002106 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002106:	1141                	add	sp,sp,-16
    80002108:	e406                	sd	ra,8(sp)
    8000210a:	e022                	sd	s0,0(sp)
    8000210c:	0800                	add	s0,sp,16
  return myproc()->pid;
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	d40080e7          	jalr	-704(ra) # 80000e4e <myproc>
}
    80002116:	5d08                	lw	a0,56(a0)
    80002118:	60a2                	ld	ra,8(sp)
    8000211a:	6402                	ld	s0,0(sp)
    8000211c:	0141                	add	sp,sp,16
    8000211e:	8082                	ret

0000000080002120 <sys_fork>:

uint64
sys_fork(void)
{
    80002120:	1141                	add	sp,sp,-16
    80002122:	e406                	sd	ra,8(sp)
    80002124:	e022                	sd	s0,0(sp)
    80002126:	0800                	add	s0,sp,16
  return fork();
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	16a080e7          	jalr	362(ra) # 80001292 <fork>
}
    80002130:	60a2                	ld	ra,8(sp)
    80002132:	6402                	ld	s0,0(sp)
    80002134:	0141                	add	sp,sp,16
    80002136:	8082                	ret

0000000080002138 <sys_wait>:

uint64
sys_wait(void)
{
    80002138:	1101                	add	sp,sp,-32
    8000213a:	ec06                	sd	ra,24(sp)
    8000213c:	e822                	sd	s0,16(sp)
    8000213e:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002140:	fe840593          	add	a1,s0,-24
    80002144:	4501                	li	a0,0
    80002146:	00000097          	auipc	ra,0x0
    8000214a:	ed0080e7          	jalr	-304(ra) # 80002016 <argaddr>
  return wait(p);
    8000214e:	fe843503          	ld	a0,-24(s0)
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	70c080e7          	jalr	1804(ra) # 8000185e <wait>
}
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	6105                	add	sp,sp,32
    80002160:	8082                	ret

0000000080002162 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002162:	7179                	add	sp,sp,-48
    80002164:	f406                	sd	ra,40(sp)
    80002166:	f022                	sd	s0,32(sp)
    80002168:	ec26                	sd	s1,24(sp)
    8000216a:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000216c:	fdc40593          	add	a1,s0,-36
    80002170:	4501                	li	a0,0
    80002172:	00000097          	auipc	ra,0x0
    80002176:	e84080e7          	jalr	-380(ra) # 80001ff6 <argint>
  addr = myproc()->sz;
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	cd4080e7          	jalr	-812(ra) # 80000e4e <myproc>
    80002182:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    80002184:	fdc42503          	lw	a0,-36(s0)
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	0ae080e7          	jalr	174(ra) # 80001236 <growproc>
    80002190:	00054863          	bltz	a0,800021a0 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002194:	8526                	mv	a0,s1
    80002196:	70a2                	ld	ra,40(sp)
    80002198:	7402                	ld	s0,32(sp)
    8000219a:	64e2                	ld	s1,24(sp)
    8000219c:	6145                	add	sp,sp,48
    8000219e:	8082                	ret
    return -1;
    800021a0:	54fd                	li	s1,-1
    800021a2:	bfcd                	j	80002194 <sys_sbrk+0x32>

00000000800021a4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021a4:	7139                	add	sp,sp,-64
    800021a6:	fc06                	sd	ra,56(sp)
    800021a8:	f822                	sd	s0,48(sp)
    800021aa:	f426                	sd	s1,40(sp)
    800021ac:	f04a                	sd	s2,32(sp)
    800021ae:	ec4e                	sd	s3,24(sp)
    800021b0:	0080                	add	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800021b2:	fcc40593          	add	a1,s0,-52
    800021b6:	4501                	li	a0,0
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	e3e080e7          	jalr	-450(ra) # 80001ff6 <argint>
  acquire(&tickslock);
    800021c0:	0000c517          	auipc	a0,0xc
    800021c4:	7a050513          	add	a0,a0,1952 # 8000e960 <tickslock>
    800021c8:	00004097          	auipc	ra,0x4
    800021cc:	f26080e7          	jalr	-218(ra) # 800060ee <acquire>
  ticks0 = ticks;
    800021d0:	00006917          	auipc	s2,0x6
    800021d4:	72892903          	lw	s2,1832(s2) # 800088f8 <ticks>
  while(ticks - ticks0 < n){
    800021d8:	fcc42783          	lw	a5,-52(s0)
    800021dc:	cf9d                	beqz	a5,8000221a <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021de:	0000c997          	auipc	s3,0xc
    800021e2:	78298993          	add	s3,s3,1922 # 8000e960 <tickslock>
    800021e6:	00006497          	auipc	s1,0x6
    800021ea:	71248493          	add	s1,s1,1810 # 800088f8 <ticks>
    if(killed(myproc())){
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	c60080e7          	jalr	-928(ra) # 80000e4e <myproc>
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	636080e7          	jalr	1590(ra) # 8000182c <killed>
    800021fe:	ed15                	bnez	a0,8000223a <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002200:	85ce                	mv	a1,s3
    80002202:	8526                	mv	a0,s1
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	380080e7          	jalr	896(ra) # 80001584 <sleep>
  while(ticks - ticks0 < n){
    8000220c:	409c                	lw	a5,0(s1)
    8000220e:	412787bb          	subw	a5,a5,s2
    80002212:	fcc42703          	lw	a4,-52(s0)
    80002216:	fce7ece3          	bltu	a5,a4,800021ee <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000221a:	0000c517          	auipc	a0,0xc
    8000221e:	74650513          	add	a0,a0,1862 # 8000e960 <tickslock>
    80002222:	00004097          	auipc	ra,0x4
    80002226:	f80080e7          	jalr	-128(ra) # 800061a2 <release>
  return 0;
    8000222a:	4501                	li	a0,0
}
    8000222c:	70e2                	ld	ra,56(sp)
    8000222e:	7442                	ld	s0,48(sp)
    80002230:	74a2                	ld	s1,40(sp)
    80002232:	7902                	ld	s2,32(sp)
    80002234:	69e2                	ld	s3,24(sp)
    80002236:	6121                	add	sp,sp,64
    80002238:	8082                	ret
      release(&tickslock);
    8000223a:	0000c517          	auipc	a0,0xc
    8000223e:	72650513          	add	a0,a0,1830 # 8000e960 <tickslock>
    80002242:	00004097          	auipc	ra,0x4
    80002246:	f60080e7          	jalr	-160(ra) # 800061a2 <release>
      return -1;
    8000224a:	557d                	li	a0,-1
    8000224c:	b7c5                	j	8000222c <sys_sleep+0x88>

000000008000224e <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000224e:	1141                	add	sp,sp,-16
    80002250:	e422                	sd	s0,8(sp)
    80002252:	0800                	add	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    80002254:	4501                	li	a0,0
    80002256:	6422                	ld	s0,8(sp)
    80002258:	0141                	add	sp,sp,16
    8000225a:	8082                	ret

000000008000225c <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000225c:	1101                	add	sp,sp,-32
    8000225e:	ec06                	sd	ra,24(sp)
    80002260:	e822                	sd	s0,16(sp)
    80002262:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002264:	fec40593          	add	a1,s0,-20
    80002268:	4501                	li	a0,0
    8000226a:	00000097          	auipc	ra,0x0
    8000226e:	d8c080e7          	jalr	-628(ra) # 80001ff6 <argint>
  return kill(pid);
    80002272:	fec42503          	lw	a0,-20(s0)
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	518080e7          	jalr	1304(ra) # 8000178e <kill>
}
    8000227e:	60e2                	ld	ra,24(sp)
    80002280:	6442                	ld	s0,16(sp)
    80002282:	6105                	add	sp,sp,32
    80002284:	8082                	ret

0000000080002286 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002286:	1101                	add	sp,sp,-32
    80002288:	ec06                	sd	ra,24(sp)
    8000228a:	e822                	sd	s0,16(sp)
    8000228c:	e426                	sd	s1,8(sp)
    8000228e:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002290:	0000c517          	auipc	a0,0xc
    80002294:	6d050513          	add	a0,a0,1744 # 8000e960 <tickslock>
    80002298:	00004097          	auipc	ra,0x4
    8000229c:	e56080e7          	jalr	-426(ra) # 800060ee <acquire>
  xticks = ticks;
    800022a0:	00006497          	auipc	s1,0x6
    800022a4:	6584a483          	lw	s1,1624(s1) # 800088f8 <ticks>
  release(&tickslock);
    800022a8:	0000c517          	auipc	a0,0xc
    800022ac:	6b850513          	add	a0,a0,1720 # 8000e960 <tickslock>
    800022b0:	00004097          	auipc	ra,0x4
    800022b4:	ef2080e7          	jalr	-270(ra) # 800061a2 <release>
  return xticks;
}
    800022b8:	02049513          	sll	a0,s1,0x20
    800022bc:	9101                	srl	a0,a0,0x20
    800022be:	60e2                	ld	ra,24(sp)
    800022c0:	6442                	ld	s0,16(sp)
    800022c2:	64a2                	ld	s1,8(sp)
    800022c4:	6105                	add	sp,sp,32
    800022c6:	8082                	ret

00000000800022c8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022c8:	7179                	add	sp,sp,-48
    800022ca:	f406                	sd	ra,40(sp)
    800022cc:	f022                	sd	s0,32(sp)
    800022ce:	ec26                	sd	s1,24(sp)
    800022d0:	e84a                	sd	s2,16(sp)
    800022d2:	e44e                	sd	s3,8(sp)
    800022d4:	e052                	sd	s4,0(sp)
    800022d6:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022d8:	00006597          	auipc	a1,0x6
    800022dc:	1f058593          	add	a1,a1,496 # 800084c8 <syscalls+0xf8>
    800022e0:	0000c517          	auipc	a0,0xc
    800022e4:	69850513          	add	a0,a0,1688 # 8000e978 <bcache>
    800022e8:	00004097          	auipc	ra,0x4
    800022ec:	d76080e7          	jalr	-650(ra) # 8000605e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022f0:	00014797          	auipc	a5,0x14
    800022f4:	68878793          	add	a5,a5,1672 # 80016978 <bcache+0x8000>
    800022f8:	00015717          	auipc	a4,0x15
    800022fc:	8e870713          	add	a4,a4,-1816 # 80016be0 <bcache+0x8268>
    80002300:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002304:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002308:	0000c497          	auipc	s1,0xc
    8000230c:	68848493          	add	s1,s1,1672 # 8000e990 <bcache+0x18>
    b->next = bcache.head.next;
    80002310:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002312:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002314:	00006a17          	auipc	s4,0x6
    80002318:	1bca0a13          	add	s4,s4,444 # 800084d0 <syscalls+0x100>
    b->next = bcache.head.next;
    8000231c:	2b893783          	ld	a5,696(s2)
    80002320:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002322:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002326:	85d2                	mv	a1,s4
    80002328:	01048513          	add	a0,s1,16
    8000232c:	00001097          	auipc	ra,0x1
    80002330:	496080e7          	jalr	1174(ra) # 800037c2 <initsleeplock>
    bcache.head.next->prev = b;
    80002334:	2b893783          	ld	a5,696(s2)
    80002338:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000233a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000233e:	45848493          	add	s1,s1,1112
    80002342:	fd349de3          	bne	s1,s3,8000231c <binit+0x54>
  }
}
    80002346:	70a2                	ld	ra,40(sp)
    80002348:	7402                	ld	s0,32(sp)
    8000234a:	64e2                	ld	s1,24(sp)
    8000234c:	6942                	ld	s2,16(sp)
    8000234e:	69a2                	ld	s3,8(sp)
    80002350:	6a02                	ld	s4,0(sp)
    80002352:	6145                	add	sp,sp,48
    80002354:	8082                	ret

0000000080002356 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002356:	7179                	add	sp,sp,-48
    80002358:	f406                	sd	ra,40(sp)
    8000235a:	f022                	sd	s0,32(sp)
    8000235c:	ec26                	sd	s1,24(sp)
    8000235e:	e84a                	sd	s2,16(sp)
    80002360:	e44e                	sd	s3,8(sp)
    80002362:	1800                	add	s0,sp,48
    80002364:	892a                	mv	s2,a0
    80002366:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002368:	0000c517          	auipc	a0,0xc
    8000236c:	61050513          	add	a0,a0,1552 # 8000e978 <bcache>
    80002370:	00004097          	auipc	ra,0x4
    80002374:	d7e080e7          	jalr	-642(ra) # 800060ee <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002378:	00015497          	auipc	s1,0x15
    8000237c:	8b84b483          	ld	s1,-1864(s1) # 80016c30 <bcache+0x82b8>
    80002380:	00015797          	auipc	a5,0x15
    80002384:	86078793          	add	a5,a5,-1952 # 80016be0 <bcache+0x8268>
    80002388:	02f48f63          	beq	s1,a5,800023c6 <bread+0x70>
    8000238c:	873e                	mv	a4,a5
    8000238e:	a021                	j	80002396 <bread+0x40>
    80002390:	68a4                	ld	s1,80(s1)
    80002392:	02e48a63          	beq	s1,a4,800023c6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002396:	449c                	lw	a5,8(s1)
    80002398:	ff279ce3          	bne	a5,s2,80002390 <bread+0x3a>
    8000239c:	44dc                	lw	a5,12(s1)
    8000239e:	ff3799e3          	bne	a5,s3,80002390 <bread+0x3a>
      b->refcnt++;
    800023a2:	40bc                	lw	a5,64(s1)
    800023a4:	2785                	addw	a5,a5,1
    800023a6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023a8:	0000c517          	auipc	a0,0xc
    800023ac:	5d050513          	add	a0,a0,1488 # 8000e978 <bcache>
    800023b0:	00004097          	auipc	ra,0x4
    800023b4:	df2080e7          	jalr	-526(ra) # 800061a2 <release>
      acquiresleep(&b->lock);
    800023b8:	01048513          	add	a0,s1,16
    800023bc:	00001097          	auipc	ra,0x1
    800023c0:	440080e7          	jalr	1088(ra) # 800037fc <acquiresleep>
      return b;
    800023c4:	a8b9                	j	80002422 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023c6:	00015497          	auipc	s1,0x15
    800023ca:	8624b483          	ld	s1,-1950(s1) # 80016c28 <bcache+0x82b0>
    800023ce:	00015797          	auipc	a5,0x15
    800023d2:	81278793          	add	a5,a5,-2030 # 80016be0 <bcache+0x8268>
    800023d6:	00f48863          	beq	s1,a5,800023e6 <bread+0x90>
    800023da:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023dc:	40bc                	lw	a5,64(s1)
    800023de:	cf81                	beqz	a5,800023f6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023e0:	64a4                	ld	s1,72(s1)
    800023e2:	fee49de3          	bne	s1,a4,800023dc <bread+0x86>
  panic("bget: no buffers");
    800023e6:	00006517          	auipc	a0,0x6
    800023ea:	0f250513          	add	a0,a0,242 # 800084d8 <syscalls+0x108>
    800023ee:	00003097          	auipc	ra,0x3
    800023f2:	7c8080e7          	jalr	1992(ra) # 80005bb6 <panic>
      b->dev = dev;
    800023f6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023fa:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023fe:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002402:	4785                	li	a5,1
    80002404:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002406:	0000c517          	auipc	a0,0xc
    8000240a:	57250513          	add	a0,a0,1394 # 8000e978 <bcache>
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	d94080e7          	jalr	-620(ra) # 800061a2 <release>
      acquiresleep(&b->lock);
    80002416:	01048513          	add	a0,s1,16
    8000241a:	00001097          	auipc	ra,0x1
    8000241e:	3e2080e7          	jalr	994(ra) # 800037fc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002422:	409c                	lw	a5,0(s1)
    80002424:	cb89                	beqz	a5,80002436 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002426:	8526                	mv	a0,s1
    80002428:	70a2                	ld	ra,40(sp)
    8000242a:	7402                	ld	s0,32(sp)
    8000242c:	64e2                	ld	s1,24(sp)
    8000242e:	6942                	ld	s2,16(sp)
    80002430:	69a2                	ld	s3,8(sp)
    80002432:	6145                	add	sp,sp,48
    80002434:	8082                	ret
    virtio_disk_rw(b, 0);
    80002436:	4581                	li	a1,0
    80002438:	8526                	mv	a0,s1
    8000243a:	00003097          	auipc	ra,0x3
    8000243e:	f78080e7          	jalr	-136(ra) # 800053b2 <virtio_disk_rw>
    b->valid = 1;
    80002442:	4785                	li	a5,1
    80002444:	c09c                	sw	a5,0(s1)
  return b;
    80002446:	b7c5                	j	80002426 <bread+0xd0>

0000000080002448 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002448:	1101                	add	sp,sp,-32
    8000244a:	ec06                	sd	ra,24(sp)
    8000244c:	e822                	sd	s0,16(sp)
    8000244e:	e426                	sd	s1,8(sp)
    80002450:	1000                	add	s0,sp,32
    80002452:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002454:	0541                	add	a0,a0,16
    80002456:	00001097          	auipc	ra,0x1
    8000245a:	440080e7          	jalr	1088(ra) # 80003896 <holdingsleep>
    8000245e:	cd01                	beqz	a0,80002476 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002460:	4585                	li	a1,1
    80002462:	8526                	mv	a0,s1
    80002464:	00003097          	auipc	ra,0x3
    80002468:	f4e080e7          	jalr	-178(ra) # 800053b2 <virtio_disk_rw>
}
    8000246c:	60e2                	ld	ra,24(sp)
    8000246e:	6442                	ld	s0,16(sp)
    80002470:	64a2                	ld	s1,8(sp)
    80002472:	6105                	add	sp,sp,32
    80002474:	8082                	ret
    panic("bwrite");
    80002476:	00006517          	auipc	a0,0x6
    8000247a:	07a50513          	add	a0,a0,122 # 800084f0 <syscalls+0x120>
    8000247e:	00003097          	auipc	ra,0x3
    80002482:	738080e7          	jalr	1848(ra) # 80005bb6 <panic>

0000000080002486 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002486:	1101                	add	sp,sp,-32
    80002488:	ec06                	sd	ra,24(sp)
    8000248a:	e822                	sd	s0,16(sp)
    8000248c:	e426                	sd	s1,8(sp)
    8000248e:	e04a                	sd	s2,0(sp)
    80002490:	1000                	add	s0,sp,32
    80002492:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002494:	01050913          	add	s2,a0,16
    80002498:	854a                	mv	a0,s2
    8000249a:	00001097          	auipc	ra,0x1
    8000249e:	3fc080e7          	jalr	1020(ra) # 80003896 <holdingsleep>
    800024a2:	c925                	beqz	a0,80002512 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800024a4:	854a                	mv	a0,s2
    800024a6:	00001097          	auipc	ra,0x1
    800024aa:	3ac080e7          	jalr	940(ra) # 80003852 <releasesleep>

  acquire(&bcache.lock);
    800024ae:	0000c517          	auipc	a0,0xc
    800024b2:	4ca50513          	add	a0,a0,1226 # 8000e978 <bcache>
    800024b6:	00004097          	auipc	ra,0x4
    800024ba:	c38080e7          	jalr	-968(ra) # 800060ee <acquire>
  b->refcnt--;
    800024be:	40bc                	lw	a5,64(s1)
    800024c0:	37fd                	addw	a5,a5,-1
    800024c2:	0007871b          	sext.w	a4,a5
    800024c6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024c8:	e71d                	bnez	a4,800024f6 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024ca:	68b8                	ld	a4,80(s1)
    800024cc:	64bc                	ld	a5,72(s1)
    800024ce:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800024d0:	68b8                	ld	a4,80(s1)
    800024d2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024d4:	00014797          	auipc	a5,0x14
    800024d8:	4a478793          	add	a5,a5,1188 # 80016978 <bcache+0x8000>
    800024dc:	2b87b703          	ld	a4,696(a5)
    800024e0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024e2:	00014717          	auipc	a4,0x14
    800024e6:	6fe70713          	add	a4,a4,1790 # 80016be0 <bcache+0x8268>
    800024ea:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024ec:	2b87b703          	ld	a4,696(a5)
    800024f0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024f2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024f6:	0000c517          	auipc	a0,0xc
    800024fa:	48250513          	add	a0,a0,1154 # 8000e978 <bcache>
    800024fe:	00004097          	auipc	ra,0x4
    80002502:	ca4080e7          	jalr	-860(ra) # 800061a2 <release>
}
    80002506:	60e2                	ld	ra,24(sp)
    80002508:	6442                	ld	s0,16(sp)
    8000250a:	64a2                	ld	s1,8(sp)
    8000250c:	6902                	ld	s2,0(sp)
    8000250e:	6105                	add	sp,sp,32
    80002510:	8082                	ret
    panic("brelse");
    80002512:	00006517          	auipc	a0,0x6
    80002516:	fe650513          	add	a0,a0,-26 # 800084f8 <syscalls+0x128>
    8000251a:	00003097          	auipc	ra,0x3
    8000251e:	69c080e7          	jalr	1692(ra) # 80005bb6 <panic>

0000000080002522 <bpin>:

void
bpin(struct buf *b) {
    80002522:	1101                	add	sp,sp,-32
    80002524:	ec06                	sd	ra,24(sp)
    80002526:	e822                	sd	s0,16(sp)
    80002528:	e426                	sd	s1,8(sp)
    8000252a:	1000                	add	s0,sp,32
    8000252c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000252e:	0000c517          	auipc	a0,0xc
    80002532:	44a50513          	add	a0,a0,1098 # 8000e978 <bcache>
    80002536:	00004097          	auipc	ra,0x4
    8000253a:	bb8080e7          	jalr	-1096(ra) # 800060ee <acquire>
  b->refcnt++;
    8000253e:	40bc                	lw	a5,64(s1)
    80002540:	2785                	addw	a5,a5,1
    80002542:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002544:	0000c517          	auipc	a0,0xc
    80002548:	43450513          	add	a0,a0,1076 # 8000e978 <bcache>
    8000254c:	00004097          	auipc	ra,0x4
    80002550:	c56080e7          	jalr	-938(ra) # 800061a2 <release>
}
    80002554:	60e2                	ld	ra,24(sp)
    80002556:	6442                	ld	s0,16(sp)
    80002558:	64a2                	ld	s1,8(sp)
    8000255a:	6105                	add	sp,sp,32
    8000255c:	8082                	ret

000000008000255e <bunpin>:

void
bunpin(struct buf *b) {
    8000255e:	1101                	add	sp,sp,-32
    80002560:	ec06                	sd	ra,24(sp)
    80002562:	e822                	sd	s0,16(sp)
    80002564:	e426                	sd	s1,8(sp)
    80002566:	1000                	add	s0,sp,32
    80002568:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000256a:	0000c517          	auipc	a0,0xc
    8000256e:	40e50513          	add	a0,a0,1038 # 8000e978 <bcache>
    80002572:	00004097          	auipc	ra,0x4
    80002576:	b7c080e7          	jalr	-1156(ra) # 800060ee <acquire>
  b->refcnt--;
    8000257a:	40bc                	lw	a5,64(s1)
    8000257c:	37fd                	addw	a5,a5,-1
    8000257e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002580:	0000c517          	auipc	a0,0xc
    80002584:	3f850513          	add	a0,a0,1016 # 8000e978 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	c1a080e7          	jalr	-998(ra) # 800061a2 <release>
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6105                	add	sp,sp,32
    80002598:	8082                	ret

000000008000259a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000259a:	1101                	add	sp,sp,-32
    8000259c:	ec06                	sd	ra,24(sp)
    8000259e:	e822                	sd	s0,16(sp)
    800025a0:	e426                	sd	s1,8(sp)
    800025a2:	e04a                	sd	s2,0(sp)
    800025a4:	1000                	add	s0,sp,32
    800025a6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025a8:	00d5d59b          	srlw	a1,a1,0xd
    800025ac:	00015797          	auipc	a5,0x15
    800025b0:	aa87a783          	lw	a5,-1368(a5) # 80017054 <sb+0x1c>
    800025b4:	9dbd                	addw	a1,a1,a5
    800025b6:	00000097          	auipc	ra,0x0
    800025ba:	da0080e7          	jalr	-608(ra) # 80002356 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025be:	0074f713          	and	a4,s1,7
    800025c2:	4785                	li	a5,1
    800025c4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025c8:	14ce                	sll	s1,s1,0x33
    800025ca:	90d9                	srl	s1,s1,0x36
    800025cc:	00950733          	add	a4,a0,s1
    800025d0:	05874703          	lbu	a4,88(a4)
    800025d4:	00e7f6b3          	and	a3,a5,a4
    800025d8:	c69d                	beqz	a3,80002606 <bfree+0x6c>
    800025da:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025dc:	94aa                	add	s1,s1,a0
    800025de:	fff7c793          	not	a5,a5
    800025e2:	8f7d                	and	a4,a4,a5
    800025e4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025e8:	00001097          	auipc	ra,0x1
    800025ec:	0f6080e7          	jalr	246(ra) # 800036de <log_write>
  brelse(bp);
    800025f0:	854a                	mv	a0,s2
    800025f2:	00000097          	auipc	ra,0x0
    800025f6:	e94080e7          	jalr	-364(ra) # 80002486 <brelse>
}
    800025fa:	60e2                	ld	ra,24(sp)
    800025fc:	6442                	ld	s0,16(sp)
    800025fe:	64a2                	ld	s1,8(sp)
    80002600:	6902                	ld	s2,0(sp)
    80002602:	6105                	add	sp,sp,32
    80002604:	8082                	ret
    panic("freeing free block");
    80002606:	00006517          	auipc	a0,0x6
    8000260a:	efa50513          	add	a0,a0,-262 # 80008500 <syscalls+0x130>
    8000260e:	00003097          	auipc	ra,0x3
    80002612:	5a8080e7          	jalr	1448(ra) # 80005bb6 <panic>

0000000080002616 <balloc>:
{
    80002616:	711d                	add	sp,sp,-96
    80002618:	ec86                	sd	ra,88(sp)
    8000261a:	e8a2                	sd	s0,80(sp)
    8000261c:	e4a6                	sd	s1,72(sp)
    8000261e:	e0ca                	sd	s2,64(sp)
    80002620:	fc4e                	sd	s3,56(sp)
    80002622:	f852                	sd	s4,48(sp)
    80002624:	f456                	sd	s5,40(sp)
    80002626:	f05a                	sd	s6,32(sp)
    80002628:	ec5e                	sd	s7,24(sp)
    8000262a:	e862                	sd	s8,16(sp)
    8000262c:	e466                	sd	s9,8(sp)
    8000262e:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002630:	00015797          	auipc	a5,0x15
    80002634:	a0c7a783          	lw	a5,-1524(a5) # 8001703c <sb+0x4>
    80002638:	cff5                	beqz	a5,80002734 <balloc+0x11e>
    8000263a:	8baa                	mv	s7,a0
    8000263c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000263e:	00015b17          	auipc	s6,0x15
    80002642:	9fab0b13          	add	s6,s6,-1542 # 80017038 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002646:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002648:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000264a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000264c:	6c89                	lui	s9,0x2
    8000264e:	a061                	j	800026d6 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002650:	97ca                	add	a5,a5,s2
    80002652:	8e55                	or	a2,a2,a3
    80002654:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002658:	854a                	mv	a0,s2
    8000265a:	00001097          	auipc	ra,0x1
    8000265e:	084080e7          	jalr	132(ra) # 800036de <log_write>
        brelse(bp);
    80002662:	854a                	mv	a0,s2
    80002664:	00000097          	auipc	ra,0x0
    80002668:	e22080e7          	jalr	-478(ra) # 80002486 <brelse>
  bp = bread(dev, bno);
    8000266c:	85a6                	mv	a1,s1
    8000266e:	855e                	mv	a0,s7
    80002670:	00000097          	auipc	ra,0x0
    80002674:	ce6080e7          	jalr	-794(ra) # 80002356 <bread>
    80002678:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000267a:	40000613          	li	a2,1024
    8000267e:	4581                	li	a1,0
    80002680:	05850513          	add	a0,a0,88
    80002684:	ffffe097          	auipc	ra,0xffffe
    80002688:	af6080e7          	jalr	-1290(ra) # 8000017a <memset>
  log_write(bp);
    8000268c:	854a                	mv	a0,s2
    8000268e:	00001097          	auipc	ra,0x1
    80002692:	050080e7          	jalr	80(ra) # 800036de <log_write>
  brelse(bp);
    80002696:	854a                	mv	a0,s2
    80002698:	00000097          	auipc	ra,0x0
    8000269c:	dee080e7          	jalr	-530(ra) # 80002486 <brelse>
}
    800026a0:	8526                	mv	a0,s1
    800026a2:	60e6                	ld	ra,88(sp)
    800026a4:	6446                	ld	s0,80(sp)
    800026a6:	64a6                	ld	s1,72(sp)
    800026a8:	6906                	ld	s2,64(sp)
    800026aa:	79e2                	ld	s3,56(sp)
    800026ac:	7a42                	ld	s4,48(sp)
    800026ae:	7aa2                	ld	s5,40(sp)
    800026b0:	7b02                	ld	s6,32(sp)
    800026b2:	6be2                	ld	s7,24(sp)
    800026b4:	6c42                	ld	s8,16(sp)
    800026b6:	6ca2                	ld	s9,8(sp)
    800026b8:	6125                	add	sp,sp,96
    800026ba:	8082                	ret
    brelse(bp);
    800026bc:	854a                	mv	a0,s2
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	dc8080e7          	jalr	-568(ra) # 80002486 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026c6:	015c87bb          	addw	a5,s9,s5
    800026ca:	00078a9b          	sext.w	s5,a5
    800026ce:	004b2703          	lw	a4,4(s6)
    800026d2:	06eaf163          	bgeu	s5,a4,80002734 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800026d6:	41fad79b          	sraw	a5,s5,0x1f
    800026da:	0137d79b          	srlw	a5,a5,0x13
    800026de:	015787bb          	addw	a5,a5,s5
    800026e2:	40d7d79b          	sraw	a5,a5,0xd
    800026e6:	01cb2583          	lw	a1,28(s6)
    800026ea:	9dbd                	addw	a1,a1,a5
    800026ec:	855e                	mv	a0,s7
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	c68080e7          	jalr	-920(ra) # 80002356 <bread>
    800026f6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f8:	004b2503          	lw	a0,4(s6)
    800026fc:	000a849b          	sext.w	s1,s5
    80002700:	8762                	mv	a4,s8
    80002702:	faa4fde3          	bgeu	s1,a0,800026bc <balloc+0xa6>
      m = 1 << (bi % 8);
    80002706:	00777693          	and	a3,a4,7
    8000270a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000270e:	41f7579b          	sraw	a5,a4,0x1f
    80002712:	01d7d79b          	srlw	a5,a5,0x1d
    80002716:	9fb9                	addw	a5,a5,a4
    80002718:	4037d79b          	sraw	a5,a5,0x3
    8000271c:	00f90633          	add	a2,s2,a5
    80002720:	05864603          	lbu	a2,88(a2)
    80002724:	00c6f5b3          	and	a1,a3,a2
    80002728:	d585                	beqz	a1,80002650 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000272a:	2705                	addw	a4,a4,1
    8000272c:	2485                	addw	s1,s1,1
    8000272e:	fd471ae3          	bne	a4,s4,80002702 <balloc+0xec>
    80002732:	b769                	j	800026bc <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002734:	00006517          	auipc	a0,0x6
    80002738:	de450513          	add	a0,a0,-540 # 80008518 <syscalls+0x148>
    8000273c:	00003097          	auipc	ra,0x3
    80002740:	4c4080e7          	jalr	1220(ra) # 80005c00 <printf>
  return 0;
    80002744:	4481                	li	s1,0
    80002746:	bfa9                	j	800026a0 <balloc+0x8a>

0000000080002748 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002748:	7179                	add	sp,sp,-48
    8000274a:	f406                	sd	ra,40(sp)
    8000274c:	f022                	sd	s0,32(sp)
    8000274e:	ec26                	sd	s1,24(sp)
    80002750:	e84a                	sd	s2,16(sp)
    80002752:	e44e                	sd	s3,8(sp)
    80002754:	e052                	sd	s4,0(sp)
    80002756:	1800                	add	s0,sp,48
    80002758:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000275a:	47ad                	li	a5,11
    8000275c:	02b7e863          	bltu	a5,a1,8000278c <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002760:	02059793          	sll	a5,a1,0x20
    80002764:	01e7d593          	srl	a1,a5,0x1e
    80002768:	00b504b3          	add	s1,a0,a1
    8000276c:	0504a903          	lw	s2,80(s1)
    80002770:	06091e63          	bnez	s2,800027ec <bmap+0xa4>
      addr = balloc(ip->dev);
    80002774:	4108                	lw	a0,0(a0)
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	ea0080e7          	jalr	-352(ra) # 80002616 <balloc>
    8000277e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002782:	06090563          	beqz	s2,800027ec <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002786:	0524a823          	sw	s2,80(s1)
    8000278a:	a08d                	j	800027ec <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000278c:	ff45849b          	addw	s1,a1,-12
    80002790:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002794:	0ff00793          	li	a5,255
    80002798:	08e7e563          	bltu	a5,a4,80002822 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000279c:	08052903          	lw	s2,128(a0)
    800027a0:	00091d63          	bnez	s2,800027ba <bmap+0x72>
      addr = balloc(ip->dev);
    800027a4:	4108                	lw	a0,0(a0)
    800027a6:	00000097          	auipc	ra,0x0
    800027aa:	e70080e7          	jalr	-400(ra) # 80002616 <balloc>
    800027ae:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027b2:	02090d63          	beqz	s2,800027ec <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800027b6:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800027ba:	85ca                	mv	a1,s2
    800027bc:	0009a503          	lw	a0,0(s3)
    800027c0:	00000097          	auipc	ra,0x0
    800027c4:	b96080e7          	jalr	-1130(ra) # 80002356 <bread>
    800027c8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027ca:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    800027ce:	02049713          	sll	a4,s1,0x20
    800027d2:	01e75593          	srl	a1,a4,0x1e
    800027d6:	00b784b3          	add	s1,a5,a1
    800027da:	0004a903          	lw	s2,0(s1)
    800027de:	02090063          	beqz	s2,800027fe <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800027e2:	8552                	mv	a0,s4
    800027e4:	00000097          	auipc	ra,0x0
    800027e8:	ca2080e7          	jalr	-862(ra) # 80002486 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027ec:	854a                	mv	a0,s2
    800027ee:	70a2                	ld	ra,40(sp)
    800027f0:	7402                	ld	s0,32(sp)
    800027f2:	64e2                	ld	s1,24(sp)
    800027f4:	6942                	ld	s2,16(sp)
    800027f6:	69a2                	ld	s3,8(sp)
    800027f8:	6a02                	ld	s4,0(sp)
    800027fa:	6145                	add	sp,sp,48
    800027fc:	8082                	ret
      addr = balloc(ip->dev);
    800027fe:	0009a503          	lw	a0,0(s3)
    80002802:	00000097          	auipc	ra,0x0
    80002806:	e14080e7          	jalr	-492(ra) # 80002616 <balloc>
    8000280a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000280e:	fc090ae3          	beqz	s2,800027e2 <bmap+0x9a>
        a[bn] = addr;
    80002812:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002816:	8552                	mv	a0,s4
    80002818:	00001097          	auipc	ra,0x1
    8000281c:	ec6080e7          	jalr	-314(ra) # 800036de <log_write>
    80002820:	b7c9                	j	800027e2 <bmap+0x9a>
  panic("bmap: out of range");
    80002822:	00006517          	auipc	a0,0x6
    80002826:	d0e50513          	add	a0,a0,-754 # 80008530 <syscalls+0x160>
    8000282a:	00003097          	auipc	ra,0x3
    8000282e:	38c080e7          	jalr	908(ra) # 80005bb6 <panic>

0000000080002832 <iget>:
{
    80002832:	7179                	add	sp,sp,-48
    80002834:	f406                	sd	ra,40(sp)
    80002836:	f022                	sd	s0,32(sp)
    80002838:	ec26                	sd	s1,24(sp)
    8000283a:	e84a                	sd	s2,16(sp)
    8000283c:	e44e                	sd	s3,8(sp)
    8000283e:	e052                	sd	s4,0(sp)
    80002840:	1800                	add	s0,sp,48
    80002842:	89aa                	mv	s3,a0
    80002844:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002846:	00015517          	auipc	a0,0x15
    8000284a:	81250513          	add	a0,a0,-2030 # 80017058 <itable>
    8000284e:	00004097          	auipc	ra,0x4
    80002852:	8a0080e7          	jalr	-1888(ra) # 800060ee <acquire>
  empty = 0;
    80002856:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002858:	00015497          	auipc	s1,0x15
    8000285c:	81848493          	add	s1,s1,-2024 # 80017070 <itable+0x18>
    80002860:	00016697          	auipc	a3,0x16
    80002864:	2a068693          	add	a3,a3,672 # 80018b00 <log>
    80002868:	a039                	j	80002876 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000286a:	02090b63          	beqz	s2,800028a0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000286e:	08848493          	add	s1,s1,136
    80002872:	02d48a63          	beq	s1,a3,800028a6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002876:	449c                	lw	a5,8(s1)
    80002878:	fef059e3          	blez	a5,8000286a <iget+0x38>
    8000287c:	4098                	lw	a4,0(s1)
    8000287e:	ff3716e3          	bne	a4,s3,8000286a <iget+0x38>
    80002882:	40d8                	lw	a4,4(s1)
    80002884:	ff4713e3          	bne	a4,s4,8000286a <iget+0x38>
      ip->ref++;
    80002888:	2785                	addw	a5,a5,1
    8000288a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000288c:	00014517          	auipc	a0,0x14
    80002890:	7cc50513          	add	a0,a0,1996 # 80017058 <itable>
    80002894:	00004097          	auipc	ra,0x4
    80002898:	90e080e7          	jalr	-1778(ra) # 800061a2 <release>
      return ip;
    8000289c:	8926                	mv	s2,s1
    8000289e:	a03d                	j	800028cc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028a0:	f7f9                	bnez	a5,8000286e <iget+0x3c>
    800028a2:	8926                	mv	s2,s1
    800028a4:	b7e9                	j	8000286e <iget+0x3c>
  if(empty == 0)
    800028a6:	02090c63          	beqz	s2,800028de <iget+0xac>
  ip->dev = dev;
    800028aa:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028ae:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028b2:	4785                	li	a5,1
    800028b4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028b8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028bc:	00014517          	auipc	a0,0x14
    800028c0:	79c50513          	add	a0,a0,1948 # 80017058 <itable>
    800028c4:	00004097          	auipc	ra,0x4
    800028c8:	8de080e7          	jalr	-1826(ra) # 800061a2 <release>
}
    800028cc:	854a                	mv	a0,s2
    800028ce:	70a2                	ld	ra,40(sp)
    800028d0:	7402                	ld	s0,32(sp)
    800028d2:	64e2                	ld	s1,24(sp)
    800028d4:	6942                	ld	s2,16(sp)
    800028d6:	69a2                	ld	s3,8(sp)
    800028d8:	6a02                	ld	s4,0(sp)
    800028da:	6145                	add	sp,sp,48
    800028dc:	8082                	ret
    panic("iget: no inodes");
    800028de:	00006517          	auipc	a0,0x6
    800028e2:	c6a50513          	add	a0,a0,-918 # 80008548 <syscalls+0x178>
    800028e6:	00003097          	auipc	ra,0x3
    800028ea:	2d0080e7          	jalr	720(ra) # 80005bb6 <panic>

00000000800028ee <fsinit>:
fsinit(int dev) {
    800028ee:	7179                	add	sp,sp,-48
    800028f0:	f406                	sd	ra,40(sp)
    800028f2:	f022                	sd	s0,32(sp)
    800028f4:	ec26                	sd	s1,24(sp)
    800028f6:	e84a                	sd	s2,16(sp)
    800028f8:	e44e                	sd	s3,8(sp)
    800028fa:	1800                	add	s0,sp,48
    800028fc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028fe:	4585                	li	a1,1
    80002900:	00000097          	auipc	ra,0x0
    80002904:	a56080e7          	jalr	-1450(ra) # 80002356 <bread>
    80002908:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000290a:	00014997          	auipc	s3,0x14
    8000290e:	72e98993          	add	s3,s3,1838 # 80017038 <sb>
    80002912:	02000613          	li	a2,32
    80002916:	05850593          	add	a1,a0,88
    8000291a:	854e                	mv	a0,s3
    8000291c:	ffffe097          	auipc	ra,0xffffe
    80002920:	8ba080e7          	jalr	-1862(ra) # 800001d6 <memmove>
  brelse(bp);
    80002924:	8526                	mv	a0,s1
    80002926:	00000097          	auipc	ra,0x0
    8000292a:	b60080e7          	jalr	-1184(ra) # 80002486 <brelse>
  if(sb.magic != FSMAGIC)
    8000292e:	0009a703          	lw	a4,0(s3)
    80002932:	102037b7          	lui	a5,0x10203
    80002936:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000293a:	02f71263          	bne	a4,a5,8000295e <fsinit+0x70>
  initlog(dev, &sb);
    8000293e:	00014597          	auipc	a1,0x14
    80002942:	6fa58593          	add	a1,a1,1786 # 80017038 <sb>
    80002946:	854a                	mv	a0,s2
    80002948:	00001097          	auipc	ra,0x1
    8000294c:	b2c080e7          	jalr	-1236(ra) # 80003474 <initlog>
}
    80002950:	70a2                	ld	ra,40(sp)
    80002952:	7402                	ld	s0,32(sp)
    80002954:	64e2                	ld	s1,24(sp)
    80002956:	6942                	ld	s2,16(sp)
    80002958:	69a2                	ld	s3,8(sp)
    8000295a:	6145                	add	sp,sp,48
    8000295c:	8082                	ret
    panic("invalid file system");
    8000295e:	00006517          	auipc	a0,0x6
    80002962:	bfa50513          	add	a0,a0,-1030 # 80008558 <syscalls+0x188>
    80002966:	00003097          	auipc	ra,0x3
    8000296a:	250080e7          	jalr	592(ra) # 80005bb6 <panic>

000000008000296e <iinit>:
{
    8000296e:	7179                	add	sp,sp,-48
    80002970:	f406                	sd	ra,40(sp)
    80002972:	f022                	sd	s0,32(sp)
    80002974:	ec26                	sd	s1,24(sp)
    80002976:	e84a                	sd	s2,16(sp)
    80002978:	e44e                	sd	s3,8(sp)
    8000297a:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    8000297c:	00006597          	auipc	a1,0x6
    80002980:	bf458593          	add	a1,a1,-1036 # 80008570 <syscalls+0x1a0>
    80002984:	00014517          	auipc	a0,0x14
    80002988:	6d450513          	add	a0,a0,1748 # 80017058 <itable>
    8000298c:	00003097          	auipc	ra,0x3
    80002990:	6d2080e7          	jalr	1746(ra) # 8000605e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002994:	00014497          	auipc	s1,0x14
    80002998:	6ec48493          	add	s1,s1,1772 # 80017080 <itable+0x28>
    8000299c:	00016997          	auipc	s3,0x16
    800029a0:	17498993          	add	s3,s3,372 # 80018b10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029a4:	00006917          	auipc	s2,0x6
    800029a8:	bd490913          	add	s2,s2,-1068 # 80008578 <syscalls+0x1a8>
    800029ac:	85ca                	mv	a1,s2
    800029ae:	8526                	mv	a0,s1
    800029b0:	00001097          	auipc	ra,0x1
    800029b4:	e12080e7          	jalr	-494(ra) # 800037c2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029b8:	08848493          	add	s1,s1,136
    800029bc:	ff3498e3          	bne	s1,s3,800029ac <iinit+0x3e>
}
    800029c0:	70a2                	ld	ra,40(sp)
    800029c2:	7402                	ld	s0,32(sp)
    800029c4:	64e2                	ld	s1,24(sp)
    800029c6:	6942                	ld	s2,16(sp)
    800029c8:	69a2                	ld	s3,8(sp)
    800029ca:	6145                	add	sp,sp,48
    800029cc:	8082                	ret

00000000800029ce <ialloc>:
{
    800029ce:	7139                	add	sp,sp,-64
    800029d0:	fc06                	sd	ra,56(sp)
    800029d2:	f822                	sd	s0,48(sp)
    800029d4:	f426                	sd	s1,40(sp)
    800029d6:	f04a                	sd	s2,32(sp)
    800029d8:	ec4e                	sd	s3,24(sp)
    800029da:	e852                	sd	s4,16(sp)
    800029dc:	e456                	sd	s5,8(sp)
    800029de:	e05a                	sd	s6,0(sp)
    800029e0:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800029e2:	00014717          	auipc	a4,0x14
    800029e6:	66272703          	lw	a4,1634(a4) # 80017044 <sb+0xc>
    800029ea:	4785                	li	a5,1
    800029ec:	04e7f863          	bgeu	a5,a4,80002a3c <ialloc+0x6e>
    800029f0:	8aaa                	mv	s5,a0
    800029f2:	8b2e                	mv	s6,a1
    800029f4:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029f6:	00014a17          	auipc	s4,0x14
    800029fa:	642a0a13          	add	s4,s4,1602 # 80017038 <sb>
    800029fe:	00495593          	srl	a1,s2,0x4
    80002a02:	018a2783          	lw	a5,24(s4)
    80002a06:	9dbd                	addw	a1,a1,a5
    80002a08:	8556                	mv	a0,s5
    80002a0a:	00000097          	auipc	ra,0x0
    80002a0e:	94c080e7          	jalr	-1716(ra) # 80002356 <bread>
    80002a12:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a14:	05850993          	add	s3,a0,88
    80002a18:	00f97793          	and	a5,s2,15
    80002a1c:	079a                	sll	a5,a5,0x6
    80002a1e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a20:	00099783          	lh	a5,0(s3)
    80002a24:	cf9d                	beqz	a5,80002a62 <ialloc+0x94>
    brelse(bp);
    80002a26:	00000097          	auipc	ra,0x0
    80002a2a:	a60080e7          	jalr	-1440(ra) # 80002486 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a2e:	0905                	add	s2,s2,1
    80002a30:	00ca2703          	lw	a4,12(s4)
    80002a34:	0009079b          	sext.w	a5,s2
    80002a38:	fce7e3e3          	bltu	a5,a4,800029fe <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002a3c:	00006517          	auipc	a0,0x6
    80002a40:	b4450513          	add	a0,a0,-1212 # 80008580 <syscalls+0x1b0>
    80002a44:	00003097          	auipc	ra,0x3
    80002a48:	1bc080e7          	jalr	444(ra) # 80005c00 <printf>
  return 0;
    80002a4c:	4501                	li	a0,0
}
    80002a4e:	70e2                	ld	ra,56(sp)
    80002a50:	7442                	ld	s0,48(sp)
    80002a52:	74a2                	ld	s1,40(sp)
    80002a54:	7902                	ld	s2,32(sp)
    80002a56:	69e2                	ld	s3,24(sp)
    80002a58:	6a42                	ld	s4,16(sp)
    80002a5a:	6aa2                	ld	s5,8(sp)
    80002a5c:	6b02                	ld	s6,0(sp)
    80002a5e:	6121                	add	sp,sp,64
    80002a60:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a62:	04000613          	li	a2,64
    80002a66:	4581                	li	a1,0
    80002a68:	854e                	mv	a0,s3
    80002a6a:	ffffd097          	auipc	ra,0xffffd
    80002a6e:	710080e7          	jalr	1808(ra) # 8000017a <memset>
      dip->type = type;
    80002a72:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a76:	8526                	mv	a0,s1
    80002a78:	00001097          	auipc	ra,0x1
    80002a7c:	c66080e7          	jalr	-922(ra) # 800036de <log_write>
      brelse(bp);
    80002a80:	8526                	mv	a0,s1
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	a04080e7          	jalr	-1532(ra) # 80002486 <brelse>
      return iget(dev, inum);
    80002a8a:	0009059b          	sext.w	a1,s2
    80002a8e:	8556                	mv	a0,s5
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	da2080e7          	jalr	-606(ra) # 80002832 <iget>
    80002a98:	bf5d                	j	80002a4e <ialloc+0x80>

0000000080002a9a <iupdate>:
{
    80002a9a:	1101                	add	sp,sp,-32
    80002a9c:	ec06                	sd	ra,24(sp)
    80002a9e:	e822                	sd	s0,16(sp)
    80002aa0:	e426                	sd	s1,8(sp)
    80002aa2:	e04a                	sd	s2,0(sp)
    80002aa4:	1000                	add	s0,sp,32
    80002aa6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aa8:	415c                	lw	a5,4(a0)
    80002aaa:	0047d79b          	srlw	a5,a5,0x4
    80002aae:	00014597          	auipc	a1,0x14
    80002ab2:	5a25a583          	lw	a1,1442(a1) # 80017050 <sb+0x18>
    80002ab6:	9dbd                	addw	a1,a1,a5
    80002ab8:	4108                	lw	a0,0(a0)
    80002aba:	00000097          	auipc	ra,0x0
    80002abe:	89c080e7          	jalr	-1892(ra) # 80002356 <bread>
    80002ac2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ac4:	05850793          	add	a5,a0,88
    80002ac8:	40d8                	lw	a4,4(s1)
    80002aca:	8b3d                	and	a4,a4,15
    80002acc:	071a                	sll	a4,a4,0x6
    80002ace:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002ad0:	04449703          	lh	a4,68(s1)
    80002ad4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ad8:	04649703          	lh	a4,70(s1)
    80002adc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ae0:	04849703          	lh	a4,72(s1)
    80002ae4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ae8:	04a49703          	lh	a4,74(s1)
    80002aec:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002af0:	44f8                	lw	a4,76(s1)
    80002af2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002af4:	03400613          	li	a2,52
    80002af8:	05048593          	add	a1,s1,80
    80002afc:	00c78513          	add	a0,a5,12
    80002b00:	ffffd097          	auipc	ra,0xffffd
    80002b04:	6d6080e7          	jalr	1750(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b08:	854a                	mv	a0,s2
    80002b0a:	00001097          	auipc	ra,0x1
    80002b0e:	bd4080e7          	jalr	-1068(ra) # 800036de <log_write>
  brelse(bp);
    80002b12:	854a                	mv	a0,s2
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	972080e7          	jalr	-1678(ra) # 80002486 <brelse>
}
    80002b1c:	60e2                	ld	ra,24(sp)
    80002b1e:	6442                	ld	s0,16(sp)
    80002b20:	64a2                	ld	s1,8(sp)
    80002b22:	6902                	ld	s2,0(sp)
    80002b24:	6105                	add	sp,sp,32
    80002b26:	8082                	ret

0000000080002b28 <idup>:
{
    80002b28:	1101                	add	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	1000                	add	s0,sp,32
    80002b32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b34:	00014517          	auipc	a0,0x14
    80002b38:	52450513          	add	a0,a0,1316 # 80017058 <itable>
    80002b3c:	00003097          	auipc	ra,0x3
    80002b40:	5b2080e7          	jalr	1458(ra) # 800060ee <acquire>
  ip->ref++;
    80002b44:	449c                	lw	a5,8(s1)
    80002b46:	2785                	addw	a5,a5,1
    80002b48:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b4a:	00014517          	auipc	a0,0x14
    80002b4e:	50e50513          	add	a0,a0,1294 # 80017058 <itable>
    80002b52:	00003097          	auipc	ra,0x3
    80002b56:	650080e7          	jalr	1616(ra) # 800061a2 <release>
}
    80002b5a:	8526                	mv	a0,s1
    80002b5c:	60e2                	ld	ra,24(sp)
    80002b5e:	6442                	ld	s0,16(sp)
    80002b60:	64a2                	ld	s1,8(sp)
    80002b62:	6105                	add	sp,sp,32
    80002b64:	8082                	ret

0000000080002b66 <ilock>:
{
    80002b66:	1101                	add	sp,sp,-32
    80002b68:	ec06                	sd	ra,24(sp)
    80002b6a:	e822                	sd	s0,16(sp)
    80002b6c:	e426                	sd	s1,8(sp)
    80002b6e:	e04a                	sd	s2,0(sp)
    80002b70:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b72:	c115                	beqz	a0,80002b96 <ilock+0x30>
    80002b74:	84aa                	mv	s1,a0
    80002b76:	451c                	lw	a5,8(a0)
    80002b78:	00f05f63          	blez	a5,80002b96 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b7c:	0541                	add	a0,a0,16
    80002b7e:	00001097          	auipc	ra,0x1
    80002b82:	c7e080e7          	jalr	-898(ra) # 800037fc <acquiresleep>
  if(ip->valid == 0){
    80002b86:	40bc                	lw	a5,64(s1)
    80002b88:	cf99                	beqz	a5,80002ba6 <ilock+0x40>
}
    80002b8a:	60e2                	ld	ra,24(sp)
    80002b8c:	6442                	ld	s0,16(sp)
    80002b8e:	64a2                	ld	s1,8(sp)
    80002b90:	6902                	ld	s2,0(sp)
    80002b92:	6105                	add	sp,sp,32
    80002b94:	8082                	ret
    panic("ilock");
    80002b96:	00006517          	auipc	a0,0x6
    80002b9a:	a0250513          	add	a0,a0,-1534 # 80008598 <syscalls+0x1c8>
    80002b9e:	00003097          	auipc	ra,0x3
    80002ba2:	018080e7          	jalr	24(ra) # 80005bb6 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ba6:	40dc                	lw	a5,4(s1)
    80002ba8:	0047d79b          	srlw	a5,a5,0x4
    80002bac:	00014597          	auipc	a1,0x14
    80002bb0:	4a45a583          	lw	a1,1188(a1) # 80017050 <sb+0x18>
    80002bb4:	9dbd                	addw	a1,a1,a5
    80002bb6:	4088                	lw	a0,0(s1)
    80002bb8:	fffff097          	auipc	ra,0xfffff
    80002bbc:	79e080e7          	jalr	1950(ra) # 80002356 <bread>
    80002bc0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bc2:	05850593          	add	a1,a0,88
    80002bc6:	40dc                	lw	a5,4(s1)
    80002bc8:	8bbd                	and	a5,a5,15
    80002bca:	079a                	sll	a5,a5,0x6
    80002bcc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bce:	00059783          	lh	a5,0(a1)
    80002bd2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bd6:	00259783          	lh	a5,2(a1)
    80002bda:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bde:	00459783          	lh	a5,4(a1)
    80002be2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002be6:	00659783          	lh	a5,6(a1)
    80002bea:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bee:	459c                	lw	a5,8(a1)
    80002bf0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bf2:	03400613          	li	a2,52
    80002bf6:	05b1                	add	a1,a1,12
    80002bf8:	05048513          	add	a0,s1,80
    80002bfc:	ffffd097          	auipc	ra,0xffffd
    80002c00:	5da080e7          	jalr	1498(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c04:	854a                	mv	a0,s2
    80002c06:	00000097          	auipc	ra,0x0
    80002c0a:	880080e7          	jalr	-1920(ra) # 80002486 <brelse>
    ip->valid = 1;
    80002c0e:	4785                	li	a5,1
    80002c10:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c12:	04449783          	lh	a5,68(s1)
    80002c16:	fbb5                	bnez	a5,80002b8a <ilock+0x24>
      panic("ilock: no type");
    80002c18:	00006517          	auipc	a0,0x6
    80002c1c:	98850513          	add	a0,a0,-1656 # 800085a0 <syscalls+0x1d0>
    80002c20:	00003097          	auipc	ra,0x3
    80002c24:	f96080e7          	jalr	-106(ra) # 80005bb6 <panic>

0000000080002c28 <iunlock>:
{
    80002c28:	1101                	add	sp,sp,-32
    80002c2a:	ec06                	sd	ra,24(sp)
    80002c2c:	e822                	sd	s0,16(sp)
    80002c2e:	e426                	sd	s1,8(sp)
    80002c30:	e04a                	sd	s2,0(sp)
    80002c32:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c34:	c905                	beqz	a0,80002c64 <iunlock+0x3c>
    80002c36:	84aa                	mv	s1,a0
    80002c38:	01050913          	add	s2,a0,16
    80002c3c:	854a                	mv	a0,s2
    80002c3e:	00001097          	auipc	ra,0x1
    80002c42:	c58080e7          	jalr	-936(ra) # 80003896 <holdingsleep>
    80002c46:	cd19                	beqz	a0,80002c64 <iunlock+0x3c>
    80002c48:	449c                	lw	a5,8(s1)
    80002c4a:	00f05d63          	blez	a5,80002c64 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c4e:	854a                	mv	a0,s2
    80002c50:	00001097          	auipc	ra,0x1
    80002c54:	c02080e7          	jalr	-1022(ra) # 80003852 <releasesleep>
}
    80002c58:	60e2                	ld	ra,24(sp)
    80002c5a:	6442                	ld	s0,16(sp)
    80002c5c:	64a2                	ld	s1,8(sp)
    80002c5e:	6902                	ld	s2,0(sp)
    80002c60:	6105                	add	sp,sp,32
    80002c62:	8082                	ret
    panic("iunlock");
    80002c64:	00006517          	auipc	a0,0x6
    80002c68:	94c50513          	add	a0,a0,-1716 # 800085b0 <syscalls+0x1e0>
    80002c6c:	00003097          	auipc	ra,0x3
    80002c70:	f4a080e7          	jalr	-182(ra) # 80005bb6 <panic>

0000000080002c74 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c74:	7179                	add	sp,sp,-48
    80002c76:	f406                	sd	ra,40(sp)
    80002c78:	f022                	sd	s0,32(sp)
    80002c7a:	ec26                	sd	s1,24(sp)
    80002c7c:	e84a                	sd	s2,16(sp)
    80002c7e:	e44e                	sd	s3,8(sp)
    80002c80:	e052                	sd	s4,0(sp)
    80002c82:	1800                	add	s0,sp,48
    80002c84:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c86:	05050493          	add	s1,a0,80
    80002c8a:	08050913          	add	s2,a0,128
    80002c8e:	a021                	j	80002c96 <itrunc+0x22>
    80002c90:	0491                	add	s1,s1,4
    80002c92:	01248d63          	beq	s1,s2,80002cac <itrunc+0x38>
    if(ip->addrs[i]){
    80002c96:	408c                	lw	a1,0(s1)
    80002c98:	dde5                	beqz	a1,80002c90 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c9a:	0009a503          	lw	a0,0(s3)
    80002c9e:	00000097          	auipc	ra,0x0
    80002ca2:	8fc080e7          	jalr	-1796(ra) # 8000259a <bfree>
      ip->addrs[i] = 0;
    80002ca6:	0004a023          	sw	zero,0(s1)
    80002caa:	b7dd                	j	80002c90 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cac:	0809a583          	lw	a1,128(s3)
    80002cb0:	e185                	bnez	a1,80002cd0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cb2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cb6:	854e                	mv	a0,s3
    80002cb8:	00000097          	auipc	ra,0x0
    80002cbc:	de2080e7          	jalr	-542(ra) # 80002a9a <iupdate>
}
    80002cc0:	70a2                	ld	ra,40(sp)
    80002cc2:	7402                	ld	s0,32(sp)
    80002cc4:	64e2                	ld	s1,24(sp)
    80002cc6:	6942                	ld	s2,16(sp)
    80002cc8:	69a2                	ld	s3,8(sp)
    80002cca:	6a02                	ld	s4,0(sp)
    80002ccc:	6145                	add	sp,sp,48
    80002cce:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cd0:	0009a503          	lw	a0,0(s3)
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	682080e7          	jalr	1666(ra) # 80002356 <bread>
    80002cdc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cde:	05850493          	add	s1,a0,88
    80002ce2:	45850913          	add	s2,a0,1112
    80002ce6:	a021                	j	80002cee <itrunc+0x7a>
    80002ce8:	0491                	add	s1,s1,4
    80002cea:	01248b63          	beq	s1,s2,80002d00 <itrunc+0x8c>
      if(a[j])
    80002cee:	408c                	lw	a1,0(s1)
    80002cf0:	dde5                	beqz	a1,80002ce8 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002cf2:	0009a503          	lw	a0,0(s3)
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	8a4080e7          	jalr	-1884(ra) # 8000259a <bfree>
    80002cfe:	b7ed                	j	80002ce8 <itrunc+0x74>
    brelse(bp);
    80002d00:	8552                	mv	a0,s4
    80002d02:	fffff097          	auipc	ra,0xfffff
    80002d06:	784080e7          	jalr	1924(ra) # 80002486 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d0a:	0809a583          	lw	a1,128(s3)
    80002d0e:	0009a503          	lw	a0,0(s3)
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	888080e7          	jalr	-1912(ra) # 8000259a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d1a:	0809a023          	sw	zero,128(s3)
    80002d1e:	bf51                	j	80002cb2 <itrunc+0x3e>

0000000080002d20 <iput>:
{
    80002d20:	1101                	add	sp,sp,-32
    80002d22:	ec06                	sd	ra,24(sp)
    80002d24:	e822                	sd	s0,16(sp)
    80002d26:	e426                	sd	s1,8(sp)
    80002d28:	e04a                	sd	s2,0(sp)
    80002d2a:	1000                	add	s0,sp,32
    80002d2c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d2e:	00014517          	auipc	a0,0x14
    80002d32:	32a50513          	add	a0,a0,810 # 80017058 <itable>
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	3b8080e7          	jalr	952(ra) # 800060ee <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d3e:	4498                	lw	a4,8(s1)
    80002d40:	4785                	li	a5,1
    80002d42:	02f70363          	beq	a4,a5,80002d68 <iput+0x48>
  ip->ref--;
    80002d46:	449c                	lw	a5,8(s1)
    80002d48:	37fd                	addw	a5,a5,-1
    80002d4a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d4c:	00014517          	auipc	a0,0x14
    80002d50:	30c50513          	add	a0,a0,780 # 80017058 <itable>
    80002d54:	00003097          	auipc	ra,0x3
    80002d58:	44e080e7          	jalr	1102(ra) # 800061a2 <release>
}
    80002d5c:	60e2                	ld	ra,24(sp)
    80002d5e:	6442                	ld	s0,16(sp)
    80002d60:	64a2                	ld	s1,8(sp)
    80002d62:	6902                	ld	s2,0(sp)
    80002d64:	6105                	add	sp,sp,32
    80002d66:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d68:	40bc                	lw	a5,64(s1)
    80002d6a:	dff1                	beqz	a5,80002d46 <iput+0x26>
    80002d6c:	04a49783          	lh	a5,74(s1)
    80002d70:	fbf9                	bnez	a5,80002d46 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d72:	01048913          	add	s2,s1,16
    80002d76:	854a                	mv	a0,s2
    80002d78:	00001097          	auipc	ra,0x1
    80002d7c:	a84080e7          	jalr	-1404(ra) # 800037fc <acquiresleep>
    release(&itable.lock);
    80002d80:	00014517          	auipc	a0,0x14
    80002d84:	2d850513          	add	a0,a0,728 # 80017058 <itable>
    80002d88:	00003097          	auipc	ra,0x3
    80002d8c:	41a080e7          	jalr	1050(ra) # 800061a2 <release>
    itrunc(ip);
    80002d90:	8526                	mv	a0,s1
    80002d92:	00000097          	auipc	ra,0x0
    80002d96:	ee2080e7          	jalr	-286(ra) # 80002c74 <itrunc>
    ip->type = 0;
    80002d9a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d9e:	8526                	mv	a0,s1
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	cfa080e7          	jalr	-774(ra) # 80002a9a <iupdate>
    ip->valid = 0;
    80002da8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dac:	854a                	mv	a0,s2
    80002dae:	00001097          	auipc	ra,0x1
    80002db2:	aa4080e7          	jalr	-1372(ra) # 80003852 <releasesleep>
    acquire(&itable.lock);
    80002db6:	00014517          	auipc	a0,0x14
    80002dba:	2a250513          	add	a0,a0,674 # 80017058 <itable>
    80002dbe:	00003097          	auipc	ra,0x3
    80002dc2:	330080e7          	jalr	816(ra) # 800060ee <acquire>
    80002dc6:	b741                	j	80002d46 <iput+0x26>

0000000080002dc8 <iunlockput>:
{
    80002dc8:	1101                	add	sp,sp,-32
    80002dca:	ec06                	sd	ra,24(sp)
    80002dcc:	e822                	sd	s0,16(sp)
    80002dce:	e426                	sd	s1,8(sp)
    80002dd0:	1000                	add	s0,sp,32
    80002dd2:	84aa                	mv	s1,a0
  iunlock(ip);
    80002dd4:	00000097          	auipc	ra,0x0
    80002dd8:	e54080e7          	jalr	-428(ra) # 80002c28 <iunlock>
  iput(ip);
    80002ddc:	8526                	mv	a0,s1
    80002dde:	00000097          	auipc	ra,0x0
    80002de2:	f42080e7          	jalr	-190(ra) # 80002d20 <iput>
}
    80002de6:	60e2                	ld	ra,24(sp)
    80002de8:	6442                	ld	s0,16(sp)
    80002dea:	64a2                	ld	s1,8(sp)
    80002dec:	6105                	add	sp,sp,32
    80002dee:	8082                	ret

0000000080002df0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002df0:	1141                	add	sp,sp,-16
    80002df2:	e422                	sd	s0,8(sp)
    80002df4:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002df6:	411c                	lw	a5,0(a0)
    80002df8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dfa:	415c                	lw	a5,4(a0)
    80002dfc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dfe:	04451783          	lh	a5,68(a0)
    80002e02:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e06:	04a51783          	lh	a5,74(a0)
    80002e0a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e0e:	04c56783          	lwu	a5,76(a0)
    80002e12:	e99c                	sd	a5,16(a1)
}
    80002e14:	6422                	ld	s0,8(sp)
    80002e16:	0141                	add	sp,sp,16
    80002e18:	8082                	ret

0000000080002e1a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e1a:	457c                	lw	a5,76(a0)
    80002e1c:	0ed7e963          	bltu	a5,a3,80002f0e <readi+0xf4>
{
    80002e20:	7159                	add	sp,sp,-112
    80002e22:	f486                	sd	ra,104(sp)
    80002e24:	f0a2                	sd	s0,96(sp)
    80002e26:	eca6                	sd	s1,88(sp)
    80002e28:	e8ca                	sd	s2,80(sp)
    80002e2a:	e4ce                	sd	s3,72(sp)
    80002e2c:	e0d2                	sd	s4,64(sp)
    80002e2e:	fc56                	sd	s5,56(sp)
    80002e30:	f85a                	sd	s6,48(sp)
    80002e32:	f45e                	sd	s7,40(sp)
    80002e34:	f062                	sd	s8,32(sp)
    80002e36:	ec66                	sd	s9,24(sp)
    80002e38:	e86a                	sd	s10,16(sp)
    80002e3a:	e46e                	sd	s11,8(sp)
    80002e3c:	1880                	add	s0,sp,112
    80002e3e:	8b2a                	mv	s6,a0
    80002e40:	8bae                	mv	s7,a1
    80002e42:	8a32                	mv	s4,a2
    80002e44:	84b6                	mv	s1,a3
    80002e46:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e48:	9f35                	addw	a4,a4,a3
    return 0;
    80002e4a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e4c:	0ad76063          	bltu	a4,a3,80002eec <readi+0xd2>
  if(off + n > ip->size)
    80002e50:	00e7f463          	bgeu	a5,a4,80002e58 <readi+0x3e>
    n = ip->size - off;
    80002e54:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e58:	0a0a8963          	beqz	s5,80002f0a <readi+0xf0>
    80002e5c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e5e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e62:	5c7d                	li	s8,-1
    80002e64:	a82d                	j	80002e9e <readi+0x84>
    80002e66:	020d1d93          	sll	s11,s10,0x20
    80002e6a:	020ddd93          	srl	s11,s11,0x20
    80002e6e:	05890613          	add	a2,s2,88
    80002e72:	86ee                	mv	a3,s11
    80002e74:	963a                	add	a2,a2,a4
    80002e76:	85d2                	mv	a1,s4
    80002e78:	855e                	mv	a0,s7
    80002e7a:	fffff097          	auipc	ra,0xfffff
    80002e7e:	b12080e7          	jalr	-1262(ra) # 8000198c <either_copyout>
    80002e82:	05850d63          	beq	a0,s8,80002edc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e86:	854a                	mv	a0,s2
    80002e88:	fffff097          	auipc	ra,0xfffff
    80002e8c:	5fe080e7          	jalr	1534(ra) # 80002486 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e90:	013d09bb          	addw	s3,s10,s3
    80002e94:	009d04bb          	addw	s1,s10,s1
    80002e98:	9a6e                	add	s4,s4,s11
    80002e9a:	0559f763          	bgeu	s3,s5,80002ee8 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e9e:	00a4d59b          	srlw	a1,s1,0xa
    80002ea2:	855a                	mv	a0,s6
    80002ea4:	00000097          	auipc	ra,0x0
    80002ea8:	8a4080e7          	jalr	-1884(ra) # 80002748 <bmap>
    80002eac:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002eb0:	cd85                	beqz	a1,80002ee8 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002eb2:	000b2503          	lw	a0,0(s6)
    80002eb6:	fffff097          	auipc	ra,0xfffff
    80002eba:	4a0080e7          	jalr	1184(ra) # 80002356 <bread>
    80002ebe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec0:	3ff4f713          	and	a4,s1,1023
    80002ec4:	40ec87bb          	subw	a5,s9,a4
    80002ec8:	413a86bb          	subw	a3,s5,s3
    80002ecc:	8d3e                	mv	s10,a5
    80002ece:	2781                	sext.w	a5,a5
    80002ed0:	0006861b          	sext.w	a2,a3
    80002ed4:	f8f679e3          	bgeu	a2,a5,80002e66 <readi+0x4c>
    80002ed8:	8d36                	mv	s10,a3
    80002eda:	b771                	j	80002e66 <readi+0x4c>
      brelse(bp);
    80002edc:	854a                	mv	a0,s2
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	5a8080e7          	jalr	1448(ra) # 80002486 <brelse>
      tot = -1;
    80002ee6:	59fd                	li	s3,-1
  }
  return tot;
    80002ee8:	0009851b          	sext.w	a0,s3
}
    80002eec:	70a6                	ld	ra,104(sp)
    80002eee:	7406                	ld	s0,96(sp)
    80002ef0:	64e6                	ld	s1,88(sp)
    80002ef2:	6946                	ld	s2,80(sp)
    80002ef4:	69a6                	ld	s3,72(sp)
    80002ef6:	6a06                	ld	s4,64(sp)
    80002ef8:	7ae2                	ld	s5,56(sp)
    80002efa:	7b42                	ld	s6,48(sp)
    80002efc:	7ba2                	ld	s7,40(sp)
    80002efe:	7c02                	ld	s8,32(sp)
    80002f00:	6ce2                	ld	s9,24(sp)
    80002f02:	6d42                	ld	s10,16(sp)
    80002f04:	6da2                	ld	s11,8(sp)
    80002f06:	6165                	add	sp,sp,112
    80002f08:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f0a:	89d6                	mv	s3,s5
    80002f0c:	bff1                	j	80002ee8 <readi+0xce>
    return 0;
    80002f0e:	4501                	li	a0,0
}
    80002f10:	8082                	ret

0000000080002f12 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f12:	457c                	lw	a5,76(a0)
    80002f14:	10d7e863          	bltu	a5,a3,80003024 <writei+0x112>
{
    80002f18:	7159                	add	sp,sp,-112
    80002f1a:	f486                	sd	ra,104(sp)
    80002f1c:	f0a2                	sd	s0,96(sp)
    80002f1e:	eca6                	sd	s1,88(sp)
    80002f20:	e8ca                	sd	s2,80(sp)
    80002f22:	e4ce                	sd	s3,72(sp)
    80002f24:	e0d2                	sd	s4,64(sp)
    80002f26:	fc56                	sd	s5,56(sp)
    80002f28:	f85a                	sd	s6,48(sp)
    80002f2a:	f45e                	sd	s7,40(sp)
    80002f2c:	f062                	sd	s8,32(sp)
    80002f2e:	ec66                	sd	s9,24(sp)
    80002f30:	e86a                	sd	s10,16(sp)
    80002f32:	e46e                	sd	s11,8(sp)
    80002f34:	1880                	add	s0,sp,112
    80002f36:	8aaa                	mv	s5,a0
    80002f38:	8bae                	mv	s7,a1
    80002f3a:	8a32                	mv	s4,a2
    80002f3c:	8936                	mv	s2,a3
    80002f3e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f40:	00e687bb          	addw	a5,a3,a4
    80002f44:	0ed7e263          	bltu	a5,a3,80003028 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f48:	00043737          	lui	a4,0x43
    80002f4c:	0ef76063          	bltu	a4,a5,8000302c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f50:	0c0b0863          	beqz	s6,80003020 <writei+0x10e>
    80002f54:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f56:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f5a:	5c7d                	li	s8,-1
    80002f5c:	a091                	j	80002fa0 <writei+0x8e>
    80002f5e:	020d1d93          	sll	s11,s10,0x20
    80002f62:	020ddd93          	srl	s11,s11,0x20
    80002f66:	05848513          	add	a0,s1,88
    80002f6a:	86ee                	mv	a3,s11
    80002f6c:	8652                	mv	a2,s4
    80002f6e:	85de                	mv	a1,s7
    80002f70:	953a                	add	a0,a0,a4
    80002f72:	fffff097          	auipc	ra,0xfffff
    80002f76:	a70080e7          	jalr	-1424(ra) # 800019e2 <either_copyin>
    80002f7a:	07850263          	beq	a0,s8,80002fde <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f7e:	8526                	mv	a0,s1
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	75e080e7          	jalr	1886(ra) # 800036de <log_write>
    brelse(bp);
    80002f88:	8526                	mv	a0,s1
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	4fc080e7          	jalr	1276(ra) # 80002486 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f92:	013d09bb          	addw	s3,s10,s3
    80002f96:	012d093b          	addw	s2,s10,s2
    80002f9a:	9a6e                	add	s4,s4,s11
    80002f9c:	0569f663          	bgeu	s3,s6,80002fe8 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002fa0:	00a9559b          	srlw	a1,s2,0xa
    80002fa4:	8556                	mv	a0,s5
    80002fa6:	fffff097          	auipc	ra,0xfffff
    80002faa:	7a2080e7          	jalr	1954(ra) # 80002748 <bmap>
    80002fae:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fb2:	c99d                	beqz	a1,80002fe8 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002fb4:	000aa503          	lw	a0,0(s5)
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	39e080e7          	jalr	926(ra) # 80002356 <bread>
    80002fc0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc2:	3ff97713          	and	a4,s2,1023
    80002fc6:	40ec87bb          	subw	a5,s9,a4
    80002fca:	413b06bb          	subw	a3,s6,s3
    80002fce:	8d3e                	mv	s10,a5
    80002fd0:	2781                	sext.w	a5,a5
    80002fd2:	0006861b          	sext.w	a2,a3
    80002fd6:	f8f674e3          	bgeu	a2,a5,80002f5e <writei+0x4c>
    80002fda:	8d36                	mv	s10,a3
    80002fdc:	b749                	j	80002f5e <writei+0x4c>
      brelse(bp);
    80002fde:	8526                	mv	a0,s1
    80002fe0:	fffff097          	auipc	ra,0xfffff
    80002fe4:	4a6080e7          	jalr	1190(ra) # 80002486 <brelse>
  }

  if(off > ip->size)
    80002fe8:	04caa783          	lw	a5,76(s5)
    80002fec:	0127f463          	bgeu	a5,s2,80002ff4 <writei+0xe2>
    ip->size = off;
    80002ff0:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002ff4:	8556                	mv	a0,s5
    80002ff6:	00000097          	auipc	ra,0x0
    80002ffa:	aa4080e7          	jalr	-1372(ra) # 80002a9a <iupdate>

  return tot;
    80002ffe:	0009851b          	sext.w	a0,s3
}
    80003002:	70a6                	ld	ra,104(sp)
    80003004:	7406                	ld	s0,96(sp)
    80003006:	64e6                	ld	s1,88(sp)
    80003008:	6946                	ld	s2,80(sp)
    8000300a:	69a6                	ld	s3,72(sp)
    8000300c:	6a06                	ld	s4,64(sp)
    8000300e:	7ae2                	ld	s5,56(sp)
    80003010:	7b42                	ld	s6,48(sp)
    80003012:	7ba2                	ld	s7,40(sp)
    80003014:	7c02                	ld	s8,32(sp)
    80003016:	6ce2                	ld	s9,24(sp)
    80003018:	6d42                	ld	s10,16(sp)
    8000301a:	6da2                	ld	s11,8(sp)
    8000301c:	6165                	add	sp,sp,112
    8000301e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003020:	89da                	mv	s3,s6
    80003022:	bfc9                	j	80002ff4 <writei+0xe2>
    return -1;
    80003024:	557d                	li	a0,-1
}
    80003026:	8082                	ret
    return -1;
    80003028:	557d                	li	a0,-1
    8000302a:	bfe1                	j	80003002 <writei+0xf0>
    return -1;
    8000302c:	557d                	li	a0,-1
    8000302e:	bfd1                	j	80003002 <writei+0xf0>

0000000080003030 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003030:	1141                	add	sp,sp,-16
    80003032:	e406                	sd	ra,8(sp)
    80003034:	e022                	sd	s0,0(sp)
    80003036:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003038:	4639                	li	a2,14
    8000303a:	ffffd097          	auipc	ra,0xffffd
    8000303e:	210080e7          	jalr	528(ra) # 8000024a <strncmp>
}
    80003042:	60a2                	ld	ra,8(sp)
    80003044:	6402                	ld	s0,0(sp)
    80003046:	0141                	add	sp,sp,16
    80003048:	8082                	ret

000000008000304a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000304a:	7139                	add	sp,sp,-64
    8000304c:	fc06                	sd	ra,56(sp)
    8000304e:	f822                	sd	s0,48(sp)
    80003050:	f426                	sd	s1,40(sp)
    80003052:	f04a                	sd	s2,32(sp)
    80003054:	ec4e                	sd	s3,24(sp)
    80003056:	e852                	sd	s4,16(sp)
    80003058:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000305a:	04451703          	lh	a4,68(a0)
    8000305e:	4785                	li	a5,1
    80003060:	00f71a63          	bne	a4,a5,80003074 <dirlookup+0x2a>
    80003064:	892a                	mv	s2,a0
    80003066:	89ae                	mv	s3,a1
    80003068:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000306a:	457c                	lw	a5,76(a0)
    8000306c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000306e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003070:	e79d                	bnez	a5,8000309e <dirlookup+0x54>
    80003072:	a8a5                	j	800030ea <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003074:	00005517          	auipc	a0,0x5
    80003078:	54450513          	add	a0,a0,1348 # 800085b8 <syscalls+0x1e8>
    8000307c:	00003097          	auipc	ra,0x3
    80003080:	b3a080e7          	jalr	-1222(ra) # 80005bb6 <panic>
      panic("dirlookup read");
    80003084:	00005517          	auipc	a0,0x5
    80003088:	54c50513          	add	a0,a0,1356 # 800085d0 <syscalls+0x200>
    8000308c:	00003097          	auipc	ra,0x3
    80003090:	b2a080e7          	jalr	-1238(ra) # 80005bb6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003094:	24c1                	addw	s1,s1,16
    80003096:	04c92783          	lw	a5,76(s2)
    8000309a:	04f4f763          	bgeu	s1,a5,800030e8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000309e:	4741                	li	a4,16
    800030a0:	86a6                	mv	a3,s1
    800030a2:	fc040613          	add	a2,s0,-64
    800030a6:	4581                	li	a1,0
    800030a8:	854a                	mv	a0,s2
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	d70080e7          	jalr	-656(ra) # 80002e1a <readi>
    800030b2:	47c1                	li	a5,16
    800030b4:	fcf518e3          	bne	a0,a5,80003084 <dirlookup+0x3a>
    if(de.inum == 0)
    800030b8:	fc045783          	lhu	a5,-64(s0)
    800030bc:	dfe1                	beqz	a5,80003094 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030be:	fc240593          	add	a1,s0,-62
    800030c2:	854e                	mv	a0,s3
    800030c4:	00000097          	auipc	ra,0x0
    800030c8:	f6c080e7          	jalr	-148(ra) # 80003030 <namecmp>
    800030cc:	f561                	bnez	a0,80003094 <dirlookup+0x4a>
      if(poff)
    800030ce:	000a0463          	beqz	s4,800030d6 <dirlookup+0x8c>
        *poff = off;
    800030d2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030d6:	fc045583          	lhu	a1,-64(s0)
    800030da:	00092503          	lw	a0,0(s2)
    800030de:	fffff097          	auipc	ra,0xfffff
    800030e2:	754080e7          	jalr	1876(ra) # 80002832 <iget>
    800030e6:	a011                	j	800030ea <dirlookup+0xa0>
  return 0;
    800030e8:	4501                	li	a0,0
}
    800030ea:	70e2                	ld	ra,56(sp)
    800030ec:	7442                	ld	s0,48(sp)
    800030ee:	74a2                	ld	s1,40(sp)
    800030f0:	7902                	ld	s2,32(sp)
    800030f2:	69e2                	ld	s3,24(sp)
    800030f4:	6a42                	ld	s4,16(sp)
    800030f6:	6121                	add	sp,sp,64
    800030f8:	8082                	ret

00000000800030fa <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030fa:	711d                	add	sp,sp,-96
    800030fc:	ec86                	sd	ra,88(sp)
    800030fe:	e8a2                	sd	s0,80(sp)
    80003100:	e4a6                	sd	s1,72(sp)
    80003102:	e0ca                	sd	s2,64(sp)
    80003104:	fc4e                	sd	s3,56(sp)
    80003106:	f852                	sd	s4,48(sp)
    80003108:	f456                	sd	s5,40(sp)
    8000310a:	f05a                	sd	s6,32(sp)
    8000310c:	ec5e                	sd	s7,24(sp)
    8000310e:	e862                	sd	s8,16(sp)
    80003110:	e466                	sd	s9,8(sp)
    80003112:	1080                	add	s0,sp,96
    80003114:	84aa                	mv	s1,a0
    80003116:	8b2e                	mv	s6,a1
    80003118:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000311a:	00054703          	lbu	a4,0(a0)
    8000311e:	02f00793          	li	a5,47
    80003122:	02f70263          	beq	a4,a5,80003146 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003126:	ffffe097          	auipc	ra,0xffffe
    8000312a:	d28080e7          	jalr	-728(ra) # 80000e4e <myproc>
    8000312e:	15853503          	ld	a0,344(a0)
    80003132:	00000097          	auipc	ra,0x0
    80003136:	9f6080e7          	jalr	-1546(ra) # 80002b28 <idup>
    8000313a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000313c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003140:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003142:	4b85                	li	s7,1
    80003144:	a875                	j	80003200 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003146:	4585                	li	a1,1
    80003148:	4505                	li	a0,1
    8000314a:	fffff097          	auipc	ra,0xfffff
    8000314e:	6e8080e7          	jalr	1768(ra) # 80002832 <iget>
    80003152:	8a2a                	mv	s4,a0
    80003154:	b7e5                	j	8000313c <namex+0x42>
      iunlockput(ip);
    80003156:	8552                	mv	a0,s4
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	c70080e7          	jalr	-912(ra) # 80002dc8 <iunlockput>
      return 0;
    80003160:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003162:	8552                	mv	a0,s4
    80003164:	60e6                	ld	ra,88(sp)
    80003166:	6446                	ld	s0,80(sp)
    80003168:	64a6                	ld	s1,72(sp)
    8000316a:	6906                	ld	s2,64(sp)
    8000316c:	79e2                	ld	s3,56(sp)
    8000316e:	7a42                	ld	s4,48(sp)
    80003170:	7aa2                	ld	s5,40(sp)
    80003172:	7b02                	ld	s6,32(sp)
    80003174:	6be2                	ld	s7,24(sp)
    80003176:	6c42                	ld	s8,16(sp)
    80003178:	6ca2                	ld	s9,8(sp)
    8000317a:	6125                	add	sp,sp,96
    8000317c:	8082                	ret
      iunlock(ip);
    8000317e:	8552                	mv	a0,s4
    80003180:	00000097          	auipc	ra,0x0
    80003184:	aa8080e7          	jalr	-1368(ra) # 80002c28 <iunlock>
      return ip;
    80003188:	bfe9                	j	80003162 <namex+0x68>
      iunlockput(ip);
    8000318a:	8552                	mv	a0,s4
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	c3c080e7          	jalr	-964(ra) # 80002dc8 <iunlockput>
      return 0;
    80003194:	8a4e                	mv	s4,s3
    80003196:	b7f1                	j	80003162 <namex+0x68>
  len = path - s;
    80003198:	40998633          	sub	a2,s3,s1
    8000319c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800031a0:	099c5863          	bge	s8,s9,80003230 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800031a4:	4639                	li	a2,14
    800031a6:	85a6                	mv	a1,s1
    800031a8:	8556                	mv	a0,s5
    800031aa:	ffffd097          	auipc	ra,0xffffd
    800031ae:	02c080e7          	jalr	44(ra) # 800001d6 <memmove>
    800031b2:	84ce                	mv	s1,s3
  while(*path == '/')
    800031b4:	0004c783          	lbu	a5,0(s1)
    800031b8:	01279763          	bne	a5,s2,800031c6 <namex+0xcc>
    path++;
    800031bc:	0485                	add	s1,s1,1
  while(*path == '/')
    800031be:	0004c783          	lbu	a5,0(s1)
    800031c2:	ff278de3          	beq	a5,s2,800031bc <namex+0xc2>
    ilock(ip);
    800031c6:	8552                	mv	a0,s4
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	99e080e7          	jalr	-1634(ra) # 80002b66 <ilock>
    if(ip->type != T_DIR){
    800031d0:	044a1783          	lh	a5,68(s4)
    800031d4:	f97791e3          	bne	a5,s7,80003156 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800031d8:	000b0563          	beqz	s6,800031e2 <namex+0xe8>
    800031dc:	0004c783          	lbu	a5,0(s1)
    800031e0:	dfd9                	beqz	a5,8000317e <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031e2:	4601                	li	a2,0
    800031e4:	85d6                	mv	a1,s5
    800031e6:	8552                	mv	a0,s4
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	e62080e7          	jalr	-414(ra) # 8000304a <dirlookup>
    800031f0:	89aa                	mv	s3,a0
    800031f2:	dd41                	beqz	a0,8000318a <namex+0x90>
    iunlockput(ip);
    800031f4:	8552                	mv	a0,s4
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	bd2080e7          	jalr	-1070(ra) # 80002dc8 <iunlockput>
    ip = next;
    800031fe:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003200:	0004c783          	lbu	a5,0(s1)
    80003204:	01279763          	bne	a5,s2,80003212 <namex+0x118>
    path++;
    80003208:	0485                	add	s1,s1,1
  while(*path == '/')
    8000320a:	0004c783          	lbu	a5,0(s1)
    8000320e:	ff278de3          	beq	a5,s2,80003208 <namex+0x10e>
  if(*path == 0)
    80003212:	cb9d                	beqz	a5,80003248 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003214:	0004c783          	lbu	a5,0(s1)
    80003218:	89a6                	mv	s3,s1
  len = path - s;
    8000321a:	4c81                	li	s9,0
    8000321c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000321e:	01278963          	beq	a5,s2,80003230 <namex+0x136>
    80003222:	dbbd                	beqz	a5,80003198 <namex+0x9e>
    path++;
    80003224:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003226:	0009c783          	lbu	a5,0(s3)
    8000322a:	ff279ce3          	bne	a5,s2,80003222 <namex+0x128>
    8000322e:	b7ad                	j	80003198 <namex+0x9e>
    memmove(name, s, len);
    80003230:	2601                	sext.w	a2,a2
    80003232:	85a6                	mv	a1,s1
    80003234:	8556                	mv	a0,s5
    80003236:	ffffd097          	auipc	ra,0xffffd
    8000323a:	fa0080e7          	jalr	-96(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000323e:	9cd6                	add	s9,s9,s5
    80003240:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003244:	84ce                	mv	s1,s3
    80003246:	b7bd                	j	800031b4 <namex+0xba>
  if(nameiparent){
    80003248:	f00b0de3          	beqz	s6,80003162 <namex+0x68>
    iput(ip);
    8000324c:	8552                	mv	a0,s4
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	ad2080e7          	jalr	-1326(ra) # 80002d20 <iput>
    return 0;
    80003256:	4a01                	li	s4,0
    80003258:	b729                	j	80003162 <namex+0x68>

000000008000325a <dirlink>:
{
    8000325a:	7139                	add	sp,sp,-64
    8000325c:	fc06                	sd	ra,56(sp)
    8000325e:	f822                	sd	s0,48(sp)
    80003260:	f426                	sd	s1,40(sp)
    80003262:	f04a                	sd	s2,32(sp)
    80003264:	ec4e                	sd	s3,24(sp)
    80003266:	e852                	sd	s4,16(sp)
    80003268:	0080                	add	s0,sp,64
    8000326a:	892a                	mv	s2,a0
    8000326c:	8a2e                	mv	s4,a1
    8000326e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003270:	4601                	li	a2,0
    80003272:	00000097          	auipc	ra,0x0
    80003276:	dd8080e7          	jalr	-552(ra) # 8000304a <dirlookup>
    8000327a:	e93d                	bnez	a0,800032f0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000327c:	04c92483          	lw	s1,76(s2)
    80003280:	c49d                	beqz	s1,800032ae <dirlink+0x54>
    80003282:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003284:	4741                	li	a4,16
    80003286:	86a6                	mv	a3,s1
    80003288:	fc040613          	add	a2,s0,-64
    8000328c:	4581                	li	a1,0
    8000328e:	854a                	mv	a0,s2
    80003290:	00000097          	auipc	ra,0x0
    80003294:	b8a080e7          	jalr	-1142(ra) # 80002e1a <readi>
    80003298:	47c1                	li	a5,16
    8000329a:	06f51163          	bne	a0,a5,800032fc <dirlink+0xa2>
    if(de.inum == 0)
    8000329e:	fc045783          	lhu	a5,-64(s0)
    800032a2:	c791                	beqz	a5,800032ae <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a4:	24c1                	addw	s1,s1,16
    800032a6:	04c92783          	lw	a5,76(s2)
    800032aa:	fcf4ede3          	bltu	s1,a5,80003284 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032ae:	4639                	li	a2,14
    800032b0:	85d2                	mv	a1,s4
    800032b2:	fc240513          	add	a0,s0,-62
    800032b6:	ffffd097          	auipc	ra,0xffffd
    800032ba:	fd0080e7          	jalr	-48(ra) # 80000286 <strncpy>
  de.inum = inum;
    800032be:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c2:	4741                	li	a4,16
    800032c4:	86a6                	mv	a3,s1
    800032c6:	fc040613          	add	a2,s0,-64
    800032ca:	4581                	li	a1,0
    800032cc:	854a                	mv	a0,s2
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	c44080e7          	jalr	-956(ra) # 80002f12 <writei>
    800032d6:	1541                	add	a0,a0,-16
    800032d8:	00a03533          	snez	a0,a0
    800032dc:	40a00533          	neg	a0,a0
}
    800032e0:	70e2                	ld	ra,56(sp)
    800032e2:	7442                	ld	s0,48(sp)
    800032e4:	74a2                	ld	s1,40(sp)
    800032e6:	7902                	ld	s2,32(sp)
    800032e8:	69e2                	ld	s3,24(sp)
    800032ea:	6a42                	ld	s4,16(sp)
    800032ec:	6121                	add	sp,sp,64
    800032ee:	8082                	ret
    iput(ip);
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	a30080e7          	jalr	-1488(ra) # 80002d20 <iput>
    return -1;
    800032f8:	557d                	li	a0,-1
    800032fa:	b7dd                	j	800032e0 <dirlink+0x86>
      panic("dirlink read");
    800032fc:	00005517          	auipc	a0,0x5
    80003300:	2e450513          	add	a0,a0,740 # 800085e0 <syscalls+0x210>
    80003304:	00003097          	auipc	ra,0x3
    80003308:	8b2080e7          	jalr	-1870(ra) # 80005bb6 <panic>

000000008000330c <namei>:

struct inode*
namei(char *path)
{
    8000330c:	1101                	add	sp,sp,-32
    8000330e:	ec06                	sd	ra,24(sp)
    80003310:	e822                	sd	s0,16(sp)
    80003312:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003314:	fe040613          	add	a2,s0,-32
    80003318:	4581                	li	a1,0
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	de0080e7          	jalr	-544(ra) # 800030fa <namex>
}
    80003322:	60e2                	ld	ra,24(sp)
    80003324:	6442                	ld	s0,16(sp)
    80003326:	6105                	add	sp,sp,32
    80003328:	8082                	ret

000000008000332a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000332a:	1141                	add	sp,sp,-16
    8000332c:	e406                	sd	ra,8(sp)
    8000332e:	e022                	sd	s0,0(sp)
    80003330:	0800                	add	s0,sp,16
    80003332:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003334:	4585                	li	a1,1
    80003336:	00000097          	auipc	ra,0x0
    8000333a:	dc4080e7          	jalr	-572(ra) # 800030fa <namex>
}
    8000333e:	60a2                	ld	ra,8(sp)
    80003340:	6402                	ld	s0,0(sp)
    80003342:	0141                	add	sp,sp,16
    80003344:	8082                	ret

0000000080003346 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003346:	1101                	add	sp,sp,-32
    80003348:	ec06                	sd	ra,24(sp)
    8000334a:	e822                	sd	s0,16(sp)
    8000334c:	e426                	sd	s1,8(sp)
    8000334e:	e04a                	sd	s2,0(sp)
    80003350:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003352:	00015917          	auipc	s2,0x15
    80003356:	7ae90913          	add	s2,s2,1966 # 80018b00 <log>
    8000335a:	01892583          	lw	a1,24(s2)
    8000335e:	02892503          	lw	a0,40(s2)
    80003362:	fffff097          	auipc	ra,0xfffff
    80003366:	ff4080e7          	jalr	-12(ra) # 80002356 <bread>
    8000336a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000336c:	02c92603          	lw	a2,44(s2)
    80003370:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003372:	00c05f63          	blez	a2,80003390 <write_head+0x4a>
    80003376:	00015717          	auipc	a4,0x15
    8000337a:	7ba70713          	add	a4,a4,1978 # 80018b30 <log+0x30>
    8000337e:	87aa                	mv	a5,a0
    80003380:	060a                	sll	a2,a2,0x2
    80003382:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003384:	4314                	lw	a3,0(a4)
    80003386:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003388:	0711                	add	a4,a4,4
    8000338a:	0791                	add	a5,a5,4
    8000338c:	fec79ce3          	bne	a5,a2,80003384 <write_head+0x3e>
  }
  bwrite(buf);
    80003390:	8526                	mv	a0,s1
    80003392:	fffff097          	auipc	ra,0xfffff
    80003396:	0b6080e7          	jalr	182(ra) # 80002448 <bwrite>
  brelse(buf);
    8000339a:	8526                	mv	a0,s1
    8000339c:	fffff097          	auipc	ra,0xfffff
    800033a0:	0ea080e7          	jalr	234(ra) # 80002486 <brelse>
}
    800033a4:	60e2                	ld	ra,24(sp)
    800033a6:	6442                	ld	s0,16(sp)
    800033a8:	64a2                	ld	s1,8(sp)
    800033aa:	6902                	ld	s2,0(sp)
    800033ac:	6105                	add	sp,sp,32
    800033ae:	8082                	ret

00000000800033b0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033b0:	00015797          	auipc	a5,0x15
    800033b4:	77c7a783          	lw	a5,1916(a5) # 80018b2c <log+0x2c>
    800033b8:	0af05d63          	blez	a5,80003472 <install_trans+0xc2>
{
    800033bc:	7139                	add	sp,sp,-64
    800033be:	fc06                	sd	ra,56(sp)
    800033c0:	f822                	sd	s0,48(sp)
    800033c2:	f426                	sd	s1,40(sp)
    800033c4:	f04a                	sd	s2,32(sp)
    800033c6:	ec4e                	sd	s3,24(sp)
    800033c8:	e852                	sd	s4,16(sp)
    800033ca:	e456                	sd	s5,8(sp)
    800033cc:	e05a                	sd	s6,0(sp)
    800033ce:	0080                	add	s0,sp,64
    800033d0:	8b2a                	mv	s6,a0
    800033d2:	00015a97          	auipc	s5,0x15
    800033d6:	75ea8a93          	add	s5,s5,1886 # 80018b30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033da:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033dc:	00015997          	auipc	s3,0x15
    800033e0:	72498993          	add	s3,s3,1828 # 80018b00 <log>
    800033e4:	a00d                	j	80003406 <install_trans+0x56>
    brelse(lbuf);
    800033e6:	854a                	mv	a0,s2
    800033e8:	fffff097          	auipc	ra,0xfffff
    800033ec:	09e080e7          	jalr	158(ra) # 80002486 <brelse>
    brelse(dbuf);
    800033f0:	8526                	mv	a0,s1
    800033f2:	fffff097          	auipc	ra,0xfffff
    800033f6:	094080e7          	jalr	148(ra) # 80002486 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033fa:	2a05                	addw	s4,s4,1
    800033fc:	0a91                	add	s5,s5,4
    800033fe:	02c9a783          	lw	a5,44(s3)
    80003402:	04fa5e63          	bge	s4,a5,8000345e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003406:	0189a583          	lw	a1,24(s3)
    8000340a:	014585bb          	addw	a1,a1,s4
    8000340e:	2585                	addw	a1,a1,1
    80003410:	0289a503          	lw	a0,40(s3)
    80003414:	fffff097          	auipc	ra,0xfffff
    80003418:	f42080e7          	jalr	-190(ra) # 80002356 <bread>
    8000341c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000341e:	000aa583          	lw	a1,0(s5)
    80003422:	0289a503          	lw	a0,40(s3)
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	f30080e7          	jalr	-208(ra) # 80002356 <bread>
    8000342e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003430:	40000613          	li	a2,1024
    80003434:	05890593          	add	a1,s2,88
    80003438:	05850513          	add	a0,a0,88
    8000343c:	ffffd097          	auipc	ra,0xffffd
    80003440:	d9a080e7          	jalr	-614(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003444:	8526                	mv	a0,s1
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	002080e7          	jalr	2(ra) # 80002448 <bwrite>
    if(recovering == 0)
    8000344e:	f80b1ce3          	bnez	s6,800033e6 <install_trans+0x36>
      bunpin(dbuf);
    80003452:	8526                	mv	a0,s1
    80003454:	fffff097          	auipc	ra,0xfffff
    80003458:	10a080e7          	jalr	266(ra) # 8000255e <bunpin>
    8000345c:	b769                	j	800033e6 <install_trans+0x36>
}
    8000345e:	70e2                	ld	ra,56(sp)
    80003460:	7442                	ld	s0,48(sp)
    80003462:	74a2                	ld	s1,40(sp)
    80003464:	7902                	ld	s2,32(sp)
    80003466:	69e2                	ld	s3,24(sp)
    80003468:	6a42                	ld	s4,16(sp)
    8000346a:	6aa2                	ld	s5,8(sp)
    8000346c:	6b02                	ld	s6,0(sp)
    8000346e:	6121                	add	sp,sp,64
    80003470:	8082                	ret
    80003472:	8082                	ret

0000000080003474 <initlog>:
{
    80003474:	7179                	add	sp,sp,-48
    80003476:	f406                	sd	ra,40(sp)
    80003478:	f022                	sd	s0,32(sp)
    8000347a:	ec26                	sd	s1,24(sp)
    8000347c:	e84a                	sd	s2,16(sp)
    8000347e:	e44e                	sd	s3,8(sp)
    80003480:	1800                	add	s0,sp,48
    80003482:	892a                	mv	s2,a0
    80003484:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003486:	00015497          	auipc	s1,0x15
    8000348a:	67a48493          	add	s1,s1,1658 # 80018b00 <log>
    8000348e:	00005597          	auipc	a1,0x5
    80003492:	16258593          	add	a1,a1,354 # 800085f0 <syscalls+0x220>
    80003496:	8526                	mv	a0,s1
    80003498:	00003097          	auipc	ra,0x3
    8000349c:	bc6080e7          	jalr	-1082(ra) # 8000605e <initlock>
  log.start = sb->logstart;
    800034a0:	0149a583          	lw	a1,20(s3)
    800034a4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034a6:	0109a783          	lw	a5,16(s3)
    800034aa:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034ac:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034b0:	854a                	mv	a0,s2
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	ea4080e7          	jalr	-348(ra) # 80002356 <bread>
  log.lh.n = lh->n;
    800034ba:	4d30                	lw	a2,88(a0)
    800034bc:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034be:	00c05f63          	blez	a2,800034dc <initlog+0x68>
    800034c2:	87aa                	mv	a5,a0
    800034c4:	00015717          	auipc	a4,0x15
    800034c8:	66c70713          	add	a4,a4,1644 # 80018b30 <log+0x30>
    800034cc:	060a                	sll	a2,a2,0x2
    800034ce:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800034d0:	4ff4                	lw	a3,92(a5)
    800034d2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034d4:	0791                	add	a5,a5,4
    800034d6:	0711                	add	a4,a4,4
    800034d8:	fec79ce3          	bne	a5,a2,800034d0 <initlog+0x5c>
  brelse(buf);
    800034dc:	fffff097          	auipc	ra,0xfffff
    800034e0:	faa080e7          	jalr	-86(ra) # 80002486 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034e4:	4505                	li	a0,1
    800034e6:	00000097          	auipc	ra,0x0
    800034ea:	eca080e7          	jalr	-310(ra) # 800033b0 <install_trans>
  log.lh.n = 0;
    800034ee:	00015797          	auipc	a5,0x15
    800034f2:	6207af23          	sw	zero,1598(a5) # 80018b2c <log+0x2c>
  write_head(); // clear the log
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	e50080e7          	jalr	-432(ra) # 80003346 <write_head>
}
    800034fe:	70a2                	ld	ra,40(sp)
    80003500:	7402                	ld	s0,32(sp)
    80003502:	64e2                	ld	s1,24(sp)
    80003504:	6942                	ld	s2,16(sp)
    80003506:	69a2                	ld	s3,8(sp)
    80003508:	6145                	add	sp,sp,48
    8000350a:	8082                	ret

000000008000350c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000350c:	1101                	add	sp,sp,-32
    8000350e:	ec06                	sd	ra,24(sp)
    80003510:	e822                	sd	s0,16(sp)
    80003512:	e426                	sd	s1,8(sp)
    80003514:	e04a                	sd	s2,0(sp)
    80003516:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003518:	00015517          	auipc	a0,0x15
    8000351c:	5e850513          	add	a0,a0,1512 # 80018b00 <log>
    80003520:	00003097          	auipc	ra,0x3
    80003524:	bce080e7          	jalr	-1074(ra) # 800060ee <acquire>
  while(1){
    if(log.committing){
    80003528:	00015497          	auipc	s1,0x15
    8000352c:	5d848493          	add	s1,s1,1496 # 80018b00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003530:	4979                	li	s2,30
    80003532:	a039                	j	80003540 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003534:	85a6                	mv	a1,s1
    80003536:	8526                	mv	a0,s1
    80003538:	ffffe097          	auipc	ra,0xffffe
    8000353c:	04c080e7          	jalr	76(ra) # 80001584 <sleep>
    if(log.committing){
    80003540:	50dc                	lw	a5,36(s1)
    80003542:	fbed                	bnez	a5,80003534 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003544:	5098                	lw	a4,32(s1)
    80003546:	2705                	addw	a4,a4,1
    80003548:	0027179b          	sllw	a5,a4,0x2
    8000354c:	9fb9                	addw	a5,a5,a4
    8000354e:	0017979b          	sllw	a5,a5,0x1
    80003552:	54d4                	lw	a3,44(s1)
    80003554:	9fb5                	addw	a5,a5,a3
    80003556:	00f95963          	bge	s2,a5,80003568 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000355a:	85a6                	mv	a1,s1
    8000355c:	8526                	mv	a0,s1
    8000355e:	ffffe097          	auipc	ra,0xffffe
    80003562:	026080e7          	jalr	38(ra) # 80001584 <sleep>
    80003566:	bfe9                	j	80003540 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003568:	00015517          	auipc	a0,0x15
    8000356c:	59850513          	add	a0,a0,1432 # 80018b00 <log>
    80003570:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003572:	00003097          	auipc	ra,0x3
    80003576:	c30080e7          	jalr	-976(ra) # 800061a2 <release>
      break;
    }
  }
}
    8000357a:	60e2                	ld	ra,24(sp)
    8000357c:	6442                	ld	s0,16(sp)
    8000357e:	64a2                	ld	s1,8(sp)
    80003580:	6902                	ld	s2,0(sp)
    80003582:	6105                	add	sp,sp,32
    80003584:	8082                	ret

0000000080003586 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003586:	7139                	add	sp,sp,-64
    80003588:	fc06                	sd	ra,56(sp)
    8000358a:	f822                	sd	s0,48(sp)
    8000358c:	f426                	sd	s1,40(sp)
    8000358e:	f04a                	sd	s2,32(sp)
    80003590:	ec4e                	sd	s3,24(sp)
    80003592:	e852                	sd	s4,16(sp)
    80003594:	e456                	sd	s5,8(sp)
    80003596:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003598:	00015497          	auipc	s1,0x15
    8000359c:	56848493          	add	s1,s1,1384 # 80018b00 <log>
    800035a0:	8526                	mv	a0,s1
    800035a2:	00003097          	auipc	ra,0x3
    800035a6:	b4c080e7          	jalr	-1204(ra) # 800060ee <acquire>
  log.outstanding -= 1;
    800035aa:	509c                	lw	a5,32(s1)
    800035ac:	37fd                	addw	a5,a5,-1
    800035ae:	0007891b          	sext.w	s2,a5
    800035b2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035b4:	50dc                	lw	a5,36(s1)
    800035b6:	e7b9                	bnez	a5,80003604 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035b8:	04091e63          	bnez	s2,80003614 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035bc:	00015497          	auipc	s1,0x15
    800035c0:	54448493          	add	s1,s1,1348 # 80018b00 <log>
    800035c4:	4785                	li	a5,1
    800035c6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035c8:	8526                	mv	a0,s1
    800035ca:	00003097          	auipc	ra,0x3
    800035ce:	bd8080e7          	jalr	-1064(ra) # 800061a2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035d2:	54dc                	lw	a5,44(s1)
    800035d4:	06f04763          	bgtz	a5,80003642 <end_op+0xbc>
    acquire(&log.lock);
    800035d8:	00015497          	auipc	s1,0x15
    800035dc:	52848493          	add	s1,s1,1320 # 80018b00 <log>
    800035e0:	8526                	mv	a0,s1
    800035e2:	00003097          	auipc	ra,0x3
    800035e6:	b0c080e7          	jalr	-1268(ra) # 800060ee <acquire>
    log.committing = 0;
    800035ea:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035ee:	8526                	mv	a0,s1
    800035f0:	ffffe097          	auipc	ra,0xffffe
    800035f4:	ff8080e7          	jalr	-8(ra) # 800015e8 <wakeup>
    release(&log.lock);
    800035f8:	8526                	mv	a0,s1
    800035fa:	00003097          	auipc	ra,0x3
    800035fe:	ba8080e7          	jalr	-1112(ra) # 800061a2 <release>
}
    80003602:	a03d                	j	80003630 <end_op+0xaa>
    panic("log.committing");
    80003604:	00005517          	auipc	a0,0x5
    80003608:	ff450513          	add	a0,a0,-12 # 800085f8 <syscalls+0x228>
    8000360c:	00002097          	auipc	ra,0x2
    80003610:	5aa080e7          	jalr	1450(ra) # 80005bb6 <panic>
    wakeup(&log);
    80003614:	00015497          	auipc	s1,0x15
    80003618:	4ec48493          	add	s1,s1,1260 # 80018b00 <log>
    8000361c:	8526                	mv	a0,s1
    8000361e:	ffffe097          	auipc	ra,0xffffe
    80003622:	fca080e7          	jalr	-54(ra) # 800015e8 <wakeup>
  release(&log.lock);
    80003626:	8526                	mv	a0,s1
    80003628:	00003097          	auipc	ra,0x3
    8000362c:	b7a080e7          	jalr	-1158(ra) # 800061a2 <release>
}
    80003630:	70e2                	ld	ra,56(sp)
    80003632:	7442                	ld	s0,48(sp)
    80003634:	74a2                	ld	s1,40(sp)
    80003636:	7902                	ld	s2,32(sp)
    80003638:	69e2                	ld	s3,24(sp)
    8000363a:	6a42                	ld	s4,16(sp)
    8000363c:	6aa2                	ld	s5,8(sp)
    8000363e:	6121                	add	sp,sp,64
    80003640:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003642:	00015a97          	auipc	s5,0x15
    80003646:	4eea8a93          	add	s5,s5,1262 # 80018b30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000364a:	00015a17          	auipc	s4,0x15
    8000364e:	4b6a0a13          	add	s4,s4,1206 # 80018b00 <log>
    80003652:	018a2583          	lw	a1,24(s4)
    80003656:	012585bb          	addw	a1,a1,s2
    8000365a:	2585                	addw	a1,a1,1
    8000365c:	028a2503          	lw	a0,40(s4)
    80003660:	fffff097          	auipc	ra,0xfffff
    80003664:	cf6080e7          	jalr	-778(ra) # 80002356 <bread>
    80003668:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000366a:	000aa583          	lw	a1,0(s5)
    8000366e:	028a2503          	lw	a0,40(s4)
    80003672:	fffff097          	auipc	ra,0xfffff
    80003676:	ce4080e7          	jalr	-796(ra) # 80002356 <bread>
    8000367a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000367c:	40000613          	li	a2,1024
    80003680:	05850593          	add	a1,a0,88
    80003684:	05848513          	add	a0,s1,88
    80003688:	ffffd097          	auipc	ra,0xffffd
    8000368c:	b4e080e7          	jalr	-1202(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003690:	8526                	mv	a0,s1
    80003692:	fffff097          	auipc	ra,0xfffff
    80003696:	db6080e7          	jalr	-586(ra) # 80002448 <bwrite>
    brelse(from);
    8000369a:	854e                	mv	a0,s3
    8000369c:	fffff097          	auipc	ra,0xfffff
    800036a0:	dea080e7          	jalr	-534(ra) # 80002486 <brelse>
    brelse(to);
    800036a4:	8526                	mv	a0,s1
    800036a6:	fffff097          	auipc	ra,0xfffff
    800036aa:	de0080e7          	jalr	-544(ra) # 80002486 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ae:	2905                	addw	s2,s2,1
    800036b0:	0a91                	add	s5,s5,4
    800036b2:	02ca2783          	lw	a5,44(s4)
    800036b6:	f8f94ee3          	blt	s2,a5,80003652 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036ba:	00000097          	auipc	ra,0x0
    800036be:	c8c080e7          	jalr	-884(ra) # 80003346 <write_head>
    install_trans(0); // Now install writes to home locations
    800036c2:	4501                	li	a0,0
    800036c4:	00000097          	auipc	ra,0x0
    800036c8:	cec080e7          	jalr	-788(ra) # 800033b0 <install_trans>
    log.lh.n = 0;
    800036cc:	00015797          	auipc	a5,0x15
    800036d0:	4607a023          	sw	zero,1120(a5) # 80018b2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	c72080e7          	jalr	-910(ra) # 80003346 <write_head>
    800036dc:	bdf5                	j	800035d8 <end_op+0x52>

00000000800036de <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036de:	1101                	add	sp,sp,-32
    800036e0:	ec06                	sd	ra,24(sp)
    800036e2:	e822                	sd	s0,16(sp)
    800036e4:	e426                	sd	s1,8(sp)
    800036e6:	e04a                	sd	s2,0(sp)
    800036e8:	1000                	add	s0,sp,32
    800036ea:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036ec:	00015917          	auipc	s2,0x15
    800036f0:	41490913          	add	s2,s2,1044 # 80018b00 <log>
    800036f4:	854a                	mv	a0,s2
    800036f6:	00003097          	auipc	ra,0x3
    800036fa:	9f8080e7          	jalr	-1544(ra) # 800060ee <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036fe:	02c92603          	lw	a2,44(s2)
    80003702:	47f5                	li	a5,29
    80003704:	06c7c563          	blt	a5,a2,8000376e <log_write+0x90>
    80003708:	00015797          	auipc	a5,0x15
    8000370c:	4147a783          	lw	a5,1044(a5) # 80018b1c <log+0x1c>
    80003710:	37fd                	addw	a5,a5,-1
    80003712:	04f65e63          	bge	a2,a5,8000376e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003716:	00015797          	auipc	a5,0x15
    8000371a:	40a7a783          	lw	a5,1034(a5) # 80018b20 <log+0x20>
    8000371e:	06f05063          	blez	a5,8000377e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003722:	4781                	li	a5,0
    80003724:	06c05563          	blez	a2,8000378e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003728:	44cc                	lw	a1,12(s1)
    8000372a:	00015717          	auipc	a4,0x15
    8000372e:	40670713          	add	a4,a4,1030 # 80018b30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003732:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003734:	4314                	lw	a3,0(a4)
    80003736:	04b68c63          	beq	a3,a1,8000378e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000373a:	2785                	addw	a5,a5,1
    8000373c:	0711                	add	a4,a4,4
    8000373e:	fef61be3          	bne	a2,a5,80003734 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003742:	0621                	add	a2,a2,8
    80003744:	060a                	sll	a2,a2,0x2
    80003746:	00015797          	auipc	a5,0x15
    8000374a:	3ba78793          	add	a5,a5,954 # 80018b00 <log>
    8000374e:	97b2                	add	a5,a5,a2
    80003750:	44d8                	lw	a4,12(s1)
    80003752:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003754:	8526                	mv	a0,s1
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	dcc080e7          	jalr	-564(ra) # 80002522 <bpin>
    log.lh.n++;
    8000375e:	00015717          	auipc	a4,0x15
    80003762:	3a270713          	add	a4,a4,930 # 80018b00 <log>
    80003766:	575c                	lw	a5,44(a4)
    80003768:	2785                	addw	a5,a5,1
    8000376a:	d75c                	sw	a5,44(a4)
    8000376c:	a82d                	j	800037a6 <log_write+0xc8>
    panic("too big a transaction");
    8000376e:	00005517          	auipc	a0,0x5
    80003772:	e9a50513          	add	a0,a0,-358 # 80008608 <syscalls+0x238>
    80003776:	00002097          	auipc	ra,0x2
    8000377a:	440080e7          	jalr	1088(ra) # 80005bb6 <panic>
    panic("log_write outside of trans");
    8000377e:	00005517          	auipc	a0,0x5
    80003782:	ea250513          	add	a0,a0,-350 # 80008620 <syscalls+0x250>
    80003786:	00002097          	auipc	ra,0x2
    8000378a:	430080e7          	jalr	1072(ra) # 80005bb6 <panic>
  log.lh.block[i] = b->blockno;
    8000378e:	00878693          	add	a3,a5,8
    80003792:	068a                	sll	a3,a3,0x2
    80003794:	00015717          	auipc	a4,0x15
    80003798:	36c70713          	add	a4,a4,876 # 80018b00 <log>
    8000379c:	9736                	add	a4,a4,a3
    8000379e:	44d4                	lw	a3,12(s1)
    800037a0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037a2:	faf609e3          	beq	a2,a5,80003754 <log_write+0x76>
  }
  release(&log.lock);
    800037a6:	00015517          	auipc	a0,0x15
    800037aa:	35a50513          	add	a0,a0,858 # 80018b00 <log>
    800037ae:	00003097          	auipc	ra,0x3
    800037b2:	9f4080e7          	jalr	-1548(ra) # 800061a2 <release>
}
    800037b6:	60e2                	ld	ra,24(sp)
    800037b8:	6442                	ld	s0,16(sp)
    800037ba:	64a2                	ld	s1,8(sp)
    800037bc:	6902                	ld	s2,0(sp)
    800037be:	6105                	add	sp,sp,32
    800037c0:	8082                	ret

00000000800037c2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037c2:	1101                	add	sp,sp,-32
    800037c4:	ec06                	sd	ra,24(sp)
    800037c6:	e822                	sd	s0,16(sp)
    800037c8:	e426                	sd	s1,8(sp)
    800037ca:	e04a                	sd	s2,0(sp)
    800037cc:	1000                	add	s0,sp,32
    800037ce:	84aa                	mv	s1,a0
    800037d0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037d2:	00005597          	auipc	a1,0x5
    800037d6:	e6e58593          	add	a1,a1,-402 # 80008640 <syscalls+0x270>
    800037da:	0521                	add	a0,a0,8
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	882080e7          	jalr	-1918(ra) # 8000605e <initlock>
  lk->name = name;
    800037e4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037ec:	0204a423          	sw	zero,40(s1)
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6902                	ld	s2,0(sp)
    800037f8:	6105                	add	sp,sp,32
    800037fa:	8082                	ret

00000000800037fc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037fc:	1101                	add	sp,sp,-32
    800037fe:	ec06                	sd	ra,24(sp)
    80003800:	e822                	sd	s0,16(sp)
    80003802:	e426                	sd	s1,8(sp)
    80003804:	e04a                	sd	s2,0(sp)
    80003806:	1000                	add	s0,sp,32
    80003808:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000380a:	00850913          	add	s2,a0,8
    8000380e:	854a                	mv	a0,s2
    80003810:	00003097          	auipc	ra,0x3
    80003814:	8de080e7          	jalr	-1826(ra) # 800060ee <acquire>
  while (lk->locked) {
    80003818:	409c                	lw	a5,0(s1)
    8000381a:	cb89                	beqz	a5,8000382c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000381c:	85ca                	mv	a1,s2
    8000381e:	8526                	mv	a0,s1
    80003820:	ffffe097          	auipc	ra,0xffffe
    80003824:	d64080e7          	jalr	-668(ra) # 80001584 <sleep>
  while (lk->locked) {
    80003828:	409c                	lw	a5,0(s1)
    8000382a:	fbed                	bnez	a5,8000381c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000382c:	4785                	li	a5,1
    8000382e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003830:	ffffd097          	auipc	ra,0xffffd
    80003834:	61e080e7          	jalr	1566(ra) # 80000e4e <myproc>
    80003838:	5d1c                	lw	a5,56(a0)
    8000383a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000383c:	854a                	mv	a0,s2
    8000383e:	00003097          	auipc	ra,0x3
    80003842:	964080e7          	jalr	-1692(ra) # 800061a2 <release>
}
    80003846:	60e2                	ld	ra,24(sp)
    80003848:	6442                	ld	s0,16(sp)
    8000384a:	64a2                	ld	s1,8(sp)
    8000384c:	6902                	ld	s2,0(sp)
    8000384e:	6105                	add	sp,sp,32
    80003850:	8082                	ret

0000000080003852 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003852:	1101                	add	sp,sp,-32
    80003854:	ec06                	sd	ra,24(sp)
    80003856:	e822                	sd	s0,16(sp)
    80003858:	e426                	sd	s1,8(sp)
    8000385a:	e04a                	sd	s2,0(sp)
    8000385c:	1000                	add	s0,sp,32
    8000385e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003860:	00850913          	add	s2,a0,8
    80003864:	854a                	mv	a0,s2
    80003866:	00003097          	auipc	ra,0x3
    8000386a:	888080e7          	jalr	-1912(ra) # 800060ee <acquire>
  lk->locked = 0;
    8000386e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003872:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003876:	8526                	mv	a0,s1
    80003878:	ffffe097          	auipc	ra,0xffffe
    8000387c:	d70080e7          	jalr	-656(ra) # 800015e8 <wakeup>
  release(&lk->lk);
    80003880:	854a                	mv	a0,s2
    80003882:	00003097          	auipc	ra,0x3
    80003886:	920080e7          	jalr	-1760(ra) # 800061a2 <release>
}
    8000388a:	60e2                	ld	ra,24(sp)
    8000388c:	6442                	ld	s0,16(sp)
    8000388e:	64a2                	ld	s1,8(sp)
    80003890:	6902                	ld	s2,0(sp)
    80003892:	6105                	add	sp,sp,32
    80003894:	8082                	ret

0000000080003896 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003896:	7179                	add	sp,sp,-48
    80003898:	f406                	sd	ra,40(sp)
    8000389a:	f022                	sd	s0,32(sp)
    8000389c:	ec26                	sd	s1,24(sp)
    8000389e:	e84a                	sd	s2,16(sp)
    800038a0:	e44e                	sd	s3,8(sp)
    800038a2:	1800                	add	s0,sp,48
    800038a4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038a6:	00850913          	add	s2,a0,8
    800038aa:	854a                	mv	a0,s2
    800038ac:	00003097          	auipc	ra,0x3
    800038b0:	842080e7          	jalr	-1982(ra) # 800060ee <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038b4:	409c                	lw	a5,0(s1)
    800038b6:	ef99                	bnez	a5,800038d4 <holdingsleep+0x3e>
    800038b8:	4481                	li	s1,0
  release(&lk->lk);
    800038ba:	854a                	mv	a0,s2
    800038bc:	00003097          	auipc	ra,0x3
    800038c0:	8e6080e7          	jalr	-1818(ra) # 800061a2 <release>
  return r;
}
    800038c4:	8526                	mv	a0,s1
    800038c6:	70a2                	ld	ra,40(sp)
    800038c8:	7402                	ld	s0,32(sp)
    800038ca:	64e2                	ld	s1,24(sp)
    800038cc:	6942                	ld	s2,16(sp)
    800038ce:	69a2                	ld	s3,8(sp)
    800038d0:	6145                	add	sp,sp,48
    800038d2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038d4:	0284a983          	lw	s3,40(s1)
    800038d8:	ffffd097          	auipc	ra,0xffffd
    800038dc:	576080e7          	jalr	1398(ra) # 80000e4e <myproc>
    800038e0:	5d04                	lw	s1,56(a0)
    800038e2:	413484b3          	sub	s1,s1,s3
    800038e6:	0014b493          	seqz	s1,s1
    800038ea:	bfc1                	j	800038ba <holdingsleep+0x24>

00000000800038ec <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038ec:	1141                	add	sp,sp,-16
    800038ee:	e406                	sd	ra,8(sp)
    800038f0:	e022                	sd	s0,0(sp)
    800038f2:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038f4:	00005597          	auipc	a1,0x5
    800038f8:	d5c58593          	add	a1,a1,-676 # 80008650 <syscalls+0x280>
    800038fc:	00015517          	auipc	a0,0x15
    80003900:	34c50513          	add	a0,a0,844 # 80018c48 <ftable>
    80003904:	00002097          	auipc	ra,0x2
    80003908:	75a080e7          	jalr	1882(ra) # 8000605e <initlock>
}
    8000390c:	60a2                	ld	ra,8(sp)
    8000390e:	6402                	ld	s0,0(sp)
    80003910:	0141                	add	sp,sp,16
    80003912:	8082                	ret

0000000080003914 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003914:	1101                	add	sp,sp,-32
    80003916:	ec06                	sd	ra,24(sp)
    80003918:	e822                	sd	s0,16(sp)
    8000391a:	e426                	sd	s1,8(sp)
    8000391c:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000391e:	00015517          	auipc	a0,0x15
    80003922:	32a50513          	add	a0,a0,810 # 80018c48 <ftable>
    80003926:	00002097          	auipc	ra,0x2
    8000392a:	7c8080e7          	jalr	1992(ra) # 800060ee <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000392e:	00015497          	auipc	s1,0x15
    80003932:	33248493          	add	s1,s1,818 # 80018c60 <ftable+0x18>
    80003936:	00016717          	auipc	a4,0x16
    8000393a:	2ca70713          	add	a4,a4,714 # 80019c00 <disk>
    if(f->ref == 0){
    8000393e:	40dc                	lw	a5,4(s1)
    80003940:	cf99                	beqz	a5,8000395e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003942:	02848493          	add	s1,s1,40
    80003946:	fee49ce3          	bne	s1,a4,8000393e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000394a:	00015517          	auipc	a0,0x15
    8000394e:	2fe50513          	add	a0,a0,766 # 80018c48 <ftable>
    80003952:	00003097          	auipc	ra,0x3
    80003956:	850080e7          	jalr	-1968(ra) # 800061a2 <release>
  return 0;
    8000395a:	4481                	li	s1,0
    8000395c:	a819                	j	80003972 <filealloc+0x5e>
      f->ref = 1;
    8000395e:	4785                	li	a5,1
    80003960:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003962:	00015517          	auipc	a0,0x15
    80003966:	2e650513          	add	a0,a0,742 # 80018c48 <ftable>
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	838080e7          	jalr	-1992(ra) # 800061a2 <release>
}
    80003972:	8526                	mv	a0,s1
    80003974:	60e2                	ld	ra,24(sp)
    80003976:	6442                	ld	s0,16(sp)
    80003978:	64a2                	ld	s1,8(sp)
    8000397a:	6105                	add	sp,sp,32
    8000397c:	8082                	ret

000000008000397e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000397e:	1101                	add	sp,sp,-32
    80003980:	ec06                	sd	ra,24(sp)
    80003982:	e822                	sd	s0,16(sp)
    80003984:	e426                	sd	s1,8(sp)
    80003986:	1000                	add	s0,sp,32
    80003988:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000398a:	00015517          	auipc	a0,0x15
    8000398e:	2be50513          	add	a0,a0,702 # 80018c48 <ftable>
    80003992:	00002097          	auipc	ra,0x2
    80003996:	75c080e7          	jalr	1884(ra) # 800060ee <acquire>
  if(f->ref < 1)
    8000399a:	40dc                	lw	a5,4(s1)
    8000399c:	02f05263          	blez	a5,800039c0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039a0:	2785                	addw	a5,a5,1
    800039a2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039a4:	00015517          	auipc	a0,0x15
    800039a8:	2a450513          	add	a0,a0,676 # 80018c48 <ftable>
    800039ac:	00002097          	auipc	ra,0x2
    800039b0:	7f6080e7          	jalr	2038(ra) # 800061a2 <release>
  return f;
}
    800039b4:	8526                	mv	a0,s1
    800039b6:	60e2                	ld	ra,24(sp)
    800039b8:	6442                	ld	s0,16(sp)
    800039ba:	64a2                	ld	s1,8(sp)
    800039bc:	6105                	add	sp,sp,32
    800039be:	8082                	ret
    panic("filedup");
    800039c0:	00005517          	auipc	a0,0x5
    800039c4:	c9850513          	add	a0,a0,-872 # 80008658 <syscalls+0x288>
    800039c8:	00002097          	auipc	ra,0x2
    800039cc:	1ee080e7          	jalr	494(ra) # 80005bb6 <panic>

00000000800039d0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039d0:	7139                	add	sp,sp,-64
    800039d2:	fc06                	sd	ra,56(sp)
    800039d4:	f822                	sd	s0,48(sp)
    800039d6:	f426                	sd	s1,40(sp)
    800039d8:	f04a                	sd	s2,32(sp)
    800039da:	ec4e                	sd	s3,24(sp)
    800039dc:	e852                	sd	s4,16(sp)
    800039de:	e456                	sd	s5,8(sp)
    800039e0:	0080                	add	s0,sp,64
    800039e2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039e4:	00015517          	auipc	a0,0x15
    800039e8:	26450513          	add	a0,a0,612 # 80018c48 <ftable>
    800039ec:	00002097          	auipc	ra,0x2
    800039f0:	702080e7          	jalr	1794(ra) # 800060ee <acquire>
  if(f->ref < 1)
    800039f4:	40dc                	lw	a5,4(s1)
    800039f6:	06f05163          	blez	a5,80003a58 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039fa:	37fd                	addw	a5,a5,-1
    800039fc:	0007871b          	sext.w	a4,a5
    80003a00:	c0dc                	sw	a5,4(s1)
    80003a02:	06e04363          	bgtz	a4,80003a68 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a06:	0004a903          	lw	s2,0(s1)
    80003a0a:	0094ca83          	lbu	s5,9(s1)
    80003a0e:	0104ba03          	ld	s4,16(s1)
    80003a12:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a16:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a1a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a1e:	00015517          	auipc	a0,0x15
    80003a22:	22a50513          	add	a0,a0,554 # 80018c48 <ftable>
    80003a26:	00002097          	auipc	ra,0x2
    80003a2a:	77c080e7          	jalr	1916(ra) # 800061a2 <release>

  if(ff.type == FD_PIPE){
    80003a2e:	4785                	li	a5,1
    80003a30:	04f90d63          	beq	s2,a5,80003a8a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a34:	3979                	addw	s2,s2,-2
    80003a36:	4785                	li	a5,1
    80003a38:	0527e063          	bltu	a5,s2,80003a78 <fileclose+0xa8>
    begin_op();
    80003a3c:	00000097          	auipc	ra,0x0
    80003a40:	ad0080e7          	jalr	-1328(ra) # 8000350c <begin_op>
    iput(ff.ip);
    80003a44:	854e                	mv	a0,s3
    80003a46:	fffff097          	auipc	ra,0xfffff
    80003a4a:	2da080e7          	jalr	730(ra) # 80002d20 <iput>
    end_op();
    80003a4e:	00000097          	auipc	ra,0x0
    80003a52:	b38080e7          	jalr	-1224(ra) # 80003586 <end_op>
    80003a56:	a00d                	j	80003a78 <fileclose+0xa8>
    panic("fileclose");
    80003a58:	00005517          	auipc	a0,0x5
    80003a5c:	c0850513          	add	a0,a0,-1016 # 80008660 <syscalls+0x290>
    80003a60:	00002097          	auipc	ra,0x2
    80003a64:	156080e7          	jalr	342(ra) # 80005bb6 <panic>
    release(&ftable.lock);
    80003a68:	00015517          	auipc	a0,0x15
    80003a6c:	1e050513          	add	a0,a0,480 # 80018c48 <ftable>
    80003a70:	00002097          	auipc	ra,0x2
    80003a74:	732080e7          	jalr	1842(ra) # 800061a2 <release>
  }
}
    80003a78:	70e2                	ld	ra,56(sp)
    80003a7a:	7442                	ld	s0,48(sp)
    80003a7c:	74a2                	ld	s1,40(sp)
    80003a7e:	7902                	ld	s2,32(sp)
    80003a80:	69e2                	ld	s3,24(sp)
    80003a82:	6a42                	ld	s4,16(sp)
    80003a84:	6aa2                	ld	s5,8(sp)
    80003a86:	6121                	add	sp,sp,64
    80003a88:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a8a:	85d6                	mv	a1,s5
    80003a8c:	8552                	mv	a0,s4
    80003a8e:	00000097          	auipc	ra,0x0
    80003a92:	348080e7          	jalr	840(ra) # 80003dd6 <pipeclose>
    80003a96:	b7cd                	j	80003a78 <fileclose+0xa8>

0000000080003a98 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a98:	715d                	add	sp,sp,-80
    80003a9a:	e486                	sd	ra,72(sp)
    80003a9c:	e0a2                	sd	s0,64(sp)
    80003a9e:	fc26                	sd	s1,56(sp)
    80003aa0:	f84a                	sd	s2,48(sp)
    80003aa2:	f44e                	sd	s3,40(sp)
    80003aa4:	0880                	add	s0,sp,80
    80003aa6:	84aa                	mv	s1,a0
    80003aa8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aaa:	ffffd097          	auipc	ra,0xffffd
    80003aae:	3a4080e7          	jalr	932(ra) # 80000e4e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ab2:	409c                	lw	a5,0(s1)
    80003ab4:	37f9                	addw	a5,a5,-2
    80003ab6:	4705                	li	a4,1
    80003ab8:	04f76763          	bltu	a4,a5,80003b06 <filestat+0x6e>
    80003abc:	892a                	mv	s2,a0
    ilock(f->ip);
    80003abe:	6c88                	ld	a0,24(s1)
    80003ac0:	fffff097          	auipc	ra,0xfffff
    80003ac4:	0a6080e7          	jalr	166(ra) # 80002b66 <ilock>
    stati(f->ip, &st);
    80003ac8:	fb840593          	add	a1,s0,-72
    80003acc:	6c88                	ld	a0,24(s1)
    80003ace:	fffff097          	auipc	ra,0xfffff
    80003ad2:	322080e7          	jalr	802(ra) # 80002df0 <stati>
    iunlock(f->ip);
    80003ad6:	6c88                	ld	a0,24(s1)
    80003ad8:	fffff097          	auipc	ra,0xfffff
    80003adc:	150080e7          	jalr	336(ra) # 80002c28 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ae0:	46e1                	li	a3,24
    80003ae2:	fb840613          	add	a2,s0,-72
    80003ae6:	85ce                	mv	a1,s3
    80003ae8:	05893503          	ld	a0,88(s2)
    80003aec:	ffffd097          	auipc	ra,0xffffd
    80003af0:	026080e7          	jalr	38(ra) # 80000b12 <copyout>
    80003af4:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003af8:	60a6                	ld	ra,72(sp)
    80003afa:	6406                	ld	s0,64(sp)
    80003afc:	74e2                	ld	s1,56(sp)
    80003afe:	7942                	ld	s2,48(sp)
    80003b00:	79a2                	ld	s3,40(sp)
    80003b02:	6161                	add	sp,sp,80
    80003b04:	8082                	ret
  return -1;
    80003b06:	557d                	li	a0,-1
    80003b08:	bfc5                	j	80003af8 <filestat+0x60>

0000000080003b0a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b0a:	7179                	add	sp,sp,-48
    80003b0c:	f406                	sd	ra,40(sp)
    80003b0e:	f022                	sd	s0,32(sp)
    80003b10:	ec26                	sd	s1,24(sp)
    80003b12:	e84a                	sd	s2,16(sp)
    80003b14:	e44e                	sd	s3,8(sp)
    80003b16:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b18:	00854783          	lbu	a5,8(a0)
    80003b1c:	c3d5                	beqz	a5,80003bc0 <fileread+0xb6>
    80003b1e:	84aa                	mv	s1,a0
    80003b20:	89ae                	mv	s3,a1
    80003b22:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b24:	411c                	lw	a5,0(a0)
    80003b26:	4705                	li	a4,1
    80003b28:	04e78963          	beq	a5,a4,80003b7a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b2c:	470d                	li	a4,3
    80003b2e:	04e78d63          	beq	a5,a4,80003b88 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b32:	4709                	li	a4,2
    80003b34:	06e79e63          	bne	a5,a4,80003bb0 <fileread+0xa6>
    ilock(f->ip);
    80003b38:	6d08                	ld	a0,24(a0)
    80003b3a:	fffff097          	auipc	ra,0xfffff
    80003b3e:	02c080e7          	jalr	44(ra) # 80002b66 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b42:	874a                	mv	a4,s2
    80003b44:	5094                	lw	a3,32(s1)
    80003b46:	864e                	mv	a2,s3
    80003b48:	4585                	li	a1,1
    80003b4a:	6c88                	ld	a0,24(s1)
    80003b4c:	fffff097          	auipc	ra,0xfffff
    80003b50:	2ce080e7          	jalr	718(ra) # 80002e1a <readi>
    80003b54:	892a                	mv	s2,a0
    80003b56:	00a05563          	blez	a0,80003b60 <fileread+0x56>
      f->off += r;
    80003b5a:	509c                	lw	a5,32(s1)
    80003b5c:	9fa9                	addw	a5,a5,a0
    80003b5e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b60:	6c88                	ld	a0,24(s1)
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	0c6080e7          	jalr	198(ra) # 80002c28 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b6a:	854a                	mv	a0,s2
    80003b6c:	70a2                	ld	ra,40(sp)
    80003b6e:	7402                	ld	s0,32(sp)
    80003b70:	64e2                	ld	s1,24(sp)
    80003b72:	6942                	ld	s2,16(sp)
    80003b74:	69a2                	ld	s3,8(sp)
    80003b76:	6145                	add	sp,sp,48
    80003b78:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b7a:	6908                	ld	a0,16(a0)
    80003b7c:	00000097          	auipc	ra,0x0
    80003b80:	3c2080e7          	jalr	962(ra) # 80003f3e <piperead>
    80003b84:	892a                	mv	s2,a0
    80003b86:	b7d5                	j	80003b6a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b88:	02451783          	lh	a5,36(a0)
    80003b8c:	03079693          	sll	a3,a5,0x30
    80003b90:	92c1                	srl	a3,a3,0x30
    80003b92:	4725                	li	a4,9
    80003b94:	02d76863          	bltu	a4,a3,80003bc4 <fileread+0xba>
    80003b98:	0792                	sll	a5,a5,0x4
    80003b9a:	00015717          	auipc	a4,0x15
    80003b9e:	00e70713          	add	a4,a4,14 # 80018ba8 <devsw>
    80003ba2:	97ba                	add	a5,a5,a4
    80003ba4:	639c                	ld	a5,0(a5)
    80003ba6:	c38d                	beqz	a5,80003bc8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ba8:	4505                	li	a0,1
    80003baa:	9782                	jalr	a5
    80003bac:	892a                	mv	s2,a0
    80003bae:	bf75                	j	80003b6a <fileread+0x60>
    panic("fileread");
    80003bb0:	00005517          	auipc	a0,0x5
    80003bb4:	ac050513          	add	a0,a0,-1344 # 80008670 <syscalls+0x2a0>
    80003bb8:	00002097          	auipc	ra,0x2
    80003bbc:	ffe080e7          	jalr	-2(ra) # 80005bb6 <panic>
    return -1;
    80003bc0:	597d                	li	s2,-1
    80003bc2:	b765                	j	80003b6a <fileread+0x60>
      return -1;
    80003bc4:	597d                	li	s2,-1
    80003bc6:	b755                	j	80003b6a <fileread+0x60>
    80003bc8:	597d                	li	s2,-1
    80003bca:	b745                	j	80003b6a <fileread+0x60>

0000000080003bcc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003bcc:	00954783          	lbu	a5,9(a0)
    80003bd0:	10078e63          	beqz	a5,80003cec <filewrite+0x120>
{
    80003bd4:	715d                	add	sp,sp,-80
    80003bd6:	e486                	sd	ra,72(sp)
    80003bd8:	e0a2                	sd	s0,64(sp)
    80003bda:	fc26                	sd	s1,56(sp)
    80003bdc:	f84a                	sd	s2,48(sp)
    80003bde:	f44e                	sd	s3,40(sp)
    80003be0:	f052                	sd	s4,32(sp)
    80003be2:	ec56                	sd	s5,24(sp)
    80003be4:	e85a                	sd	s6,16(sp)
    80003be6:	e45e                	sd	s7,8(sp)
    80003be8:	e062                	sd	s8,0(sp)
    80003bea:	0880                	add	s0,sp,80
    80003bec:	892a                	mv	s2,a0
    80003bee:	8b2e                	mv	s6,a1
    80003bf0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bf2:	411c                	lw	a5,0(a0)
    80003bf4:	4705                	li	a4,1
    80003bf6:	02e78263          	beq	a5,a4,80003c1a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bfa:	470d                	li	a4,3
    80003bfc:	02e78563          	beq	a5,a4,80003c26 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c00:	4709                	li	a4,2
    80003c02:	0ce79d63          	bne	a5,a4,80003cdc <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c06:	0ac05b63          	blez	a2,80003cbc <filewrite+0xf0>
    int i = 0;
    80003c0a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003c0c:	6b85                	lui	s7,0x1
    80003c0e:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c12:	6c05                	lui	s8,0x1
    80003c14:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c18:	a851                	j	80003cac <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003c1a:	6908                	ld	a0,16(a0)
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	22a080e7          	jalr	554(ra) # 80003e46 <pipewrite>
    80003c24:	a045                	j	80003cc4 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c26:	02451783          	lh	a5,36(a0)
    80003c2a:	03079693          	sll	a3,a5,0x30
    80003c2e:	92c1                	srl	a3,a3,0x30
    80003c30:	4725                	li	a4,9
    80003c32:	0ad76f63          	bltu	a4,a3,80003cf0 <filewrite+0x124>
    80003c36:	0792                	sll	a5,a5,0x4
    80003c38:	00015717          	auipc	a4,0x15
    80003c3c:	f7070713          	add	a4,a4,-144 # 80018ba8 <devsw>
    80003c40:	97ba                	add	a5,a5,a4
    80003c42:	679c                	ld	a5,8(a5)
    80003c44:	cbc5                	beqz	a5,80003cf4 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003c46:	4505                	li	a0,1
    80003c48:	9782                	jalr	a5
    80003c4a:	a8ad                	j	80003cc4 <filewrite+0xf8>
      if(n1 > max)
    80003c4c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	8bc080e7          	jalr	-1860(ra) # 8000350c <begin_op>
      ilock(f->ip);
    80003c58:	01893503          	ld	a0,24(s2)
    80003c5c:	fffff097          	auipc	ra,0xfffff
    80003c60:	f0a080e7          	jalr	-246(ra) # 80002b66 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c64:	8756                	mv	a4,s5
    80003c66:	02092683          	lw	a3,32(s2)
    80003c6a:	01698633          	add	a2,s3,s6
    80003c6e:	4585                	li	a1,1
    80003c70:	01893503          	ld	a0,24(s2)
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	29e080e7          	jalr	670(ra) # 80002f12 <writei>
    80003c7c:	84aa                	mv	s1,a0
    80003c7e:	00a05763          	blez	a0,80003c8c <filewrite+0xc0>
        f->off += r;
    80003c82:	02092783          	lw	a5,32(s2)
    80003c86:	9fa9                	addw	a5,a5,a0
    80003c88:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c8c:	01893503          	ld	a0,24(s2)
    80003c90:	fffff097          	auipc	ra,0xfffff
    80003c94:	f98080e7          	jalr	-104(ra) # 80002c28 <iunlock>
      end_op();
    80003c98:	00000097          	auipc	ra,0x0
    80003c9c:	8ee080e7          	jalr	-1810(ra) # 80003586 <end_op>

      if(r != n1){
    80003ca0:	009a9f63          	bne	s5,s1,80003cbe <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003ca4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ca8:	0149db63          	bge	s3,s4,80003cbe <filewrite+0xf2>
      int n1 = n - i;
    80003cac:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003cb0:	0004879b          	sext.w	a5,s1
    80003cb4:	f8fbdce3          	bge	s7,a5,80003c4c <filewrite+0x80>
    80003cb8:	84e2                	mv	s1,s8
    80003cba:	bf49                	j	80003c4c <filewrite+0x80>
    int i = 0;
    80003cbc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003cbe:	033a1d63          	bne	s4,s3,80003cf8 <filewrite+0x12c>
    80003cc2:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003cc4:	60a6                	ld	ra,72(sp)
    80003cc6:	6406                	ld	s0,64(sp)
    80003cc8:	74e2                	ld	s1,56(sp)
    80003cca:	7942                	ld	s2,48(sp)
    80003ccc:	79a2                	ld	s3,40(sp)
    80003cce:	7a02                	ld	s4,32(sp)
    80003cd0:	6ae2                	ld	s5,24(sp)
    80003cd2:	6b42                	ld	s6,16(sp)
    80003cd4:	6ba2                	ld	s7,8(sp)
    80003cd6:	6c02                	ld	s8,0(sp)
    80003cd8:	6161                	add	sp,sp,80
    80003cda:	8082                	ret
    panic("filewrite");
    80003cdc:	00005517          	auipc	a0,0x5
    80003ce0:	9a450513          	add	a0,a0,-1628 # 80008680 <syscalls+0x2b0>
    80003ce4:	00002097          	auipc	ra,0x2
    80003ce8:	ed2080e7          	jalr	-302(ra) # 80005bb6 <panic>
    return -1;
    80003cec:	557d                	li	a0,-1
}
    80003cee:	8082                	ret
      return -1;
    80003cf0:	557d                	li	a0,-1
    80003cf2:	bfc9                	j	80003cc4 <filewrite+0xf8>
    80003cf4:	557d                	li	a0,-1
    80003cf6:	b7f9                	j	80003cc4 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003cf8:	557d                	li	a0,-1
    80003cfa:	b7e9                	j	80003cc4 <filewrite+0xf8>

0000000080003cfc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cfc:	7179                	add	sp,sp,-48
    80003cfe:	f406                	sd	ra,40(sp)
    80003d00:	f022                	sd	s0,32(sp)
    80003d02:	ec26                	sd	s1,24(sp)
    80003d04:	e84a                	sd	s2,16(sp)
    80003d06:	e44e                	sd	s3,8(sp)
    80003d08:	e052                	sd	s4,0(sp)
    80003d0a:	1800                	add	s0,sp,48
    80003d0c:	84aa                	mv	s1,a0
    80003d0e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d10:	0005b023          	sd	zero,0(a1)
    80003d14:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d18:	00000097          	auipc	ra,0x0
    80003d1c:	bfc080e7          	jalr	-1028(ra) # 80003914 <filealloc>
    80003d20:	e088                	sd	a0,0(s1)
    80003d22:	c551                	beqz	a0,80003dae <pipealloc+0xb2>
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	bf0080e7          	jalr	-1040(ra) # 80003914 <filealloc>
    80003d2c:	00aa3023          	sd	a0,0(s4)
    80003d30:	c92d                	beqz	a0,80003da2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d32:	ffffc097          	auipc	ra,0xffffc
    80003d36:	3e8080e7          	jalr	1000(ra) # 8000011a <kalloc>
    80003d3a:	892a                	mv	s2,a0
    80003d3c:	c125                	beqz	a0,80003d9c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d3e:	4985                	li	s3,1
    80003d40:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d44:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d48:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d4c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d50:	00005597          	auipc	a1,0x5
    80003d54:	94058593          	add	a1,a1,-1728 # 80008690 <syscalls+0x2c0>
    80003d58:	00002097          	auipc	ra,0x2
    80003d5c:	306080e7          	jalr	774(ra) # 8000605e <initlock>
  (*f0)->type = FD_PIPE;
    80003d60:	609c                	ld	a5,0(s1)
    80003d62:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d66:	609c                	ld	a5,0(s1)
    80003d68:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d6c:	609c                	ld	a5,0(s1)
    80003d6e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d72:	609c                	ld	a5,0(s1)
    80003d74:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d78:	000a3783          	ld	a5,0(s4)
    80003d7c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d80:	000a3783          	ld	a5,0(s4)
    80003d84:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d88:	000a3783          	ld	a5,0(s4)
    80003d8c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d90:	000a3783          	ld	a5,0(s4)
    80003d94:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d98:	4501                	li	a0,0
    80003d9a:	a025                	j	80003dc2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d9c:	6088                	ld	a0,0(s1)
    80003d9e:	e501                	bnez	a0,80003da6 <pipealloc+0xaa>
    80003da0:	a039                	j	80003dae <pipealloc+0xb2>
    80003da2:	6088                	ld	a0,0(s1)
    80003da4:	c51d                	beqz	a0,80003dd2 <pipealloc+0xd6>
    fileclose(*f0);
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	c2a080e7          	jalr	-982(ra) # 800039d0 <fileclose>
  if(*f1)
    80003dae:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003db2:	557d                	li	a0,-1
  if(*f1)
    80003db4:	c799                	beqz	a5,80003dc2 <pipealloc+0xc6>
    fileclose(*f1);
    80003db6:	853e                	mv	a0,a5
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	c18080e7          	jalr	-1000(ra) # 800039d0 <fileclose>
  return -1;
    80003dc0:	557d                	li	a0,-1
}
    80003dc2:	70a2                	ld	ra,40(sp)
    80003dc4:	7402                	ld	s0,32(sp)
    80003dc6:	64e2                	ld	s1,24(sp)
    80003dc8:	6942                	ld	s2,16(sp)
    80003dca:	69a2                	ld	s3,8(sp)
    80003dcc:	6a02                	ld	s4,0(sp)
    80003dce:	6145                	add	sp,sp,48
    80003dd0:	8082                	ret
  return -1;
    80003dd2:	557d                	li	a0,-1
    80003dd4:	b7fd                	j	80003dc2 <pipealloc+0xc6>

0000000080003dd6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dd6:	1101                	add	sp,sp,-32
    80003dd8:	ec06                	sd	ra,24(sp)
    80003dda:	e822                	sd	s0,16(sp)
    80003ddc:	e426                	sd	s1,8(sp)
    80003dde:	e04a                	sd	s2,0(sp)
    80003de0:	1000                	add	s0,sp,32
    80003de2:	84aa                	mv	s1,a0
    80003de4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003de6:	00002097          	auipc	ra,0x2
    80003dea:	308080e7          	jalr	776(ra) # 800060ee <acquire>
  if(writable){
    80003dee:	02090d63          	beqz	s2,80003e28 <pipeclose+0x52>
    pi->writeopen = 0;
    80003df2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003df6:	21848513          	add	a0,s1,536
    80003dfa:	ffffd097          	auipc	ra,0xffffd
    80003dfe:	7ee080e7          	jalr	2030(ra) # 800015e8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e02:	2204b783          	ld	a5,544(s1)
    80003e06:	eb95                	bnez	a5,80003e3a <pipeclose+0x64>
    release(&pi->lock);
    80003e08:	8526                	mv	a0,s1
    80003e0a:	00002097          	auipc	ra,0x2
    80003e0e:	398080e7          	jalr	920(ra) # 800061a2 <release>
    kfree((char*)pi);
    80003e12:	8526                	mv	a0,s1
    80003e14:	ffffc097          	auipc	ra,0xffffc
    80003e18:	208080e7          	jalr	520(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e1c:	60e2                	ld	ra,24(sp)
    80003e1e:	6442                	ld	s0,16(sp)
    80003e20:	64a2                	ld	s1,8(sp)
    80003e22:	6902                	ld	s2,0(sp)
    80003e24:	6105                	add	sp,sp,32
    80003e26:	8082                	ret
    pi->readopen = 0;
    80003e28:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e2c:	21c48513          	add	a0,s1,540
    80003e30:	ffffd097          	auipc	ra,0xffffd
    80003e34:	7b8080e7          	jalr	1976(ra) # 800015e8 <wakeup>
    80003e38:	b7e9                	j	80003e02 <pipeclose+0x2c>
    release(&pi->lock);
    80003e3a:	8526                	mv	a0,s1
    80003e3c:	00002097          	auipc	ra,0x2
    80003e40:	366080e7          	jalr	870(ra) # 800061a2 <release>
}
    80003e44:	bfe1                	j	80003e1c <pipeclose+0x46>

0000000080003e46 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e46:	711d                	add	sp,sp,-96
    80003e48:	ec86                	sd	ra,88(sp)
    80003e4a:	e8a2                	sd	s0,80(sp)
    80003e4c:	e4a6                	sd	s1,72(sp)
    80003e4e:	e0ca                	sd	s2,64(sp)
    80003e50:	fc4e                	sd	s3,56(sp)
    80003e52:	f852                	sd	s4,48(sp)
    80003e54:	f456                	sd	s5,40(sp)
    80003e56:	f05a                	sd	s6,32(sp)
    80003e58:	ec5e                	sd	s7,24(sp)
    80003e5a:	e862                	sd	s8,16(sp)
    80003e5c:	1080                	add	s0,sp,96
    80003e5e:	84aa                	mv	s1,a0
    80003e60:	8aae                	mv	s5,a1
    80003e62:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e64:	ffffd097          	auipc	ra,0xffffd
    80003e68:	fea080e7          	jalr	-22(ra) # 80000e4e <myproc>
    80003e6c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e6e:	8526                	mv	a0,s1
    80003e70:	00002097          	auipc	ra,0x2
    80003e74:	27e080e7          	jalr	638(ra) # 800060ee <acquire>
  while(i < n){
    80003e78:	0b405663          	blez	s4,80003f24 <pipewrite+0xde>
  int i = 0;
    80003e7c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e7e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e80:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e84:	21c48b93          	add	s7,s1,540
    80003e88:	a089                	j	80003eca <pipewrite+0x84>
      release(&pi->lock);
    80003e8a:	8526                	mv	a0,s1
    80003e8c:	00002097          	auipc	ra,0x2
    80003e90:	316080e7          	jalr	790(ra) # 800061a2 <release>
      return -1;
    80003e94:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e96:	854a                	mv	a0,s2
    80003e98:	60e6                	ld	ra,88(sp)
    80003e9a:	6446                	ld	s0,80(sp)
    80003e9c:	64a6                	ld	s1,72(sp)
    80003e9e:	6906                	ld	s2,64(sp)
    80003ea0:	79e2                	ld	s3,56(sp)
    80003ea2:	7a42                	ld	s4,48(sp)
    80003ea4:	7aa2                	ld	s5,40(sp)
    80003ea6:	7b02                	ld	s6,32(sp)
    80003ea8:	6be2                	ld	s7,24(sp)
    80003eaa:	6c42                	ld	s8,16(sp)
    80003eac:	6125                	add	sp,sp,96
    80003eae:	8082                	ret
      wakeup(&pi->nread);
    80003eb0:	8562                	mv	a0,s8
    80003eb2:	ffffd097          	auipc	ra,0xffffd
    80003eb6:	736080e7          	jalr	1846(ra) # 800015e8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003eba:	85a6                	mv	a1,s1
    80003ebc:	855e                	mv	a0,s7
    80003ebe:	ffffd097          	auipc	ra,0xffffd
    80003ec2:	6c6080e7          	jalr	1734(ra) # 80001584 <sleep>
  while(i < n){
    80003ec6:	07495063          	bge	s2,s4,80003f26 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003eca:	2204a783          	lw	a5,544(s1)
    80003ece:	dfd5                	beqz	a5,80003e8a <pipewrite+0x44>
    80003ed0:	854e                	mv	a0,s3
    80003ed2:	ffffe097          	auipc	ra,0xffffe
    80003ed6:	95a080e7          	jalr	-1702(ra) # 8000182c <killed>
    80003eda:	f945                	bnez	a0,80003e8a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003edc:	2184a783          	lw	a5,536(s1)
    80003ee0:	21c4a703          	lw	a4,540(s1)
    80003ee4:	2007879b          	addw	a5,a5,512
    80003ee8:	fcf704e3          	beq	a4,a5,80003eb0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eec:	4685                	li	a3,1
    80003eee:	01590633          	add	a2,s2,s5
    80003ef2:	faf40593          	add	a1,s0,-81
    80003ef6:	0589b503          	ld	a0,88(s3)
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	ca4080e7          	jalr	-860(ra) # 80000b9e <copyin>
    80003f02:	03650263          	beq	a0,s6,80003f26 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f06:	21c4a783          	lw	a5,540(s1)
    80003f0a:	0017871b          	addw	a4,a5,1
    80003f0e:	20e4ae23          	sw	a4,540(s1)
    80003f12:	1ff7f793          	and	a5,a5,511
    80003f16:	97a6                	add	a5,a5,s1
    80003f18:	faf44703          	lbu	a4,-81(s0)
    80003f1c:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f20:	2905                	addw	s2,s2,1
    80003f22:	b755                	j	80003ec6 <pipewrite+0x80>
  int i = 0;
    80003f24:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f26:	21848513          	add	a0,s1,536
    80003f2a:	ffffd097          	auipc	ra,0xffffd
    80003f2e:	6be080e7          	jalr	1726(ra) # 800015e8 <wakeup>
  release(&pi->lock);
    80003f32:	8526                	mv	a0,s1
    80003f34:	00002097          	auipc	ra,0x2
    80003f38:	26e080e7          	jalr	622(ra) # 800061a2 <release>
  return i;
    80003f3c:	bfa9                	j	80003e96 <pipewrite+0x50>

0000000080003f3e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f3e:	715d                	add	sp,sp,-80
    80003f40:	e486                	sd	ra,72(sp)
    80003f42:	e0a2                	sd	s0,64(sp)
    80003f44:	fc26                	sd	s1,56(sp)
    80003f46:	f84a                	sd	s2,48(sp)
    80003f48:	f44e                	sd	s3,40(sp)
    80003f4a:	f052                	sd	s4,32(sp)
    80003f4c:	ec56                	sd	s5,24(sp)
    80003f4e:	e85a                	sd	s6,16(sp)
    80003f50:	0880                	add	s0,sp,80
    80003f52:	84aa                	mv	s1,a0
    80003f54:	892e                	mv	s2,a1
    80003f56:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	ef6080e7          	jalr	-266(ra) # 80000e4e <myproc>
    80003f60:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f62:	8526                	mv	a0,s1
    80003f64:	00002097          	auipc	ra,0x2
    80003f68:	18a080e7          	jalr	394(ra) # 800060ee <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f6c:	2184a703          	lw	a4,536(s1)
    80003f70:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f74:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f78:	02f71763          	bne	a4,a5,80003fa6 <piperead+0x68>
    80003f7c:	2244a783          	lw	a5,548(s1)
    80003f80:	c39d                	beqz	a5,80003fa6 <piperead+0x68>
    if(killed(pr)){
    80003f82:	8552                	mv	a0,s4
    80003f84:	ffffe097          	auipc	ra,0xffffe
    80003f88:	8a8080e7          	jalr	-1880(ra) # 8000182c <killed>
    80003f8c:	e949                	bnez	a0,8000401e <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f8e:	85a6                	mv	a1,s1
    80003f90:	854e                	mv	a0,s3
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	5f2080e7          	jalr	1522(ra) # 80001584 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f9a:	2184a703          	lw	a4,536(s1)
    80003f9e:	21c4a783          	lw	a5,540(s1)
    80003fa2:	fcf70de3          	beq	a4,a5,80003f7c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fa6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fa8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003faa:	05505463          	blez	s5,80003ff2 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003fae:	2184a783          	lw	a5,536(s1)
    80003fb2:	21c4a703          	lw	a4,540(s1)
    80003fb6:	02f70e63          	beq	a4,a5,80003ff2 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fba:	0017871b          	addw	a4,a5,1
    80003fbe:	20e4ac23          	sw	a4,536(s1)
    80003fc2:	1ff7f793          	and	a5,a5,511
    80003fc6:	97a6                	add	a5,a5,s1
    80003fc8:	0187c783          	lbu	a5,24(a5)
    80003fcc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fd0:	4685                	li	a3,1
    80003fd2:	fbf40613          	add	a2,s0,-65
    80003fd6:	85ca                	mv	a1,s2
    80003fd8:	058a3503          	ld	a0,88(s4)
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	b36080e7          	jalr	-1226(ra) # 80000b12 <copyout>
    80003fe4:	01650763          	beq	a0,s6,80003ff2 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fe8:	2985                	addw	s3,s3,1
    80003fea:	0905                	add	s2,s2,1
    80003fec:	fd3a91e3          	bne	s5,s3,80003fae <piperead+0x70>
    80003ff0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ff2:	21c48513          	add	a0,s1,540
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	5f2080e7          	jalr	1522(ra) # 800015e8 <wakeup>
  release(&pi->lock);
    80003ffe:	8526                	mv	a0,s1
    80004000:	00002097          	auipc	ra,0x2
    80004004:	1a2080e7          	jalr	418(ra) # 800061a2 <release>
  return i;
}
    80004008:	854e                	mv	a0,s3
    8000400a:	60a6                	ld	ra,72(sp)
    8000400c:	6406                	ld	s0,64(sp)
    8000400e:	74e2                	ld	s1,56(sp)
    80004010:	7942                	ld	s2,48(sp)
    80004012:	79a2                	ld	s3,40(sp)
    80004014:	7a02                	ld	s4,32(sp)
    80004016:	6ae2                	ld	s5,24(sp)
    80004018:	6b42                	ld	s6,16(sp)
    8000401a:	6161                	add	sp,sp,80
    8000401c:	8082                	ret
      release(&pi->lock);
    8000401e:	8526                	mv	a0,s1
    80004020:	00002097          	auipc	ra,0x2
    80004024:	182080e7          	jalr	386(ra) # 800061a2 <release>
      return -1;
    80004028:	59fd                	li	s3,-1
    8000402a:	bff9                	j	80004008 <piperead+0xca>

000000008000402c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000402c:	1141                	add	sp,sp,-16
    8000402e:	e422                	sd	s0,8(sp)
    80004030:	0800                	add	s0,sp,16
    80004032:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004034:	8905                	and	a0,a0,1
    80004036:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004038:	8b89                	and	a5,a5,2
    8000403a:	c399                	beqz	a5,80004040 <flags2perm+0x14>
      perm |= PTE_W;
    8000403c:	00456513          	or	a0,a0,4
    return perm;
}
    80004040:	6422                	ld	s0,8(sp)
    80004042:	0141                	add	sp,sp,16
    80004044:	8082                	ret

0000000080004046 <exec>:

int
exec(char *path, char **argv)
{
    80004046:	df010113          	add	sp,sp,-528
    8000404a:	20113423          	sd	ra,520(sp)
    8000404e:	20813023          	sd	s0,512(sp)
    80004052:	ffa6                	sd	s1,504(sp)
    80004054:	fbca                	sd	s2,496(sp)
    80004056:	f7ce                	sd	s3,488(sp)
    80004058:	f3d2                	sd	s4,480(sp)
    8000405a:	efd6                	sd	s5,472(sp)
    8000405c:	ebda                	sd	s6,464(sp)
    8000405e:	e7de                	sd	s7,456(sp)
    80004060:	e3e2                	sd	s8,448(sp)
    80004062:	ff66                	sd	s9,440(sp)
    80004064:	fb6a                	sd	s10,432(sp)
    80004066:	f76e                	sd	s11,424(sp)
    80004068:	0c00                	add	s0,sp,528
    8000406a:	892a                	mv	s2,a0
    8000406c:	dea43c23          	sd	a0,-520(s0)
    80004070:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004074:	ffffd097          	auipc	ra,0xffffd
    80004078:	dda080e7          	jalr	-550(ra) # 80000e4e <myproc>
    8000407c:	84aa                	mv	s1,a0

  begin_op();
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	48e080e7          	jalr	1166(ra) # 8000350c <begin_op>

  if((ip = namei(path)) == 0){
    80004086:	854a                	mv	a0,s2
    80004088:	fffff097          	auipc	ra,0xfffff
    8000408c:	284080e7          	jalr	644(ra) # 8000330c <namei>
    80004090:	c92d                	beqz	a0,80004102 <exec+0xbc>
    80004092:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004094:	fffff097          	auipc	ra,0xfffff
    80004098:	ad2080e7          	jalr	-1326(ra) # 80002b66 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000409c:	04000713          	li	a4,64
    800040a0:	4681                	li	a3,0
    800040a2:	e5040613          	add	a2,s0,-432
    800040a6:	4581                	li	a1,0
    800040a8:	8552                	mv	a0,s4
    800040aa:	fffff097          	auipc	ra,0xfffff
    800040ae:	d70080e7          	jalr	-656(ra) # 80002e1a <readi>
    800040b2:	04000793          	li	a5,64
    800040b6:	00f51a63          	bne	a0,a5,800040ca <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800040ba:	e5042703          	lw	a4,-432(s0)
    800040be:	464c47b7          	lui	a5,0x464c4
    800040c2:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040c6:	04f70463          	beq	a4,a5,8000410e <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040ca:	8552                	mv	a0,s4
    800040cc:	fffff097          	auipc	ra,0xfffff
    800040d0:	cfc080e7          	jalr	-772(ra) # 80002dc8 <iunlockput>
    end_op();
    800040d4:	fffff097          	auipc	ra,0xfffff
    800040d8:	4b2080e7          	jalr	1202(ra) # 80003586 <end_op>
  }
  return -1;
    800040dc:	557d                	li	a0,-1
}
    800040de:	20813083          	ld	ra,520(sp)
    800040e2:	20013403          	ld	s0,512(sp)
    800040e6:	74fe                	ld	s1,504(sp)
    800040e8:	795e                	ld	s2,496(sp)
    800040ea:	79be                	ld	s3,488(sp)
    800040ec:	7a1e                	ld	s4,480(sp)
    800040ee:	6afe                	ld	s5,472(sp)
    800040f0:	6b5e                	ld	s6,464(sp)
    800040f2:	6bbe                	ld	s7,456(sp)
    800040f4:	6c1e                	ld	s8,448(sp)
    800040f6:	7cfa                	ld	s9,440(sp)
    800040f8:	7d5a                	ld	s10,432(sp)
    800040fa:	7dba                	ld	s11,424(sp)
    800040fc:	21010113          	add	sp,sp,528
    80004100:	8082                	ret
    end_op();
    80004102:	fffff097          	auipc	ra,0xfffff
    80004106:	484080e7          	jalr	1156(ra) # 80003586 <end_op>
    return -1;
    8000410a:	557d                	li	a0,-1
    8000410c:	bfc9                	j	800040de <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000410e:	8526                	mv	a0,s1
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	e02080e7          	jalr	-510(ra) # 80000f12 <proc_pagetable>
    80004118:	8b2a                	mv	s6,a0
    8000411a:	d945                	beqz	a0,800040ca <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000411c:	e7042d03          	lw	s10,-400(s0)
    80004120:	e8845783          	lhu	a5,-376(s0)
    80004124:	10078463          	beqz	a5,8000422c <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004128:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000412a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000412c:	6c85                	lui	s9,0x1
    8000412e:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004132:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004136:	6a85                	lui	s5,0x1
    80004138:	a0b5                	j	800041a4 <exec+0x15e>
      panic("loadseg: address should exist");
    8000413a:	00004517          	auipc	a0,0x4
    8000413e:	55e50513          	add	a0,a0,1374 # 80008698 <syscalls+0x2c8>
    80004142:	00002097          	auipc	ra,0x2
    80004146:	a74080e7          	jalr	-1420(ra) # 80005bb6 <panic>
    if(sz - i < PGSIZE)
    8000414a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000414c:	8726                	mv	a4,s1
    8000414e:	012c06bb          	addw	a3,s8,s2
    80004152:	4581                	li	a1,0
    80004154:	8552                	mv	a0,s4
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	cc4080e7          	jalr	-828(ra) # 80002e1a <readi>
    8000415e:	2501                	sext.w	a0,a0
    80004160:	24a49863          	bne	s1,a0,800043b0 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004164:	012a893b          	addw	s2,s5,s2
    80004168:	03397563          	bgeu	s2,s3,80004192 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    8000416c:	02091593          	sll	a1,s2,0x20
    80004170:	9181                	srl	a1,a1,0x20
    80004172:	95de                	add	a1,a1,s7
    80004174:	855a                	mv	a0,s6
    80004176:	ffffc097          	auipc	ra,0xffffc
    8000417a:	38c080e7          	jalr	908(ra) # 80000502 <walkaddr>
    8000417e:	862a                	mv	a2,a0
    if(pa == 0)
    80004180:	dd4d                	beqz	a0,8000413a <exec+0xf4>
    if(sz - i < PGSIZE)
    80004182:	412984bb          	subw	s1,s3,s2
    80004186:	0004879b          	sext.w	a5,s1
    8000418a:	fcfcf0e3          	bgeu	s9,a5,8000414a <exec+0x104>
    8000418e:	84d6                	mv	s1,s5
    80004190:	bf6d                	j	8000414a <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004192:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004196:	2d85                	addw	s11,s11,1
    80004198:	038d0d1b          	addw	s10,s10,56
    8000419c:	e8845783          	lhu	a5,-376(s0)
    800041a0:	08fdd763          	bge	s11,a5,8000422e <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041a4:	2d01                	sext.w	s10,s10
    800041a6:	03800713          	li	a4,56
    800041aa:	86ea                	mv	a3,s10
    800041ac:	e1840613          	add	a2,s0,-488
    800041b0:	4581                	li	a1,0
    800041b2:	8552                	mv	a0,s4
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	c66080e7          	jalr	-922(ra) # 80002e1a <readi>
    800041bc:	03800793          	li	a5,56
    800041c0:	1ef51663          	bne	a0,a5,800043ac <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    800041c4:	e1842783          	lw	a5,-488(s0)
    800041c8:	4705                	li	a4,1
    800041ca:	fce796e3          	bne	a5,a4,80004196 <exec+0x150>
    if(ph.memsz < ph.filesz)
    800041ce:	e4043483          	ld	s1,-448(s0)
    800041d2:	e3843783          	ld	a5,-456(s0)
    800041d6:	1ef4e863          	bltu	s1,a5,800043c6 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800041da:	e2843783          	ld	a5,-472(s0)
    800041de:	94be                	add	s1,s1,a5
    800041e0:	1ef4e663          	bltu	s1,a5,800043cc <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800041e4:	df043703          	ld	a4,-528(s0)
    800041e8:	8ff9                	and	a5,a5,a4
    800041ea:	1e079463          	bnez	a5,800043d2 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800041ee:	e1c42503          	lw	a0,-484(s0)
    800041f2:	00000097          	auipc	ra,0x0
    800041f6:	e3a080e7          	jalr	-454(ra) # 8000402c <flags2perm>
    800041fa:	86aa                	mv	a3,a0
    800041fc:	8626                	mv	a2,s1
    800041fe:	85ca                	mv	a1,s2
    80004200:	855a                	mv	a0,s6
    80004202:	ffffc097          	auipc	ra,0xffffc
    80004206:	6b4080e7          	jalr	1716(ra) # 800008b6 <uvmalloc>
    8000420a:	e0a43423          	sd	a0,-504(s0)
    8000420e:	1c050563          	beqz	a0,800043d8 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004212:	e2843b83          	ld	s7,-472(s0)
    80004216:	e2042c03          	lw	s8,-480(s0)
    8000421a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000421e:	00098463          	beqz	s3,80004226 <exec+0x1e0>
    80004222:	4901                	li	s2,0
    80004224:	b7a1                	j	8000416c <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004226:	e0843903          	ld	s2,-504(s0)
    8000422a:	b7b5                	j	80004196 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000422c:	4901                	li	s2,0
  iunlockput(ip);
    8000422e:	8552                	mv	a0,s4
    80004230:	fffff097          	auipc	ra,0xfffff
    80004234:	b98080e7          	jalr	-1128(ra) # 80002dc8 <iunlockput>
  end_op();
    80004238:	fffff097          	auipc	ra,0xfffff
    8000423c:	34e080e7          	jalr	846(ra) # 80003586 <end_op>
  p = myproc();
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	c0e080e7          	jalr	-1010(ra) # 80000e4e <myproc>
    80004248:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000424a:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    8000424e:	6985                	lui	s3,0x1
    80004250:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004252:	99ca                	add	s3,s3,s2
    80004254:	77fd                	lui	a5,0xfffff
    80004256:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000425a:	4691                	li	a3,4
    8000425c:	6609                	lui	a2,0x2
    8000425e:	964e                	add	a2,a2,s3
    80004260:	85ce                	mv	a1,s3
    80004262:	855a                	mv	a0,s6
    80004264:	ffffc097          	auipc	ra,0xffffc
    80004268:	652080e7          	jalr	1618(ra) # 800008b6 <uvmalloc>
    8000426c:	892a                	mv	s2,a0
    8000426e:	e0a43423          	sd	a0,-504(s0)
    80004272:	e509                	bnez	a0,8000427c <exec+0x236>
  if(pagetable)
    80004274:	e1343423          	sd	s3,-504(s0)
    80004278:	4a01                	li	s4,0
    8000427a:	aa1d                	j	800043b0 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000427c:	75f9                	lui	a1,0xffffe
    8000427e:	95aa                	add	a1,a1,a0
    80004280:	855a                	mv	a0,s6
    80004282:	ffffd097          	auipc	ra,0xffffd
    80004286:	85e080e7          	jalr	-1954(ra) # 80000ae0 <uvmclear>
  stackbase = sp - PGSIZE;
    8000428a:	7bfd                	lui	s7,0xfffff
    8000428c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000428e:	e0043783          	ld	a5,-512(s0)
    80004292:	6388                	ld	a0,0(a5)
    80004294:	c52d                	beqz	a0,800042fe <exec+0x2b8>
    80004296:	e9040993          	add	s3,s0,-368
    8000429a:	f9040c13          	add	s8,s0,-112
    8000429e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042a0:	ffffc097          	auipc	ra,0xffffc
    800042a4:	054080e7          	jalr	84(ra) # 800002f4 <strlen>
    800042a8:	0015079b          	addw	a5,a0,1
    800042ac:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042b0:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    800042b4:	13796563          	bltu	s2,s7,800043de <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042b8:	e0043d03          	ld	s10,-512(s0)
    800042bc:	000d3a03          	ld	s4,0(s10)
    800042c0:	8552                	mv	a0,s4
    800042c2:	ffffc097          	auipc	ra,0xffffc
    800042c6:	032080e7          	jalr	50(ra) # 800002f4 <strlen>
    800042ca:	0015069b          	addw	a3,a0,1
    800042ce:	8652                	mv	a2,s4
    800042d0:	85ca                	mv	a1,s2
    800042d2:	855a                	mv	a0,s6
    800042d4:	ffffd097          	auipc	ra,0xffffd
    800042d8:	83e080e7          	jalr	-1986(ra) # 80000b12 <copyout>
    800042dc:	10054363          	bltz	a0,800043e2 <exec+0x39c>
    ustack[argc] = sp;
    800042e0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042e4:	0485                	add	s1,s1,1
    800042e6:	008d0793          	add	a5,s10,8
    800042ea:	e0f43023          	sd	a5,-512(s0)
    800042ee:	008d3503          	ld	a0,8(s10)
    800042f2:	c909                	beqz	a0,80004304 <exec+0x2be>
    if(argc >= MAXARG)
    800042f4:	09a1                	add	s3,s3,8
    800042f6:	fb8995e3          	bne	s3,s8,800042a0 <exec+0x25a>
  ip = 0;
    800042fa:	4a01                	li	s4,0
    800042fc:	a855                	j	800043b0 <exec+0x36a>
  sp = sz;
    800042fe:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004302:	4481                	li	s1,0
  ustack[argc] = 0;
    80004304:	00349793          	sll	a5,s1,0x3
    80004308:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd010>
    8000430c:	97a2                	add	a5,a5,s0
    8000430e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004312:	00148693          	add	a3,s1,1
    80004316:	068e                	sll	a3,a3,0x3
    80004318:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000431c:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004320:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004324:	f57968e3          	bltu	s2,s7,80004274 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004328:	e9040613          	add	a2,s0,-368
    8000432c:	85ca                	mv	a1,s2
    8000432e:	855a                	mv	a0,s6
    80004330:	ffffc097          	auipc	ra,0xffffc
    80004334:	7e2080e7          	jalr	2018(ra) # 80000b12 <copyout>
    80004338:	0a054763          	bltz	a0,800043e6 <exec+0x3a0>
  p->trapframe->a1 = sp;
    8000433c:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80004340:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004344:	df843783          	ld	a5,-520(s0)
    80004348:	0007c703          	lbu	a4,0(a5)
    8000434c:	cf11                	beqz	a4,80004368 <exec+0x322>
    8000434e:	0785                	add	a5,a5,1
    if(*s == '/')
    80004350:	02f00693          	li	a3,47
    80004354:	a039                	j	80004362 <exec+0x31c>
      last = s+1;
    80004356:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000435a:	0785                	add	a5,a5,1
    8000435c:	fff7c703          	lbu	a4,-1(a5)
    80004360:	c701                	beqz	a4,80004368 <exec+0x322>
    if(*s == '/')
    80004362:	fed71ce3          	bne	a4,a3,8000435a <exec+0x314>
    80004366:	bfc5                	j	80004356 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004368:	4641                	li	a2,16
    8000436a:	df843583          	ld	a1,-520(s0)
    8000436e:	160a8513          	add	a0,s5,352
    80004372:	ffffc097          	auipc	ra,0xffffc
    80004376:	f50080e7          	jalr	-176(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000437a:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    8000437e:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80004382:	e0843783          	ld	a5,-504(s0)
    80004386:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000438a:	060ab783          	ld	a5,96(s5)
    8000438e:	e6843703          	ld	a4,-408(s0)
    80004392:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004394:	060ab783          	ld	a5,96(s5)
    80004398:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000439c:	85e6                	mv	a1,s9
    8000439e:	ffffd097          	auipc	ra,0xffffd
    800043a2:	c54080e7          	jalr	-940(ra) # 80000ff2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043a6:	0004851b          	sext.w	a0,s1
    800043aa:	bb15                	j	800040de <exec+0x98>
    800043ac:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043b0:	e0843583          	ld	a1,-504(s0)
    800043b4:	855a                	mv	a0,s6
    800043b6:	ffffd097          	auipc	ra,0xffffd
    800043ba:	c3c080e7          	jalr	-964(ra) # 80000ff2 <proc_freepagetable>
  return -1;
    800043be:	557d                	li	a0,-1
  if(ip){
    800043c0:	d00a0fe3          	beqz	s4,800040de <exec+0x98>
    800043c4:	b319                	j	800040ca <exec+0x84>
    800043c6:	e1243423          	sd	s2,-504(s0)
    800043ca:	b7dd                	j	800043b0 <exec+0x36a>
    800043cc:	e1243423          	sd	s2,-504(s0)
    800043d0:	b7c5                	j	800043b0 <exec+0x36a>
    800043d2:	e1243423          	sd	s2,-504(s0)
    800043d6:	bfe9                	j	800043b0 <exec+0x36a>
    800043d8:	e1243423          	sd	s2,-504(s0)
    800043dc:	bfd1                	j	800043b0 <exec+0x36a>
  ip = 0;
    800043de:	4a01                	li	s4,0
    800043e0:	bfc1                	j	800043b0 <exec+0x36a>
    800043e2:	4a01                	li	s4,0
  if(pagetable)
    800043e4:	b7f1                	j	800043b0 <exec+0x36a>
  sz = sz1;
    800043e6:	e0843983          	ld	s3,-504(s0)
    800043ea:	b569                	j	80004274 <exec+0x22e>

00000000800043ec <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043ec:	7179                	add	sp,sp,-48
    800043ee:	f406                	sd	ra,40(sp)
    800043f0:	f022                	sd	s0,32(sp)
    800043f2:	ec26                	sd	s1,24(sp)
    800043f4:	e84a                	sd	s2,16(sp)
    800043f6:	1800                	add	s0,sp,48
    800043f8:	892e                	mv	s2,a1
    800043fa:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043fc:	fdc40593          	add	a1,s0,-36
    80004400:	ffffe097          	auipc	ra,0xffffe
    80004404:	bf6080e7          	jalr	-1034(ra) # 80001ff6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004408:	fdc42703          	lw	a4,-36(s0)
    8000440c:	47bd                	li	a5,15
    8000440e:	02e7eb63          	bltu	a5,a4,80004444 <argfd+0x58>
    80004412:	ffffd097          	auipc	ra,0xffffd
    80004416:	a3c080e7          	jalr	-1476(ra) # 80000e4e <myproc>
    8000441a:	fdc42703          	lw	a4,-36(s0)
    8000441e:	01a70793          	add	a5,a4,26
    80004422:	078e                	sll	a5,a5,0x3
    80004424:	953e                	add	a0,a0,a5
    80004426:	651c                	ld	a5,8(a0)
    80004428:	c385                	beqz	a5,80004448 <argfd+0x5c>
    return -1;
  if(pfd)
    8000442a:	00090463          	beqz	s2,80004432 <argfd+0x46>
    *pfd = fd;
    8000442e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004432:	4501                	li	a0,0
  if(pf)
    80004434:	c091                	beqz	s1,80004438 <argfd+0x4c>
    *pf = f;
    80004436:	e09c                	sd	a5,0(s1)
}
    80004438:	70a2                	ld	ra,40(sp)
    8000443a:	7402                	ld	s0,32(sp)
    8000443c:	64e2                	ld	s1,24(sp)
    8000443e:	6942                	ld	s2,16(sp)
    80004440:	6145                	add	sp,sp,48
    80004442:	8082                	ret
    return -1;
    80004444:	557d                	li	a0,-1
    80004446:	bfcd                	j	80004438 <argfd+0x4c>
    80004448:	557d                	li	a0,-1
    8000444a:	b7fd                	j	80004438 <argfd+0x4c>

000000008000444c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000444c:	1101                	add	sp,sp,-32
    8000444e:	ec06                	sd	ra,24(sp)
    80004450:	e822                	sd	s0,16(sp)
    80004452:	e426                	sd	s1,8(sp)
    80004454:	1000                	add	s0,sp,32
    80004456:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004458:	ffffd097          	auipc	ra,0xffffd
    8000445c:	9f6080e7          	jalr	-1546(ra) # 80000e4e <myproc>
    80004460:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004462:	0d850793          	add	a5,a0,216
    80004466:	4501                	li	a0,0
    80004468:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000446a:	6398                	ld	a4,0(a5)
    8000446c:	cb19                	beqz	a4,80004482 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000446e:	2505                	addw	a0,a0,1
    80004470:	07a1                	add	a5,a5,8
    80004472:	fed51ce3          	bne	a0,a3,8000446a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004476:	557d                	li	a0,-1
}
    80004478:	60e2                	ld	ra,24(sp)
    8000447a:	6442                	ld	s0,16(sp)
    8000447c:	64a2                	ld	s1,8(sp)
    8000447e:	6105                	add	sp,sp,32
    80004480:	8082                	ret
      p->ofile[fd] = f;
    80004482:	01a50793          	add	a5,a0,26
    80004486:	078e                	sll	a5,a5,0x3
    80004488:	963e                	add	a2,a2,a5
    8000448a:	e604                	sd	s1,8(a2)
      return fd;
    8000448c:	b7f5                	j	80004478 <fdalloc+0x2c>

000000008000448e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000448e:	715d                	add	sp,sp,-80
    80004490:	e486                	sd	ra,72(sp)
    80004492:	e0a2                	sd	s0,64(sp)
    80004494:	fc26                	sd	s1,56(sp)
    80004496:	f84a                	sd	s2,48(sp)
    80004498:	f44e                	sd	s3,40(sp)
    8000449a:	f052                	sd	s4,32(sp)
    8000449c:	ec56                	sd	s5,24(sp)
    8000449e:	e85a                	sd	s6,16(sp)
    800044a0:	0880                	add	s0,sp,80
    800044a2:	8b2e                	mv	s6,a1
    800044a4:	89b2                	mv	s3,a2
    800044a6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044a8:	fb040593          	add	a1,s0,-80
    800044ac:	fffff097          	auipc	ra,0xfffff
    800044b0:	e7e080e7          	jalr	-386(ra) # 8000332a <nameiparent>
    800044b4:	84aa                	mv	s1,a0
    800044b6:	14050b63          	beqz	a0,8000460c <create+0x17e>
    return 0;

  ilock(dp);
    800044ba:	ffffe097          	auipc	ra,0xffffe
    800044be:	6ac080e7          	jalr	1708(ra) # 80002b66 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044c2:	4601                	li	a2,0
    800044c4:	fb040593          	add	a1,s0,-80
    800044c8:	8526                	mv	a0,s1
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	b80080e7          	jalr	-1152(ra) # 8000304a <dirlookup>
    800044d2:	8aaa                	mv	s5,a0
    800044d4:	c921                	beqz	a0,80004524 <create+0x96>
    iunlockput(dp);
    800044d6:	8526                	mv	a0,s1
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	8f0080e7          	jalr	-1808(ra) # 80002dc8 <iunlockput>
    ilock(ip);
    800044e0:	8556                	mv	a0,s5
    800044e2:	ffffe097          	auipc	ra,0xffffe
    800044e6:	684080e7          	jalr	1668(ra) # 80002b66 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044ea:	4789                	li	a5,2
    800044ec:	02fb1563          	bne	s6,a5,80004516 <create+0x88>
    800044f0:	044ad783          	lhu	a5,68(s5)
    800044f4:	37f9                	addw	a5,a5,-2
    800044f6:	17c2                	sll	a5,a5,0x30
    800044f8:	93c1                	srl	a5,a5,0x30
    800044fa:	4705                	li	a4,1
    800044fc:	00f76d63          	bltu	a4,a5,80004516 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004500:	8556                	mv	a0,s5
    80004502:	60a6                	ld	ra,72(sp)
    80004504:	6406                	ld	s0,64(sp)
    80004506:	74e2                	ld	s1,56(sp)
    80004508:	7942                	ld	s2,48(sp)
    8000450a:	79a2                	ld	s3,40(sp)
    8000450c:	7a02                	ld	s4,32(sp)
    8000450e:	6ae2                	ld	s5,24(sp)
    80004510:	6b42                	ld	s6,16(sp)
    80004512:	6161                	add	sp,sp,80
    80004514:	8082                	ret
    iunlockput(ip);
    80004516:	8556                	mv	a0,s5
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	8b0080e7          	jalr	-1872(ra) # 80002dc8 <iunlockput>
    return 0;
    80004520:	4a81                	li	s5,0
    80004522:	bff9                	j	80004500 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004524:	85da                	mv	a1,s6
    80004526:	4088                	lw	a0,0(s1)
    80004528:	ffffe097          	auipc	ra,0xffffe
    8000452c:	4a6080e7          	jalr	1190(ra) # 800029ce <ialloc>
    80004530:	8a2a                	mv	s4,a0
    80004532:	c529                	beqz	a0,8000457c <create+0xee>
  ilock(ip);
    80004534:	ffffe097          	auipc	ra,0xffffe
    80004538:	632080e7          	jalr	1586(ra) # 80002b66 <ilock>
  ip->major = major;
    8000453c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004540:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004544:	4905                	li	s2,1
    80004546:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000454a:	8552                	mv	a0,s4
    8000454c:	ffffe097          	auipc	ra,0xffffe
    80004550:	54e080e7          	jalr	1358(ra) # 80002a9a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004554:	032b0b63          	beq	s6,s2,8000458a <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004558:	004a2603          	lw	a2,4(s4)
    8000455c:	fb040593          	add	a1,s0,-80
    80004560:	8526                	mv	a0,s1
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	cf8080e7          	jalr	-776(ra) # 8000325a <dirlink>
    8000456a:	06054f63          	bltz	a0,800045e8 <create+0x15a>
  iunlockput(dp);
    8000456e:	8526                	mv	a0,s1
    80004570:	fffff097          	auipc	ra,0xfffff
    80004574:	858080e7          	jalr	-1960(ra) # 80002dc8 <iunlockput>
  return ip;
    80004578:	8ad2                	mv	s5,s4
    8000457a:	b759                	j	80004500 <create+0x72>
    iunlockput(dp);
    8000457c:	8526                	mv	a0,s1
    8000457e:	fffff097          	auipc	ra,0xfffff
    80004582:	84a080e7          	jalr	-1974(ra) # 80002dc8 <iunlockput>
    return 0;
    80004586:	8ad2                	mv	s5,s4
    80004588:	bfa5                	j	80004500 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000458a:	004a2603          	lw	a2,4(s4)
    8000458e:	00004597          	auipc	a1,0x4
    80004592:	12a58593          	add	a1,a1,298 # 800086b8 <syscalls+0x2e8>
    80004596:	8552                	mv	a0,s4
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	cc2080e7          	jalr	-830(ra) # 8000325a <dirlink>
    800045a0:	04054463          	bltz	a0,800045e8 <create+0x15a>
    800045a4:	40d0                	lw	a2,4(s1)
    800045a6:	00004597          	auipc	a1,0x4
    800045aa:	11a58593          	add	a1,a1,282 # 800086c0 <syscalls+0x2f0>
    800045ae:	8552                	mv	a0,s4
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	caa080e7          	jalr	-854(ra) # 8000325a <dirlink>
    800045b8:	02054863          	bltz	a0,800045e8 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800045bc:	004a2603          	lw	a2,4(s4)
    800045c0:	fb040593          	add	a1,s0,-80
    800045c4:	8526                	mv	a0,s1
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	c94080e7          	jalr	-876(ra) # 8000325a <dirlink>
    800045ce:	00054d63          	bltz	a0,800045e8 <create+0x15a>
    dp->nlink++;  // for ".."
    800045d2:	04a4d783          	lhu	a5,74(s1)
    800045d6:	2785                	addw	a5,a5,1
    800045d8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045dc:	8526                	mv	a0,s1
    800045de:	ffffe097          	auipc	ra,0xffffe
    800045e2:	4bc080e7          	jalr	1212(ra) # 80002a9a <iupdate>
    800045e6:	b761                	j	8000456e <create+0xe0>
  ip->nlink = 0;
    800045e8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045ec:	8552                	mv	a0,s4
    800045ee:	ffffe097          	auipc	ra,0xffffe
    800045f2:	4ac080e7          	jalr	1196(ra) # 80002a9a <iupdate>
  iunlockput(ip);
    800045f6:	8552                	mv	a0,s4
    800045f8:	ffffe097          	auipc	ra,0xffffe
    800045fc:	7d0080e7          	jalr	2000(ra) # 80002dc8 <iunlockput>
  iunlockput(dp);
    80004600:	8526                	mv	a0,s1
    80004602:	ffffe097          	auipc	ra,0xffffe
    80004606:	7c6080e7          	jalr	1990(ra) # 80002dc8 <iunlockput>
  return 0;
    8000460a:	bddd                	j	80004500 <create+0x72>
    return 0;
    8000460c:	8aaa                	mv	s5,a0
    8000460e:	bdcd                	j	80004500 <create+0x72>

0000000080004610 <sys_dup>:
{
    80004610:	7179                	add	sp,sp,-48
    80004612:	f406                	sd	ra,40(sp)
    80004614:	f022                	sd	s0,32(sp)
    80004616:	ec26                	sd	s1,24(sp)
    80004618:	e84a                	sd	s2,16(sp)
    8000461a:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000461c:	fd840613          	add	a2,s0,-40
    80004620:	4581                	li	a1,0
    80004622:	4501                	li	a0,0
    80004624:	00000097          	auipc	ra,0x0
    80004628:	dc8080e7          	jalr	-568(ra) # 800043ec <argfd>
    return -1;
    8000462c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000462e:	02054363          	bltz	a0,80004654 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004632:	fd843903          	ld	s2,-40(s0)
    80004636:	854a                	mv	a0,s2
    80004638:	00000097          	auipc	ra,0x0
    8000463c:	e14080e7          	jalr	-492(ra) # 8000444c <fdalloc>
    80004640:	84aa                	mv	s1,a0
    return -1;
    80004642:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004644:	00054863          	bltz	a0,80004654 <sys_dup+0x44>
  filedup(f);
    80004648:	854a                	mv	a0,s2
    8000464a:	fffff097          	auipc	ra,0xfffff
    8000464e:	334080e7          	jalr	820(ra) # 8000397e <filedup>
  return fd;
    80004652:	87a6                	mv	a5,s1
}
    80004654:	853e                	mv	a0,a5
    80004656:	70a2                	ld	ra,40(sp)
    80004658:	7402                	ld	s0,32(sp)
    8000465a:	64e2                	ld	s1,24(sp)
    8000465c:	6942                	ld	s2,16(sp)
    8000465e:	6145                	add	sp,sp,48
    80004660:	8082                	ret

0000000080004662 <sys_read>:
{
    80004662:	7179                	add	sp,sp,-48
    80004664:	f406                	sd	ra,40(sp)
    80004666:	f022                	sd	s0,32(sp)
    80004668:	1800                	add	s0,sp,48
  argaddr(1, &p);
    8000466a:	fd840593          	add	a1,s0,-40
    8000466e:	4505                	li	a0,1
    80004670:	ffffe097          	auipc	ra,0xffffe
    80004674:	9a6080e7          	jalr	-1626(ra) # 80002016 <argaddr>
  argint(2, &n);
    80004678:	fe440593          	add	a1,s0,-28
    8000467c:	4509                	li	a0,2
    8000467e:	ffffe097          	auipc	ra,0xffffe
    80004682:	978080e7          	jalr	-1672(ra) # 80001ff6 <argint>
  if(argfd(0, 0, &f) < 0)
    80004686:	fe840613          	add	a2,s0,-24
    8000468a:	4581                	li	a1,0
    8000468c:	4501                	li	a0,0
    8000468e:	00000097          	auipc	ra,0x0
    80004692:	d5e080e7          	jalr	-674(ra) # 800043ec <argfd>
    80004696:	87aa                	mv	a5,a0
    return -1;
    80004698:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000469a:	0007cc63          	bltz	a5,800046b2 <sys_read+0x50>
  return fileread(f, p, n);
    8000469e:	fe442603          	lw	a2,-28(s0)
    800046a2:	fd843583          	ld	a1,-40(s0)
    800046a6:	fe843503          	ld	a0,-24(s0)
    800046aa:	fffff097          	auipc	ra,0xfffff
    800046ae:	460080e7          	jalr	1120(ra) # 80003b0a <fileread>
}
    800046b2:	70a2                	ld	ra,40(sp)
    800046b4:	7402                	ld	s0,32(sp)
    800046b6:	6145                	add	sp,sp,48
    800046b8:	8082                	ret

00000000800046ba <sys_write>:
{
    800046ba:	7179                	add	sp,sp,-48
    800046bc:	f406                	sd	ra,40(sp)
    800046be:	f022                	sd	s0,32(sp)
    800046c0:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800046c2:	fd840593          	add	a1,s0,-40
    800046c6:	4505                	li	a0,1
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	94e080e7          	jalr	-1714(ra) # 80002016 <argaddr>
  argint(2, &n);
    800046d0:	fe440593          	add	a1,s0,-28
    800046d4:	4509                	li	a0,2
    800046d6:	ffffe097          	auipc	ra,0xffffe
    800046da:	920080e7          	jalr	-1760(ra) # 80001ff6 <argint>
  if(argfd(0, 0, &f) < 0)
    800046de:	fe840613          	add	a2,s0,-24
    800046e2:	4581                	li	a1,0
    800046e4:	4501                	li	a0,0
    800046e6:	00000097          	auipc	ra,0x0
    800046ea:	d06080e7          	jalr	-762(ra) # 800043ec <argfd>
    800046ee:	87aa                	mv	a5,a0
    return -1;
    800046f0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046f2:	0007cc63          	bltz	a5,8000470a <sys_write+0x50>
  return filewrite(f, p, n);
    800046f6:	fe442603          	lw	a2,-28(s0)
    800046fa:	fd843583          	ld	a1,-40(s0)
    800046fe:	fe843503          	ld	a0,-24(s0)
    80004702:	fffff097          	auipc	ra,0xfffff
    80004706:	4ca080e7          	jalr	1226(ra) # 80003bcc <filewrite>
}
    8000470a:	70a2                	ld	ra,40(sp)
    8000470c:	7402                	ld	s0,32(sp)
    8000470e:	6145                	add	sp,sp,48
    80004710:	8082                	ret

0000000080004712 <sys_close>:
{
    80004712:	1101                	add	sp,sp,-32
    80004714:	ec06                	sd	ra,24(sp)
    80004716:	e822                	sd	s0,16(sp)
    80004718:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000471a:	fe040613          	add	a2,s0,-32
    8000471e:	fec40593          	add	a1,s0,-20
    80004722:	4501                	li	a0,0
    80004724:	00000097          	auipc	ra,0x0
    80004728:	cc8080e7          	jalr	-824(ra) # 800043ec <argfd>
    return -1;
    8000472c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000472e:	02054463          	bltz	a0,80004756 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004732:	ffffc097          	auipc	ra,0xffffc
    80004736:	71c080e7          	jalr	1820(ra) # 80000e4e <myproc>
    8000473a:	fec42783          	lw	a5,-20(s0)
    8000473e:	07e9                	add	a5,a5,26
    80004740:	078e                	sll	a5,a5,0x3
    80004742:	953e                	add	a0,a0,a5
    80004744:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004748:	fe043503          	ld	a0,-32(s0)
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	284080e7          	jalr	644(ra) # 800039d0 <fileclose>
  return 0;
    80004754:	4781                	li	a5,0
}
    80004756:	853e                	mv	a0,a5
    80004758:	60e2                	ld	ra,24(sp)
    8000475a:	6442                	ld	s0,16(sp)
    8000475c:	6105                	add	sp,sp,32
    8000475e:	8082                	ret

0000000080004760 <sys_fstat>:
{
    80004760:	1101                	add	sp,sp,-32
    80004762:	ec06                	sd	ra,24(sp)
    80004764:	e822                	sd	s0,16(sp)
    80004766:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004768:	fe040593          	add	a1,s0,-32
    8000476c:	4505                	li	a0,1
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	8a8080e7          	jalr	-1880(ra) # 80002016 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004776:	fe840613          	add	a2,s0,-24
    8000477a:	4581                	li	a1,0
    8000477c:	4501                	li	a0,0
    8000477e:	00000097          	auipc	ra,0x0
    80004782:	c6e080e7          	jalr	-914(ra) # 800043ec <argfd>
    80004786:	87aa                	mv	a5,a0
    return -1;
    80004788:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000478a:	0007ca63          	bltz	a5,8000479e <sys_fstat+0x3e>
  return filestat(f, st);
    8000478e:	fe043583          	ld	a1,-32(s0)
    80004792:	fe843503          	ld	a0,-24(s0)
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	302080e7          	jalr	770(ra) # 80003a98 <filestat>
}
    8000479e:	60e2                	ld	ra,24(sp)
    800047a0:	6442                	ld	s0,16(sp)
    800047a2:	6105                	add	sp,sp,32
    800047a4:	8082                	ret

00000000800047a6 <sys_link>:
{
    800047a6:	7169                	add	sp,sp,-304
    800047a8:	f606                	sd	ra,296(sp)
    800047aa:	f222                	sd	s0,288(sp)
    800047ac:	ee26                	sd	s1,280(sp)
    800047ae:	ea4a                	sd	s2,272(sp)
    800047b0:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047b2:	08000613          	li	a2,128
    800047b6:	ed040593          	add	a1,s0,-304
    800047ba:	4501                	li	a0,0
    800047bc:	ffffe097          	auipc	ra,0xffffe
    800047c0:	87a080e7          	jalr	-1926(ra) # 80002036 <argstr>
    return -1;
    800047c4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047c6:	10054e63          	bltz	a0,800048e2 <sys_link+0x13c>
    800047ca:	08000613          	li	a2,128
    800047ce:	f5040593          	add	a1,s0,-176
    800047d2:	4505                	li	a0,1
    800047d4:	ffffe097          	auipc	ra,0xffffe
    800047d8:	862080e7          	jalr	-1950(ra) # 80002036 <argstr>
    return -1;
    800047dc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047de:	10054263          	bltz	a0,800048e2 <sys_link+0x13c>
  begin_op();
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	d2a080e7          	jalr	-726(ra) # 8000350c <begin_op>
  if((ip = namei(old)) == 0){
    800047ea:	ed040513          	add	a0,s0,-304
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	b1e080e7          	jalr	-1250(ra) # 8000330c <namei>
    800047f6:	84aa                	mv	s1,a0
    800047f8:	c551                	beqz	a0,80004884 <sys_link+0xde>
  ilock(ip);
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	36c080e7          	jalr	876(ra) # 80002b66 <ilock>
  if(ip->type == T_DIR){
    80004802:	04449703          	lh	a4,68(s1)
    80004806:	4785                	li	a5,1
    80004808:	08f70463          	beq	a4,a5,80004890 <sys_link+0xea>
  ip->nlink++;
    8000480c:	04a4d783          	lhu	a5,74(s1)
    80004810:	2785                	addw	a5,a5,1
    80004812:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004816:	8526                	mv	a0,s1
    80004818:	ffffe097          	auipc	ra,0xffffe
    8000481c:	282080e7          	jalr	642(ra) # 80002a9a <iupdate>
  iunlock(ip);
    80004820:	8526                	mv	a0,s1
    80004822:	ffffe097          	auipc	ra,0xffffe
    80004826:	406080e7          	jalr	1030(ra) # 80002c28 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000482a:	fd040593          	add	a1,s0,-48
    8000482e:	f5040513          	add	a0,s0,-176
    80004832:	fffff097          	auipc	ra,0xfffff
    80004836:	af8080e7          	jalr	-1288(ra) # 8000332a <nameiparent>
    8000483a:	892a                	mv	s2,a0
    8000483c:	c935                	beqz	a0,800048b0 <sys_link+0x10a>
  ilock(dp);
    8000483e:	ffffe097          	auipc	ra,0xffffe
    80004842:	328080e7          	jalr	808(ra) # 80002b66 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004846:	00092703          	lw	a4,0(s2)
    8000484a:	409c                	lw	a5,0(s1)
    8000484c:	04f71d63          	bne	a4,a5,800048a6 <sys_link+0x100>
    80004850:	40d0                	lw	a2,4(s1)
    80004852:	fd040593          	add	a1,s0,-48
    80004856:	854a                	mv	a0,s2
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	a02080e7          	jalr	-1534(ra) # 8000325a <dirlink>
    80004860:	04054363          	bltz	a0,800048a6 <sys_link+0x100>
  iunlockput(dp);
    80004864:	854a                	mv	a0,s2
    80004866:	ffffe097          	auipc	ra,0xffffe
    8000486a:	562080e7          	jalr	1378(ra) # 80002dc8 <iunlockput>
  iput(ip);
    8000486e:	8526                	mv	a0,s1
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	4b0080e7          	jalr	1200(ra) # 80002d20 <iput>
  end_op();
    80004878:	fffff097          	auipc	ra,0xfffff
    8000487c:	d0e080e7          	jalr	-754(ra) # 80003586 <end_op>
  return 0;
    80004880:	4781                	li	a5,0
    80004882:	a085                	j	800048e2 <sys_link+0x13c>
    end_op();
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	d02080e7          	jalr	-766(ra) # 80003586 <end_op>
    return -1;
    8000488c:	57fd                	li	a5,-1
    8000488e:	a891                	j	800048e2 <sys_link+0x13c>
    iunlockput(ip);
    80004890:	8526                	mv	a0,s1
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	536080e7          	jalr	1334(ra) # 80002dc8 <iunlockput>
    end_op();
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	cec080e7          	jalr	-788(ra) # 80003586 <end_op>
    return -1;
    800048a2:	57fd                	li	a5,-1
    800048a4:	a83d                	j	800048e2 <sys_link+0x13c>
    iunlockput(dp);
    800048a6:	854a                	mv	a0,s2
    800048a8:	ffffe097          	auipc	ra,0xffffe
    800048ac:	520080e7          	jalr	1312(ra) # 80002dc8 <iunlockput>
  ilock(ip);
    800048b0:	8526                	mv	a0,s1
    800048b2:	ffffe097          	auipc	ra,0xffffe
    800048b6:	2b4080e7          	jalr	692(ra) # 80002b66 <ilock>
  ip->nlink--;
    800048ba:	04a4d783          	lhu	a5,74(s1)
    800048be:	37fd                	addw	a5,a5,-1
    800048c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048c4:	8526                	mv	a0,s1
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	1d4080e7          	jalr	468(ra) # 80002a9a <iupdate>
  iunlockput(ip);
    800048ce:	8526                	mv	a0,s1
    800048d0:	ffffe097          	auipc	ra,0xffffe
    800048d4:	4f8080e7          	jalr	1272(ra) # 80002dc8 <iunlockput>
  end_op();
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	cae080e7          	jalr	-850(ra) # 80003586 <end_op>
  return -1;
    800048e0:	57fd                	li	a5,-1
}
    800048e2:	853e                	mv	a0,a5
    800048e4:	70b2                	ld	ra,296(sp)
    800048e6:	7412                	ld	s0,288(sp)
    800048e8:	64f2                	ld	s1,280(sp)
    800048ea:	6952                	ld	s2,272(sp)
    800048ec:	6155                	add	sp,sp,304
    800048ee:	8082                	ret

00000000800048f0 <sys_unlink>:
{
    800048f0:	7151                	add	sp,sp,-240
    800048f2:	f586                	sd	ra,232(sp)
    800048f4:	f1a2                	sd	s0,224(sp)
    800048f6:	eda6                	sd	s1,216(sp)
    800048f8:	e9ca                	sd	s2,208(sp)
    800048fa:	e5ce                	sd	s3,200(sp)
    800048fc:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048fe:	08000613          	li	a2,128
    80004902:	f3040593          	add	a1,s0,-208
    80004906:	4501                	li	a0,0
    80004908:	ffffd097          	auipc	ra,0xffffd
    8000490c:	72e080e7          	jalr	1838(ra) # 80002036 <argstr>
    80004910:	18054163          	bltz	a0,80004a92 <sys_unlink+0x1a2>
  begin_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	bf8080e7          	jalr	-1032(ra) # 8000350c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000491c:	fb040593          	add	a1,s0,-80
    80004920:	f3040513          	add	a0,s0,-208
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	a06080e7          	jalr	-1530(ra) # 8000332a <nameiparent>
    8000492c:	84aa                	mv	s1,a0
    8000492e:	c979                	beqz	a0,80004a04 <sys_unlink+0x114>
  ilock(dp);
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	236080e7          	jalr	566(ra) # 80002b66 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004938:	00004597          	auipc	a1,0x4
    8000493c:	d8058593          	add	a1,a1,-640 # 800086b8 <syscalls+0x2e8>
    80004940:	fb040513          	add	a0,s0,-80
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	6ec080e7          	jalr	1772(ra) # 80003030 <namecmp>
    8000494c:	14050a63          	beqz	a0,80004aa0 <sys_unlink+0x1b0>
    80004950:	00004597          	auipc	a1,0x4
    80004954:	d7058593          	add	a1,a1,-656 # 800086c0 <syscalls+0x2f0>
    80004958:	fb040513          	add	a0,s0,-80
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	6d4080e7          	jalr	1748(ra) # 80003030 <namecmp>
    80004964:	12050e63          	beqz	a0,80004aa0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004968:	f2c40613          	add	a2,s0,-212
    8000496c:	fb040593          	add	a1,s0,-80
    80004970:	8526                	mv	a0,s1
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	6d8080e7          	jalr	1752(ra) # 8000304a <dirlookup>
    8000497a:	892a                	mv	s2,a0
    8000497c:	12050263          	beqz	a0,80004aa0 <sys_unlink+0x1b0>
  ilock(ip);
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	1e6080e7          	jalr	486(ra) # 80002b66 <ilock>
  if(ip->nlink < 1)
    80004988:	04a91783          	lh	a5,74(s2)
    8000498c:	08f05263          	blez	a5,80004a10 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004990:	04491703          	lh	a4,68(s2)
    80004994:	4785                	li	a5,1
    80004996:	08f70563          	beq	a4,a5,80004a20 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000499a:	4641                	li	a2,16
    8000499c:	4581                	li	a1,0
    8000499e:	fc040513          	add	a0,s0,-64
    800049a2:	ffffb097          	auipc	ra,0xffffb
    800049a6:	7d8080e7          	jalr	2008(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049aa:	4741                	li	a4,16
    800049ac:	f2c42683          	lw	a3,-212(s0)
    800049b0:	fc040613          	add	a2,s0,-64
    800049b4:	4581                	li	a1,0
    800049b6:	8526                	mv	a0,s1
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	55a080e7          	jalr	1370(ra) # 80002f12 <writei>
    800049c0:	47c1                	li	a5,16
    800049c2:	0af51563          	bne	a0,a5,80004a6c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049c6:	04491703          	lh	a4,68(s2)
    800049ca:	4785                	li	a5,1
    800049cc:	0af70863          	beq	a4,a5,80004a7c <sys_unlink+0x18c>
  iunlockput(dp);
    800049d0:	8526                	mv	a0,s1
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	3f6080e7          	jalr	1014(ra) # 80002dc8 <iunlockput>
  ip->nlink--;
    800049da:	04a95783          	lhu	a5,74(s2)
    800049de:	37fd                	addw	a5,a5,-1
    800049e0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049e4:	854a                	mv	a0,s2
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	0b4080e7          	jalr	180(ra) # 80002a9a <iupdate>
  iunlockput(ip);
    800049ee:	854a                	mv	a0,s2
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	3d8080e7          	jalr	984(ra) # 80002dc8 <iunlockput>
  end_op();
    800049f8:	fffff097          	auipc	ra,0xfffff
    800049fc:	b8e080e7          	jalr	-1138(ra) # 80003586 <end_op>
  return 0;
    80004a00:	4501                	li	a0,0
    80004a02:	a84d                	j	80004ab4 <sys_unlink+0x1c4>
    end_op();
    80004a04:	fffff097          	auipc	ra,0xfffff
    80004a08:	b82080e7          	jalr	-1150(ra) # 80003586 <end_op>
    return -1;
    80004a0c:	557d                	li	a0,-1
    80004a0e:	a05d                	j	80004ab4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a10:	00004517          	auipc	a0,0x4
    80004a14:	cb850513          	add	a0,a0,-840 # 800086c8 <syscalls+0x2f8>
    80004a18:	00001097          	auipc	ra,0x1
    80004a1c:	19e080e7          	jalr	414(ra) # 80005bb6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a20:	04c92703          	lw	a4,76(s2)
    80004a24:	02000793          	li	a5,32
    80004a28:	f6e7f9e3          	bgeu	a5,a4,8000499a <sys_unlink+0xaa>
    80004a2c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a30:	4741                	li	a4,16
    80004a32:	86ce                	mv	a3,s3
    80004a34:	f1840613          	add	a2,s0,-232
    80004a38:	4581                	li	a1,0
    80004a3a:	854a                	mv	a0,s2
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	3de080e7          	jalr	990(ra) # 80002e1a <readi>
    80004a44:	47c1                	li	a5,16
    80004a46:	00f51b63          	bne	a0,a5,80004a5c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a4a:	f1845783          	lhu	a5,-232(s0)
    80004a4e:	e7a1                	bnez	a5,80004a96 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a50:	29c1                	addw	s3,s3,16
    80004a52:	04c92783          	lw	a5,76(s2)
    80004a56:	fcf9ede3          	bltu	s3,a5,80004a30 <sys_unlink+0x140>
    80004a5a:	b781                	j	8000499a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a5c:	00004517          	auipc	a0,0x4
    80004a60:	c8450513          	add	a0,a0,-892 # 800086e0 <syscalls+0x310>
    80004a64:	00001097          	auipc	ra,0x1
    80004a68:	152080e7          	jalr	338(ra) # 80005bb6 <panic>
    panic("unlink: writei");
    80004a6c:	00004517          	auipc	a0,0x4
    80004a70:	c8c50513          	add	a0,a0,-884 # 800086f8 <syscalls+0x328>
    80004a74:	00001097          	auipc	ra,0x1
    80004a78:	142080e7          	jalr	322(ra) # 80005bb6 <panic>
    dp->nlink--;
    80004a7c:	04a4d783          	lhu	a5,74(s1)
    80004a80:	37fd                	addw	a5,a5,-1
    80004a82:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a86:	8526                	mv	a0,s1
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	012080e7          	jalr	18(ra) # 80002a9a <iupdate>
    80004a90:	b781                	j	800049d0 <sys_unlink+0xe0>
    return -1;
    80004a92:	557d                	li	a0,-1
    80004a94:	a005                	j	80004ab4 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a96:	854a                	mv	a0,s2
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	330080e7          	jalr	816(ra) # 80002dc8 <iunlockput>
  iunlockput(dp);
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	326080e7          	jalr	806(ra) # 80002dc8 <iunlockput>
  end_op();
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	adc080e7          	jalr	-1316(ra) # 80003586 <end_op>
  return -1;
    80004ab2:	557d                	li	a0,-1
}
    80004ab4:	70ae                	ld	ra,232(sp)
    80004ab6:	740e                	ld	s0,224(sp)
    80004ab8:	64ee                	ld	s1,216(sp)
    80004aba:	694e                	ld	s2,208(sp)
    80004abc:	69ae                	ld	s3,200(sp)
    80004abe:	616d                	add	sp,sp,240
    80004ac0:	8082                	ret

0000000080004ac2 <sys_open>:

uint64
sys_open(void)
{
    80004ac2:	7131                	add	sp,sp,-192
    80004ac4:	fd06                	sd	ra,184(sp)
    80004ac6:	f922                	sd	s0,176(sp)
    80004ac8:	f526                	sd	s1,168(sp)
    80004aca:	f14a                	sd	s2,160(sp)
    80004acc:	ed4e                	sd	s3,152(sp)
    80004ace:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ad0:	f4c40593          	add	a1,s0,-180
    80004ad4:	4505                	li	a0,1
    80004ad6:	ffffd097          	auipc	ra,0xffffd
    80004ada:	520080e7          	jalr	1312(ra) # 80001ff6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ade:	08000613          	li	a2,128
    80004ae2:	f5040593          	add	a1,s0,-176
    80004ae6:	4501                	li	a0,0
    80004ae8:	ffffd097          	auipc	ra,0xffffd
    80004aec:	54e080e7          	jalr	1358(ra) # 80002036 <argstr>
    80004af0:	87aa                	mv	a5,a0
    return -1;
    80004af2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004af4:	0a07c863          	bltz	a5,80004ba4 <sys_open+0xe2>

  begin_op();
    80004af8:	fffff097          	auipc	ra,0xfffff
    80004afc:	a14080e7          	jalr	-1516(ra) # 8000350c <begin_op>

  if(omode & O_CREATE){
    80004b00:	f4c42783          	lw	a5,-180(s0)
    80004b04:	2007f793          	and	a5,a5,512
    80004b08:	cbdd                	beqz	a5,80004bbe <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004b0a:	4681                	li	a3,0
    80004b0c:	4601                	li	a2,0
    80004b0e:	4589                	li	a1,2
    80004b10:	f5040513          	add	a0,s0,-176
    80004b14:	00000097          	auipc	ra,0x0
    80004b18:	97a080e7          	jalr	-1670(ra) # 8000448e <create>
    80004b1c:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b1e:	c951                	beqz	a0,80004bb2 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b20:	04449703          	lh	a4,68(s1)
    80004b24:	478d                	li	a5,3
    80004b26:	00f71763          	bne	a4,a5,80004b34 <sys_open+0x72>
    80004b2a:	0464d703          	lhu	a4,70(s1)
    80004b2e:	47a5                	li	a5,9
    80004b30:	0ce7ec63          	bltu	a5,a4,80004c08 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b34:	fffff097          	auipc	ra,0xfffff
    80004b38:	de0080e7          	jalr	-544(ra) # 80003914 <filealloc>
    80004b3c:	892a                	mv	s2,a0
    80004b3e:	c56d                	beqz	a0,80004c28 <sys_open+0x166>
    80004b40:	00000097          	auipc	ra,0x0
    80004b44:	90c080e7          	jalr	-1780(ra) # 8000444c <fdalloc>
    80004b48:	89aa                	mv	s3,a0
    80004b4a:	0c054a63          	bltz	a0,80004c1e <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b4e:	04449703          	lh	a4,68(s1)
    80004b52:	478d                	li	a5,3
    80004b54:	0ef70563          	beq	a4,a5,80004c3e <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b58:	4789                	li	a5,2
    80004b5a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004b5e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004b62:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004b66:	f4c42783          	lw	a5,-180(s0)
    80004b6a:	0017c713          	xor	a4,a5,1
    80004b6e:	8b05                	and	a4,a4,1
    80004b70:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b74:	0037f713          	and	a4,a5,3
    80004b78:	00e03733          	snez	a4,a4
    80004b7c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b80:	4007f793          	and	a5,a5,1024
    80004b84:	c791                	beqz	a5,80004b90 <sys_open+0xce>
    80004b86:	04449703          	lh	a4,68(s1)
    80004b8a:	4789                	li	a5,2
    80004b8c:	0cf70063          	beq	a4,a5,80004c4c <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004b90:	8526                	mv	a0,s1
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	096080e7          	jalr	150(ra) # 80002c28 <iunlock>
  end_op();
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	9ec080e7          	jalr	-1556(ra) # 80003586 <end_op>

  return fd;
    80004ba2:	854e                	mv	a0,s3
}
    80004ba4:	70ea                	ld	ra,184(sp)
    80004ba6:	744a                	ld	s0,176(sp)
    80004ba8:	74aa                	ld	s1,168(sp)
    80004baa:	790a                	ld	s2,160(sp)
    80004bac:	69ea                	ld	s3,152(sp)
    80004bae:	6129                	add	sp,sp,192
    80004bb0:	8082                	ret
      end_op();
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	9d4080e7          	jalr	-1580(ra) # 80003586 <end_op>
      return -1;
    80004bba:	557d                	li	a0,-1
    80004bbc:	b7e5                	j	80004ba4 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004bbe:	f5040513          	add	a0,s0,-176
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	74a080e7          	jalr	1866(ra) # 8000330c <namei>
    80004bca:	84aa                	mv	s1,a0
    80004bcc:	c905                	beqz	a0,80004bfc <sys_open+0x13a>
    ilock(ip);
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	f98080e7          	jalr	-104(ra) # 80002b66 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bd6:	04449703          	lh	a4,68(s1)
    80004bda:	4785                	li	a5,1
    80004bdc:	f4f712e3          	bne	a4,a5,80004b20 <sys_open+0x5e>
    80004be0:	f4c42783          	lw	a5,-180(s0)
    80004be4:	dba1                	beqz	a5,80004b34 <sys_open+0x72>
      iunlockput(ip);
    80004be6:	8526                	mv	a0,s1
    80004be8:	ffffe097          	auipc	ra,0xffffe
    80004bec:	1e0080e7          	jalr	480(ra) # 80002dc8 <iunlockput>
      end_op();
    80004bf0:	fffff097          	auipc	ra,0xfffff
    80004bf4:	996080e7          	jalr	-1642(ra) # 80003586 <end_op>
      return -1;
    80004bf8:	557d                	li	a0,-1
    80004bfa:	b76d                	j	80004ba4 <sys_open+0xe2>
      end_op();
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	98a080e7          	jalr	-1654(ra) # 80003586 <end_op>
      return -1;
    80004c04:	557d                	li	a0,-1
    80004c06:	bf79                	j	80004ba4 <sys_open+0xe2>
    iunlockput(ip);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	1be080e7          	jalr	446(ra) # 80002dc8 <iunlockput>
    end_op();
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	974080e7          	jalr	-1676(ra) # 80003586 <end_op>
    return -1;
    80004c1a:	557d                	li	a0,-1
    80004c1c:	b761                	j	80004ba4 <sys_open+0xe2>
      fileclose(f);
    80004c1e:	854a                	mv	a0,s2
    80004c20:	fffff097          	auipc	ra,0xfffff
    80004c24:	db0080e7          	jalr	-592(ra) # 800039d0 <fileclose>
    iunlockput(ip);
    80004c28:	8526                	mv	a0,s1
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	19e080e7          	jalr	414(ra) # 80002dc8 <iunlockput>
    end_op();
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	954080e7          	jalr	-1708(ra) # 80003586 <end_op>
    return -1;
    80004c3a:	557d                	li	a0,-1
    80004c3c:	b7a5                	j	80004ba4 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004c3e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004c42:	04649783          	lh	a5,70(s1)
    80004c46:	02f91223          	sh	a5,36(s2)
    80004c4a:	bf21                	j	80004b62 <sys_open+0xa0>
    itrunc(ip);
    80004c4c:	8526                	mv	a0,s1
    80004c4e:	ffffe097          	auipc	ra,0xffffe
    80004c52:	026080e7          	jalr	38(ra) # 80002c74 <itrunc>
    80004c56:	bf2d                	j	80004b90 <sys_open+0xce>

0000000080004c58 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c58:	7175                	add	sp,sp,-144
    80004c5a:	e506                	sd	ra,136(sp)
    80004c5c:	e122                	sd	s0,128(sp)
    80004c5e:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	8ac080e7          	jalr	-1876(ra) # 8000350c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c68:	08000613          	li	a2,128
    80004c6c:	f7040593          	add	a1,s0,-144
    80004c70:	4501                	li	a0,0
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	3c4080e7          	jalr	964(ra) # 80002036 <argstr>
    80004c7a:	02054963          	bltz	a0,80004cac <sys_mkdir+0x54>
    80004c7e:	4681                	li	a3,0
    80004c80:	4601                	li	a2,0
    80004c82:	4585                	li	a1,1
    80004c84:	f7040513          	add	a0,s0,-144
    80004c88:	00000097          	auipc	ra,0x0
    80004c8c:	806080e7          	jalr	-2042(ra) # 8000448e <create>
    80004c90:	cd11                	beqz	a0,80004cac <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	136080e7          	jalr	310(ra) # 80002dc8 <iunlockput>
  end_op();
    80004c9a:	fffff097          	auipc	ra,0xfffff
    80004c9e:	8ec080e7          	jalr	-1812(ra) # 80003586 <end_op>
  return 0;
    80004ca2:	4501                	li	a0,0
}
    80004ca4:	60aa                	ld	ra,136(sp)
    80004ca6:	640a                	ld	s0,128(sp)
    80004ca8:	6149                	add	sp,sp,144
    80004caa:	8082                	ret
    end_op();
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	8da080e7          	jalr	-1830(ra) # 80003586 <end_op>
    return -1;
    80004cb4:	557d                	li	a0,-1
    80004cb6:	b7fd                	j	80004ca4 <sys_mkdir+0x4c>

0000000080004cb8 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cb8:	7135                	add	sp,sp,-160
    80004cba:	ed06                	sd	ra,152(sp)
    80004cbc:	e922                	sd	s0,144(sp)
    80004cbe:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cc0:	fffff097          	auipc	ra,0xfffff
    80004cc4:	84c080e7          	jalr	-1972(ra) # 8000350c <begin_op>
  argint(1, &major);
    80004cc8:	f6c40593          	add	a1,s0,-148
    80004ccc:	4505                	li	a0,1
    80004cce:	ffffd097          	auipc	ra,0xffffd
    80004cd2:	328080e7          	jalr	808(ra) # 80001ff6 <argint>
  argint(2, &minor);
    80004cd6:	f6840593          	add	a1,s0,-152
    80004cda:	4509                	li	a0,2
    80004cdc:	ffffd097          	auipc	ra,0xffffd
    80004ce0:	31a080e7          	jalr	794(ra) # 80001ff6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ce4:	08000613          	li	a2,128
    80004ce8:	f7040593          	add	a1,s0,-144
    80004cec:	4501                	li	a0,0
    80004cee:	ffffd097          	auipc	ra,0xffffd
    80004cf2:	348080e7          	jalr	840(ra) # 80002036 <argstr>
    80004cf6:	02054b63          	bltz	a0,80004d2c <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cfa:	f6841683          	lh	a3,-152(s0)
    80004cfe:	f6c41603          	lh	a2,-148(s0)
    80004d02:	458d                	li	a1,3
    80004d04:	f7040513          	add	a0,s0,-144
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	786080e7          	jalr	1926(ra) # 8000448e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d10:	cd11                	beqz	a0,80004d2c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d12:	ffffe097          	auipc	ra,0xffffe
    80004d16:	0b6080e7          	jalr	182(ra) # 80002dc8 <iunlockput>
  end_op();
    80004d1a:	fffff097          	auipc	ra,0xfffff
    80004d1e:	86c080e7          	jalr	-1940(ra) # 80003586 <end_op>
  return 0;
    80004d22:	4501                	li	a0,0
}
    80004d24:	60ea                	ld	ra,152(sp)
    80004d26:	644a                	ld	s0,144(sp)
    80004d28:	610d                	add	sp,sp,160
    80004d2a:	8082                	ret
    end_op();
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	85a080e7          	jalr	-1958(ra) # 80003586 <end_op>
    return -1;
    80004d34:	557d                	li	a0,-1
    80004d36:	b7fd                	j	80004d24 <sys_mknod+0x6c>

0000000080004d38 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d38:	7135                	add	sp,sp,-160
    80004d3a:	ed06                	sd	ra,152(sp)
    80004d3c:	e922                	sd	s0,144(sp)
    80004d3e:	e526                	sd	s1,136(sp)
    80004d40:	e14a                	sd	s2,128(sp)
    80004d42:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d44:	ffffc097          	auipc	ra,0xffffc
    80004d48:	10a080e7          	jalr	266(ra) # 80000e4e <myproc>
    80004d4c:	892a                	mv	s2,a0
  
  begin_op();
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	7be080e7          	jalr	1982(ra) # 8000350c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d56:	08000613          	li	a2,128
    80004d5a:	f6040593          	add	a1,s0,-160
    80004d5e:	4501                	li	a0,0
    80004d60:	ffffd097          	auipc	ra,0xffffd
    80004d64:	2d6080e7          	jalr	726(ra) # 80002036 <argstr>
    80004d68:	04054b63          	bltz	a0,80004dbe <sys_chdir+0x86>
    80004d6c:	f6040513          	add	a0,s0,-160
    80004d70:	ffffe097          	auipc	ra,0xffffe
    80004d74:	59c080e7          	jalr	1436(ra) # 8000330c <namei>
    80004d78:	84aa                	mv	s1,a0
    80004d7a:	c131                	beqz	a0,80004dbe <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d7c:	ffffe097          	auipc	ra,0xffffe
    80004d80:	dea080e7          	jalr	-534(ra) # 80002b66 <ilock>
  if(ip->type != T_DIR){
    80004d84:	04449703          	lh	a4,68(s1)
    80004d88:	4785                	li	a5,1
    80004d8a:	04f71063          	bne	a4,a5,80004dca <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d8e:	8526                	mv	a0,s1
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	e98080e7          	jalr	-360(ra) # 80002c28 <iunlock>
  iput(p->cwd);
    80004d98:	15893503          	ld	a0,344(s2)
    80004d9c:	ffffe097          	auipc	ra,0xffffe
    80004da0:	f84080e7          	jalr	-124(ra) # 80002d20 <iput>
  end_op();
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	7e2080e7          	jalr	2018(ra) # 80003586 <end_op>
  p->cwd = ip;
    80004dac:	14993c23          	sd	s1,344(s2)
  return 0;
    80004db0:	4501                	li	a0,0
}
    80004db2:	60ea                	ld	ra,152(sp)
    80004db4:	644a                	ld	s0,144(sp)
    80004db6:	64aa                	ld	s1,136(sp)
    80004db8:	690a                	ld	s2,128(sp)
    80004dba:	610d                	add	sp,sp,160
    80004dbc:	8082                	ret
    end_op();
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	7c8080e7          	jalr	1992(ra) # 80003586 <end_op>
    return -1;
    80004dc6:	557d                	li	a0,-1
    80004dc8:	b7ed                	j	80004db2 <sys_chdir+0x7a>
    iunlockput(ip);
    80004dca:	8526                	mv	a0,s1
    80004dcc:	ffffe097          	auipc	ra,0xffffe
    80004dd0:	ffc080e7          	jalr	-4(ra) # 80002dc8 <iunlockput>
    end_op();
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	7b2080e7          	jalr	1970(ra) # 80003586 <end_op>
    return -1;
    80004ddc:	557d                	li	a0,-1
    80004dde:	bfd1                	j	80004db2 <sys_chdir+0x7a>

0000000080004de0 <sys_exec>:

uint64
sys_exec(void)
{
    80004de0:	7121                	add	sp,sp,-448
    80004de2:	ff06                	sd	ra,440(sp)
    80004de4:	fb22                	sd	s0,432(sp)
    80004de6:	f726                	sd	s1,424(sp)
    80004de8:	f34a                	sd	s2,416(sp)
    80004dea:	ef4e                	sd	s3,408(sp)
    80004dec:	eb52                	sd	s4,400(sp)
    80004dee:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004df0:	e4840593          	add	a1,s0,-440
    80004df4:	4505                	li	a0,1
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	220080e7          	jalr	544(ra) # 80002016 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004dfe:	08000613          	li	a2,128
    80004e02:	f5040593          	add	a1,s0,-176
    80004e06:	4501                	li	a0,0
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	22e080e7          	jalr	558(ra) # 80002036 <argstr>
    80004e10:	87aa                	mv	a5,a0
    return -1;
    80004e12:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e14:	0c07c263          	bltz	a5,80004ed8 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004e18:	10000613          	li	a2,256
    80004e1c:	4581                	li	a1,0
    80004e1e:	e5040513          	add	a0,s0,-432
    80004e22:	ffffb097          	auipc	ra,0xffffb
    80004e26:	358080e7          	jalr	856(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e2a:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e2e:	89a6                	mv	s3,s1
    80004e30:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e32:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e36:	00391513          	sll	a0,s2,0x3
    80004e3a:	e4040593          	add	a1,s0,-448
    80004e3e:	e4843783          	ld	a5,-440(s0)
    80004e42:	953e                	add	a0,a0,a5
    80004e44:	ffffd097          	auipc	ra,0xffffd
    80004e48:	114080e7          	jalr	276(ra) # 80001f58 <fetchaddr>
    80004e4c:	02054a63          	bltz	a0,80004e80 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004e50:	e4043783          	ld	a5,-448(s0)
    80004e54:	c3b9                	beqz	a5,80004e9a <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e56:	ffffb097          	auipc	ra,0xffffb
    80004e5a:	2c4080e7          	jalr	708(ra) # 8000011a <kalloc>
    80004e5e:	85aa                	mv	a1,a0
    80004e60:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e64:	cd11                	beqz	a0,80004e80 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e66:	6605                	lui	a2,0x1
    80004e68:	e4043503          	ld	a0,-448(s0)
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	13e080e7          	jalr	318(ra) # 80001faa <fetchstr>
    80004e74:	00054663          	bltz	a0,80004e80 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004e78:	0905                	add	s2,s2,1
    80004e7a:	09a1                	add	s3,s3,8
    80004e7c:	fb491de3          	bne	s2,s4,80004e36 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e80:	f5040913          	add	s2,s0,-176
    80004e84:	6088                	ld	a0,0(s1)
    80004e86:	c921                	beqz	a0,80004ed6 <sys_exec+0xf6>
    kfree(argv[i]);
    80004e88:	ffffb097          	auipc	ra,0xffffb
    80004e8c:	194080e7          	jalr	404(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e90:	04a1                	add	s1,s1,8
    80004e92:	ff2499e3          	bne	s1,s2,80004e84 <sys_exec+0xa4>
  return -1;
    80004e96:	557d                	li	a0,-1
    80004e98:	a081                	j	80004ed8 <sys_exec+0xf8>
      argv[i] = 0;
    80004e9a:	0009079b          	sext.w	a5,s2
    80004e9e:	078e                	sll	a5,a5,0x3
    80004ea0:	fd078793          	add	a5,a5,-48
    80004ea4:	97a2                	add	a5,a5,s0
    80004ea6:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004eaa:	e5040593          	add	a1,s0,-432
    80004eae:	f5040513          	add	a0,s0,-176
    80004eb2:	fffff097          	auipc	ra,0xfffff
    80004eb6:	194080e7          	jalr	404(ra) # 80004046 <exec>
    80004eba:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ebc:	f5040993          	add	s3,s0,-176
    80004ec0:	6088                	ld	a0,0(s1)
    80004ec2:	c901                	beqz	a0,80004ed2 <sys_exec+0xf2>
    kfree(argv[i]);
    80004ec4:	ffffb097          	auipc	ra,0xffffb
    80004ec8:	158080e7          	jalr	344(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ecc:	04a1                	add	s1,s1,8
    80004ece:	ff3499e3          	bne	s1,s3,80004ec0 <sys_exec+0xe0>
  return ret;
    80004ed2:	854a                	mv	a0,s2
    80004ed4:	a011                	j	80004ed8 <sys_exec+0xf8>
  return -1;
    80004ed6:	557d                	li	a0,-1
}
    80004ed8:	70fa                	ld	ra,440(sp)
    80004eda:	745a                	ld	s0,432(sp)
    80004edc:	74ba                	ld	s1,424(sp)
    80004ede:	791a                	ld	s2,416(sp)
    80004ee0:	69fa                	ld	s3,408(sp)
    80004ee2:	6a5a                	ld	s4,400(sp)
    80004ee4:	6139                	add	sp,sp,448
    80004ee6:	8082                	ret

0000000080004ee8 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ee8:	7139                	add	sp,sp,-64
    80004eea:	fc06                	sd	ra,56(sp)
    80004eec:	f822                	sd	s0,48(sp)
    80004eee:	f426                	sd	s1,40(sp)
    80004ef0:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ef2:	ffffc097          	auipc	ra,0xffffc
    80004ef6:	f5c080e7          	jalr	-164(ra) # 80000e4e <myproc>
    80004efa:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004efc:	fd840593          	add	a1,s0,-40
    80004f00:	4501                	li	a0,0
    80004f02:	ffffd097          	auipc	ra,0xffffd
    80004f06:	114080e7          	jalr	276(ra) # 80002016 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f0a:	fc840593          	add	a1,s0,-56
    80004f0e:	fd040513          	add	a0,s0,-48
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	dea080e7          	jalr	-534(ra) # 80003cfc <pipealloc>
    return -1;
    80004f1a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f1c:	0c054463          	bltz	a0,80004fe4 <sys_pipe+0xfc>
  fd0 = -1;
    80004f20:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f24:	fd043503          	ld	a0,-48(s0)
    80004f28:	fffff097          	auipc	ra,0xfffff
    80004f2c:	524080e7          	jalr	1316(ra) # 8000444c <fdalloc>
    80004f30:	fca42223          	sw	a0,-60(s0)
    80004f34:	08054b63          	bltz	a0,80004fca <sys_pipe+0xe2>
    80004f38:	fc843503          	ld	a0,-56(s0)
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	510080e7          	jalr	1296(ra) # 8000444c <fdalloc>
    80004f44:	fca42023          	sw	a0,-64(s0)
    80004f48:	06054863          	bltz	a0,80004fb8 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f4c:	4691                	li	a3,4
    80004f4e:	fc440613          	add	a2,s0,-60
    80004f52:	fd843583          	ld	a1,-40(s0)
    80004f56:	6ca8                	ld	a0,88(s1)
    80004f58:	ffffc097          	auipc	ra,0xffffc
    80004f5c:	bba080e7          	jalr	-1094(ra) # 80000b12 <copyout>
    80004f60:	02054063          	bltz	a0,80004f80 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f64:	4691                	li	a3,4
    80004f66:	fc040613          	add	a2,s0,-64
    80004f6a:	fd843583          	ld	a1,-40(s0)
    80004f6e:	0591                	add	a1,a1,4
    80004f70:	6ca8                	ld	a0,88(s1)
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	ba0080e7          	jalr	-1120(ra) # 80000b12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f7a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f7c:	06055463          	bgez	a0,80004fe4 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f80:	fc442783          	lw	a5,-60(s0)
    80004f84:	07e9                	add	a5,a5,26
    80004f86:	078e                	sll	a5,a5,0x3
    80004f88:	97a6                	add	a5,a5,s1
    80004f8a:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004f8e:	fc042783          	lw	a5,-64(s0)
    80004f92:	07e9                	add	a5,a5,26
    80004f94:	078e                	sll	a5,a5,0x3
    80004f96:	94be                	add	s1,s1,a5
    80004f98:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80004f9c:	fd043503          	ld	a0,-48(s0)
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	a30080e7          	jalr	-1488(ra) # 800039d0 <fileclose>
    fileclose(wf);
    80004fa8:	fc843503          	ld	a0,-56(s0)
    80004fac:	fffff097          	auipc	ra,0xfffff
    80004fb0:	a24080e7          	jalr	-1500(ra) # 800039d0 <fileclose>
    return -1;
    80004fb4:	57fd                	li	a5,-1
    80004fb6:	a03d                	j	80004fe4 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004fb8:	fc442783          	lw	a5,-60(s0)
    80004fbc:	0007c763          	bltz	a5,80004fca <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004fc0:	07e9                	add	a5,a5,26
    80004fc2:	078e                	sll	a5,a5,0x3
    80004fc4:	97a6                	add	a5,a5,s1
    80004fc6:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004fca:	fd043503          	ld	a0,-48(s0)
    80004fce:	fffff097          	auipc	ra,0xfffff
    80004fd2:	a02080e7          	jalr	-1534(ra) # 800039d0 <fileclose>
    fileclose(wf);
    80004fd6:	fc843503          	ld	a0,-56(s0)
    80004fda:	fffff097          	auipc	ra,0xfffff
    80004fde:	9f6080e7          	jalr	-1546(ra) # 800039d0 <fileclose>
    return -1;
    80004fe2:	57fd                	li	a5,-1
}
    80004fe4:	853e                	mv	a0,a5
    80004fe6:	70e2                	ld	ra,56(sp)
    80004fe8:	7442                	ld	s0,48(sp)
    80004fea:	74a2                	ld	s1,40(sp)
    80004fec:	6121                	add	sp,sp,64
    80004fee:	8082                	ret

0000000080004ff0 <kernelvec>:
    80004ff0:	7111                	add	sp,sp,-256
    80004ff2:	e006                	sd	ra,0(sp)
    80004ff4:	e40a                	sd	sp,8(sp)
    80004ff6:	e80e                	sd	gp,16(sp)
    80004ff8:	ec12                	sd	tp,24(sp)
    80004ffa:	f016                	sd	t0,32(sp)
    80004ffc:	f41a                	sd	t1,40(sp)
    80004ffe:	f81e                	sd	t2,48(sp)
    80005000:	fc22                	sd	s0,56(sp)
    80005002:	e0a6                	sd	s1,64(sp)
    80005004:	e4aa                	sd	a0,72(sp)
    80005006:	e8ae                	sd	a1,80(sp)
    80005008:	ecb2                	sd	a2,88(sp)
    8000500a:	f0b6                	sd	a3,96(sp)
    8000500c:	f4ba                	sd	a4,104(sp)
    8000500e:	f8be                	sd	a5,112(sp)
    80005010:	fcc2                	sd	a6,120(sp)
    80005012:	e146                	sd	a7,128(sp)
    80005014:	e54a                	sd	s2,136(sp)
    80005016:	e94e                	sd	s3,144(sp)
    80005018:	ed52                	sd	s4,152(sp)
    8000501a:	f156                	sd	s5,160(sp)
    8000501c:	f55a                	sd	s6,168(sp)
    8000501e:	f95e                	sd	s7,176(sp)
    80005020:	fd62                	sd	s8,184(sp)
    80005022:	e1e6                	sd	s9,192(sp)
    80005024:	e5ea                	sd	s10,200(sp)
    80005026:	e9ee                	sd	s11,208(sp)
    80005028:	edf2                	sd	t3,216(sp)
    8000502a:	f1f6                	sd	t4,224(sp)
    8000502c:	f5fa                	sd	t5,232(sp)
    8000502e:	f9fe                	sd	t6,240(sp)
    80005030:	df5fc0ef          	jal	80001e24 <kerneltrap>
    80005034:	6082                	ld	ra,0(sp)
    80005036:	6122                	ld	sp,8(sp)
    80005038:	61c2                	ld	gp,16(sp)
    8000503a:	7282                	ld	t0,32(sp)
    8000503c:	7322                	ld	t1,40(sp)
    8000503e:	73c2                	ld	t2,48(sp)
    80005040:	7462                	ld	s0,56(sp)
    80005042:	6486                	ld	s1,64(sp)
    80005044:	6526                	ld	a0,72(sp)
    80005046:	65c6                	ld	a1,80(sp)
    80005048:	6666                	ld	a2,88(sp)
    8000504a:	7686                	ld	a3,96(sp)
    8000504c:	7726                	ld	a4,104(sp)
    8000504e:	77c6                	ld	a5,112(sp)
    80005050:	7866                	ld	a6,120(sp)
    80005052:	688a                	ld	a7,128(sp)
    80005054:	692a                	ld	s2,136(sp)
    80005056:	69ca                	ld	s3,144(sp)
    80005058:	6a6a                	ld	s4,152(sp)
    8000505a:	7a8a                	ld	s5,160(sp)
    8000505c:	7b2a                	ld	s6,168(sp)
    8000505e:	7bca                	ld	s7,176(sp)
    80005060:	7c6a                	ld	s8,184(sp)
    80005062:	6c8e                	ld	s9,192(sp)
    80005064:	6d2e                	ld	s10,200(sp)
    80005066:	6dce                	ld	s11,208(sp)
    80005068:	6e6e                	ld	t3,216(sp)
    8000506a:	7e8e                	ld	t4,224(sp)
    8000506c:	7f2e                	ld	t5,232(sp)
    8000506e:	7fce                	ld	t6,240(sp)
    80005070:	6111                	add	sp,sp,256
    80005072:	10200073          	sret
    80005076:	00000013          	nop
    8000507a:	00000013          	nop
    8000507e:	0001                	nop

0000000080005080 <timervec>:
    80005080:	34051573          	csrrw	a0,mscratch,a0
    80005084:	e10c                	sd	a1,0(a0)
    80005086:	e510                	sd	a2,8(a0)
    80005088:	e914                	sd	a3,16(a0)
    8000508a:	6d0c                	ld	a1,24(a0)
    8000508c:	7110                	ld	a2,32(a0)
    8000508e:	6194                	ld	a3,0(a1)
    80005090:	96b2                	add	a3,a3,a2
    80005092:	e194                	sd	a3,0(a1)
    80005094:	4589                	li	a1,2
    80005096:	14459073          	csrw	sip,a1
    8000509a:	6914                	ld	a3,16(a0)
    8000509c:	6510                	ld	a2,8(a0)
    8000509e:	610c                	ld	a1,0(a0)
    800050a0:	34051573          	csrrw	a0,mscratch,a0
    800050a4:	30200073          	mret
	...

00000000800050aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050aa:	1141                	add	sp,sp,-16
    800050ac:	e422                	sd	s0,8(sp)
    800050ae:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050b0:	0c0007b7          	lui	a5,0xc000
    800050b4:	4705                	li	a4,1
    800050b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050b8:	c3d8                	sw	a4,4(a5)
}
    800050ba:	6422                	ld	s0,8(sp)
    800050bc:	0141                	add	sp,sp,16
    800050be:	8082                	ret

00000000800050c0 <plicinithart>:

void
plicinithart(void)
{
    800050c0:	1141                	add	sp,sp,-16
    800050c2:	e406                	sd	ra,8(sp)
    800050c4:	e022                	sd	s0,0(sp)
    800050c6:	0800                	add	s0,sp,16
  int hart = cpuid();
    800050c8:	ffffc097          	auipc	ra,0xffffc
    800050cc:	d5a080e7          	jalr	-678(ra) # 80000e22 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050d0:	0085171b          	sllw	a4,a0,0x8
    800050d4:	0c0027b7          	lui	a5,0xc002
    800050d8:	97ba                	add	a5,a5,a4
    800050da:	40200713          	li	a4,1026
    800050de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050e2:	00d5151b          	sllw	a0,a0,0xd
    800050e6:	0c2017b7          	lui	a5,0xc201
    800050ea:	97aa                	add	a5,a5,a0
    800050ec:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050f0:	60a2                	ld	ra,8(sp)
    800050f2:	6402                	ld	s0,0(sp)
    800050f4:	0141                	add	sp,sp,16
    800050f6:	8082                	ret

00000000800050f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050f8:	1141                	add	sp,sp,-16
    800050fa:	e406                	sd	ra,8(sp)
    800050fc:	e022                	sd	s0,0(sp)
    800050fe:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005100:	ffffc097          	auipc	ra,0xffffc
    80005104:	d22080e7          	jalr	-734(ra) # 80000e22 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005108:	00d5151b          	sllw	a0,a0,0xd
    8000510c:	0c2017b7          	lui	a5,0xc201
    80005110:	97aa                	add	a5,a5,a0
  return irq;
}
    80005112:	43c8                	lw	a0,4(a5)
    80005114:	60a2                	ld	ra,8(sp)
    80005116:	6402                	ld	s0,0(sp)
    80005118:	0141                	add	sp,sp,16
    8000511a:	8082                	ret

000000008000511c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000511c:	1101                	add	sp,sp,-32
    8000511e:	ec06                	sd	ra,24(sp)
    80005120:	e822                	sd	s0,16(sp)
    80005122:	e426                	sd	s1,8(sp)
    80005124:	1000                	add	s0,sp,32
    80005126:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005128:	ffffc097          	auipc	ra,0xffffc
    8000512c:	cfa080e7          	jalr	-774(ra) # 80000e22 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005130:	00d5151b          	sllw	a0,a0,0xd
    80005134:	0c2017b7          	lui	a5,0xc201
    80005138:	97aa                	add	a5,a5,a0
    8000513a:	c3c4                	sw	s1,4(a5)
}
    8000513c:	60e2                	ld	ra,24(sp)
    8000513e:	6442                	ld	s0,16(sp)
    80005140:	64a2                	ld	s1,8(sp)
    80005142:	6105                	add	sp,sp,32
    80005144:	8082                	ret

0000000080005146 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005146:	1141                	add	sp,sp,-16
    80005148:	e406                	sd	ra,8(sp)
    8000514a:	e022                	sd	s0,0(sp)
    8000514c:	0800                	add	s0,sp,16
  if(i >= NUM)
    8000514e:	479d                	li	a5,7
    80005150:	04a7cc63          	blt	a5,a0,800051a8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005154:	00015797          	auipc	a5,0x15
    80005158:	aac78793          	add	a5,a5,-1364 # 80019c00 <disk>
    8000515c:	97aa                	add	a5,a5,a0
    8000515e:	0187c783          	lbu	a5,24(a5)
    80005162:	ebb9                	bnez	a5,800051b8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005164:	00451693          	sll	a3,a0,0x4
    80005168:	00015797          	auipc	a5,0x15
    8000516c:	a9878793          	add	a5,a5,-1384 # 80019c00 <disk>
    80005170:	6398                	ld	a4,0(a5)
    80005172:	9736                	add	a4,a4,a3
    80005174:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005178:	6398                	ld	a4,0(a5)
    8000517a:	9736                	add	a4,a4,a3
    8000517c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005180:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005184:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005188:	97aa                	add	a5,a5,a0
    8000518a:	4705                	li	a4,1
    8000518c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005190:	00015517          	auipc	a0,0x15
    80005194:	a8850513          	add	a0,a0,-1400 # 80019c18 <disk+0x18>
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	450080e7          	jalr	1104(ra) # 800015e8 <wakeup>
}
    800051a0:	60a2                	ld	ra,8(sp)
    800051a2:	6402                	ld	s0,0(sp)
    800051a4:	0141                	add	sp,sp,16
    800051a6:	8082                	ret
    panic("free_desc 1");
    800051a8:	00003517          	auipc	a0,0x3
    800051ac:	56050513          	add	a0,a0,1376 # 80008708 <syscalls+0x338>
    800051b0:	00001097          	auipc	ra,0x1
    800051b4:	a06080e7          	jalr	-1530(ra) # 80005bb6 <panic>
    panic("free_desc 2");
    800051b8:	00003517          	auipc	a0,0x3
    800051bc:	56050513          	add	a0,a0,1376 # 80008718 <syscalls+0x348>
    800051c0:	00001097          	auipc	ra,0x1
    800051c4:	9f6080e7          	jalr	-1546(ra) # 80005bb6 <panic>

00000000800051c8 <virtio_disk_init>:
{
    800051c8:	1101                	add	sp,sp,-32
    800051ca:	ec06                	sd	ra,24(sp)
    800051cc:	e822                	sd	s0,16(sp)
    800051ce:	e426                	sd	s1,8(sp)
    800051d0:	e04a                	sd	s2,0(sp)
    800051d2:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051d4:	00003597          	auipc	a1,0x3
    800051d8:	55458593          	add	a1,a1,1364 # 80008728 <syscalls+0x358>
    800051dc:	00015517          	auipc	a0,0x15
    800051e0:	b4c50513          	add	a0,a0,-1204 # 80019d28 <disk+0x128>
    800051e4:	00001097          	auipc	ra,0x1
    800051e8:	e7a080e7          	jalr	-390(ra) # 8000605e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051ec:	100017b7          	lui	a5,0x10001
    800051f0:	4398                	lw	a4,0(a5)
    800051f2:	2701                	sext.w	a4,a4
    800051f4:	747277b7          	lui	a5,0x74727
    800051f8:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051fc:	14f71b63          	bne	a4,a5,80005352 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005200:	100017b7          	lui	a5,0x10001
    80005204:	43dc                	lw	a5,4(a5)
    80005206:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005208:	4709                	li	a4,2
    8000520a:	14e79463          	bne	a5,a4,80005352 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000520e:	100017b7          	lui	a5,0x10001
    80005212:	479c                	lw	a5,8(a5)
    80005214:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005216:	12e79e63          	bne	a5,a4,80005352 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000521a:	100017b7          	lui	a5,0x10001
    8000521e:	47d8                	lw	a4,12(a5)
    80005220:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005222:	554d47b7          	lui	a5,0x554d4
    80005226:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000522a:	12f71463          	bne	a4,a5,80005352 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000522e:	100017b7          	lui	a5,0x10001
    80005232:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005236:	4705                	li	a4,1
    80005238:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000523a:	470d                	li	a4,3
    8000523c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000523e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005240:	c7ffe6b7          	lui	a3,0xc7ffe
    80005244:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc7df>
    80005248:	8f75                	and	a4,a4,a3
    8000524a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000524c:	472d                	li	a4,11
    8000524e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005250:	5bbc                	lw	a5,112(a5)
    80005252:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005256:	8ba1                	and	a5,a5,8
    80005258:	10078563          	beqz	a5,80005362 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000525c:	100017b7          	lui	a5,0x10001
    80005260:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005264:	43fc                	lw	a5,68(a5)
    80005266:	2781                	sext.w	a5,a5
    80005268:	10079563          	bnez	a5,80005372 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000526c:	100017b7          	lui	a5,0x10001
    80005270:	5bdc                	lw	a5,52(a5)
    80005272:	2781                	sext.w	a5,a5
  if(max == 0)
    80005274:	10078763          	beqz	a5,80005382 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005278:	471d                	li	a4,7
    8000527a:	10f77c63          	bgeu	a4,a5,80005392 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000527e:	ffffb097          	auipc	ra,0xffffb
    80005282:	e9c080e7          	jalr	-356(ra) # 8000011a <kalloc>
    80005286:	00015497          	auipc	s1,0x15
    8000528a:	97a48493          	add	s1,s1,-1670 # 80019c00 <disk>
    8000528e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005290:	ffffb097          	auipc	ra,0xffffb
    80005294:	e8a080e7          	jalr	-374(ra) # 8000011a <kalloc>
    80005298:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000529a:	ffffb097          	auipc	ra,0xffffb
    8000529e:	e80080e7          	jalr	-384(ra) # 8000011a <kalloc>
    800052a2:	87aa                	mv	a5,a0
    800052a4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800052a6:	6088                	ld	a0,0(s1)
    800052a8:	cd6d                	beqz	a0,800053a2 <virtio_disk_init+0x1da>
    800052aa:	00015717          	auipc	a4,0x15
    800052ae:	95e73703          	ld	a4,-1698(a4) # 80019c08 <disk+0x8>
    800052b2:	cb65                	beqz	a4,800053a2 <virtio_disk_init+0x1da>
    800052b4:	c7fd                	beqz	a5,800053a2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800052b6:	6605                	lui	a2,0x1
    800052b8:	4581                	li	a1,0
    800052ba:	ffffb097          	auipc	ra,0xffffb
    800052be:	ec0080e7          	jalr	-320(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800052c2:	00015497          	auipc	s1,0x15
    800052c6:	93e48493          	add	s1,s1,-1730 # 80019c00 <disk>
    800052ca:	6605                	lui	a2,0x1
    800052cc:	4581                	li	a1,0
    800052ce:	6488                	ld	a0,8(s1)
    800052d0:	ffffb097          	auipc	ra,0xffffb
    800052d4:	eaa080e7          	jalr	-342(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800052d8:	6605                	lui	a2,0x1
    800052da:	4581                	li	a1,0
    800052dc:	6888                	ld	a0,16(s1)
    800052de:	ffffb097          	auipc	ra,0xffffb
    800052e2:	e9c080e7          	jalr	-356(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052e6:	100017b7          	lui	a5,0x10001
    800052ea:	4721                	li	a4,8
    800052ec:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052ee:	4098                	lw	a4,0(s1)
    800052f0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052f4:	40d8                	lw	a4,4(s1)
    800052f6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052fa:	6498                	ld	a4,8(s1)
    800052fc:	0007069b          	sext.w	a3,a4
    80005300:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005304:	9701                	sra	a4,a4,0x20
    80005306:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000530a:	6898                	ld	a4,16(s1)
    8000530c:	0007069b          	sext.w	a3,a4
    80005310:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005314:	9701                	sra	a4,a4,0x20
    80005316:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000531a:	4705                	li	a4,1
    8000531c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000531e:	00e48c23          	sb	a4,24(s1)
    80005322:	00e48ca3          	sb	a4,25(s1)
    80005326:	00e48d23          	sb	a4,26(s1)
    8000532a:	00e48da3          	sb	a4,27(s1)
    8000532e:	00e48e23          	sb	a4,28(s1)
    80005332:	00e48ea3          	sb	a4,29(s1)
    80005336:	00e48f23          	sb	a4,30(s1)
    8000533a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000533e:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005342:	0727a823          	sw	s2,112(a5)
}
    80005346:	60e2                	ld	ra,24(sp)
    80005348:	6442                	ld	s0,16(sp)
    8000534a:	64a2                	ld	s1,8(sp)
    8000534c:	6902                	ld	s2,0(sp)
    8000534e:	6105                	add	sp,sp,32
    80005350:	8082                	ret
    panic("could not find virtio disk");
    80005352:	00003517          	auipc	a0,0x3
    80005356:	3e650513          	add	a0,a0,998 # 80008738 <syscalls+0x368>
    8000535a:	00001097          	auipc	ra,0x1
    8000535e:	85c080e7          	jalr	-1956(ra) # 80005bb6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	3f650513          	add	a0,a0,1014 # 80008758 <syscalls+0x388>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	84c080e7          	jalr	-1972(ra) # 80005bb6 <panic>
    panic("virtio disk should not be ready");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	40650513          	add	a0,a0,1030 # 80008778 <syscalls+0x3a8>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	83c080e7          	jalr	-1988(ra) # 80005bb6 <panic>
    panic("virtio disk has no queue 0");
    80005382:	00003517          	auipc	a0,0x3
    80005386:	41650513          	add	a0,a0,1046 # 80008798 <syscalls+0x3c8>
    8000538a:	00001097          	auipc	ra,0x1
    8000538e:	82c080e7          	jalr	-2004(ra) # 80005bb6 <panic>
    panic("virtio disk max queue too short");
    80005392:	00003517          	auipc	a0,0x3
    80005396:	42650513          	add	a0,a0,1062 # 800087b8 <syscalls+0x3e8>
    8000539a:	00001097          	auipc	ra,0x1
    8000539e:	81c080e7          	jalr	-2020(ra) # 80005bb6 <panic>
    panic("virtio disk kalloc");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	43650513          	add	a0,a0,1078 # 800087d8 <syscalls+0x408>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	80c080e7          	jalr	-2036(ra) # 80005bb6 <panic>

00000000800053b2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053b2:	7159                	add	sp,sp,-112
    800053b4:	f486                	sd	ra,104(sp)
    800053b6:	f0a2                	sd	s0,96(sp)
    800053b8:	eca6                	sd	s1,88(sp)
    800053ba:	e8ca                	sd	s2,80(sp)
    800053bc:	e4ce                	sd	s3,72(sp)
    800053be:	e0d2                	sd	s4,64(sp)
    800053c0:	fc56                	sd	s5,56(sp)
    800053c2:	f85a                	sd	s6,48(sp)
    800053c4:	f45e                	sd	s7,40(sp)
    800053c6:	f062                	sd	s8,32(sp)
    800053c8:	ec66                	sd	s9,24(sp)
    800053ca:	e86a                	sd	s10,16(sp)
    800053cc:	1880                	add	s0,sp,112
    800053ce:	8a2a                	mv	s4,a0
    800053d0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053d2:	00c52c83          	lw	s9,12(a0)
    800053d6:	001c9c9b          	sllw	s9,s9,0x1
    800053da:	1c82                	sll	s9,s9,0x20
    800053dc:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053e0:	00015517          	auipc	a0,0x15
    800053e4:	94850513          	add	a0,a0,-1720 # 80019d28 <disk+0x128>
    800053e8:	00001097          	auipc	ra,0x1
    800053ec:	d06080e7          	jalr	-762(ra) # 800060ee <acquire>
  for(int i = 0; i < 3; i++){
    800053f0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800053f2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053f4:	00015b17          	auipc	s6,0x15
    800053f8:	80cb0b13          	add	s6,s6,-2036 # 80019c00 <disk>
  for(int i = 0; i < 3; i++){
    800053fc:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053fe:	00015c17          	auipc	s8,0x15
    80005402:	92ac0c13          	add	s8,s8,-1750 # 80019d28 <disk+0x128>
    80005406:	a095                	j	8000546a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005408:	00fb0733          	add	a4,s6,a5
    8000540c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005410:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005412:	0207c563          	bltz	a5,8000543c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005416:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005418:	0591                	add	a1,a1,4
    8000541a:	05560d63          	beq	a2,s5,80005474 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000541e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005420:	00014717          	auipc	a4,0x14
    80005424:	7e070713          	add	a4,a4,2016 # 80019c00 <disk>
    80005428:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000542a:	01874683          	lbu	a3,24(a4)
    8000542e:	fee9                	bnez	a3,80005408 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005430:	2785                	addw	a5,a5,1
    80005432:	0705                	add	a4,a4,1
    80005434:	fe979be3          	bne	a5,s1,8000542a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005438:	57fd                	li	a5,-1
    8000543a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000543c:	00c05e63          	blez	a2,80005458 <virtio_disk_rw+0xa6>
    80005440:	060a                	sll	a2,a2,0x2
    80005442:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005446:	0009a503          	lw	a0,0(s3)
    8000544a:	00000097          	auipc	ra,0x0
    8000544e:	cfc080e7          	jalr	-772(ra) # 80005146 <free_desc>
      for(int j = 0; j < i; j++)
    80005452:	0991                	add	s3,s3,4
    80005454:	ffa999e3          	bne	s3,s10,80005446 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005458:	85e2                	mv	a1,s8
    8000545a:	00014517          	auipc	a0,0x14
    8000545e:	7be50513          	add	a0,a0,1982 # 80019c18 <disk+0x18>
    80005462:	ffffc097          	auipc	ra,0xffffc
    80005466:	122080e7          	jalr	290(ra) # 80001584 <sleep>
  for(int i = 0; i < 3; i++){
    8000546a:	f9040993          	add	s3,s0,-112
{
    8000546e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005470:	864a                	mv	a2,s2
    80005472:	b775                	j	8000541e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005474:	f9042503          	lw	a0,-112(s0)
    80005478:	00a50713          	add	a4,a0,10
    8000547c:	0712                	sll	a4,a4,0x4

  if(write)
    8000547e:	00014797          	auipc	a5,0x14
    80005482:	78278793          	add	a5,a5,1922 # 80019c00 <disk>
    80005486:	00e786b3          	add	a3,a5,a4
    8000548a:	01703633          	snez	a2,s7
    8000548e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005490:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005494:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005498:	f6070613          	add	a2,a4,-160
    8000549c:	6394                	ld	a3,0(a5)
    8000549e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054a0:	00870593          	add	a1,a4,8
    800054a4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800054a6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054a8:	0007b803          	ld	a6,0(a5)
    800054ac:	9642                	add	a2,a2,a6
    800054ae:	46c1                	li	a3,16
    800054b0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054b2:	4585                	li	a1,1
    800054b4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800054b8:	f9442683          	lw	a3,-108(s0)
    800054bc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054c0:	0692                	sll	a3,a3,0x4
    800054c2:	9836                	add	a6,a6,a3
    800054c4:	058a0613          	add	a2,s4,88
    800054c8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800054cc:	0007b803          	ld	a6,0(a5)
    800054d0:	96c2                	add	a3,a3,a6
    800054d2:	40000613          	li	a2,1024
    800054d6:	c690                	sw	a2,8(a3)
  if(write)
    800054d8:	001bb613          	seqz	a2,s7
    800054dc:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054e0:	00166613          	or	a2,a2,1
    800054e4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800054e8:	f9842603          	lw	a2,-104(s0)
    800054ec:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054f0:	00250693          	add	a3,a0,2
    800054f4:	0692                	sll	a3,a3,0x4
    800054f6:	96be                	add	a3,a3,a5
    800054f8:	58fd                	li	a7,-1
    800054fa:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054fe:	0612                	sll	a2,a2,0x4
    80005500:	9832                	add	a6,a6,a2
    80005502:	f9070713          	add	a4,a4,-112
    80005506:	973e                	add	a4,a4,a5
    80005508:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000550c:	6398                	ld	a4,0(a5)
    8000550e:	9732                	add	a4,a4,a2
    80005510:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005512:	4609                	li	a2,2
    80005514:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005518:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000551c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005520:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005524:	6794                	ld	a3,8(a5)
    80005526:	0026d703          	lhu	a4,2(a3)
    8000552a:	8b1d                	and	a4,a4,7
    8000552c:	0706                	sll	a4,a4,0x1
    8000552e:	96ba                	add	a3,a3,a4
    80005530:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005534:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005538:	6798                	ld	a4,8(a5)
    8000553a:	00275783          	lhu	a5,2(a4)
    8000553e:	2785                	addw	a5,a5,1
    80005540:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005544:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005548:	100017b7          	lui	a5,0x10001
    8000554c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005550:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005554:	00014917          	auipc	s2,0x14
    80005558:	7d490913          	add	s2,s2,2004 # 80019d28 <disk+0x128>
  while(b->disk == 1) {
    8000555c:	4485                	li	s1,1
    8000555e:	00b79c63          	bne	a5,a1,80005576 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005562:	85ca                	mv	a1,s2
    80005564:	8552                	mv	a0,s4
    80005566:	ffffc097          	auipc	ra,0xffffc
    8000556a:	01e080e7          	jalr	30(ra) # 80001584 <sleep>
  while(b->disk == 1) {
    8000556e:	004a2783          	lw	a5,4(s4)
    80005572:	fe9788e3          	beq	a5,s1,80005562 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005576:	f9042903          	lw	s2,-112(s0)
    8000557a:	00290713          	add	a4,s2,2
    8000557e:	0712                	sll	a4,a4,0x4
    80005580:	00014797          	auipc	a5,0x14
    80005584:	68078793          	add	a5,a5,1664 # 80019c00 <disk>
    80005588:	97ba                	add	a5,a5,a4
    8000558a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000558e:	00014997          	auipc	s3,0x14
    80005592:	67298993          	add	s3,s3,1650 # 80019c00 <disk>
    80005596:	00491713          	sll	a4,s2,0x4
    8000559a:	0009b783          	ld	a5,0(s3)
    8000559e:	97ba                	add	a5,a5,a4
    800055a0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055a4:	854a                	mv	a0,s2
    800055a6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055aa:	00000097          	auipc	ra,0x0
    800055ae:	b9c080e7          	jalr	-1124(ra) # 80005146 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055b2:	8885                	and	s1,s1,1
    800055b4:	f0ed                	bnez	s1,80005596 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055b6:	00014517          	auipc	a0,0x14
    800055ba:	77250513          	add	a0,a0,1906 # 80019d28 <disk+0x128>
    800055be:	00001097          	auipc	ra,0x1
    800055c2:	be4080e7          	jalr	-1052(ra) # 800061a2 <release>
}
    800055c6:	70a6                	ld	ra,104(sp)
    800055c8:	7406                	ld	s0,96(sp)
    800055ca:	64e6                	ld	s1,88(sp)
    800055cc:	6946                	ld	s2,80(sp)
    800055ce:	69a6                	ld	s3,72(sp)
    800055d0:	6a06                	ld	s4,64(sp)
    800055d2:	7ae2                	ld	s5,56(sp)
    800055d4:	7b42                	ld	s6,48(sp)
    800055d6:	7ba2                	ld	s7,40(sp)
    800055d8:	7c02                	ld	s8,32(sp)
    800055da:	6ce2                	ld	s9,24(sp)
    800055dc:	6d42                	ld	s10,16(sp)
    800055de:	6165                	add	sp,sp,112
    800055e0:	8082                	ret

00000000800055e2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055e2:	1101                	add	sp,sp,-32
    800055e4:	ec06                	sd	ra,24(sp)
    800055e6:	e822                	sd	s0,16(sp)
    800055e8:	e426                	sd	s1,8(sp)
    800055ea:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055ec:	00014497          	auipc	s1,0x14
    800055f0:	61448493          	add	s1,s1,1556 # 80019c00 <disk>
    800055f4:	00014517          	auipc	a0,0x14
    800055f8:	73450513          	add	a0,a0,1844 # 80019d28 <disk+0x128>
    800055fc:	00001097          	auipc	ra,0x1
    80005600:	af2080e7          	jalr	-1294(ra) # 800060ee <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005604:	10001737          	lui	a4,0x10001
    80005608:	533c                	lw	a5,96(a4)
    8000560a:	8b8d                	and	a5,a5,3
    8000560c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000560e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005612:	689c                	ld	a5,16(s1)
    80005614:	0204d703          	lhu	a4,32(s1)
    80005618:	0027d783          	lhu	a5,2(a5)
    8000561c:	04f70863          	beq	a4,a5,8000566c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005620:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005624:	6898                	ld	a4,16(s1)
    80005626:	0204d783          	lhu	a5,32(s1)
    8000562a:	8b9d                	and	a5,a5,7
    8000562c:	078e                	sll	a5,a5,0x3
    8000562e:	97ba                	add	a5,a5,a4
    80005630:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005632:	00278713          	add	a4,a5,2
    80005636:	0712                	sll	a4,a4,0x4
    80005638:	9726                	add	a4,a4,s1
    8000563a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000563e:	e721                	bnez	a4,80005686 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005640:	0789                	add	a5,a5,2
    80005642:	0792                	sll	a5,a5,0x4
    80005644:	97a6                	add	a5,a5,s1
    80005646:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005648:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000564c:	ffffc097          	auipc	ra,0xffffc
    80005650:	f9c080e7          	jalr	-100(ra) # 800015e8 <wakeup>

    disk.used_idx += 1;
    80005654:	0204d783          	lhu	a5,32(s1)
    80005658:	2785                	addw	a5,a5,1
    8000565a:	17c2                	sll	a5,a5,0x30
    8000565c:	93c1                	srl	a5,a5,0x30
    8000565e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005662:	6898                	ld	a4,16(s1)
    80005664:	00275703          	lhu	a4,2(a4)
    80005668:	faf71ce3          	bne	a4,a5,80005620 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000566c:	00014517          	auipc	a0,0x14
    80005670:	6bc50513          	add	a0,a0,1724 # 80019d28 <disk+0x128>
    80005674:	00001097          	auipc	ra,0x1
    80005678:	b2e080e7          	jalr	-1234(ra) # 800061a2 <release>
}
    8000567c:	60e2                	ld	ra,24(sp)
    8000567e:	6442                	ld	s0,16(sp)
    80005680:	64a2                	ld	s1,8(sp)
    80005682:	6105                	add	sp,sp,32
    80005684:	8082                	ret
      panic("virtio_disk_intr status");
    80005686:	00003517          	auipc	a0,0x3
    8000568a:	16a50513          	add	a0,a0,362 # 800087f0 <syscalls+0x420>
    8000568e:	00000097          	auipc	ra,0x0
    80005692:	528080e7          	jalr	1320(ra) # 80005bb6 <panic>

0000000080005696 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005696:	1141                	add	sp,sp,-16
    80005698:	e422                	sd	s0,8(sp)
    8000569a:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000569c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056a0:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056a4:	0037979b          	sllw	a5,a5,0x3
    800056a8:	02004737          	lui	a4,0x2004
    800056ac:	97ba                	add	a5,a5,a4
    800056ae:	0200c737          	lui	a4,0x200c
    800056b2:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800056b6:	000f4637          	lui	a2,0xf4
    800056ba:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800056be:	9732                	add	a4,a4,a2
    800056c0:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800056c2:	00259693          	sll	a3,a1,0x2
    800056c6:	96ae                	add	a3,a3,a1
    800056c8:	068e                	sll	a3,a3,0x3
    800056ca:	00014717          	auipc	a4,0x14
    800056ce:	67670713          	add	a4,a4,1654 # 80019d40 <timer_scratch>
    800056d2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056d4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056d6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056d8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800056dc:	00000797          	auipc	a5,0x0
    800056e0:	9a478793          	add	a5,a5,-1628 # 80005080 <timervec>
    800056e4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056e8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800056ec:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056f0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056f4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800056f8:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800056fc:	30479073          	csrw	mie,a5
}
    80005700:	6422                	ld	s0,8(sp)
    80005702:	0141                	add	sp,sp,16
    80005704:	8082                	ret

0000000080005706 <start>:
{
    80005706:	1141                	add	sp,sp,-16
    80005708:	e406                	sd	ra,8(sp)
    8000570a:	e022                	sd	s0,0(sp)
    8000570c:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000570e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005712:	7779                	lui	a4,0xffffe
    80005714:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc87f>
    80005718:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000571a:	6705                	lui	a4,0x1
    8000571c:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005720:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005722:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005726:	ffffb797          	auipc	a5,0xffffb
    8000572a:	bf878793          	add	a5,a5,-1032 # 8000031e <main>
    8000572e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005732:	4781                	li	a5,0
    80005734:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005738:	67c1                	lui	a5,0x10
    8000573a:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000573c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005740:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005744:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005748:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000574c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005750:	57fd                	li	a5,-1
    80005752:	83a9                	srl	a5,a5,0xa
    80005754:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005758:	47bd                	li	a5,15
    8000575a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000575e:	00000097          	auipc	ra,0x0
    80005762:	f38080e7          	jalr	-200(ra) # 80005696 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005766:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000576a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000576c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000576e:	30200073          	mret
}
    80005772:	60a2                	ld	ra,8(sp)
    80005774:	6402                	ld	s0,0(sp)
    80005776:	0141                	add	sp,sp,16
    80005778:	8082                	ret

000000008000577a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000577a:	715d                	add	sp,sp,-80
    8000577c:	e486                	sd	ra,72(sp)
    8000577e:	e0a2                	sd	s0,64(sp)
    80005780:	fc26                	sd	s1,56(sp)
    80005782:	f84a                	sd	s2,48(sp)
    80005784:	f44e                	sd	s3,40(sp)
    80005786:	f052                	sd	s4,32(sp)
    80005788:	ec56                	sd	s5,24(sp)
    8000578a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000578c:	04c05763          	blez	a2,800057da <consolewrite+0x60>
    80005790:	8a2a                	mv	s4,a0
    80005792:	84ae                	mv	s1,a1
    80005794:	89b2                	mv	s3,a2
    80005796:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005798:	5afd                	li	s5,-1
    8000579a:	4685                	li	a3,1
    8000579c:	8626                	mv	a2,s1
    8000579e:	85d2                	mv	a1,s4
    800057a0:	fbf40513          	add	a0,s0,-65
    800057a4:	ffffc097          	auipc	ra,0xffffc
    800057a8:	23e080e7          	jalr	574(ra) # 800019e2 <either_copyin>
    800057ac:	01550d63          	beq	a0,s5,800057c6 <consolewrite+0x4c>
      break;
    uartputc(c);
    800057b0:	fbf44503          	lbu	a0,-65(s0)
    800057b4:	00000097          	auipc	ra,0x0
    800057b8:	780080e7          	jalr	1920(ra) # 80005f34 <uartputc>
  for(i = 0; i < n; i++){
    800057bc:	2905                	addw	s2,s2,1
    800057be:	0485                	add	s1,s1,1
    800057c0:	fd299de3          	bne	s3,s2,8000579a <consolewrite+0x20>
    800057c4:	894e                	mv	s2,s3
  }

  return i;
}
    800057c6:	854a                	mv	a0,s2
    800057c8:	60a6                	ld	ra,72(sp)
    800057ca:	6406                	ld	s0,64(sp)
    800057cc:	74e2                	ld	s1,56(sp)
    800057ce:	7942                	ld	s2,48(sp)
    800057d0:	79a2                	ld	s3,40(sp)
    800057d2:	7a02                	ld	s4,32(sp)
    800057d4:	6ae2                	ld	s5,24(sp)
    800057d6:	6161                	add	sp,sp,80
    800057d8:	8082                	ret
  for(i = 0; i < n; i++){
    800057da:	4901                	li	s2,0
    800057dc:	b7ed                	j	800057c6 <consolewrite+0x4c>

00000000800057de <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800057de:	711d                	add	sp,sp,-96
    800057e0:	ec86                	sd	ra,88(sp)
    800057e2:	e8a2                	sd	s0,80(sp)
    800057e4:	e4a6                	sd	s1,72(sp)
    800057e6:	e0ca                	sd	s2,64(sp)
    800057e8:	fc4e                	sd	s3,56(sp)
    800057ea:	f852                	sd	s4,48(sp)
    800057ec:	f456                	sd	s5,40(sp)
    800057ee:	f05a                	sd	s6,32(sp)
    800057f0:	ec5e                	sd	s7,24(sp)
    800057f2:	1080                	add	s0,sp,96
    800057f4:	8aaa                	mv	s5,a0
    800057f6:	8a2e                	mv	s4,a1
    800057f8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057fa:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057fe:	0001c517          	auipc	a0,0x1c
    80005802:	68250513          	add	a0,a0,1666 # 80021e80 <cons>
    80005806:	00001097          	auipc	ra,0x1
    8000580a:	8e8080e7          	jalr	-1816(ra) # 800060ee <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000580e:	0001c497          	auipc	s1,0x1c
    80005812:	67248493          	add	s1,s1,1650 # 80021e80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005816:	0001c917          	auipc	s2,0x1c
    8000581a:	70290913          	add	s2,s2,1794 # 80021f18 <cons+0x98>
  while(n > 0){
    8000581e:	09305263          	blez	s3,800058a2 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005822:	0984a783          	lw	a5,152(s1)
    80005826:	09c4a703          	lw	a4,156(s1)
    8000582a:	02f71763          	bne	a4,a5,80005858 <consoleread+0x7a>
      if(killed(myproc())){
    8000582e:	ffffb097          	auipc	ra,0xffffb
    80005832:	620080e7          	jalr	1568(ra) # 80000e4e <myproc>
    80005836:	ffffc097          	auipc	ra,0xffffc
    8000583a:	ff6080e7          	jalr	-10(ra) # 8000182c <killed>
    8000583e:	ed2d                	bnez	a0,800058b8 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005840:	85a6                	mv	a1,s1
    80005842:	854a                	mv	a0,s2
    80005844:	ffffc097          	auipc	ra,0xffffc
    80005848:	d40080e7          	jalr	-704(ra) # 80001584 <sleep>
    while(cons.r == cons.w){
    8000584c:	0984a783          	lw	a5,152(s1)
    80005850:	09c4a703          	lw	a4,156(s1)
    80005854:	fcf70de3          	beq	a4,a5,8000582e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005858:	0001c717          	auipc	a4,0x1c
    8000585c:	62870713          	add	a4,a4,1576 # 80021e80 <cons>
    80005860:	0017869b          	addw	a3,a5,1
    80005864:	08d72c23          	sw	a3,152(a4)
    80005868:	07f7f693          	and	a3,a5,127
    8000586c:	9736                	add	a4,a4,a3
    8000586e:	01874703          	lbu	a4,24(a4)
    80005872:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005876:	4691                	li	a3,4
    80005878:	06db8463          	beq	s7,a3,800058e0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000587c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005880:	4685                	li	a3,1
    80005882:	faf40613          	add	a2,s0,-81
    80005886:	85d2                	mv	a1,s4
    80005888:	8556                	mv	a0,s5
    8000588a:	ffffc097          	auipc	ra,0xffffc
    8000588e:	102080e7          	jalr	258(ra) # 8000198c <either_copyout>
    80005892:	57fd                	li	a5,-1
    80005894:	00f50763          	beq	a0,a5,800058a2 <consoleread+0xc4>
      break;

    dst++;
    80005898:	0a05                	add	s4,s4,1
    --n;
    8000589a:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    8000589c:	47a9                	li	a5,10
    8000589e:	f8fb90e3          	bne	s7,a5,8000581e <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058a2:	0001c517          	auipc	a0,0x1c
    800058a6:	5de50513          	add	a0,a0,1502 # 80021e80 <cons>
    800058aa:	00001097          	auipc	ra,0x1
    800058ae:	8f8080e7          	jalr	-1800(ra) # 800061a2 <release>

  return target - n;
    800058b2:	413b053b          	subw	a0,s6,s3
    800058b6:	a811                	j	800058ca <consoleread+0xec>
        release(&cons.lock);
    800058b8:	0001c517          	auipc	a0,0x1c
    800058bc:	5c850513          	add	a0,a0,1480 # 80021e80 <cons>
    800058c0:	00001097          	auipc	ra,0x1
    800058c4:	8e2080e7          	jalr	-1822(ra) # 800061a2 <release>
        return -1;
    800058c8:	557d                	li	a0,-1
}
    800058ca:	60e6                	ld	ra,88(sp)
    800058cc:	6446                	ld	s0,80(sp)
    800058ce:	64a6                	ld	s1,72(sp)
    800058d0:	6906                	ld	s2,64(sp)
    800058d2:	79e2                	ld	s3,56(sp)
    800058d4:	7a42                	ld	s4,48(sp)
    800058d6:	7aa2                	ld	s5,40(sp)
    800058d8:	7b02                	ld	s6,32(sp)
    800058da:	6be2                	ld	s7,24(sp)
    800058dc:	6125                	add	sp,sp,96
    800058de:	8082                	ret
      if(n < target){
    800058e0:	0009871b          	sext.w	a4,s3
    800058e4:	fb677fe3          	bgeu	a4,s6,800058a2 <consoleread+0xc4>
        cons.r--;
    800058e8:	0001c717          	auipc	a4,0x1c
    800058ec:	62f72823          	sw	a5,1584(a4) # 80021f18 <cons+0x98>
    800058f0:	bf4d                	j	800058a2 <consoleread+0xc4>

00000000800058f2 <consputc>:
{
    800058f2:	1141                	add	sp,sp,-16
    800058f4:	e406                	sd	ra,8(sp)
    800058f6:	e022                	sd	s0,0(sp)
    800058f8:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    800058fa:	10000793          	li	a5,256
    800058fe:	00f50a63          	beq	a0,a5,80005912 <consputc+0x20>
    uartputc_sync(c);
    80005902:	00000097          	auipc	ra,0x0
    80005906:	560080e7          	jalr	1376(ra) # 80005e62 <uartputc_sync>
}
    8000590a:	60a2                	ld	ra,8(sp)
    8000590c:	6402                	ld	s0,0(sp)
    8000590e:	0141                	add	sp,sp,16
    80005910:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005912:	4521                	li	a0,8
    80005914:	00000097          	auipc	ra,0x0
    80005918:	54e080e7          	jalr	1358(ra) # 80005e62 <uartputc_sync>
    8000591c:	02000513          	li	a0,32
    80005920:	00000097          	auipc	ra,0x0
    80005924:	542080e7          	jalr	1346(ra) # 80005e62 <uartputc_sync>
    80005928:	4521                	li	a0,8
    8000592a:	00000097          	auipc	ra,0x0
    8000592e:	538080e7          	jalr	1336(ra) # 80005e62 <uartputc_sync>
    80005932:	bfe1                	j	8000590a <consputc+0x18>

0000000080005934 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005934:	1101                	add	sp,sp,-32
    80005936:	ec06                	sd	ra,24(sp)
    80005938:	e822                	sd	s0,16(sp)
    8000593a:	e426                	sd	s1,8(sp)
    8000593c:	e04a                	sd	s2,0(sp)
    8000593e:	1000                	add	s0,sp,32
    80005940:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005942:	0001c517          	auipc	a0,0x1c
    80005946:	53e50513          	add	a0,a0,1342 # 80021e80 <cons>
    8000594a:	00000097          	auipc	ra,0x0
    8000594e:	7a4080e7          	jalr	1956(ra) # 800060ee <acquire>

  switch(c){
    80005952:	47d5                	li	a5,21
    80005954:	0af48663          	beq	s1,a5,80005a00 <consoleintr+0xcc>
    80005958:	0297ca63          	blt	a5,s1,8000598c <consoleintr+0x58>
    8000595c:	47a1                	li	a5,8
    8000595e:	0ef48763          	beq	s1,a5,80005a4c <consoleintr+0x118>
    80005962:	47c1                	li	a5,16
    80005964:	10f49a63          	bne	s1,a5,80005a78 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005968:	ffffc097          	auipc	ra,0xffffc
    8000596c:	0d0080e7          	jalr	208(ra) # 80001a38 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005970:	0001c517          	auipc	a0,0x1c
    80005974:	51050513          	add	a0,a0,1296 # 80021e80 <cons>
    80005978:	00001097          	auipc	ra,0x1
    8000597c:	82a080e7          	jalr	-2006(ra) # 800061a2 <release>
}
    80005980:	60e2                	ld	ra,24(sp)
    80005982:	6442                	ld	s0,16(sp)
    80005984:	64a2                	ld	s1,8(sp)
    80005986:	6902                	ld	s2,0(sp)
    80005988:	6105                	add	sp,sp,32
    8000598a:	8082                	ret
  switch(c){
    8000598c:	07f00793          	li	a5,127
    80005990:	0af48e63          	beq	s1,a5,80005a4c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005994:	0001c717          	auipc	a4,0x1c
    80005998:	4ec70713          	add	a4,a4,1260 # 80021e80 <cons>
    8000599c:	0a072783          	lw	a5,160(a4)
    800059a0:	09872703          	lw	a4,152(a4)
    800059a4:	9f99                	subw	a5,a5,a4
    800059a6:	07f00713          	li	a4,127
    800059aa:	fcf763e3          	bltu	a4,a5,80005970 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800059ae:	47b5                	li	a5,13
    800059b0:	0cf48763          	beq	s1,a5,80005a7e <consoleintr+0x14a>
      consputc(c);
    800059b4:	8526                	mv	a0,s1
    800059b6:	00000097          	auipc	ra,0x0
    800059ba:	f3c080e7          	jalr	-196(ra) # 800058f2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800059be:	0001c797          	auipc	a5,0x1c
    800059c2:	4c278793          	add	a5,a5,1218 # 80021e80 <cons>
    800059c6:	0a07a683          	lw	a3,160(a5)
    800059ca:	0016871b          	addw	a4,a3,1
    800059ce:	0007061b          	sext.w	a2,a4
    800059d2:	0ae7a023          	sw	a4,160(a5)
    800059d6:	07f6f693          	and	a3,a3,127
    800059da:	97b6                	add	a5,a5,a3
    800059dc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800059e0:	47a9                	li	a5,10
    800059e2:	0cf48563          	beq	s1,a5,80005aac <consoleintr+0x178>
    800059e6:	4791                	li	a5,4
    800059e8:	0cf48263          	beq	s1,a5,80005aac <consoleintr+0x178>
    800059ec:	0001c797          	auipc	a5,0x1c
    800059f0:	52c7a783          	lw	a5,1324(a5) # 80021f18 <cons+0x98>
    800059f4:	9f1d                	subw	a4,a4,a5
    800059f6:	08000793          	li	a5,128
    800059fa:	f6f71be3          	bne	a4,a5,80005970 <consoleintr+0x3c>
    800059fe:	a07d                	j	80005aac <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a00:	0001c717          	auipc	a4,0x1c
    80005a04:	48070713          	add	a4,a4,1152 # 80021e80 <cons>
    80005a08:	0a072783          	lw	a5,160(a4)
    80005a0c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a10:	0001c497          	auipc	s1,0x1c
    80005a14:	47048493          	add	s1,s1,1136 # 80021e80 <cons>
    while(cons.e != cons.w &&
    80005a18:	4929                	li	s2,10
    80005a1a:	f4f70be3          	beq	a4,a5,80005970 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a1e:	37fd                	addw	a5,a5,-1
    80005a20:	07f7f713          	and	a4,a5,127
    80005a24:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a26:	01874703          	lbu	a4,24(a4)
    80005a2a:	f52703e3          	beq	a4,s2,80005970 <consoleintr+0x3c>
      cons.e--;
    80005a2e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a32:	10000513          	li	a0,256
    80005a36:	00000097          	auipc	ra,0x0
    80005a3a:	ebc080e7          	jalr	-324(ra) # 800058f2 <consputc>
    while(cons.e != cons.w &&
    80005a3e:	0a04a783          	lw	a5,160(s1)
    80005a42:	09c4a703          	lw	a4,156(s1)
    80005a46:	fcf71ce3          	bne	a4,a5,80005a1e <consoleintr+0xea>
    80005a4a:	b71d                	j	80005970 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a4c:	0001c717          	auipc	a4,0x1c
    80005a50:	43470713          	add	a4,a4,1076 # 80021e80 <cons>
    80005a54:	0a072783          	lw	a5,160(a4)
    80005a58:	09c72703          	lw	a4,156(a4)
    80005a5c:	f0f70ae3          	beq	a4,a5,80005970 <consoleintr+0x3c>
      cons.e--;
    80005a60:	37fd                	addw	a5,a5,-1
    80005a62:	0001c717          	auipc	a4,0x1c
    80005a66:	4af72f23          	sw	a5,1214(a4) # 80021f20 <cons+0xa0>
      consputc(BACKSPACE);
    80005a6a:	10000513          	li	a0,256
    80005a6e:	00000097          	auipc	ra,0x0
    80005a72:	e84080e7          	jalr	-380(ra) # 800058f2 <consputc>
    80005a76:	bded                	j	80005970 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a78:	ee048ce3          	beqz	s1,80005970 <consoleintr+0x3c>
    80005a7c:	bf21                	j	80005994 <consoleintr+0x60>
      consputc(c);
    80005a7e:	4529                	li	a0,10
    80005a80:	00000097          	auipc	ra,0x0
    80005a84:	e72080e7          	jalr	-398(ra) # 800058f2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a88:	0001c797          	auipc	a5,0x1c
    80005a8c:	3f878793          	add	a5,a5,1016 # 80021e80 <cons>
    80005a90:	0a07a703          	lw	a4,160(a5)
    80005a94:	0017069b          	addw	a3,a4,1
    80005a98:	0006861b          	sext.w	a2,a3
    80005a9c:	0ad7a023          	sw	a3,160(a5)
    80005aa0:	07f77713          	and	a4,a4,127
    80005aa4:	97ba                	add	a5,a5,a4
    80005aa6:	4729                	li	a4,10
    80005aa8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005aac:	0001c797          	auipc	a5,0x1c
    80005ab0:	46c7a823          	sw	a2,1136(a5) # 80021f1c <cons+0x9c>
        wakeup(&cons.r);
    80005ab4:	0001c517          	auipc	a0,0x1c
    80005ab8:	46450513          	add	a0,a0,1124 # 80021f18 <cons+0x98>
    80005abc:	ffffc097          	auipc	ra,0xffffc
    80005ac0:	b2c080e7          	jalr	-1236(ra) # 800015e8 <wakeup>
    80005ac4:	b575                	j	80005970 <consoleintr+0x3c>

0000000080005ac6 <consoleinit>:

void
consoleinit(void)
{
    80005ac6:	1141                	add	sp,sp,-16
    80005ac8:	e406                	sd	ra,8(sp)
    80005aca:	e022                	sd	s0,0(sp)
    80005acc:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ace:	00003597          	auipc	a1,0x3
    80005ad2:	d3a58593          	add	a1,a1,-710 # 80008808 <syscalls+0x438>
    80005ad6:	0001c517          	auipc	a0,0x1c
    80005ada:	3aa50513          	add	a0,a0,938 # 80021e80 <cons>
    80005ade:	00000097          	auipc	ra,0x0
    80005ae2:	580080e7          	jalr	1408(ra) # 8000605e <initlock>

  uartinit();
    80005ae6:	00000097          	auipc	ra,0x0
    80005aea:	32c080e7          	jalr	812(ra) # 80005e12 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005aee:	00013797          	auipc	a5,0x13
    80005af2:	0ba78793          	add	a5,a5,186 # 80018ba8 <devsw>
    80005af6:	00000717          	auipc	a4,0x0
    80005afa:	ce870713          	add	a4,a4,-792 # 800057de <consoleread>
    80005afe:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b00:	00000717          	auipc	a4,0x0
    80005b04:	c7a70713          	add	a4,a4,-902 # 8000577a <consolewrite>
    80005b08:	ef98                	sd	a4,24(a5)
}
    80005b0a:	60a2                	ld	ra,8(sp)
    80005b0c:	6402                	ld	s0,0(sp)
    80005b0e:	0141                	add	sp,sp,16
    80005b10:	8082                	ret

0000000080005b12 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b12:	7179                	add	sp,sp,-48
    80005b14:	f406                	sd	ra,40(sp)
    80005b16:	f022                	sd	s0,32(sp)
    80005b18:	ec26                	sd	s1,24(sp)
    80005b1a:	e84a                	sd	s2,16(sp)
    80005b1c:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b1e:	c219                	beqz	a2,80005b24 <printint+0x12>
    80005b20:	08054763          	bltz	a0,80005bae <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b24:	2501                	sext.w	a0,a0
    80005b26:	4881                	li	a7,0
    80005b28:	fd040693          	add	a3,s0,-48

  i = 0;
    80005b2c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b2e:	2581                	sext.w	a1,a1
    80005b30:	00003617          	auipc	a2,0x3
    80005b34:	d0860613          	add	a2,a2,-760 # 80008838 <digits>
    80005b38:	883a                	mv	a6,a4
    80005b3a:	2705                	addw	a4,a4,1
    80005b3c:	02b577bb          	remuw	a5,a0,a1
    80005b40:	1782                	sll	a5,a5,0x20
    80005b42:	9381                	srl	a5,a5,0x20
    80005b44:	97b2                	add	a5,a5,a2
    80005b46:	0007c783          	lbu	a5,0(a5)
    80005b4a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b4e:	0005079b          	sext.w	a5,a0
    80005b52:	02b5553b          	divuw	a0,a0,a1
    80005b56:	0685                	add	a3,a3,1
    80005b58:	feb7f0e3          	bgeu	a5,a1,80005b38 <printint+0x26>

  if(sign)
    80005b5c:	00088c63          	beqz	a7,80005b74 <printint+0x62>
    buf[i++] = '-';
    80005b60:	fe070793          	add	a5,a4,-32
    80005b64:	00878733          	add	a4,a5,s0
    80005b68:	02d00793          	li	a5,45
    80005b6c:	fef70823          	sb	a5,-16(a4)
    80005b70:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005b74:	02e05763          	blez	a4,80005ba2 <printint+0x90>
    80005b78:	fd040793          	add	a5,s0,-48
    80005b7c:	00e784b3          	add	s1,a5,a4
    80005b80:	fff78913          	add	s2,a5,-1
    80005b84:	993a                	add	s2,s2,a4
    80005b86:	377d                	addw	a4,a4,-1
    80005b88:	1702                	sll	a4,a4,0x20
    80005b8a:	9301                	srl	a4,a4,0x20
    80005b8c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b90:	fff4c503          	lbu	a0,-1(s1)
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	d5e080e7          	jalr	-674(ra) # 800058f2 <consputc>
  while(--i >= 0)
    80005b9c:	14fd                	add	s1,s1,-1
    80005b9e:	ff2499e3          	bne	s1,s2,80005b90 <printint+0x7e>
}
    80005ba2:	70a2                	ld	ra,40(sp)
    80005ba4:	7402                	ld	s0,32(sp)
    80005ba6:	64e2                	ld	s1,24(sp)
    80005ba8:	6942                	ld	s2,16(sp)
    80005baa:	6145                	add	sp,sp,48
    80005bac:	8082                	ret
    x = -xx;
    80005bae:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005bb2:	4885                	li	a7,1
    x = -xx;
    80005bb4:	bf95                	j	80005b28 <printint+0x16>

0000000080005bb6 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005bb6:	1101                	add	sp,sp,-32
    80005bb8:	ec06                	sd	ra,24(sp)
    80005bba:	e822                	sd	s0,16(sp)
    80005bbc:	e426                	sd	s1,8(sp)
    80005bbe:	1000                	add	s0,sp,32
    80005bc0:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005bc2:	0001c797          	auipc	a5,0x1c
    80005bc6:	3607af23          	sw	zero,894(a5) # 80021f40 <pr+0x18>
  printf("panic: ");
    80005bca:	00003517          	auipc	a0,0x3
    80005bce:	c4650513          	add	a0,a0,-954 # 80008810 <syscalls+0x440>
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	02e080e7          	jalr	46(ra) # 80005c00 <printf>
  printf(s);
    80005bda:	8526                	mv	a0,s1
    80005bdc:	00000097          	auipc	ra,0x0
    80005be0:	024080e7          	jalr	36(ra) # 80005c00 <printf>
  printf("\n");
    80005be4:	00002517          	auipc	a0,0x2
    80005be8:	46450513          	add	a0,a0,1124 # 80008048 <etext+0x48>
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	014080e7          	jalr	20(ra) # 80005c00 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005bf4:	4785                	li	a5,1
    80005bf6:	00003717          	auipc	a4,0x3
    80005bfa:	d0f72323          	sw	a5,-762(a4) # 800088fc <panicked>
  for(;;)
    80005bfe:	a001                	j	80005bfe <panic+0x48>

0000000080005c00 <printf>:
{
    80005c00:	7131                	add	sp,sp,-192
    80005c02:	fc86                	sd	ra,120(sp)
    80005c04:	f8a2                	sd	s0,112(sp)
    80005c06:	f4a6                	sd	s1,104(sp)
    80005c08:	f0ca                	sd	s2,96(sp)
    80005c0a:	ecce                	sd	s3,88(sp)
    80005c0c:	e8d2                	sd	s4,80(sp)
    80005c0e:	e4d6                	sd	s5,72(sp)
    80005c10:	e0da                	sd	s6,64(sp)
    80005c12:	fc5e                	sd	s7,56(sp)
    80005c14:	f862                	sd	s8,48(sp)
    80005c16:	f466                	sd	s9,40(sp)
    80005c18:	f06a                	sd	s10,32(sp)
    80005c1a:	ec6e                	sd	s11,24(sp)
    80005c1c:	0100                	add	s0,sp,128
    80005c1e:	8a2a                	mv	s4,a0
    80005c20:	e40c                	sd	a1,8(s0)
    80005c22:	e810                	sd	a2,16(s0)
    80005c24:	ec14                	sd	a3,24(s0)
    80005c26:	f018                	sd	a4,32(s0)
    80005c28:	f41c                	sd	a5,40(s0)
    80005c2a:	03043823          	sd	a6,48(s0)
    80005c2e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c32:	0001cd97          	auipc	s11,0x1c
    80005c36:	30edad83          	lw	s11,782(s11) # 80021f40 <pr+0x18>
  if(locking)
    80005c3a:	020d9b63          	bnez	s11,80005c70 <printf+0x70>
  if (fmt == 0)
    80005c3e:	040a0263          	beqz	s4,80005c82 <printf+0x82>
  va_start(ap, fmt);
    80005c42:	00840793          	add	a5,s0,8
    80005c46:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c4a:	000a4503          	lbu	a0,0(s4)
    80005c4e:	14050f63          	beqz	a0,80005dac <printf+0x1ac>
    80005c52:	4981                	li	s3,0
    if(c != '%'){
    80005c54:	02500a93          	li	s5,37
    switch(c){
    80005c58:	07000b93          	li	s7,112
  consputc('x');
    80005c5c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c5e:	00003b17          	auipc	s6,0x3
    80005c62:	bdab0b13          	add	s6,s6,-1062 # 80008838 <digits>
    switch(c){
    80005c66:	07300c93          	li	s9,115
    80005c6a:	06400c13          	li	s8,100
    80005c6e:	a82d                	j	80005ca8 <printf+0xa8>
    acquire(&pr.lock);
    80005c70:	0001c517          	auipc	a0,0x1c
    80005c74:	2b850513          	add	a0,a0,696 # 80021f28 <pr>
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	476080e7          	jalr	1142(ra) # 800060ee <acquire>
    80005c80:	bf7d                	j	80005c3e <printf+0x3e>
    panic("null fmt");
    80005c82:	00003517          	auipc	a0,0x3
    80005c86:	b9e50513          	add	a0,a0,-1122 # 80008820 <syscalls+0x450>
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	f2c080e7          	jalr	-212(ra) # 80005bb6 <panic>
      consputc(c);
    80005c92:	00000097          	auipc	ra,0x0
    80005c96:	c60080e7          	jalr	-928(ra) # 800058f2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c9a:	2985                	addw	s3,s3,1
    80005c9c:	013a07b3          	add	a5,s4,s3
    80005ca0:	0007c503          	lbu	a0,0(a5)
    80005ca4:	10050463          	beqz	a0,80005dac <printf+0x1ac>
    if(c != '%'){
    80005ca8:	ff5515e3          	bne	a0,s5,80005c92 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005cac:	2985                	addw	s3,s3,1
    80005cae:	013a07b3          	add	a5,s4,s3
    80005cb2:	0007c783          	lbu	a5,0(a5)
    80005cb6:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005cba:	cbed                	beqz	a5,80005dac <printf+0x1ac>
    switch(c){
    80005cbc:	05778a63          	beq	a5,s7,80005d10 <printf+0x110>
    80005cc0:	02fbf663          	bgeu	s7,a5,80005cec <printf+0xec>
    80005cc4:	09978863          	beq	a5,s9,80005d54 <printf+0x154>
    80005cc8:	07800713          	li	a4,120
    80005ccc:	0ce79563          	bne	a5,a4,80005d96 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005cd0:	f8843783          	ld	a5,-120(s0)
    80005cd4:	00878713          	add	a4,a5,8
    80005cd8:	f8e43423          	sd	a4,-120(s0)
    80005cdc:	4605                	li	a2,1
    80005cde:	85ea                	mv	a1,s10
    80005ce0:	4388                	lw	a0,0(a5)
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	e30080e7          	jalr	-464(ra) # 80005b12 <printint>
      break;
    80005cea:	bf45                	j	80005c9a <printf+0x9a>
    switch(c){
    80005cec:	09578f63          	beq	a5,s5,80005d8a <printf+0x18a>
    80005cf0:	0b879363          	bne	a5,s8,80005d96 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005cf4:	f8843783          	ld	a5,-120(s0)
    80005cf8:	00878713          	add	a4,a5,8
    80005cfc:	f8e43423          	sd	a4,-120(s0)
    80005d00:	4605                	li	a2,1
    80005d02:	45a9                	li	a1,10
    80005d04:	4388                	lw	a0,0(a5)
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	e0c080e7          	jalr	-500(ra) # 80005b12 <printint>
      break;
    80005d0e:	b771                	j	80005c9a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d10:	f8843783          	ld	a5,-120(s0)
    80005d14:	00878713          	add	a4,a5,8
    80005d18:	f8e43423          	sd	a4,-120(s0)
    80005d1c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d20:	03000513          	li	a0,48
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	bce080e7          	jalr	-1074(ra) # 800058f2 <consputc>
  consputc('x');
    80005d2c:	07800513          	li	a0,120
    80005d30:	00000097          	auipc	ra,0x0
    80005d34:	bc2080e7          	jalr	-1086(ra) # 800058f2 <consputc>
    80005d38:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d3a:	03c95793          	srl	a5,s2,0x3c
    80005d3e:	97da                	add	a5,a5,s6
    80005d40:	0007c503          	lbu	a0,0(a5)
    80005d44:	00000097          	auipc	ra,0x0
    80005d48:	bae080e7          	jalr	-1106(ra) # 800058f2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d4c:	0912                	sll	s2,s2,0x4
    80005d4e:	34fd                	addw	s1,s1,-1
    80005d50:	f4ed                	bnez	s1,80005d3a <printf+0x13a>
    80005d52:	b7a1                	j	80005c9a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d54:	f8843783          	ld	a5,-120(s0)
    80005d58:	00878713          	add	a4,a5,8
    80005d5c:	f8e43423          	sd	a4,-120(s0)
    80005d60:	6384                	ld	s1,0(a5)
    80005d62:	cc89                	beqz	s1,80005d7c <printf+0x17c>
      for(; *s; s++)
    80005d64:	0004c503          	lbu	a0,0(s1)
    80005d68:	d90d                	beqz	a0,80005c9a <printf+0x9a>
        consputc(*s);
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	b88080e7          	jalr	-1144(ra) # 800058f2 <consputc>
      for(; *s; s++)
    80005d72:	0485                	add	s1,s1,1
    80005d74:	0004c503          	lbu	a0,0(s1)
    80005d78:	f96d                	bnez	a0,80005d6a <printf+0x16a>
    80005d7a:	b705                	j	80005c9a <printf+0x9a>
        s = "(null)";
    80005d7c:	00003497          	auipc	s1,0x3
    80005d80:	a9c48493          	add	s1,s1,-1380 # 80008818 <syscalls+0x448>
      for(; *s; s++)
    80005d84:	02800513          	li	a0,40
    80005d88:	b7cd                	j	80005d6a <printf+0x16a>
      consputc('%');
    80005d8a:	8556                	mv	a0,s5
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	b66080e7          	jalr	-1178(ra) # 800058f2 <consputc>
      break;
    80005d94:	b719                	j	80005c9a <printf+0x9a>
      consputc('%');
    80005d96:	8556                	mv	a0,s5
    80005d98:	00000097          	auipc	ra,0x0
    80005d9c:	b5a080e7          	jalr	-1190(ra) # 800058f2 <consputc>
      consputc(c);
    80005da0:	8526                	mv	a0,s1
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	b50080e7          	jalr	-1200(ra) # 800058f2 <consputc>
      break;
    80005daa:	bdc5                	j	80005c9a <printf+0x9a>
  if(locking)
    80005dac:	020d9163          	bnez	s11,80005dce <printf+0x1ce>
}
    80005db0:	70e6                	ld	ra,120(sp)
    80005db2:	7446                	ld	s0,112(sp)
    80005db4:	74a6                	ld	s1,104(sp)
    80005db6:	7906                	ld	s2,96(sp)
    80005db8:	69e6                	ld	s3,88(sp)
    80005dba:	6a46                	ld	s4,80(sp)
    80005dbc:	6aa6                	ld	s5,72(sp)
    80005dbe:	6b06                	ld	s6,64(sp)
    80005dc0:	7be2                	ld	s7,56(sp)
    80005dc2:	7c42                	ld	s8,48(sp)
    80005dc4:	7ca2                	ld	s9,40(sp)
    80005dc6:	7d02                	ld	s10,32(sp)
    80005dc8:	6de2                	ld	s11,24(sp)
    80005dca:	6129                	add	sp,sp,192
    80005dcc:	8082                	ret
    release(&pr.lock);
    80005dce:	0001c517          	auipc	a0,0x1c
    80005dd2:	15a50513          	add	a0,a0,346 # 80021f28 <pr>
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	3cc080e7          	jalr	972(ra) # 800061a2 <release>
}
    80005dde:	bfc9                	j	80005db0 <printf+0x1b0>

0000000080005de0 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005de0:	1101                	add	sp,sp,-32
    80005de2:	ec06                	sd	ra,24(sp)
    80005de4:	e822                	sd	s0,16(sp)
    80005de6:	e426                	sd	s1,8(sp)
    80005de8:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80005dea:	0001c497          	auipc	s1,0x1c
    80005dee:	13e48493          	add	s1,s1,318 # 80021f28 <pr>
    80005df2:	00003597          	auipc	a1,0x3
    80005df6:	a3e58593          	add	a1,a1,-1474 # 80008830 <syscalls+0x460>
    80005dfa:	8526                	mv	a0,s1
    80005dfc:	00000097          	auipc	ra,0x0
    80005e00:	262080e7          	jalr	610(ra) # 8000605e <initlock>
  pr.locking = 1;
    80005e04:	4785                	li	a5,1
    80005e06:	cc9c                	sw	a5,24(s1)
}
    80005e08:	60e2                	ld	ra,24(sp)
    80005e0a:	6442                	ld	s0,16(sp)
    80005e0c:	64a2                	ld	s1,8(sp)
    80005e0e:	6105                	add	sp,sp,32
    80005e10:	8082                	ret

0000000080005e12 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e12:	1141                	add	sp,sp,-16
    80005e14:	e406                	sd	ra,8(sp)
    80005e16:	e022                	sd	s0,0(sp)
    80005e18:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e1a:	100007b7          	lui	a5,0x10000
    80005e1e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e22:	f8000713          	li	a4,-128
    80005e26:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e2a:	470d                	li	a4,3
    80005e2c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e30:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e34:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e38:	469d                	li	a3,7
    80005e3a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e3e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e42:	00003597          	auipc	a1,0x3
    80005e46:	a0e58593          	add	a1,a1,-1522 # 80008850 <digits+0x18>
    80005e4a:	0001c517          	auipc	a0,0x1c
    80005e4e:	0fe50513          	add	a0,a0,254 # 80021f48 <uart_tx_lock>
    80005e52:	00000097          	auipc	ra,0x0
    80005e56:	20c080e7          	jalr	524(ra) # 8000605e <initlock>
}
    80005e5a:	60a2                	ld	ra,8(sp)
    80005e5c:	6402                	ld	s0,0(sp)
    80005e5e:	0141                	add	sp,sp,16
    80005e60:	8082                	ret

0000000080005e62 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e62:	1101                	add	sp,sp,-32
    80005e64:	ec06                	sd	ra,24(sp)
    80005e66:	e822                	sd	s0,16(sp)
    80005e68:	e426                	sd	s1,8(sp)
    80005e6a:	1000                	add	s0,sp,32
    80005e6c:	84aa                	mv	s1,a0
  push_off();
    80005e6e:	00000097          	auipc	ra,0x0
    80005e72:	234080e7          	jalr	564(ra) # 800060a2 <push_off>

  if(panicked){
    80005e76:	00003797          	auipc	a5,0x3
    80005e7a:	a867a783          	lw	a5,-1402(a5) # 800088fc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e7e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e82:	c391                	beqz	a5,80005e86 <uartputc_sync+0x24>
    for(;;)
    80005e84:	a001                	j	80005e84 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e86:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e8a:	0207f793          	and	a5,a5,32
    80005e8e:	dfe5                	beqz	a5,80005e86 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e90:	0ff4f513          	zext.b	a0,s1
    80005e94:	100007b7          	lui	a5,0x10000
    80005e98:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	2a6080e7          	jalr	678(ra) # 80006142 <pop_off>
}
    80005ea4:	60e2                	ld	ra,24(sp)
    80005ea6:	6442                	ld	s0,16(sp)
    80005ea8:	64a2                	ld	s1,8(sp)
    80005eaa:	6105                	add	sp,sp,32
    80005eac:	8082                	ret

0000000080005eae <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005eae:	00003797          	auipc	a5,0x3
    80005eb2:	a527b783          	ld	a5,-1454(a5) # 80008900 <uart_tx_r>
    80005eb6:	00003717          	auipc	a4,0x3
    80005eba:	a5273703          	ld	a4,-1454(a4) # 80008908 <uart_tx_w>
    80005ebe:	06f70a63          	beq	a4,a5,80005f32 <uartstart+0x84>
{
    80005ec2:	7139                	add	sp,sp,-64
    80005ec4:	fc06                	sd	ra,56(sp)
    80005ec6:	f822                	sd	s0,48(sp)
    80005ec8:	f426                	sd	s1,40(sp)
    80005eca:	f04a                	sd	s2,32(sp)
    80005ecc:	ec4e                	sd	s3,24(sp)
    80005ece:	e852                	sd	s4,16(sp)
    80005ed0:	e456                	sd	s5,8(sp)
    80005ed2:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ed4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ed8:	0001ca17          	auipc	s4,0x1c
    80005edc:	070a0a13          	add	s4,s4,112 # 80021f48 <uart_tx_lock>
    uart_tx_r += 1;
    80005ee0:	00003497          	auipc	s1,0x3
    80005ee4:	a2048493          	add	s1,s1,-1504 # 80008900 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ee8:	00003997          	auipc	s3,0x3
    80005eec:	a2098993          	add	s3,s3,-1504 # 80008908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ef0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005ef4:	02077713          	and	a4,a4,32
    80005ef8:	c705                	beqz	a4,80005f20 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005efa:	01f7f713          	and	a4,a5,31
    80005efe:	9752                	add	a4,a4,s4
    80005f00:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f04:	0785                	add	a5,a5,1
    80005f06:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f08:	8526                	mv	a0,s1
    80005f0a:	ffffb097          	auipc	ra,0xffffb
    80005f0e:	6de080e7          	jalr	1758(ra) # 800015e8 <wakeup>
    
    WriteReg(THR, c);
    80005f12:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f16:	609c                	ld	a5,0(s1)
    80005f18:	0009b703          	ld	a4,0(s3)
    80005f1c:	fcf71ae3          	bne	a4,a5,80005ef0 <uartstart+0x42>
  }
}
    80005f20:	70e2                	ld	ra,56(sp)
    80005f22:	7442                	ld	s0,48(sp)
    80005f24:	74a2                	ld	s1,40(sp)
    80005f26:	7902                	ld	s2,32(sp)
    80005f28:	69e2                	ld	s3,24(sp)
    80005f2a:	6a42                	ld	s4,16(sp)
    80005f2c:	6aa2                	ld	s5,8(sp)
    80005f2e:	6121                	add	sp,sp,64
    80005f30:	8082                	ret
    80005f32:	8082                	ret

0000000080005f34 <uartputc>:
{
    80005f34:	7179                	add	sp,sp,-48
    80005f36:	f406                	sd	ra,40(sp)
    80005f38:	f022                	sd	s0,32(sp)
    80005f3a:	ec26                	sd	s1,24(sp)
    80005f3c:	e84a                	sd	s2,16(sp)
    80005f3e:	e44e                	sd	s3,8(sp)
    80005f40:	e052                	sd	s4,0(sp)
    80005f42:	1800                	add	s0,sp,48
    80005f44:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f46:	0001c517          	auipc	a0,0x1c
    80005f4a:	00250513          	add	a0,a0,2 # 80021f48 <uart_tx_lock>
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	1a0080e7          	jalr	416(ra) # 800060ee <acquire>
  if(panicked){
    80005f56:	00003797          	auipc	a5,0x3
    80005f5a:	9a67a783          	lw	a5,-1626(a5) # 800088fc <panicked>
    80005f5e:	e7c9                	bnez	a5,80005fe8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f60:	00003717          	auipc	a4,0x3
    80005f64:	9a873703          	ld	a4,-1624(a4) # 80008908 <uart_tx_w>
    80005f68:	00003797          	auipc	a5,0x3
    80005f6c:	9987b783          	ld	a5,-1640(a5) # 80008900 <uart_tx_r>
    80005f70:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f74:	0001c997          	auipc	s3,0x1c
    80005f78:	fd498993          	add	s3,s3,-44 # 80021f48 <uart_tx_lock>
    80005f7c:	00003497          	auipc	s1,0x3
    80005f80:	98448493          	add	s1,s1,-1660 # 80008900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f84:	00003917          	auipc	s2,0x3
    80005f88:	98490913          	add	s2,s2,-1660 # 80008908 <uart_tx_w>
    80005f8c:	00e79f63          	bne	a5,a4,80005faa <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f90:	85ce                	mv	a1,s3
    80005f92:	8526                	mv	a0,s1
    80005f94:	ffffb097          	auipc	ra,0xffffb
    80005f98:	5f0080e7          	jalr	1520(ra) # 80001584 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f9c:	00093703          	ld	a4,0(s2)
    80005fa0:	609c                	ld	a5,0(s1)
    80005fa2:	02078793          	add	a5,a5,32
    80005fa6:	fee785e3          	beq	a5,a4,80005f90 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005faa:	0001c497          	auipc	s1,0x1c
    80005fae:	f9e48493          	add	s1,s1,-98 # 80021f48 <uart_tx_lock>
    80005fb2:	01f77793          	and	a5,a4,31
    80005fb6:	97a6                	add	a5,a5,s1
    80005fb8:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005fbc:	0705                	add	a4,a4,1
    80005fbe:	00003797          	auipc	a5,0x3
    80005fc2:	94e7b523          	sd	a4,-1718(a5) # 80008908 <uart_tx_w>
  uartstart();
    80005fc6:	00000097          	auipc	ra,0x0
    80005fca:	ee8080e7          	jalr	-280(ra) # 80005eae <uartstart>
  release(&uart_tx_lock);
    80005fce:	8526                	mv	a0,s1
    80005fd0:	00000097          	auipc	ra,0x0
    80005fd4:	1d2080e7          	jalr	466(ra) # 800061a2 <release>
}
    80005fd8:	70a2                	ld	ra,40(sp)
    80005fda:	7402                	ld	s0,32(sp)
    80005fdc:	64e2                	ld	s1,24(sp)
    80005fde:	6942                	ld	s2,16(sp)
    80005fe0:	69a2                	ld	s3,8(sp)
    80005fe2:	6a02                	ld	s4,0(sp)
    80005fe4:	6145                	add	sp,sp,48
    80005fe6:	8082                	ret
    for(;;)
    80005fe8:	a001                	j	80005fe8 <uartputc+0xb4>

0000000080005fea <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fea:	1141                	add	sp,sp,-16
    80005fec:	e422                	sd	s0,8(sp)
    80005fee:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005ff0:	100007b7          	lui	a5,0x10000
    80005ff4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005ff8:	8b85                	and	a5,a5,1
    80005ffa:	cb81                	beqz	a5,8000600a <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005ffc:	100007b7          	lui	a5,0x10000
    80006000:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006004:	6422                	ld	s0,8(sp)
    80006006:	0141                	add	sp,sp,16
    80006008:	8082                	ret
    return -1;
    8000600a:	557d                	li	a0,-1
    8000600c:	bfe5                	j	80006004 <uartgetc+0x1a>

000000008000600e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000600e:	1101                	add	sp,sp,-32
    80006010:	ec06                	sd	ra,24(sp)
    80006012:	e822                	sd	s0,16(sp)
    80006014:	e426                	sd	s1,8(sp)
    80006016:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006018:	54fd                	li	s1,-1
    8000601a:	a029                	j	80006024 <uartintr+0x16>
      break;
    consoleintr(c);
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	918080e7          	jalr	-1768(ra) # 80005934 <consoleintr>
    int c = uartgetc();
    80006024:	00000097          	auipc	ra,0x0
    80006028:	fc6080e7          	jalr	-58(ra) # 80005fea <uartgetc>
    if(c == -1)
    8000602c:	fe9518e3          	bne	a0,s1,8000601c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006030:	0001c497          	auipc	s1,0x1c
    80006034:	f1848493          	add	s1,s1,-232 # 80021f48 <uart_tx_lock>
    80006038:	8526                	mv	a0,s1
    8000603a:	00000097          	auipc	ra,0x0
    8000603e:	0b4080e7          	jalr	180(ra) # 800060ee <acquire>
  uartstart();
    80006042:	00000097          	auipc	ra,0x0
    80006046:	e6c080e7          	jalr	-404(ra) # 80005eae <uartstart>
  release(&uart_tx_lock);
    8000604a:	8526                	mv	a0,s1
    8000604c:	00000097          	auipc	ra,0x0
    80006050:	156080e7          	jalr	342(ra) # 800061a2 <release>
}
    80006054:	60e2                	ld	ra,24(sp)
    80006056:	6442                	ld	s0,16(sp)
    80006058:	64a2                	ld	s1,8(sp)
    8000605a:	6105                	add	sp,sp,32
    8000605c:	8082                	ret

000000008000605e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000605e:	1141                	add	sp,sp,-16
    80006060:	e422                	sd	s0,8(sp)
    80006062:	0800                	add	s0,sp,16
  lk->name = name;
    80006064:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006066:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000606a:	00053823          	sd	zero,16(a0)
}
    8000606e:	6422                	ld	s0,8(sp)
    80006070:	0141                	add	sp,sp,16
    80006072:	8082                	ret

0000000080006074 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006074:	411c                	lw	a5,0(a0)
    80006076:	e399                	bnez	a5,8000607c <holding+0x8>
    80006078:	4501                	li	a0,0
  return r;
}
    8000607a:	8082                	ret
{
    8000607c:	1101                	add	sp,sp,-32
    8000607e:	ec06                	sd	ra,24(sp)
    80006080:	e822                	sd	s0,16(sp)
    80006082:	e426                	sd	s1,8(sp)
    80006084:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006086:	6904                	ld	s1,16(a0)
    80006088:	ffffb097          	auipc	ra,0xffffb
    8000608c:	daa080e7          	jalr	-598(ra) # 80000e32 <mycpu>
    80006090:	40a48533          	sub	a0,s1,a0
    80006094:	00153513          	seqz	a0,a0
}
    80006098:	60e2                	ld	ra,24(sp)
    8000609a:	6442                	ld	s0,16(sp)
    8000609c:	64a2                	ld	s1,8(sp)
    8000609e:	6105                	add	sp,sp,32
    800060a0:	8082                	ret

00000000800060a2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800060a2:	1101                	add	sp,sp,-32
    800060a4:	ec06                	sd	ra,24(sp)
    800060a6:	e822                	sd	s0,16(sp)
    800060a8:	e426                	sd	s1,8(sp)
    800060aa:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060ac:	100024f3          	csrr	s1,sstatus
    800060b0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800060b4:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060b6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800060ba:	ffffb097          	auipc	ra,0xffffb
    800060be:	d78080e7          	jalr	-648(ra) # 80000e32 <mycpu>
    800060c2:	5d3c                	lw	a5,120(a0)
    800060c4:	cf89                	beqz	a5,800060de <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800060c6:	ffffb097          	auipc	ra,0xffffb
    800060ca:	d6c080e7          	jalr	-660(ra) # 80000e32 <mycpu>
    800060ce:	5d3c                	lw	a5,120(a0)
    800060d0:	2785                	addw	a5,a5,1
    800060d2:	dd3c                	sw	a5,120(a0)
}
    800060d4:	60e2                	ld	ra,24(sp)
    800060d6:	6442                	ld	s0,16(sp)
    800060d8:	64a2                	ld	s1,8(sp)
    800060da:	6105                	add	sp,sp,32
    800060dc:	8082                	ret
    mycpu()->intena = old;
    800060de:	ffffb097          	auipc	ra,0xffffb
    800060e2:	d54080e7          	jalr	-684(ra) # 80000e32 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060e6:	8085                	srl	s1,s1,0x1
    800060e8:	8885                	and	s1,s1,1
    800060ea:	dd64                	sw	s1,124(a0)
    800060ec:	bfe9                	j	800060c6 <push_off+0x24>

00000000800060ee <acquire>:
{
    800060ee:	1101                	add	sp,sp,-32
    800060f0:	ec06                	sd	ra,24(sp)
    800060f2:	e822                	sd	s0,16(sp)
    800060f4:	e426                	sd	s1,8(sp)
    800060f6:	1000                	add	s0,sp,32
    800060f8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	fa8080e7          	jalr	-88(ra) # 800060a2 <push_off>
  if(holding(lk))
    80006102:	8526                	mv	a0,s1
    80006104:	00000097          	auipc	ra,0x0
    80006108:	f70080e7          	jalr	-144(ra) # 80006074 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000610c:	4705                	li	a4,1
  if(holding(lk))
    8000610e:	e115                	bnez	a0,80006132 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006110:	87ba                	mv	a5,a4
    80006112:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006116:	2781                	sext.w	a5,a5
    80006118:	ffe5                	bnez	a5,80006110 <acquire+0x22>
  __sync_synchronize();
    8000611a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000611e:	ffffb097          	auipc	ra,0xffffb
    80006122:	d14080e7          	jalr	-748(ra) # 80000e32 <mycpu>
    80006126:	e888                	sd	a0,16(s1)
}
    80006128:	60e2                	ld	ra,24(sp)
    8000612a:	6442                	ld	s0,16(sp)
    8000612c:	64a2                	ld	s1,8(sp)
    8000612e:	6105                	add	sp,sp,32
    80006130:	8082                	ret
    panic("acquire");
    80006132:	00002517          	auipc	a0,0x2
    80006136:	72650513          	add	a0,a0,1830 # 80008858 <digits+0x20>
    8000613a:	00000097          	auipc	ra,0x0
    8000613e:	a7c080e7          	jalr	-1412(ra) # 80005bb6 <panic>

0000000080006142 <pop_off>:

void
pop_off(void)
{
    80006142:	1141                	add	sp,sp,-16
    80006144:	e406                	sd	ra,8(sp)
    80006146:	e022                	sd	s0,0(sp)
    80006148:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    8000614a:	ffffb097          	auipc	ra,0xffffb
    8000614e:	ce8080e7          	jalr	-792(ra) # 80000e32 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006152:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006156:	8b89                	and	a5,a5,2
  if(intr_get())
    80006158:	e78d                	bnez	a5,80006182 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000615a:	5d3c                	lw	a5,120(a0)
    8000615c:	02f05b63          	blez	a5,80006192 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006160:	37fd                	addw	a5,a5,-1
    80006162:	0007871b          	sext.w	a4,a5
    80006166:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006168:	eb09                	bnez	a4,8000617a <pop_off+0x38>
    8000616a:	5d7c                	lw	a5,124(a0)
    8000616c:	c799                	beqz	a5,8000617a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000616e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006172:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006176:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000617a:	60a2                	ld	ra,8(sp)
    8000617c:	6402                	ld	s0,0(sp)
    8000617e:	0141                	add	sp,sp,16
    80006180:	8082                	ret
    panic("pop_off - interruptible");
    80006182:	00002517          	auipc	a0,0x2
    80006186:	6de50513          	add	a0,a0,1758 # 80008860 <digits+0x28>
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	a2c080e7          	jalr	-1492(ra) # 80005bb6 <panic>
    panic("pop_off");
    80006192:	00002517          	auipc	a0,0x2
    80006196:	6e650513          	add	a0,a0,1766 # 80008878 <digits+0x40>
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	a1c080e7          	jalr	-1508(ra) # 80005bb6 <panic>

00000000800061a2 <release>:
{
    800061a2:	1101                	add	sp,sp,-32
    800061a4:	ec06                	sd	ra,24(sp)
    800061a6:	e822                	sd	s0,16(sp)
    800061a8:	e426                	sd	s1,8(sp)
    800061aa:	1000                	add	s0,sp,32
    800061ac:	84aa                	mv	s1,a0
  if(!holding(lk))
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	ec6080e7          	jalr	-314(ra) # 80006074 <holding>
    800061b6:	c115                	beqz	a0,800061da <release+0x38>
  lk->cpu = 0;
    800061b8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800061bc:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800061c0:	0f50000f          	fence	iorw,ow
    800061c4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	f7a080e7          	jalr	-134(ra) # 80006142 <pop_off>
}
    800061d0:	60e2                	ld	ra,24(sp)
    800061d2:	6442                	ld	s0,16(sp)
    800061d4:	64a2                	ld	s1,8(sp)
    800061d6:	6105                	add	sp,sp,32
    800061d8:	8082                	ret
    panic("release");
    800061da:	00002517          	auipc	a0,0x2
    800061de:	6a650513          	add	a0,a0,1702 # 80008880 <digits+0x48>
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	9d4080e7          	jalr	-1580(ra) # 80005bb6 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...

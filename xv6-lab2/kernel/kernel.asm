
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	fc010113          	add	sp,sp,-64 # 80019fc0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7c0050ef          	jal	800057d6 <start>

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
    80000034:	09078793          	add	a5,a5,144 # 800220c0 <end>
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
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	a0090913          	add	s2,s2,-1536 # 80008a50 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	164080e7          	jalr	356(ra) # 800061be <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	204080e7          	jalr	516(ra) # 80006272 <release>
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
    8000008e:	bfc080e7          	jalr	-1028(ra) # 80005c86 <panic>

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
    800000f2:	96250513          	add	a0,a0,-1694 # 80008a50 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	038080e7          	jalr	56(ra) # 8000612e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	fbe50513          	add	a0,a0,-66 # 800220c0 <end>
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
    80000124:	00009497          	auipc	s1,0x9
    80000128:	92c48493          	add	s1,s1,-1748 # 80008a50 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	090080e7          	jalr	144(ra) # 800061be <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	91450513          	add	a0,a0,-1772 # 80008a50 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	12c080e7          	jalr	300(ra) # 80006272 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	add	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	8e850513          	add	a0,a0,-1816 # 80008a50 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	102080e7          	jalr	258(ra) # 80006272 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <kcollect_free>:

uint64
kcollect_free(void)
{
    8000017a:	1101                	add	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	add	s0,sp,32
  acquire(&kmem.lock);
    80000184:	00009497          	auipc	s1,0x9
    80000188:	8cc48493          	add	s1,s1,-1844 # 80008a50 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	030080e7          	jalr	48(ra) # 800061be <acquire>
  
  uint64 free_bytes = 0;
  struct run *r = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
  while(r){
    80000198:	c785                	beqz	a5,800001c0 <kcollect_free+0x46>
  uint64 free_bytes = 0;
    8000019a:	4481                	li	s1,0
    free_bytes += PGSIZE;
    8000019c:	6705                	lui	a4,0x1
    8000019e:	94ba                	add	s1,s1,a4
    r = r->next;
    800001a0:	639c                	ld	a5,0(a5)
  while(r){
    800001a2:	fff5                	bnez	a5,8000019e <kcollect_free+0x24>
  }

  release(&kmem.lock);
    800001a4:	00009517          	auipc	a0,0x9
    800001a8:	8ac50513          	add	a0,a0,-1876 # 80008a50 <kmem>
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	0c6080e7          	jalr	198(ra) # 80006272 <release>
  return free_bytes;
    800001b4:	8526                	mv	a0,s1
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	add	sp,sp,32
    800001be:	8082                	ret
  uint64 free_bytes = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7cd                	j	800001a4 <kcollect_free+0x2a>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	add	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	sll	a2,a2,0x20
    800001d0:	9201                	srl	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	add	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	add	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	add	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	sll	a3,a3,0x20
    800001f4:	9281                	srl	a3,a3,0x20
    800001f6:	0685                	add	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	add	a0,a0,1
    80000208:	0585                	add	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	add	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	add	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	sll	a2,a2,0x20
    8000022e:	9201                	srl	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	add	a1,a1,1
    80000238:	0705                	add	a4,a4,1 # 1001 <_entry-0x7fffefff>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	fef59ae3          	bne	a1,a5,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	add	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	sll	a3,a2,0x20
    80000250:	9281                	srl	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addw	a5,a2,-1
    80000260:	1782                	sll	a5,a5,0x20
    80000262:	9381                	srl	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	add	a4,a4,-1
    8000026c:	16fd                	add	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fee79ae3          	bne	a5,a4,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	add	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	add	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	add	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addw	a2,a2,-1
    800002ac:	0505                	add	a0,a0,1
    800002ae:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a809                	j	800002c6 <strncmp+0x32>
    800002b6:	4501                	li	a0,0
    800002b8:	a039                	j	800002c6 <strncmp+0x32>
  if(n == 0)
    800002ba:	ca09                	beqz	a2,800002cc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002bc:	00054503          	lbu	a0,0(a0)
    800002c0:	0005c783          	lbu	a5,0(a1)
    800002c4:	9d1d                	subw	a0,a0,a5
}
    800002c6:	6422                	ld	s0,8(sp)
    800002c8:	0141                	add	sp,sp,16
    800002ca:	8082                	ret
    return 0;
    800002cc:	4501                	li	a0,0
    800002ce:	bfe5                	j	800002c6 <strncmp+0x32>

00000000800002d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d0:	1141                	add	sp,sp,-16
    800002d2:	e422                	sd	s0,8(sp)
    800002d4:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d6:	87aa                	mv	a5,a0
    800002d8:	86b2                	mv	a3,a2
    800002da:	367d                	addw	a2,a2,-1
    800002dc:	00d05963          	blez	a3,800002ee <strncpy+0x1e>
    800002e0:	0785                	add	a5,a5,1
    800002e2:	0005c703          	lbu	a4,0(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	0585                	add	a1,a1,1
    800002ec:	f775                	bnez	a4,800002d8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ee:	873e                	mv	a4,a5
    800002f0:	9fb5                	addw	a5,a5,a3
    800002f2:	37fd                	addw	a5,a5,-1
    800002f4:	00c05963          	blez	a2,80000306 <strncpy+0x36>
    *s++ = 0;
    800002f8:	0705                	add	a4,a4,1
    800002fa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002fe:	40e786bb          	subw	a3,a5,a4
    80000302:	fed04be3          	bgtz	a3,800002f8 <strncpy+0x28>
  return os;
}
    80000306:	6422                	ld	s0,8(sp)
    80000308:	0141                	add	sp,sp,16
    8000030a:	8082                	ret

000000008000030c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000030c:	1141                	add	sp,sp,-16
    8000030e:	e422                	sd	s0,8(sp)
    80000310:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000312:	02c05363          	blez	a2,80000338 <safestrcpy+0x2c>
    80000316:	fff6069b          	addw	a3,a2,-1
    8000031a:	1682                	sll	a3,a3,0x20
    8000031c:	9281                	srl	a3,a3,0x20
    8000031e:	96ae                	add	a3,a3,a1
    80000320:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000322:	00d58963          	beq	a1,a3,80000334 <safestrcpy+0x28>
    80000326:	0585                	add	a1,a1,1
    80000328:	0785                	add	a5,a5,1
    8000032a:	fff5c703          	lbu	a4,-1(a1)
    8000032e:	fee78fa3          	sb	a4,-1(a5)
    80000332:	fb65                	bnez	a4,80000322 <safestrcpy+0x16>
    ;
  *s = 0;
    80000334:	00078023          	sb	zero,0(a5)
  return os;
}
    80000338:	6422                	ld	s0,8(sp)
    8000033a:	0141                	add	sp,sp,16
    8000033c:	8082                	ret

000000008000033e <strlen>:

int
strlen(const char *s)
{
    8000033e:	1141                	add	sp,sp,-16
    80000340:	e422                	sd	s0,8(sp)
    80000342:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000344:	00054783          	lbu	a5,0(a0)
    80000348:	cf91                	beqz	a5,80000364 <strlen+0x26>
    8000034a:	0505                	add	a0,a0,1
    8000034c:	87aa                	mv	a5,a0
    8000034e:	86be                	mv	a3,a5
    80000350:	0785                	add	a5,a5,1
    80000352:	fff7c703          	lbu	a4,-1(a5)
    80000356:	ff65                	bnez	a4,8000034e <strlen+0x10>
    80000358:	40a6853b          	subw	a0,a3,a0
    8000035c:	2505                	addw	a0,a0,1
    ;
  return n;
}
    8000035e:	6422                	ld	s0,8(sp)
    80000360:	0141                	add	sp,sp,16
    80000362:	8082                	ret
  for(n = 0; s[n]; n++)
    80000364:	4501                	li	a0,0
    80000366:	bfe5                	j	8000035e <strlen+0x20>

0000000080000368 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000368:	1141                	add	sp,sp,-16
    8000036a:	e406                	sd	ra,8(sp)
    8000036c:	e022                	sd	s0,0(sp)
    8000036e:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000370:	00001097          	auipc	ra,0x1
    80000374:	b00080e7          	jalr	-1280(ra) # 80000e70 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000378:	00008717          	auipc	a4,0x8
    8000037c:	6a870713          	add	a4,a4,1704 # 80008a20 <started>
  if(cpuid() == 0){
    80000380:	c139                	beqz	a0,800003c6 <main+0x5e>
    while(started == 0)
    80000382:	431c                	lw	a5,0(a4)
    80000384:	2781                	sext.w	a5,a5
    80000386:	dff5                	beqz	a5,80000382 <main+0x1a>
      ;
    __sync_synchronize();
    80000388:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000038c:	00001097          	auipc	ra,0x1
    80000390:	ae4080e7          	jalr	-1308(ra) # 80000e70 <cpuid>
    80000394:	85aa                	mv	a1,a0
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	ca250513          	add	a0,a0,-862 # 80008038 <etext+0x38>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	932080e7          	jalr	-1742(ra) # 80005cd0 <printf>
    kvminithart();    // turn on paging
    800003a6:	00000097          	auipc	ra,0x0
    800003aa:	0d8080e7          	jalr	216(ra) # 8000047e <kvminithart>
    trapinithart();   // install kernel trap vector
    800003ae:	00001097          	auipc	ra,0x1
    800003b2:	7c8080e7          	jalr	1992(ra) # 80001b76 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b6:	00005097          	auipc	ra,0x5
    800003ba:	dda080e7          	jalr	-550(ra) # 80005190 <plicinithart>
  }

  scheduler();        
    800003be:	00001097          	auipc	ra,0x1
    800003c2:	fe0080e7          	jalr	-32(ra) # 8000139e <scheduler>
    consoleinit();
    800003c6:	00005097          	auipc	ra,0x5
    800003ca:	7d0080e7          	jalr	2000(ra) # 80005b96 <consoleinit>
    printfinit();
    800003ce:	00006097          	auipc	ra,0x6
    800003d2:	ae2080e7          	jalr	-1310(ra) # 80005eb0 <printfinit>
    printf("\n");
    800003d6:	00008517          	auipc	a0,0x8
    800003da:	c7250513          	add	a0,a0,-910 # 80008048 <etext+0x48>
    800003de:	00006097          	auipc	ra,0x6
    800003e2:	8f2080e7          	jalr	-1806(ra) # 80005cd0 <printf>
    printf("xv6 kernel is booting\n");
    800003e6:	00008517          	auipc	a0,0x8
    800003ea:	c3a50513          	add	a0,a0,-966 # 80008020 <etext+0x20>
    800003ee:	00006097          	auipc	ra,0x6
    800003f2:	8e2080e7          	jalr	-1822(ra) # 80005cd0 <printf>
    printf("\n");
    800003f6:	00008517          	auipc	a0,0x8
    800003fa:	c5250513          	add	a0,a0,-942 # 80008048 <etext+0x48>
    800003fe:	00006097          	auipc	ra,0x6
    80000402:	8d2080e7          	jalr	-1838(ra) # 80005cd0 <printf>
    kinit();         // physical page allocator
    80000406:	00000097          	auipc	ra,0x0
    8000040a:	cd8080e7          	jalr	-808(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	326080e7          	jalr	806(ra) # 80000734 <kvminit>
    kvminithart();   // turn on paging
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	068080e7          	jalr	104(ra) # 8000047e <kvminithart>
    procinit();      // process table
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	99e080e7          	jalr	-1634(ra) # 80000dbc <procinit>
    trapinit();      // trap vectors
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	728080e7          	jalr	1832(ra) # 80001b4e <trapinit>
    trapinithart();  // install kernel trap vector
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	748080e7          	jalr	1864(ra) # 80001b76 <trapinithart>
    plicinit();      // set up interrupt controller
    80000436:	00005097          	auipc	ra,0x5
    8000043a:	d44080e7          	jalr	-700(ra) # 8000517a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	d52080e7          	jalr	-686(ra) # 80005190 <plicinithart>
    binit();         // buffer cache
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	f48080e7          	jalr	-184(ra) # 8000238e <binit>
    iinit();         // inode table
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	5e6080e7          	jalr	1510(ra) # 80002a34 <iinit>
    fileinit();      // file table
    80000456:	00003097          	auipc	ra,0x3
    8000045a:	55c080e7          	jalr	1372(ra) # 800039b2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000045e:	00005097          	auipc	ra,0x5
    80000462:	e3a080e7          	jalr	-454(ra) # 80005298 <virtio_disk_init>
    userinit();      // first user process
    80000466:	00001097          	auipc	ra,0x1
    8000046a:	d12080e7          	jalr	-750(ra) # 80001178 <userinit>
    __sync_synchronize();
    8000046e:	0ff0000f          	fence
    started = 1;
    80000472:	4785                	li	a5,1
    80000474:	00008717          	auipc	a4,0x8
    80000478:	5af72623          	sw	a5,1452(a4) # 80008a20 <started>
    8000047c:	b789                	j	800003be <main+0x56>

000000008000047e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000047e:	1141                	add	sp,sp,-16
    80000480:	e422                	sd	s0,8(sp)
    80000482:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000484:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000488:	00008797          	auipc	a5,0x8
    8000048c:	5a07b783          	ld	a5,1440(a5) # 80008a28 <kernel_pagetable>
    80000490:	83b1                	srl	a5,a5,0xc
    80000492:	577d                	li	a4,-1
    80000494:	177e                	sll	a4,a4,0x3f
    80000496:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000498:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000049c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004a0:	6422                	ld	s0,8(sp)
    800004a2:	0141                	add	sp,sp,16
    800004a4:	8082                	ret

00000000800004a6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004a6:	7139                	add	sp,sp,-64
    800004a8:	fc06                	sd	ra,56(sp)
    800004aa:	f822                	sd	s0,48(sp)
    800004ac:	f426                	sd	s1,40(sp)
    800004ae:	f04a                	sd	s2,32(sp)
    800004b0:	ec4e                	sd	s3,24(sp)
    800004b2:	e852                	sd	s4,16(sp)
    800004b4:	e456                	sd	s5,8(sp)
    800004b6:	e05a                	sd	s6,0(sp)
    800004b8:	0080                	add	s0,sp,64
    800004ba:	84aa                	mv	s1,a0
    800004bc:	89ae                	mv	s3,a1
    800004be:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c0:	57fd                	li	a5,-1
    800004c2:	83e9                	srl	a5,a5,0x1a
    800004c4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004c6:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004c8:	04b7f263          	bgeu	a5,a1,8000050c <walk+0x66>
    panic("walk");
    800004cc:	00008517          	auipc	a0,0x8
    800004d0:	b8450513          	add	a0,a0,-1148 # 80008050 <etext+0x50>
    800004d4:	00005097          	auipc	ra,0x5
    800004d8:	7b2080e7          	jalr	1970(ra) # 80005c86 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004dc:	060a8663          	beqz	s5,80000548 <walk+0xa2>
    800004e0:	00000097          	auipc	ra,0x0
    800004e4:	c3a080e7          	jalr	-966(ra) # 8000011a <kalloc>
    800004e8:	84aa                	mv	s1,a0
    800004ea:	c529                	beqz	a0,80000534 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004ec:	6605                	lui	a2,0x1
    800004ee:	4581                	li	a1,0
    800004f0:	00000097          	auipc	ra,0x0
    800004f4:	cd4080e7          	jalr	-812(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004f8:	00c4d793          	srl	a5,s1,0xc
    800004fc:	07aa                	sll	a5,a5,0xa
    800004fe:	0017e793          	or	a5,a5,1
    80000502:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000506:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcf37>
    80000508:	036a0063          	beq	s4,s6,80000528 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000050c:	0149d933          	srl	s2,s3,s4
    80000510:	1ff97913          	and	s2,s2,511
    80000514:	090e                	sll	s2,s2,0x3
    80000516:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000518:	00093483          	ld	s1,0(s2)
    8000051c:	0014f793          	and	a5,s1,1
    80000520:	dfd5                	beqz	a5,800004dc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000522:	80a9                	srl	s1,s1,0xa
    80000524:	04b2                	sll	s1,s1,0xc
    80000526:	b7c5                	j	80000506 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000528:	00c9d513          	srl	a0,s3,0xc
    8000052c:	1ff57513          	and	a0,a0,511
    80000530:	050e                	sll	a0,a0,0x3
    80000532:	9526                	add	a0,a0,s1
}
    80000534:	70e2                	ld	ra,56(sp)
    80000536:	7442                	ld	s0,48(sp)
    80000538:	74a2                	ld	s1,40(sp)
    8000053a:	7902                	ld	s2,32(sp)
    8000053c:	69e2                	ld	s3,24(sp)
    8000053e:	6a42                	ld	s4,16(sp)
    80000540:	6aa2                	ld	s5,8(sp)
    80000542:	6b02                	ld	s6,0(sp)
    80000544:	6121                	add	sp,sp,64
    80000546:	8082                	ret
        return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7ed                	j	80000534 <walk+0x8e>

000000008000054c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000054c:	57fd                	li	a5,-1
    8000054e:	83e9                	srl	a5,a5,0x1a
    80000550:	00b7f463          	bgeu	a5,a1,80000558 <walkaddr+0xc>
    return 0;
    80000554:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000556:	8082                	ret
{
    80000558:	1141                	add	sp,sp,-16
    8000055a:	e406                	sd	ra,8(sp)
    8000055c:	e022                	sd	s0,0(sp)
    8000055e:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000560:	4601                	li	a2,0
    80000562:	00000097          	auipc	ra,0x0
    80000566:	f44080e7          	jalr	-188(ra) # 800004a6 <walk>
  if(pte == 0)
    8000056a:	c105                	beqz	a0,8000058a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000056c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000056e:	0117f693          	and	a3,a5,17
    80000572:	4745                	li	a4,17
    return 0;
    80000574:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000576:	00e68663          	beq	a3,a4,80000582 <walkaddr+0x36>
}
    8000057a:	60a2                	ld	ra,8(sp)
    8000057c:	6402                	ld	s0,0(sp)
    8000057e:	0141                	add	sp,sp,16
    80000580:	8082                	ret
  pa = PTE2PA(*pte);
    80000582:	83a9                	srl	a5,a5,0xa
    80000584:	00c79513          	sll	a0,a5,0xc
  return pa;
    80000588:	bfcd                	j	8000057a <walkaddr+0x2e>
    return 0;
    8000058a:	4501                	li	a0,0
    8000058c:	b7fd                	j	8000057a <walkaddr+0x2e>

000000008000058e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000058e:	715d                	add	sp,sp,-80
    80000590:	e486                	sd	ra,72(sp)
    80000592:	e0a2                	sd	s0,64(sp)
    80000594:	fc26                	sd	s1,56(sp)
    80000596:	f84a                	sd	s2,48(sp)
    80000598:	f44e                	sd	s3,40(sp)
    8000059a:	f052                	sd	s4,32(sp)
    8000059c:	ec56                	sd	s5,24(sp)
    8000059e:	e85a                	sd	s6,16(sp)
    800005a0:	e45e                	sd	s7,8(sp)
    800005a2:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a4:	c639                	beqz	a2,800005f2 <mappages+0x64>
    800005a6:	8aaa                	mv	s5,a0
    800005a8:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005aa:	777d                	lui	a4,0xfffff
    800005ac:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005b0:	fff58993          	add	s3,a1,-1
    800005b4:	99b2                	add	s3,s3,a2
    800005b6:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005ba:	893e                	mv	s2,a5
    800005bc:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c0:	6b85                	lui	s7,0x1
    800005c2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c6:	4605                	li	a2,1
    800005c8:	85ca                	mv	a1,s2
    800005ca:	8556                	mv	a0,s5
    800005cc:	00000097          	auipc	ra,0x0
    800005d0:	eda080e7          	jalr	-294(ra) # 800004a6 <walk>
    800005d4:	cd1d                	beqz	a0,80000612 <mappages+0x84>
    if(*pte & PTE_V)
    800005d6:	611c                	ld	a5,0(a0)
    800005d8:	8b85                	and	a5,a5,1
    800005da:	e785                	bnez	a5,80000602 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005dc:	80b1                	srl	s1,s1,0xc
    800005de:	04aa                	sll	s1,s1,0xa
    800005e0:	0164e4b3          	or	s1,s1,s6
    800005e4:	0014e493          	or	s1,s1,1
    800005e8:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ea:	05390063          	beq	s2,s3,8000062a <mappages+0x9c>
    a += PGSIZE;
    800005ee:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005f0:	bfc9                	j	800005c2 <mappages+0x34>
    panic("mappages: size");
    800005f2:	00008517          	auipc	a0,0x8
    800005f6:	a6650513          	add	a0,a0,-1434 # 80008058 <etext+0x58>
    800005fa:	00005097          	auipc	ra,0x5
    800005fe:	68c080e7          	jalr	1676(ra) # 80005c86 <panic>
      panic("mappages: remap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a6650513          	add	a0,a0,-1434 # 80008068 <etext+0x68>
    8000060a:	00005097          	auipc	ra,0x5
    8000060e:	67c080e7          	jalr	1660(ra) # 80005c86 <panic>
      return -1;
    80000612:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000614:	60a6                	ld	ra,72(sp)
    80000616:	6406                	ld	s0,64(sp)
    80000618:	74e2                	ld	s1,56(sp)
    8000061a:	7942                	ld	s2,48(sp)
    8000061c:	79a2                	ld	s3,40(sp)
    8000061e:	7a02                	ld	s4,32(sp)
    80000620:	6ae2                	ld	s5,24(sp)
    80000622:	6b42                	ld	s6,16(sp)
    80000624:	6ba2                	ld	s7,8(sp)
    80000626:	6161                	add	sp,sp,80
    80000628:	8082                	ret
  return 0;
    8000062a:	4501                	li	a0,0
    8000062c:	b7e5                	j	80000614 <mappages+0x86>

000000008000062e <kvmmap>:
{
    8000062e:	1141                	add	sp,sp,-16
    80000630:	e406                	sd	ra,8(sp)
    80000632:	e022                	sd	s0,0(sp)
    80000634:	0800                	add	s0,sp,16
    80000636:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000638:	86b2                	mv	a3,a2
    8000063a:	863e                	mv	a2,a5
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	f52080e7          	jalr	-174(ra) # 8000058e <mappages>
    80000644:	e509                	bnez	a0,8000064e <kvmmap+0x20>
}
    80000646:	60a2                	ld	ra,8(sp)
    80000648:	6402                	ld	s0,0(sp)
    8000064a:	0141                	add	sp,sp,16
    8000064c:	8082                	ret
    panic("kvmmap");
    8000064e:	00008517          	auipc	a0,0x8
    80000652:	a2a50513          	add	a0,a0,-1494 # 80008078 <etext+0x78>
    80000656:	00005097          	auipc	ra,0x5
    8000065a:	630080e7          	jalr	1584(ra) # 80005c86 <panic>

000000008000065e <kvmmake>:
{
    8000065e:	1101                	add	sp,sp,-32
    80000660:	ec06                	sd	ra,24(sp)
    80000662:	e822                	sd	s0,16(sp)
    80000664:	e426                	sd	s1,8(sp)
    80000666:	e04a                	sd	s2,0(sp)
    80000668:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	ab0080e7          	jalr	-1360(ra) # 8000011a <kalloc>
    80000672:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000674:	6605                	lui	a2,0x1
    80000676:	4581                	li	a1,0
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	b4c080e7          	jalr	-1204(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000680:	4719                	li	a4,6
    80000682:	6685                	lui	a3,0x1
    80000684:	10000637          	lui	a2,0x10000
    80000688:	100005b7          	lui	a1,0x10000
    8000068c:	8526                	mv	a0,s1
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	fa0080e7          	jalr	-96(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000696:	4719                	li	a4,6
    80000698:	6685                	lui	a3,0x1
    8000069a:	10001637          	lui	a2,0x10001
    8000069e:	100015b7          	lui	a1,0x10001
    800006a2:	8526                	mv	a0,s1
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	f8a080e7          	jalr	-118(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006ac:	4719                	li	a4,6
    800006ae:	004006b7          	lui	a3,0x400
    800006b2:	0c000637          	lui	a2,0xc000
    800006b6:	0c0005b7          	lui	a1,0xc000
    800006ba:	8526                	mv	a0,s1
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	f72080e7          	jalr	-142(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c4:	00008917          	auipc	s2,0x8
    800006c8:	93c90913          	add	s2,s2,-1732 # 80008000 <etext>
    800006cc:	4729                	li	a4,10
    800006ce:	80008697          	auipc	a3,0x80008
    800006d2:	93268693          	add	a3,a3,-1742 # 8000 <_entry-0x7fff8000>
    800006d6:	4605                	li	a2,1
    800006d8:	067e                	sll	a2,a2,0x1f
    800006da:	85b2                	mv	a1,a2
    800006dc:	8526                	mv	a0,s1
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	f50080e7          	jalr	-176(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e6:	4719                	li	a4,6
    800006e8:	46c5                	li	a3,17
    800006ea:	06ee                	sll	a3,a3,0x1b
    800006ec:	412686b3          	sub	a3,a3,s2
    800006f0:	864a                	mv	a2,s2
    800006f2:	85ca                	mv	a1,s2
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f38080e7          	jalr	-200(ra) # 8000062e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fe:	4729                	li	a4,10
    80000700:	6685                	lui	a3,0x1
    80000702:	00007617          	auipc	a2,0x7
    80000706:	8fe60613          	add	a2,a2,-1794 # 80007000 <_trampoline>
    8000070a:	040005b7          	lui	a1,0x4000
    8000070e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000710:	05b2                	sll	a1,a1,0xc
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	f1a080e7          	jalr	-230(ra) # 8000062e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000071c:	8526                	mv	a0,s1
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	608080e7          	jalr	1544(ra) # 80000d26 <proc_mapstacks>
}
    80000726:	8526                	mv	a0,s1
    80000728:	60e2                	ld	ra,24(sp)
    8000072a:	6442                	ld	s0,16(sp)
    8000072c:	64a2                	ld	s1,8(sp)
    8000072e:	6902                	ld	s2,0(sp)
    80000730:	6105                	add	sp,sp,32
    80000732:	8082                	ret

0000000080000734 <kvminit>:
{
    80000734:	1141                	add	sp,sp,-16
    80000736:	e406                	sd	ra,8(sp)
    80000738:	e022                	sd	s0,0(sp)
    8000073a:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	f22080e7          	jalr	-222(ra) # 8000065e <kvmmake>
    80000744:	00008797          	auipc	a5,0x8
    80000748:	2ea7b223          	sd	a0,740(a5) # 80008a28 <kernel_pagetable>
}
    8000074c:	60a2                	ld	ra,8(sp)
    8000074e:	6402                	ld	s0,0(sp)
    80000750:	0141                	add	sp,sp,16
    80000752:	8082                	ret

0000000080000754 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000754:	715d                	add	sp,sp,-80
    80000756:	e486                	sd	ra,72(sp)
    80000758:	e0a2                	sd	s0,64(sp)
    8000075a:	fc26                	sd	s1,56(sp)
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
    80000768:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076a:	03459793          	sll	a5,a1,0x34
    8000076e:	e795                	bnez	a5,8000079a <uvmunmap+0x46>
    80000770:	8a2a                	mv	s4,a0
    80000772:	892e                	mv	s2,a1
    80000774:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000776:	0632                	sll	a2,a2,0xc
    80000778:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000077c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077e:	6b05                	lui	s6,0x1
    80000780:	0735e263          	bltu	a1,s3,800007e4 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000784:	60a6                	ld	ra,72(sp)
    80000786:	6406                	ld	s0,64(sp)
    80000788:	74e2                	ld	s1,56(sp)
    8000078a:	7942                	ld	s2,48(sp)
    8000078c:	79a2                	ld	s3,40(sp)
    8000078e:	7a02                	ld	s4,32(sp)
    80000790:	6ae2                	ld	s5,24(sp)
    80000792:	6b42                	ld	s6,16(sp)
    80000794:	6ba2                	ld	s7,8(sp)
    80000796:	6161                	add	sp,sp,80
    80000798:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079a:	00008517          	auipc	a0,0x8
    8000079e:	8e650513          	add	a0,a0,-1818 # 80008080 <etext+0x80>
    800007a2:	00005097          	auipc	ra,0x5
    800007a6:	4e4080e7          	jalr	1252(ra) # 80005c86 <panic>
      panic("uvmunmap: walk");
    800007aa:	00008517          	auipc	a0,0x8
    800007ae:	8ee50513          	add	a0,a0,-1810 # 80008098 <etext+0x98>
    800007b2:	00005097          	auipc	ra,0x5
    800007b6:	4d4080e7          	jalr	1236(ra) # 80005c86 <panic>
      panic("uvmunmap: not mapped");
    800007ba:	00008517          	auipc	a0,0x8
    800007be:	8ee50513          	add	a0,a0,-1810 # 800080a8 <etext+0xa8>
    800007c2:	00005097          	auipc	ra,0x5
    800007c6:	4c4080e7          	jalr	1220(ra) # 80005c86 <panic>
      panic("uvmunmap: not a leaf");
    800007ca:	00008517          	auipc	a0,0x8
    800007ce:	8f650513          	add	a0,a0,-1802 # 800080c0 <etext+0xc0>
    800007d2:	00005097          	auipc	ra,0x5
    800007d6:	4b4080e7          	jalr	1204(ra) # 80005c86 <panic>
    *pte = 0;
    800007da:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007de:	995a                	add	s2,s2,s6
    800007e0:	fb3972e3          	bgeu	s2,s3,80000784 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e4:	4601                	li	a2,0
    800007e6:	85ca                	mv	a1,s2
    800007e8:	8552                	mv	a0,s4
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	cbc080e7          	jalr	-836(ra) # 800004a6 <walk>
    800007f2:	84aa                	mv	s1,a0
    800007f4:	d95d                	beqz	a0,800007aa <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007f6:	6108                	ld	a0,0(a0)
    800007f8:	00157793          	and	a5,a0,1
    800007fc:	dfdd                	beqz	a5,800007ba <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007fe:	3ff57793          	and	a5,a0,1023
    80000802:	fd7784e3          	beq	a5,s7,800007ca <uvmunmap+0x76>
    if(do_free){
    80000806:	fc0a8ae3          	beqz	s5,800007da <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000080a:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    8000080c:	0532                	sll	a0,a0,0xc
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	80e080e7          	jalr	-2034(ra) # 8000001c <kfree>
    80000816:	b7d1                	j	800007da <uvmunmap+0x86>

0000000080000818 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000818:	1101                	add	sp,sp,-32
    8000081a:	ec06                	sd	ra,24(sp)
    8000081c:	e822                	sd	s0,16(sp)
    8000081e:	e426                	sd	s1,8(sp)
    80000820:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000822:	00000097          	auipc	ra,0x0
    80000826:	8f8080e7          	jalr	-1800(ra) # 8000011a <kalloc>
    8000082a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000082c:	c519                	beqz	a0,8000083a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000082e:	6605                	lui	a2,0x1
    80000830:	4581                	li	a1,0
    80000832:	00000097          	auipc	ra,0x0
    80000836:	992080e7          	jalr	-1646(ra) # 800001c4 <memset>
  return pagetable;
}
    8000083a:	8526                	mv	a0,s1
    8000083c:	60e2                	ld	ra,24(sp)
    8000083e:	6442                	ld	s0,16(sp)
    80000840:	64a2                	ld	s1,8(sp)
    80000842:	6105                	add	sp,sp,32
    80000844:	8082                	ret

0000000080000846 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000846:	7179                	add	sp,sp,-48
    80000848:	f406                	sd	ra,40(sp)
    8000084a:	f022                	sd	s0,32(sp)
    8000084c:	ec26                	sd	s1,24(sp)
    8000084e:	e84a                	sd	s2,16(sp)
    80000850:	e44e                	sd	s3,8(sp)
    80000852:	e052                	sd	s4,0(sp)
    80000854:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000856:	6785                	lui	a5,0x1
    80000858:	04f67863          	bgeu	a2,a5,800008a8 <uvmfirst+0x62>
    8000085c:	8a2a                	mv	s4,a0
    8000085e:	89ae                	mv	s3,a1
    80000860:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000862:	00000097          	auipc	ra,0x0
    80000866:	8b8080e7          	jalr	-1864(ra) # 8000011a <kalloc>
    8000086a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000086c:	6605                	lui	a2,0x1
    8000086e:	4581                	li	a1,0
    80000870:	00000097          	auipc	ra,0x0
    80000874:	954080e7          	jalr	-1708(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000878:	4779                	li	a4,30
    8000087a:	86ca                	mv	a3,s2
    8000087c:	6605                	lui	a2,0x1
    8000087e:	4581                	li	a1,0
    80000880:	8552                	mv	a0,s4
    80000882:	00000097          	auipc	ra,0x0
    80000886:	d0c080e7          	jalr	-756(ra) # 8000058e <mappages>
  memmove(mem, src, sz);
    8000088a:	8626                	mv	a2,s1
    8000088c:	85ce                	mv	a1,s3
    8000088e:	854a                	mv	a0,s2
    80000890:	00000097          	auipc	ra,0x0
    80000894:	990080e7          	jalr	-1648(ra) # 80000220 <memmove>
}
    80000898:	70a2                	ld	ra,40(sp)
    8000089a:	7402                	ld	s0,32(sp)
    8000089c:	64e2                	ld	s1,24(sp)
    8000089e:	6942                	ld	s2,16(sp)
    800008a0:	69a2                	ld	s3,8(sp)
    800008a2:	6a02                	ld	s4,0(sp)
    800008a4:	6145                	add	sp,sp,48
    800008a6:	8082                	ret
    panic("uvmfirst: more than a page");
    800008a8:	00008517          	auipc	a0,0x8
    800008ac:	83050513          	add	a0,a0,-2000 # 800080d8 <etext+0xd8>
    800008b0:	00005097          	auipc	ra,0x5
    800008b4:	3d6080e7          	jalr	982(ra) # 80005c86 <panic>

00000000800008b8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008b8:	1101                	add	sp,sp,-32
    800008ba:	ec06                	sd	ra,24(sp)
    800008bc:	e822                	sd	s0,16(sp)
    800008be:	e426                	sd	s1,8(sp)
    800008c0:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c4:	00b67d63          	bgeu	a2,a1,800008de <uvmdealloc+0x26>
    800008c8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ca:	6785                	lui	a5,0x1
    800008cc:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ce:	00f60733          	add	a4,a2,a5
    800008d2:	76fd                	lui	a3,0xfffff
    800008d4:	8f75                	and	a4,a4,a3
    800008d6:	97ae                	add	a5,a5,a1
    800008d8:	8ff5                	and	a5,a5,a3
    800008da:	00f76863          	bltu	a4,a5,800008ea <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008de:	8526                	mv	a0,s1
    800008e0:	60e2                	ld	ra,24(sp)
    800008e2:	6442                	ld	s0,16(sp)
    800008e4:	64a2                	ld	s1,8(sp)
    800008e6:	6105                	add	sp,sp,32
    800008e8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ea:	8f99                	sub	a5,a5,a4
    800008ec:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ee:	4685                	li	a3,1
    800008f0:	0007861b          	sext.w	a2,a5
    800008f4:	85ba                	mv	a1,a4
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	e5e080e7          	jalr	-418(ra) # 80000754 <uvmunmap>
    800008fe:	b7c5                	j	800008de <uvmdealloc+0x26>

0000000080000900 <uvmalloc>:
  if(newsz < oldsz)
    80000900:	0ab66563          	bltu	a2,a1,800009aa <uvmalloc+0xaa>
{
    80000904:	7139                	add	sp,sp,-64
    80000906:	fc06                	sd	ra,56(sp)
    80000908:	f822                	sd	s0,48(sp)
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	f04a                	sd	s2,32(sp)
    8000090e:	ec4e                	sd	s3,24(sp)
    80000910:	e852                	sd	s4,16(sp)
    80000912:	e456                	sd	s5,8(sp)
    80000914:	e05a                	sd	s6,0(sp)
    80000916:	0080                	add	s0,sp,64
    80000918:	8aaa                	mv	s5,a0
    8000091a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091c:	6785                	lui	a5,0x1
    8000091e:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000920:	95be                	add	a1,a1,a5
    80000922:	77fd                	lui	a5,0xfffff
    80000924:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000928:	08c9f363          	bgeu	s3,a2,800009ae <uvmalloc+0xae>
    8000092c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092e:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80000932:	fffff097          	auipc	ra,0xfffff
    80000936:	7e8080e7          	jalr	2024(ra) # 8000011a <kalloc>
    8000093a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093c:	c51d                	beqz	a0,8000096a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000093e:	6605                	lui	a2,0x1
    80000940:	4581                	li	a1,0
    80000942:	00000097          	auipc	ra,0x0
    80000946:	882080e7          	jalr	-1918(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000094a:	875a                	mv	a4,s6
    8000094c:	86a6                	mv	a3,s1
    8000094e:	6605                	lui	a2,0x1
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	c3a080e7          	jalr	-966(ra) # 8000058e <mappages>
    8000095c:	e90d                	bnez	a0,8000098e <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095e:	6785                	lui	a5,0x1
    80000960:	993e                	add	s2,s2,a5
    80000962:	fd4968e3          	bltu	s2,s4,80000932 <uvmalloc+0x32>
  return newsz;
    80000966:	8552                	mv	a0,s4
    80000968:	a809                	j	8000097a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000096a:	864e                	mv	a2,s3
    8000096c:	85ca                	mv	a1,s2
    8000096e:	8556                	mv	a0,s5
    80000970:	00000097          	auipc	ra,0x0
    80000974:	f48080e7          	jalr	-184(ra) # 800008b8 <uvmdealloc>
      return 0;
    80000978:	4501                	li	a0,0
}
    8000097a:	70e2                	ld	ra,56(sp)
    8000097c:	7442                	ld	s0,48(sp)
    8000097e:	74a2                	ld	s1,40(sp)
    80000980:	7902                	ld	s2,32(sp)
    80000982:	69e2                	ld	s3,24(sp)
    80000984:	6a42                	ld	s4,16(sp)
    80000986:	6aa2                	ld	s5,8(sp)
    80000988:	6b02                	ld	s6,0(sp)
    8000098a:	6121                	add	sp,sp,64
    8000098c:	8082                	ret
      kfree(mem);
    8000098e:	8526                	mv	a0,s1
    80000990:	fffff097          	auipc	ra,0xfffff
    80000994:	68c080e7          	jalr	1676(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000998:	864e                	mv	a2,s3
    8000099a:	85ca                	mv	a1,s2
    8000099c:	8556                	mv	a0,s5
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	f1a080e7          	jalr	-230(ra) # 800008b8 <uvmdealloc>
      return 0;
    800009a6:	4501                	li	a0,0
    800009a8:	bfc9                	j	8000097a <uvmalloc+0x7a>
    return oldsz;
    800009aa:	852e                	mv	a0,a1
}
    800009ac:	8082                	ret
  return newsz;
    800009ae:	8532                	mv	a0,a2
    800009b0:	b7e9                	j	8000097a <uvmalloc+0x7a>

00000000800009b2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b2:	7179                	add	sp,sp,-48
    800009b4:	f406                	sd	ra,40(sp)
    800009b6:	f022                	sd	s0,32(sp)
    800009b8:	ec26                	sd	s1,24(sp)
    800009ba:	e84a                	sd	s2,16(sp)
    800009bc:	e44e                	sd	s3,8(sp)
    800009be:	e052                	sd	s4,0(sp)
    800009c0:	1800                	add	s0,sp,48
    800009c2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c4:	84aa                	mv	s1,a0
    800009c6:	6905                	lui	s2,0x1
    800009c8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ca:	4985                	li	s3,1
    800009cc:	a829                	j	800009e6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ce:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009d0:	00c79513          	sll	a0,a5,0xc
    800009d4:	00000097          	auipc	ra,0x0
    800009d8:	fde080e7          	jalr	-34(ra) # 800009b2 <freewalk>
      pagetable[i] = 0;
    800009dc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e0:	04a1                	add	s1,s1,8
    800009e2:	03248163          	beq	s1,s2,80000a04 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009e6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e8:	00f7f713          	and	a4,a5,15
    800009ec:	ff3701e3          	beq	a4,s3,800009ce <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f0:	8b85                	and	a5,a5,1
    800009f2:	d7fd                	beqz	a5,800009e0 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009f4:	00007517          	auipc	a0,0x7
    800009f8:	70450513          	add	a0,a0,1796 # 800080f8 <etext+0xf8>
    800009fc:	00005097          	auipc	ra,0x5
    80000a00:	28a080e7          	jalr	650(ra) # 80005c86 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a04:	8552                	mv	a0,s4
    80000a06:	fffff097          	auipc	ra,0xfffff
    80000a0a:	616080e7          	jalr	1558(ra) # 8000001c <kfree>
}
    80000a0e:	70a2                	ld	ra,40(sp)
    80000a10:	7402                	ld	s0,32(sp)
    80000a12:	64e2                	ld	s1,24(sp)
    80000a14:	6942                	ld	s2,16(sp)
    80000a16:	69a2                	ld	s3,8(sp)
    80000a18:	6a02                	ld	s4,0(sp)
    80000a1a:	6145                	add	sp,sp,48
    80000a1c:	8082                	ret

0000000080000a1e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a1e:	1101                	add	sp,sp,-32
    80000a20:	ec06                	sd	ra,24(sp)
    80000a22:	e822                	sd	s0,16(sp)
    80000a24:	e426                	sd	s1,8(sp)
    80000a26:	1000                	add	s0,sp,32
    80000a28:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a2a:	e999                	bnez	a1,80000a40 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a2c:	8526                	mv	a0,s1
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	f84080e7          	jalr	-124(ra) # 800009b2 <freewalk>
}
    80000a36:	60e2                	ld	ra,24(sp)
    80000a38:	6442                	ld	s0,16(sp)
    80000a3a:	64a2                	ld	s1,8(sp)
    80000a3c:	6105                	add	sp,sp,32
    80000a3e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a40:	6785                	lui	a5,0x1
    80000a42:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a44:	95be                	add	a1,a1,a5
    80000a46:	4685                	li	a3,1
    80000a48:	00c5d613          	srl	a2,a1,0xc
    80000a4c:	4581                	li	a1,0
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	d06080e7          	jalr	-762(ra) # 80000754 <uvmunmap>
    80000a56:	bfd9                	j	80000a2c <uvmfree+0xe>

0000000080000a58 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a58:	c679                	beqz	a2,80000b26 <uvmcopy+0xce>
{
    80000a5a:	715d                	add	sp,sp,-80
    80000a5c:	e486                	sd	ra,72(sp)
    80000a5e:	e0a2                	sd	s0,64(sp)
    80000a60:	fc26                	sd	s1,56(sp)
    80000a62:	f84a                	sd	s2,48(sp)
    80000a64:	f44e                	sd	s3,40(sp)
    80000a66:	f052                	sd	s4,32(sp)
    80000a68:	ec56                	sd	s5,24(sp)
    80000a6a:	e85a                	sd	s6,16(sp)
    80000a6c:	e45e                	sd	s7,8(sp)
    80000a6e:	0880                	add	s0,sp,80
    80000a70:	8b2a                	mv	s6,a0
    80000a72:	8aae                	mv	s5,a1
    80000a74:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a78:	4601                	li	a2,0
    80000a7a:	85ce                	mv	a1,s3
    80000a7c:	855a                	mv	a0,s6
    80000a7e:	00000097          	auipc	ra,0x0
    80000a82:	a28080e7          	jalr	-1496(ra) # 800004a6 <walk>
    80000a86:	c531                	beqz	a0,80000ad2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a88:	6118                	ld	a4,0(a0)
    80000a8a:	00177793          	and	a5,a4,1
    80000a8e:	cbb1                	beqz	a5,80000ae2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a90:	00a75593          	srl	a1,a4,0xa
    80000a94:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a98:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a9c:	fffff097          	auipc	ra,0xfffff
    80000aa0:	67e080e7          	jalr	1662(ra) # 8000011a <kalloc>
    80000aa4:	892a                	mv	s2,a0
    80000aa6:	c939                	beqz	a0,80000afc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa8:	6605                	lui	a2,0x1
    80000aaa:	85de                	mv	a1,s7
    80000aac:	fffff097          	auipc	ra,0xfffff
    80000ab0:	774080e7          	jalr	1908(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ab4:	8726                	mv	a4,s1
    80000ab6:	86ca                	mv	a3,s2
    80000ab8:	6605                	lui	a2,0x1
    80000aba:	85ce                	mv	a1,s3
    80000abc:	8556                	mv	a0,s5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	ad0080e7          	jalr	-1328(ra) # 8000058e <mappages>
    80000ac6:	e515                	bnez	a0,80000af2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac8:	6785                	lui	a5,0x1
    80000aca:	99be                	add	s3,s3,a5
    80000acc:	fb49e6e3          	bltu	s3,s4,80000a78 <uvmcopy+0x20>
    80000ad0:	a081                	j	80000b10 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	63650513          	add	a0,a0,1590 # 80008108 <etext+0x108>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	1ac080e7          	jalr	428(ra) # 80005c86 <panic>
      panic("uvmcopy: page not present");
    80000ae2:	00007517          	auipc	a0,0x7
    80000ae6:	64650513          	add	a0,a0,1606 # 80008128 <etext+0x128>
    80000aea:	00005097          	auipc	ra,0x5
    80000aee:	19c080e7          	jalr	412(ra) # 80005c86 <panic>
      kfree(mem);
    80000af2:	854a                	mv	a0,s2
    80000af4:	fffff097          	auipc	ra,0xfffff
    80000af8:	528080e7          	jalr	1320(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000afc:	4685                	li	a3,1
    80000afe:	00c9d613          	srl	a2,s3,0xc
    80000b02:	4581                	li	a1,0
    80000b04:	8556                	mv	a0,s5
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	c4e080e7          	jalr	-946(ra) # 80000754 <uvmunmap>
  return -1;
    80000b0e:	557d                	li	a0,-1
}
    80000b10:	60a6                	ld	ra,72(sp)
    80000b12:	6406                	ld	s0,64(sp)
    80000b14:	74e2                	ld	s1,56(sp)
    80000b16:	7942                	ld	s2,48(sp)
    80000b18:	79a2                	ld	s3,40(sp)
    80000b1a:	7a02                	ld	s4,32(sp)
    80000b1c:	6ae2                	ld	s5,24(sp)
    80000b1e:	6b42                	ld	s6,16(sp)
    80000b20:	6ba2                	ld	s7,8(sp)
    80000b22:	6161                	add	sp,sp,80
    80000b24:	8082                	ret
  return 0;
    80000b26:	4501                	li	a0,0
}
    80000b28:	8082                	ret

0000000080000b2a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b2a:	1141                	add	sp,sp,-16
    80000b2c:	e406                	sd	ra,8(sp)
    80000b2e:	e022                	sd	s0,0(sp)
    80000b30:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b32:	4601                	li	a2,0
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	972080e7          	jalr	-1678(ra) # 800004a6 <walk>
  if(pte == 0)
    80000b3c:	c901                	beqz	a0,80000b4c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b3e:	611c                	ld	a5,0(a0)
    80000b40:	9bbd                	and	a5,a5,-17
    80000b42:	e11c                	sd	a5,0(a0)
}
    80000b44:	60a2                	ld	ra,8(sp)
    80000b46:	6402                	ld	s0,0(sp)
    80000b48:	0141                	add	sp,sp,16
    80000b4a:	8082                	ret
    panic("uvmclear");
    80000b4c:	00007517          	auipc	a0,0x7
    80000b50:	5fc50513          	add	a0,a0,1532 # 80008148 <etext+0x148>
    80000b54:	00005097          	auipc	ra,0x5
    80000b58:	132080e7          	jalr	306(ra) # 80005c86 <panic>

0000000080000b5c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b5c:	c6bd                	beqz	a3,80000bca <copyout+0x6e>
{
    80000b5e:	715d                	add	sp,sp,-80
    80000b60:	e486                	sd	ra,72(sp)
    80000b62:	e0a2                	sd	s0,64(sp)
    80000b64:	fc26                	sd	s1,56(sp)
    80000b66:	f84a                	sd	s2,48(sp)
    80000b68:	f44e                	sd	s3,40(sp)
    80000b6a:	f052                	sd	s4,32(sp)
    80000b6c:	ec56                	sd	s5,24(sp)
    80000b6e:	e85a                	sd	s6,16(sp)
    80000b70:	e45e                	sd	s7,8(sp)
    80000b72:	e062                	sd	s8,0(sp)
    80000b74:	0880                	add	s0,sp,80
    80000b76:	8b2a                	mv	s6,a0
    80000b78:	8c2e                	mv	s8,a1
    80000b7a:	8a32                	mv	s4,a2
    80000b7c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b7e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b80:	6a85                	lui	s5,0x1
    80000b82:	a015                	j	80000ba6 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b84:	9562                	add	a0,a0,s8
    80000b86:	0004861b          	sext.w	a2,s1
    80000b8a:	85d2                	mv	a1,s4
    80000b8c:	41250533          	sub	a0,a0,s2
    80000b90:	fffff097          	auipc	ra,0xfffff
    80000b94:	690080e7          	jalr	1680(ra) # 80000220 <memmove>

    len -= n;
    80000b98:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b9c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b9e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba2:	02098263          	beqz	s3,80000bc6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000ba6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000baa:	85ca                	mv	a1,s2
    80000bac:	855a                	mv	a0,s6
    80000bae:	00000097          	auipc	ra,0x0
    80000bb2:	99e080e7          	jalr	-1634(ra) # 8000054c <walkaddr>
    if(pa0 == 0)
    80000bb6:	cd01                	beqz	a0,80000bce <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb8:	418904b3          	sub	s1,s2,s8
    80000bbc:	94d6                	add	s1,s1,s5
    80000bbe:	fc99f3e3          	bgeu	s3,s1,80000b84 <copyout+0x28>
    80000bc2:	84ce                	mv	s1,s3
    80000bc4:	b7c1                	j	80000b84 <copyout+0x28>
  }
  return 0;
    80000bc6:	4501                	li	a0,0
    80000bc8:	a021                	j	80000bd0 <copyout+0x74>
    80000bca:	4501                	li	a0,0
}
    80000bcc:	8082                	ret
      return -1;
    80000bce:	557d                	li	a0,-1
}
    80000bd0:	60a6                	ld	ra,72(sp)
    80000bd2:	6406                	ld	s0,64(sp)
    80000bd4:	74e2                	ld	s1,56(sp)
    80000bd6:	7942                	ld	s2,48(sp)
    80000bd8:	79a2                	ld	s3,40(sp)
    80000bda:	7a02                	ld	s4,32(sp)
    80000bdc:	6ae2                	ld	s5,24(sp)
    80000bde:	6b42                	ld	s6,16(sp)
    80000be0:	6ba2                	ld	s7,8(sp)
    80000be2:	6c02                	ld	s8,0(sp)
    80000be4:	6161                	add	sp,sp,80
    80000be6:	8082                	ret

0000000080000be8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be8:	caa5                	beqz	a3,80000c58 <copyin+0x70>
{
    80000bea:	715d                	add	sp,sp,-80
    80000bec:	e486                	sd	ra,72(sp)
    80000bee:	e0a2                	sd	s0,64(sp)
    80000bf0:	fc26                	sd	s1,56(sp)
    80000bf2:	f84a                	sd	s2,48(sp)
    80000bf4:	f44e                	sd	s3,40(sp)
    80000bf6:	f052                	sd	s4,32(sp)
    80000bf8:	ec56                	sd	s5,24(sp)
    80000bfa:	e85a                	sd	s6,16(sp)
    80000bfc:	e45e                	sd	s7,8(sp)
    80000bfe:	e062                	sd	s8,0(sp)
    80000c00:	0880                	add	s0,sp,80
    80000c02:	8b2a                	mv	s6,a0
    80000c04:	8a2e                	mv	s4,a1
    80000c06:	8c32                	mv	s8,a2
    80000c08:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c0a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c0c:	6a85                	lui	s5,0x1
    80000c0e:	a01d                	j	80000c34 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c10:	018505b3          	add	a1,a0,s8
    80000c14:	0004861b          	sext.w	a2,s1
    80000c18:	412585b3          	sub	a1,a1,s2
    80000c1c:	8552                	mv	a0,s4
    80000c1e:	fffff097          	auipc	ra,0xfffff
    80000c22:	602080e7          	jalr	1538(ra) # 80000220 <memmove>

    len -= n;
    80000c26:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c2a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c2c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c30:	02098263          	beqz	s3,80000c54 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c34:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c38:	85ca                	mv	a1,s2
    80000c3a:	855a                	mv	a0,s6
    80000c3c:	00000097          	auipc	ra,0x0
    80000c40:	910080e7          	jalr	-1776(ra) # 8000054c <walkaddr>
    if(pa0 == 0)
    80000c44:	cd01                	beqz	a0,80000c5c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c46:	418904b3          	sub	s1,s2,s8
    80000c4a:	94d6                	add	s1,s1,s5
    80000c4c:	fc99f2e3          	bgeu	s3,s1,80000c10 <copyin+0x28>
    80000c50:	84ce                	mv	s1,s3
    80000c52:	bf7d                	j	80000c10 <copyin+0x28>
  }
  return 0;
    80000c54:	4501                	li	a0,0
    80000c56:	a021                	j	80000c5e <copyin+0x76>
    80000c58:	4501                	li	a0,0
}
    80000c5a:	8082                	ret
      return -1;
    80000c5c:	557d                	li	a0,-1
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
    80000c70:	6c02                	ld	s8,0(sp)
    80000c72:	6161                	add	sp,sp,80
    80000c74:	8082                	ret

0000000080000c76 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c76:	c2dd                	beqz	a3,80000d1c <copyinstr+0xa6>
{
    80000c78:	715d                	add	sp,sp,-80
    80000c7a:	e486                	sd	ra,72(sp)
    80000c7c:	e0a2                	sd	s0,64(sp)
    80000c7e:	fc26                	sd	s1,56(sp)
    80000c80:	f84a                	sd	s2,48(sp)
    80000c82:	f44e                	sd	s3,40(sp)
    80000c84:	f052                	sd	s4,32(sp)
    80000c86:	ec56                	sd	s5,24(sp)
    80000c88:	e85a                	sd	s6,16(sp)
    80000c8a:	e45e                	sd	s7,8(sp)
    80000c8c:	0880                	add	s0,sp,80
    80000c8e:	8a2a                	mv	s4,a0
    80000c90:	8b2e                	mv	s6,a1
    80000c92:	8bb2                	mv	s7,a2
    80000c94:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c96:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c98:	6985                	lui	s3,0x1
    80000c9a:	a02d                	j	80000cc4 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c9c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ca2:	37fd                	addw	a5,a5,-1
    80000ca4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca8:	60a6                	ld	ra,72(sp)
    80000caa:	6406                	ld	s0,64(sp)
    80000cac:	74e2                	ld	s1,56(sp)
    80000cae:	7942                	ld	s2,48(sp)
    80000cb0:	79a2                	ld	s3,40(sp)
    80000cb2:	7a02                	ld	s4,32(sp)
    80000cb4:	6ae2                	ld	s5,24(sp)
    80000cb6:	6b42                	ld	s6,16(sp)
    80000cb8:	6ba2                	ld	s7,8(sp)
    80000cba:	6161                	add	sp,sp,80
    80000cbc:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cbe:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cc2:	c8a9                	beqz	s1,80000d14 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cc4:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc8:	85ca                	mv	a1,s2
    80000cca:	8552                	mv	a0,s4
    80000ccc:	00000097          	auipc	ra,0x0
    80000cd0:	880080e7          	jalr	-1920(ra) # 8000054c <walkaddr>
    if(pa0 == 0)
    80000cd4:	c131                	beqz	a0,80000d18 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000cd6:	417906b3          	sub	a3,s2,s7
    80000cda:	96ce                	add	a3,a3,s3
    80000cdc:	00d4f363          	bgeu	s1,a3,80000ce2 <copyinstr+0x6c>
    80000ce0:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000ce2:	955e                	add	a0,a0,s7
    80000ce4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce8:	daf9                	beqz	a3,80000cbe <copyinstr+0x48>
    80000cea:	87da                	mv	a5,s6
    80000cec:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cee:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000cf2:	96da                	add	a3,a3,s6
    80000cf4:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cf6:	00f60733          	add	a4,a2,a5
    80000cfa:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcf40>
    80000cfe:	df59                	beqz	a4,80000c9c <copyinstr+0x26>
        *dst = *p;
    80000d00:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d04:	0785                	add	a5,a5,1
    while(n > 0){
    80000d06:	fed797e3          	bne	a5,a3,80000cf4 <copyinstr+0x7e>
    80000d0a:	14fd                	add	s1,s1,-1
    80000d0c:	94c2                	add	s1,s1,a6
      --max;
    80000d0e:	8c8d                	sub	s1,s1,a1
      dst++;
    80000d10:	8b3e                	mv	s6,a5
    80000d12:	b775                	j	80000cbe <copyinstr+0x48>
    80000d14:	4781                	li	a5,0
    80000d16:	b771                	j	80000ca2 <copyinstr+0x2c>
      return -1;
    80000d18:	557d                	li	a0,-1
    80000d1a:	b779                	j	80000ca8 <copyinstr+0x32>
  int got_null = 0;
    80000d1c:	4781                	li	a5,0
  if(got_null){
    80000d1e:	37fd                	addw	a5,a5,-1
    80000d20:	0007851b          	sext.w	a0,a5
}
    80000d24:	8082                	ret

0000000080000d26 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d26:	7139                	add	sp,sp,-64
    80000d28:	fc06                	sd	ra,56(sp)
    80000d2a:	f822                	sd	s0,48(sp)
    80000d2c:	f426                	sd	s1,40(sp)
    80000d2e:	f04a                	sd	s2,32(sp)
    80000d30:	ec4e                	sd	s3,24(sp)
    80000d32:	e852                	sd	s4,16(sp)
    80000d34:	e456                	sd	s5,8(sp)
    80000d36:	e05a                	sd	s6,0(sp)
    80000d38:	0080                	add	s0,sp,64
    80000d3a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	00008497          	auipc	s1,0x8
    80000d40:	16448493          	add	s1,s1,356 # 80008ea0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d44:	8b26                	mv	s6,s1
    80000d46:	00007a97          	auipc	s5,0x7
    80000d4a:	2baa8a93          	add	s5,s5,698 # 80008000 <etext>
    80000d4e:	04000937          	lui	s2,0x4000
    80000d52:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d54:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d56:	0000ea17          	auipc	s4,0xe
    80000d5a:	d4aa0a13          	add	s4,s4,-694 # 8000eaa0 <tickslock>
    char *pa = kalloc();
    80000d5e:	fffff097          	auipc	ra,0xfffff
    80000d62:	3bc080e7          	jalr	956(ra) # 8000011a <kalloc>
    80000d66:	862a                	mv	a2,a0
    if(pa == 0)
    80000d68:	c131                	beqz	a0,80000dac <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d6a:	416485b3          	sub	a1,s1,s6
    80000d6e:	8591                	sra	a1,a1,0x4
    80000d70:	000ab783          	ld	a5,0(s5)
    80000d74:	02f585b3          	mul	a1,a1,a5
    80000d78:	2585                	addw	a1,a1,1
    80000d7a:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d7e:	4719                	li	a4,6
    80000d80:	6685                	lui	a3,0x1
    80000d82:	40b905b3          	sub	a1,s2,a1
    80000d86:	854e                	mv	a0,s3
    80000d88:	00000097          	auipc	ra,0x0
    80000d8c:	8a6080e7          	jalr	-1882(ra) # 8000062e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d90:	17048493          	add	s1,s1,368
    80000d94:	fd4495e3          	bne	s1,s4,80000d5e <proc_mapstacks+0x38>
  }
}
    80000d98:	70e2                	ld	ra,56(sp)
    80000d9a:	7442                	ld	s0,48(sp)
    80000d9c:	74a2                	ld	s1,40(sp)
    80000d9e:	7902                	ld	s2,32(sp)
    80000da0:	69e2                	ld	s3,24(sp)
    80000da2:	6a42                	ld	s4,16(sp)
    80000da4:	6aa2                	ld	s5,8(sp)
    80000da6:	6b02                	ld	s6,0(sp)
    80000da8:	6121                	add	sp,sp,64
    80000daa:	8082                	ret
      panic("kalloc");
    80000dac:	00007517          	auipc	a0,0x7
    80000db0:	3ac50513          	add	a0,a0,940 # 80008158 <etext+0x158>
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	ed2080e7          	jalr	-302(ra) # 80005c86 <panic>

0000000080000dbc <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dbc:	7139                	add	sp,sp,-64
    80000dbe:	fc06                	sd	ra,56(sp)
    80000dc0:	f822                	sd	s0,48(sp)
    80000dc2:	f426                	sd	s1,40(sp)
    80000dc4:	f04a                	sd	s2,32(sp)
    80000dc6:	ec4e                	sd	s3,24(sp)
    80000dc8:	e852                	sd	s4,16(sp)
    80000dca:	e456                	sd	s5,8(sp)
    80000dcc:	e05a                	sd	s6,0(sp)
    80000dce:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dd0:	00007597          	auipc	a1,0x7
    80000dd4:	39058593          	add	a1,a1,912 # 80008160 <etext+0x160>
    80000dd8:	00008517          	auipc	a0,0x8
    80000ddc:	c9850513          	add	a0,a0,-872 # 80008a70 <pid_lock>
    80000de0:	00005097          	auipc	ra,0x5
    80000de4:	34e080e7          	jalr	846(ra) # 8000612e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de8:	00007597          	auipc	a1,0x7
    80000dec:	38058593          	add	a1,a1,896 # 80008168 <etext+0x168>
    80000df0:	00008517          	auipc	a0,0x8
    80000df4:	c9850513          	add	a0,a0,-872 # 80008a88 <wait_lock>
    80000df8:	00005097          	auipc	ra,0x5
    80000dfc:	336080e7          	jalr	822(ra) # 8000612e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	00008497          	auipc	s1,0x8
    80000e04:	0a048493          	add	s1,s1,160 # 80008ea0 <proc>
      initlock(&p->lock, "proc");
    80000e08:	00007b17          	auipc	s6,0x7
    80000e0c:	370b0b13          	add	s6,s6,880 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e10:	8aa6                	mv	s5,s1
    80000e12:	00007a17          	auipc	s4,0x7
    80000e16:	1eea0a13          	add	s4,s4,494 # 80008000 <etext>
    80000e1a:	04000937          	lui	s2,0x4000
    80000e1e:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e20:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e22:	0000e997          	auipc	s3,0xe
    80000e26:	c7e98993          	add	s3,s3,-898 # 8000eaa0 <tickslock>
      initlock(&p->lock, "proc");
    80000e2a:	85da                	mv	a1,s6
    80000e2c:	8526                	mv	a0,s1
    80000e2e:	00005097          	auipc	ra,0x5
    80000e32:	300080e7          	jalr	768(ra) # 8000612e <initlock>
      p->state = UNUSED;
    80000e36:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e3a:	415487b3          	sub	a5,s1,s5
    80000e3e:	8791                	sra	a5,a5,0x4
    80000e40:	000a3703          	ld	a4,0(s4)
    80000e44:	02e787b3          	mul	a5,a5,a4
    80000e48:	2785                	addw	a5,a5,1
    80000e4a:	00d7979b          	sllw	a5,a5,0xd
    80000e4e:	40f907b3          	sub	a5,s2,a5
    80000e52:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e54:	17048493          	add	s1,s1,368
    80000e58:	fd3499e3          	bne	s1,s3,80000e2a <procinit+0x6e>
  }
}
    80000e5c:	70e2                	ld	ra,56(sp)
    80000e5e:	7442                	ld	s0,48(sp)
    80000e60:	74a2                	ld	s1,40(sp)
    80000e62:	7902                	ld	s2,32(sp)
    80000e64:	69e2                	ld	s3,24(sp)
    80000e66:	6a42                	ld	s4,16(sp)
    80000e68:	6aa2                	ld	s5,8(sp)
    80000e6a:	6b02                	ld	s6,0(sp)
    80000e6c:	6121                	add	sp,sp,64
    80000e6e:	8082                	ret

0000000080000e70 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e70:	1141                	add	sp,sp,-16
    80000e72:	e422                	sd	s0,8(sp)
    80000e74:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e76:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e78:	2501                	sext.w	a0,a0
    80000e7a:	6422                	ld	s0,8(sp)
    80000e7c:	0141                	add	sp,sp,16
    80000e7e:	8082                	ret

0000000080000e80 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e80:	1141                	add	sp,sp,-16
    80000e82:	e422                	sd	s0,8(sp)
    80000e84:	0800                	add	s0,sp,16
    80000e86:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	079e                	sll	a5,a5,0x7
  return c;
}
    80000e8c:	00008517          	auipc	a0,0x8
    80000e90:	c1450513          	add	a0,a0,-1004 # 80008aa0 <cpus>
    80000e94:	953e                	add	a0,a0,a5
    80000e96:	6422                	ld	s0,8(sp)
    80000e98:	0141                	add	sp,sp,16
    80000e9a:	8082                	ret

0000000080000e9c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e9c:	1101                	add	sp,sp,-32
    80000e9e:	ec06                	sd	ra,24(sp)
    80000ea0:	e822                	sd	s0,16(sp)
    80000ea2:	e426                	sd	s1,8(sp)
    80000ea4:	1000                	add	s0,sp,32
  push_off();
    80000ea6:	00005097          	auipc	ra,0x5
    80000eaa:	2cc080e7          	jalr	716(ra) # 80006172 <push_off>
    80000eae:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eb0:	2781                	sext.w	a5,a5
    80000eb2:	079e                	sll	a5,a5,0x7
    80000eb4:	00008717          	auipc	a4,0x8
    80000eb8:	bbc70713          	add	a4,a4,-1092 # 80008a70 <pid_lock>
    80000ebc:	97ba                	add	a5,a5,a4
    80000ebe:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	352080e7          	jalr	850(ra) # 80006212 <pop_off>
  return p;
}
    80000ec8:	8526                	mv	a0,s1
    80000eca:	60e2                	ld	ra,24(sp)
    80000ecc:	6442                	ld	s0,16(sp)
    80000ece:	64a2                	ld	s1,8(sp)
    80000ed0:	6105                	add	sp,sp,32
    80000ed2:	8082                	ret

0000000080000ed4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ed4:	1141                	add	sp,sp,-16
    80000ed6:	e406                	sd	ra,8(sp)
    80000ed8:	e022                	sd	s0,0(sp)
    80000eda:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000edc:	00000097          	auipc	ra,0x0
    80000ee0:	fc0080e7          	jalr	-64(ra) # 80000e9c <myproc>
    80000ee4:	00005097          	auipc	ra,0x5
    80000ee8:	38e080e7          	jalr	910(ra) # 80006272 <release>

  if (first) {
    80000eec:	00008797          	auipc	a5,0x8
    80000ef0:	ae47a783          	lw	a5,-1308(a5) # 800089d0 <first.1>
    80000ef4:	eb89                	bnez	a5,80000f06 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ef6:	00001097          	auipc	ra,0x1
    80000efa:	c98080e7          	jalr	-872(ra) # 80001b8e <usertrapret>
}
    80000efe:	60a2                	ld	ra,8(sp)
    80000f00:	6402                	ld	s0,0(sp)
    80000f02:	0141                	add	sp,sp,16
    80000f04:	8082                	ret
    first = 0;
    80000f06:	00008797          	auipc	a5,0x8
    80000f0a:	ac07a523          	sw	zero,-1334(a5) # 800089d0 <first.1>
    fsinit(ROOTDEV);
    80000f0e:	4505                	li	a0,1
    80000f10:	00002097          	auipc	ra,0x2
    80000f14:	aa4080e7          	jalr	-1372(ra) # 800029b4 <fsinit>
    80000f18:	bff9                	j	80000ef6 <forkret+0x22>

0000000080000f1a <allocpid>:
{
    80000f1a:	1101                	add	sp,sp,-32
    80000f1c:	ec06                	sd	ra,24(sp)
    80000f1e:	e822                	sd	s0,16(sp)
    80000f20:	e426                	sd	s1,8(sp)
    80000f22:	e04a                	sd	s2,0(sp)
    80000f24:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80000f26:	00008917          	auipc	s2,0x8
    80000f2a:	b4a90913          	add	s2,s2,-1206 # 80008a70 <pid_lock>
    80000f2e:	854a                	mv	a0,s2
    80000f30:	00005097          	auipc	ra,0x5
    80000f34:	28e080e7          	jalr	654(ra) # 800061be <acquire>
  pid = nextpid;
    80000f38:	00008797          	auipc	a5,0x8
    80000f3c:	a9c78793          	add	a5,a5,-1380 # 800089d4 <nextpid>
    80000f40:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f42:	0014871b          	addw	a4,s1,1
    80000f46:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f48:	854a                	mv	a0,s2
    80000f4a:	00005097          	auipc	ra,0x5
    80000f4e:	328080e7          	jalr	808(ra) # 80006272 <release>
}
    80000f52:	8526                	mv	a0,s1
    80000f54:	60e2                	ld	ra,24(sp)
    80000f56:	6442                	ld	s0,16(sp)
    80000f58:	64a2                	ld	s1,8(sp)
    80000f5a:	6902                	ld	s2,0(sp)
    80000f5c:	6105                	add	sp,sp,32
    80000f5e:	8082                	ret

0000000080000f60 <proc_pagetable>:
{
    80000f60:	1101                	add	sp,sp,-32
    80000f62:	ec06                	sd	ra,24(sp)
    80000f64:	e822                	sd	s0,16(sp)
    80000f66:	e426                	sd	s1,8(sp)
    80000f68:	e04a                	sd	s2,0(sp)
    80000f6a:	1000                	add	s0,sp,32
    80000f6c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f6e:	00000097          	auipc	ra,0x0
    80000f72:	8aa080e7          	jalr	-1878(ra) # 80000818 <uvmcreate>
    80000f76:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f78:	c121                	beqz	a0,80000fb8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f7a:	4729                	li	a4,10
    80000f7c:	00006697          	auipc	a3,0x6
    80000f80:	08468693          	add	a3,a3,132 # 80007000 <_trampoline>
    80000f84:	6605                	lui	a2,0x1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f8c:	05b2                	sll	a1,a1,0xc
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	600080e7          	jalr	1536(ra) # 8000058e <mappages>
    80000f96:	02054863          	bltz	a0,80000fc6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f9a:	4719                	li	a4,6
    80000f9c:	05893683          	ld	a3,88(s2)
    80000fa0:	6605                	lui	a2,0x1
    80000fa2:	020005b7          	lui	a1,0x2000
    80000fa6:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fa8:	05b6                	sll	a1,a1,0xd
    80000faa:	8526                	mv	a0,s1
    80000fac:	fffff097          	auipc	ra,0xfffff
    80000fb0:	5e2080e7          	jalr	1506(ra) # 8000058e <mappages>
    80000fb4:	02054163          	bltz	a0,80000fd6 <proc_pagetable+0x76>
}
    80000fb8:	8526                	mv	a0,s1
    80000fba:	60e2                	ld	ra,24(sp)
    80000fbc:	6442                	ld	s0,16(sp)
    80000fbe:	64a2                	ld	s1,8(sp)
    80000fc0:	6902                	ld	s2,0(sp)
    80000fc2:	6105                	add	sp,sp,32
    80000fc4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fc6:	4581                	li	a1,0
    80000fc8:	8526                	mv	a0,s1
    80000fca:	00000097          	auipc	ra,0x0
    80000fce:	a54080e7          	jalr	-1452(ra) # 80000a1e <uvmfree>
    return 0;
    80000fd2:	4481                	li	s1,0
    80000fd4:	b7d5                	j	80000fb8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	040005b7          	lui	a1,0x4000
    80000fde:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fe0:	05b2                	sll	a1,a1,0xc
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	770080e7          	jalr	1904(ra) # 80000754 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fec:	4581                	li	a1,0
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	a2e080e7          	jalr	-1490(ra) # 80000a1e <uvmfree>
    return 0;
    80000ff8:	4481                	li	s1,0
    80000ffa:	bf7d                	j	80000fb8 <proc_pagetable+0x58>

0000000080000ffc <proc_freepagetable>:
{
    80000ffc:	1101                	add	sp,sp,-32
    80000ffe:	ec06                	sd	ra,24(sp)
    80001000:	e822                	sd	s0,16(sp)
    80001002:	e426                	sd	s1,8(sp)
    80001004:	e04a                	sd	s2,0(sp)
    80001006:	1000                	add	s0,sp,32
    80001008:	84aa                	mv	s1,a0
    8000100a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000100c:	4681                	li	a3,0
    8000100e:	4605                	li	a2,1
    80001010:	040005b7          	lui	a1,0x4000
    80001014:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001016:	05b2                	sll	a1,a1,0xc
    80001018:	fffff097          	auipc	ra,0xfffff
    8000101c:	73c080e7          	jalr	1852(ra) # 80000754 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001020:	4681                	li	a3,0
    80001022:	4605                	li	a2,1
    80001024:	020005b7          	lui	a1,0x2000
    80001028:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000102a:	05b6                	sll	a1,a1,0xd
    8000102c:	8526                	mv	a0,s1
    8000102e:	fffff097          	auipc	ra,0xfffff
    80001032:	726080e7          	jalr	1830(ra) # 80000754 <uvmunmap>
  uvmfree(pagetable, sz);
    80001036:	85ca                	mv	a1,s2
    80001038:	8526                	mv	a0,s1
    8000103a:	00000097          	auipc	ra,0x0
    8000103e:	9e4080e7          	jalr	-1564(ra) # 80000a1e <uvmfree>
}
    80001042:	60e2                	ld	ra,24(sp)
    80001044:	6442                	ld	s0,16(sp)
    80001046:	64a2                	ld	s1,8(sp)
    80001048:	6902                	ld	s2,0(sp)
    8000104a:	6105                	add	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <freeproc>:
{
    8000104e:	1101                	add	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	1000                	add	s0,sp,32
    80001058:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000105a:	6d28                	ld	a0,88(a0)
    8000105c:	c509                	beqz	a0,80001066 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000105e:	fffff097          	auipc	ra,0xfffff
    80001062:	fbe080e7          	jalr	-66(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001066:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000106a:	68a8                	ld	a0,80(s1)
    8000106c:	c511                	beqz	a0,80001078 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000106e:	64ac                	ld	a1,72(s1)
    80001070:	00000097          	auipc	ra,0x0
    80001074:	f8c080e7          	jalr	-116(ra) # 80000ffc <proc_freepagetable>
  p->pagetable = 0;
    80001078:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000107c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001080:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001084:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001088:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000108c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001090:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001094:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001098:	0004ac23          	sw	zero,24(s1)
}
    8000109c:	60e2                	ld	ra,24(sp)
    8000109e:	6442                	ld	s0,16(sp)
    800010a0:	64a2                	ld	s1,8(sp)
    800010a2:	6105                	add	sp,sp,32
    800010a4:	8082                	ret

00000000800010a6 <allocproc>:
{
    800010a6:	1101                	add	sp,sp,-32
    800010a8:	ec06                	sd	ra,24(sp)
    800010aa:	e822                	sd	s0,16(sp)
    800010ac:	e426                	sd	s1,8(sp)
    800010ae:	e04a                	sd	s2,0(sp)
    800010b0:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b2:	00008497          	auipc	s1,0x8
    800010b6:	dee48493          	add	s1,s1,-530 # 80008ea0 <proc>
    800010ba:	0000e917          	auipc	s2,0xe
    800010be:	9e690913          	add	s2,s2,-1562 # 8000eaa0 <tickslock>
    acquire(&p->lock);
    800010c2:	8526                	mv	a0,s1
    800010c4:	00005097          	auipc	ra,0x5
    800010c8:	0fa080e7          	jalr	250(ra) # 800061be <acquire>
    if(p->state == UNUSED) {
    800010cc:	4c9c                	lw	a5,24(s1)
    800010ce:	cf81                	beqz	a5,800010e6 <allocproc+0x40>
      release(&p->lock);
    800010d0:	8526                	mv	a0,s1
    800010d2:	00005097          	auipc	ra,0x5
    800010d6:	1a0080e7          	jalr	416(ra) # 80006272 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010da:	17048493          	add	s1,s1,368
    800010de:	ff2492e3          	bne	s1,s2,800010c2 <allocproc+0x1c>
  return 0;
    800010e2:	4481                	li	s1,0
    800010e4:	a899                	j	8000113a <allocproc+0x94>
  p->pid = allocpid();
    800010e6:	00000097          	auipc	ra,0x0
    800010ea:	e34080e7          	jalr	-460(ra) # 80000f1a <allocpid>
    800010ee:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010f0:	4785                	li	a5,1
    800010f2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010f4:	fffff097          	auipc	ra,0xfffff
    800010f8:	026080e7          	jalr	38(ra) # 8000011a <kalloc>
    800010fc:	892a                	mv	s2,a0
    800010fe:	eca8                	sd	a0,88(s1)
    80001100:	c521                	beqz	a0,80001148 <allocproc+0xa2>
  p->pagetable = proc_pagetable(p);
    80001102:	8526                	mv	a0,s1
    80001104:	00000097          	auipc	ra,0x0
    80001108:	e5c080e7          	jalr	-420(ra) # 80000f60 <proc_pagetable>
    8000110c:	892a                	mv	s2,a0
    8000110e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001110:	c921                	beqz	a0,80001160 <allocproc+0xba>
  memset(&p->context, 0, sizeof(p->context));
    80001112:	07000613          	li	a2,112
    80001116:	4581                	li	a1,0
    80001118:	06048513          	add	a0,s1,96
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	0a8080e7          	jalr	168(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    80001124:	00000797          	auipc	a5,0x0
    80001128:	db078793          	add	a5,a5,-592 # 80000ed4 <forkret>
    8000112c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000112e:	60bc                	ld	a5,64(s1)
    80001130:	6705                	lui	a4,0x1
    80001132:	97ba                	add	a5,a5,a4
    80001134:	f4bc                	sd	a5,104(s1)
  p->trace_mask = 0;
    80001136:	1604a423          	sw	zero,360(s1)
}
    8000113a:	8526                	mv	a0,s1
    8000113c:	60e2                	ld	ra,24(sp)
    8000113e:	6442                	ld	s0,16(sp)
    80001140:	64a2                	ld	s1,8(sp)
    80001142:	6902                	ld	s2,0(sp)
    80001144:	6105                	add	sp,sp,32
    80001146:	8082                	ret
    freeproc(p);
    80001148:	8526                	mv	a0,s1
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	f04080e7          	jalr	-252(ra) # 8000104e <freeproc>
    release(&p->lock);
    80001152:	8526                	mv	a0,s1
    80001154:	00005097          	auipc	ra,0x5
    80001158:	11e080e7          	jalr	286(ra) # 80006272 <release>
    return 0;
    8000115c:	84ca                	mv	s1,s2
    8000115e:	bff1                	j	8000113a <allocproc+0x94>
    freeproc(p);
    80001160:	8526                	mv	a0,s1
    80001162:	00000097          	auipc	ra,0x0
    80001166:	eec080e7          	jalr	-276(ra) # 8000104e <freeproc>
    release(&p->lock);
    8000116a:	8526                	mv	a0,s1
    8000116c:	00005097          	auipc	ra,0x5
    80001170:	106080e7          	jalr	262(ra) # 80006272 <release>
    return 0;
    80001174:	84ca                	mv	s1,s2
    80001176:	b7d1                	j	8000113a <allocproc+0x94>

0000000080001178 <userinit>:
{
    80001178:	1101                	add	sp,sp,-32
    8000117a:	ec06                	sd	ra,24(sp)
    8000117c:	e822                	sd	s0,16(sp)
    8000117e:	e426                	sd	s1,8(sp)
    80001180:	1000                	add	s0,sp,32
  p = allocproc();
    80001182:	00000097          	auipc	ra,0x0
    80001186:	f24080e7          	jalr	-220(ra) # 800010a6 <allocproc>
    8000118a:	84aa                	mv	s1,a0
  initproc = p;
    8000118c:	00008797          	auipc	a5,0x8
    80001190:	8aa7b223          	sd	a0,-1884(a5) # 80008a30 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001194:	03400613          	li	a2,52
    80001198:	00008597          	auipc	a1,0x8
    8000119c:	84858593          	add	a1,a1,-1976 # 800089e0 <initcode>
    800011a0:	6928                	ld	a0,80(a0)
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	6a4080e7          	jalr	1700(ra) # 80000846 <uvmfirst>
  p->sz = PGSIZE;
    800011aa:	6785                	lui	a5,0x1
    800011ac:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ae:	6cb8                	ld	a4,88(s1)
    800011b0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011b4:	6cb8                	ld	a4,88(s1)
    800011b6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011b8:	4641                	li	a2,16
    800011ba:	00007597          	auipc	a1,0x7
    800011be:	fc658593          	add	a1,a1,-58 # 80008180 <etext+0x180>
    800011c2:	15848513          	add	a0,s1,344
    800011c6:	fffff097          	auipc	ra,0xfffff
    800011ca:	146080e7          	jalr	326(ra) # 8000030c <safestrcpy>
  p->cwd = namei("/");
    800011ce:	00007517          	auipc	a0,0x7
    800011d2:	fc250513          	add	a0,a0,-62 # 80008190 <etext+0x190>
    800011d6:	00002097          	auipc	ra,0x2
    800011da:	1fc080e7          	jalr	508(ra) # 800033d2 <namei>
    800011de:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011e2:	478d                	li	a5,3
    800011e4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011e6:	8526                	mv	a0,s1
    800011e8:	00005097          	auipc	ra,0x5
    800011ec:	08a080e7          	jalr	138(ra) # 80006272 <release>
}
    800011f0:	60e2                	ld	ra,24(sp)
    800011f2:	6442                	ld	s0,16(sp)
    800011f4:	64a2                	ld	s1,8(sp)
    800011f6:	6105                	add	sp,sp,32
    800011f8:	8082                	ret

00000000800011fa <growproc>:
{
    800011fa:	1101                	add	sp,sp,-32
    800011fc:	ec06                	sd	ra,24(sp)
    800011fe:	e822                	sd	s0,16(sp)
    80001200:	e426                	sd	s1,8(sp)
    80001202:	e04a                	sd	s2,0(sp)
    80001204:	1000                	add	s0,sp,32
    80001206:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	c94080e7          	jalr	-876(ra) # 80000e9c <myproc>
    80001210:	84aa                	mv	s1,a0
  sz = p->sz;
    80001212:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001214:	01204c63          	bgtz	s2,8000122c <growproc+0x32>
  } else if(n < 0){
    80001218:	02094663          	bltz	s2,80001244 <growproc+0x4a>
  p->sz = sz;
    8000121c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000121e:	4501                	li	a0,0
}
    80001220:	60e2                	ld	ra,24(sp)
    80001222:	6442                	ld	s0,16(sp)
    80001224:	64a2                	ld	s1,8(sp)
    80001226:	6902                	ld	s2,0(sp)
    80001228:	6105                	add	sp,sp,32
    8000122a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000122c:	4691                	li	a3,4
    8000122e:	00b90633          	add	a2,s2,a1
    80001232:	6928                	ld	a0,80(a0)
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	6cc080e7          	jalr	1740(ra) # 80000900 <uvmalloc>
    8000123c:	85aa                	mv	a1,a0
    8000123e:	fd79                	bnez	a0,8000121c <growproc+0x22>
      return -1;
    80001240:	557d                	li	a0,-1
    80001242:	bff9                	j	80001220 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001244:	00b90633          	add	a2,s2,a1
    80001248:	6928                	ld	a0,80(a0)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	66e080e7          	jalr	1646(ra) # 800008b8 <uvmdealloc>
    80001252:	85aa                	mv	a1,a0
    80001254:	b7e1                	j	8000121c <growproc+0x22>

0000000080001256 <fork>:
{
    80001256:	7139                	add	sp,sp,-64
    80001258:	fc06                	sd	ra,56(sp)
    8000125a:	f822                	sd	s0,48(sp)
    8000125c:	f426                	sd	s1,40(sp)
    8000125e:	f04a                	sd	s2,32(sp)
    80001260:	ec4e                	sd	s3,24(sp)
    80001262:	e852                	sd	s4,16(sp)
    80001264:	e456                	sd	s5,8(sp)
    80001266:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	c34080e7          	jalr	-972(ra) # 80000e9c <myproc>
    80001270:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001272:	00000097          	auipc	ra,0x0
    80001276:	e34080e7          	jalr	-460(ra) # 800010a6 <allocproc>
    8000127a:	12050063          	beqz	a0,8000139a <fork+0x144>
    8000127e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001280:	048ab603          	ld	a2,72(s5)
    80001284:	692c                	ld	a1,80(a0)
    80001286:	050ab503          	ld	a0,80(s5)
    8000128a:	fffff097          	auipc	ra,0xfffff
    8000128e:	7ce080e7          	jalr	1998(ra) # 80000a58 <uvmcopy>
    80001292:	04054863          	bltz	a0,800012e2 <fork+0x8c>
  np->sz = p->sz;
    80001296:	048ab783          	ld	a5,72(s5)
    8000129a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000129e:	058ab683          	ld	a3,88(s5)
    800012a2:	87b6                	mv	a5,a3
    800012a4:	0589b703          	ld	a4,88(s3)
    800012a8:	12068693          	add	a3,a3,288
    800012ac:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b0:	6788                	ld	a0,8(a5)
    800012b2:	6b8c                	ld	a1,16(a5)
    800012b4:	6f90                	ld	a2,24(a5)
    800012b6:	01073023          	sd	a6,0(a4)
    800012ba:	e708                	sd	a0,8(a4)
    800012bc:	eb0c                	sd	a1,16(a4)
    800012be:	ef10                	sd	a2,24(a4)
    800012c0:	02078793          	add	a5,a5,32
    800012c4:	02070713          	add	a4,a4,32
    800012c8:	fed792e3          	bne	a5,a3,800012ac <fork+0x56>
  np->trapframe->a0 = 0;
    800012cc:	0589b783          	ld	a5,88(s3)
    800012d0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012d4:	0d0a8493          	add	s1,s5,208
    800012d8:	0d098913          	add	s2,s3,208
    800012dc:	150a8a13          	add	s4,s5,336
    800012e0:	a00d                	j	80001302 <fork+0xac>
    freeproc(np);
    800012e2:	854e                	mv	a0,s3
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	d6a080e7          	jalr	-662(ra) # 8000104e <freeproc>
    release(&np->lock);
    800012ec:	854e                	mv	a0,s3
    800012ee:	00005097          	auipc	ra,0x5
    800012f2:	f84080e7          	jalr	-124(ra) # 80006272 <release>
    return -1;
    800012f6:	597d                	li	s2,-1
    800012f8:	a079                	j	80001386 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012fa:	04a1                	add	s1,s1,8
    800012fc:	0921                	add	s2,s2,8
    800012fe:	01448b63          	beq	s1,s4,80001314 <fork+0xbe>
    if(p->ofile[i])
    80001302:	6088                	ld	a0,0(s1)
    80001304:	d97d                	beqz	a0,800012fa <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001306:	00002097          	auipc	ra,0x2
    8000130a:	73e080e7          	jalr	1854(ra) # 80003a44 <filedup>
    8000130e:	00a93023          	sd	a0,0(s2)
    80001312:	b7e5                	j	800012fa <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001314:	150ab503          	ld	a0,336(s5)
    80001318:	00002097          	auipc	ra,0x2
    8000131c:	8d6080e7          	jalr	-1834(ra) # 80002bee <idup>
    80001320:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001324:	4641                	li	a2,16
    80001326:	158a8593          	add	a1,s5,344
    8000132a:	15898513          	add	a0,s3,344
    8000132e:	fffff097          	auipc	ra,0xfffff
    80001332:	fde080e7          	jalr	-34(ra) # 8000030c <safestrcpy>
  np->trace_mask = p->trace_mask;
    80001336:	168aa783          	lw	a5,360(s5)
    8000133a:	16f9a423          	sw	a5,360(s3)
  pid = np->pid;
    8000133e:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001342:	854e                	mv	a0,s3
    80001344:	00005097          	auipc	ra,0x5
    80001348:	f2e080e7          	jalr	-210(ra) # 80006272 <release>
  acquire(&wait_lock);
    8000134c:	00007497          	auipc	s1,0x7
    80001350:	73c48493          	add	s1,s1,1852 # 80008a88 <wait_lock>
    80001354:	8526                	mv	a0,s1
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	e68080e7          	jalr	-408(ra) # 800061be <acquire>
  np->parent = p;
    8000135e:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001362:	8526                	mv	a0,s1
    80001364:	00005097          	auipc	ra,0x5
    80001368:	f0e080e7          	jalr	-242(ra) # 80006272 <release>
  acquire(&np->lock);
    8000136c:	854e                	mv	a0,s3
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	e50080e7          	jalr	-432(ra) # 800061be <acquire>
  np->state = RUNNABLE;
    80001376:	478d                	li	a5,3
    80001378:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000137c:	854e                	mv	a0,s3
    8000137e:	00005097          	auipc	ra,0x5
    80001382:	ef4080e7          	jalr	-268(ra) # 80006272 <release>
}
    80001386:	854a                	mv	a0,s2
    80001388:	70e2                	ld	ra,56(sp)
    8000138a:	7442                	ld	s0,48(sp)
    8000138c:	74a2                	ld	s1,40(sp)
    8000138e:	7902                	ld	s2,32(sp)
    80001390:	69e2                	ld	s3,24(sp)
    80001392:	6a42                	ld	s4,16(sp)
    80001394:	6aa2                	ld	s5,8(sp)
    80001396:	6121                	add	sp,sp,64
    80001398:	8082                	ret
    return -1;
    8000139a:	597d                	li	s2,-1
    8000139c:	b7ed                	j	80001386 <fork+0x130>

000000008000139e <scheduler>:
{
    8000139e:	7139                	add	sp,sp,-64
    800013a0:	fc06                	sd	ra,56(sp)
    800013a2:	f822                	sd	s0,48(sp)
    800013a4:	f426                	sd	s1,40(sp)
    800013a6:	f04a                	sd	s2,32(sp)
    800013a8:	ec4e                	sd	s3,24(sp)
    800013aa:	e852                	sd	s4,16(sp)
    800013ac:	e456                	sd	s5,8(sp)
    800013ae:	e05a                	sd	s6,0(sp)
    800013b0:	0080                	add	s0,sp,64
    800013b2:	8792                	mv	a5,tp
  int id = r_tp();
    800013b4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013b6:	00779a93          	sll	s5,a5,0x7
    800013ba:	00007717          	auipc	a4,0x7
    800013be:	6b670713          	add	a4,a4,1718 # 80008a70 <pid_lock>
    800013c2:	9756                	add	a4,a4,s5
    800013c4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013c8:	00007717          	auipc	a4,0x7
    800013cc:	6e070713          	add	a4,a4,1760 # 80008aa8 <cpus+0x8>
    800013d0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d2:	498d                	li	s3,3
        p->state = RUNNING;
    800013d4:	4b11                	li	s6,4
        c->proc = p;
    800013d6:	079e                	sll	a5,a5,0x7
    800013d8:	00007a17          	auipc	s4,0x7
    800013dc:	698a0a13          	add	s4,s4,1688 # 80008a70 <pid_lock>
    800013e0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e2:	0000d917          	auipc	s2,0xd
    800013e6:	6be90913          	add	s2,s2,1726 # 8000eaa0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ea:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013ee:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f2:	10079073          	csrw	sstatus,a5
    800013f6:	00008497          	auipc	s1,0x8
    800013fa:	aaa48493          	add	s1,s1,-1366 # 80008ea0 <proc>
    800013fe:	a811                	j	80001412 <scheduler+0x74>
      release(&p->lock);
    80001400:	8526                	mv	a0,s1
    80001402:	00005097          	auipc	ra,0x5
    80001406:	e70080e7          	jalr	-400(ra) # 80006272 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140a:	17048493          	add	s1,s1,368
    8000140e:	fd248ee3          	beq	s1,s2,800013ea <scheduler+0x4c>
      acquire(&p->lock);
    80001412:	8526                	mv	a0,s1
    80001414:	00005097          	auipc	ra,0x5
    80001418:	daa080e7          	jalr	-598(ra) # 800061be <acquire>
      if(p->state == RUNNABLE) {
    8000141c:	4c9c                	lw	a5,24(s1)
    8000141e:	ff3791e3          	bne	a5,s3,80001400 <scheduler+0x62>
        p->state = RUNNING;
    80001422:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001426:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000142a:	06048593          	add	a1,s1,96
    8000142e:	8556                	mv	a0,s5
    80001430:	00000097          	auipc	ra,0x0
    80001434:	6b4080e7          	jalr	1716(ra) # 80001ae4 <swtch>
        c->proc = 0;
    80001438:	020a3823          	sd	zero,48(s4)
    8000143c:	b7d1                	j	80001400 <scheduler+0x62>

000000008000143e <sched>:
{
    8000143e:	7179                	add	sp,sp,-48
    80001440:	f406                	sd	ra,40(sp)
    80001442:	f022                	sd	s0,32(sp)
    80001444:	ec26                	sd	s1,24(sp)
    80001446:	e84a                	sd	s2,16(sp)
    80001448:	e44e                	sd	s3,8(sp)
    8000144a:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	a50080e7          	jalr	-1456(ra) # 80000e9c <myproc>
    80001454:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001456:	00005097          	auipc	ra,0x5
    8000145a:	cee080e7          	jalr	-786(ra) # 80006144 <holding>
    8000145e:	c93d                	beqz	a0,800014d4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001460:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001462:	2781                	sext.w	a5,a5
    80001464:	079e                	sll	a5,a5,0x7
    80001466:	00007717          	auipc	a4,0x7
    8000146a:	60a70713          	add	a4,a4,1546 # 80008a70 <pid_lock>
    8000146e:	97ba                	add	a5,a5,a4
    80001470:	0a87a703          	lw	a4,168(a5)
    80001474:	4785                	li	a5,1
    80001476:	06f71763          	bne	a4,a5,800014e4 <sched+0xa6>
  if(p->state == RUNNING)
    8000147a:	4c98                	lw	a4,24(s1)
    8000147c:	4791                	li	a5,4
    8000147e:	06f70b63          	beq	a4,a5,800014f4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001482:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001486:	8b89                	and	a5,a5,2
  if(intr_get())
    80001488:	efb5                	bnez	a5,80001504 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000148c:	00007917          	auipc	s2,0x7
    80001490:	5e490913          	add	s2,s2,1508 # 80008a70 <pid_lock>
    80001494:	2781                	sext.w	a5,a5
    80001496:	079e                	sll	a5,a5,0x7
    80001498:	97ca                	add	a5,a5,s2
    8000149a:	0ac7a983          	lw	s3,172(a5)
    8000149e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a0:	2781                	sext.w	a5,a5
    800014a2:	079e                	sll	a5,a5,0x7
    800014a4:	00007597          	auipc	a1,0x7
    800014a8:	60458593          	add	a1,a1,1540 # 80008aa8 <cpus+0x8>
    800014ac:	95be                	add	a1,a1,a5
    800014ae:	06048513          	add	a0,s1,96
    800014b2:	00000097          	auipc	ra,0x0
    800014b6:	632080e7          	jalr	1586(ra) # 80001ae4 <swtch>
    800014ba:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014bc:	2781                	sext.w	a5,a5
    800014be:	079e                	sll	a5,a5,0x7
    800014c0:	993e                	add	s2,s2,a5
    800014c2:	0b392623          	sw	s3,172(s2)
}
    800014c6:	70a2                	ld	ra,40(sp)
    800014c8:	7402                	ld	s0,32(sp)
    800014ca:	64e2                	ld	s1,24(sp)
    800014cc:	6942                	ld	s2,16(sp)
    800014ce:	69a2                	ld	s3,8(sp)
    800014d0:	6145                	add	sp,sp,48
    800014d2:	8082                	ret
    panic("sched p->lock");
    800014d4:	00007517          	auipc	a0,0x7
    800014d8:	cc450513          	add	a0,a0,-828 # 80008198 <etext+0x198>
    800014dc:	00004097          	auipc	ra,0x4
    800014e0:	7aa080e7          	jalr	1962(ra) # 80005c86 <panic>
    panic("sched locks");
    800014e4:	00007517          	auipc	a0,0x7
    800014e8:	cc450513          	add	a0,a0,-828 # 800081a8 <etext+0x1a8>
    800014ec:	00004097          	auipc	ra,0x4
    800014f0:	79a080e7          	jalr	1946(ra) # 80005c86 <panic>
    panic("sched running");
    800014f4:	00007517          	auipc	a0,0x7
    800014f8:	cc450513          	add	a0,a0,-828 # 800081b8 <etext+0x1b8>
    800014fc:	00004097          	auipc	ra,0x4
    80001500:	78a080e7          	jalr	1930(ra) # 80005c86 <panic>
    panic("sched interruptible");
    80001504:	00007517          	auipc	a0,0x7
    80001508:	cc450513          	add	a0,a0,-828 # 800081c8 <etext+0x1c8>
    8000150c:	00004097          	auipc	ra,0x4
    80001510:	77a080e7          	jalr	1914(ra) # 80005c86 <panic>

0000000080001514 <yield>:
{
    80001514:	1101                	add	sp,sp,-32
    80001516:	ec06                	sd	ra,24(sp)
    80001518:	e822                	sd	s0,16(sp)
    8000151a:	e426                	sd	s1,8(sp)
    8000151c:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	97e080e7          	jalr	-1666(ra) # 80000e9c <myproc>
    80001526:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	c96080e7          	jalr	-874(ra) # 800061be <acquire>
  p->state = RUNNABLE;
    80001530:	478d                	li	a5,3
    80001532:	cc9c                	sw	a5,24(s1)
  sched();
    80001534:	00000097          	auipc	ra,0x0
    80001538:	f0a080e7          	jalr	-246(ra) # 8000143e <sched>
  release(&p->lock);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	d34080e7          	jalr	-716(ra) # 80006272 <release>
}
    80001546:	60e2                	ld	ra,24(sp)
    80001548:	6442                	ld	s0,16(sp)
    8000154a:	64a2                	ld	s1,8(sp)
    8000154c:	6105                	add	sp,sp,32
    8000154e:	8082                	ret

0000000080001550 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001550:	7179                	add	sp,sp,-48
    80001552:	f406                	sd	ra,40(sp)
    80001554:	f022                	sd	s0,32(sp)
    80001556:	ec26                	sd	s1,24(sp)
    80001558:	e84a                	sd	s2,16(sp)
    8000155a:	e44e                	sd	s3,8(sp)
    8000155c:	1800                	add	s0,sp,48
    8000155e:	89aa                	mv	s3,a0
    80001560:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001562:	00000097          	auipc	ra,0x0
    80001566:	93a080e7          	jalr	-1734(ra) # 80000e9c <myproc>
    8000156a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000156c:	00005097          	auipc	ra,0x5
    80001570:	c52080e7          	jalr	-942(ra) # 800061be <acquire>
  release(lk);
    80001574:	854a                	mv	a0,s2
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	cfc080e7          	jalr	-772(ra) # 80006272 <release>

  // Go to sleep.
  p->chan = chan;
    8000157e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001582:	4789                	li	a5,2
    80001584:	cc9c                	sw	a5,24(s1)

  sched();
    80001586:	00000097          	auipc	ra,0x0
    8000158a:	eb8080e7          	jalr	-328(ra) # 8000143e <sched>

  // Tidy up.
  p->chan = 0;
    8000158e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001592:	8526                	mv	a0,s1
    80001594:	00005097          	auipc	ra,0x5
    80001598:	cde080e7          	jalr	-802(ra) # 80006272 <release>
  acquire(lk);
    8000159c:	854a                	mv	a0,s2
    8000159e:	00005097          	auipc	ra,0x5
    800015a2:	c20080e7          	jalr	-992(ra) # 800061be <acquire>
}
    800015a6:	70a2                	ld	ra,40(sp)
    800015a8:	7402                	ld	s0,32(sp)
    800015aa:	64e2                	ld	s1,24(sp)
    800015ac:	6942                	ld	s2,16(sp)
    800015ae:	69a2                	ld	s3,8(sp)
    800015b0:	6145                	add	sp,sp,48
    800015b2:	8082                	ret

00000000800015b4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015b4:	7139                	add	sp,sp,-64
    800015b6:	fc06                	sd	ra,56(sp)
    800015b8:	f822                	sd	s0,48(sp)
    800015ba:	f426                	sd	s1,40(sp)
    800015bc:	f04a                	sd	s2,32(sp)
    800015be:	ec4e                	sd	s3,24(sp)
    800015c0:	e852                	sd	s4,16(sp)
    800015c2:	e456                	sd	s5,8(sp)
    800015c4:	0080                	add	s0,sp,64
    800015c6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015c8:	00008497          	auipc	s1,0x8
    800015cc:	8d848493          	add	s1,s1,-1832 # 80008ea0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015d0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015d2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015d4:	0000d917          	auipc	s2,0xd
    800015d8:	4cc90913          	add	s2,s2,1228 # 8000eaa0 <tickslock>
    800015dc:	a811                	j	800015f0 <wakeup+0x3c>
      }
      release(&p->lock);
    800015de:	8526                	mv	a0,s1
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	c92080e7          	jalr	-878(ra) # 80006272 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015e8:	17048493          	add	s1,s1,368
    800015ec:	03248663          	beq	s1,s2,80001618 <wakeup+0x64>
    if(p != myproc()){
    800015f0:	00000097          	auipc	ra,0x0
    800015f4:	8ac080e7          	jalr	-1876(ra) # 80000e9c <myproc>
    800015f8:	fea488e3          	beq	s1,a0,800015e8 <wakeup+0x34>
      acquire(&p->lock);
    800015fc:	8526                	mv	a0,s1
    800015fe:	00005097          	auipc	ra,0x5
    80001602:	bc0080e7          	jalr	-1088(ra) # 800061be <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001606:	4c9c                	lw	a5,24(s1)
    80001608:	fd379be3          	bne	a5,s3,800015de <wakeup+0x2a>
    8000160c:	709c                	ld	a5,32(s1)
    8000160e:	fd4798e3          	bne	a5,s4,800015de <wakeup+0x2a>
        p->state = RUNNABLE;
    80001612:	0154ac23          	sw	s5,24(s1)
    80001616:	b7e1                	j	800015de <wakeup+0x2a>
    }
  }
}
    80001618:	70e2                	ld	ra,56(sp)
    8000161a:	7442                	ld	s0,48(sp)
    8000161c:	74a2                	ld	s1,40(sp)
    8000161e:	7902                	ld	s2,32(sp)
    80001620:	69e2                	ld	s3,24(sp)
    80001622:	6a42                	ld	s4,16(sp)
    80001624:	6aa2                	ld	s5,8(sp)
    80001626:	6121                	add	sp,sp,64
    80001628:	8082                	ret

000000008000162a <reparent>:
{
    8000162a:	7179                	add	sp,sp,-48
    8000162c:	f406                	sd	ra,40(sp)
    8000162e:	f022                	sd	s0,32(sp)
    80001630:	ec26                	sd	s1,24(sp)
    80001632:	e84a                	sd	s2,16(sp)
    80001634:	e44e                	sd	s3,8(sp)
    80001636:	e052                	sd	s4,0(sp)
    80001638:	1800                	add	s0,sp,48
    8000163a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163c:	00008497          	auipc	s1,0x8
    80001640:	86448493          	add	s1,s1,-1948 # 80008ea0 <proc>
      pp->parent = initproc;
    80001644:	00007a17          	auipc	s4,0x7
    80001648:	3eca0a13          	add	s4,s4,1004 # 80008a30 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000164c:	0000d997          	auipc	s3,0xd
    80001650:	45498993          	add	s3,s3,1108 # 8000eaa0 <tickslock>
    80001654:	a029                	j	8000165e <reparent+0x34>
    80001656:	17048493          	add	s1,s1,368
    8000165a:	01348d63          	beq	s1,s3,80001674 <reparent+0x4a>
    if(pp->parent == p){
    8000165e:	7c9c                	ld	a5,56(s1)
    80001660:	ff279be3          	bne	a5,s2,80001656 <reparent+0x2c>
      pp->parent = initproc;
    80001664:	000a3503          	ld	a0,0(s4)
    80001668:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	f4a080e7          	jalr	-182(ra) # 800015b4 <wakeup>
    80001672:	b7d5                	j	80001656 <reparent+0x2c>
}
    80001674:	70a2                	ld	ra,40(sp)
    80001676:	7402                	ld	s0,32(sp)
    80001678:	64e2                	ld	s1,24(sp)
    8000167a:	6942                	ld	s2,16(sp)
    8000167c:	69a2                	ld	s3,8(sp)
    8000167e:	6a02                	ld	s4,0(sp)
    80001680:	6145                	add	sp,sp,48
    80001682:	8082                	ret

0000000080001684 <exit>:
{
    80001684:	7179                	add	sp,sp,-48
    80001686:	f406                	sd	ra,40(sp)
    80001688:	f022                	sd	s0,32(sp)
    8000168a:	ec26                	sd	s1,24(sp)
    8000168c:	e84a                	sd	s2,16(sp)
    8000168e:	e44e                	sd	s3,8(sp)
    80001690:	e052                	sd	s4,0(sp)
    80001692:	1800                	add	s0,sp,48
    80001694:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001696:	00000097          	auipc	ra,0x0
    8000169a:	806080e7          	jalr	-2042(ra) # 80000e9c <myproc>
    8000169e:	89aa                	mv	s3,a0
  if(p == initproc)
    800016a0:	00007797          	auipc	a5,0x7
    800016a4:	3907b783          	ld	a5,912(a5) # 80008a30 <initproc>
    800016a8:	0d050493          	add	s1,a0,208
    800016ac:	15050913          	add	s2,a0,336
    800016b0:	02a79363          	bne	a5,a0,800016d6 <exit+0x52>
    panic("init exiting");
    800016b4:	00007517          	auipc	a0,0x7
    800016b8:	b2c50513          	add	a0,a0,-1236 # 800081e0 <etext+0x1e0>
    800016bc:	00004097          	auipc	ra,0x4
    800016c0:	5ca080e7          	jalr	1482(ra) # 80005c86 <panic>
      fileclose(f);
    800016c4:	00002097          	auipc	ra,0x2
    800016c8:	3d2080e7          	jalr	978(ra) # 80003a96 <fileclose>
      p->ofile[fd] = 0;
    800016cc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016d0:	04a1                	add	s1,s1,8
    800016d2:	01248563          	beq	s1,s2,800016dc <exit+0x58>
    if(p->ofile[fd]){
    800016d6:	6088                	ld	a0,0(s1)
    800016d8:	f575                	bnez	a0,800016c4 <exit+0x40>
    800016da:	bfdd                	j	800016d0 <exit+0x4c>
  begin_op();
    800016dc:	00002097          	auipc	ra,0x2
    800016e0:	ef6080e7          	jalr	-266(ra) # 800035d2 <begin_op>
  iput(p->cwd);
    800016e4:	1509b503          	ld	a0,336(s3)
    800016e8:	00001097          	auipc	ra,0x1
    800016ec:	6fe080e7          	jalr	1790(ra) # 80002de6 <iput>
  end_op();
    800016f0:	00002097          	auipc	ra,0x2
    800016f4:	f5c080e7          	jalr	-164(ra) # 8000364c <end_op>
  p->cwd = 0;
    800016f8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016fc:	00007497          	auipc	s1,0x7
    80001700:	38c48493          	add	s1,s1,908 # 80008a88 <wait_lock>
    80001704:	8526                	mv	a0,s1
    80001706:	00005097          	auipc	ra,0x5
    8000170a:	ab8080e7          	jalr	-1352(ra) # 800061be <acquire>
  reparent(p);
    8000170e:	854e                	mv	a0,s3
    80001710:	00000097          	auipc	ra,0x0
    80001714:	f1a080e7          	jalr	-230(ra) # 8000162a <reparent>
  wakeup(p->parent);
    80001718:	0389b503          	ld	a0,56(s3)
    8000171c:	00000097          	auipc	ra,0x0
    80001720:	e98080e7          	jalr	-360(ra) # 800015b4 <wakeup>
  acquire(&p->lock);
    80001724:	854e                	mv	a0,s3
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	a98080e7          	jalr	-1384(ra) # 800061be <acquire>
  p->xstate = status;
    8000172e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001732:	4795                	li	a5,5
    80001734:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001738:	8526                	mv	a0,s1
    8000173a:	00005097          	auipc	ra,0x5
    8000173e:	b38080e7          	jalr	-1224(ra) # 80006272 <release>
  sched();
    80001742:	00000097          	auipc	ra,0x0
    80001746:	cfc080e7          	jalr	-772(ra) # 8000143e <sched>
  panic("zombie exit");
    8000174a:	00007517          	auipc	a0,0x7
    8000174e:	aa650513          	add	a0,a0,-1370 # 800081f0 <etext+0x1f0>
    80001752:	00004097          	auipc	ra,0x4
    80001756:	534080e7          	jalr	1332(ra) # 80005c86 <panic>

000000008000175a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000175a:	7179                	add	sp,sp,-48
    8000175c:	f406                	sd	ra,40(sp)
    8000175e:	f022                	sd	s0,32(sp)
    80001760:	ec26                	sd	s1,24(sp)
    80001762:	e84a                	sd	s2,16(sp)
    80001764:	e44e                	sd	s3,8(sp)
    80001766:	1800                	add	s0,sp,48
    80001768:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000176a:	00007497          	auipc	s1,0x7
    8000176e:	73648493          	add	s1,s1,1846 # 80008ea0 <proc>
    80001772:	0000d997          	auipc	s3,0xd
    80001776:	32e98993          	add	s3,s3,814 # 8000eaa0 <tickslock>
    acquire(&p->lock);
    8000177a:	8526                	mv	a0,s1
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	a42080e7          	jalr	-1470(ra) # 800061be <acquire>
    if(p->pid == pid){
    80001784:	589c                	lw	a5,48(s1)
    80001786:	01278d63          	beq	a5,s2,800017a0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000178a:	8526                	mv	a0,s1
    8000178c:	00005097          	auipc	ra,0x5
    80001790:	ae6080e7          	jalr	-1306(ra) # 80006272 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001794:	17048493          	add	s1,s1,368
    80001798:	ff3491e3          	bne	s1,s3,8000177a <kill+0x20>
  }
  return -1;
    8000179c:	557d                	li	a0,-1
    8000179e:	a829                	j	800017b8 <kill+0x5e>
      p->killed = 1;
    800017a0:	4785                	li	a5,1
    800017a2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017a4:	4c98                	lw	a4,24(s1)
    800017a6:	4789                	li	a5,2
    800017a8:	00f70f63          	beq	a4,a5,800017c6 <kill+0x6c>
      release(&p->lock);
    800017ac:	8526                	mv	a0,s1
    800017ae:	00005097          	auipc	ra,0x5
    800017b2:	ac4080e7          	jalr	-1340(ra) # 80006272 <release>
      return 0;
    800017b6:	4501                	li	a0,0
}
    800017b8:	70a2                	ld	ra,40(sp)
    800017ba:	7402                	ld	s0,32(sp)
    800017bc:	64e2                	ld	s1,24(sp)
    800017be:	6942                	ld	s2,16(sp)
    800017c0:	69a2                	ld	s3,8(sp)
    800017c2:	6145                	add	sp,sp,48
    800017c4:	8082                	ret
        p->state = RUNNABLE;
    800017c6:	478d                	li	a5,3
    800017c8:	cc9c                	sw	a5,24(s1)
    800017ca:	b7cd                	j	800017ac <kill+0x52>

00000000800017cc <setkilled>:

void
setkilled(struct proc *p)
{
    800017cc:	1101                	add	sp,sp,-32
    800017ce:	ec06                	sd	ra,24(sp)
    800017d0:	e822                	sd	s0,16(sp)
    800017d2:	e426                	sd	s1,8(sp)
    800017d4:	1000                	add	s0,sp,32
    800017d6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017d8:	00005097          	auipc	ra,0x5
    800017dc:	9e6080e7          	jalr	-1562(ra) # 800061be <acquire>
  p->killed = 1;
    800017e0:	4785                	li	a5,1
    800017e2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017e4:	8526                	mv	a0,s1
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	a8c080e7          	jalr	-1396(ra) # 80006272 <release>
}
    800017ee:	60e2                	ld	ra,24(sp)
    800017f0:	6442                	ld	s0,16(sp)
    800017f2:	64a2                	ld	s1,8(sp)
    800017f4:	6105                	add	sp,sp,32
    800017f6:	8082                	ret

00000000800017f8 <killed>:

int
killed(struct proc *p)
{
    800017f8:	1101                	add	sp,sp,-32
    800017fa:	ec06                	sd	ra,24(sp)
    800017fc:	e822                	sd	s0,16(sp)
    800017fe:	e426                	sd	s1,8(sp)
    80001800:	e04a                	sd	s2,0(sp)
    80001802:	1000                	add	s0,sp,32
    80001804:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001806:	00005097          	auipc	ra,0x5
    8000180a:	9b8080e7          	jalr	-1608(ra) # 800061be <acquire>
  k = p->killed;
    8000180e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001812:	8526                	mv	a0,s1
    80001814:	00005097          	auipc	ra,0x5
    80001818:	a5e080e7          	jalr	-1442(ra) # 80006272 <release>
  return k;
}
    8000181c:	854a                	mv	a0,s2
    8000181e:	60e2                	ld	ra,24(sp)
    80001820:	6442                	ld	s0,16(sp)
    80001822:	64a2                	ld	s1,8(sp)
    80001824:	6902                	ld	s2,0(sp)
    80001826:	6105                	add	sp,sp,32
    80001828:	8082                	ret

000000008000182a <wait>:
{
    8000182a:	715d                	add	sp,sp,-80
    8000182c:	e486                	sd	ra,72(sp)
    8000182e:	e0a2                	sd	s0,64(sp)
    80001830:	fc26                	sd	s1,56(sp)
    80001832:	f84a                	sd	s2,48(sp)
    80001834:	f44e                	sd	s3,40(sp)
    80001836:	f052                	sd	s4,32(sp)
    80001838:	ec56                	sd	s5,24(sp)
    8000183a:	e85a                	sd	s6,16(sp)
    8000183c:	e45e                	sd	s7,8(sp)
    8000183e:	e062                	sd	s8,0(sp)
    80001840:	0880                	add	s0,sp,80
    80001842:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001844:	fffff097          	auipc	ra,0xfffff
    80001848:	658080e7          	jalr	1624(ra) # 80000e9c <myproc>
    8000184c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000184e:	00007517          	auipc	a0,0x7
    80001852:	23a50513          	add	a0,a0,570 # 80008a88 <wait_lock>
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	968080e7          	jalr	-1688(ra) # 800061be <acquire>
    havekids = 0;
    8000185e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001860:	4a15                	li	s4,5
        havekids = 1;
    80001862:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001864:	0000d997          	auipc	s3,0xd
    80001868:	23c98993          	add	s3,s3,572 # 8000eaa0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000186c:	00007c17          	auipc	s8,0x7
    80001870:	21cc0c13          	add	s8,s8,540 # 80008a88 <wait_lock>
    80001874:	a0d1                	j	80001938 <wait+0x10e>
          pid = pp->pid;
    80001876:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000187a:	000b0e63          	beqz	s6,80001896 <wait+0x6c>
    8000187e:	4691                	li	a3,4
    80001880:	02c48613          	add	a2,s1,44
    80001884:	85da                	mv	a1,s6
    80001886:	05093503          	ld	a0,80(s2)
    8000188a:	fffff097          	auipc	ra,0xfffff
    8000188e:	2d2080e7          	jalr	722(ra) # 80000b5c <copyout>
    80001892:	04054163          	bltz	a0,800018d4 <wait+0xaa>
          freeproc(pp);
    80001896:	8526                	mv	a0,s1
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	7b6080e7          	jalr	1974(ra) # 8000104e <freeproc>
          release(&pp->lock);
    800018a0:	8526                	mv	a0,s1
    800018a2:	00005097          	auipc	ra,0x5
    800018a6:	9d0080e7          	jalr	-1584(ra) # 80006272 <release>
          release(&wait_lock);
    800018aa:	00007517          	auipc	a0,0x7
    800018ae:	1de50513          	add	a0,a0,478 # 80008a88 <wait_lock>
    800018b2:	00005097          	auipc	ra,0x5
    800018b6:	9c0080e7          	jalr	-1600(ra) # 80006272 <release>
}
    800018ba:	854e                	mv	a0,s3
    800018bc:	60a6                	ld	ra,72(sp)
    800018be:	6406                	ld	s0,64(sp)
    800018c0:	74e2                	ld	s1,56(sp)
    800018c2:	7942                	ld	s2,48(sp)
    800018c4:	79a2                	ld	s3,40(sp)
    800018c6:	7a02                	ld	s4,32(sp)
    800018c8:	6ae2                	ld	s5,24(sp)
    800018ca:	6b42                	ld	s6,16(sp)
    800018cc:	6ba2                	ld	s7,8(sp)
    800018ce:	6c02                	ld	s8,0(sp)
    800018d0:	6161                	add	sp,sp,80
    800018d2:	8082                	ret
            release(&pp->lock);
    800018d4:	8526                	mv	a0,s1
    800018d6:	00005097          	auipc	ra,0x5
    800018da:	99c080e7          	jalr	-1636(ra) # 80006272 <release>
            release(&wait_lock);
    800018de:	00007517          	auipc	a0,0x7
    800018e2:	1aa50513          	add	a0,a0,426 # 80008a88 <wait_lock>
    800018e6:	00005097          	auipc	ra,0x5
    800018ea:	98c080e7          	jalr	-1652(ra) # 80006272 <release>
            return -1;
    800018ee:	59fd                	li	s3,-1
    800018f0:	b7e9                	j	800018ba <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f2:	17048493          	add	s1,s1,368
    800018f6:	03348463          	beq	s1,s3,8000191e <wait+0xf4>
      if(pp->parent == p){
    800018fa:	7c9c                	ld	a5,56(s1)
    800018fc:	ff279be3          	bne	a5,s2,800018f2 <wait+0xc8>
        acquire(&pp->lock);
    80001900:	8526                	mv	a0,s1
    80001902:	00005097          	auipc	ra,0x5
    80001906:	8bc080e7          	jalr	-1860(ra) # 800061be <acquire>
        if(pp->state == ZOMBIE){
    8000190a:	4c9c                	lw	a5,24(s1)
    8000190c:	f74785e3          	beq	a5,s4,80001876 <wait+0x4c>
        release(&pp->lock);
    80001910:	8526                	mv	a0,s1
    80001912:	00005097          	auipc	ra,0x5
    80001916:	960080e7          	jalr	-1696(ra) # 80006272 <release>
        havekids = 1;
    8000191a:	8756                	mv	a4,s5
    8000191c:	bfd9                	j	800018f2 <wait+0xc8>
    if(!havekids || killed(p)){
    8000191e:	c31d                	beqz	a4,80001944 <wait+0x11a>
    80001920:	854a                	mv	a0,s2
    80001922:	00000097          	auipc	ra,0x0
    80001926:	ed6080e7          	jalr	-298(ra) # 800017f8 <killed>
    8000192a:	ed09                	bnez	a0,80001944 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000192c:	85e2                	mv	a1,s8
    8000192e:	854a                	mv	a0,s2
    80001930:	00000097          	auipc	ra,0x0
    80001934:	c20080e7          	jalr	-992(ra) # 80001550 <sleep>
    havekids = 0;
    80001938:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193a:	00007497          	auipc	s1,0x7
    8000193e:	56648493          	add	s1,s1,1382 # 80008ea0 <proc>
    80001942:	bf65                	j	800018fa <wait+0xd0>
      release(&wait_lock);
    80001944:	00007517          	auipc	a0,0x7
    80001948:	14450513          	add	a0,a0,324 # 80008a88 <wait_lock>
    8000194c:	00005097          	auipc	ra,0x5
    80001950:	926080e7          	jalr	-1754(ra) # 80006272 <release>
      return -1;
    80001954:	59fd                	li	s3,-1
    80001956:	b795                	j	800018ba <wait+0x90>

0000000080001958 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001958:	7179                	add	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	add	s0,sp,48
    80001968:	84aa                	mv	s1,a0
    8000196a:	892e                	mv	s2,a1
    8000196c:	89b2                	mv	s3,a2
    8000196e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	52c080e7          	jalr	1324(ra) # 80000e9c <myproc>
  if(user_dst){
    80001978:	c08d                	beqz	s1,8000199a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000197a:	86d2                	mv	a3,s4
    8000197c:	864e                	mv	a2,s3
    8000197e:	85ca                	mv	a1,s2
    80001980:	6928                	ld	a0,80(a0)
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	1da080e7          	jalr	474(ra) # 80000b5c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6a02                	ld	s4,0(sp)
    80001996:	6145                	add	sp,sp,48
    80001998:	8082                	ret
    memmove((char *)dst, src, len);
    8000199a:	000a061b          	sext.w	a2,s4
    8000199e:	85ce                	mv	a1,s3
    800019a0:	854a                	mv	a0,s2
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	87e080e7          	jalr	-1922(ra) # 80000220 <memmove>
    return 0;
    800019aa:	8526                	mv	a0,s1
    800019ac:	bff9                	j	8000198a <either_copyout+0x32>

00000000800019ae <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019ae:	7179                	add	sp,sp,-48
    800019b0:	f406                	sd	ra,40(sp)
    800019b2:	f022                	sd	s0,32(sp)
    800019b4:	ec26                	sd	s1,24(sp)
    800019b6:	e84a                	sd	s2,16(sp)
    800019b8:	e44e                	sd	s3,8(sp)
    800019ba:	e052                	sd	s4,0(sp)
    800019bc:	1800                	add	s0,sp,48
    800019be:	892a                	mv	s2,a0
    800019c0:	84ae                	mv	s1,a1
    800019c2:	89b2                	mv	s3,a2
    800019c4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019c6:	fffff097          	auipc	ra,0xfffff
    800019ca:	4d6080e7          	jalr	1238(ra) # 80000e9c <myproc>
  if(user_src){
    800019ce:	c08d                	beqz	s1,800019f0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019d0:	86d2                	mv	a3,s4
    800019d2:	864e                	mv	a2,s3
    800019d4:	85ca                	mv	a1,s2
    800019d6:	6928                	ld	a0,80(a0)
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	210080e7          	jalr	528(ra) # 80000be8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019e0:	70a2                	ld	ra,40(sp)
    800019e2:	7402                	ld	s0,32(sp)
    800019e4:	64e2                	ld	s1,24(sp)
    800019e6:	6942                	ld	s2,16(sp)
    800019e8:	69a2                	ld	s3,8(sp)
    800019ea:	6a02                	ld	s4,0(sp)
    800019ec:	6145                	add	sp,sp,48
    800019ee:	8082                	ret
    memmove(dst, (char*)src, len);
    800019f0:	000a061b          	sext.w	a2,s4
    800019f4:	85ce                	mv	a1,s3
    800019f6:	854a                	mv	a0,s2
    800019f8:	fffff097          	auipc	ra,0xfffff
    800019fc:	828080e7          	jalr	-2008(ra) # 80000220 <memmove>
    return 0;
    80001a00:	8526                	mv	a0,s1
    80001a02:	bff9                	j	800019e0 <either_copyin+0x32>

0000000080001a04 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a04:	715d                	add	sp,sp,-80
    80001a06:	e486                	sd	ra,72(sp)
    80001a08:	e0a2                	sd	s0,64(sp)
    80001a0a:	fc26                	sd	s1,56(sp)
    80001a0c:	f84a                	sd	s2,48(sp)
    80001a0e:	f44e                	sd	s3,40(sp)
    80001a10:	f052                	sd	s4,32(sp)
    80001a12:	ec56                	sd	s5,24(sp)
    80001a14:	e85a                	sd	s6,16(sp)
    80001a16:	e45e                	sd	s7,8(sp)
    80001a18:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a1a:	00006517          	auipc	a0,0x6
    80001a1e:	62e50513          	add	a0,a0,1582 # 80008048 <etext+0x48>
    80001a22:	00004097          	auipc	ra,0x4
    80001a26:	2ae080e7          	jalr	686(ra) # 80005cd0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2a:	00007497          	auipc	s1,0x7
    80001a2e:	5ce48493          	add	s1,s1,1486 # 80008ff8 <proc+0x158>
    80001a32:	0000d917          	auipc	s2,0xd
    80001a36:	1c690913          	add	s2,s2,454 # 8000ebf8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a3c:	00006997          	auipc	s3,0x6
    80001a40:	7c498993          	add	s3,s3,1988 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a44:	00006a97          	auipc	s5,0x6
    80001a48:	7c4a8a93          	add	s5,s5,1988 # 80008208 <etext+0x208>
    printf("\n");
    80001a4c:	00006a17          	auipc	s4,0x6
    80001a50:	5fca0a13          	add	s4,s4,1532 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a54:	00006b97          	auipc	s7,0x6
    80001a58:	7f4b8b93          	add	s7,s7,2036 # 80008248 <states.0>
    80001a5c:	a00d                	j	80001a7e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a5e:	ed86a583          	lw	a1,-296(a3)
    80001a62:	8556                	mv	a0,s5
    80001a64:	00004097          	auipc	ra,0x4
    80001a68:	26c080e7          	jalr	620(ra) # 80005cd0 <printf>
    printf("\n");
    80001a6c:	8552                	mv	a0,s4
    80001a6e:	00004097          	auipc	ra,0x4
    80001a72:	262080e7          	jalr	610(ra) # 80005cd0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a76:	17048493          	add	s1,s1,368
    80001a7a:	03248263          	beq	s1,s2,80001a9e <procdump+0x9a>
    if(p->state == UNUSED)
    80001a7e:	86a6                	mv	a3,s1
    80001a80:	ec04a783          	lw	a5,-320(s1)
    80001a84:	dbed                	beqz	a5,80001a76 <procdump+0x72>
      state = "???";
    80001a86:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a88:	fcfb6be3          	bltu	s6,a5,80001a5e <procdump+0x5a>
    80001a8c:	02079713          	sll	a4,a5,0x20
    80001a90:	01d75793          	srl	a5,a4,0x1d
    80001a94:	97de                	add	a5,a5,s7
    80001a96:	6390                	ld	a2,0(a5)
    80001a98:	f279                	bnez	a2,80001a5e <procdump+0x5a>
      state = "???";
    80001a9a:	864e                	mv	a2,s3
    80001a9c:	b7c9                	j	80001a5e <procdump+0x5a>
  }
}
    80001a9e:	60a6                	ld	ra,72(sp)
    80001aa0:	6406                	ld	s0,64(sp)
    80001aa2:	74e2                	ld	s1,56(sp)
    80001aa4:	7942                	ld	s2,48(sp)
    80001aa6:	79a2                	ld	s3,40(sp)
    80001aa8:	7a02                	ld	s4,32(sp)
    80001aaa:	6ae2                	ld	s5,24(sp)
    80001aac:	6b42                	ld	s6,16(sp)
    80001aae:	6ba2                	ld	s7,8(sp)
    80001ab0:	6161                	add	sp,sp,80
    80001ab2:	8082                	ret

0000000080001ab4 <collect_proc_num>:


int
collect_proc_num(void)
{
    80001ab4:	1141                	add	sp,sp,-16
    80001ab6:	e422                	sd	s0,8(sp)
    80001ab8:	0800                	add	s0,sp,16
  int num = 0;
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    80001aba:	00007797          	auipc	a5,0x7
    80001abe:	3e678793          	add	a5,a5,998 # 80008ea0 <proc>
  int num = 0;
    80001ac2:	4501                	li	a0,0
  for(p = proc; p < &proc[NPROC]; p++){
    80001ac4:	0000d697          	auipc	a3,0xd
    80001ac8:	fdc68693          	add	a3,a3,-36 # 8000eaa0 <tickslock>
    80001acc:	a029                	j	80001ad6 <collect_proc_num+0x22>
    80001ace:	17078793          	add	a5,a5,368
    80001ad2:	00d78663          	beq	a5,a3,80001ade <collect_proc_num+0x2a>
    if(p->state != UNUSED)
    80001ad6:	4f98                	lw	a4,24(a5)
    80001ad8:	db7d                	beqz	a4,80001ace <collect_proc_num+0x1a>
      num++;
    80001ada:	2505                	addw	a0,a0,1
    80001adc:	bfcd                	j	80001ace <collect_proc_num+0x1a>
  }
  return num;
    80001ade:	6422                	ld	s0,8(sp)
    80001ae0:	0141                	add	sp,sp,16
    80001ae2:	8082                	ret

0000000080001ae4 <swtch>:
    80001ae4:	00153023          	sd	ra,0(a0)
    80001ae8:	00253423          	sd	sp,8(a0)
    80001aec:	e900                	sd	s0,16(a0)
    80001aee:	ed04                	sd	s1,24(a0)
    80001af0:	03253023          	sd	s2,32(a0)
    80001af4:	03353423          	sd	s3,40(a0)
    80001af8:	03453823          	sd	s4,48(a0)
    80001afc:	03553c23          	sd	s5,56(a0)
    80001b00:	05653023          	sd	s6,64(a0)
    80001b04:	05753423          	sd	s7,72(a0)
    80001b08:	05853823          	sd	s8,80(a0)
    80001b0c:	05953c23          	sd	s9,88(a0)
    80001b10:	07a53023          	sd	s10,96(a0)
    80001b14:	07b53423          	sd	s11,104(a0)
    80001b18:	0005b083          	ld	ra,0(a1)
    80001b1c:	0085b103          	ld	sp,8(a1)
    80001b20:	6980                	ld	s0,16(a1)
    80001b22:	6d84                	ld	s1,24(a1)
    80001b24:	0205b903          	ld	s2,32(a1)
    80001b28:	0285b983          	ld	s3,40(a1)
    80001b2c:	0305ba03          	ld	s4,48(a1)
    80001b30:	0385ba83          	ld	s5,56(a1)
    80001b34:	0405bb03          	ld	s6,64(a1)
    80001b38:	0485bb83          	ld	s7,72(a1)
    80001b3c:	0505bc03          	ld	s8,80(a1)
    80001b40:	0585bc83          	ld	s9,88(a1)
    80001b44:	0605bd03          	ld	s10,96(a1)
    80001b48:	0685bd83          	ld	s11,104(a1)
    80001b4c:	8082                	ret

0000000080001b4e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b4e:	1141                	add	sp,sp,-16
    80001b50:	e406                	sd	ra,8(sp)
    80001b52:	e022                	sd	s0,0(sp)
    80001b54:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001b56:	00006597          	auipc	a1,0x6
    80001b5a:	72258593          	add	a1,a1,1826 # 80008278 <states.0+0x30>
    80001b5e:	0000d517          	auipc	a0,0xd
    80001b62:	f4250513          	add	a0,a0,-190 # 8000eaa0 <tickslock>
    80001b66:	00004097          	auipc	ra,0x4
    80001b6a:	5c8080e7          	jalr	1480(ra) # 8000612e <initlock>
}
    80001b6e:	60a2                	ld	ra,8(sp)
    80001b70:	6402                	ld	s0,0(sp)
    80001b72:	0141                	add	sp,sp,16
    80001b74:	8082                	ret

0000000080001b76 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b76:	1141                	add	sp,sp,-16
    80001b78:	e422                	sd	s0,8(sp)
    80001b7a:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b7c:	00003797          	auipc	a5,0x3
    80001b80:	54478793          	add	a5,a5,1348 # 800050c0 <kernelvec>
    80001b84:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b88:	6422                	ld	s0,8(sp)
    80001b8a:	0141                	add	sp,sp,16
    80001b8c:	8082                	ret

0000000080001b8e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b8e:	1141                	add	sp,sp,-16
    80001b90:	e406                	sd	ra,8(sp)
    80001b92:	e022                	sd	s0,0(sp)
    80001b94:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001b96:	fffff097          	auipc	ra,0xfffff
    80001b9a:	306080e7          	jalr	774(ra) # 80000e9c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b9e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ba2:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ba8:	00005697          	auipc	a3,0x5
    80001bac:	45868693          	add	a3,a3,1112 # 80007000 <_trampoline>
    80001bb0:	00005717          	auipc	a4,0x5
    80001bb4:	45070713          	add	a4,a4,1104 # 80007000 <_trampoline>
    80001bb8:	8f15                	sub	a4,a4,a3
    80001bba:	040007b7          	lui	a5,0x4000
    80001bbe:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bc0:	07b2                	sll	a5,a5,0xc
    80001bc2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bc8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bca:	18002673          	csrr	a2,satp
    80001bce:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bd0:	6d30                	ld	a2,88(a0)
    80001bd2:	6138                	ld	a4,64(a0)
    80001bd4:	6585                	lui	a1,0x1
    80001bd6:	972e                	add	a4,a4,a1
    80001bd8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bda:	6d38                	ld	a4,88(a0)
    80001bdc:	00000617          	auipc	a2,0x0
    80001be0:	13460613          	add	a2,a2,308 # 80001d10 <usertrap>
    80001be4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001be6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001be8:	8612                	mv	a2,tp
    80001bea:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bec:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bf0:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bf4:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bf8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bfe:	6f18                	ld	a4,24(a4)
    80001c00:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c04:	6928                	ld	a0,80(a0)
    80001c06:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c08:	00005717          	auipc	a4,0x5
    80001c0c:	49470713          	add	a4,a4,1172 # 8000709c <userret>
    80001c10:	8f15                	sub	a4,a4,a3
    80001c12:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c14:	577d                	li	a4,-1
    80001c16:	177e                	sll	a4,a4,0x3f
    80001c18:	8d59                	or	a0,a0,a4
    80001c1a:	9782                	jalr	a5
}
    80001c1c:	60a2                	ld	ra,8(sp)
    80001c1e:	6402                	ld	s0,0(sp)
    80001c20:	0141                	add	sp,sp,16
    80001c22:	8082                	ret

0000000080001c24 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c24:	1101                	add	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001c2e:	0000d497          	auipc	s1,0xd
    80001c32:	e7248493          	add	s1,s1,-398 # 8000eaa0 <tickslock>
    80001c36:	8526                	mv	a0,s1
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	586080e7          	jalr	1414(ra) # 800061be <acquire>
  ticks++;
    80001c40:	00007517          	auipc	a0,0x7
    80001c44:	df850513          	add	a0,a0,-520 # 80008a38 <ticks>
    80001c48:	411c                	lw	a5,0(a0)
    80001c4a:	2785                	addw	a5,a5,1
    80001c4c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c4e:	00000097          	auipc	ra,0x0
    80001c52:	966080e7          	jalr	-1690(ra) # 800015b4 <wakeup>
  release(&tickslock);
    80001c56:	8526                	mv	a0,s1
    80001c58:	00004097          	auipc	ra,0x4
    80001c5c:	61a080e7          	jalr	1562(ra) # 80006272 <release>
}
    80001c60:	60e2                	ld	ra,24(sp)
    80001c62:	6442                	ld	s0,16(sp)
    80001c64:	64a2                	ld	s1,8(sp)
    80001c66:	6105                	add	sp,sp,32
    80001c68:	8082                	ret

0000000080001c6a <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6a:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c6e:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c70:	0807df63          	bgez	a5,80001d0e <devintr+0xa4>
{
    80001c74:	1101                	add	sp,sp,-32
    80001c76:	ec06                	sd	ra,24(sp)
    80001c78:	e822                	sd	s0,16(sp)
    80001c7a:	e426                	sd	s1,8(sp)
    80001c7c:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001c7e:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c82:	46a5                	li	a3,9
    80001c84:	00d70d63          	beq	a4,a3,80001c9e <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001c88:	577d                	li	a4,-1
    80001c8a:	177e                	sll	a4,a4,0x3f
    80001c8c:	0705                	add	a4,a4,1
    return 0;
    80001c8e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c90:	04e78e63          	beq	a5,a4,80001cec <devintr+0x82>
  }
}
    80001c94:	60e2                	ld	ra,24(sp)
    80001c96:	6442                	ld	s0,16(sp)
    80001c98:	64a2                	ld	s1,8(sp)
    80001c9a:	6105                	add	sp,sp,32
    80001c9c:	8082                	ret
    int irq = plic_claim();
    80001c9e:	00003097          	auipc	ra,0x3
    80001ca2:	52a080e7          	jalr	1322(ra) # 800051c8 <plic_claim>
    80001ca6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ca8:	47a9                	li	a5,10
    80001caa:	02f50763          	beq	a0,a5,80001cd8 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001cae:	4785                	li	a5,1
    80001cb0:	02f50963          	beq	a0,a5,80001ce2 <devintr+0x78>
    return 1;
    80001cb4:	4505                	li	a0,1
    } else if(irq){
    80001cb6:	dcf9                	beqz	s1,80001c94 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb8:	85a6                	mv	a1,s1
    80001cba:	00006517          	auipc	a0,0x6
    80001cbe:	5c650513          	add	a0,a0,1478 # 80008280 <states.0+0x38>
    80001cc2:	00004097          	auipc	ra,0x4
    80001cc6:	00e080e7          	jalr	14(ra) # 80005cd0 <printf>
      plic_complete(irq);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	00003097          	auipc	ra,0x3
    80001cd0:	520080e7          	jalr	1312(ra) # 800051ec <plic_complete>
    return 1;
    80001cd4:	4505                	li	a0,1
    80001cd6:	bf7d                	j	80001c94 <devintr+0x2a>
      uartintr();
    80001cd8:	00004097          	auipc	ra,0x4
    80001cdc:	406080e7          	jalr	1030(ra) # 800060de <uartintr>
    if(irq)
    80001ce0:	b7ed                	j	80001cca <devintr+0x60>
      virtio_disk_intr();
    80001ce2:	00004097          	auipc	ra,0x4
    80001ce6:	9d0080e7          	jalr	-1584(ra) # 800056b2 <virtio_disk_intr>
    if(irq)
    80001cea:	b7c5                	j	80001cca <devintr+0x60>
    if(cpuid() == 0){
    80001cec:	fffff097          	auipc	ra,0xfffff
    80001cf0:	184080e7          	jalr	388(ra) # 80000e70 <cpuid>
    80001cf4:	c901                	beqz	a0,80001d04 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cf6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cfa:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cfc:	14479073          	csrw	sip,a5
    return 2;
    80001d00:	4509                	li	a0,2
    80001d02:	bf49                	j	80001c94 <devintr+0x2a>
      clockintr();
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	f20080e7          	jalr	-224(ra) # 80001c24 <clockintr>
    80001d0c:	b7ed                	j	80001cf6 <devintr+0x8c>
}
    80001d0e:	8082                	ret

0000000080001d10 <usertrap>:
{
    80001d10:	1101                	add	sp,sp,-32
    80001d12:	ec06                	sd	ra,24(sp)
    80001d14:	e822                	sd	s0,16(sp)
    80001d16:	e426                	sd	s1,8(sp)
    80001d18:	e04a                	sd	s2,0(sp)
    80001d1a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d20:	1007f793          	and	a5,a5,256
    80001d24:	e3b1                	bnez	a5,80001d68 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d26:	00003797          	auipc	a5,0x3
    80001d2a:	39a78793          	add	a5,a5,922 # 800050c0 <kernelvec>
    80001d2e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	16a080e7          	jalr	362(ra) # 80000e9c <myproc>
    80001d3a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d3c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3e:	14102773          	csrr	a4,sepc
    80001d42:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d44:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d48:	47a1                	li	a5,8
    80001d4a:	02f70763          	beq	a4,a5,80001d78 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	f1c080e7          	jalr	-228(ra) # 80001c6a <devintr>
    80001d56:	892a                	mv	s2,a0
    80001d58:	c151                	beqz	a0,80001ddc <usertrap+0xcc>
  if(killed(p))
    80001d5a:	8526                	mv	a0,s1
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	a9c080e7          	jalr	-1380(ra) # 800017f8 <killed>
    80001d64:	c929                	beqz	a0,80001db6 <usertrap+0xa6>
    80001d66:	a099                	j	80001dac <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d68:	00006517          	auipc	a0,0x6
    80001d6c:	53850513          	add	a0,a0,1336 # 800082a0 <states.0+0x58>
    80001d70:	00004097          	auipc	ra,0x4
    80001d74:	f16080e7          	jalr	-234(ra) # 80005c86 <panic>
    if(killed(p))
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	a80080e7          	jalr	-1408(ra) # 800017f8 <killed>
    80001d80:	e921                	bnez	a0,80001dd0 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d82:	6cb8                	ld	a4,88(s1)
    80001d84:	6f1c                	ld	a5,24(a4)
    80001d86:	0791                	add	a5,a5,4
    80001d88:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d8e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d92:	10079073          	csrw	sstatus,a5
    syscall();
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	2d4080e7          	jalr	724(ra) # 8000206a <syscall>
  if(killed(p))
    80001d9e:	8526                	mv	a0,s1
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	a58080e7          	jalr	-1448(ra) # 800017f8 <killed>
    80001da8:	c911                	beqz	a0,80001dbc <usertrap+0xac>
    80001daa:	4901                	li	s2,0
    exit(-1);
    80001dac:	557d                	li	a0,-1
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	8d6080e7          	jalr	-1834(ra) # 80001684 <exit>
  if(which_dev == 2)
    80001db6:	4789                	li	a5,2
    80001db8:	04f90f63          	beq	s2,a5,80001e16 <usertrap+0x106>
  usertrapret();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	dd2080e7          	jalr	-558(ra) # 80001b8e <usertrapret>
}
    80001dc4:	60e2                	ld	ra,24(sp)
    80001dc6:	6442                	ld	s0,16(sp)
    80001dc8:	64a2                	ld	s1,8(sp)
    80001dca:	6902                	ld	s2,0(sp)
    80001dcc:	6105                	add	sp,sp,32
    80001dce:	8082                	ret
      exit(-1);
    80001dd0:	557d                	li	a0,-1
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	8b2080e7          	jalr	-1870(ra) # 80001684 <exit>
    80001dda:	b765                	j	80001d82 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ddc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001de0:	5890                	lw	a2,48(s1)
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	4de50513          	add	a0,a0,1246 # 800082c0 <states.0+0x78>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	ee6080e7          	jalr	-282(ra) # 80005cd0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001df6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	4f650513          	add	a0,a0,1270 # 800082f0 <states.0+0xa8>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	ece080e7          	jalr	-306(ra) # 80005cd0 <printf>
    setkilled(p);
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	00000097          	auipc	ra,0x0
    80001e10:	9c0080e7          	jalr	-1600(ra) # 800017cc <setkilled>
    80001e14:	b769                	j	80001d9e <usertrap+0x8e>
    yield();
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	6fe080e7          	jalr	1790(ra) # 80001514 <yield>
    80001e1e:	bf79                	j	80001dbc <usertrap+0xac>

0000000080001e20 <kerneltrap>:
{
    80001e20:	7179                	add	sp,sp,-48
    80001e22:	f406                	sd	ra,40(sp)
    80001e24:	f022                	sd	s0,32(sp)
    80001e26:	ec26                	sd	s1,24(sp)
    80001e28:	e84a                	sd	s2,16(sp)
    80001e2a:	e44e                	sd	s3,8(sp)
    80001e2c:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e32:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e36:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e3a:	1004f793          	and	a5,s1,256
    80001e3e:	cb85                	beqz	a5,80001e6e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e40:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e44:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001e46:	ef85                	bnez	a5,80001e7e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e48:	00000097          	auipc	ra,0x0
    80001e4c:	e22080e7          	jalr	-478(ra) # 80001c6a <devintr>
    80001e50:	cd1d                	beqz	a0,80001e8e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e52:	4789                	li	a5,2
    80001e54:	06f50a63          	beq	a0,a5,80001ec8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e58:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e5c:	10049073          	csrw	sstatus,s1
}
    80001e60:	70a2                	ld	ra,40(sp)
    80001e62:	7402                	ld	s0,32(sp)
    80001e64:	64e2                	ld	s1,24(sp)
    80001e66:	6942                	ld	s2,16(sp)
    80001e68:	69a2                	ld	s3,8(sp)
    80001e6a:	6145                	add	sp,sp,48
    80001e6c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e6e:	00006517          	auipc	a0,0x6
    80001e72:	4a250513          	add	a0,a0,1186 # 80008310 <states.0+0xc8>
    80001e76:	00004097          	auipc	ra,0x4
    80001e7a:	e10080e7          	jalr	-496(ra) # 80005c86 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	4ba50513          	add	a0,a0,1210 # 80008338 <states.0+0xf0>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	e00080e7          	jalr	-512(ra) # 80005c86 <panic>
    printf("scause %p\n", scause);
    80001e8e:	85ce                	mv	a1,s3
    80001e90:	00006517          	auipc	a0,0x6
    80001e94:	4c850513          	add	a0,a0,1224 # 80008358 <states.0+0x110>
    80001e98:	00004097          	auipc	ra,0x4
    80001e9c:	e38080e7          	jalr	-456(ra) # 80005cd0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ea0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ea4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ea8:	00006517          	auipc	a0,0x6
    80001eac:	4c050513          	add	a0,a0,1216 # 80008368 <states.0+0x120>
    80001eb0:	00004097          	auipc	ra,0x4
    80001eb4:	e20080e7          	jalr	-480(ra) # 80005cd0 <printf>
    panic("kerneltrap");
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	4c850513          	add	a0,a0,1224 # 80008380 <states.0+0x138>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	dc6080e7          	jalr	-570(ra) # 80005c86 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	fd4080e7          	jalr	-44(ra) # 80000e9c <myproc>
    80001ed0:	d541                	beqz	a0,80001e58 <kerneltrap+0x38>
    80001ed2:	fffff097          	auipc	ra,0xfffff
    80001ed6:	fca080e7          	jalr	-54(ra) # 80000e9c <myproc>
    80001eda:	4d18                	lw	a4,24(a0)
    80001edc:	4791                	li	a5,4
    80001ede:	f6f71de3          	bne	a4,a5,80001e58 <kerneltrap+0x38>
    yield();
    80001ee2:	fffff097          	auipc	ra,0xfffff
    80001ee6:	632080e7          	jalr	1586(ra) # 80001514 <yield>
    80001eea:	b7bd                	j	80001e58 <kerneltrap+0x38>

0000000080001eec <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eec:	1101                	add	sp,sp,-32
    80001eee:	ec06                	sd	ra,24(sp)
    80001ef0:	e822                	sd	s0,16(sp)
    80001ef2:	e426                	sd	s1,8(sp)
    80001ef4:	1000                	add	s0,sp,32
    80001ef6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	fa4080e7          	jalr	-92(ra) # 80000e9c <myproc>
  switch (n) {
    80001f00:	4795                	li	a5,5
    80001f02:	0497e163          	bltu	a5,s1,80001f44 <argraw+0x58>
    80001f06:	048a                	sll	s1,s1,0x2
    80001f08:	00006717          	auipc	a4,0x6
    80001f0c:	57870713          	add	a4,a4,1400 # 80008480 <states.0+0x238>
    80001f10:	94ba                	add	s1,s1,a4
    80001f12:	409c                	lw	a5,0(s1)
    80001f14:	97ba                	add	a5,a5,a4
    80001f16:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f18:	6d3c                	ld	a5,88(a0)
    80001f1a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f1c:	60e2                	ld	ra,24(sp)
    80001f1e:	6442                	ld	s0,16(sp)
    80001f20:	64a2                	ld	s1,8(sp)
    80001f22:	6105                	add	sp,sp,32
    80001f24:	8082                	ret
    return p->trapframe->a1;
    80001f26:	6d3c                	ld	a5,88(a0)
    80001f28:	7fa8                	ld	a0,120(a5)
    80001f2a:	bfcd                	j	80001f1c <argraw+0x30>
    return p->trapframe->a2;
    80001f2c:	6d3c                	ld	a5,88(a0)
    80001f2e:	63c8                	ld	a0,128(a5)
    80001f30:	b7f5                	j	80001f1c <argraw+0x30>
    return p->trapframe->a3;
    80001f32:	6d3c                	ld	a5,88(a0)
    80001f34:	67c8                	ld	a0,136(a5)
    80001f36:	b7dd                	j	80001f1c <argraw+0x30>
    return p->trapframe->a4;
    80001f38:	6d3c                	ld	a5,88(a0)
    80001f3a:	6bc8                	ld	a0,144(a5)
    80001f3c:	b7c5                	j	80001f1c <argraw+0x30>
    return p->trapframe->a5;
    80001f3e:	6d3c                	ld	a5,88(a0)
    80001f40:	6fc8                	ld	a0,152(a5)
    80001f42:	bfe9                	j	80001f1c <argraw+0x30>
  panic("argraw");
    80001f44:	00006517          	auipc	a0,0x6
    80001f48:	44c50513          	add	a0,a0,1100 # 80008390 <states.0+0x148>
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	d3a080e7          	jalr	-710(ra) # 80005c86 <panic>

0000000080001f54 <fetchaddr>:
{
    80001f54:	1101                	add	sp,sp,-32
    80001f56:	ec06                	sd	ra,24(sp)
    80001f58:	e822                	sd	s0,16(sp)
    80001f5a:	e426                	sd	s1,8(sp)
    80001f5c:	e04a                	sd	s2,0(sp)
    80001f5e:	1000                	add	s0,sp,32
    80001f60:	84aa                	mv	s1,a0
    80001f62:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	f38080e7          	jalr	-200(ra) # 80000e9c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f6c:	653c                	ld	a5,72(a0)
    80001f6e:	02f4f863          	bgeu	s1,a5,80001f9e <fetchaddr+0x4a>
    80001f72:	00848713          	add	a4,s1,8
    80001f76:	02e7e663          	bltu	a5,a4,80001fa2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f7a:	46a1                	li	a3,8
    80001f7c:	8626                	mv	a2,s1
    80001f7e:	85ca                	mv	a1,s2
    80001f80:	6928                	ld	a0,80(a0)
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	c66080e7          	jalr	-922(ra) # 80000be8 <copyin>
    80001f8a:	00a03533          	snez	a0,a0
    80001f8e:	40a00533          	neg	a0,a0
}
    80001f92:	60e2                	ld	ra,24(sp)
    80001f94:	6442                	ld	s0,16(sp)
    80001f96:	64a2                	ld	s1,8(sp)
    80001f98:	6902                	ld	s2,0(sp)
    80001f9a:	6105                	add	sp,sp,32
    80001f9c:	8082                	ret
    return -1;
    80001f9e:	557d                	li	a0,-1
    80001fa0:	bfcd                	j	80001f92 <fetchaddr+0x3e>
    80001fa2:	557d                	li	a0,-1
    80001fa4:	b7fd                	j	80001f92 <fetchaddr+0x3e>

0000000080001fa6 <fetchstr>:
{
    80001fa6:	7179                	add	sp,sp,-48
    80001fa8:	f406                	sd	ra,40(sp)
    80001faa:	f022                	sd	s0,32(sp)
    80001fac:	ec26                	sd	s1,24(sp)
    80001fae:	e84a                	sd	s2,16(sp)
    80001fb0:	e44e                	sd	s3,8(sp)
    80001fb2:	1800                	add	s0,sp,48
    80001fb4:	892a                	mv	s2,a0
    80001fb6:	84ae                	mv	s1,a1
    80001fb8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	ee2080e7          	jalr	-286(ra) # 80000e9c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fc2:	86ce                	mv	a3,s3
    80001fc4:	864a                	mv	a2,s2
    80001fc6:	85a6                	mv	a1,s1
    80001fc8:	6928                	ld	a0,80(a0)
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	cac080e7          	jalr	-852(ra) # 80000c76 <copyinstr>
    80001fd2:	00054e63          	bltz	a0,80001fee <fetchstr+0x48>
  return strlen(buf);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	ffffe097          	auipc	ra,0xffffe
    80001fdc:	366080e7          	jalr	870(ra) # 8000033e <strlen>
}
    80001fe0:	70a2                	ld	ra,40(sp)
    80001fe2:	7402                	ld	s0,32(sp)
    80001fe4:	64e2                	ld	s1,24(sp)
    80001fe6:	6942                	ld	s2,16(sp)
    80001fe8:	69a2                	ld	s3,8(sp)
    80001fea:	6145                	add	sp,sp,48
    80001fec:	8082                	ret
    return -1;
    80001fee:	557d                	li	a0,-1
    80001ff0:	bfc5                	j	80001fe0 <fetchstr+0x3a>

0000000080001ff2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ff2:	1101                	add	sp,sp,-32
    80001ff4:	ec06                	sd	ra,24(sp)
    80001ff6:	e822                	sd	s0,16(sp)
    80001ff8:	e426                	sd	s1,8(sp)
    80001ffa:	1000                	add	s0,sp,32
    80001ffc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ffe:	00000097          	auipc	ra,0x0
    80002002:	eee080e7          	jalr	-274(ra) # 80001eec <argraw>
    80002006:	c088                	sw	a0,0(s1)
}
    80002008:	60e2                	ld	ra,24(sp)
    8000200a:	6442                	ld	s0,16(sp)
    8000200c:	64a2                	ld	s1,8(sp)
    8000200e:	6105                	add	sp,sp,32
    80002010:	8082                	ret

0000000080002012 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002012:	1101                	add	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	e426                	sd	s1,8(sp)
    8000201a:	1000                	add	s0,sp,32
    8000201c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000201e:	00000097          	auipc	ra,0x0
    80002022:	ece080e7          	jalr	-306(ra) # 80001eec <argraw>
    80002026:	e088                	sd	a0,0(s1)
}
    80002028:	60e2                	ld	ra,24(sp)
    8000202a:	6442                	ld	s0,16(sp)
    8000202c:	64a2                	ld	s1,8(sp)
    8000202e:	6105                	add	sp,sp,32
    80002030:	8082                	ret

0000000080002032 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002032:	7179                	add	sp,sp,-48
    80002034:	f406                	sd	ra,40(sp)
    80002036:	f022                	sd	s0,32(sp)
    80002038:	ec26                	sd	s1,24(sp)
    8000203a:	e84a                	sd	s2,16(sp)
    8000203c:	1800                	add	s0,sp,48
    8000203e:	84ae                	mv	s1,a1
    80002040:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002042:	fd840593          	add	a1,s0,-40
    80002046:	00000097          	auipc	ra,0x0
    8000204a:	fcc080e7          	jalr	-52(ra) # 80002012 <argaddr>
  return fetchstr(addr, buf, max);
    8000204e:	864a                	mv	a2,s2
    80002050:	85a6                	mv	a1,s1
    80002052:	fd843503          	ld	a0,-40(s0)
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	f50080e7          	jalr	-176(ra) # 80001fa6 <fetchstr>
}
    8000205e:	70a2                	ld	ra,40(sp)
    80002060:	7402                	ld	s0,32(sp)
    80002062:	64e2                	ld	s1,24(sp)
    80002064:	6942                	ld	s2,16(sp)
    80002066:	6145                	add	sp,sp,48
    80002068:	8082                	ret

000000008000206a <syscall>:



void
syscall(void)
{
    8000206a:	7179                	add	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	e44e                	sd	s3,8(sp)
    80002076:	1800                	add	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002078:	fffff097          	auipc	ra,0xfffff
    8000207c:	e24080e7          	jalr	-476(ra) # 80000e9c <myproc>
    80002080:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002082:	05853903          	ld	s2,88(a0)
    80002086:	0a893783          	ld	a5,168(s2)
    8000208a:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000208e:	37fd                	addw	a5,a5,-1
    80002090:	4759                	li	a4,22
    80002092:	04f76763          	bltu	a4,a5,800020e0 <syscall+0x76>
    80002096:	00399713          	sll	a4,s3,0x3
    8000209a:	00006797          	auipc	a5,0x6
    8000209e:	3fe78793          	add	a5,a5,1022 # 80008498 <syscalls>
    800020a2:	97ba                	add	a5,a5,a4
    800020a4:	639c                	ld	a5,0(a5)
    800020a6:	cf8d                	beqz	a5,800020e0 <syscall+0x76>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020a8:	9782                	jalr	a5
    800020aa:	06a93823          	sd	a0,112(s2)
    // sys_trace插桩
    if((p->trace_mask >> num) & 1){
    800020ae:	1684a783          	lw	a5,360(s1)
    800020b2:	4137d7bb          	sraw	a5,a5,s3
    800020b6:	8b85                	and	a5,a5,1
    800020b8:	c3b9                	beqz	a5,800020fe <syscall+0x94>
      printf("%d: syscall %s -> %d\n",p->pid, syscall_names[num], p->trapframe->a0);
    800020ba:	6cb8                	ld	a4,88(s1)
    800020bc:	098e                	sll	s3,s3,0x3
    800020be:	00006797          	auipc	a5,0x6
    800020c2:	3da78793          	add	a5,a5,986 # 80008498 <syscalls>
    800020c6:	97ce                	add	a5,a5,s3
    800020c8:	7b34                	ld	a3,112(a4)
    800020ca:	63f0                	ld	a2,192(a5)
    800020cc:	588c                	lw	a1,48(s1)
    800020ce:	00006517          	auipc	a0,0x6
    800020d2:	2ca50513          	add	a0,a0,714 # 80008398 <states.0+0x150>
    800020d6:	00004097          	auipc	ra,0x4
    800020da:	bfa080e7          	jalr	-1030(ra) # 80005cd0 <printf>
    800020de:	a005                	j	800020fe <syscall+0x94>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020e0:	86ce                	mv	a3,s3
    800020e2:	15848613          	add	a2,s1,344
    800020e6:	588c                	lw	a1,48(s1)
    800020e8:	00006517          	auipc	a0,0x6
    800020ec:	2c850513          	add	a0,a0,712 # 800083b0 <states.0+0x168>
    800020f0:	00004097          	auipc	ra,0x4
    800020f4:	be0080e7          	jalr	-1056(ra) # 80005cd0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020f8:	6cbc                	ld	a5,88(s1)
    800020fa:	577d                	li	a4,-1
    800020fc:	fbb8                	sd	a4,112(a5)
  }
}
    800020fe:	70a2                	ld	ra,40(sp)
    80002100:	7402                	ld	s0,32(sp)
    80002102:	64e2                	ld	s1,24(sp)
    80002104:	6942                	ld	s2,16(sp)
    80002106:	69a2                	ld	s3,8(sp)
    80002108:	6145                	add	sp,sp,48
    8000210a:	8082                	ret

000000008000210c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000210c:	1101                	add	sp,sp,-32
    8000210e:	ec06                	sd	ra,24(sp)
    80002110:	e822                	sd	s0,16(sp)
    80002112:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002114:	fec40593          	add	a1,s0,-20
    80002118:	4501                	li	a0,0
    8000211a:	00000097          	auipc	ra,0x0
    8000211e:	ed8080e7          	jalr	-296(ra) # 80001ff2 <argint>
  exit(n);
    80002122:	fec42503          	lw	a0,-20(s0)
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	55e080e7          	jalr	1374(ra) # 80001684 <exit>
  return 0;  // not reached
}
    8000212e:	4501                	li	a0,0
    80002130:	60e2                	ld	ra,24(sp)
    80002132:	6442                	ld	s0,16(sp)
    80002134:	6105                	add	sp,sp,32
    80002136:	8082                	ret

0000000080002138 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002138:	1141                	add	sp,sp,-16
    8000213a:	e406                	sd	ra,8(sp)
    8000213c:	e022                	sd	s0,0(sp)
    8000213e:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	d5c080e7          	jalr	-676(ra) # 80000e9c <myproc>
}
    80002148:	5908                	lw	a0,48(a0)
    8000214a:	60a2                	ld	ra,8(sp)
    8000214c:	6402                	ld	s0,0(sp)
    8000214e:	0141                	add	sp,sp,16
    80002150:	8082                	ret

0000000080002152 <sys_fork>:

uint64
sys_fork(void)
{
    80002152:	1141                	add	sp,sp,-16
    80002154:	e406                	sd	ra,8(sp)
    80002156:	e022                	sd	s0,0(sp)
    80002158:	0800                	add	s0,sp,16
  return fork();
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	0fc080e7          	jalr	252(ra) # 80001256 <fork>
}
    80002162:	60a2                	ld	ra,8(sp)
    80002164:	6402                	ld	s0,0(sp)
    80002166:	0141                	add	sp,sp,16
    80002168:	8082                	ret

000000008000216a <sys_wait>:

uint64
sys_wait(void)
{
    8000216a:	1101                	add	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002172:	fe840593          	add	a1,s0,-24
    80002176:	4501                	li	a0,0
    80002178:	00000097          	auipc	ra,0x0
    8000217c:	e9a080e7          	jalr	-358(ra) # 80002012 <argaddr>
  return wait(p);
    80002180:	fe843503          	ld	a0,-24(s0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	6a6080e7          	jalr	1702(ra) # 8000182a <wait>
}
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	6105                	add	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002194:	7179                	add	sp,sp,-48
    80002196:	f406                	sd	ra,40(sp)
    80002198:	f022                	sd	s0,32(sp)
    8000219a:	ec26                	sd	s1,24(sp)
    8000219c:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000219e:	fdc40593          	add	a1,s0,-36
    800021a2:	4501                	li	a0,0
    800021a4:	00000097          	auipc	ra,0x0
    800021a8:	e4e080e7          	jalr	-434(ra) # 80001ff2 <argint>
  addr = myproc()->sz;
    800021ac:	fffff097          	auipc	ra,0xfffff
    800021b0:	cf0080e7          	jalr	-784(ra) # 80000e9c <myproc>
    800021b4:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021b6:	fdc42503          	lw	a0,-36(s0)
    800021ba:	fffff097          	auipc	ra,0xfffff
    800021be:	040080e7          	jalr	64(ra) # 800011fa <growproc>
    800021c2:	00054863          	bltz	a0,800021d2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021c6:	8526                	mv	a0,s1
    800021c8:	70a2                	ld	ra,40(sp)
    800021ca:	7402                	ld	s0,32(sp)
    800021cc:	64e2                	ld	s1,24(sp)
    800021ce:	6145                	add	sp,sp,48
    800021d0:	8082                	ret
    return -1;
    800021d2:	54fd                	li	s1,-1
    800021d4:	bfcd                	j	800021c6 <sys_sbrk+0x32>

00000000800021d6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021d6:	7139                	add	sp,sp,-64
    800021d8:	fc06                	sd	ra,56(sp)
    800021da:	f822                	sd	s0,48(sp)
    800021dc:	f426                	sd	s1,40(sp)
    800021de:	f04a                	sd	s2,32(sp)
    800021e0:	ec4e                	sd	s3,24(sp)
    800021e2:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021e4:	fcc40593          	add	a1,s0,-52
    800021e8:	4501                	li	a0,0
    800021ea:	00000097          	auipc	ra,0x0
    800021ee:	e08080e7          	jalr	-504(ra) # 80001ff2 <argint>
  if(n < 0)
    800021f2:	fcc42783          	lw	a5,-52(s0)
    800021f6:	0607cf63          	bltz	a5,80002274 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021fa:	0000d517          	auipc	a0,0xd
    800021fe:	8a650513          	add	a0,a0,-1882 # 8000eaa0 <tickslock>
    80002202:	00004097          	auipc	ra,0x4
    80002206:	fbc080e7          	jalr	-68(ra) # 800061be <acquire>
  ticks0 = ticks;
    8000220a:	00007917          	auipc	s2,0x7
    8000220e:	82e92903          	lw	s2,-2002(s2) # 80008a38 <ticks>
  while(ticks - ticks0 < n){
    80002212:	fcc42783          	lw	a5,-52(s0)
    80002216:	cf9d                	beqz	a5,80002254 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002218:	0000d997          	auipc	s3,0xd
    8000221c:	88898993          	add	s3,s3,-1912 # 8000eaa0 <tickslock>
    80002220:	00007497          	auipc	s1,0x7
    80002224:	81848493          	add	s1,s1,-2024 # 80008a38 <ticks>
    if(killed(myproc())){
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	c74080e7          	jalr	-908(ra) # 80000e9c <myproc>
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	5c8080e7          	jalr	1480(ra) # 800017f8 <killed>
    80002238:	e129                	bnez	a0,8000227a <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000223a:	85ce                	mv	a1,s3
    8000223c:	8526                	mv	a0,s1
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	312080e7          	jalr	786(ra) # 80001550 <sleep>
  while(ticks - ticks0 < n){
    80002246:	409c                	lw	a5,0(s1)
    80002248:	412787bb          	subw	a5,a5,s2
    8000224c:	fcc42703          	lw	a4,-52(s0)
    80002250:	fce7ece3          	bltu	a5,a4,80002228 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002254:	0000d517          	auipc	a0,0xd
    80002258:	84c50513          	add	a0,a0,-1972 # 8000eaa0 <tickslock>
    8000225c:	00004097          	auipc	ra,0x4
    80002260:	016080e7          	jalr	22(ra) # 80006272 <release>
  return 0;
    80002264:	4501                	li	a0,0
}
    80002266:	70e2                	ld	ra,56(sp)
    80002268:	7442                	ld	s0,48(sp)
    8000226a:	74a2                	ld	s1,40(sp)
    8000226c:	7902                	ld	s2,32(sp)
    8000226e:	69e2                	ld	s3,24(sp)
    80002270:	6121                	add	sp,sp,64
    80002272:	8082                	ret
    n = 0;
    80002274:	fc042623          	sw	zero,-52(s0)
    80002278:	b749                	j	800021fa <sys_sleep+0x24>
      release(&tickslock);
    8000227a:	0000d517          	auipc	a0,0xd
    8000227e:	82650513          	add	a0,a0,-2010 # 8000eaa0 <tickslock>
    80002282:	00004097          	auipc	ra,0x4
    80002286:	ff0080e7          	jalr	-16(ra) # 80006272 <release>
      return -1;
    8000228a:	557d                	li	a0,-1
    8000228c:	bfe9                	j	80002266 <sys_sleep+0x90>

000000008000228e <sys_kill>:

uint64
sys_kill(void)
{
    8000228e:	1101                	add	sp,sp,-32
    80002290:	ec06                	sd	ra,24(sp)
    80002292:	e822                	sd	s0,16(sp)
    80002294:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002296:	fec40593          	add	a1,s0,-20
    8000229a:	4501                	li	a0,0
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	d56080e7          	jalr	-682(ra) # 80001ff2 <argint>
  return kill(pid);
    800022a4:	fec42503          	lw	a0,-20(s0)
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	4b2080e7          	jalr	1202(ra) # 8000175a <kill>
}
    800022b0:	60e2                	ld	ra,24(sp)
    800022b2:	6442                	ld	s0,16(sp)
    800022b4:	6105                	add	sp,sp,32
    800022b6:	8082                	ret

00000000800022b8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022b8:	1101                	add	sp,sp,-32
    800022ba:	ec06                	sd	ra,24(sp)
    800022bc:	e822                	sd	s0,16(sp)
    800022be:	e426                	sd	s1,8(sp)
    800022c0:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022c2:	0000c517          	auipc	a0,0xc
    800022c6:	7de50513          	add	a0,a0,2014 # 8000eaa0 <tickslock>
    800022ca:	00004097          	auipc	ra,0x4
    800022ce:	ef4080e7          	jalr	-268(ra) # 800061be <acquire>
  xticks = ticks;
    800022d2:	00006497          	auipc	s1,0x6
    800022d6:	7664a483          	lw	s1,1894(s1) # 80008a38 <ticks>
  release(&tickslock);
    800022da:	0000c517          	auipc	a0,0xc
    800022de:	7c650513          	add	a0,a0,1990 # 8000eaa0 <tickslock>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	f90080e7          	jalr	-112(ra) # 80006272 <release>
  return xticks;
}
    800022ea:	02049513          	sll	a0,s1,0x20
    800022ee:	9101                	srl	a0,a0,0x20
    800022f0:	60e2                	ld	ra,24(sp)
    800022f2:	6442                	ld	s0,16(sp)
    800022f4:	64a2                	ld	s1,8(sp)
    800022f6:	6105                	add	sp,sp,32
    800022f8:	8082                	ret

00000000800022fa <sys_trace>:

// 因为trace会涉及到进程，所以放在sysproc.c比较合适
// sys_trace只是给进程赋值mask而已，打印信息的代码应该插桩在syscall()中
uint64
sys_trace(void){
    800022fa:	1101                	add	sp,sp,-32
    800022fc:	ec06                	sd	ra,24(sp)
    800022fe:	e822                	sd	s0,16(sp)
    80002300:	1000                	add	s0,sp,32
  int mask;
  argint(0,&mask);
    80002302:	fec40593          	add	a1,s0,-20
    80002306:	4501                	li	a0,0
    80002308:	00000097          	auipc	ra,0x0
    8000230c:	cea080e7          	jalr	-790(ra) # 80001ff2 <argint>
  if(mask < 0){
    80002310:	fec42783          	lw	a5,-20(s0)
    return -1;
    80002314:	557d                	li	a0,-1
  if(mask < 0){
    80002316:	0007cb63          	bltz	a5,8000232c <sys_trace+0x32>
  }
  struct proc *p = myproc();
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	b82080e7          	jalr	-1150(ra) # 80000e9c <myproc>
  p->trace_mask = mask;
    80002322:	fec42783          	lw	a5,-20(s0)
    80002326:	16f52423          	sw	a5,360(a0)
  return 0;
    8000232a:	4501                	li	a0,0
}
    8000232c:	60e2                	ld	ra,24(sp)
    8000232e:	6442                	ld	s0,16(sp)
    80002330:	6105                	add	sp,sp,32
    80002332:	8082                	ret

0000000080002334 <sys_sysinfo>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_sysinfo(void)
{
    80002334:	7139                	add	sp,sp,-64
    80002336:	fc06                	sd	ra,56(sp)
    80002338:	f822                	sd	s0,48(sp)
    8000233a:	f426                	sd	s1,40(sp)
    8000233c:	0080                	add	s0,sp,64
    struct proc *p = myproc();
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	b5e080e7          	jalr	-1186(ra) # 80000e9c <myproc>
    80002346:	84aa                	mv	s1,a0

    struct sysinfo info;
    uint64 info_addr; // user pointer to struct stat
    argaddr(0, &info_addr);
    80002348:	fc840593          	add	a1,s0,-56
    8000234c:	4501                	li	a0,0
    8000234e:	00000097          	auipc	ra,0x0
    80002352:	cc4080e7          	jalr	-828(ra) # 80002012 <argaddr>

    info.freemem = kcollect_free();
    80002356:	ffffe097          	auipc	ra,0xffffe
    8000235a:	e24080e7          	jalr	-476(ra) # 8000017a <kcollect_free>
    8000235e:	fca43823          	sd	a0,-48(s0)
    info.nproc = collect_proc_num();
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	752080e7          	jalr	1874(ra) # 80001ab4 <collect_proc_num>
    8000236a:	fca43c23          	sd	a0,-40(s0)

    // 将struct sysinfo拷贝至用户态
    if(copyout(p->pagetable, info_addr, (char*)&info, sizeof(info)) < 0){
    8000236e:	46c1                	li	a3,16
    80002370:	fd040613          	add	a2,s0,-48
    80002374:	fc843583          	ld	a1,-56(s0)
    80002378:	68a8                	ld	a0,80(s1)
    8000237a:	ffffe097          	auipc	ra,0xffffe
    8000237e:	7e2080e7          	jalr	2018(ra) # 80000b5c <copyout>
        return -1;
    }
    return 0;
}
    80002382:	957d                	sra	a0,a0,0x3f
    80002384:	70e2                	ld	ra,56(sp)
    80002386:	7442                	ld	s0,48(sp)
    80002388:	74a2                	ld	s1,40(sp)
    8000238a:	6121                	add	sp,sp,64
    8000238c:	8082                	ret

000000008000238e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000238e:	7179                	add	sp,sp,-48
    80002390:	f406                	sd	ra,40(sp)
    80002392:	f022                	sd	s0,32(sp)
    80002394:	ec26                	sd	s1,24(sp)
    80002396:	e84a                	sd	s2,16(sp)
    80002398:	e44e                	sd	s3,8(sp)
    8000239a:	e052                	sd	s4,0(sp)
    8000239c:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000239e:	00006597          	auipc	a1,0x6
    800023a2:	27a58593          	add	a1,a1,634 # 80008618 <syscall_names+0xc0>
    800023a6:	0000c517          	auipc	a0,0xc
    800023aa:	71250513          	add	a0,a0,1810 # 8000eab8 <bcache>
    800023ae:	00004097          	auipc	ra,0x4
    800023b2:	d80080e7          	jalr	-640(ra) # 8000612e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023b6:	00014797          	auipc	a5,0x14
    800023ba:	70278793          	add	a5,a5,1794 # 80016ab8 <bcache+0x8000>
    800023be:	00015717          	auipc	a4,0x15
    800023c2:	96270713          	add	a4,a4,-1694 # 80016d20 <bcache+0x8268>
    800023c6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023ca:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ce:	0000c497          	auipc	s1,0xc
    800023d2:	70248493          	add	s1,s1,1794 # 8000ead0 <bcache+0x18>
    b->next = bcache.head.next;
    800023d6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023d8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023da:	00006a17          	auipc	s4,0x6
    800023de:	246a0a13          	add	s4,s4,582 # 80008620 <syscall_names+0xc8>
    b->next = bcache.head.next;
    800023e2:	2b893783          	ld	a5,696(s2)
    800023e6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023e8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023ec:	85d2                	mv	a1,s4
    800023ee:	01048513          	add	a0,s1,16
    800023f2:	00001097          	auipc	ra,0x1
    800023f6:	496080e7          	jalr	1174(ra) # 80003888 <initsleeplock>
    bcache.head.next->prev = b;
    800023fa:	2b893783          	ld	a5,696(s2)
    800023fe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002400:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002404:	45848493          	add	s1,s1,1112
    80002408:	fd349de3          	bne	s1,s3,800023e2 <binit+0x54>
  }
}
    8000240c:	70a2                	ld	ra,40(sp)
    8000240e:	7402                	ld	s0,32(sp)
    80002410:	64e2                	ld	s1,24(sp)
    80002412:	6942                	ld	s2,16(sp)
    80002414:	69a2                	ld	s3,8(sp)
    80002416:	6a02                	ld	s4,0(sp)
    80002418:	6145                	add	sp,sp,48
    8000241a:	8082                	ret

000000008000241c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000241c:	7179                	add	sp,sp,-48
    8000241e:	f406                	sd	ra,40(sp)
    80002420:	f022                	sd	s0,32(sp)
    80002422:	ec26                	sd	s1,24(sp)
    80002424:	e84a                	sd	s2,16(sp)
    80002426:	e44e                	sd	s3,8(sp)
    80002428:	1800                	add	s0,sp,48
    8000242a:	892a                	mv	s2,a0
    8000242c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000242e:	0000c517          	auipc	a0,0xc
    80002432:	68a50513          	add	a0,a0,1674 # 8000eab8 <bcache>
    80002436:	00004097          	auipc	ra,0x4
    8000243a:	d88080e7          	jalr	-632(ra) # 800061be <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000243e:	00015497          	auipc	s1,0x15
    80002442:	9324b483          	ld	s1,-1742(s1) # 80016d70 <bcache+0x82b8>
    80002446:	00015797          	auipc	a5,0x15
    8000244a:	8da78793          	add	a5,a5,-1830 # 80016d20 <bcache+0x8268>
    8000244e:	02f48f63          	beq	s1,a5,8000248c <bread+0x70>
    80002452:	873e                	mv	a4,a5
    80002454:	a021                	j	8000245c <bread+0x40>
    80002456:	68a4                	ld	s1,80(s1)
    80002458:	02e48a63          	beq	s1,a4,8000248c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000245c:	449c                	lw	a5,8(s1)
    8000245e:	ff279ce3          	bne	a5,s2,80002456 <bread+0x3a>
    80002462:	44dc                	lw	a5,12(s1)
    80002464:	ff3799e3          	bne	a5,s3,80002456 <bread+0x3a>
      b->refcnt++;
    80002468:	40bc                	lw	a5,64(s1)
    8000246a:	2785                	addw	a5,a5,1
    8000246c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000246e:	0000c517          	auipc	a0,0xc
    80002472:	64a50513          	add	a0,a0,1610 # 8000eab8 <bcache>
    80002476:	00004097          	auipc	ra,0x4
    8000247a:	dfc080e7          	jalr	-516(ra) # 80006272 <release>
      acquiresleep(&b->lock);
    8000247e:	01048513          	add	a0,s1,16
    80002482:	00001097          	auipc	ra,0x1
    80002486:	440080e7          	jalr	1088(ra) # 800038c2 <acquiresleep>
      return b;
    8000248a:	a8b9                	j	800024e8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000248c:	00015497          	auipc	s1,0x15
    80002490:	8dc4b483          	ld	s1,-1828(s1) # 80016d68 <bcache+0x82b0>
    80002494:	00015797          	auipc	a5,0x15
    80002498:	88c78793          	add	a5,a5,-1908 # 80016d20 <bcache+0x8268>
    8000249c:	00f48863          	beq	s1,a5,800024ac <bread+0x90>
    800024a0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024a2:	40bc                	lw	a5,64(s1)
    800024a4:	cf81                	beqz	a5,800024bc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024a6:	64a4                	ld	s1,72(s1)
    800024a8:	fee49de3          	bne	s1,a4,800024a2 <bread+0x86>
  panic("bget: no buffers");
    800024ac:	00006517          	auipc	a0,0x6
    800024b0:	17c50513          	add	a0,a0,380 # 80008628 <syscall_names+0xd0>
    800024b4:	00003097          	auipc	ra,0x3
    800024b8:	7d2080e7          	jalr	2002(ra) # 80005c86 <panic>
      b->dev = dev;
    800024bc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024c0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024c4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024c8:	4785                	li	a5,1
    800024ca:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024cc:	0000c517          	auipc	a0,0xc
    800024d0:	5ec50513          	add	a0,a0,1516 # 8000eab8 <bcache>
    800024d4:	00004097          	auipc	ra,0x4
    800024d8:	d9e080e7          	jalr	-610(ra) # 80006272 <release>
      acquiresleep(&b->lock);
    800024dc:	01048513          	add	a0,s1,16
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	3e2080e7          	jalr	994(ra) # 800038c2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024e8:	409c                	lw	a5,0(s1)
    800024ea:	cb89                	beqz	a5,800024fc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024ec:	8526                	mv	a0,s1
    800024ee:	70a2                	ld	ra,40(sp)
    800024f0:	7402                	ld	s0,32(sp)
    800024f2:	64e2                	ld	s1,24(sp)
    800024f4:	6942                	ld	s2,16(sp)
    800024f6:	69a2                	ld	s3,8(sp)
    800024f8:	6145                	add	sp,sp,48
    800024fa:	8082                	ret
    virtio_disk_rw(b, 0);
    800024fc:	4581                	li	a1,0
    800024fe:	8526                	mv	a0,s1
    80002500:	00003097          	auipc	ra,0x3
    80002504:	f82080e7          	jalr	-126(ra) # 80005482 <virtio_disk_rw>
    b->valid = 1;
    80002508:	4785                	li	a5,1
    8000250a:	c09c                	sw	a5,0(s1)
  return b;
    8000250c:	b7c5                	j	800024ec <bread+0xd0>

000000008000250e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000250e:	1101                	add	sp,sp,-32
    80002510:	ec06                	sd	ra,24(sp)
    80002512:	e822                	sd	s0,16(sp)
    80002514:	e426                	sd	s1,8(sp)
    80002516:	1000                	add	s0,sp,32
    80002518:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000251a:	0541                	add	a0,a0,16
    8000251c:	00001097          	auipc	ra,0x1
    80002520:	440080e7          	jalr	1088(ra) # 8000395c <holdingsleep>
    80002524:	cd01                	beqz	a0,8000253c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002526:	4585                	li	a1,1
    80002528:	8526                	mv	a0,s1
    8000252a:	00003097          	auipc	ra,0x3
    8000252e:	f58080e7          	jalr	-168(ra) # 80005482 <virtio_disk_rw>
}
    80002532:	60e2                	ld	ra,24(sp)
    80002534:	6442                	ld	s0,16(sp)
    80002536:	64a2                	ld	s1,8(sp)
    80002538:	6105                	add	sp,sp,32
    8000253a:	8082                	ret
    panic("bwrite");
    8000253c:	00006517          	auipc	a0,0x6
    80002540:	10450513          	add	a0,a0,260 # 80008640 <syscall_names+0xe8>
    80002544:	00003097          	auipc	ra,0x3
    80002548:	742080e7          	jalr	1858(ra) # 80005c86 <panic>

000000008000254c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000254c:	1101                	add	sp,sp,-32
    8000254e:	ec06                	sd	ra,24(sp)
    80002550:	e822                	sd	s0,16(sp)
    80002552:	e426                	sd	s1,8(sp)
    80002554:	e04a                	sd	s2,0(sp)
    80002556:	1000                	add	s0,sp,32
    80002558:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000255a:	01050913          	add	s2,a0,16
    8000255e:	854a                	mv	a0,s2
    80002560:	00001097          	auipc	ra,0x1
    80002564:	3fc080e7          	jalr	1020(ra) # 8000395c <holdingsleep>
    80002568:	c925                	beqz	a0,800025d8 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000256a:	854a                	mv	a0,s2
    8000256c:	00001097          	auipc	ra,0x1
    80002570:	3ac080e7          	jalr	940(ra) # 80003918 <releasesleep>

  acquire(&bcache.lock);
    80002574:	0000c517          	auipc	a0,0xc
    80002578:	54450513          	add	a0,a0,1348 # 8000eab8 <bcache>
    8000257c:	00004097          	auipc	ra,0x4
    80002580:	c42080e7          	jalr	-958(ra) # 800061be <acquire>
  b->refcnt--;
    80002584:	40bc                	lw	a5,64(s1)
    80002586:	37fd                	addw	a5,a5,-1
    80002588:	0007871b          	sext.w	a4,a5
    8000258c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000258e:	e71d                	bnez	a4,800025bc <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002590:	68b8                	ld	a4,80(s1)
    80002592:	64bc                	ld	a5,72(s1)
    80002594:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002596:	68b8                	ld	a4,80(s1)
    80002598:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000259a:	00014797          	auipc	a5,0x14
    8000259e:	51e78793          	add	a5,a5,1310 # 80016ab8 <bcache+0x8000>
    800025a2:	2b87b703          	ld	a4,696(a5)
    800025a6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025a8:	00014717          	auipc	a4,0x14
    800025ac:	77870713          	add	a4,a4,1912 # 80016d20 <bcache+0x8268>
    800025b0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025b2:	2b87b703          	ld	a4,696(a5)
    800025b6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025b8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025bc:	0000c517          	auipc	a0,0xc
    800025c0:	4fc50513          	add	a0,a0,1276 # 8000eab8 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	cae080e7          	jalr	-850(ra) # 80006272 <release>
}
    800025cc:	60e2                	ld	ra,24(sp)
    800025ce:	6442                	ld	s0,16(sp)
    800025d0:	64a2                	ld	s1,8(sp)
    800025d2:	6902                	ld	s2,0(sp)
    800025d4:	6105                	add	sp,sp,32
    800025d6:	8082                	ret
    panic("brelse");
    800025d8:	00006517          	auipc	a0,0x6
    800025dc:	07050513          	add	a0,a0,112 # 80008648 <syscall_names+0xf0>
    800025e0:	00003097          	auipc	ra,0x3
    800025e4:	6a6080e7          	jalr	1702(ra) # 80005c86 <panic>

00000000800025e8 <bpin>:

void
bpin(struct buf *b) {
    800025e8:	1101                	add	sp,sp,-32
    800025ea:	ec06                	sd	ra,24(sp)
    800025ec:	e822                	sd	s0,16(sp)
    800025ee:	e426                	sd	s1,8(sp)
    800025f0:	1000                	add	s0,sp,32
    800025f2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f4:	0000c517          	auipc	a0,0xc
    800025f8:	4c450513          	add	a0,a0,1220 # 8000eab8 <bcache>
    800025fc:	00004097          	auipc	ra,0x4
    80002600:	bc2080e7          	jalr	-1086(ra) # 800061be <acquire>
  b->refcnt++;
    80002604:	40bc                	lw	a5,64(s1)
    80002606:	2785                	addw	a5,a5,1
    80002608:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260a:	0000c517          	auipc	a0,0xc
    8000260e:	4ae50513          	add	a0,a0,1198 # 8000eab8 <bcache>
    80002612:	00004097          	auipc	ra,0x4
    80002616:	c60080e7          	jalr	-928(ra) # 80006272 <release>
}
    8000261a:	60e2                	ld	ra,24(sp)
    8000261c:	6442                	ld	s0,16(sp)
    8000261e:	64a2                	ld	s1,8(sp)
    80002620:	6105                	add	sp,sp,32
    80002622:	8082                	ret

0000000080002624 <bunpin>:

void
bunpin(struct buf *b) {
    80002624:	1101                	add	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	e426                	sd	s1,8(sp)
    8000262c:	1000                	add	s0,sp,32
    8000262e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002630:	0000c517          	auipc	a0,0xc
    80002634:	48850513          	add	a0,a0,1160 # 8000eab8 <bcache>
    80002638:	00004097          	auipc	ra,0x4
    8000263c:	b86080e7          	jalr	-1146(ra) # 800061be <acquire>
  b->refcnt--;
    80002640:	40bc                	lw	a5,64(s1)
    80002642:	37fd                	addw	a5,a5,-1
    80002644:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002646:	0000c517          	auipc	a0,0xc
    8000264a:	47250513          	add	a0,a0,1138 # 8000eab8 <bcache>
    8000264e:	00004097          	auipc	ra,0x4
    80002652:	c24080e7          	jalr	-988(ra) # 80006272 <release>
}
    80002656:	60e2                	ld	ra,24(sp)
    80002658:	6442                	ld	s0,16(sp)
    8000265a:	64a2                	ld	s1,8(sp)
    8000265c:	6105                	add	sp,sp,32
    8000265e:	8082                	ret

0000000080002660 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002660:	1101                	add	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	e426                	sd	s1,8(sp)
    80002668:	e04a                	sd	s2,0(sp)
    8000266a:	1000                	add	s0,sp,32
    8000266c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000266e:	00d5d59b          	srlw	a1,a1,0xd
    80002672:	00015797          	auipc	a5,0x15
    80002676:	b227a783          	lw	a5,-1246(a5) # 80017194 <sb+0x1c>
    8000267a:	9dbd                	addw	a1,a1,a5
    8000267c:	00000097          	auipc	ra,0x0
    80002680:	da0080e7          	jalr	-608(ra) # 8000241c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002684:	0074f713          	and	a4,s1,7
    80002688:	4785                	li	a5,1
    8000268a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000268e:	14ce                	sll	s1,s1,0x33
    80002690:	90d9                	srl	s1,s1,0x36
    80002692:	00950733          	add	a4,a0,s1
    80002696:	05874703          	lbu	a4,88(a4)
    8000269a:	00e7f6b3          	and	a3,a5,a4
    8000269e:	c69d                	beqz	a3,800026cc <bfree+0x6c>
    800026a0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026a2:	94aa                	add	s1,s1,a0
    800026a4:	fff7c793          	not	a5,a5
    800026a8:	8f7d                	and	a4,a4,a5
    800026aa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026ae:	00001097          	auipc	ra,0x1
    800026b2:	0f6080e7          	jalr	246(ra) # 800037a4 <log_write>
  brelse(bp);
    800026b6:	854a                	mv	a0,s2
    800026b8:	00000097          	auipc	ra,0x0
    800026bc:	e94080e7          	jalr	-364(ra) # 8000254c <brelse>
}
    800026c0:	60e2                	ld	ra,24(sp)
    800026c2:	6442                	ld	s0,16(sp)
    800026c4:	64a2                	ld	s1,8(sp)
    800026c6:	6902                	ld	s2,0(sp)
    800026c8:	6105                	add	sp,sp,32
    800026ca:	8082                	ret
    panic("freeing free block");
    800026cc:	00006517          	auipc	a0,0x6
    800026d0:	f8450513          	add	a0,a0,-124 # 80008650 <syscall_names+0xf8>
    800026d4:	00003097          	auipc	ra,0x3
    800026d8:	5b2080e7          	jalr	1458(ra) # 80005c86 <panic>

00000000800026dc <balloc>:
{
    800026dc:	711d                	add	sp,sp,-96
    800026de:	ec86                	sd	ra,88(sp)
    800026e0:	e8a2                	sd	s0,80(sp)
    800026e2:	e4a6                	sd	s1,72(sp)
    800026e4:	e0ca                	sd	s2,64(sp)
    800026e6:	fc4e                	sd	s3,56(sp)
    800026e8:	f852                	sd	s4,48(sp)
    800026ea:	f456                	sd	s5,40(sp)
    800026ec:	f05a                	sd	s6,32(sp)
    800026ee:	ec5e                	sd	s7,24(sp)
    800026f0:	e862                	sd	s8,16(sp)
    800026f2:	e466                	sd	s9,8(sp)
    800026f4:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026f6:	00015797          	auipc	a5,0x15
    800026fa:	a867a783          	lw	a5,-1402(a5) # 8001717c <sb+0x4>
    800026fe:	cff5                	beqz	a5,800027fa <balloc+0x11e>
    80002700:	8baa                	mv	s7,a0
    80002702:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002704:	00015b17          	auipc	s6,0x15
    80002708:	a74b0b13          	add	s6,s6,-1420 # 80017178 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000270e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002710:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002712:	6c89                	lui	s9,0x2
    80002714:	a061                	j	8000279c <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002716:	97ca                	add	a5,a5,s2
    80002718:	8e55                	or	a2,a2,a3
    8000271a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000271e:	854a                	mv	a0,s2
    80002720:	00001097          	auipc	ra,0x1
    80002724:	084080e7          	jalr	132(ra) # 800037a4 <log_write>
        brelse(bp);
    80002728:	854a                	mv	a0,s2
    8000272a:	00000097          	auipc	ra,0x0
    8000272e:	e22080e7          	jalr	-478(ra) # 8000254c <brelse>
  bp = bread(dev, bno);
    80002732:	85a6                	mv	a1,s1
    80002734:	855e                	mv	a0,s7
    80002736:	00000097          	auipc	ra,0x0
    8000273a:	ce6080e7          	jalr	-794(ra) # 8000241c <bread>
    8000273e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002740:	40000613          	li	a2,1024
    80002744:	4581                	li	a1,0
    80002746:	05850513          	add	a0,a0,88
    8000274a:	ffffe097          	auipc	ra,0xffffe
    8000274e:	a7a080e7          	jalr	-1414(ra) # 800001c4 <memset>
  log_write(bp);
    80002752:	854a                	mv	a0,s2
    80002754:	00001097          	auipc	ra,0x1
    80002758:	050080e7          	jalr	80(ra) # 800037a4 <log_write>
  brelse(bp);
    8000275c:	854a                	mv	a0,s2
    8000275e:	00000097          	auipc	ra,0x0
    80002762:	dee080e7          	jalr	-530(ra) # 8000254c <brelse>
}
    80002766:	8526                	mv	a0,s1
    80002768:	60e6                	ld	ra,88(sp)
    8000276a:	6446                	ld	s0,80(sp)
    8000276c:	64a6                	ld	s1,72(sp)
    8000276e:	6906                	ld	s2,64(sp)
    80002770:	79e2                	ld	s3,56(sp)
    80002772:	7a42                	ld	s4,48(sp)
    80002774:	7aa2                	ld	s5,40(sp)
    80002776:	7b02                	ld	s6,32(sp)
    80002778:	6be2                	ld	s7,24(sp)
    8000277a:	6c42                	ld	s8,16(sp)
    8000277c:	6ca2                	ld	s9,8(sp)
    8000277e:	6125                	add	sp,sp,96
    80002780:	8082                	ret
    brelse(bp);
    80002782:	854a                	mv	a0,s2
    80002784:	00000097          	auipc	ra,0x0
    80002788:	dc8080e7          	jalr	-568(ra) # 8000254c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000278c:	015c87bb          	addw	a5,s9,s5
    80002790:	00078a9b          	sext.w	s5,a5
    80002794:	004b2703          	lw	a4,4(s6)
    80002798:	06eaf163          	bgeu	s5,a4,800027fa <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000279c:	41fad79b          	sraw	a5,s5,0x1f
    800027a0:	0137d79b          	srlw	a5,a5,0x13
    800027a4:	015787bb          	addw	a5,a5,s5
    800027a8:	40d7d79b          	sraw	a5,a5,0xd
    800027ac:	01cb2583          	lw	a1,28(s6)
    800027b0:	9dbd                	addw	a1,a1,a5
    800027b2:	855e                	mv	a0,s7
    800027b4:	00000097          	auipc	ra,0x0
    800027b8:	c68080e7          	jalr	-920(ra) # 8000241c <bread>
    800027bc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027be:	004b2503          	lw	a0,4(s6)
    800027c2:	000a849b          	sext.w	s1,s5
    800027c6:	8762                	mv	a4,s8
    800027c8:	faa4fde3          	bgeu	s1,a0,80002782 <balloc+0xa6>
      m = 1 << (bi % 8);
    800027cc:	00777693          	and	a3,a4,7
    800027d0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027d4:	41f7579b          	sraw	a5,a4,0x1f
    800027d8:	01d7d79b          	srlw	a5,a5,0x1d
    800027dc:	9fb9                	addw	a5,a5,a4
    800027de:	4037d79b          	sraw	a5,a5,0x3
    800027e2:	00f90633          	add	a2,s2,a5
    800027e6:	05864603          	lbu	a2,88(a2)
    800027ea:	00c6f5b3          	and	a1,a3,a2
    800027ee:	d585                	beqz	a1,80002716 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f0:	2705                	addw	a4,a4,1
    800027f2:	2485                	addw	s1,s1,1
    800027f4:	fd471ae3          	bne	a4,s4,800027c8 <balloc+0xec>
    800027f8:	b769                	j	80002782 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800027fa:	00006517          	auipc	a0,0x6
    800027fe:	e6e50513          	add	a0,a0,-402 # 80008668 <syscall_names+0x110>
    80002802:	00003097          	auipc	ra,0x3
    80002806:	4ce080e7          	jalr	1230(ra) # 80005cd0 <printf>
  return 0;
    8000280a:	4481                	li	s1,0
    8000280c:	bfa9                	j	80002766 <balloc+0x8a>

000000008000280e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000280e:	7179                	add	sp,sp,-48
    80002810:	f406                	sd	ra,40(sp)
    80002812:	f022                	sd	s0,32(sp)
    80002814:	ec26                	sd	s1,24(sp)
    80002816:	e84a                	sd	s2,16(sp)
    80002818:	e44e                	sd	s3,8(sp)
    8000281a:	e052                	sd	s4,0(sp)
    8000281c:	1800                	add	s0,sp,48
    8000281e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002820:	47ad                	li	a5,11
    80002822:	02b7e863          	bltu	a5,a1,80002852 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002826:	02059793          	sll	a5,a1,0x20
    8000282a:	01e7d593          	srl	a1,a5,0x1e
    8000282e:	00b504b3          	add	s1,a0,a1
    80002832:	0504a903          	lw	s2,80(s1)
    80002836:	06091e63          	bnez	s2,800028b2 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000283a:	4108                	lw	a0,0(a0)
    8000283c:	00000097          	auipc	ra,0x0
    80002840:	ea0080e7          	jalr	-352(ra) # 800026dc <balloc>
    80002844:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002848:	06090563          	beqz	s2,800028b2 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000284c:	0524a823          	sw	s2,80(s1)
    80002850:	a08d                	j	800028b2 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002852:	ff45849b          	addw	s1,a1,-12
    80002856:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000285a:	0ff00793          	li	a5,255
    8000285e:	08e7e563          	bltu	a5,a4,800028e8 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002862:	08052903          	lw	s2,128(a0)
    80002866:	00091d63          	bnez	s2,80002880 <bmap+0x72>
      addr = balloc(ip->dev);
    8000286a:	4108                	lw	a0,0(a0)
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	e70080e7          	jalr	-400(ra) # 800026dc <balloc>
    80002874:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002878:	02090d63          	beqz	s2,800028b2 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000287c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002880:	85ca                	mv	a1,s2
    80002882:	0009a503          	lw	a0,0(s3)
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	b96080e7          	jalr	-1130(ra) # 8000241c <bread>
    8000288e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002890:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002894:	02049713          	sll	a4,s1,0x20
    80002898:	01e75593          	srl	a1,a4,0x1e
    8000289c:	00b784b3          	add	s1,a5,a1
    800028a0:	0004a903          	lw	s2,0(s1)
    800028a4:	02090063          	beqz	s2,800028c4 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028a8:	8552                	mv	a0,s4
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	ca2080e7          	jalr	-862(ra) # 8000254c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028b2:	854a                	mv	a0,s2
    800028b4:	70a2                	ld	ra,40(sp)
    800028b6:	7402                	ld	s0,32(sp)
    800028b8:	64e2                	ld	s1,24(sp)
    800028ba:	6942                	ld	s2,16(sp)
    800028bc:	69a2                	ld	s3,8(sp)
    800028be:	6a02                	ld	s4,0(sp)
    800028c0:	6145                	add	sp,sp,48
    800028c2:	8082                	ret
      addr = balloc(ip->dev);
    800028c4:	0009a503          	lw	a0,0(s3)
    800028c8:	00000097          	auipc	ra,0x0
    800028cc:	e14080e7          	jalr	-492(ra) # 800026dc <balloc>
    800028d0:	0005091b          	sext.w	s2,a0
      if(addr){
    800028d4:	fc090ae3          	beqz	s2,800028a8 <bmap+0x9a>
        a[bn] = addr;
    800028d8:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028dc:	8552                	mv	a0,s4
    800028de:	00001097          	auipc	ra,0x1
    800028e2:	ec6080e7          	jalr	-314(ra) # 800037a4 <log_write>
    800028e6:	b7c9                	j	800028a8 <bmap+0x9a>
  panic("bmap: out of range");
    800028e8:	00006517          	auipc	a0,0x6
    800028ec:	d9850513          	add	a0,a0,-616 # 80008680 <syscall_names+0x128>
    800028f0:	00003097          	auipc	ra,0x3
    800028f4:	396080e7          	jalr	918(ra) # 80005c86 <panic>

00000000800028f8 <iget>:
{
    800028f8:	7179                	add	sp,sp,-48
    800028fa:	f406                	sd	ra,40(sp)
    800028fc:	f022                	sd	s0,32(sp)
    800028fe:	ec26                	sd	s1,24(sp)
    80002900:	e84a                	sd	s2,16(sp)
    80002902:	e44e                	sd	s3,8(sp)
    80002904:	e052                	sd	s4,0(sp)
    80002906:	1800                	add	s0,sp,48
    80002908:	89aa                	mv	s3,a0
    8000290a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000290c:	00015517          	auipc	a0,0x15
    80002910:	88c50513          	add	a0,a0,-1908 # 80017198 <itable>
    80002914:	00004097          	auipc	ra,0x4
    80002918:	8aa080e7          	jalr	-1878(ra) # 800061be <acquire>
  empty = 0;
    8000291c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000291e:	00015497          	auipc	s1,0x15
    80002922:	89248493          	add	s1,s1,-1902 # 800171b0 <itable+0x18>
    80002926:	00016697          	auipc	a3,0x16
    8000292a:	31a68693          	add	a3,a3,794 # 80018c40 <log>
    8000292e:	a039                	j	8000293c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002930:	02090b63          	beqz	s2,80002966 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002934:	08848493          	add	s1,s1,136
    80002938:	02d48a63          	beq	s1,a3,8000296c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000293c:	449c                	lw	a5,8(s1)
    8000293e:	fef059e3          	blez	a5,80002930 <iget+0x38>
    80002942:	4098                	lw	a4,0(s1)
    80002944:	ff3716e3          	bne	a4,s3,80002930 <iget+0x38>
    80002948:	40d8                	lw	a4,4(s1)
    8000294a:	ff4713e3          	bne	a4,s4,80002930 <iget+0x38>
      ip->ref++;
    8000294e:	2785                	addw	a5,a5,1
    80002950:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002952:	00015517          	auipc	a0,0x15
    80002956:	84650513          	add	a0,a0,-1978 # 80017198 <itable>
    8000295a:	00004097          	auipc	ra,0x4
    8000295e:	918080e7          	jalr	-1768(ra) # 80006272 <release>
      return ip;
    80002962:	8926                	mv	s2,s1
    80002964:	a03d                	j	80002992 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002966:	f7f9                	bnez	a5,80002934 <iget+0x3c>
    80002968:	8926                	mv	s2,s1
    8000296a:	b7e9                	j	80002934 <iget+0x3c>
  if(empty == 0)
    8000296c:	02090c63          	beqz	s2,800029a4 <iget+0xac>
  ip->dev = dev;
    80002970:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002974:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002978:	4785                	li	a5,1
    8000297a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000297e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002982:	00015517          	auipc	a0,0x15
    80002986:	81650513          	add	a0,a0,-2026 # 80017198 <itable>
    8000298a:	00004097          	auipc	ra,0x4
    8000298e:	8e8080e7          	jalr	-1816(ra) # 80006272 <release>
}
    80002992:	854a                	mv	a0,s2
    80002994:	70a2                	ld	ra,40(sp)
    80002996:	7402                	ld	s0,32(sp)
    80002998:	64e2                	ld	s1,24(sp)
    8000299a:	6942                	ld	s2,16(sp)
    8000299c:	69a2                	ld	s3,8(sp)
    8000299e:	6a02                	ld	s4,0(sp)
    800029a0:	6145                	add	sp,sp,48
    800029a2:	8082                	ret
    panic("iget: no inodes");
    800029a4:	00006517          	auipc	a0,0x6
    800029a8:	cf450513          	add	a0,a0,-780 # 80008698 <syscall_names+0x140>
    800029ac:	00003097          	auipc	ra,0x3
    800029b0:	2da080e7          	jalr	730(ra) # 80005c86 <panic>

00000000800029b4 <fsinit>:
fsinit(int dev) {
    800029b4:	7179                	add	sp,sp,-48
    800029b6:	f406                	sd	ra,40(sp)
    800029b8:	f022                	sd	s0,32(sp)
    800029ba:	ec26                	sd	s1,24(sp)
    800029bc:	e84a                	sd	s2,16(sp)
    800029be:	e44e                	sd	s3,8(sp)
    800029c0:	1800                	add	s0,sp,48
    800029c2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029c4:	4585                	li	a1,1
    800029c6:	00000097          	auipc	ra,0x0
    800029ca:	a56080e7          	jalr	-1450(ra) # 8000241c <bread>
    800029ce:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029d0:	00014997          	auipc	s3,0x14
    800029d4:	7a898993          	add	s3,s3,1960 # 80017178 <sb>
    800029d8:	02000613          	li	a2,32
    800029dc:	05850593          	add	a1,a0,88
    800029e0:	854e                	mv	a0,s3
    800029e2:	ffffe097          	auipc	ra,0xffffe
    800029e6:	83e080e7          	jalr	-1986(ra) # 80000220 <memmove>
  brelse(bp);
    800029ea:	8526                	mv	a0,s1
    800029ec:	00000097          	auipc	ra,0x0
    800029f0:	b60080e7          	jalr	-1184(ra) # 8000254c <brelse>
  if(sb.magic != FSMAGIC)
    800029f4:	0009a703          	lw	a4,0(s3)
    800029f8:	102037b7          	lui	a5,0x10203
    800029fc:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a00:	02f71263          	bne	a4,a5,80002a24 <fsinit+0x70>
  initlog(dev, &sb);
    80002a04:	00014597          	auipc	a1,0x14
    80002a08:	77458593          	add	a1,a1,1908 # 80017178 <sb>
    80002a0c:	854a                	mv	a0,s2
    80002a0e:	00001097          	auipc	ra,0x1
    80002a12:	b2c080e7          	jalr	-1236(ra) # 8000353a <initlog>
}
    80002a16:	70a2                	ld	ra,40(sp)
    80002a18:	7402                	ld	s0,32(sp)
    80002a1a:	64e2                	ld	s1,24(sp)
    80002a1c:	6942                	ld	s2,16(sp)
    80002a1e:	69a2                	ld	s3,8(sp)
    80002a20:	6145                	add	sp,sp,48
    80002a22:	8082                	ret
    panic("invalid file system");
    80002a24:	00006517          	auipc	a0,0x6
    80002a28:	c8450513          	add	a0,a0,-892 # 800086a8 <syscall_names+0x150>
    80002a2c:	00003097          	auipc	ra,0x3
    80002a30:	25a080e7          	jalr	602(ra) # 80005c86 <panic>

0000000080002a34 <iinit>:
{
    80002a34:	7179                	add	sp,sp,-48
    80002a36:	f406                	sd	ra,40(sp)
    80002a38:	f022                	sd	s0,32(sp)
    80002a3a:	ec26                	sd	s1,24(sp)
    80002a3c:	e84a                	sd	s2,16(sp)
    80002a3e:	e44e                	sd	s3,8(sp)
    80002a40:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a42:	00006597          	auipc	a1,0x6
    80002a46:	c7e58593          	add	a1,a1,-898 # 800086c0 <syscall_names+0x168>
    80002a4a:	00014517          	auipc	a0,0x14
    80002a4e:	74e50513          	add	a0,a0,1870 # 80017198 <itable>
    80002a52:	00003097          	auipc	ra,0x3
    80002a56:	6dc080e7          	jalr	1756(ra) # 8000612e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a5a:	00014497          	auipc	s1,0x14
    80002a5e:	76648493          	add	s1,s1,1894 # 800171c0 <itable+0x28>
    80002a62:	00016997          	auipc	s3,0x16
    80002a66:	1ee98993          	add	s3,s3,494 # 80018c50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a6a:	00006917          	auipc	s2,0x6
    80002a6e:	c5e90913          	add	s2,s2,-930 # 800086c8 <syscall_names+0x170>
    80002a72:	85ca                	mv	a1,s2
    80002a74:	8526                	mv	a0,s1
    80002a76:	00001097          	auipc	ra,0x1
    80002a7a:	e12080e7          	jalr	-494(ra) # 80003888 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a7e:	08848493          	add	s1,s1,136
    80002a82:	ff3498e3          	bne	s1,s3,80002a72 <iinit+0x3e>
}
    80002a86:	70a2                	ld	ra,40(sp)
    80002a88:	7402                	ld	s0,32(sp)
    80002a8a:	64e2                	ld	s1,24(sp)
    80002a8c:	6942                	ld	s2,16(sp)
    80002a8e:	69a2                	ld	s3,8(sp)
    80002a90:	6145                	add	sp,sp,48
    80002a92:	8082                	ret

0000000080002a94 <ialloc>:
{
    80002a94:	7139                	add	sp,sp,-64
    80002a96:	fc06                	sd	ra,56(sp)
    80002a98:	f822                	sd	s0,48(sp)
    80002a9a:	f426                	sd	s1,40(sp)
    80002a9c:	f04a                	sd	s2,32(sp)
    80002a9e:	ec4e                	sd	s3,24(sp)
    80002aa0:	e852                	sd	s4,16(sp)
    80002aa2:	e456                	sd	s5,8(sp)
    80002aa4:	e05a                	sd	s6,0(sp)
    80002aa6:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aa8:	00014717          	auipc	a4,0x14
    80002aac:	6dc72703          	lw	a4,1756(a4) # 80017184 <sb+0xc>
    80002ab0:	4785                	li	a5,1
    80002ab2:	04e7f863          	bgeu	a5,a4,80002b02 <ialloc+0x6e>
    80002ab6:	8aaa                	mv	s5,a0
    80002ab8:	8b2e                	mv	s6,a1
    80002aba:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002abc:	00014a17          	auipc	s4,0x14
    80002ac0:	6bca0a13          	add	s4,s4,1724 # 80017178 <sb>
    80002ac4:	00495593          	srl	a1,s2,0x4
    80002ac8:	018a2783          	lw	a5,24(s4)
    80002acc:	9dbd                	addw	a1,a1,a5
    80002ace:	8556                	mv	a0,s5
    80002ad0:	00000097          	auipc	ra,0x0
    80002ad4:	94c080e7          	jalr	-1716(ra) # 8000241c <bread>
    80002ad8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ada:	05850993          	add	s3,a0,88
    80002ade:	00f97793          	and	a5,s2,15
    80002ae2:	079a                	sll	a5,a5,0x6
    80002ae4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ae6:	00099783          	lh	a5,0(s3)
    80002aea:	cf9d                	beqz	a5,80002b28 <ialloc+0x94>
    brelse(bp);
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	a60080e7          	jalr	-1440(ra) # 8000254c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002af4:	0905                	add	s2,s2,1
    80002af6:	00ca2703          	lw	a4,12(s4)
    80002afa:	0009079b          	sext.w	a5,s2
    80002afe:	fce7e3e3          	bltu	a5,a4,80002ac4 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002b02:	00006517          	auipc	a0,0x6
    80002b06:	bce50513          	add	a0,a0,-1074 # 800086d0 <syscall_names+0x178>
    80002b0a:	00003097          	auipc	ra,0x3
    80002b0e:	1c6080e7          	jalr	454(ra) # 80005cd0 <printf>
  return 0;
    80002b12:	4501                	li	a0,0
}
    80002b14:	70e2                	ld	ra,56(sp)
    80002b16:	7442                	ld	s0,48(sp)
    80002b18:	74a2                	ld	s1,40(sp)
    80002b1a:	7902                	ld	s2,32(sp)
    80002b1c:	69e2                	ld	s3,24(sp)
    80002b1e:	6a42                	ld	s4,16(sp)
    80002b20:	6aa2                	ld	s5,8(sp)
    80002b22:	6b02                	ld	s6,0(sp)
    80002b24:	6121                	add	sp,sp,64
    80002b26:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b28:	04000613          	li	a2,64
    80002b2c:	4581                	li	a1,0
    80002b2e:	854e                	mv	a0,s3
    80002b30:	ffffd097          	auipc	ra,0xffffd
    80002b34:	694080e7          	jalr	1684(ra) # 800001c4 <memset>
      dip->type = type;
    80002b38:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b3c:	8526                	mv	a0,s1
    80002b3e:	00001097          	auipc	ra,0x1
    80002b42:	c66080e7          	jalr	-922(ra) # 800037a4 <log_write>
      brelse(bp);
    80002b46:	8526                	mv	a0,s1
    80002b48:	00000097          	auipc	ra,0x0
    80002b4c:	a04080e7          	jalr	-1532(ra) # 8000254c <brelse>
      return iget(dev, inum);
    80002b50:	0009059b          	sext.w	a1,s2
    80002b54:	8556                	mv	a0,s5
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	da2080e7          	jalr	-606(ra) # 800028f8 <iget>
    80002b5e:	bf5d                	j	80002b14 <ialloc+0x80>

0000000080002b60 <iupdate>:
{
    80002b60:	1101                	add	sp,sp,-32
    80002b62:	ec06                	sd	ra,24(sp)
    80002b64:	e822                	sd	s0,16(sp)
    80002b66:	e426                	sd	s1,8(sp)
    80002b68:	e04a                	sd	s2,0(sp)
    80002b6a:	1000                	add	s0,sp,32
    80002b6c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b6e:	415c                	lw	a5,4(a0)
    80002b70:	0047d79b          	srlw	a5,a5,0x4
    80002b74:	00014597          	auipc	a1,0x14
    80002b78:	61c5a583          	lw	a1,1564(a1) # 80017190 <sb+0x18>
    80002b7c:	9dbd                	addw	a1,a1,a5
    80002b7e:	4108                	lw	a0,0(a0)
    80002b80:	00000097          	auipc	ra,0x0
    80002b84:	89c080e7          	jalr	-1892(ra) # 8000241c <bread>
    80002b88:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b8a:	05850793          	add	a5,a0,88
    80002b8e:	40d8                	lw	a4,4(s1)
    80002b90:	8b3d                	and	a4,a4,15
    80002b92:	071a                	sll	a4,a4,0x6
    80002b94:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b96:	04449703          	lh	a4,68(s1)
    80002b9a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b9e:	04649703          	lh	a4,70(s1)
    80002ba2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ba6:	04849703          	lh	a4,72(s1)
    80002baa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002bae:	04a49703          	lh	a4,74(s1)
    80002bb2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bb6:	44f8                	lw	a4,76(s1)
    80002bb8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bba:	03400613          	li	a2,52
    80002bbe:	05048593          	add	a1,s1,80
    80002bc2:	00c78513          	add	a0,a5,12
    80002bc6:	ffffd097          	auipc	ra,0xffffd
    80002bca:	65a080e7          	jalr	1626(ra) # 80000220 <memmove>
  log_write(bp);
    80002bce:	854a                	mv	a0,s2
    80002bd0:	00001097          	auipc	ra,0x1
    80002bd4:	bd4080e7          	jalr	-1068(ra) # 800037a4 <log_write>
  brelse(bp);
    80002bd8:	854a                	mv	a0,s2
    80002bda:	00000097          	auipc	ra,0x0
    80002bde:	972080e7          	jalr	-1678(ra) # 8000254c <brelse>
}
    80002be2:	60e2                	ld	ra,24(sp)
    80002be4:	6442                	ld	s0,16(sp)
    80002be6:	64a2                	ld	s1,8(sp)
    80002be8:	6902                	ld	s2,0(sp)
    80002bea:	6105                	add	sp,sp,32
    80002bec:	8082                	ret

0000000080002bee <idup>:
{
    80002bee:	1101                	add	sp,sp,-32
    80002bf0:	ec06                	sd	ra,24(sp)
    80002bf2:	e822                	sd	s0,16(sp)
    80002bf4:	e426                	sd	s1,8(sp)
    80002bf6:	1000                	add	s0,sp,32
    80002bf8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bfa:	00014517          	auipc	a0,0x14
    80002bfe:	59e50513          	add	a0,a0,1438 # 80017198 <itable>
    80002c02:	00003097          	auipc	ra,0x3
    80002c06:	5bc080e7          	jalr	1468(ra) # 800061be <acquire>
  ip->ref++;
    80002c0a:	449c                	lw	a5,8(s1)
    80002c0c:	2785                	addw	a5,a5,1
    80002c0e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c10:	00014517          	auipc	a0,0x14
    80002c14:	58850513          	add	a0,a0,1416 # 80017198 <itable>
    80002c18:	00003097          	auipc	ra,0x3
    80002c1c:	65a080e7          	jalr	1626(ra) # 80006272 <release>
}
    80002c20:	8526                	mv	a0,s1
    80002c22:	60e2                	ld	ra,24(sp)
    80002c24:	6442                	ld	s0,16(sp)
    80002c26:	64a2                	ld	s1,8(sp)
    80002c28:	6105                	add	sp,sp,32
    80002c2a:	8082                	ret

0000000080002c2c <ilock>:
{
    80002c2c:	1101                	add	sp,sp,-32
    80002c2e:	ec06                	sd	ra,24(sp)
    80002c30:	e822                	sd	s0,16(sp)
    80002c32:	e426                	sd	s1,8(sp)
    80002c34:	e04a                	sd	s2,0(sp)
    80002c36:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c38:	c115                	beqz	a0,80002c5c <ilock+0x30>
    80002c3a:	84aa                	mv	s1,a0
    80002c3c:	451c                	lw	a5,8(a0)
    80002c3e:	00f05f63          	blez	a5,80002c5c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c42:	0541                	add	a0,a0,16
    80002c44:	00001097          	auipc	ra,0x1
    80002c48:	c7e080e7          	jalr	-898(ra) # 800038c2 <acquiresleep>
  if(ip->valid == 0){
    80002c4c:	40bc                	lw	a5,64(s1)
    80002c4e:	cf99                	beqz	a5,80002c6c <ilock+0x40>
}
    80002c50:	60e2                	ld	ra,24(sp)
    80002c52:	6442                	ld	s0,16(sp)
    80002c54:	64a2                	ld	s1,8(sp)
    80002c56:	6902                	ld	s2,0(sp)
    80002c58:	6105                	add	sp,sp,32
    80002c5a:	8082                	ret
    panic("ilock");
    80002c5c:	00006517          	auipc	a0,0x6
    80002c60:	a8c50513          	add	a0,a0,-1396 # 800086e8 <syscall_names+0x190>
    80002c64:	00003097          	auipc	ra,0x3
    80002c68:	022080e7          	jalr	34(ra) # 80005c86 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c6c:	40dc                	lw	a5,4(s1)
    80002c6e:	0047d79b          	srlw	a5,a5,0x4
    80002c72:	00014597          	auipc	a1,0x14
    80002c76:	51e5a583          	lw	a1,1310(a1) # 80017190 <sb+0x18>
    80002c7a:	9dbd                	addw	a1,a1,a5
    80002c7c:	4088                	lw	a0,0(s1)
    80002c7e:	fffff097          	auipc	ra,0xfffff
    80002c82:	79e080e7          	jalr	1950(ra) # 8000241c <bread>
    80002c86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c88:	05850593          	add	a1,a0,88
    80002c8c:	40dc                	lw	a5,4(s1)
    80002c8e:	8bbd                	and	a5,a5,15
    80002c90:	079a                	sll	a5,a5,0x6
    80002c92:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c94:	00059783          	lh	a5,0(a1)
    80002c98:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c9c:	00259783          	lh	a5,2(a1)
    80002ca0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ca4:	00459783          	lh	a5,4(a1)
    80002ca8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cac:	00659783          	lh	a5,6(a1)
    80002cb0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cb4:	459c                	lw	a5,8(a1)
    80002cb6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cb8:	03400613          	li	a2,52
    80002cbc:	05b1                	add	a1,a1,12
    80002cbe:	05048513          	add	a0,s1,80
    80002cc2:	ffffd097          	auipc	ra,0xffffd
    80002cc6:	55e080e7          	jalr	1374(ra) # 80000220 <memmove>
    brelse(bp);
    80002cca:	854a                	mv	a0,s2
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	880080e7          	jalr	-1920(ra) # 8000254c <brelse>
    ip->valid = 1;
    80002cd4:	4785                	li	a5,1
    80002cd6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cd8:	04449783          	lh	a5,68(s1)
    80002cdc:	fbb5                	bnez	a5,80002c50 <ilock+0x24>
      panic("ilock: no type");
    80002cde:	00006517          	auipc	a0,0x6
    80002ce2:	a1250513          	add	a0,a0,-1518 # 800086f0 <syscall_names+0x198>
    80002ce6:	00003097          	auipc	ra,0x3
    80002cea:	fa0080e7          	jalr	-96(ra) # 80005c86 <panic>

0000000080002cee <iunlock>:
{
    80002cee:	1101                	add	sp,sp,-32
    80002cf0:	ec06                	sd	ra,24(sp)
    80002cf2:	e822                	sd	s0,16(sp)
    80002cf4:	e426                	sd	s1,8(sp)
    80002cf6:	e04a                	sd	s2,0(sp)
    80002cf8:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cfa:	c905                	beqz	a0,80002d2a <iunlock+0x3c>
    80002cfc:	84aa                	mv	s1,a0
    80002cfe:	01050913          	add	s2,a0,16
    80002d02:	854a                	mv	a0,s2
    80002d04:	00001097          	auipc	ra,0x1
    80002d08:	c58080e7          	jalr	-936(ra) # 8000395c <holdingsleep>
    80002d0c:	cd19                	beqz	a0,80002d2a <iunlock+0x3c>
    80002d0e:	449c                	lw	a5,8(s1)
    80002d10:	00f05d63          	blez	a5,80002d2a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d14:	854a                	mv	a0,s2
    80002d16:	00001097          	auipc	ra,0x1
    80002d1a:	c02080e7          	jalr	-1022(ra) # 80003918 <releasesleep>
}
    80002d1e:	60e2                	ld	ra,24(sp)
    80002d20:	6442                	ld	s0,16(sp)
    80002d22:	64a2                	ld	s1,8(sp)
    80002d24:	6902                	ld	s2,0(sp)
    80002d26:	6105                	add	sp,sp,32
    80002d28:	8082                	ret
    panic("iunlock");
    80002d2a:	00006517          	auipc	a0,0x6
    80002d2e:	9d650513          	add	a0,a0,-1578 # 80008700 <syscall_names+0x1a8>
    80002d32:	00003097          	auipc	ra,0x3
    80002d36:	f54080e7          	jalr	-172(ra) # 80005c86 <panic>

0000000080002d3a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d3a:	7179                	add	sp,sp,-48
    80002d3c:	f406                	sd	ra,40(sp)
    80002d3e:	f022                	sd	s0,32(sp)
    80002d40:	ec26                	sd	s1,24(sp)
    80002d42:	e84a                	sd	s2,16(sp)
    80002d44:	e44e                	sd	s3,8(sp)
    80002d46:	e052                	sd	s4,0(sp)
    80002d48:	1800                	add	s0,sp,48
    80002d4a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d4c:	05050493          	add	s1,a0,80
    80002d50:	08050913          	add	s2,a0,128
    80002d54:	a021                	j	80002d5c <itrunc+0x22>
    80002d56:	0491                	add	s1,s1,4
    80002d58:	01248d63          	beq	s1,s2,80002d72 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d5c:	408c                	lw	a1,0(s1)
    80002d5e:	dde5                	beqz	a1,80002d56 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d60:	0009a503          	lw	a0,0(s3)
    80002d64:	00000097          	auipc	ra,0x0
    80002d68:	8fc080e7          	jalr	-1796(ra) # 80002660 <bfree>
      ip->addrs[i] = 0;
    80002d6c:	0004a023          	sw	zero,0(s1)
    80002d70:	b7dd                	j	80002d56 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d72:	0809a583          	lw	a1,128(s3)
    80002d76:	e185                	bnez	a1,80002d96 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d78:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d7c:	854e                	mv	a0,s3
    80002d7e:	00000097          	auipc	ra,0x0
    80002d82:	de2080e7          	jalr	-542(ra) # 80002b60 <iupdate>
}
    80002d86:	70a2                	ld	ra,40(sp)
    80002d88:	7402                	ld	s0,32(sp)
    80002d8a:	64e2                	ld	s1,24(sp)
    80002d8c:	6942                	ld	s2,16(sp)
    80002d8e:	69a2                	ld	s3,8(sp)
    80002d90:	6a02                	ld	s4,0(sp)
    80002d92:	6145                	add	sp,sp,48
    80002d94:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d96:	0009a503          	lw	a0,0(s3)
    80002d9a:	fffff097          	auipc	ra,0xfffff
    80002d9e:	682080e7          	jalr	1666(ra) # 8000241c <bread>
    80002da2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002da4:	05850493          	add	s1,a0,88
    80002da8:	45850913          	add	s2,a0,1112
    80002dac:	a021                	j	80002db4 <itrunc+0x7a>
    80002dae:	0491                	add	s1,s1,4
    80002db0:	01248b63          	beq	s1,s2,80002dc6 <itrunc+0x8c>
      if(a[j])
    80002db4:	408c                	lw	a1,0(s1)
    80002db6:	dde5                	beqz	a1,80002dae <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002db8:	0009a503          	lw	a0,0(s3)
    80002dbc:	00000097          	auipc	ra,0x0
    80002dc0:	8a4080e7          	jalr	-1884(ra) # 80002660 <bfree>
    80002dc4:	b7ed                	j	80002dae <itrunc+0x74>
    brelse(bp);
    80002dc6:	8552                	mv	a0,s4
    80002dc8:	fffff097          	auipc	ra,0xfffff
    80002dcc:	784080e7          	jalr	1924(ra) # 8000254c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dd0:	0809a583          	lw	a1,128(s3)
    80002dd4:	0009a503          	lw	a0,0(s3)
    80002dd8:	00000097          	auipc	ra,0x0
    80002ddc:	888080e7          	jalr	-1912(ra) # 80002660 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002de0:	0809a023          	sw	zero,128(s3)
    80002de4:	bf51                	j	80002d78 <itrunc+0x3e>

0000000080002de6 <iput>:
{
    80002de6:	1101                	add	sp,sp,-32
    80002de8:	ec06                	sd	ra,24(sp)
    80002dea:	e822                	sd	s0,16(sp)
    80002dec:	e426                	sd	s1,8(sp)
    80002dee:	e04a                	sd	s2,0(sp)
    80002df0:	1000                	add	s0,sp,32
    80002df2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002df4:	00014517          	auipc	a0,0x14
    80002df8:	3a450513          	add	a0,a0,932 # 80017198 <itable>
    80002dfc:	00003097          	auipc	ra,0x3
    80002e00:	3c2080e7          	jalr	962(ra) # 800061be <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e04:	4498                	lw	a4,8(s1)
    80002e06:	4785                	li	a5,1
    80002e08:	02f70363          	beq	a4,a5,80002e2e <iput+0x48>
  ip->ref--;
    80002e0c:	449c                	lw	a5,8(s1)
    80002e0e:	37fd                	addw	a5,a5,-1
    80002e10:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e12:	00014517          	auipc	a0,0x14
    80002e16:	38650513          	add	a0,a0,902 # 80017198 <itable>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	458080e7          	jalr	1112(ra) # 80006272 <release>
}
    80002e22:	60e2                	ld	ra,24(sp)
    80002e24:	6442                	ld	s0,16(sp)
    80002e26:	64a2                	ld	s1,8(sp)
    80002e28:	6902                	ld	s2,0(sp)
    80002e2a:	6105                	add	sp,sp,32
    80002e2c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e2e:	40bc                	lw	a5,64(s1)
    80002e30:	dff1                	beqz	a5,80002e0c <iput+0x26>
    80002e32:	04a49783          	lh	a5,74(s1)
    80002e36:	fbf9                	bnez	a5,80002e0c <iput+0x26>
    acquiresleep(&ip->lock);
    80002e38:	01048913          	add	s2,s1,16
    80002e3c:	854a                	mv	a0,s2
    80002e3e:	00001097          	auipc	ra,0x1
    80002e42:	a84080e7          	jalr	-1404(ra) # 800038c2 <acquiresleep>
    release(&itable.lock);
    80002e46:	00014517          	auipc	a0,0x14
    80002e4a:	35250513          	add	a0,a0,850 # 80017198 <itable>
    80002e4e:	00003097          	auipc	ra,0x3
    80002e52:	424080e7          	jalr	1060(ra) # 80006272 <release>
    itrunc(ip);
    80002e56:	8526                	mv	a0,s1
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	ee2080e7          	jalr	-286(ra) # 80002d3a <itrunc>
    ip->type = 0;
    80002e60:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e64:	8526                	mv	a0,s1
    80002e66:	00000097          	auipc	ra,0x0
    80002e6a:	cfa080e7          	jalr	-774(ra) # 80002b60 <iupdate>
    ip->valid = 0;
    80002e6e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e72:	854a                	mv	a0,s2
    80002e74:	00001097          	auipc	ra,0x1
    80002e78:	aa4080e7          	jalr	-1372(ra) # 80003918 <releasesleep>
    acquire(&itable.lock);
    80002e7c:	00014517          	auipc	a0,0x14
    80002e80:	31c50513          	add	a0,a0,796 # 80017198 <itable>
    80002e84:	00003097          	auipc	ra,0x3
    80002e88:	33a080e7          	jalr	826(ra) # 800061be <acquire>
    80002e8c:	b741                	j	80002e0c <iput+0x26>

0000000080002e8e <iunlockput>:
{
    80002e8e:	1101                	add	sp,sp,-32
    80002e90:	ec06                	sd	ra,24(sp)
    80002e92:	e822                	sd	s0,16(sp)
    80002e94:	e426                	sd	s1,8(sp)
    80002e96:	1000                	add	s0,sp,32
    80002e98:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e9a:	00000097          	auipc	ra,0x0
    80002e9e:	e54080e7          	jalr	-428(ra) # 80002cee <iunlock>
  iput(ip);
    80002ea2:	8526                	mv	a0,s1
    80002ea4:	00000097          	auipc	ra,0x0
    80002ea8:	f42080e7          	jalr	-190(ra) # 80002de6 <iput>
}
    80002eac:	60e2                	ld	ra,24(sp)
    80002eae:	6442                	ld	s0,16(sp)
    80002eb0:	64a2                	ld	s1,8(sp)
    80002eb2:	6105                	add	sp,sp,32
    80002eb4:	8082                	ret

0000000080002eb6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002eb6:	1141                	add	sp,sp,-16
    80002eb8:	e422                	sd	s0,8(sp)
    80002eba:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002ebc:	411c                	lw	a5,0(a0)
    80002ebe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ec0:	415c                	lw	a5,4(a0)
    80002ec2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ec4:	04451783          	lh	a5,68(a0)
    80002ec8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ecc:	04a51783          	lh	a5,74(a0)
    80002ed0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ed4:	04c56783          	lwu	a5,76(a0)
    80002ed8:	e99c                	sd	a5,16(a1)
}
    80002eda:	6422                	ld	s0,8(sp)
    80002edc:	0141                	add	sp,sp,16
    80002ede:	8082                	ret

0000000080002ee0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ee0:	457c                	lw	a5,76(a0)
    80002ee2:	0ed7e963          	bltu	a5,a3,80002fd4 <readi+0xf4>
{
    80002ee6:	7159                	add	sp,sp,-112
    80002ee8:	f486                	sd	ra,104(sp)
    80002eea:	f0a2                	sd	s0,96(sp)
    80002eec:	eca6                	sd	s1,88(sp)
    80002eee:	e8ca                	sd	s2,80(sp)
    80002ef0:	e4ce                	sd	s3,72(sp)
    80002ef2:	e0d2                	sd	s4,64(sp)
    80002ef4:	fc56                	sd	s5,56(sp)
    80002ef6:	f85a                	sd	s6,48(sp)
    80002ef8:	f45e                	sd	s7,40(sp)
    80002efa:	f062                	sd	s8,32(sp)
    80002efc:	ec66                	sd	s9,24(sp)
    80002efe:	e86a                	sd	s10,16(sp)
    80002f00:	e46e                	sd	s11,8(sp)
    80002f02:	1880                	add	s0,sp,112
    80002f04:	8b2a                	mv	s6,a0
    80002f06:	8bae                	mv	s7,a1
    80002f08:	8a32                	mv	s4,a2
    80002f0a:	84b6                	mv	s1,a3
    80002f0c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f0e:	9f35                	addw	a4,a4,a3
    return 0;
    80002f10:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f12:	0ad76063          	bltu	a4,a3,80002fb2 <readi+0xd2>
  if(off + n > ip->size)
    80002f16:	00e7f463          	bgeu	a5,a4,80002f1e <readi+0x3e>
    n = ip->size - off;
    80002f1a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f1e:	0a0a8963          	beqz	s5,80002fd0 <readi+0xf0>
    80002f22:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f24:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f28:	5c7d                	li	s8,-1
    80002f2a:	a82d                	j	80002f64 <readi+0x84>
    80002f2c:	020d1d93          	sll	s11,s10,0x20
    80002f30:	020ddd93          	srl	s11,s11,0x20
    80002f34:	05890613          	add	a2,s2,88
    80002f38:	86ee                	mv	a3,s11
    80002f3a:	963a                	add	a2,a2,a4
    80002f3c:	85d2                	mv	a1,s4
    80002f3e:	855e                	mv	a0,s7
    80002f40:	fffff097          	auipc	ra,0xfffff
    80002f44:	a18080e7          	jalr	-1512(ra) # 80001958 <either_copyout>
    80002f48:	05850d63          	beq	a0,s8,80002fa2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f4c:	854a                	mv	a0,s2
    80002f4e:	fffff097          	auipc	ra,0xfffff
    80002f52:	5fe080e7          	jalr	1534(ra) # 8000254c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f56:	013d09bb          	addw	s3,s10,s3
    80002f5a:	009d04bb          	addw	s1,s10,s1
    80002f5e:	9a6e                	add	s4,s4,s11
    80002f60:	0559f763          	bgeu	s3,s5,80002fae <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f64:	00a4d59b          	srlw	a1,s1,0xa
    80002f68:	855a                	mv	a0,s6
    80002f6a:	00000097          	auipc	ra,0x0
    80002f6e:	8a4080e7          	jalr	-1884(ra) # 8000280e <bmap>
    80002f72:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f76:	cd85                	beqz	a1,80002fae <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f78:	000b2503          	lw	a0,0(s6)
    80002f7c:	fffff097          	auipc	ra,0xfffff
    80002f80:	4a0080e7          	jalr	1184(ra) # 8000241c <bread>
    80002f84:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f86:	3ff4f713          	and	a4,s1,1023
    80002f8a:	40ec87bb          	subw	a5,s9,a4
    80002f8e:	413a86bb          	subw	a3,s5,s3
    80002f92:	8d3e                	mv	s10,a5
    80002f94:	2781                	sext.w	a5,a5
    80002f96:	0006861b          	sext.w	a2,a3
    80002f9a:	f8f679e3          	bgeu	a2,a5,80002f2c <readi+0x4c>
    80002f9e:	8d36                	mv	s10,a3
    80002fa0:	b771                	j	80002f2c <readi+0x4c>
      brelse(bp);
    80002fa2:	854a                	mv	a0,s2
    80002fa4:	fffff097          	auipc	ra,0xfffff
    80002fa8:	5a8080e7          	jalr	1448(ra) # 8000254c <brelse>
      tot = -1;
    80002fac:	59fd                	li	s3,-1
  }
  return tot;
    80002fae:	0009851b          	sext.w	a0,s3
}
    80002fb2:	70a6                	ld	ra,104(sp)
    80002fb4:	7406                	ld	s0,96(sp)
    80002fb6:	64e6                	ld	s1,88(sp)
    80002fb8:	6946                	ld	s2,80(sp)
    80002fba:	69a6                	ld	s3,72(sp)
    80002fbc:	6a06                	ld	s4,64(sp)
    80002fbe:	7ae2                	ld	s5,56(sp)
    80002fc0:	7b42                	ld	s6,48(sp)
    80002fc2:	7ba2                	ld	s7,40(sp)
    80002fc4:	7c02                	ld	s8,32(sp)
    80002fc6:	6ce2                	ld	s9,24(sp)
    80002fc8:	6d42                	ld	s10,16(sp)
    80002fca:	6da2                	ld	s11,8(sp)
    80002fcc:	6165                	add	sp,sp,112
    80002fce:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fd0:	89d6                	mv	s3,s5
    80002fd2:	bff1                	j	80002fae <readi+0xce>
    return 0;
    80002fd4:	4501                	li	a0,0
}
    80002fd6:	8082                	ret

0000000080002fd8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fd8:	457c                	lw	a5,76(a0)
    80002fda:	10d7e863          	bltu	a5,a3,800030ea <writei+0x112>
{
    80002fde:	7159                	add	sp,sp,-112
    80002fe0:	f486                	sd	ra,104(sp)
    80002fe2:	f0a2                	sd	s0,96(sp)
    80002fe4:	eca6                	sd	s1,88(sp)
    80002fe6:	e8ca                	sd	s2,80(sp)
    80002fe8:	e4ce                	sd	s3,72(sp)
    80002fea:	e0d2                	sd	s4,64(sp)
    80002fec:	fc56                	sd	s5,56(sp)
    80002fee:	f85a                	sd	s6,48(sp)
    80002ff0:	f45e                	sd	s7,40(sp)
    80002ff2:	f062                	sd	s8,32(sp)
    80002ff4:	ec66                	sd	s9,24(sp)
    80002ff6:	e86a                	sd	s10,16(sp)
    80002ff8:	e46e                	sd	s11,8(sp)
    80002ffa:	1880                	add	s0,sp,112
    80002ffc:	8aaa                	mv	s5,a0
    80002ffe:	8bae                	mv	s7,a1
    80003000:	8a32                	mv	s4,a2
    80003002:	8936                	mv	s2,a3
    80003004:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003006:	00e687bb          	addw	a5,a3,a4
    8000300a:	0ed7e263          	bltu	a5,a3,800030ee <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000300e:	00043737          	lui	a4,0x43
    80003012:	0ef76063          	bltu	a4,a5,800030f2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003016:	0c0b0863          	beqz	s6,800030e6 <writei+0x10e>
    8000301a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000301c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003020:	5c7d                	li	s8,-1
    80003022:	a091                	j	80003066 <writei+0x8e>
    80003024:	020d1d93          	sll	s11,s10,0x20
    80003028:	020ddd93          	srl	s11,s11,0x20
    8000302c:	05848513          	add	a0,s1,88
    80003030:	86ee                	mv	a3,s11
    80003032:	8652                	mv	a2,s4
    80003034:	85de                	mv	a1,s7
    80003036:	953a                	add	a0,a0,a4
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	976080e7          	jalr	-1674(ra) # 800019ae <either_copyin>
    80003040:	07850263          	beq	a0,s8,800030a4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003044:	8526                	mv	a0,s1
    80003046:	00000097          	auipc	ra,0x0
    8000304a:	75e080e7          	jalr	1886(ra) # 800037a4 <log_write>
    brelse(bp);
    8000304e:	8526                	mv	a0,s1
    80003050:	fffff097          	auipc	ra,0xfffff
    80003054:	4fc080e7          	jalr	1276(ra) # 8000254c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003058:	013d09bb          	addw	s3,s10,s3
    8000305c:	012d093b          	addw	s2,s10,s2
    80003060:	9a6e                	add	s4,s4,s11
    80003062:	0569f663          	bgeu	s3,s6,800030ae <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003066:	00a9559b          	srlw	a1,s2,0xa
    8000306a:	8556                	mv	a0,s5
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	7a2080e7          	jalr	1954(ra) # 8000280e <bmap>
    80003074:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003078:	c99d                	beqz	a1,800030ae <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000307a:	000aa503          	lw	a0,0(s5)
    8000307e:	fffff097          	auipc	ra,0xfffff
    80003082:	39e080e7          	jalr	926(ra) # 8000241c <bread>
    80003086:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003088:	3ff97713          	and	a4,s2,1023
    8000308c:	40ec87bb          	subw	a5,s9,a4
    80003090:	413b06bb          	subw	a3,s6,s3
    80003094:	8d3e                	mv	s10,a5
    80003096:	2781                	sext.w	a5,a5
    80003098:	0006861b          	sext.w	a2,a3
    8000309c:	f8f674e3          	bgeu	a2,a5,80003024 <writei+0x4c>
    800030a0:	8d36                	mv	s10,a3
    800030a2:	b749                	j	80003024 <writei+0x4c>
      brelse(bp);
    800030a4:	8526                	mv	a0,s1
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	4a6080e7          	jalr	1190(ra) # 8000254c <brelse>
  }

  if(off > ip->size)
    800030ae:	04caa783          	lw	a5,76(s5)
    800030b2:	0127f463          	bgeu	a5,s2,800030ba <writei+0xe2>
    ip->size = off;
    800030b6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030ba:	8556                	mv	a0,s5
    800030bc:	00000097          	auipc	ra,0x0
    800030c0:	aa4080e7          	jalr	-1372(ra) # 80002b60 <iupdate>

  return tot;
    800030c4:	0009851b          	sext.w	a0,s3
}
    800030c8:	70a6                	ld	ra,104(sp)
    800030ca:	7406                	ld	s0,96(sp)
    800030cc:	64e6                	ld	s1,88(sp)
    800030ce:	6946                	ld	s2,80(sp)
    800030d0:	69a6                	ld	s3,72(sp)
    800030d2:	6a06                	ld	s4,64(sp)
    800030d4:	7ae2                	ld	s5,56(sp)
    800030d6:	7b42                	ld	s6,48(sp)
    800030d8:	7ba2                	ld	s7,40(sp)
    800030da:	7c02                	ld	s8,32(sp)
    800030dc:	6ce2                	ld	s9,24(sp)
    800030de:	6d42                	ld	s10,16(sp)
    800030e0:	6da2                	ld	s11,8(sp)
    800030e2:	6165                	add	sp,sp,112
    800030e4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030e6:	89da                	mv	s3,s6
    800030e8:	bfc9                	j	800030ba <writei+0xe2>
    return -1;
    800030ea:	557d                	li	a0,-1
}
    800030ec:	8082                	ret
    return -1;
    800030ee:	557d                	li	a0,-1
    800030f0:	bfe1                	j	800030c8 <writei+0xf0>
    return -1;
    800030f2:	557d                	li	a0,-1
    800030f4:	bfd1                	j	800030c8 <writei+0xf0>

00000000800030f6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030f6:	1141                	add	sp,sp,-16
    800030f8:	e406                	sd	ra,8(sp)
    800030fa:	e022                	sd	s0,0(sp)
    800030fc:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030fe:	4639                	li	a2,14
    80003100:	ffffd097          	auipc	ra,0xffffd
    80003104:	194080e7          	jalr	404(ra) # 80000294 <strncmp>
}
    80003108:	60a2                	ld	ra,8(sp)
    8000310a:	6402                	ld	s0,0(sp)
    8000310c:	0141                	add	sp,sp,16
    8000310e:	8082                	ret

0000000080003110 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003110:	7139                	add	sp,sp,-64
    80003112:	fc06                	sd	ra,56(sp)
    80003114:	f822                	sd	s0,48(sp)
    80003116:	f426                	sd	s1,40(sp)
    80003118:	f04a                	sd	s2,32(sp)
    8000311a:	ec4e                	sd	s3,24(sp)
    8000311c:	e852                	sd	s4,16(sp)
    8000311e:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003120:	04451703          	lh	a4,68(a0)
    80003124:	4785                	li	a5,1
    80003126:	00f71a63          	bne	a4,a5,8000313a <dirlookup+0x2a>
    8000312a:	892a                	mv	s2,a0
    8000312c:	89ae                	mv	s3,a1
    8000312e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003130:	457c                	lw	a5,76(a0)
    80003132:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003134:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003136:	e79d                	bnez	a5,80003164 <dirlookup+0x54>
    80003138:	a8a5                	j	800031b0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000313a:	00005517          	auipc	a0,0x5
    8000313e:	5ce50513          	add	a0,a0,1486 # 80008708 <syscall_names+0x1b0>
    80003142:	00003097          	auipc	ra,0x3
    80003146:	b44080e7          	jalr	-1212(ra) # 80005c86 <panic>
      panic("dirlookup read");
    8000314a:	00005517          	auipc	a0,0x5
    8000314e:	5d650513          	add	a0,a0,1494 # 80008720 <syscall_names+0x1c8>
    80003152:	00003097          	auipc	ra,0x3
    80003156:	b34080e7          	jalr	-1228(ra) # 80005c86 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000315a:	24c1                	addw	s1,s1,16
    8000315c:	04c92783          	lw	a5,76(s2)
    80003160:	04f4f763          	bgeu	s1,a5,800031ae <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003164:	4741                	li	a4,16
    80003166:	86a6                	mv	a3,s1
    80003168:	fc040613          	add	a2,s0,-64
    8000316c:	4581                	li	a1,0
    8000316e:	854a                	mv	a0,s2
    80003170:	00000097          	auipc	ra,0x0
    80003174:	d70080e7          	jalr	-656(ra) # 80002ee0 <readi>
    80003178:	47c1                	li	a5,16
    8000317a:	fcf518e3          	bne	a0,a5,8000314a <dirlookup+0x3a>
    if(de.inum == 0)
    8000317e:	fc045783          	lhu	a5,-64(s0)
    80003182:	dfe1                	beqz	a5,8000315a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003184:	fc240593          	add	a1,s0,-62
    80003188:	854e                	mv	a0,s3
    8000318a:	00000097          	auipc	ra,0x0
    8000318e:	f6c080e7          	jalr	-148(ra) # 800030f6 <namecmp>
    80003192:	f561                	bnez	a0,8000315a <dirlookup+0x4a>
      if(poff)
    80003194:	000a0463          	beqz	s4,8000319c <dirlookup+0x8c>
        *poff = off;
    80003198:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000319c:	fc045583          	lhu	a1,-64(s0)
    800031a0:	00092503          	lw	a0,0(s2)
    800031a4:	fffff097          	auipc	ra,0xfffff
    800031a8:	754080e7          	jalr	1876(ra) # 800028f8 <iget>
    800031ac:	a011                	j	800031b0 <dirlookup+0xa0>
  return 0;
    800031ae:	4501                	li	a0,0
}
    800031b0:	70e2                	ld	ra,56(sp)
    800031b2:	7442                	ld	s0,48(sp)
    800031b4:	74a2                	ld	s1,40(sp)
    800031b6:	7902                	ld	s2,32(sp)
    800031b8:	69e2                	ld	s3,24(sp)
    800031ba:	6a42                	ld	s4,16(sp)
    800031bc:	6121                	add	sp,sp,64
    800031be:	8082                	ret

00000000800031c0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031c0:	711d                	add	sp,sp,-96
    800031c2:	ec86                	sd	ra,88(sp)
    800031c4:	e8a2                	sd	s0,80(sp)
    800031c6:	e4a6                	sd	s1,72(sp)
    800031c8:	e0ca                	sd	s2,64(sp)
    800031ca:	fc4e                	sd	s3,56(sp)
    800031cc:	f852                	sd	s4,48(sp)
    800031ce:	f456                	sd	s5,40(sp)
    800031d0:	f05a                	sd	s6,32(sp)
    800031d2:	ec5e                	sd	s7,24(sp)
    800031d4:	e862                	sd	s8,16(sp)
    800031d6:	e466                	sd	s9,8(sp)
    800031d8:	1080                	add	s0,sp,96
    800031da:	84aa                	mv	s1,a0
    800031dc:	8b2e                	mv	s6,a1
    800031de:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031e0:	00054703          	lbu	a4,0(a0)
    800031e4:	02f00793          	li	a5,47
    800031e8:	02f70263          	beq	a4,a5,8000320c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031ec:	ffffe097          	auipc	ra,0xffffe
    800031f0:	cb0080e7          	jalr	-848(ra) # 80000e9c <myproc>
    800031f4:	15053503          	ld	a0,336(a0)
    800031f8:	00000097          	auipc	ra,0x0
    800031fc:	9f6080e7          	jalr	-1546(ra) # 80002bee <idup>
    80003200:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003202:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003206:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003208:	4b85                	li	s7,1
    8000320a:	a875                	j	800032c6 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000320c:	4585                	li	a1,1
    8000320e:	4505                	li	a0,1
    80003210:	fffff097          	auipc	ra,0xfffff
    80003214:	6e8080e7          	jalr	1768(ra) # 800028f8 <iget>
    80003218:	8a2a                	mv	s4,a0
    8000321a:	b7e5                	j	80003202 <namex+0x42>
      iunlockput(ip);
    8000321c:	8552                	mv	a0,s4
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	c70080e7          	jalr	-912(ra) # 80002e8e <iunlockput>
      return 0;
    80003226:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003228:	8552                	mv	a0,s4
    8000322a:	60e6                	ld	ra,88(sp)
    8000322c:	6446                	ld	s0,80(sp)
    8000322e:	64a6                	ld	s1,72(sp)
    80003230:	6906                	ld	s2,64(sp)
    80003232:	79e2                	ld	s3,56(sp)
    80003234:	7a42                	ld	s4,48(sp)
    80003236:	7aa2                	ld	s5,40(sp)
    80003238:	7b02                	ld	s6,32(sp)
    8000323a:	6be2                	ld	s7,24(sp)
    8000323c:	6c42                	ld	s8,16(sp)
    8000323e:	6ca2                	ld	s9,8(sp)
    80003240:	6125                	add	sp,sp,96
    80003242:	8082                	ret
      iunlock(ip);
    80003244:	8552                	mv	a0,s4
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	aa8080e7          	jalr	-1368(ra) # 80002cee <iunlock>
      return ip;
    8000324e:	bfe9                	j	80003228 <namex+0x68>
      iunlockput(ip);
    80003250:	8552                	mv	a0,s4
    80003252:	00000097          	auipc	ra,0x0
    80003256:	c3c080e7          	jalr	-964(ra) # 80002e8e <iunlockput>
      return 0;
    8000325a:	8a4e                	mv	s4,s3
    8000325c:	b7f1                	j	80003228 <namex+0x68>
  len = path - s;
    8000325e:	40998633          	sub	a2,s3,s1
    80003262:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003266:	099c5863          	bge	s8,s9,800032f6 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000326a:	4639                	li	a2,14
    8000326c:	85a6                	mv	a1,s1
    8000326e:	8556                	mv	a0,s5
    80003270:	ffffd097          	auipc	ra,0xffffd
    80003274:	fb0080e7          	jalr	-80(ra) # 80000220 <memmove>
    80003278:	84ce                	mv	s1,s3
  while(*path == '/')
    8000327a:	0004c783          	lbu	a5,0(s1)
    8000327e:	01279763          	bne	a5,s2,8000328c <namex+0xcc>
    path++;
    80003282:	0485                	add	s1,s1,1
  while(*path == '/')
    80003284:	0004c783          	lbu	a5,0(s1)
    80003288:	ff278de3          	beq	a5,s2,80003282 <namex+0xc2>
    ilock(ip);
    8000328c:	8552                	mv	a0,s4
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	99e080e7          	jalr	-1634(ra) # 80002c2c <ilock>
    if(ip->type != T_DIR){
    80003296:	044a1783          	lh	a5,68(s4)
    8000329a:	f97791e3          	bne	a5,s7,8000321c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000329e:	000b0563          	beqz	s6,800032a8 <namex+0xe8>
    800032a2:	0004c783          	lbu	a5,0(s1)
    800032a6:	dfd9                	beqz	a5,80003244 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032a8:	4601                	li	a2,0
    800032aa:	85d6                	mv	a1,s5
    800032ac:	8552                	mv	a0,s4
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	e62080e7          	jalr	-414(ra) # 80003110 <dirlookup>
    800032b6:	89aa                	mv	s3,a0
    800032b8:	dd41                	beqz	a0,80003250 <namex+0x90>
    iunlockput(ip);
    800032ba:	8552                	mv	a0,s4
    800032bc:	00000097          	auipc	ra,0x0
    800032c0:	bd2080e7          	jalr	-1070(ra) # 80002e8e <iunlockput>
    ip = next;
    800032c4:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032c6:	0004c783          	lbu	a5,0(s1)
    800032ca:	01279763          	bne	a5,s2,800032d8 <namex+0x118>
    path++;
    800032ce:	0485                	add	s1,s1,1
  while(*path == '/')
    800032d0:	0004c783          	lbu	a5,0(s1)
    800032d4:	ff278de3          	beq	a5,s2,800032ce <namex+0x10e>
  if(*path == 0)
    800032d8:	cb9d                	beqz	a5,8000330e <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032da:	0004c783          	lbu	a5,0(s1)
    800032de:	89a6                	mv	s3,s1
  len = path - s;
    800032e0:	4c81                	li	s9,0
    800032e2:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032e4:	01278963          	beq	a5,s2,800032f6 <namex+0x136>
    800032e8:	dbbd                	beqz	a5,8000325e <namex+0x9e>
    path++;
    800032ea:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    800032ec:	0009c783          	lbu	a5,0(s3)
    800032f0:	ff279ce3          	bne	a5,s2,800032e8 <namex+0x128>
    800032f4:	b7ad                	j	8000325e <namex+0x9e>
    memmove(name, s, len);
    800032f6:	2601                	sext.w	a2,a2
    800032f8:	85a6                	mv	a1,s1
    800032fa:	8556                	mv	a0,s5
    800032fc:	ffffd097          	auipc	ra,0xffffd
    80003300:	f24080e7          	jalr	-220(ra) # 80000220 <memmove>
    name[len] = 0;
    80003304:	9cd6                	add	s9,s9,s5
    80003306:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000330a:	84ce                	mv	s1,s3
    8000330c:	b7bd                	j	8000327a <namex+0xba>
  if(nameiparent){
    8000330e:	f00b0de3          	beqz	s6,80003228 <namex+0x68>
    iput(ip);
    80003312:	8552                	mv	a0,s4
    80003314:	00000097          	auipc	ra,0x0
    80003318:	ad2080e7          	jalr	-1326(ra) # 80002de6 <iput>
    return 0;
    8000331c:	4a01                	li	s4,0
    8000331e:	b729                	j	80003228 <namex+0x68>

0000000080003320 <dirlink>:
{
    80003320:	7139                	add	sp,sp,-64
    80003322:	fc06                	sd	ra,56(sp)
    80003324:	f822                	sd	s0,48(sp)
    80003326:	f426                	sd	s1,40(sp)
    80003328:	f04a                	sd	s2,32(sp)
    8000332a:	ec4e                	sd	s3,24(sp)
    8000332c:	e852                	sd	s4,16(sp)
    8000332e:	0080                	add	s0,sp,64
    80003330:	892a                	mv	s2,a0
    80003332:	8a2e                	mv	s4,a1
    80003334:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003336:	4601                	li	a2,0
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	dd8080e7          	jalr	-552(ra) # 80003110 <dirlookup>
    80003340:	e93d                	bnez	a0,800033b6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003342:	04c92483          	lw	s1,76(s2)
    80003346:	c49d                	beqz	s1,80003374 <dirlink+0x54>
    80003348:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000334a:	4741                	li	a4,16
    8000334c:	86a6                	mv	a3,s1
    8000334e:	fc040613          	add	a2,s0,-64
    80003352:	4581                	li	a1,0
    80003354:	854a                	mv	a0,s2
    80003356:	00000097          	auipc	ra,0x0
    8000335a:	b8a080e7          	jalr	-1142(ra) # 80002ee0 <readi>
    8000335e:	47c1                	li	a5,16
    80003360:	06f51163          	bne	a0,a5,800033c2 <dirlink+0xa2>
    if(de.inum == 0)
    80003364:	fc045783          	lhu	a5,-64(s0)
    80003368:	c791                	beqz	a5,80003374 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000336a:	24c1                	addw	s1,s1,16
    8000336c:	04c92783          	lw	a5,76(s2)
    80003370:	fcf4ede3          	bltu	s1,a5,8000334a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003374:	4639                	li	a2,14
    80003376:	85d2                	mv	a1,s4
    80003378:	fc240513          	add	a0,s0,-62
    8000337c:	ffffd097          	auipc	ra,0xffffd
    80003380:	f54080e7          	jalr	-172(ra) # 800002d0 <strncpy>
  de.inum = inum;
    80003384:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003388:	4741                	li	a4,16
    8000338a:	86a6                	mv	a3,s1
    8000338c:	fc040613          	add	a2,s0,-64
    80003390:	4581                	li	a1,0
    80003392:	854a                	mv	a0,s2
    80003394:	00000097          	auipc	ra,0x0
    80003398:	c44080e7          	jalr	-956(ra) # 80002fd8 <writei>
    8000339c:	1541                	add	a0,a0,-16
    8000339e:	00a03533          	snez	a0,a0
    800033a2:	40a00533          	neg	a0,a0
}
    800033a6:	70e2                	ld	ra,56(sp)
    800033a8:	7442                	ld	s0,48(sp)
    800033aa:	74a2                	ld	s1,40(sp)
    800033ac:	7902                	ld	s2,32(sp)
    800033ae:	69e2                	ld	s3,24(sp)
    800033b0:	6a42                	ld	s4,16(sp)
    800033b2:	6121                	add	sp,sp,64
    800033b4:	8082                	ret
    iput(ip);
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	a30080e7          	jalr	-1488(ra) # 80002de6 <iput>
    return -1;
    800033be:	557d                	li	a0,-1
    800033c0:	b7dd                	j	800033a6 <dirlink+0x86>
      panic("dirlink read");
    800033c2:	00005517          	auipc	a0,0x5
    800033c6:	36e50513          	add	a0,a0,878 # 80008730 <syscall_names+0x1d8>
    800033ca:	00003097          	auipc	ra,0x3
    800033ce:	8bc080e7          	jalr	-1860(ra) # 80005c86 <panic>

00000000800033d2 <namei>:

struct inode*
namei(char *path)
{
    800033d2:	1101                	add	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033da:	fe040613          	add	a2,s0,-32
    800033de:	4581                	li	a1,0
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	de0080e7          	jalr	-544(ra) # 800031c0 <namex>
}
    800033e8:	60e2                	ld	ra,24(sp)
    800033ea:	6442                	ld	s0,16(sp)
    800033ec:	6105                	add	sp,sp,32
    800033ee:	8082                	ret

00000000800033f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033f0:	1141                	add	sp,sp,-16
    800033f2:	e406                	sd	ra,8(sp)
    800033f4:	e022                	sd	s0,0(sp)
    800033f6:	0800                	add	s0,sp,16
    800033f8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033fa:	4585                	li	a1,1
    800033fc:	00000097          	auipc	ra,0x0
    80003400:	dc4080e7          	jalr	-572(ra) # 800031c0 <namex>
}
    80003404:	60a2                	ld	ra,8(sp)
    80003406:	6402                	ld	s0,0(sp)
    80003408:	0141                	add	sp,sp,16
    8000340a:	8082                	ret

000000008000340c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000340c:	1101                	add	sp,sp,-32
    8000340e:	ec06                	sd	ra,24(sp)
    80003410:	e822                	sd	s0,16(sp)
    80003412:	e426                	sd	s1,8(sp)
    80003414:	e04a                	sd	s2,0(sp)
    80003416:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003418:	00016917          	auipc	s2,0x16
    8000341c:	82890913          	add	s2,s2,-2008 # 80018c40 <log>
    80003420:	01892583          	lw	a1,24(s2)
    80003424:	02892503          	lw	a0,40(s2)
    80003428:	fffff097          	auipc	ra,0xfffff
    8000342c:	ff4080e7          	jalr	-12(ra) # 8000241c <bread>
    80003430:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003432:	02c92603          	lw	a2,44(s2)
    80003436:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003438:	00c05f63          	blez	a2,80003456 <write_head+0x4a>
    8000343c:	00016717          	auipc	a4,0x16
    80003440:	83470713          	add	a4,a4,-1996 # 80018c70 <log+0x30>
    80003444:	87aa                	mv	a5,a0
    80003446:	060a                	sll	a2,a2,0x2
    80003448:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000344a:	4314                	lw	a3,0(a4)
    8000344c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000344e:	0711                	add	a4,a4,4
    80003450:	0791                	add	a5,a5,4
    80003452:	fec79ce3          	bne	a5,a2,8000344a <write_head+0x3e>
  }
  bwrite(buf);
    80003456:	8526                	mv	a0,s1
    80003458:	fffff097          	auipc	ra,0xfffff
    8000345c:	0b6080e7          	jalr	182(ra) # 8000250e <bwrite>
  brelse(buf);
    80003460:	8526                	mv	a0,s1
    80003462:	fffff097          	auipc	ra,0xfffff
    80003466:	0ea080e7          	jalr	234(ra) # 8000254c <brelse>
}
    8000346a:	60e2                	ld	ra,24(sp)
    8000346c:	6442                	ld	s0,16(sp)
    8000346e:	64a2                	ld	s1,8(sp)
    80003470:	6902                	ld	s2,0(sp)
    80003472:	6105                	add	sp,sp,32
    80003474:	8082                	ret

0000000080003476 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003476:	00015797          	auipc	a5,0x15
    8000347a:	7f67a783          	lw	a5,2038(a5) # 80018c6c <log+0x2c>
    8000347e:	0af05d63          	blez	a5,80003538 <install_trans+0xc2>
{
    80003482:	7139                	add	sp,sp,-64
    80003484:	fc06                	sd	ra,56(sp)
    80003486:	f822                	sd	s0,48(sp)
    80003488:	f426                	sd	s1,40(sp)
    8000348a:	f04a                	sd	s2,32(sp)
    8000348c:	ec4e                	sd	s3,24(sp)
    8000348e:	e852                	sd	s4,16(sp)
    80003490:	e456                	sd	s5,8(sp)
    80003492:	e05a                	sd	s6,0(sp)
    80003494:	0080                	add	s0,sp,64
    80003496:	8b2a                	mv	s6,a0
    80003498:	00015a97          	auipc	s5,0x15
    8000349c:	7d8a8a93          	add	s5,s5,2008 # 80018c70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a2:	00015997          	auipc	s3,0x15
    800034a6:	79e98993          	add	s3,s3,1950 # 80018c40 <log>
    800034aa:	a00d                	j	800034cc <install_trans+0x56>
    brelse(lbuf);
    800034ac:	854a                	mv	a0,s2
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	09e080e7          	jalr	158(ra) # 8000254c <brelse>
    brelse(dbuf);
    800034b6:	8526                	mv	a0,s1
    800034b8:	fffff097          	auipc	ra,0xfffff
    800034bc:	094080e7          	jalr	148(ra) # 8000254c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c0:	2a05                	addw	s4,s4,1
    800034c2:	0a91                	add	s5,s5,4
    800034c4:	02c9a783          	lw	a5,44(s3)
    800034c8:	04fa5e63          	bge	s4,a5,80003524 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034cc:	0189a583          	lw	a1,24(s3)
    800034d0:	014585bb          	addw	a1,a1,s4
    800034d4:	2585                	addw	a1,a1,1
    800034d6:	0289a503          	lw	a0,40(s3)
    800034da:	fffff097          	auipc	ra,0xfffff
    800034de:	f42080e7          	jalr	-190(ra) # 8000241c <bread>
    800034e2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034e4:	000aa583          	lw	a1,0(s5)
    800034e8:	0289a503          	lw	a0,40(s3)
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	f30080e7          	jalr	-208(ra) # 8000241c <bread>
    800034f4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034f6:	40000613          	li	a2,1024
    800034fa:	05890593          	add	a1,s2,88
    800034fe:	05850513          	add	a0,a0,88
    80003502:	ffffd097          	auipc	ra,0xffffd
    80003506:	d1e080e7          	jalr	-738(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000350a:	8526                	mv	a0,s1
    8000350c:	fffff097          	auipc	ra,0xfffff
    80003510:	002080e7          	jalr	2(ra) # 8000250e <bwrite>
    if(recovering == 0)
    80003514:	f80b1ce3          	bnez	s6,800034ac <install_trans+0x36>
      bunpin(dbuf);
    80003518:	8526                	mv	a0,s1
    8000351a:	fffff097          	auipc	ra,0xfffff
    8000351e:	10a080e7          	jalr	266(ra) # 80002624 <bunpin>
    80003522:	b769                	j	800034ac <install_trans+0x36>
}
    80003524:	70e2                	ld	ra,56(sp)
    80003526:	7442                	ld	s0,48(sp)
    80003528:	74a2                	ld	s1,40(sp)
    8000352a:	7902                	ld	s2,32(sp)
    8000352c:	69e2                	ld	s3,24(sp)
    8000352e:	6a42                	ld	s4,16(sp)
    80003530:	6aa2                	ld	s5,8(sp)
    80003532:	6b02                	ld	s6,0(sp)
    80003534:	6121                	add	sp,sp,64
    80003536:	8082                	ret
    80003538:	8082                	ret

000000008000353a <initlog>:
{
    8000353a:	7179                	add	sp,sp,-48
    8000353c:	f406                	sd	ra,40(sp)
    8000353e:	f022                	sd	s0,32(sp)
    80003540:	ec26                	sd	s1,24(sp)
    80003542:	e84a                	sd	s2,16(sp)
    80003544:	e44e                	sd	s3,8(sp)
    80003546:	1800                	add	s0,sp,48
    80003548:	892a                	mv	s2,a0
    8000354a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000354c:	00015497          	auipc	s1,0x15
    80003550:	6f448493          	add	s1,s1,1780 # 80018c40 <log>
    80003554:	00005597          	auipc	a1,0x5
    80003558:	1ec58593          	add	a1,a1,492 # 80008740 <syscall_names+0x1e8>
    8000355c:	8526                	mv	a0,s1
    8000355e:	00003097          	auipc	ra,0x3
    80003562:	bd0080e7          	jalr	-1072(ra) # 8000612e <initlock>
  log.start = sb->logstart;
    80003566:	0149a583          	lw	a1,20(s3)
    8000356a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000356c:	0109a783          	lw	a5,16(s3)
    80003570:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003572:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003576:	854a                	mv	a0,s2
    80003578:	fffff097          	auipc	ra,0xfffff
    8000357c:	ea4080e7          	jalr	-348(ra) # 8000241c <bread>
  log.lh.n = lh->n;
    80003580:	4d30                	lw	a2,88(a0)
    80003582:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003584:	00c05f63          	blez	a2,800035a2 <initlog+0x68>
    80003588:	87aa                	mv	a5,a0
    8000358a:	00015717          	auipc	a4,0x15
    8000358e:	6e670713          	add	a4,a4,1766 # 80018c70 <log+0x30>
    80003592:	060a                	sll	a2,a2,0x2
    80003594:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003596:	4ff4                	lw	a3,92(a5)
    80003598:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000359a:	0791                	add	a5,a5,4
    8000359c:	0711                	add	a4,a4,4
    8000359e:	fec79ce3          	bne	a5,a2,80003596 <initlog+0x5c>
  brelse(buf);
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	faa080e7          	jalr	-86(ra) # 8000254c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035aa:	4505                	li	a0,1
    800035ac:	00000097          	auipc	ra,0x0
    800035b0:	eca080e7          	jalr	-310(ra) # 80003476 <install_trans>
  log.lh.n = 0;
    800035b4:	00015797          	auipc	a5,0x15
    800035b8:	6a07ac23          	sw	zero,1720(a5) # 80018c6c <log+0x2c>
  write_head(); // clear the log
    800035bc:	00000097          	auipc	ra,0x0
    800035c0:	e50080e7          	jalr	-432(ra) # 8000340c <write_head>
}
    800035c4:	70a2                	ld	ra,40(sp)
    800035c6:	7402                	ld	s0,32(sp)
    800035c8:	64e2                	ld	s1,24(sp)
    800035ca:	6942                	ld	s2,16(sp)
    800035cc:	69a2                	ld	s3,8(sp)
    800035ce:	6145                	add	sp,sp,48
    800035d0:	8082                	ret

00000000800035d2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035d2:	1101                	add	sp,sp,-32
    800035d4:	ec06                	sd	ra,24(sp)
    800035d6:	e822                	sd	s0,16(sp)
    800035d8:	e426                	sd	s1,8(sp)
    800035da:	e04a                	sd	s2,0(sp)
    800035dc:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800035de:	00015517          	auipc	a0,0x15
    800035e2:	66250513          	add	a0,a0,1634 # 80018c40 <log>
    800035e6:	00003097          	auipc	ra,0x3
    800035ea:	bd8080e7          	jalr	-1064(ra) # 800061be <acquire>
  while(1){
    if(log.committing){
    800035ee:	00015497          	auipc	s1,0x15
    800035f2:	65248493          	add	s1,s1,1618 # 80018c40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035f6:	4979                	li	s2,30
    800035f8:	a039                	j	80003606 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035fa:	85a6                	mv	a1,s1
    800035fc:	8526                	mv	a0,s1
    800035fe:	ffffe097          	auipc	ra,0xffffe
    80003602:	f52080e7          	jalr	-174(ra) # 80001550 <sleep>
    if(log.committing){
    80003606:	50dc                	lw	a5,36(s1)
    80003608:	fbed                	bnez	a5,800035fa <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000360a:	5098                	lw	a4,32(s1)
    8000360c:	2705                	addw	a4,a4,1
    8000360e:	0027179b          	sllw	a5,a4,0x2
    80003612:	9fb9                	addw	a5,a5,a4
    80003614:	0017979b          	sllw	a5,a5,0x1
    80003618:	54d4                	lw	a3,44(s1)
    8000361a:	9fb5                	addw	a5,a5,a3
    8000361c:	00f95963          	bge	s2,a5,8000362e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003620:	85a6                	mv	a1,s1
    80003622:	8526                	mv	a0,s1
    80003624:	ffffe097          	auipc	ra,0xffffe
    80003628:	f2c080e7          	jalr	-212(ra) # 80001550 <sleep>
    8000362c:	bfe9                	j	80003606 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000362e:	00015517          	auipc	a0,0x15
    80003632:	61250513          	add	a0,a0,1554 # 80018c40 <log>
    80003636:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003638:	00003097          	auipc	ra,0x3
    8000363c:	c3a080e7          	jalr	-966(ra) # 80006272 <release>
      break;
    }
  }
}
    80003640:	60e2                	ld	ra,24(sp)
    80003642:	6442                	ld	s0,16(sp)
    80003644:	64a2                	ld	s1,8(sp)
    80003646:	6902                	ld	s2,0(sp)
    80003648:	6105                	add	sp,sp,32
    8000364a:	8082                	ret

000000008000364c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000364c:	7139                	add	sp,sp,-64
    8000364e:	fc06                	sd	ra,56(sp)
    80003650:	f822                	sd	s0,48(sp)
    80003652:	f426                	sd	s1,40(sp)
    80003654:	f04a                	sd	s2,32(sp)
    80003656:	ec4e                	sd	s3,24(sp)
    80003658:	e852                	sd	s4,16(sp)
    8000365a:	e456                	sd	s5,8(sp)
    8000365c:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000365e:	00015497          	auipc	s1,0x15
    80003662:	5e248493          	add	s1,s1,1506 # 80018c40 <log>
    80003666:	8526                	mv	a0,s1
    80003668:	00003097          	auipc	ra,0x3
    8000366c:	b56080e7          	jalr	-1194(ra) # 800061be <acquire>
  log.outstanding -= 1;
    80003670:	509c                	lw	a5,32(s1)
    80003672:	37fd                	addw	a5,a5,-1
    80003674:	0007891b          	sext.w	s2,a5
    80003678:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000367a:	50dc                	lw	a5,36(s1)
    8000367c:	e7b9                	bnez	a5,800036ca <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000367e:	04091e63          	bnez	s2,800036da <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003682:	00015497          	auipc	s1,0x15
    80003686:	5be48493          	add	s1,s1,1470 # 80018c40 <log>
    8000368a:	4785                	li	a5,1
    8000368c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000368e:	8526                	mv	a0,s1
    80003690:	00003097          	auipc	ra,0x3
    80003694:	be2080e7          	jalr	-1054(ra) # 80006272 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003698:	54dc                	lw	a5,44(s1)
    8000369a:	06f04763          	bgtz	a5,80003708 <end_op+0xbc>
    acquire(&log.lock);
    8000369e:	00015497          	auipc	s1,0x15
    800036a2:	5a248493          	add	s1,s1,1442 # 80018c40 <log>
    800036a6:	8526                	mv	a0,s1
    800036a8:	00003097          	auipc	ra,0x3
    800036ac:	b16080e7          	jalr	-1258(ra) # 800061be <acquire>
    log.committing = 0;
    800036b0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036b4:	8526                	mv	a0,s1
    800036b6:	ffffe097          	auipc	ra,0xffffe
    800036ba:	efe080e7          	jalr	-258(ra) # 800015b4 <wakeup>
    release(&log.lock);
    800036be:	8526                	mv	a0,s1
    800036c0:	00003097          	auipc	ra,0x3
    800036c4:	bb2080e7          	jalr	-1102(ra) # 80006272 <release>
}
    800036c8:	a03d                	j	800036f6 <end_op+0xaa>
    panic("log.committing");
    800036ca:	00005517          	auipc	a0,0x5
    800036ce:	07e50513          	add	a0,a0,126 # 80008748 <syscall_names+0x1f0>
    800036d2:	00002097          	auipc	ra,0x2
    800036d6:	5b4080e7          	jalr	1460(ra) # 80005c86 <panic>
    wakeup(&log);
    800036da:	00015497          	auipc	s1,0x15
    800036de:	56648493          	add	s1,s1,1382 # 80018c40 <log>
    800036e2:	8526                	mv	a0,s1
    800036e4:	ffffe097          	auipc	ra,0xffffe
    800036e8:	ed0080e7          	jalr	-304(ra) # 800015b4 <wakeup>
  release(&log.lock);
    800036ec:	8526                	mv	a0,s1
    800036ee:	00003097          	auipc	ra,0x3
    800036f2:	b84080e7          	jalr	-1148(ra) # 80006272 <release>
}
    800036f6:	70e2                	ld	ra,56(sp)
    800036f8:	7442                	ld	s0,48(sp)
    800036fa:	74a2                	ld	s1,40(sp)
    800036fc:	7902                	ld	s2,32(sp)
    800036fe:	69e2                	ld	s3,24(sp)
    80003700:	6a42                	ld	s4,16(sp)
    80003702:	6aa2                	ld	s5,8(sp)
    80003704:	6121                	add	sp,sp,64
    80003706:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003708:	00015a97          	auipc	s5,0x15
    8000370c:	568a8a93          	add	s5,s5,1384 # 80018c70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003710:	00015a17          	auipc	s4,0x15
    80003714:	530a0a13          	add	s4,s4,1328 # 80018c40 <log>
    80003718:	018a2583          	lw	a1,24(s4)
    8000371c:	012585bb          	addw	a1,a1,s2
    80003720:	2585                	addw	a1,a1,1
    80003722:	028a2503          	lw	a0,40(s4)
    80003726:	fffff097          	auipc	ra,0xfffff
    8000372a:	cf6080e7          	jalr	-778(ra) # 8000241c <bread>
    8000372e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003730:	000aa583          	lw	a1,0(s5)
    80003734:	028a2503          	lw	a0,40(s4)
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	ce4080e7          	jalr	-796(ra) # 8000241c <bread>
    80003740:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003742:	40000613          	li	a2,1024
    80003746:	05850593          	add	a1,a0,88
    8000374a:	05848513          	add	a0,s1,88
    8000374e:	ffffd097          	auipc	ra,0xffffd
    80003752:	ad2080e7          	jalr	-1326(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    80003756:	8526                	mv	a0,s1
    80003758:	fffff097          	auipc	ra,0xfffff
    8000375c:	db6080e7          	jalr	-586(ra) # 8000250e <bwrite>
    brelse(from);
    80003760:	854e                	mv	a0,s3
    80003762:	fffff097          	auipc	ra,0xfffff
    80003766:	dea080e7          	jalr	-534(ra) # 8000254c <brelse>
    brelse(to);
    8000376a:	8526                	mv	a0,s1
    8000376c:	fffff097          	auipc	ra,0xfffff
    80003770:	de0080e7          	jalr	-544(ra) # 8000254c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003774:	2905                	addw	s2,s2,1
    80003776:	0a91                	add	s5,s5,4
    80003778:	02ca2783          	lw	a5,44(s4)
    8000377c:	f8f94ee3          	blt	s2,a5,80003718 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003780:	00000097          	auipc	ra,0x0
    80003784:	c8c080e7          	jalr	-884(ra) # 8000340c <write_head>
    install_trans(0); // Now install writes to home locations
    80003788:	4501                	li	a0,0
    8000378a:	00000097          	auipc	ra,0x0
    8000378e:	cec080e7          	jalr	-788(ra) # 80003476 <install_trans>
    log.lh.n = 0;
    80003792:	00015797          	auipc	a5,0x15
    80003796:	4c07ad23          	sw	zero,1242(a5) # 80018c6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000379a:	00000097          	auipc	ra,0x0
    8000379e:	c72080e7          	jalr	-910(ra) # 8000340c <write_head>
    800037a2:	bdf5                	j	8000369e <end_op+0x52>

00000000800037a4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037a4:	1101                	add	sp,sp,-32
    800037a6:	ec06                	sd	ra,24(sp)
    800037a8:	e822                	sd	s0,16(sp)
    800037aa:	e426                	sd	s1,8(sp)
    800037ac:	e04a                	sd	s2,0(sp)
    800037ae:	1000                	add	s0,sp,32
    800037b0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037b2:	00015917          	auipc	s2,0x15
    800037b6:	48e90913          	add	s2,s2,1166 # 80018c40 <log>
    800037ba:	854a                	mv	a0,s2
    800037bc:	00003097          	auipc	ra,0x3
    800037c0:	a02080e7          	jalr	-1534(ra) # 800061be <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037c4:	02c92603          	lw	a2,44(s2)
    800037c8:	47f5                	li	a5,29
    800037ca:	06c7c563          	blt	a5,a2,80003834 <log_write+0x90>
    800037ce:	00015797          	auipc	a5,0x15
    800037d2:	48e7a783          	lw	a5,1166(a5) # 80018c5c <log+0x1c>
    800037d6:	37fd                	addw	a5,a5,-1
    800037d8:	04f65e63          	bge	a2,a5,80003834 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037dc:	00015797          	auipc	a5,0x15
    800037e0:	4847a783          	lw	a5,1156(a5) # 80018c60 <log+0x20>
    800037e4:	06f05063          	blez	a5,80003844 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037e8:	4781                	li	a5,0
    800037ea:	06c05563          	blez	a2,80003854 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ee:	44cc                	lw	a1,12(s1)
    800037f0:	00015717          	auipc	a4,0x15
    800037f4:	48070713          	add	a4,a4,1152 # 80018c70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037f8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037fa:	4314                	lw	a3,0(a4)
    800037fc:	04b68c63          	beq	a3,a1,80003854 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003800:	2785                	addw	a5,a5,1
    80003802:	0711                	add	a4,a4,4
    80003804:	fef61be3          	bne	a2,a5,800037fa <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003808:	0621                	add	a2,a2,8
    8000380a:	060a                	sll	a2,a2,0x2
    8000380c:	00015797          	auipc	a5,0x15
    80003810:	43478793          	add	a5,a5,1076 # 80018c40 <log>
    80003814:	97b2                	add	a5,a5,a2
    80003816:	44d8                	lw	a4,12(s1)
    80003818:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000381a:	8526                	mv	a0,s1
    8000381c:	fffff097          	auipc	ra,0xfffff
    80003820:	dcc080e7          	jalr	-564(ra) # 800025e8 <bpin>
    log.lh.n++;
    80003824:	00015717          	auipc	a4,0x15
    80003828:	41c70713          	add	a4,a4,1052 # 80018c40 <log>
    8000382c:	575c                	lw	a5,44(a4)
    8000382e:	2785                	addw	a5,a5,1
    80003830:	d75c                	sw	a5,44(a4)
    80003832:	a82d                	j	8000386c <log_write+0xc8>
    panic("too big a transaction");
    80003834:	00005517          	auipc	a0,0x5
    80003838:	f2450513          	add	a0,a0,-220 # 80008758 <syscall_names+0x200>
    8000383c:	00002097          	auipc	ra,0x2
    80003840:	44a080e7          	jalr	1098(ra) # 80005c86 <panic>
    panic("log_write outside of trans");
    80003844:	00005517          	auipc	a0,0x5
    80003848:	f2c50513          	add	a0,a0,-212 # 80008770 <syscall_names+0x218>
    8000384c:	00002097          	auipc	ra,0x2
    80003850:	43a080e7          	jalr	1082(ra) # 80005c86 <panic>
  log.lh.block[i] = b->blockno;
    80003854:	00878693          	add	a3,a5,8
    80003858:	068a                	sll	a3,a3,0x2
    8000385a:	00015717          	auipc	a4,0x15
    8000385e:	3e670713          	add	a4,a4,998 # 80018c40 <log>
    80003862:	9736                	add	a4,a4,a3
    80003864:	44d4                	lw	a3,12(s1)
    80003866:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003868:	faf609e3          	beq	a2,a5,8000381a <log_write+0x76>
  }
  release(&log.lock);
    8000386c:	00015517          	auipc	a0,0x15
    80003870:	3d450513          	add	a0,a0,980 # 80018c40 <log>
    80003874:	00003097          	auipc	ra,0x3
    80003878:	9fe080e7          	jalr	-1538(ra) # 80006272 <release>
}
    8000387c:	60e2                	ld	ra,24(sp)
    8000387e:	6442                	ld	s0,16(sp)
    80003880:	64a2                	ld	s1,8(sp)
    80003882:	6902                	ld	s2,0(sp)
    80003884:	6105                	add	sp,sp,32
    80003886:	8082                	ret

0000000080003888 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003888:	1101                	add	sp,sp,-32
    8000388a:	ec06                	sd	ra,24(sp)
    8000388c:	e822                	sd	s0,16(sp)
    8000388e:	e426                	sd	s1,8(sp)
    80003890:	e04a                	sd	s2,0(sp)
    80003892:	1000                	add	s0,sp,32
    80003894:	84aa                	mv	s1,a0
    80003896:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003898:	00005597          	auipc	a1,0x5
    8000389c:	ef858593          	add	a1,a1,-264 # 80008790 <syscall_names+0x238>
    800038a0:	0521                	add	a0,a0,8
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	88c080e7          	jalr	-1908(ra) # 8000612e <initlock>
  lk->name = name;
    800038aa:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038ae:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038b2:	0204a423          	sw	zero,40(s1)
}
    800038b6:	60e2                	ld	ra,24(sp)
    800038b8:	6442                	ld	s0,16(sp)
    800038ba:	64a2                	ld	s1,8(sp)
    800038bc:	6902                	ld	s2,0(sp)
    800038be:	6105                	add	sp,sp,32
    800038c0:	8082                	ret

00000000800038c2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038c2:	1101                	add	sp,sp,-32
    800038c4:	ec06                	sd	ra,24(sp)
    800038c6:	e822                	sd	s0,16(sp)
    800038c8:	e426                	sd	s1,8(sp)
    800038ca:	e04a                	sd	s2,0(sp)
    800038cc:	1000                	add	s0,sp,32
    800038ce:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d0:	00850913          	add	s2,a0,8
    800038d4:	854a                	mv	a0,s2
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	8e8080e7          	jalr	-1816(ra) # 800061be <acquire>
  while (lk->locked) {
    800038de:	409c                	lw	a5,0(s1)
    800038e0:	cb89                	beqz	a5,800038f2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038e2:	85ca                	mv	a1,s2
    800038e4:	8526                	mv	a0,s1
    800038e6:	ffffe097          	auipc	ra,0xffffe
    800038ea:	c6a080e7          	jalr	-918(ra) # 80001550 <sleep>
  while (lk->locked) {
    800038ee:	409c                	lw	a5,0(s1)
    800038f0:	fbed                	bnez	a5,800038e2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038f2:	4785                	li	a5,1
    800038f4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038f6:	ffffd097          	auipc	ra,0xffffd
    800038fa:	5a6080e7          	jalr	1446(ra) # 80000e9c <myproc>
    800038fe:	591c                	lw	a5,48(a0)
    80003900:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003902:	854a                	mv	a0,s2
    80003904:	00003097          	auipc	ra,0x3
    80003908:	96e080e7          	jalr	-1682(ra) # 80006272 <release>
}
    8000390c:	60e2                	ld	ra,24(sp)
    8000390e:	6442                	ld	s0,16(sp)
    80003910:	64a2                	ld	s1,8(sp)
    80003912:	6902                	ld	s2,0(sp)
    80003914:	6105                	add	sp,sp,32
    80003916:	8082                	ret

0000000080003918 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003918:	1101                	add	sp,sp,-32
    8000391a:	ec06                	sd	ra,24(sp)
    8000391c:	e822                	sd	s0,16(sp)
    8000391e:	e426                	sd	s1,8(sp)
    80003920:	e04a                	sd	s2,0(sp)
    80003922:	1000                	add	s0,sp,32
    80003924:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003926:	00850913          	add	s2,a0,8
    8000392a:	854a                	mv	a0,s2
    8000392c:	00003097          	auipc	ra,0x3
    80003930:	892080e7          	jalr	-1902(ra) # 800061be <acquire>
  lk->locked = 0;
    80003934:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003938:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000393c:	8526                	mv	a0,s1
    8000393e:	ffffe097          	auipc	ra,0xffffe
    80003942:	c76080e7          	jalr	-906(ra) # 800015b4 <wakeup>
  release(&lk->lk);
    80003946:	854a                	mv	a0,s2
    80003948:	00003097          	auipc	ra,0x3
    8000394c:	92a080e7          	jalr	-1750(ra) # 80006272 <release>
}
    80003950:	60e2                	ld	ra,24(sp)
    80003952:	6442                	ld	s0,16(sp)
    80003954:	64a2                	ld	s1,8(sp)
    80003956:	6902                	ld	s2,0(sp)
    80003958:	6105                	add	sp,sp,32
    8000395a:	8082                	ret

000000008000395c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000395c:	7179                	add	sp,sp,-48
    8000395e:	f406                	sd	ra,40(sp)
    80003960:	f022                	sd	s0,32(sp)
    80003962:	ec26                	sd	s1,24(sp)
    80003964:	e84a                	sd	s2,16(sp)
    80003966:	e44e                	sd	s3,8(sp)
    80003968:	1800                	add	s0,sp,48
    8000396a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000396c:	00850913          	add	s2,a0,8
    80003970:	854a                	mv	a0,s2
    80003972:	00003097          	auipc	ra,0x3
    80003976:	84c080e7          	jalr	-1972(ra) # 800061be <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000397a:	409c                	lw	a5,0(s1)
    8000397c:	ef99                	bnez	a5,8000399a <holdingsleep+0x3e>
    8000397e:	4481                	li	s1,0
  release(&lk->lk);
    80003980:	854a                	mv	a0,s2
    80003982:	00003097          	auipc	ra,0x3
    80003986:	8f0080e7          	jalr	-1808(ra) # 80006272 <release>
  return r;
}
    8000398a:	8526                	mv	a0,s1
    8000398c:	70a2                	ld	ra,40(sp)
    8000398e:	7402                	ld	s0,32(sp)
    80003990:	64e2                	ld	s1,24(sp)
    80003992:	6942                	ld	s2,16(sp)
    80003994:	69a2                	ld	s3,8(sp)
    80003996:	6145                	add	sp,sp,48
    80003998:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399a:	0284a983          	lw	s3,40(s1)
    8000399e:	ffffd097          	auipc	ra,0xffffd
    800039a2:	4fe080e7          	jalr	1278(ra) # 80000e9c <myproc>
    800039a6:	5904                	lw	s1,48(a0)
    800039a8:	413484b3          	sub	s1,s1,s3
    800039ac:	0014b493          	seqz	s1,s1
    800039b0:	bfc1                	j	80003980 <holdingsleep+0x24>

00000000800039b2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039b2:	1141                	add	sp,sp,-16
    800039b4:	e406                	sd	ra,8(sp)
    800039b6:	e022                	sd	s0,0(sp)
    800039b8:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039ba:	00005597          	auipc	a1,0x5
    800039be:	de658593          	add	a1,a1,-538 # 800087a0 <syscall_names+0x248>
    800039c2:	00015517          	auipc	a0,0x15
    800039c6:	3c650513          	add	a0,a0,966 # 80018d88 <ftable>
    800039ca:	00002097          	auipc	ra,0x2
    800039ce:	764080e7          	jalr	1892(ra) # 8000612e <initlock>
}
    800039d2:	60a2                	ld	ra,8(sp)
    800039d4:	6402                	ld	s0,0(sp)
    800039d6:	0141                	add	sp,sp,16
    800039d8:	8082                	ret

00000000800039da <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039da:	1101                	add	sp,sp,-32
    800039dc:	ec06                	sd	ra,24(sp)
    800039de:	e822                	sd	s0,16(sp)
    800039e0:	e426                	sd	s1,8(sp)
    800039e2:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039e4:	00015517          	auipc	a0,0x15
    800039e8:	3a450513          	add	a0,a0,932 # 80018d88 <ftable>
    800039ec:	00002097          	auipc	ra,0x2
    800039f0:	7d2080e7          	jalr	2002(ra) # 800061be <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f4:	00015497          	auipc	s1,0x15
    800039f8:	3ac48493          	add	s1,s1,940 # 80018da0 <ftable+0x18>
    800039fc:	00016717          	auipc	a4,0x16
    80003a00:	34470713          	add	a4,a4,836 # 80019d40 <disk>
    if(f->ref == 0){
    80003a04:	40dc                	lw	a5,4(s1)
    80003a06:	cf99                	beqz	a5,80003a24 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a08:	02848493          	add	s1,s1,40
    80003a0c:	fee49ce3          	bne	s1,a4,80003a04 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a10:	00015517          	auipc	a0,0x15
    80003a14:	37850513          	add	a0,a0,888 # 80018d88 <ftable>
    80003a18:	00003097          	auipc	ra,0x3
    80003a1c:	85a080e7          	jalr	-1958(ra) # 80006272 <release>
  return 0;
    80003a20:	4481                	li	s1,0
    80003a22:	a819                	j	80003a38 <filealloc+0x5e>
      f->ref = 1;
    80003a24:	4785                	li	a5,1
    80003a26:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a28:	00015517          	auipc	a0,0x15
    80003a2c:	36050513          	add	a0,a0,864 # 80018d88 <ftable>
    80003a30:	00003097          	auipc	ra,0x3
    80003a34:	842080e7          	jalr	-1982(ra) # 80006272 <release>
}
    80003a38:	8526                	mv	a0,s1
    80003a3a:	60e2                	ld	ra,24(sp)
    80003a3c:	6442                	ld	s0,16(sp)
    80003a3e:	64a2                	ld	s1,8(sp)
    80003a40:	6105                	add	sp,sp,32
    80003a42:	8082                	ret

0000000080003a44 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a44:	1101                	add	sp,sp,-32
    80003a46:	ec06                	sd	ra,24(sp)
    80003a48:	e822                	sd	s0,16(sp)
    80003a4a:	e426                	sd	s1,8(sp)
    80003a4c:	1000                	add	s0,sp,32
    80003a4e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a50:	00015517          	auipc	a0,0x15
    80003a54:	33850513          	add	a0,a0,824 # 80018d88 <ftable>
    80003a58:	00002097          	auipc	ra,0x2
    80003a5c:	766080e7          	jalr	1894(ra) # 800061be <acquire>
  if(f->ref < 1)
    80003a60:	40dc                	lw	a5,4(s1)
    80003a62:	02f05263          	blez	a5,80003a86 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a66:	2785                	addw	a5,a5,1
    80003a68:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a6a:	00015517          	auipc	a0,0x15
    80003a6e:	31e50513          	add	a0,a0,798 # 80018d88 <ftable>
    80003a72:	00003097          	auipc	ra,0x3
    80003a76:	800080e7          	jalr	-2048(ra) # 80006272 <release>
  return f;
}
    80003a7a:	8526                	mv	a0,s1
    80003a7c:	60e2                	ld	ra,24(sp)
    80003a7e:	6442                	ld	s0,16(sp)
    80003a80:	64a2                	ld	s1,8(sp)
    80003a82:	6105                	add	sp,sp,32
    80003a84:	8082                	ret
    panic("filedup");
    80003a86:	00005517          	auipc	a0,0x5
    80003a8a:	d2250513          	add	a0,a0,-734 # 800087a8 <syscall_names+0x250>
    80003a8e:	00002097          	auipc	ra,0x2
    80003a92:	1f8080e7          	jalr	504(ra) # 80005c86 <panic>

0000000080003a96 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a96:	7139                	add	sp,sp,-64
    80003a98:	fc06                	sd	ra,56(sp)
    80003a9a:	f822                	sd	s0,48(sp)
    80003a9c:	f426                	sd	s1,40(sp)
    80003a9e:	f04a                	sd	s2,32(sp)
    80003aa0:	ec4e                	sd	s3,24(sp)
    80003aa2:	e852                	sd	s4,16(sp)
    80003aa4:	e456                	sd	s5,8(sp)
    80003aa6:	0080                	add	s0,sp,64
    80003aa8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aaa:	00015517          	auipc	a0,0x15
    80003aae:	2de50513          	add	a0,a0,734 # 80018d88 <ftable>
    80003ab2:	00002097          	auipc	ra,0x2
    80003ab6:	70c080e7          	jalr	1804(ra) # 800061be <acquire>
  if(f->ref < 1)
    80003aba:	40dc                	lw	a5,4(s1)
    80003abc:	06f05163          	blez	a5,80003b1e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ac0:	37fd                	addw	a5,a5,-1
    80003ac2:	0007871b          	sext.w	a4,a5
    80003ac6:	c0dc                	sw	a5,4(s1)
    80003ac8:	06e04363          	bgtz	a4,80003b2e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003acc:	0004a903          	lw	s2,0(s1)
    80003ad0:	0094ca83          	lbu	s5,9(s1)
    80003ad4:	0104ba03          	ld	s4,16(s1)
    80003ad8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003adc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ae0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ae4:	00015517          	auipc	a0,0x15
    80003ae8:	2a450513          	add	a0,a0,676 # 80018d88 <ftable>
    80003aec:	00002097          	auipc	ra,0x2
    80003af0:	786080e7          	jalr	1926(ra) # 80006272 <release>

  if(ff.type == FD_PIPE){
    80003af4:	4785                	li	a5,1
    80003af6:	04f90d63          	beq	s2,a5,80003b50 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003afa:	3979                	addw	s2,s2,-2
    80003afc:	4785                	li	a5,1
    80003afe:	0527e063          	bltu	a5,s2,80003b3e <fileclose+0xa8>
    begin_op();
    80003b02:	00000097          	auipc	ra,0x0
    80003b06:	ad0080e7          	jalr	-1328(ra) # 800035d2 <begin_op>
    iput(ff.ip);
    80003b0a:	854e                	mv	a0,s3
    80003b0c:	fffff097          	auipc	ra,0xfffff
    80003b10:	2da080e7          	jalr	730(ra) # 80002de6 <iput>
    end_op();
    80003b14:	00000097          	auipc	ra,0x0
    80003b18:	b38080e7          	jalr	-1224(ra) # 8000364c <end_op>
    80003b1c:	a00d                	j	80003b3e <fileclose+0xa8>
    panic("fileclose");
    80003b1e:	00005517          	auipc	a0,0x5
    80003b22:	c9250513          	add	a0,a0,-878 # 800087b0 <syscall_names+0x258>
    80003b26:	00002097          	auipc	ra,0x2
    80003b2a:	160080e7          	jalr	352(ra) # 80005c86 <panic>
    release(&ftable.lock);
    80003b2e:	00015517          	auipc	a0,0x15
    80003b32:	25a50513          	add	a0,a0,602 # 80018d88 <ftable>
    80003b36:	00002097          	auipc	ra,0x2
    80003b3a:	73c080e7          	jalr	1852(ra) # 80006272 <release>
  }
}
    80003b3e:	70e2                	ld	ra,56(sp)
    80003b40:	7442                	ld	s0,48(sp)
    80003b42:	74a2                	ld	s1,40(sp)
    80003b44:	7902                	ld	s2,32(sp)
    80003b46:	69e2                	ld	s3,24(sp)
    80003b48:	6a42                	ld	s4,16(sp)
    80003b4a:	6aa2                	ld	s5,8(sp)
    80003b4c:	6121                	add	sp,sp,64
    80003b4e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b50:	85d6                	mv	a1,s5
    80003b52:	8552                	mv	a0,s4
    80003b54:	00000097          	auipc	ra,0x0
    80003b58:	348080e7          	jalr	840(ra) # 80003e9c <pipeclose>
    80003b5c:	b7cd                	j	80003b3e <fileclose+0xa8>

0000000080003b5e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b5e:	715d                	add	sp,sp,-80
    80003b60:	e486                	sd	ra,72(sp)
    80003b62:	e0a2                	sd	s0,64(sp)
    80003b64:	fc26                	sd	s1,56(sp)
    80003b66:	f84a                	sd	s2,48(sp)
    80003b68:	f44e                	sd	s3,40(sp)
    80003b6a:	0880                	add	s0,sp,80
    80003b6c:	84aa                	mv	s1,a0
    80003b6e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b70:	ffffd097          	auipc	ra,0xffffd
    80003b74:	32c080e7          	jalr	812(ra) # 80000e9c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b78:	409c                	lw	a5,0(s1)
    80003b7a:	37f9                	addw	a5,a5,-2
    80003b7c:	4705                	li	a4,1
    80003b7e:	04f76763          	bltu	a4,a5,80003bcc <filestat+0x6e>
    80003b82:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b84:	6c88                	ld	a0,24(s1)
    80003b86:	fffff097          	auipc	ra,0xfffff
    80003b8a:	0a6080e7          	jalr	166(ra) # 80002c2c <ilock>
    stati(f->ip, &st);
    80003b8e:	fb840593          	add	a1,s0,-72
    80003b92:	6c88                	ld	a0,24(s1)
    80003b94:	fffff097          	auipc	ra,0xfffff
    80003b98:	322080e7          	jalr	802(ra) # 80002eb6 <stati>
    iunlock(f->ip);
    80003b9c:	6c88                	ld	a0,24(s1)
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	150080e7          	jalr	336(ra) # 80002cee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ba6:	46e1                	li	a3,24
    80003ba8:	fb840613          	add	a2,s0,-72
    80003bac:	85ce                	mv	a1,s3
    80003bae:	05093503          	ld	a0,80(s2)
    80003bb2:	ffffd097          	auipc	ra,0xffffd
    80003bb6:	faa080e7          	jalr	-86(ra) # 80000b5c <copyout>
    80003bba:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bbe:	60a6                	ld	ra,72(sp)
    80003bc0:	6406                	ld	s0,64(sp)
    80003bc2:	74e2                	ld	s1,56(sp)
    80003bc4:	7942                	ld	s2,48(sp)
    80003bc6:	79a2                	ld	s3,40(sp)
    80003bc8:	6161                	add	sp,sp,80
    80003bca:	8082                	ret
  return -1;
    80003bcc:	557d                	li	a0,-1
    80003bce:	bfc5                	j	80003bbe <filestat+0x60>

0000000080003bd0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bd0:	7179                	add	sp,sp,-48
    80003bd2:	f406                	sd	ra,40(sp)
    80003bd4:	f022                	sd	s0,32(sp)
    80003bd6:	ec26                	sd	s1,24(sp)
    80003bd8:	e84a                	sd	s2,16(sp)
    80003bda:	e44e                	sd	s3,8(sp)
    80003bdc:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bde:	00854783          	lbu	a5,8(a0)
    80003be2:	c3d5                	beqz	a5,80003c86 <fileread+0xb6>
    80003be4:	84aa                	mv	s1,a0
    80003be6:	89ae                	mv	s3,a1
    80003be8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bea:	411c                	lw	a5,0(a0)
    80003bec:	4705                	li	a4,1
    80003bee:	04e78963          	beq	a5,a4,80003c40 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf2:	470d                	li	a4,3
    80003bf4:	04e78d63          	beq	a5,a4,80003c4e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bf8:	4709                	li	a4,2
    80003bfa:	06e79e63          	bne	a5,a4,80003c76 <fileread+0xa6>
    ilock(f->ip);
    80003bfe:	6d08                	ld	a0,24(a0)
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	02c080e7          	jalr	44(ra) # 80002c2c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c08:	874a                	mv	a4,s2
    80003c0a:	5094                	lw	a3,32(s1)
    80003c0c:	864e                	mv	a2,s3
    80003c0e:	4585                	li	a1,1
    80003c10:	6c88                	ld	a0,24(s1)
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	2ce080e7          	jalr	718(ra) # 80002ee0 <readi>
    80003c1a:	892a                	mv	s2,a0
    80003c1c:	00a05563          	blez	a0,80003c26 <fileread+0x56>
      f->off += r;
    80003c20:	509c                	lw	a5,32(s1)
    80003c22:	9fa9                	addw	a5,a5,a0
    80003c24:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c26:	6c88                	ld	a0,24(s1)
    80003c28:	fffff097          	auipc	ra,0xfffff
    80003c2c:	0c6080e7          	jalr	198(ra) # 80002cee <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c30:	854a                	mv	a0,s2
    80003c32:	70a2                	ld	ra,40(sp)
    80003c34:	7402                	ld	s0,32(sp)
    80003c36:	64e2                	ld	s1,24(sp)
    80003c38:	6942                	ld	s2,16(sp)
    80003c3a:	69a2                	ld	s3,8(sp)
    80003c3c:	6145                	add	sp,sp,48
    80003c3e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c40:	6908                	ld	a0,16(a0)
    80003c42:	00000097          	auipc	ra,0x0
    80003c46:	3c2080e7          	jalr	962(ra) # 80004004 <piperead>
    80003c4a:	892a                	mv	s2,a0
    80003c4c:	b7d5                	j	80003c30 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c4e:	02451783          	lh	a5,36(a0)
    80003c52:	03079693          	sll	a3,a5,0x30
    80003c56:	92c1                	srl	a3,a3,0x30
    80003c58:	4725                	li	a4,9
    80003c5a:	02d76863          	bltu	a4,a3,80003c8a <fileread+0xba>
    80003c5e:	0792                	sll	a5,a5,0x4
    80003c60:	00015717          	auipc	a4,0x15
    80003c64:	08870713          	add	a4,a4,136 # 80018ce8 <devsw>
    80003c68:	97ba                	add	a5,a5,a4
    80003c6a:	639c                	ld	a5,0(a5)
    80003c6c:	c38d                	beqz	a5,80003c8e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c6e:	4505                	li	a0,1
    80003c70:	9782                	jalr	a5
    80003c72:	892a                	mv	s2,a0
    80003c74:	bf75                	j	80003c30 <fileread+0x60>
    panic("fileread");
    80003c76:	00005517          	auipc	a0,0x5
    80003c7a:	b4a50513          	add	a0,a0,-1206 # 800087c0 <syscall_names+0x268>
    80003c7e:	00002097          	auipc	ra,0x2
    80003c82:	008080e7          	jalr	8(ra) # 80005c86 <panic>
    return -1;
    80003c86:	597d                	li	s2,-1
    80003c88:	b765                	j	80003c30 <fileread+0x60>
      return -1;
    80003c8a:	597d                	li	s2,-1
    80003c8c:	b755                	j	80003c30 <fileread+0x60>
    80003c8e:	597d                	li	s2,-1
    80003c90:	b745                	j	80003c30 <fileread+0x60>

0000000080003c92 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c92:	00954783          	lbu	a5,9(a0)
    80003c96:	10078e63          	beqz	a5,80003db2 <filewrite+0x120>
{
    80003c9a:	715d                	add	sp,sp,-80
    80003c9c:	e486                	sd	ra,72(sp)
    80003c9e:	e0a2                	sd	s0,64(sp)
    80003ca0:	fc26                	sd	s1,56(sp)
    80003ca2:	f84a                	sd	s2,48(sp)
    80003ca4:	f44e                	sd	s3,40(sp)
    80003ca6:	f052                	sd	s4,32(sp)
    80003ca8:	ec56                	sd	s5,24(sp)
    80003caa:	e85a                	sd	s6,16(sp)
    80003cac:	e45e                	sd	s7,8(sp)
    80003cae:	e062                	sd	s8,0(sp)
    80003cb0:	0880                	add	s0,sp,80
    80003cb2:	892a                	mv	s2,a0
    80003cb4:	8b2e                	mv	s6,a1
    80003cb6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cb8:	411c                	lw	a5,0(a0)
    80003cba:	4705                	li	a4,1
    80003cbc:	02e78263          	beq	a5,a4,80003ce0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cc0:	470d                	li	a4,3
    80003cc2:	02e78563          	beq	a5,a4,80003cec <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cc6:	4709                	li	a4,2
    80003cc8:	0ce79d63          	bne	a5,a4,80003da2 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ccc:	0ac05b63          	blez	a2,80003d82 <filewrite+0xf0>
    int i = 0;
    80003cd0:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003cd2:	6b85                	lui	s7,0x1
    80003cd4:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cd8:	6c05                	lui	s8,0x1
    80003cda:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cde:	a851                	j	80003d72 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003ce0:	6908                	ld	a0,16(a0)
    80003ce2:	00000097          	auipc	ra,0x0
    80003ce6:	22a080e7          	jalr	554(ra) # 80003f0c <pipewrite>
    80003cea:	a045                	j	80003d8a <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cec:	02451783          	lh	a5,36(a0)
    80003cf0:	03079693          	sll	a3,a5,0x30
    80003cf4:	92c1                	srl	a3,a3,0x30
    80003cf6:	4725                	li	a4,9
    80003cf8:	0ad76f63          	bltu	a4,a3,80003db6 <filewrite+0x124>
    80003cfc:	0792                	sll	a5,a5,0x4
    80003cfe:	00015717          	auipc	a4,0x15
    80003d02:	fea70713          	add	a4,a4,-22 # 80018ce8 <devsw>
    80003d06:	97ba                	add	a5,a5,a4
    80003d08:	679c                	ld	a5,8(a5)
    80003d0a:	cbc5                	beqz	a5,80003dba <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003d0c:	4505                	li	a0,1
    80003d0e:	9782                	jalr	a5
    80003d10:	a8ad                	j	80003d8a <filewrite+0xf8>
      if(n1 > max)
    80003d12:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d16:	00000097          	auipc	ra,0x0
    80003d1a:	8bc080e7          	jalr	-1860(ra) # 800035d2 <begin_op>
      ilock(f->ip);
    80003d1e:	01893503          	ld	a0,24(s2)
    80003d22:	fffff097          	auipc	ra,0xfffff
    80003d26:	f0a080e7          	jalr	-246(ra) # 80002c2c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d2a:	8756                	mv	a4,s5
    80003d2c:	02092683          	lw	a3,32(s2)
    80003d30:	01698633          	add	a2,s3,s6
    80003d34:	4585                	li	a1,1
    80003d36:	01893503          	ld	a0,24(s2)
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	29e080e7          	jalr	670(ra) # 80002fd8 <writei>
    80003d42:	84aa                	mv	s1,a0
    80003d44:	00a05763          	blez	a0,80003d52 <filewrite+0xc0>
        f->off += r;
    80003d48:	02092783          	lw	a5,32(s2)
    80003d4c:	9fa9                	addw	a5,a5,a0
    80003d4e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d52:	01893503          	ld	a0,24(s2)
    80003d56:	fffff097          	auipc	ra,0xfffff
    80003d5a:	f98080e7          	jalr	-104(ra) # 80002cee <iunlock>
      end_op();
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	8ee080e7          	jalr	-1810(ra) # 8000364c <end_op>

      if(r != n1){
    80003d66:	009a9f63          	bne	s5,s1,80003d84 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003d6a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d6e:	0149db63          	bge	s3,s4,80003d84 <filewrite+0xf2>
      int n1 = n - i;
    80003d72:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d76:	0004879b          	sext.w	a5,s1
    80003d7a:	f8fbdce3          	bge	s7,a5,80003d12 <filewrite+0x80>
    80003d7e:	84e2                	mv	s1,s8
    80003d80:	bf49                	j	80003d12 <filewrite+0x80>
    int i = 0;
    80003d82:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d84:	033a1d63          	bne	s4,s3,80003dbe <filewrite+0x12c>
    80003d88:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d8a:	60a6                	ld	ra,72(sp)
    80003d8c:	6406                	ld	s0,64(sp)
    80003d8e:	74e2                	ld	s1,56(sp)
    80003d90:	7942                	ld	s2,48(sp)
    80003d92:	79a2                	ld	s3,40(sp)
    80003d94:	7a02                	ld	s4,32(sp)
    80003d96:	6ae2                	ld	s5,24(sp)
    80003d98:	6b42                	ld	s6,16(sp)
    80003d9a:	6ba2                	ld	s7,8(sp)
    80003d9c:	6c02                	ld	s8,0(sp)
    80003d9e:	6161                	add	sp,sp,80
    80003da0:	8082                	ret
    panic("filewrite");
    80003da2:	00005517          	auipc	a0,0x5
    80003da6:	a2e50513          	add	a0,a0,-1490 # 800087d0 <syscall_names+0x278>
    80003daa:	00002097          	auipc	ra,0x2
    80003dae:	edc080e7          	jalr	-292(ra) # 80005c86 <panic>
    return -1;
    80003db2:	557d                	li	a0,-1
}
    80003db4:	8082                	ret
      return -1;
    80003db6:	557d                	li	a0,-1
    80003db8:	bfc9                	j	80003d8a <filewrite+0xf8>
    80003dba:	557d                	li	a0,-1
    80003dbc:	b7f9                	j	80003d8a <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003dbe:	557d                	li	a0,-1
    80003dc0:	b7e9                	j	80003d8a <filewrite+0xf8>

0000000080003dc2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dc2:	7179                	add	sp,sp,-48
    80003dc4:	f406                	sd	ra,40(sp)
    80003dc6:	f022                	sd	s0,32(sp)
    80003dc8:	ec26                	sd	s1,24(sp)
    80003dca:	e84a                	sd	s2,16(sp)
    80003dcc:	e44e                	sd	s3,8(sp)
    80003dce:	e052                	sd	s4,0(sp)
    80003dd0:	1800                	add	s0,sp,48
    80003dd2:	84aa                	mv	s1,a0
    80003dd4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dd6:	0005b023          	sd	zero,0(a1)
    80003dda:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dde:	00000097          	auipc	ra,0x0
    80003de2:	bfc080e7          	jalr	-1028(ra) # 800039da <filealloc>
    80003de6:	e088                	sd	a0,0(s1)
    80003de8:	c551                	beqz	a0,80003e74 <pipealloc+0xb2>
    80003dea:	00000097          	auipc	ra,0x0
    80003dee:	bf0080e7          	jalr	-1040(ra) # 800039da <filealloc>
    80003df2:	00aa3023          	sd	a0,0(s4)
    80003df6:	c92d                	beqz	a0,80003e68 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003df8:	ffffc097          	auipc	ra,0xffffc
    80003dfc:	322080e7          	jalr	802(ra) # 8000011a <kalloc>
    80003e00:	892a                	mv	s2,a0
    80003e02:	c125                	beqz	a0,80003e62 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e04:	4985                	li	s3,1
    80003e06:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e0a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e0e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e12:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e16:	00004597          	auipc	a1,0x4
    80003e1a:	5d258593          	add	a1,a1,1490 # 800083e8 <states.0+0x1a0>
    80003e1e:	00002097          	auipc	ra,0x2
    80003e22:	310080e7          	jalr	784(ra) # 8000612e <initlock>
  (*f0)->type = FD_PIPE;
    80003e26:	609c                	ld	a5,0(s1)
    80003e28:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e2c:	609c                	ld	a5,0(s1)
    80003e2e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e32:	609c                	ld	a5,0(s1)
    80003e34:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e38:	609c                	ld	a5,0(s1)
    80003e3a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e3e:	000a3783          	ld	a5,0(s4)
    80003e42:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e46:	000a3783          	ld	a5,0(s4)
    80003e4a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e4e:	000a3783          	ld	a5,0(s4)
    80003e52:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e56:	000a3783          	ld	a5,0(s4)
    80003e5a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e5e:	4501                	li	a0,0
    80003e60:	a025                	j	80003e88 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e62:	6088                	ld	a0,0(s1)
    80003e64:	e501                	bnez	a0,80003e6c <pipealloc+0xaa>
    80003e66:	a039                	j	80003e74 <pipealloc+0xb2>
    80003e68:	6088                	ld	a0,0(s1)
    80003e6a:	c51d                	beqz	a0,80003e98 <pipealloc+0xd6>
    fileclose(*f0);
    80003e6c:	00000097          	auipc	ra,0x0
    80003e70:	c2a080e7          	jalr	-982(ra) # 80003a96 <fileclose>
  if(*f1)
    80003e74:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e78:	557d                	li	a0,-1
  if(*f1)
    80003e7a:	c799                	beqz	a5,80003e88 <pipealloc+0xc6>
    fileclose(*f1);
    80003e7c:	853e                	mv	a0,a5
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	c18080e7          	jalr	-1000(ra) # 80003a96 <fileclose>
  return -1;
    80003e86:	557d                	li	a0,-1
}
    80003e88:	70a2                	ld	ra,40(sp)
    80003e8a:	7402                	ld	s0,32(sp)
    80003e8c:	64e2                	ld	s1,24(sp)
    80003e8e:	6942                	ld	s2,16(sp)
    80003e90:	69a2                	ld	s3,8(sp)
    80003e92:	6a02                	ld	s4,0(sp)
    80003e94:	6145                	add	sp,sp,48
    80003e96:	8082                	ret
  return -1;
    80003e98:	557d                	li	a0,-1
    80003e9a:	b7fd                	j	80003e88 <pipealloc+0xc6>

0000000080003e9c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e9c:	1101                	add	sp,sp,-32
    80003e9e:	ec06                	sd	ra,24(sp)
    80003ea0:	e822                	sd	s0,16(sp)
    80003ea2:	e426                	sd	s1,8(sp)
    80003ea4:	e04a                	sd	s2,0(sp)
    80003ea6:	1000                	add	s0,sp,32
    80003ea8:	84aa                	mv	s1,a0
    80003eaa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eac:	00002097          	auipc	ra,0x2
    80003eb0:	312080e7          	jalr	786(ra) # 800061be <acquire>
  if(writable){
    80003eb4:	02090d63          	beqz	s2,80003eee <pipeclose+0x52>
    pi->writeopen = 0;
    80003eb8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ebc:	21848513          	add	a0,s1,536
    80003ec0:	ffffd097          	auipc	ra,0xffffd
    80003ec4:	6f4080e7          	jalr	1780(ra) # 800015b4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ec8:	2204b783          	ld	a5,544(s1)
    80003ecc:	eb95                	bnez	a5,80003f00 <pipeclose+0x64>
    release(&pi->lock);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	00002097          	auipc	ra,0x2
    80003ed4:	3a2080e7          	jalr	930(ra) # 80006272 <release>
    kfree((char*)pi);
    80003ed8:	8526                	mv	a0,s1
    80003eda:	ffffc097          	auipc	ra,0xffffc
    80003ede:	142080e7          	jalr	322(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ee2:	60e2                	ld	ra,24(sp)
    80003ee4:	6442                	ld	s0,16(sp)
    80003ee6:	64a2                	ld	s1,8(sp)
    80003ee8:	6902                	ld	s2,0(sp)
    80003eea:	6105                	add	sp,sp,32
    80003eec:	8082                	ret
    pi->readopen = 0;
    80003eee:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ef2:	21c48513          	add	a0,s1,540
    80003ef6:	ffffd097          	auipc	ra,0xffffd
    80003efa:	6be080e7          	jalr	1726(ra) # 800015b4 <wakeup>
    80003efe:	b7e9                	j	80003ec8 <pipeclose+0x2c>
    release(&pi->lock);
    80003f00:	8526                	mv	a0,s1
    80003f02:	00002097          	auipc	ra,0x2
    80003f06:	370080e7          	jalr	880(ra) # 80006272 <release>
}
    80003f0a:	bfe1                	j	80003ee2 <pipeclose+0x46>

0000000080003f0c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f0c:	711d                	add	sp,sp,-96
    80003f0e:	ec86                	sd	ra,88(sp)
    80003f10:	e8a2                	sd	s0,80(sp)
    80003f12:	e4a6                	sd	s1,72(sp)
    80003f14:	e0ca                	sd	s2,64(sp)
    80003f16:	fc4e                	sd	s3,56(sp)
    80003f18:	f852                	sd	s4,48(sp)
    80003f1a:	f456                	sd	s5,40(sp)
    80003f1c:	f05a                	sd	s6,32(sp)
    80003f1e:	ec5e                	sd	s7,24(sp)
    80003f20:	e862                	sd	s8,16(sp)
    80003f22:	1080                	add	s0,sp,96
    80003f24:	84aa                	mv	s1,a0
    80003f26:	8aae                	mv	s5,a1
    80003f28:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f2a:	ffffd097          	auipc	ra,0xffffd
    80003f2e:	f72080e7          	jalr	-142(ra) # 80000e9c <myproc>
    80003f32:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f34:	8526                	mv	a0,s1
    80003f36:	00002097          	auipc	ra,0x2
    80003f3a:	288080e7          	jalr	648(ra) # 800061be <acquire>
  while(i < n){
    80003f3e:	0b405663          	blez	s4,80003fea <pipewrite+0xde>
  int i = 0;
    80003f42:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f44:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f46:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f4a:	21c48b93          	add	s7,s1,540
    80003f4e:	a089                	j	80003f90 <pipewrite+0x84>
      release(&pi->lock);
    80003f50:	8526                	mv	a0,s1
    80003f52:	00002097          	auipc	ra,0x2
    80003f56:	320080e7          	jalr	800(ra) # 80006272 <release>
      return -1;
    80003f5a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f5c:	854a                	mv	a0,s2
    80003f5e:	60e6                	ld	ra,88(sp)
    80003f60:	6446                	ld	s0,80(sp)
    80003f62:	64a6                	ld	s1,72(sp)
    80003f64:	6906                	ld	s2,64(sp)
    80003f66:	79e2                	ld	s3,56(sp)
    80003f68:	7a42                	ld	s4,48(sp)
    80003f6a:	7aa2                	ld	s5,40(sp)
    80003f6c:	7b02                	ld	s6,32(sp)
    80003f6e:	6be2                	ld	s7,24(sp)
    80003f70:	6c42                	ld	s8,16(sp)
    80003f72:	6125                	add	sp,sp,96
    80003f74:	8082                	ret
      wakeup(&pi->nread);
    80003f76:	8562                	mv	a0,s8
    80003f78:	ffffd097          	auipc	ra,0xffffd
    80003f7c:	63c080e7          	jalr	1596(ra) # 800015b4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f80:	85a6                	mv	a1,s1
    80003f82:	855e                	mv	a0,s7
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	5cc080e7          	jalr	1484(ra) # 80001550 <sleep>
  while(i < n){
    80003f8c:	07495063          	bge	s2,s4,80003fec <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f90:	2204a783          	lw	a5,544(s1)
    80003f94:	dfd5                	beqz	a5,80003f50 <pipewrite+0x44>
    80003f96:	854e                	mv	a0,s3
    80003f98:	ffffe097          	auipc	ra,0xffffe
    80003f9c:	860080e7          	jalr	-1952(ra) # 800017f8 <killed>
    80003fa0:	f945                	bnez	a0,80003f50 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fa2:	2184a783          	lw	a5,536(s1)
    80003fa6:	21c4a703          	lw	a4,540(s1)
    80003faa:	2007879b          	addw	a5,a5,512
    80003fae:	fcf704e3          	beq	a4,a5,80003f76 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fb2:	4685                	li	a3,1
    80003fb4:	01590633          	add	a2,s2,s5
    80003fb8:	faf40593          	add	a1,s0,-81
    80003fbc:	0509b503          	ld	a0,80(s3)
    80003fc0:	ffffd097          	auipc	ra,0xffffd
    80003fc4:	c28080e7          	jalr	-984(ra) # 80000be8 <copyin>
    80003fc8:	03650263          	beq	a0,s6,80003fec <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fcc:	21c4a783          	lw	a5,540(s1)
    80003fd0:	0017871b          	addw	a4,a5,1
    80003fd4:	20e4ae23          	sw	a4,540(s1)
    80003fd8:	1ff7f793          	and	a5,a5,511
    80003fdc:	97a6                	add	a5,a5,s1
    80003fde:	faf44703          	lbu	a4,-81(s0)
    80003fe2:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fe6:	2905                	addw	s2,s2,1
    80003fe8:	b755                	j	80003f8c <pipewrite+0x80>
  int i = 0;
    80003fea:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fec:	21848513          	add	a0,s1,536
    80003ff0:	ffffd097          	auipc	ra,0xffffd
    80003ff4:	5c4080e7          	jalr	1476(ra) # 800015b4 <wakeup>
  release(&pi->lock);
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	00002097          	auipc	ra,0x2
    80003ffe:	278080e7          	jalr	632(ra) # 80006272 <release>
  return i;
    80004002:	bfa9                	j	80003f5c <pipewrite+0x50>

0000000080004004 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004004:	715d                	add	sp,sp,-80
    80004006:	e486                	sd	ra,72(sp)
    80004008:	e0a2                	sd	s0,64(sp)
    8000400a:	fc26                	sd	s1,56(sp)
    8000400c:	f84a                	sd	s2,48(sp)
    8000400e:	f44e                	sd	s3,40(sp)
    80004010:	f052                	sd	s4,32(sp)
    80004012:	ec56                	sd	s5,24(sp)
    80004014:	e85a                	sd	s6,16(sp)
    80004016:	0880                	add	s0,sp,80
    80004018:	84aa                	mv	s1,a0
    8000401a:	892e                	mv	s2,a1
    8000401c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	e7e080e7          	jalr	-386(ra) # 80000e9c <myproc>
    80004026:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004028:	8526                	mv	a0,s1
    8000402a:	00002097          	auipc	ra,0x2
    8000402e:	194080e7          	jalr	404(ra) # 800061be <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004032:	2184a703          	lw	a4,536(s1)
    80004036:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000403a:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000403e:	02f71763          	bne	a4,a5,8000406c <piperead+0x68>
    80004042:	2244a783          	lw	a5,548(s1)
    80004046:	c39d                	beqz	a5,8000406c <piperead+0x68>
    if(killed(pr)){
    80004048:	8552                	mv	a0,s4
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	7ae080e7          	jalr	1966(ra) # 800017f8 <killed>
    80004052:	e949                	bnez	a0,800040e4 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004054:	85a6                	mv	a1,s1
    80004056:	854e                	mv	a0,s3
    80004058:	ffffd097          	auipc	ra,0xffffd
    8000405c:	4f8080e7          	jalr	1272(ra) # 80001550 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004060:	2184a703          	lw	a4,536(s1)
    80004064:	21c4a783          	lw	a5,540(s1)
    80004068:	fcf70de3          	beq	a4,a5,80004042 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000406c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000406e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004070:	05505463          	blez	s5,800040b8 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004074:	2184a783          	lw	a5,536(s1)
    80004078:	21c4a703          	lw	a4,540(s1)
    8000407c:	02f70e63          	beq	a4,a5,800040b8 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004080:	0017871b          	addw	a4,a5,1
    80004084:	20e4ac23          	sw	a4,536(s1)
    80004088:	1ff7f793          	and	a5,a5,511
    8000408c:	97a6                	add	a5,a5,s1
    8000408e:	0187c783          	lbu	a5,24(a5)
    80004092:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004096:	4685                	li	a3,1
    80004098:	fbf40613          	add	a2,s0,-65
    8000409c:	85ca                	mv	a1,s2
    8000409e:	050a3503          	ld	a0,80(s4)
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	aba080e7          	jalr	-1350(ra) # 80000b5c <copyout>
    800040aa:	01650763          	beq	a0,s6,800040b8 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ae:	2985                	addw	s3,s3,1
    800040b0:	0905                	add	s2,s2,1
    800040b2:	fd3a91e3          	bne	s5,s3,80004074 <piperead+0x70>
    800040b6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040b8:	21c48513          	add	a0,s1,540
    800040bc:	ffffd097          	auipc	ra,0xffffd
    800040c0:	4f8080e7          	jalr	1272(ra) # 800015b4 <wakeup>
  release(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	00002097          	auipc	ra,0x2
    800040ca:	1ac080e7          	jalr	428(ra) # 80006272 <release>
  return i;
}
    800040ce:	854e                	mv	a0,s3
    800040d0:	60a6                	ld	ra,72(sp)
    800040d2:	6406                	ld	s0,64(sp)
    800040d4:	74e2                	ld	s1,56(sp)
    800040d6:	7942                	ld	s2,48(sp)
    800040d8:	79a2                	ld	s3,40(sp)
    800040da:	7a02                	ld	s4,32(sp)
    800040dc:	6ae2                	ld	s5,24(sp)
    800040de:	6b42                	ld	s6,16(sp)
    800040e0:	6161                	add	sp,sp,80
    800040e2:	8082                	ret
      release(&pi->lock);
    800040e4:	8526                	mv	a0,s1
    800040e6:	00002097          	auipc	ra,0x2
    800040ea:	18c080e7          	jalr	396(ra) # 80006272 <release>
      return -1;
    800040ee:	59fd                	li	s3,-1
    800040f0:	bff9                	j	800040ce <piperead+0xca>

00000000800040f2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040f2:	1141                	add	sp,sp,-16
    800040f4:	e422                	sd	s0,8(sp)
    800040f6:	0800                	add	s0,sp,16
    800040f8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040fa:	8905                	and	a0,a0,1
    800040fc:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800040fe:	8b89                	and	a5,a5,2
    80004100:	c399                	beqz	a5,80004106 <flags2perm+0x14>
      perm |= PTE_W;
    80004102:	00456513          	or	a0,a0,4
    return perm;
}
    80004106:	6422                	ld	s0,8(sp)
    80004108:	0141                	add	sp,sp,16
    8000410a:	8082                	ret

000000008000410c <exec>:

int
exec(char *path, char **argv)
{
    8000410c:	df010113          	add	sp,sp,-528
    80004110:	20113423          	sd	ra,520(sp)
    80004114:	20813023          	sd	s0,512(sp)
    80004118:	ffa6                	sd	s1,504(sp)
    8000411a:	fbca                	sd	s2,496(sp)
    8000411c:	f7ce                	sd	s3,488(sp)
    8000411e:	f3d2                	sd	s4,480(sp)
    80004120:	efd6                	sd	s5,472(sp)
    80004122:	ebda                	sd	s6,464(sp)
    80004124:	e7de                	sd	s7,456(sp)
    80004126:	e3e2                	sd	s8,448(sp)
    80004128:	ff66                	sd	s9,440(sp)
    8000412a:	fb6a                	sd	s10,432(sp)
    8000412c:	f76e                	sd	s11,424(sp)
    8000412e:	0c00                	add	s0,sp,528
    80004130:	892a                	mv	s2,a0
    80004132:	dea43c23          	sd	a0,-520(s0)
    80004136:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	d62080e7          	jalr	-670(ra) # 80000e9c <myproc>
    80004142:	84aa                	mv	s1,a0

  begin_op();
    80004144:	fffff097          	auipc	ra,0xfffff
    80004148:	48e080e7          	jalr	1166(ra) # 800035d2 <begin_op>

  if((ip = namei(path)) == 0){
    8000414c:	854a                	mv	a0,s2
    8000414e:	fffff097          	auipc	ra,0xfffff
    80004152:	284080e7          	jalr	644(ra) # 800033d2 <namei>
    80004156:	c92d                	beqz	a0,800041c8 <exec+0xbc>
    80004158:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	ad2080e7          	jalr	-1326(ra) # 80002c2c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004162:	04000713          	li	a4,64
    80004166:	4681                	li	a3,0
    80004168:	e5040613          	add	a2,s0,-432
    8000416c:	4581                	li	a1,0
    8000416e:	8552                	mv	a0,s4
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	d70080e7          	jalr	-656(ra) # 80002ee0 <readi>
    80004178:	04000793          	li	a5,64
    8000417c:	00f51a63          	bne	a0,a5,80004190 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004180:	e5042703          	lw	a4,-432(s0)
    80004184:	464c47b7          	lui	a5,0x464c4
    80004188:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000418c:	04f70463          	beq	a4,a5,800041d4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004190:	8552                	mv	a0,s4
    80004192:	fffff097          	auipc	ra,0xfffff
    80004196:	cfc080e7          	jalr	-772(ra) # 80002e8e <iunlockput>
    end_op();
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	4b2080e7          	jalr	1202(ra) # 8000364c <end_op>
  }
  return -1;
    800041a2:	557d                	li	a0,-1
}
    800041a4:	20813083          	ld	ra,520(sp)
    800041a8:	20013403          	ld	s0,512(sp)
    800041ac:	74fe                	ld	s1,504(sp)
    800041ae:	795e                	ld	s2,496(sp)
    800041b0:	79be                	ld	s3,488(sp)
    800041b2:	7a1e                	ld	s4,480(sp)
    800041b4:	6afe                	ld	s5,472(sp)
    800041b6:	6b5e                	ld	s6,464(sp)
    800041b8:	6bbe                	ld	s7,456(sp)
    800041ba:	6c1e                	ld	s8,448(sp)
    800041bc:	7cfa                	ld	s9,440(sp)
    800041be:	7d5a                	ld	s10,432(sp)
    800041c0:	7dba                	ld	s11,424(sp)
    800041c2:	21010113          	add	sp,sp,528
    800041c6:	8082                	ret
    end_op();
    800041c8:	fffff097          	auipc	ra,0xfffff
    800041cc:	484080e7          	jalr	1156(ra) # 8000364c <end_op>
    return -1;
    800041d0:	557d                	li	a0,-1
    800041d2:	bfc9                	j	800041a4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041d4:	8526                	mv	a0,s1
    800041d6:	ffffd097          	auipc	ra,0xffffd
    800041da:	d8a080e7          	jalr	-630(ra) # 80000f60 <proc_pagetable>
    800041de:	8b2a                	mv	s6,a0
    800041e0:	d945                	beqz	a0,80004190 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041e2:	e7042d03          	lw	s10,-400(s0)
    800041e6:	e8845783          	lhu	a5,-376(s0)
    800041ea:	10078463          	beqz	a5,800042f2 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ee:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f0:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800041f2:	6c85                	lui	s9,0x1
    800041f4:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041f8:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800041fc:	6a85                	lui	s5,0x1
    800041fe:	a0b5                	j	8000426a <exec+0x15e>
      panic("loadseg: address should exist");
    80004200:	00004517          	auipc	a0,0x4
    80004204:	5e050513          	add	a0,a0,1504 # 800087e0 <syscall_names+0x288>
    80004208:	00002097          	auipc	ra,0x2
    8000420c:	a7e080e7          	jalr	-1410(ra) # 80005c86 <panic>
    if(sz - i < PGSIZE)
    80004210:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004212:	8726                	mv	a4,s1
    80004214:	012c06bb          	addw	a3,s8,s2
    80004218:	4581                	li	a1,0
    8000421a:	8552                	mv	a0,s4
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	cc4080e7          	jalr	-828(ra) # 80002ee0 <readi>
    80004224:	2501                	sext.w	a0,a0
    80004226:	24a49863          	bne	s1,a0,80004476 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    8000422a:	012a893b          	addw	s2,s5,s2
    8000422e:	03397563          	bgeu	s2,s3,80004258 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004232:	02091593          	sll	a1,s2,0x20
    80004236:	9181                	srl	a1,a1,0x20
    80004238:	95de                	add	a1,a1,s7
    8000423a:	855a                	mv	a0,s6
    8000423c:	ffffc097          	auipc	ra,0xffffc
    80004240:	310080e7          	jalr	784(ra) # 8000054c <walkaddr>
    80004244:	862a                	mv	a2,a0
    if(pa == 0)
    80004246:	dd4d                	beqz	a0,80004200 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004248:	412984bb          	subw	s1,s3,s2
    8000424c:	0004879b          	sext.w	a5,s1
    80004250:	fcfcf0e3          	bgeu	s9,a5,80004210 <exec+0x104>
    80004254:	84d6                	mv	s1,s5
    80004256:	bf6d                	j	80004210 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004258:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000425c:	2d85                	addw	s11,s11,1
    8000425e:	038d0d1b          	addw	s10,s10,56
    80004262:	e8845783          	lhu	a5,-376(s0)
    80004266:	08fdd763          	bge	s11,a5,800042f4 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000426a:	2d01                	sext.w	s10,s10
    8000426c:	03800713          	li	a4,56
    80004270:	86ea                	mv	a3,s10
    80004272:	e1840613          	add	a2,s0,-488
    80004276:	4581                	li	a1,0
    80004278:	8552                	mv	a0,s4
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	c66080e7          	jalr	-922(ra) # 80002ee0 <readi>
    80004282:	03800793          	li	a5,56
    80004286:	1ef51663          	bne	a0,a5,80004472 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    8000428a:	e1842783          	lw	a5,-488(s0)
    8000428e:	4705                	li	a4,1
    80004290:	fce796e3          	bne	a5,a4,8000425c <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004294:	e4043483          	ld	s1,-448(s0)
    80004298:	e3843783          	ld	a5,-456(s0)
    8000429c:	1ef4e863          	bltu	s1,a5,8000448c <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042a0:	e2843783          	ld	a5,-472(s0)
    800042a4:	94be                	add	s1,s1,a5
    800042a6:	1ef4e663          	bltu	s1,a5,80004492 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800042aa:	df043703          	ld	a4,-528(s0)
    800042ae:	8ff9                	and	a5,a5,a4
    800042b0:	1e079463          	bnez	a5,80004498 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042b4:	e1c42503          	lw	a0,-484(s0)
    800042b8:	00000097          	auipc	ra,0x0
    800042bc:	e3a080e7          	jalr	-454(ra) # 800040f2 <flags2perm>
    800042c0:	86aa                	mv	a3,a0
    800042c2:	8626                	mv	a2,s1
    800042c4:	85ca                	mv	a1,s2
    800042c6:	855a                	mv	a0,s6
    800042c8:	ffffc097          	auipc	ra,0xffffc
    800042cc:	638080e7          	jalr	1592(ra) # 80000900 <uvmalloc>
    800042d0:	e0a43423          	sd	a0,-504(s0)
    800042d4:	1c050563          	beqz	a0,8000449e <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042d8:	e2843b83          	ld	s7,-472(s0)
    800042dc:	e2042c03          	lw	s8,-480(s0)
    800042e0:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042e4:	00098463          	beqz	s3,800042ec <exec+0x1e0>
    800042e8:	4901                	li	s2,0
    800042ea:	b7a1                	j	80004232 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042ec:	e0843903          	ld	s2,-504(s0)
    800042f0:	b7b5                	j	8000425c <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042f2:	4901                	li	s2,0
  iunlockput(ip);
    800042f4:	8552                	mv	a0,s4
    800042f6:	fffff097          	auipc	ra,0xfffff
    800042fa:	b98080e7          	jalr	-1128(ra) # 80002e8e <iunlockput>
  end_op();
    800042fe:	fffff097          	auipc	ra,0xfffff
    80004302:	34e080e7          	jalr	846(ra) # 8000364c <end_op>
  p = myproc();
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	b96080e7          	jalr	-1130(ra) # 80000e9c <myproc>
    8000430e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004310:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004314:	6985                	lui	s3,0x1
    80004316:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004318:	99ca                	add	s3,s3,s2
    8000431a:	77fd                	lui	a5,0xfffff
    8000431c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004320:	4691                	li	a3,4
    80004322:	6609                	lui	a2,0x2
    80004324:	964e                	add	a2,a2,s3
    80004326:	85ce                	mv	a1,s3
    80004328:	855a                	mv	a0,s6
    8000432a:	ffffc097          	auipc	ra,0xffffc
    8000432e:	5d6080e7          	jalr	1494(ra) # 80000900 <uvmalloc>
    80004332:	892a                	mv	s2,a0
    80004334:	e0a43423          	sd	a0,-504(s0)
    80004338:	e509                	bnez	a0,80004342 <exec+0x236>
  if(pagetable)
    8000433a:	e1343423          	sd	s3,-504(s0)
    8000433e:	4a01                	li	s4,0
    80004340:	aa1d                	j	80004476 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004342:	75f9                	lui	a1,0xffffe
    80004344:	95aa                	add	a1,a1,a0
    80004346:	855a                	mv	a0,s6
    80004348:	ffffc097          	auipc	ra,0xffffc
    8000434c:	7e2080e7          	jalr	2018(ra) # 80000b2a <uvmclear>
  stackbase = sp - PGSIZE;
    80004350:	7bfd                	lui	s7,0xfffff
    80004352:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004354:	e0043783          	ld	a5,-512(s0)
    80004358:	6388                	ld	a0,0(a5)
    8000435a:	c52d                	beqz	a0,800043c4 <exec+0x2b8>
    8000435c:	e9040993          	add	s3,s0,-368
    80004360:	f9040c13          	add	s8,s0,-112
    80004364:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004366:	ffffc097          	auipc	ra,0xffffc
    8000436a:	fd8080e7          	jalr	-40(ra) # 8000033e <strlen>
    8000436e:	0015079b          	addw	a5,a0,1
    80004372:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004376:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    8000437a:	13796563          	bltu	s2,s7,800044a4 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000437e:	e0043d03          	ld	s10,-512(s0)
    80004382:	000d3a03          	ld	s4,0(s10)
    80004386:	8552                	mv	a0,s4
    80004388:	ffffc097          	auipc	ra,0xffffc
    8000438c:	fb6080e7          	jalr	-74(ra) # 8000033e <strlen>
    80004390:	0015069b          	addw	a3,a0,1
    80004394:	8652                	mv	a2,s4
    80004396:	85ca                	mv	a1,s2
    80004398:	855a                	mv	a0,s6
    8000439a:	ffffc097          	auipc	ra,0xffffc
    8000439e:	7c2080e7          	jalr	1986(ra) # 80000b5c <copyout>
    800043a2:	10054363          	bltz	a0,800044a8 <exec+0x39c>
    ustack[argc] = sp;
    800043a6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043aa:	0485                	add	s1,s1,1
    800043ac:	008d0793          	add	a5,s10,8
    800043b0:	e0f43023          	sd	a5,-512(s0)
    800043b4:	008d3503          	ld	a0,8(s10)
    800043b8:	c909                	beqz	a0,800043ca <exec+0x2be>
    if(argc >= MAXARG)
    800043ba:	09a1                	add	s3,s3,8
    800043bc:	fb8995e3          	bne	s3,s8,80004366 <exec+0x25a>
  ip = 0;
    800043c0:	4a01                	li	s4,0
    800043c2:	a855                	j	80004476 <exec+0x36a>
  sp = sz;
    800043c4:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043c8:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ca:	00349793          	sll	a5,s1,0x3
    800043ce:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdced0>
    800043d2:	97a2                	add	a5,a5,s0
    800043d4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043d8:	00148693          	add	a3,s1,1
    800043dc:	068e                	sll	a3,a3,0x3
    800043de:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043e2:	ff097913          	and	s2,s2,-16
  sz = sz1;
    800043e6:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800043ea:	f57968e3          	bltu	s2,s7,8000433a <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043ee:	e9040613          	add	a2,s0,-368
    800043f2:	85ca                	mv	a1,s2
    800043f4:	855a                	mv	a0,s6
    800043f6:	ffffc097          	auipc	ra,0xffffc
    800043fa:	766080e7          	jalr	1894(ra) # 80000b5c <copyout>
    800043fe:	0a054763          	bltz	a0,800044ac <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004402:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004406:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000440a:	df843783          	ld	a5,-520(s0)
    8000440e:	0007c703          	lbu	a4,0(a5)
    80004412:	cf11                	beqz	a4,8000442e <exec+0x322>
    80004414:	0785                	add	a5,a5,1
    if(*s == '/')
    80004416:	02f00693          	li	a3,47
    8000441a:	a039                	j	80004428 <exec+0x31c>
      last = s+1;
    8000441c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004420:	0785                	add	a5,a5,1
    80004422:	fff7c703          	lbu	a4,-1(a5)
    80004426:	c701                	beqz	a4,8000442e <exec+0x322>
    if(*s == '/')
    80004428:	fed71ce3          	bne	a4,a3,80004420 <exec+0x314>
    8000442c:	bfc5                	j	8000441c <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    8000442e:	4641                	li	a2,16
    80004430:	df843583          	ld	a1,-520(s0)
    80004434:	158a8513          	add	a0,s5,344
    80004438:	ffffc097          	auipc	ra,0xffffc
    8000443c:	ed4080e7          	jalr	-300(ra) # 8000030c <safestrcpy>
  oldpagetable = p->pagetable;
    80004440:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004444:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004448:	e0843783          	ld	a5,-504(s0)
    8000444c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004450:	058ab783          	ld	a5,88(s5)
    80004454:	e6843703          	ld	a4,-408(s0)
    80004458:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000445a:	058ab783          	ld	a5,88(s5)
    8000445e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004462:	85e6                	mv	a1,s9
    80004464:	ffffd097          	auipc	ra,0xffffd
    80004468:	b98080e7          	jalr	-1128(ra) # 80000ffc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000446c:	0004851b          	sext.w	a0,s1
    80004470:	bb15                	j	800041a4 <exec+0x98>
    80004472:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004476:	e0843583          	ld	a1,-504(s0)
    8000447a:	855a                	mv	a0,s6
    8000447c:	ffffd097          	auipc	ra,0xffffd
    80004480:	b80080e7          	jalr	-1152(ra) # 80000ffc <proc_freepagetable>
  return -1;
    80004484:	557d                	li	a0,-1
  if(ip){
    80004486:	d00a0fe3          	beqz	s4,800041a4 <exec+0x98>
    8000448a:	b319                	j	80004190 <exec+0x84>
    8000448c:	e1243423          	sd	s2,-504(s0)
    80004490:	b7dd                	j	80004476 <exec+0x36a>
    80004492:	e1243423          	sd	s2,-504(s0)
    80004496:	b7c5                	j	80004476 <exec+0x36a>
    80004498:	e1243423          	sd	s2,-504(s0)
    8000449c:	bfe9                	j	80004476 <exec+0x36a>
    8000449e:	e1243423          	sd	s2,-504(s0)
    800044a2:	bfd1                	j	80004476 <exec+0x36a>
  ip = 0;
    800044a4:	4a01                	li	s4,0
    800044a6:	bfc1                	j	80004476 <exec+0x36a>
    800044a8:	4a01                	li	s4,0
  if(pagetable)
    800044aa:	b7f1                	j	80004476 <exec+0x36a>
  sz = sz1;
    800044ac:	e0843983          	ld	s3,-504(s0)
    800044b0:	b569                	j	8000433a <exec+0x22e>

00000000800044b2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044b2:	7179                	add	sp,sp,-48
    800044b4:	f406                	sd	ra,40(sp)
    800044b6:	f022                	sd	s0,32(sp)
    800044b8:	ec26                	sd	s1,24(sp)
    800044ba:	e84a                	sd	s2,16(sp)
    800044bc:	1800                	add	s0,sp,48
    800044be:	892e                	mv	s2,a1
    800044c0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044c2:	fdc40593          	add	a1,s0,-36
    800044c6:	ffffe097          	auipc	ra,0xffffe
    800044ca:	b2c080e7          	jalr	-1236(ra) # 80001ff2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044ce:	fdc42703          	lw	a4,-36(s0)
    800044d2:	47bd                	li	a5,15
    800044d4:	02e7eb63          	bltu	a5,a4,8000450a <argfd+0x58>
    800044d8:	ffffd097          	auipc	ra,0xffffd
    800044dc:	9c4080e7          	jalr	-1596(ra) # 80000e9c <myproc>
    800044e0:	fdc42703          	lw	a4,-36(s0)
    800044e4:	01a70793          	add	a5,a4,26
    800044e8:	078e                	sll	a5,a5,0x3
    800044ea:	953e                	add	a0,a0,a5
    800044ec:	611c                	ld	a5,0(a0)
    800044ee:	c385                	beqz	a5,8000450e <argfd+0x5c>
    return -1;
  if(pfd)
    800044f0:	00090463          	beqz	s2,800044f8 <argfd+0x46>
    *pfd = fd;
    800044f4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044f8:	4501                	li	a0,0
  if(pf)
    800044fa:	c091                	beqz	s1,800044fe <argfd+0x4c>
    *pf = f;
    800044fc:	e09c                	sd	a5,0(s1)
}
    800044fe:	70a2                	ld	ra,40(sp)
    80004500:	7402                	ld	s0,32(sp)
    80004502:	64e2                	ld	s1,24(sp)
    80004504:	6942                	ld	s2,16(sp)
    80004506:	6145                	add	sp,sp,48
    80004508:	8082                	ret
    return -1;
    8000450a:	557d                	li	a0,-1
    8000450c:	bfcd                	j	800044fe <argfd+0x4c>
    8000450e:	557d                	li	a0,-1
    80004510:	b7fd                	j	800044fe <argfd+0x4c>

0000000080004512 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004512:	1101                	add	sp,sp,-32
    80004514:	ec06                	sd	ra,24(sp)
    80004516:	e822                	sd	s0,16(sp)
    80004518:	e426                	sd	s1,8(sp)
    8000451a:	1000                	add	s0,sp,32
    8000451c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000451e:	ffffd097          	auipc	ra,0xffffd
    80004522:	97e080e7          	jalr	-1666(ra) # 80000e9c <myproc>
    80004526:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004528:	0d050793          	add	a5,a0,208
    8000452c:	4501                	li	a0,0
    8000452e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004530:	6398                	ld	a4,0(a5)
    80004532:	cb19                	beqz	a4,80004548 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004534:	2505                	addw	a0,a0,1
    80004536:	07a1                	add	a5,a5,8
    80004538:	fed51ce3          	bne	a0,a3,80004530 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000453c:	557d                	li	a0,-1
}
    8000453e:	60e2                	ld	ra,24(sp)
    80004540:	6442                	ld	s0,16(sp)
    80004542:	64a2                	ld	s1,8(sp)
    80004544:	6105                	add	sp,sp,32
    80004546:	8082                	ret
      p->ofile[fd] = f;
    80004548:	01a50793          	add	a5,a0,26
    8000454c:	078e                	sll	a5,a5,0x3
    8000454e:	963e                	add	a2,a2,a5
    80004550:	e204                	sd	s1,0(a2)
      return fd;
    80004552:	b7f5                	j	8000453e <fdalloc+0x2c>

0000000080004554 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004554:	715d                	add	sp,sp,-80
    80004556:	e486                	sd	ra,72(sp)
    80004558:	e0a2                	sd	s0,64(sp)
    8000455a:	fc26                	sd	s1,56(sp)
    8000455c:	f84a                	sd	s2,48(sp)
    8000455e:	f44e                	sd	s3,40(sp)
    80004560:	f052                	sd	s4,32(sp)
    80004562:	ec56                	sd	s5,24(sp)
    80004564:	e85a                	sd	s6,16(sp)
    80004566:	0880                	add	s0,sp,80
    80004568:	8b2e                	mv	s6,a1
    8000456a:	89b2                	mv	s3,a2
    8000456c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000456e:	fb040593          	add	a1,s0,-80
    80004572:	fffff097          	auipc	ra,0xfffff
    80004576:	e7e080e7          	jalr	-386(ra) # 800033f0 <nameiparent>
    8000457a:	84aa                	mv	s1,a0
    8000457c:	14050b63          	beqz	a0,800046d2 <create+0x17e>
    return 0;

  ilock(dp);
    80004580:	ffffe097          	auipc	ra,0xffffe
    80004584:	6ac080e7          	jalr	1708(ra) # 80002c2c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004588:	4601                	li	a2,0
    8000458a:	fb040593          	add	a1,s0,-80
    8000458e:	8526                	mv	a0,s1
    80004590:	fffff097          	auipc	ra,0xfffff
    80004594:	b80080e7          	jalr	-1152(ra) # 80003110 <dirlookup>
    80004598:	8aaa                	mv	s5,a0
    8000459a:	c921                	beqz	a0,800045ea <create+0x96>
    iunlockput(dp);
    8000459c:	8526                	mv	a0,s1
    8000459e:	fffff097          	auipc	ra,0xfffff
    800045a2:	8f0080e7          	jalr	-1808(ra) # 80002e8e <iunlockput>
    ilock(ip);
    800045a6:	8556                	mv	a0,s5
    800045a8:	ffffe097          	auipc	ra,0xffffe
    800045ac:	684080e7          	jalr	1668(ra) # 80002c2c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045b0:	4789                	li	a5,2
    800045b2:	02fb1563          	bne	s6,a5,800045dc <create+0x88>
    800045b6:	044ad783          	lhu	a5,68(s5)
    800045ba:	37f9                	addw	a5,a5,-2
    800045bc:	17c2                	sll	a5,a5,0x30
    800045be:	93c1                	srl	a5,a5,0x30
    800045c0:	4705                	li	a4,1
    800045c2:	00f76d63          	bltu	a4,a5,800045dc <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045c6:	8556                	mv	a0,s5
    800045c8:	60a6                	ld	ra,72(sp)
    800045ca:	6406                	ld	s0,64(sp)
    800045cc:	74e2                	ld	s1,56(sp)
    800045ce:	7942                	ld	s2,48(sp)
    800045d0:	79a2                	ld	s3,40(sp)
    800045d2:	7a02                	ld	s4,32(sp)
    800045d4:	6ae2                	ld	s5,24(sp)
    800045d6:	6b42                	ld	s6,16(sp)
    800045d8:	6161                	add	sp,sp,80
    800045da:	8082                	ret
    iunlockput(ip);
    800045dc:	8556                	mv	a0,s5
    800045de:	fffff097          	auipc	ra,0xfffff
    800045e2:	8b0080e7          	jalr	-1872(ra) # 80002e8e <iunlockput>
    return 0;
    800045e6:	4a81                	li	s5,0
    800045e8:	bff9                	j	800045c6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045ea:	85da                	mv	a1,s6
    800045ec:	4088                	lw	a0,0(s1)
    800045ee:	ffffe097          	auipc	ra,0xffffe
    800045f2:	4a6080e7          	jalr	1190(ra) # 80002a94 <ialloc>
    800045f6:	8a2a                	mv	s4,a0
    800045f8:	c529                	beqz	a0,80004642 <create+0xee>
  ilock(ip);
    800045fa:	ffffe097          	auipc	ra,0xffffe
    800045fe:	632080e7          	jalr	1586(ra) # 80002c2c <ilock>
  ip->major = major;
    80004602:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004606:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000460a:	4905                	li	s2,1
    8000460c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004610:	8552                	mv	a0,s4
    80004612:	ffffe097          	auipc	ra,0xffffe
    80004616:	54e080e7          	jalr	1358(ra) # 80002b60 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000461a:	032b0b63          	beq	s6,s2,80004650 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000461e:	004a2603          	lw	a2,4(s4)
    80004622:	fb040593          	add	a1,s0,-80
    80004626:	8526                	mv	a0,s1
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	cf8080e7          	jalr	-776(ra) # 80003320 <dirlink>
    80004630:	06054f63          	bltz	a0,800046ae <create+0x15a>
  iunlockput(dp);
    80004634:	8526                	mv	a0,s1
    80004636:	fffff097          	auipc	ra,0xfffff
    8000463a:	858080e7          	jalr	-1960(ra) # 80002e8e <iunlockput>
  return ip;
    8000463e:	8ad2                	mv	s5,s4
    80004640:	b759                	j	800045c6 <create+0x72>
    iunlockput(dp);
    80004642:	8526                	mv	a0,s1
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	84a080e7          	jalr	-1974(ra) # 80002e8e <iunlockput>
    return 0;
    8000464c:	8ad2                	mv	s5,s4
    8000464e:	bfa5                	j	800045c6 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004650:	004a2603          	lw	a2,4(s4)
    80004654:	00004597          	auipc	a1,0x4
    80004658:	1ac58593          	add	a1,a1,428 # 80008800 <syscall_names+0x2a8>
    8000465c:	8552                	mv	a0,s4
    8000465e:	fffff097          	auipc	ra,0xfffff
    80004662:	cc2080e7          	jalr	-830(ra) # 80003320 <dirlink>
    80004666:	04054463          	bltz	a0,800046ae <create+0x15a>
    8000466a:	40d0                	lw	a2,4(s1)
    8000466c:	00004597          	auipc	a1,0x4
    80004670:	19c58593          	add	a1,a1,412 # 80008808 <syscall_names+0x2b0>
    80004674:	8552                	mv	a0,s4
    80004676:	fffff097          	auipc	ra,0xfffff
    8000467a:	caa080e7          	jalr	-854(ra) # 80003320 <dirlink>
    8000467e:	02054863          	bltz	a0,800046ae <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004682:	004a2603          	lw	a2,4(s4)
    80004686:	fb040593          	add	a1,s0,-80
    8000468a:	8526                	mv	a0,s1
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	c94080e7          	jalr	-876(ra) # 80003320 <dirlink>
    80004694:	00054d63          	bltz	a0,800046ae <create+0x15a>
    dp->nlink++;  // for ".."
    80004698:	04a4d783          	lhu	a5,74(s1)
    8000469c:	2785                	addw	a5,a5,1
    8000469e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046a2:	8526                	mv	a0,s1
    800046a4:	ffffe097          	auipc	ra,0xffffe
    800046a8:	4bc080e7          	jalr	1212(ra) # 80002b60 <iupdate>
    800046ac:	b761                	j	80004634 <create+0xe0>
  ip->nlink = 0;
    800046ae:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046b2:	8552                	mv	a0,s4
    800046b4:	ffffe097          	auipc	ra,0xffffe
    800046b8:	4ac080e7          	jalr	1196(ra) # 80002b60 <iupdate>
  iunlockput(ip);
    800046bc:	8552                	mv	a0,s4
    800046be:	ffffe097          	auipc	ra,0xffffe
    800046c2:	7d0080e7          	jalr	2000(ra) # 80002e8e <iunlockput>
  iunlockput(dp);
    800046c6:	8526                	mv	a0,s1
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	7c6080e7          	jalr	1990(ra) # 80002e8e <iunlockput>
  return 0;
    800046d0:	bddd                	j	800045c6 <create+0x72>
    return 0;
    800046d2:	8aaa                	mv	s5,a0
    800046d4:	bdcd                	j	800045c6 <create+0x72>

00000000800046d6 <sys_dup>:
{
    800046d6:	7179                	add	sp,sp,-48
    800046d8:	f406                	sd	ra,40(sp)
    800046da:	f022                	sd	s0,32(sp)
    800046dc:	ec26                	sd	s1,24(sp)
    800046de:	e84a                	sd	s2,16(sp)
    800046e0:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046e2:	fd840613          	add	a2,s0,-40
    800046e6:	4581                	li	a1,0
    800046e8:	4501                	li	a0,0
    800046ea:	00000097          	auipc	ra,0x0
    800046ee:	dc8080e7          	jalr	-568(ra) # 800044b2 <argfd>
    return -1;
    800046f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046f4:	02054363          	bltz	a0,8000471a <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800046f8:	fd843903          	ld	s2,-40(s0)
    800046fc:	854a                	mv	a0,s2
    800046fe:	00000097          	auipc	ra,0x0
    80004702:	e14080e7          	jalr	-492(ra) # 80004512 <fdalloc>
    80004706:	84aa                	mv	s1,a0
    return -1;
    80004708:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000470a:	00054863          	bltz	a0,8000471a <sys_dup+0x44>
  filedup(f);
    8000470e:	854a                	mv	a0,s2
    80004710:	fffff097          	auipc	ra,0xfffff
    80004714:	334080e7          	jalr	820(ra) # 80003a44 <filedup>
  return fd;
    80004718:	87a6                	mv	a5,s1
}
    8000471a:	853e                	mv	a0,a5
    8000471c:	70a2                	ld	ra,40(sp)
    8000471e:	7402                	ld	s0,32(sp)
    80004720:	64e2                	ld	s1,24(sp)
    80004722:	6942                	ld	s2,16(sp)
    80004724:	6145                	add	sp,sp,48
    80004726:	8082                	ret

0000000080004728 <sys_read>:
{
    80004728:	7179                	add	sp,sp,-48
    8000472a:	f406                	sd	ra,40(sp)
    8000472c:	f022                	sd	s0,32(sp)
    8000472e:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004730:	fd840593          	add	a1,s0,-40
    80004734:	4505                	li	a0,1
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	8dc080e7          	jalr	-1828(ra) # 80002012 <argaddr>
  argint(2, &n);
    8000473e:	fe440593          	add	a1,s0,-28
    80004742:	4509                	li	a0,2
    80004744:	ffffe097          	auipc	ra,0xffffe
    80004748:	8ae080e7          	jalr	-1874(ra) # 80001ff2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000474c:	fe840613          	add	a2,s0,-24
    80004750:	4581                	li	a1,0
    80004752:	4501                	li	a0,0
    80004754:	00000097          	auipc	ra,0x0
    80004758:	d5e080e7          	jalr	-674(ra) # 800044b2 <argfd>
    8000475c:	87aa                	mv	a5,a0
    return -1;
    8000475e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004760:	0007cc63          	bltz	a5,80004778 <sys_read+0x50>
  return fileread(f, p, n);
    80004764:	fe442603          	lw	a2,-28(s0)
    80004768:	fd843583          	ld	a1,-40(s0)
    8000476c:	fe843503          	ld	a0,-24(s0)
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	460080e7          	jalr	1120(ra) # 80003bd0 <fileread>
}
    80004778:	70a2                	ld	ra,40(sp)
    8000477a:	7402                	ld	s0,32(sp)
    8000477c:	6145                	add	sp,sp,48
    8000477e:	8082                	ret

0000000080004780 <sys_write>:
{
    80004780:	7179                	add	sp,sp,-48
    80004782:	f406                	sd	ra,40(sp)
    80004784:	f022                	sd	s0,32(sp)
    80004786:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004788:	fd840593          	add	a1,s0,-40
    8000478c:	4505                	li	a0,1
    8000478e:	ffffe097          	auipc	ra,0xffffe
    80004792:	884080e7          	jalr	-1916(ra) # 80002012 <argaddr>
  argint(2, &n);
    80004796:	fe440593          	add	a1,s0,-28
    8000479a:	4509                	li	a0,2
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	856080e7          	jalr	-1962(ra) # 80001ff2 <argint>
  if(argfd(0, 0, &f) < 0)
    800047a4:	fe840613          	add	a2,s0,-24
    800047a8:	4581                	li	a1,0
    800047aa:	4501                	li	a0,0
    800047ac:	00000097          	auipc	ra,0x0
    800047b0:	d06080e7          	jalr	-762(ra) # 800044b2 <argfd>
    800047b4:	87aa                	mv	a5,a0
    return -1;
    800047b6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047b8:	0007cc63          	bltz	a5,800047d0 <sys_write+0x50>
  return filewrite(f, p, n);
    800047bc:	fe442603          	lw	a2,-28(s0)
    800047c0:	fd843583          	ld	a1,-40(s0)
    800047c4:	fe843503          	ld	a0,-24(s0)
    800047c8:	fffff097          	auipc	ra,0xfffff
    800047cc:	4ca080e7          	jalr	1226(ra) # 80003c92 <filewrite>
}
    800047d0:	70a2                	ld	ra,40(sp)
    800047d2:	7402                	ld	s0,32(sp)
    800047d4:	6145                	add	sp,sp,48
    800047d6:	8082                	ret

00000000800047d8 <sys_close>:
{
    800047d8:	1101                	add	sp,sp,-32
    800047da:	ec06                	sd	ra,24(sp)
    800047dc:	e822                	sd	s0,16(sp)
    800047de:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047e0:	fe040613          	add	a2,s0,-32
    800047e4:	fec40593          	add	a1,s0,-20
    800047e8:	4501                	li	a0,0
    800047ea:	00000097          	auipc	ra,0x0
    800047ee:	cc8080e7          	jalr	-824(ra) # 800044b2 <argfd>
    return -1;
    800047f2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047f4:	02054463          	bltz	a0,8000481c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047f8:	ffffc097          	auipc	ra,0xffffc
    800047fc:	6a4080e7          	jalr	1700(ra) # 80000e9c <myproc>
    80004800:	fec42783          	lw	a5,-20(s0)
    80004804:	07e9                	add	a5,a5,26
    80004806:	078e                	sll	a5,a5,0x3
    80004808:	953e                	add	a0,a0,a5
    8000480a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000480e:	fe043503          	ld	a0,-32(s0)
    80004812:	fffff097          	auipc	ra,0xfffff
    80004816:	284080e7          	jalr	644(ra) # 80003a96 <fileclose>
  return 0;
    8000481a:	4781                	li	a5,0
}
    8000481c:	853e                	mv	a0,a5
    8000481e:	60e2                	ld	ra,24(sp)
    80004820:	6442                	ld	s0,16(sp)
    80004822:	6105                	add	sp,sp,32
    80004824:	8082                	ret

0000000080004826 <sys_fstat>:
{
    80004826:	1101                	add	sp,sp,-32
    80004828:	ec06                	sd	ra,24(sp)
    8000482a:	e822                	sd	s0,16(sp)
    8000482c:	1000                	add	s0,sp,32
  argaddr(1, &st);
    8000482e:	fe040593          	add	a1,s0,-32
    80004832:	4505                	li	a0,1
    80004834:	ffffd097          	auipc	ra,0xffffd
    80004838:	7de080e7          	jalr	2014(ra) # 80002012 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000483c:	fe840613          	add	a2,s0,-24
    80004840:	4581                	li	a1,0
    80004842:	4501                	li	a0,0
    80004844:	00000097          	auipc	ra,0x0
    80004848:	c6e080e7          	jalr	-914(ra) # 800044b2 <argfd>
    8000484c:	87aa                	mv	a5,a0
    return -1;
    8000484e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004850:	0007ca63          	bltz	a5,80004864 <sys_fstat+0x3e>
  return filestat(f, st);
    80004854:	fe043583          	ld	a1,-32(s0)
    80004858:	fe843503          	ld	a0,-24(s0)
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	302080e7          	jalr	770(ra) # 80003b5e <filestat>
}
    80004864:	60e2                	ld	ra,24(sp)
    80004866:	6442                	ld	s0,16(sp)
    80004868:	6105                	add	sp,sp,32
    8000486a:	8082                	ret

000000008000486c <sys_link>:
{
    8000486c:	7169                	add	sp,sp,-304
    8000486e:	f606                	sd	ra,296(sp)
    80004870:	f222                	sd	s0,288(sp)
    80004872:	ee26                	sd	s1,280(sp)
    80004874:	ea4a                	sd	s2,272(sp)
    80004876:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004878:	08000613          	li	a2,128
    8000487c:	ed040593          	add	a1,s0,-304
    80004880:	4501                	li	a0,0
    80004882:	ffffd097          	auipc	ra,0xffffd
    80004886:	7b0080e7          	jalr	1968(ra) # 80002032 <argstr>
    return -1;
    8000488a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000488c:	10054e63          	bltz	a0,800049a8 <sys_link+0x13c>
    80004890:	08000613          	li	a2,128
    80004894:	f5040593          	add	a1,s0,-176
    80004898:	4505                	li	a0,1
    8000489a:	ffffd097          	auipc	ra,0xffffd
    8000489e:	798080e7          	jalr	1944(ra) # 80002032 <argstr>
    return -1;
    800048a2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048a4:	10054263          	bltz	a0,800049a8 <sys_link+0x13c>
  begin_op();
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	d2a080e7          	jalr	-726(ra) # 800035d2 <begin_op>
  if((ip = namei(old)) == 0){
    800048b0:	ed040513          	add	a0,s0,-304
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	b1e080e7          	jalr	-1250(ra) # 800033d2 <namei>
    800048bc:	84aa                	mv	s1,a0
    800048be:	c551                	beqz	a0,8000494a <sys_link+0xde>
  ilock(ip);
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	36c080e7          	jalr	876(ra) # 80002c2c <ilock>
  if(ip->type == T_DIR){
    800048c8:	04449703          	lh	a4,68(s1)
    800048cc:	4785                	li	a5,1
    800048ce:	08f70463          	beq	a4,a5,80004956 <sys_link+0xea>
  ip->nlink++;
    800048d2:	04a4d783          	lhu	a5,74(s1)
    800048d6:	2785                	addw	a5,a5,1
    800048d8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048dc:	8526                	mv	a0,s1
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	282080e7          	jalr	642(ra) # 80002b60 <iupdate>
  iunlock(ip);
    800048e6:	8526                	mv	a0,s1
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	406080e7          	jalr	1030(ra) # 80002cee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048f0:	fd040593          	add	a1,s0,-48
    800048f4:	f5040513          	add	a0,s0,-176
    800048f8:	fffff097          	auipc	ra,0xfffff
    800048fc:	af8080e7          	jalr	-1288(ra) # 800033f0 <nameiparent>
    80004900:	892a                	mv	s2,a0
    80004902:	c935                	beqz	a0,80004976 <sys_link+0x10a>
  ilock(dp);
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	328080e7          	jalr	808(ra) # 80002c2c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000490c:	00092703          	lw	a4,0(s2)
    80004910:	409c                	lw	a5,0(s1)
    80004912:	04f71d63          	bne	a4,a5,8000496c <sys_link+0x100>
    80004916:	40d0                	lw	a2,4(s1)
    80004918:	fd040593          	add	a1,s0,-48
    8000491c:	854a                	mv	a0,s2
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	a02080e7          	jalr	-1534(ra) # 80003320 <dirlink>
    80004926:	04054363          	bltz	a0,8000496c <sys_link+0x100>
  iunlockput(dp);
    8000492a:	854a                	mv	a0,s2
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	562080e7          	jalr	1378(ra) # 80002e8e <iunlockput>
  iput(ip);
    80004934:	8526                	mv	a0,s1
    80004936:	ffffe097          	auipc	ra,0xffffe
    8000493a:	4b0080e7          	jalr	1200(ra) # 80002de6 <iput>
  end_op();
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	d0e080e7          	jalr	-754(ra) # 8000364c <end_op>
  return 0;
    80004946:	4781                	li	a5,0
    80004948:	a085                	j	800049a8 <sys_link+0x13c>
    end_op();
    8000494a:	fffff097          	auipc	ra,0xfffff
    8000494e:	d02080e7          	jalr	-766(ra) # 8000364c <end_op>
    return -1;
    80004952:	57fd                	li	a5,-1
    80004954:	a891                	j	800049a8 <sys_link+0x13c>
    iunlockput(ip);
    80004956:	8526                	mv	a0,s1
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	536080e7          	jalr	1334(ra) # 80002e8e <iunlockput>
    end_op();
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	cec080e7          	jalr	-788(ra) # 8000364c <end_op>
    return -1;
    80004968:	57fd                	li	a5,-1
    8000496a:	a83d                	j	800049a8 <sys_link+0x13c>
    iunlockput(dp);
    8000496c:	854a                	mv	a0,s2
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	520080e7          	jalr	1312(ra) # 80002e8e <iunlockput>
  ilock(ip);
    80004976:	8526                	mv	a0,s1
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	2b4080e7          	jalr	692(ra) # 80002c2c <ilock>
  ip->nlink--;
    80004980:	04a4d783          	lhu	a5,74(s1)
    80004984:	37fd                	addw	a5,a5,-1
    80004986:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000498a:	8526                	mv	a0,s1
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	1d4080e7          	jalr	468(ra) # 80002b60 <iupdate>
  iunlockput(ip);
    80004994:	8526                	mv	a0,s1
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	4f8080e7          	jalr	1272(ra) # 80002e8e <iunlockput>
  end_op();
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	cae080e7          	jalr	-850(ra) # 8000364c <end_op>
  return -1;
    800049a6:	57fd                	li	a5,-1
}
    800049a8:	853e                	mv	a0,a5
    800049aa:	70b2                	ld	ra,296(sp)
    800049ac:	7412                	ld	s0,288(sp)
    800049ae:	64f2                	ld	s1,280(sp)
    800049b0:	6952                	ld	s2,272(sp)
    800049b2:	6155                	add	sp,sp,304
    800049b4:	8082                	ret

00000000800049b6 <sys_unlink>:
{
    800049b6:	7151                	add	sp,sp,-240
    800049b8:	f586                	sd	ra,232(sp)
    800049ba:	f1a2                	sd	s0,224(sp)
    800049bc:	eda6                	sd	s1,216(sp)
    800049be:	e9ca                	sd	s2,208(sp)
    800049c0:	e5ce                	sd	s3,200(sp)
    800049c2:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049c4:	08000613          	li	a2,128
    800049c8:	f3040593          	add	a1,s0,-208
    800049cc:	4501                	li	a0,0
    800049ce:	ffffd097          	auipc	ra,0xffffd
    800049d2:	664080e7          	jalr	1636(ra) # 80002032 <argstr>
    800049d6:	18054163          	bltz	a0,80004b58 <sys_unlink+0x1a2>
  begin_op();
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	bf8080e7          	jalr	-1032(ra) # 800035d2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049e2:	fb040593          	add	a1,s0,-80
    800049e6:	f3040513          	add	a0,s0,-208
    800049ea:	fffff097          	auipc	ra,0xfffff
    800049ee:	a06080e7          	jalr	-1530(ra) # 800033f0 <nameiparent>
    800049f2:	84aa                	mv	s1,a0
    800049f4:	c979                	beqz	a0,80004aca <sys_unlink+0x114>
  ilock(dp);
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	236080e7          	jalr	566(ra) # 80002c2c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049fe:	00004597          	auipc	a1,0x4
    80004a02:	e0258593          	add	a1,a1,-510 # 80008800 <syscall_names+0x2a8>
    80004a06:	fb040513          	add	a0,s0,-80
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	6ec080e7          	jalr	1772(ra) # 800030f6 <namecmp>
    80004a12:	14050a63          	beqz	a0,80004b66 <sys_unlink+0x1b0>
    80004a16:	00004597          	auipc	a1,0x4
    80004a1a:	df258593          	add	a1,a1,-526 # 80008808 <syscall_names+0x2b0>
    80004a1e:	fb040513          	add	a0,s0,-80
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	6d4080e7          	jalr	1748(ra) # 800030f6 <namecmp>
    80004a2a:	12050e63          	beqz	a0,80004b66 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a2e:	f2c40613          	add	a2,s0,-212
    80004a32:	fb040593          	add	a1,s0,-80
    80004a36:	8526                	mv	a0,s1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	6d8080e7          	jalr	1752(ra) # 80003110 <dirlookup>
    80004a40:	892a                	mv	s2,a0
    80004a42:	12050263          	beqz	a0,80004b66 <sys_unlink+0x1b0>
  ilock(ip);
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	1e6080e7          	jalr	486(ra) # 80002c2c <ilock>
  if(ip->nlink < 1)
    80004a4e:	04a91783          	lh	a5,74(s2)
    80004a52:	08f05263          	blez	a5,80004ad6 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a56:	04491703          	lh	a4,68(s2)
    80004a5a:	4785                	li	a5,1
    80004a5c:	08f70563          	beq	a4,a5,80004ae6 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a60:	4641                	li	a2,16
    80004a62:	4581                	li	a1,0
    80004a64:	fc040513          	add	a0,s0,-64
    80004a68:	ffffb097          	auipc	ra,0xffffb
    80004a6c:	75c080e7          	jalr	1884(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a70:	4741                	li	a4,16
    80004a72:	f2c42683          	lw	a3,-212(s0)
    80004a76:	fc040613          	add	a2,s0,-64
    80004a7a:	4581                	li	a1,0
    80004a7c:	8526                	mv	a0,s1
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	55a080e7          	jalr	1370(ra) # 80002fd8 <writei>
    80004a86:	47c1                	li	a5,16
    80004a88:	0af51563          	bne	a0,a5,80004b32 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a8c:	04491703          	lh	a4,68(s2)
    80004a90:	4785                	li	a5,1
    80004a92:	0af70863          	beq	a4,a5,80004b42 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a96:	8526                	mv	a0,s1
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	3f6080e7          	jalr	1014(ra) # 80002e8e <iunlockput>
  ip->nlink--;
    80004aa0:	04a95783          	lhu	a5,74(s2)
    80004aa4:	37fd                	addw	a5,a5,-1
    80004aa6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004aaa:	854a                	mv	a0,s2
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	0b4080e7          	jalr	180(ra) # 80002b60 <iupdate>
  iunlockput(ip);
    80004ab4:	854a                	mv	a0,s2
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	3d8080e7          	jalr	984(ra) # 80002e8e <iunlockput>
  end_op();
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	b8e080e7          	jalr	-1138(ra) # 8000364c <end_op>
  return 0;
    80004ac6:	4501                	li	a0,0
    80004ac8:	a84d                	j	80004b7a <sys_unlink+0x1c4>
    end_op();
    80004aca:	fffff097          	auipc	ra,0xfffff
    80004ace:	b82080e7          	jalr	-1150(ra) # 8000364c <end_op>
    return -1;
    80004ad2:	557d                	li	a0,-1
    80004ad4:	a05d                	j	80004b7a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ad6:	00004517          	auipc	a0,0x4
    80004ada:	d3a50513          	add	a0,a0,-710 # 80008810 <syscall_names+0x2b8>
    80004ade:	00001097          	auipc	ra,0x1
    80004ae2:	1a8080e7          	jalr	424(ra) # 80005c86 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ae6:	04c92703          	lw	a4,76(s2)
    80004aea:	02000793          	li	a5,32
    80004aee:	f6e7f9e3          	bgeu	a5,a4,80004a60 <sys_unlink+0xaa>
    80004af2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af6:	4741                	li	a4,16
    80004af8:	86ce                	mv	a3,s3
    80004afa:	f1840613          	add	a2,s0,-232
    80004afe:	4581                	li	a1,0
    80004b00:	854a                	mv	a0,s2
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	3de080e7          	jalr	990(ra) # 80002ee0 <readi>
    80004b0a:	47c1                	li	a5,16
    80004b0c:	00f51b63          	bne	a0,a5,80004b22 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b10:	f1845783          	lhu	a5,-232(s0)
    80004b14:	e7a1                	bnez	a5,80004b5c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b16:	29c1                	addw	s3,s3,16
    80004b18:	04c92783          	lw	a5,76(s2)
    80004b1c:	fcf9ede3          	bltu	s3,a5,80004af6 <sys_unlink+0x140>
    80004b20:	b781                	j	80004a60 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b22:	00004517          	auipc	a0,0x4
    80004b26:	d0650513          	add	a0,a0,-762 # 80008828 <syscall_names+0x2d0>
    80004b2a:	00001097          	auipc	ra,0x1
    80004b2e:	15c080e7          	jalr	348(ra) # 80005c86 <panic>
    panic("unlink: writei");
    80004b32:	00004517          	auipc	a0,0x4
    80004b36:	d0e50513          	add	a0,a0,-754 # 80008840 <syscall_names+0x2e8>
    80004b3a:	00001097          	auipc	ra,0x1
    80004b3e:	14c080e7          	jalr	332(ra) # 80005c86 <panic>
    dp->nlink--;
    80004b42:	04a4d783          	lhu	a5,74(s1)
    80004b46:	37fd                	addw	a5,a5,-1
    80004b48:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b4c:	8526                	mv	a0,s1
    80004b4e:	ffffe097          	auipc	ra,0xffffe
    80004b52:	012080e7          	jalr	18(ra) # 80002b60 <iupdate>
    80004b56:	b781                	j	80004a96 <sys_unlink+0xe0>
    return -1;
    80004b58:	557d                	li	a0,-1
    80004b5a:	a005                	j	80004b7a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b5c:	854a                	mv	a0,s2
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	330080e7          	jalr	816(ra) # 80002e8e <iunlockput>
  iunlockput(dp);
    80004b66:	8526                	mv	a0,s1
    80004b68:	ffffe097          	auipc	ra,0xffffe
    80004b6c:	326080e7          	jalr	806(ra) # 80002e8e <iunlockput>
  end_op();
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	adc080e7          	jalr	-1316(ra) # 8000364c <end_op>
  return -1;
    80004b78:	557d                	li	a0,-1
}
    80004b7a:	70ae                	ld	ra,232(sp)
    80004b7c:	740e                	ld	s0,224(sp)
    80004b7e:	64ee                	ld	s1,216(sp)
    80004b80:	694e                	ld	s2,208(sp)
    80004b82:	69ae                	ld	s3,200(sp)
    80004b84:	616d                	add	sp,sp,240
    80004b86:	8082                	ret

0000000080004b88 <sys_open>:

uint64
sys_open(void)
{
    80004b88:	7131                	add	sp,sp,-192
    80004b8a:	fd06                	sd	ra,184(sp)
    80004b8c:	f922                	sd	s0,176(sp)
    80004b8e:	f526                	sd	s1,168(sp)
    80004b90:	f14a                	sd	s2,160(sp)
    80004b92:	ed4e                	sd	s3,152(sp)
    80004b94:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b96:	f4c40593          	add	a1,s0,-180
    80004b9a:	4505                	li	a0,1
    80004b9c:	ffffd097          	auipc	ra,0xffffd
    80004ba0:	456080e7          	jalr	1110(ra) # 80001ff2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ba4:	08000613          	li	a2,128
    80004ba8:	f5040593          	add	a1,s0,-176
    80004bac:	4501                	li	a0,0
    80004bae:	ffffd097          	auipc	ra,0xffffd
    80004bb2:	484080e7          	jalr	1156(ra) # 80002032 <argstr>
    80004bb6:	87aa                	mv	a5,a0
    return -1;
    80004bb8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bba:	0a07c863          	bltz	a5,80004c6a <sys_open+0xe2>

  begin_op();
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	a14080e7          	jalr	-1516(ra) # 800035d2 <begin_op>

  if(omode & O_CREATE){
    80004bc6:	f4c42783          	lw	a5,-180(s0)
    80004bca:	2007f793          	and	a5,a5,512
    80004bce:	cbdd                	beqz	a5,80004c84 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004bd0:	4681                	li	a3,0
    80004bd2:	4601                	li	a2,0
    80004bd4:	4589                	li	a1,2
    80004bd6:	f5040513          	add	a0,s0,-176
    80004bda:	00000097          	auipc	ra,0x0
    80004bde:	97a080e7          	jalr	-1670(ra) # 80004554 <create>
    80004be2:	84aa                	mv	s1,a0
    if(ip == 0){
    80004be4:	c951                	beqz	a0,80004c78 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004be6:	04449703          	lh	a4,68(s1)
    80004bea:	478d                	li	a5,3
    80004bec:	00f71763          	bne	a4,a5,80004bfa <sys_open+0x72>
    80004bf0:	0464d703          	lhu	a4,70(s1)
    80004bf4:	47a5                	li	a5,9
    80004bf6:	0ce7ec63          	bltu	a5,a4,80004cce <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	de0080e7          	jalr	-544(ra) # 800039da <filealloc>
    80004c02:	892a                	mv	s2,a0
    80004c04:	c56d                	beqz	a0,80004cee <sys_open+0x166>
    80004c06:	00000097          	auipc	ra,0x0
    80004c0a:	90c080e7          	jalr	-1780(ra) # 80004512 <fdalloc>
    80004c0e:	89aa                	mv	s3,a0
    80004c10:	0c054a63          	bltz	a0,80004ce4 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c14:	04449703          	lh	a4,68(s1)
    80004c18:	478d                	li	a5,3
    80004c1a:	0ef70563          	beq	a4,a5,80004d04 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c1e:	4789                	li	a5,2
    80004c20:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c24:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c28:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c2c:	f4c42783          	lw	a5,-180(s0)
    80004c30:	0017c713          	xor	a4,a5,1
    80004c34:	8b05                	and	a4,a4,1
    80004c36:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c3a:	0037f713          	and	a4,a5,3
    80004c3e:	00e03733          	snez	a4,a4
    80004c42:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c46:	4007f793          	and	a5,a5,1024
    80004c4a:	c791                	beqz	a5,80004c56 <sys_open+0xce>
    80004c4c:	04449703          	lh	a4,68(s1)
    80004c50:	4789                	li	a5,2
    80004c52:	0cf70063          	beq	a4,a5,80004d12 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004c56:	8526                	mv	a0,s1
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	096080e7          	jalr	150(ra) # 80002cee <iunlock>
  end_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	9ec080e7          	jalr	-1556(ra) # 8000364c <end_op>

  return fd;
    80004c68:	854e                	mv	a0,s3
}
    80004c6a:	70ea                	ld	ra,184(sp)
    80004c6c:	744a                	ld	s0,176(sp)
    80004c6e:	74aa                	ld	s1,168(sp)
    80004c70:	790a                	ld	s2,160(sp)
    80004c72:	69ea                	ld	s3,152(sp)
    80004c74:	6129                	add	sp,sp,192
    80004c76:	8082                	ret
      end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	9d4080e7          	jalr	-1580(ra) # 8000364c <end_op>
      return -1;
    80004c80:	557d                	li	a0,-1
    80004c82:	b7e5                	j	80004c6a <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004c84:	f5040513          	add	a0,s0,-176
    80004c88:	ffffe097          	auipc	ra,0xffffe
    80004c8c:	74a080e7          	jalr	1866(ra) # 800033d2 <namei>
    80004c90:	84aa                	mv	s1,a0
    80004c92:	c905                	beqz	a0,80004cc2 <sys_open+0x13a>
    ilock(ip);
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	f98080e7          	jalr	-104(ra) # 80002c2c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c9c:	04449703          	lh	a4,68(s1)
    80004ca0:	4785                	li	a5,1
    80004ca2:	f4f712e3          	bne	a4,a5,80004be6 <sys_open+0x5e>
    80004ca6:	f4c42783          	lw	a5,-180(s0)
    80004caa:	dba1                	beqz	a5,80004bfa <sys_open+0x72>
      iunlockput(ip);
    80004cac:	8526                	mv	a0,s1
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	1e0080e7          	jalr	480(ra) # 80002e8e <iunlockput>
      end_op();
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	996080e7          	jalr	-1642(ra) # 8000364c <end_op>
      return -1;
    80004cbe:	557d                	li	a0,-1
    80004cc0:	b76d                	j	80004c6a <sys_open+0xe2>
      end_op();
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	98a080e7          	jalr	-1654(ra) # 8000364c <end_op>
      return -1;
    80004cca:	557d                	li	a0,-1
    80004ccc:	bf79                	j	80004c6a <sys_open+0xe2>
    iunlockput(ip);
    80004cce:	8526                	mv	a0,s1
    80004cd0:	ffffe097          	auipc	ra,0xffffe
    80004cd4:	1be080e7          	jalr	446(ra) # 80002e8e <iunlockput>
    end_op();
    80004cd8:	fffff097          	auipc	ra,0xfffff
    80004cdc:	974080e7          	jalr	-1676(ra) # 8000364c <end_op>
    return -1;
    80004ce0:	557d                	li	a0,-1
    80004ce2:	b761                	j	80004c6a <sys_open+0xe2>
      fileclose(f);
    80004ce4:	854a                	mv	a0,s2
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	db0080e7          	jalr	-592(ra) # 80003a96 <fileclose>
    iunlockput(ip);
    80004cee:	8526                	mv	a0,s1
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	19e080e7          	jalr	414(ra) # 80002e8e <iunlockput>
    end_op();
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	954080e7          	jalr	-1708(ra) # 8000364c <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	b7a5                	j	80004c6a <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004d04:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d08:	04649783          	lh	a5,70(s1)
    80004d0c:	02f91223          	sh	a5,36(s2)
    80004d10:	bf21                	j	80004c28 <sys_open+0xa0>
    itrunc(ip);
    80004d12:	8526                	mv	a0,s1
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	026080e7          	jalr	38(ra) # 80002d3a <itrunc>
    80004d1c:	bf2d                	j	80004c56 <sys_open+0xce>

0000000080004d1e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d1e:	7175                	add	sp,sp,-144
    80004d20:	e506                	sd	ra,136(sp)
    80004d22:	e122                	sd	s0,128(sp)
    80004d24:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	8ac080e7          	jalr	-1876(ra) # 800035d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d2e:	08000613          	li	a2,128
    80004d32:	f7040593          	add	a1,s0,-144
    80004d36:	4501                	li	a0,0
    80004d38:	ffffd097          	auipc	ra,0xffffd
    80004d3c:	2fa080e7          	jalr	762(ra) # 80002032 <argstr>
    80004d40:	02054963          	bltz	a0,80004d72 <sys_mkdir+0x54>
    80004d44:	4681                	li	a3,0
    80004d46:	4601                	li	a2,0
    80004d48:	4585                	li	a1,1
    80004d4a:	f7040513          	add	a0,s0,-144
    80004d4e:	00000097          	auipc	ra,0x0
    80004d52:	806080e7          	jalr	-2042(ra) # 80004554 <create>
    80004d56:	cd11                	beqz	a0,80004d72 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	136080e7          	jalr	310(ra) # 80002e8e <iunlockput>
  end_op();
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	8ec080e7          	jalr	-1812(ra) # 8000364c <end_op>
  return 0;
    80004d68:	4501                	li	a0,0
}
    80004d6a:	60aa                	ld	ra,136(sp)
    80004d6c:	640a                	ld	s0,128(sp)
    80004d6e:	6149                	add	sp,sp,144
    80004d70:	8082                	ret
    end_op();
    80004d72:	fffff097          	auipc	ra,0xfffff
    80004d76:	8da080e7          	jalr	-1830(ra) # 8000364c <end_op>
    return -1;
    80004d7a:	557d                	li	a0,-1
    80004d7c:	b7fd                	j	80004d6a <sys_mkdir+0x4c>

0000000080004d7e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d7e:	7135                	add	sp,sp,-160
    80004d80:	ed06                	sd	ra,152(sp)
    80004d82:	e922                	sd	s0,144(sp)
    80004d84:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	84c080e7          	jalr	-1972(ra) # 800035d2 <begin_op>
  argint(1, &major);
    80004d8e:	f6c40593          	add	a1,s0,-148
    80004d92:	4505                	li	a0,1
    80004d94:	ffffd097          	auipc	ra,0xffffd
    80004d98:	25e080e7          	jalr	606(ra) # 80001ff2 <argint>
  argint(2, &minor);
    80004d9c:	f6840593          	add	a1,s0,-152
    80004da0:	4509                	li	a0,2
    80004da2:	ffffd097          	auipc	ra,0xffffd
    80004da6:	250080e7          	jalr	592(ra) # 80001ff2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004daa:	08000613          	li	a2,128
    80004dae:	f7040593          	add	a1,s0,-144
    80004db2:	4501                	li	a0,0
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	27e080e7          	jalr	638(ra) # 80002032 <argstr>
    80004dbc:	02054b63          	bltz	a0,80004df2 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dc0:	f6841683          	lh	a3,-152(s0)
    80004dc4:	f6c41603          	lh	a2,-148(s0)
    80004dc8:	458d                	li	a1,3
    80004dca:	f7040513          	add	a0,s0,-144
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	786080e7          	jalr	1926(ra) # 80004554 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dd6:	cd11                	beqz	a0,80004df2 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	0b6080e7          	jalr	182(ra) # 80002e8e <iunlockput>
  end_op();
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	86c080e7          	jalr	-1940(ra) # 8000364c <end_op>
  return 0;
    80004de8:	4501                	li	a0,0
}
    80004dea:	60ea                	ld	ra,152(sp)
    80004dec:	644a                	ld	s0,144(sp)
    80004dee:	610d                	add	sp,sp,160
    80004df0:	8082                	ret
    end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	85a080e7          	jalr	-1958(ra) # 8000364c <end_op>
    return -1;
    80004dfa:	557d                	li	a0,-1
    80004dfc:	b7fd                	j	80004dea <sys_mknod+0x6c>

0000000080004dfe <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dfe:	7135                	add	sp,sp,-160
    80004e00:	ed06                	sd	ra,152(sp)
    80004e02:	e922                	sd	s0,144(sp)
    80004e04:	e526                	sd	s1,136(sp)
    80004e06:	e14a                	sd	s2,128(sp)
    80004e08:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e0a:	ffffc097          	auipc	ra,0xffffc
    80004e0e:	092080e7          	jalr	146(ra) # 80000e9c <myproc>
    80004e12:	892a                	mv	s2,a0
  
  begin_op();
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	7be080e7          	jalr	1982(ra) # 800035d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e1c:	08000613          	li	a2,128
    80004e20:	f6040593          	add	a1,s0,-160
    80004e24:	4501                	li	a0,0
    80004e26:	ffffd097          	auipc	ra,0xffffd
    80004e2a:	20c080e7          	jalr	524(ra) # 80002032 <argstr>
    80004e2e:	04054b63          	bltz	a0,80004e84 <sys_chdir+0x86>
    80004e32:	f6040513          	add	a0,s0,-160
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	59c080e7          	jalr	1436(ra) # 800033d2 <namei>
    80004e3e:	84aa                	mv	s1,a0
    80004e40:	c131                	beqz	a0,80004e84 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	dea080e7          	jalr	-534(ra) # 80002c2c <ilock>
  if(ip->type != T_DIR){
    80004e4a:	04449703          	lh	a4,68(s1)
    80004e4e:	4785                	li	a5,1
    80004e50:	04f71063          	bne	a4,a5,80004e90 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e54:	8526                	mv	a0,s1
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	e98080e7          	jalr	-360(ra) # 80002cee <iunlock>
  iput(p->cwd);
    80004e5e:	15093503          	ld	a0,336(s2)
    80004e62:	ffffe097          	auipc	ra,0xffffe
    80004e66:	f84080e7          	jalr	-124(ra) # 80002de6 <iput>
  end_op();
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	7e2080e7          	jalr	2018(ra) # 8000364c <end_op>
  p->cwd = ip;
    80004e72:	14993823          	sd	s1,336(s2)
  return 0;
    80004e76:	4501                	li	a0,0
}
    80004e78:	60ea                	ld	ra,152(sp)
    80004e7a:	644a                	ld	s0,144(sp)
    80004e7c:	64aa                	ld	s1,136(sp)
    80004e7e:	690a                	ld	s2,128(sp)
    80004e80:	610d                	add	sp,sp,160
    80004e82:	8082                	ret
    end_op();
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	7c8080e7          	jalr	1992(ra) # 8000364c <end_op>
    return -1;
    80004e8c:	557d                	li	a0,-1
    80004e8e:	b7ed                	j	80004e78 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e90:	8526                	mv	a0,s1
    80004e92:	ffffe097          	auipc	ra,0xffffe
    80004e96:	ffc080e7          	jalr	-4(ra) # 80002e8e <iunlockput>
    end_op();
    80004e9a:	ffffe097          	auipc	ra,0xffffe
    80004e9e:	7b2080e7          	jalr	1970(ra) # 8000364c <end_op>
    return -1;
    80004ea2:	557d                	li	a0,-1
    80004ea4:	bfd1                	j	80004e78 <sys_chdir+0x7a>

0000000080004ea6 <sys_exec>:

uint64
sys_exec(void)
{
    80004ea6:	7121                	add	sp,sp,-448
    80004ea8:	ff06                	sd	ra,440(sp)
    80004eaa:	fb22                	sd	s0,432(sp)
    80004eac:	f726                	sd	s1,424(sp)
    80004eae:	f34a                	sd	s2,416(sp)
    80004eb0:	ef4e                	sd	s3,408(sp)
    80004eb2:	eb52                	sd	s4,400(sp)
    80004eb4:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004eb6:	e4840593          	add	a1,s0,-440
    80004eba:	4505                	li	a0,1
    80004ebc:	ffffd097          	auipc	ra,0xffffd
    80004ec0:	156080e7          	jalr	342(ra) # 80002012 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ec4:	08000613          	li	a2,128
    80004ec8:	f5040593          	add	a1,s0,-176
    80004ecc:	4501                	li	a0,0
    80004ece:	ffffd097          	auipc	ra,0xffffd
    80004ed2:	164080e7          	jalr	356(ra) # 80002032 <argstr>
    80004ed6:	87aa                	mv	a5,a0
    return -1;
    80004ed8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004eda:	0c07c263          	bltz	a5,80004f9e <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004ede:	10000613          	li	a2,256
    80004ee2:	4581                	li	a1,0
    80004ee4:	e5040513          	add	a0,s0,-432
    80004ee8:	ffffb097          	auipc	ra,0xffffb
    80004eec:	2dc080e7          	jalr	732(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ef0:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004ef4:	89a6                	mv	s3,s1
    80004ef6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ef8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004efc:	00391513          	sll	a0,s2,0x3
    80004f00:	e4040593          	add	a1,s0,-448
    80004f04:	e4843783          	ld	a5,-440(s0)
    80004f08:	953e                	add	a0,a0,a5
    80004f0a:	ffffd097          	auipc	ra,0xffffd
    80004f0e:	04a080e7          	jalr	74(ra) # 80001f54 <fetchaddr>
    80004f12:	02054a63          	bltz	a0,80004f46 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004f16:	e4043783          	ld	a5,-448(s0)
    80004f1a:	c3b9                	beqz	a5,80004f60 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f1c:	ffffb097          	auipc	ra,0xffffb
    80004f20:	1fe080e7          	jalr	510(ra) # 8000011a <kalloc>
    80004f24:	85aa                	mv	a1,a0
    80004f26:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f2a:	cd11                	beqz	a0,80004f46 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f2c:	6605                	lui	a2,0x1
    80004f2e:	e4043503          	ld	a0,-448(s0)
    80004f32:	ffffd097          	auipc	ra,0xffffd
    80004f36:	074080e7          	jalr	116(ra) # 80001fa6 <fetchstr>
    80004f3a:	00054663          	bltz	a0,80004f46 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004f3e:	0905                	add	s2,s2,1
    80004f40:	09a1                	add	s3,s3,8
    80004f42:	fb491de3          	bne	s2,s4,80004efc <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f46:	f5040913          	add	s2,s0,-176
    80004f4a:	6088                	ld	a0,0(s1)
    80004f4c:	c921                	beqz	a0,80004f9c <sys_exec+0xf6>
    kfree(argv[i]);
    80004f4e:	ffffb097          	auipc	ra,0xffffb
    80004f52:	0ce080e7          	jalr	206(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f56:	04a1                	add	s1,s1,8
    80004f58:	ff2499e3          	bne	s1,s2,80004f4a <sys_exec+0xa4>
  return -1;
    80004f5c:	557d                	li	a0,-1
    80004f5e:	a081                	j	80004f9e <sys_exec+0xf8>
      argv[i] = 0;
    80004f60:	0009079b          	sext.w	a5,s2
    80004f64:	078e                	sll	a5,a5,0x3
    80004f66:	fd078793          	add	a5,a5,-48
    80004f6a:	97a2                	add	a5,a5,s0
    80004f6c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f70:	e5040593          	add	a1,s0,-432
    80004f74:	f5040513          	add	a0,s0,-176
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	194080e7          	jalr	404(ra) # 8000410c <exec>
    80004f80:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f82:	f5040993          	add	s3,s0,-176
    80004f86:	6088                	ld	a0,0(s1)
    80004f88:	c901                	beqz	a0,80004f98 <sys_exec+0xf2>
    kfree(argv[i]);
    80004f8a:	ffffb097          	auipc	ra,0xffffb
    80004f8e:	092080e7          	jalr	146(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f92:	04a1                	add	s1,s1,8
    80004f94:	ff3499e3          	bne	s1,s3,80004f86 <sys_exec+0xe0>
  return ret;
    80004f98:	854a                	mv	a0,s2
    80004f9a:	a011                	j	80004f9e <sys_exec+0xf8>
  return -1;
    80004f9c:	557d                	li	a0,-1
}
    80004f9e:	70fa                	ld	ra,440(sp)
    80004fa0:	745a                	ld	s0,432(sp)
    80004fa2:	74ba                	ld	s1,424(sp)
    80004fa4:	791a                	ld	s2,416(sp)
    80004fa6:	69fa                	ld	s3,408(sp)
    80004fa8:	6a5a                	ld	s4,400(sp)
    80004faa:	6139                	add	sp,sp,448
    80004fac:	8082                	ret

0000000080004fae <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fae:	7139                	add	sp,sp,-64
    80004fb0:	fc06                	sd	ra,56(sp)
    80004fb2:	f822                	sd	s0,48(sp)
    80004fb4:	f426                	sd	s1,40(sp)
    80004fb6:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fb8:	ffffc097          	auipc	ra,0xffffc
    80004fbc:	ee4080e7          	jalr	-284(ra) # 80000e9c <myproc>
    80004fc0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fc2:	fd840593          	add	a1,s0,-40
    80004fc6:	4501                	li	a0,0
    80004fc8:	ffffd097          	auipc	ra,0xffffd
    80004fcc:	04a080e7          	jalr	74(ra) # 80002012 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fd0:	fc840593          	add	a1,s0,-56
    80004fd4:	fd040513          	add	a0,s0,-48
    80004fd8:	fffff097          	auipc	ra,0xfffff
    80004fdc:	dea080e7          	jalr	-534(ra) # 80003dc2 <pipealloc>
    return -1;
    80004fe0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fe2:	0c054463          	bltz	a0,800050aa <sys_pipe+0xfc>
  fd0 = -1;
    80004fe6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fea:	fd043503          	ld	a0,-48(s0)
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	524080e7          	jalr	1316(ra) # 80004512 <fdalloc>
    80004ff6:	fca42223          	sw	a0,-60(s0)
    80004ffa:	08054b63          	bltz	a0,80005090 <sys_pipe+0xe2>
    80004ffe:	fc843503          	ld	a0,-56(s0)
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	510080e7          	jalr	1296(ra) # 80004512 <fdalloc>
    8000500a:	fca42023          	sw	a0,-64(s0)
    8000500e:	06054863          	bltz	a0,8000507e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005012:	4691                	li	a3,4
    80005014:	fc440613          	add	a2,s0,-60
    80005018:	fd843583          	ld	a1,-40(s0)
    8000501c:	68a8                	ld	a0,80(s1)
    8000501e:	ffffc097          	auipc	ra,0xffffc
    80005022:	b3e080e7          	jalr	-1218(ra) # 80000b5c <copyout>
    80005026:	02054063          	bltz	a0,80005046 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000502a:	4691                	li	a3,4
    8000502c:	fc040613          	add	a2,s0,-64
    80005030:	fd843583          	ld	a1,-40(s0)
    80005034:	0591                	add	a1,a1,4
    80005036:	68a8                	ld	a0,80(s1)
    80005038:	ffffc097          	auipc	ra,0xffffc
    8000503c:	b24080e7          	jalr	-1244(ra) # 80000b5c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005040:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005042:	06055463          	bgez	a0,800050aa <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005046:	fc442783          	lw	a5,-60(s0)
    8000504a:	07e9                	add	a5,a5,26
    8000504c:	078e                	sll	a5,a5,0x3
    8000504e:	97a6                	add	a5,a5,s1
    80005050:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005054:	fc042783          	lw	a5,-64(s0)
    80005058:	07e9                	add	a5,a5,26
    8000505a:	078e                	sll	a5,a5,0x3
    8000505c:	94be                	add	s1,s1,a5
    8000505e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005062:	fd043503          	ld	a0,-48(s0)
    80005066:	fffff097          	auipc	ra,0xfffff
    8000506a:	a30080e7          	jalr	-1488(ra) # 80003a96 <fileclose>
    fileclose(wf);
    8000506e:	fc843503          	ld	a0,-56(s0)
    80005072:	fffff097          	auipc	ra,0xfffff
    80005076:	a24080e7          	jalr	-1500(ra) # 80003a96 <fileclose>
    return -1;
    8000507a:	57fd                	li	a5,-1
    8000507c:	a03d                	j	800050aa <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000507e:	fc442783          	lw	a5,-60(s0)
    80005082:	0007c763          	bltz	a5,80005090 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005086:	07e9                	add	a5,a5,26
    80005088:	078e                	sll	a5,a5,0x3
    8000508a:	97a6                	add	a5,a5,s1
    8000508c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005090:	fd043503          	ld	a0,-48(s0)
    80005094:	fffff097          	auipc	ra,0xfffff
    80005098:	a02080e7          	jalr	-1534(ra) # 80003a96 <fileclose>
    fileclose(wf);
    8000509c:	fc843503          	ld	a0,-56(s0)
    800050a0:	fffff097          	auipc	ra,0xfffff
    800050a4:	9f6080e7          	jalr	-1546(ra) # 80003a96 <fileclose>
    return -1;
    800050a8:	57fd                	li	a5,-1
}
    800050aa:	853e                	mv	a0,a5
    800050ac:	70e2                	ld	ra,56(sp)
    800050ae:	7442                	ld	s0,48(sp)
    800050b0:	74a2                	ld	s1,40(sp)
    800050b2:	6121                	add	sp,sp,64
    800050b4:	8082                	ret
	...

00000000800050c0 <kernelvec>:
    800050c0:	7111                	add	sp,sp,-256
    800050c2:	e006                	sd	ra,0(sp)
    800050c4:	e40a                	sd	sp,8(sp)
    800050c6:	e80e                	sd	gp,16(sp)
    800050c8:	ec12                	sd	tp,24(sp)
    800050ca:	f016                	sd	t0,32(sp)
    800050cc:	f41a                	sd	t1,40(sp)
    800050ce:	f81e                	sd	t2,48(sp)
    800050d0:	fc22                	sd	s0,56(sp)
    800050d2:	e0a6                	sd	s1,64(sp)
    800050d4:	e4aa                	sd	a0,72(sp)
    800050d6:	e8ae                	sd	a1,80(sp)
    800050d8:	ecb2                	sd	a2,88(sp)
    800050da:	f0b6                	sd	a3,96(sp)
    800050dc:	f4ba                	sd	a4,104(sp)
    800050de:	f8be                	sd	a5,112(sp)
    800050e0:	fcc2                	sd	a6,120(sp)
    800050e2:	e146                	sd	a7,128(sp)
    800050e4:	e54a                	sd	s2,136(sp)
    800050e6:	e94e                	sd	s3,144(sp)
    800050e8:	ed52                	sd	s4,152(sp)
    800050ea:	f156                	sd	s5,160(sp)
    800050ec:	f55a                	sd	s6,168(sp)
    800050ee:	f95e                	sd	s7,176(sp)
    800050f0:	fd62                	sd	s8,184(sp)
    800050f2:	e1e6                	sd	s9,192(sp)
    800050f4:	e5ea                	sd	s10,200(sp)
    800050f6:	e9ee                	sd	s11,208(sp)
    800050f8:	edf2                	sd	t3,216(sp)
    800050fa:	f1f6                	sd	t4,224(sp)
    800050fc:	f5fa                	sd	t5,232(sp)
    800050fe:	f9fe                	sd	t6,240(sp)
    80005100:	d21fc0ef          	jal	80001e20 <kerneltrap>
    80005104:	6082                	ld	ra,0(sp)
    80005106:	6122                	ld	sp,8(sp)
    80005108:	61c2                	ld	gp,16(sp)
    8000510a:	7282                	ld	t0,32(sp)
    8000510c:	7322                	ld	t1,40(sp)
    8000510e:	73c2                	ld	t2,48(sp)
    80005110:	7462                	ld	s0,56(sp)
    80005112:	6486                	ld	s1,64(sp)
    80005114:	6526                	ld	a0,72(sp)
    80005116:	65c6                	ld	a1,80(sp)
    80005118:	6666                	ld	a2,88(sp)
    8000511a:	7686                	ld	a3,96(sp)
    8000511c:	7726                	ld	a4,104(sp)
    8000511e:	77c6                	ld	a5,112(sp)
    80005120:	7866                	ld	a6,120(sp)
    80005122:	688a                	ld	a7,128(sp)
    80005124:	692a                	ld	s2,136(sp)
    80005126:	69ca                	ld	s3,144(sp)
    80005128:	6a6a                	ld	s4,152(sp)
    8000512a:	7a8a                	ld	s5,160(sp)
    8000512c:	7b2a                	ld	s6,168(sp)
    8000512e:	7bca                	ld	s7,176(sp)
    80005130:	7c6a                	ld	s8,184(sp)
    80005132:	6c8e                	ld	s9,192(sp)
    80005134:	6d2e                	ld	s10,200(sp)
    80005136:	6dce                	ld	s11,208(sp)
    80005138:	6e6e                	ld	t3,216(sp)
    8000513a:	7e8e                	ld	t4,224(sp)
    8000513c:	7f2e                	ld	t5,232(sp)
    8000513e:	7fce                	ld	t6,240(sp)
    80005140:	6111                	add	sp,sp,256
    80005142:	10200073          	sret
    80005146:	00000013          	nop
    8000514a:	00000013          	nop
    8000514e:	0001                	nop

0000000080005150 <timervec>:
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	e10c                	sd	a1,0(a0)
    80005156:	e510                	sd	a2,8(a0)
    80005158:	e914                	sd	a3,16(a0)
    8000515a:	6d0c                	ld	a1,24(a0)
    8000515c:	7110                	ld	a2,32(a0)
    8000515e:	6194                	ld	a3,0(a1)
    80005160:	96b2                	add	a3,a3,a2
    80005162:	e194                	sd	a3,0(a1)
    80005164:	4589                	li	a1,2
    80005166:	14459073          	csrw	sip,a1
    8000516a:	6914                	ld	a3,16(a0)
    8000516c:	6510                	ld	a2,8(a0)
    8000516e:	610c                	ld	a1,0(a0)
    80005170:	34051573          	csrrw	a0,mscratch,a0
    80005174:	30200073          	mret
	...

000000008000517a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000517a:	1141                	add	sp,sp,-16
    8000517c:	e422                	sd	s0,8(sp)
    8000517e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005180:	0c0007b7          	lui	a5,0xc000
    80005184:	4705                	li	a4,1
    80005186:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005188:	c3d8                	sw	a4,4(a5)
}
    8000518a:	6422                	ld	s0,8(sp)
    8000518c:	0141                	add	sp,sp,16
    8000518e:	8082                	ret

0000000080005190 <plicinithart>:

void
plicinithart(void)
{
    80005190:	1141                	add	sp,sp,-16
    80005192:	e406                	sd	ra,8(sp)
    80005194:	e022                	sd	s0,0(sp)
    80005196:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	cd8080e7          	jalr	-808(ra) # 80000e70 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051a0:	0085171b          	sllw	a4,a0,0x8
    800051a4:	0c0027b7          	lui	a5,0xc002
    800051a8:	97ba                	add	a5,a5,a4
    800051aa:	40200713          	li	a4,1026
    800051ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051b2:	00d5151b          	sllw	a0,a0,0xd
    800051b6:	0c2017b7          	lui	a5,0xc201
    800051ba:	97aa                	add	a5,a5,a0
    800051bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051c0:	60a2                	ld	ra,8(sp)
    800051c2:	6402                	ld	s0,0(sp)
    800051c4:	0141                	add	sp,sp,16
    800051c6:	8082                	ret

00000000800051c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051c8:	1141                	add	sp,sp,-16
    800051ca:	e406                	sd	ra,8(sp)
    800051cc:	e022                	sd	s0,0(sp)
    800051ce:	0800                	add	s0,sp,16
  int hart = cpuid();
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	ca0080e7          	jalr	-864(ra) # 80000e70 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051d8:	00d5151b          	sllw	a0,a0,0xd
    800051dc:	0c2017b7          	lui	a5,0xc201
    800051e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051e2:	43c8                	lw	a0,4(a5)
    800051e4:	60a2                	ld	ra,8(sp)
    800051e6:	6402                	ld	s0,0(sp)
    800051e8:	0141                	add	sp,sp,16
    800051ea:	8082                	ret

00000000800051ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051ec:	1101                	add	sp,sp,-32
    800051ee:	ec06                	sd	ra,24(sp)
    800051f0:	e822                	sd	s0,16(sp)
    800051f2:	e426                	sd	s1,8(sp)
    800051f4:	1000                	add	s0,sp,32
    800051f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	c78080e7          	jalr	-904(ra) # 80000e70 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005200:	00d5151b          	sllw	a0,a0,0xd
    80005204:	0c2017b7          	lui	a5,0xc201
    80005208:	97aa                	add	a5,a5,a0
    8000520a:	c3c4                	sw	s1,4(a5)
}
    8000520c:	60e2                	ld	ra,24(sp)
    8000520e:	6442                	ld	s0,16(sp)
    80005210:	64a2                	ld	s1,8(sp)
    80005212:	6105                	add	sp,sp,32
    80005214:	8082                	ret

0000000080005216 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005216:	1141                	add	sp,sp,-16
    80005218:	e406                	sd	ra,8(sp)
    8000521a:	e022                	sd	s0,0(sp)
    8000521c:	0800                	add	s0,sp,16
  if(i >= NUM)
    8000521e:	479d                	li	a5,7
    80005220:	04a7cc63          	blt	a5,a0,80005278 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005224:	00015797          	auipc	a5,0x15
    80005228:	b1c78793          	add	a5,a5,-1252 # 80019d40 <disk>
    8000522c:	97aa                	add	a5,a5,a0
    8000522e:	0187c783          	lbu	a5,24(a5)
    80005232:	ebb9                	bnez	a5,80005288 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005234:	00451693          	sll	a3,a0,0x4
    80005238:	00015797          	auipc	a5,0x15
    8000523c:	b0878793          	add	a5,a5,-1272 # 80019d40 <disk>
    80005240:	6398                	ld	a4,0(a5)
    80005242:	9736                	add	a4,a4,a3
    80005244:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005248:	6398                	ld	a4,0(a5)
    8000524a:	9736                	add	a4,a4,a3
    8000524c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005250:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005254:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005258:	97aa                	add	a5,a5,a0
    8000525a:	4705                	li	a4,1
    8000525c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005260:	00015517          	auipc	a0,0x15
    80005264:	af850513          	add	a0,a0,-1288 # 80019d58 <disk+0x18>
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	34c080e7          	jalr	844(ra) # 800015b4 <wakeup>
}
    80005270:	60a2                	ld	ra,8(sp)
    80005272:	6402                	ld	s0,0(sp)
    80005274:	0141                	add	sp,sp,16
    80005276:	8082                	ret
    panic("free_desc 1");
    80005278:	00003517          	auipc	a0,0x3
    8000527c:	5d850513          	add	a0,a0,1496 # 80008850 <syscall_names+0x2f8>
    80005280:	00001097          	auipc	ra,0x1
    80005284:	a06080e7          	jalr	-1530(ra) # 80005c86 <panic>
    panic("free_desc 2");
    80005288:	00003517          	auipc	a0,0x3
    8000528c:	5d850513          	add	a0,a0,1496 # 80008860 <syscall_names+0x308>
    80005290:	00001097          	auipc	ra,0x1
    80005294:	9f6080e7          	jalr	-1546(ra) # 80005c86 <panic>

0000000080005298 <virtio_disk_init>:
{
    80005298:	1101                	add	sp,sp,-32
    8000529a:	ec06                	sd	ra,24(sp)
    8000529c:	e822                	sd	s0,16(sp)
    8000529e:	e426                	sd	s1,8(sp)
    800052a0:	e04a                	sd	s2,0(sp)
    800052a2:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052a4:	00003597          	auipc	a1,0x3
    800052a8:	5cc58593          	add	a1,a1,1484 # 80008870 <syscall_names+0x318>
    800052ac:	00015517          	auipc	a0,0x15
    800052b0:	bbc50513          	add	a0,a0,-1092 # 80019e68 <disk+0x128>
    800052b4:	00001097          	auipc	ra,0x1
    800052b8:	e7a080e7          	jalr	-390(ra) # 8000612e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052bc:	100017b7          	lui	a5,0x10001
    800052c0:	4398                	lw	a4,0(a5)
    800052c2:	2701                	sext.w	a4,a4
    800052c4:	747277b7          	lui	a5,0x74727
    800052c8:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052cc:	14f71b63          	bne	a4,a5,80005422 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052d0:	100017b7          	lui	a5,0x10001
    800052d4:	43dc                	lw	a5,4(a5)
    800052d6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d8:	4709                	li	a4,2
    800052da:	14e79463          	bne	a5,a4,80005422 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052de:	100017b7          	lui	a5,0x10001
    800052e2:	479c                	lw	a5,8(a5)
    800052e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052e6:	12e79e63          	bne	a5,a4,80005422 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ea:	100017b7          	lui	a5,0x10001
    800052ee:	47d8                	lw	a4,12(a5)
    800052f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f2:	554d47b7          	lui	a5,0x554d4
    800052f6:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052fa:	12f71463          	bne	a4,a5,80005422 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052fe:	100017b7          	lui	a5,0x10001
    80005302:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005306:	4705                	li	a4,1
    80005308:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000530a:	470d                	li	a4,3
    8000530c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000530e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005310:	c7ffe6b7          	lui	a3,0xc7ffe
    80005314:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc69f>
    80005318:	8f75                	and	a4,a4,a3
    8000531a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531c:	472d                	li	a4,11
    8000531e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005320:	5bbc                	lw	a5,112(a5)
    80005322:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005326:	8ba1                	and	a5,a5,8
    80005328:	10078563          	beqz	a5,80005432 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000532c:	100017b7          	lui	a5,0x10001
    80005330:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005334:	43fc                	lw	a5,68(a5)
    80005336:	2781                	sext.w	a5,a5
    80005338:	10079563          	bnez	a5,80005442 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000533c:	100017b7          	lui	a5,0x10001
    80005340:	5bdc                	lw	a5,52(a5)
    80005342:	2781                	sext.w	a5,a5
  if(max == 0)
    80005344:	10078763          	beqz	a5,80005452 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005348:	471d                	li	a4,7
    8000534a:	10f77c63          	bgeu	a4,a5,80005462 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000534e:	ffffb097          	auipc	ra,0xffffb
    80005352:	dcc080e7          	jalr	-564(ra) # 8000011a <kalloc>
    80005356:	00015497          	auipc	s1,0x15
    8000535a:	9ea48493          	add	s1,s1,-1558 # 80019d40 <disk>
    8000535e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005360:	ffffb097          	auipc	ra,0xffffb
    80005364:	dba080e7          	jalr	-582(ra) # 8000011a <kalloc>
    80005368:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000536a:	ffffb097          	auipc	ra,0xffffb
    8000536e:	db0080e7          	jalr	-592(ra) # 8000011a <kalloc>
    80005372:	87aa                	mv	a5,a0
    80005374:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005376:	6088                	ld	a0,0(s1)
    80005378:	cd6d                	beqz	a0,80005472 <virtio_disk_init+0x1da>
    8000537a:	00015717          	auipc	a4,0x15
    8000537e:	9ce73703          	ld	a4,-1586(a4) # 80019d48 <disk+0x8>
    80005382:	cb65                	beqz	a4,80005472 <virtio_disk_init+0x1da>
    80005384:	c7fd                	beqz	a5,80005472 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005386:	6605                	lui	a2,0x1
    80005388:	4581                	li	a1,0
    8000538a:	ffffb097          	auipc	ra,0xffffb
    8000538e:	e3a080e7          	jalr	-454(ra) # 800001c4 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005392:	00015497          	auipc	s1,0x15
    80005396:	9ae48493          	add	s1,s1,-1618 # 80019d40 <disk>
    8000539a:	6605                	lui	a2,0x1
    8000539c:	4581                	li	a1,0
    8000539e:	6488                	ld	a0,8(s1)
    800053a0:	ffffb097          	auipc	ra,0xffffb
    800053a4:	e24080e7          	jalr	-476(ra) # 800001c4 <memset>
  memset(disk.used, 0, PGSIZE);
    800053a8:	6605                	lui	a2,0x1
    800053aa:	4581                	li	a1,0
    800053ac:	6888                	ld	a0,16(s1)
    800053ae:	ffffb097          	auipc	ra,0xffffb
    800053b2:	e16080e7          	jalr	-490(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053b6:	100017b7          	lui	a5,0x10001
    800053ba:	4721                	li	a4,8
    800053bc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053be:	4098                	lw	a4,0(s1)
    800053c0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053c4:	40d8                	lw	a4,4(s1)
    800053c6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053ca:	6498                	ld	a4,8(s1)
    800053cc:	0007069b          	sext.w	a3,a4
    800053d0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053d4:	9701                	sra	a4,a4,0x20
    800053d6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053da:	6898                	ld	a4,16(s1)
    800053dc:	0007069b          	sext.w	a3,a4
    800053e0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053e4:	9701                	sra	a4,a4,0x20
    800053e6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053ea:	4705                	li	a4,1
    800053ec:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800053ee:	00e48c23          	sb	a4,24(s1)
    800053f2:	00e48ca3          	sb	a4,25(s1)
    800053f6:	00e48d23          	sb	a4,26(s1)
    800053fa:	00e48da3          	sb	a4,27(s1)
    800053fe:	00e48e23          	sb	a4,28(s1)
    80005402:	00e48ea3          	sb	a4,29(s1)
    80005406:	00e48f23          	sb	a4,30(s1)
    8000540a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000540e:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005412:	0727a823          	sw	s2,112(a5)
}
    80005416:	60e2                	ld	ra,24(sp)
    80005418:	6442                	ld	s0,16(sp)
    8000541a:	64a2                	ld	s1,8(sp)
    8000541c:	6902                	ld	s2,0(sp)
    8000541e:	6105                	add	sp,sp,32
    80005420:	8082                	ret
    panic("could not find virtio disk");
    80005422:	00003517          	auipc	a0,0x3
    80005426:	45e50513          	add	a0,a0,1118 # 80008880 <syscall_names+0x328>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	85c080e7          	jalr	-1956(ra) # 80005c86 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005432:	00003517          	auipc	a0,0x3
    80005436:	46e50513          	add	a0,a0,1134 # 800088a0 <syscall_names+0x348>
    8000543a:	00001097          	auipc	ra,0x1
    8000543e:	84c080e7          	jalr	-1972(ra) # 80005c86 <panic>
    panic("virtio disk should not be ready");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	47e50513          	add	a0,a0,1150 # 800088c0 <syscall_names+0x368>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	83c080e7          	jalr	-1988(ra) # 80005c86 <panic>
    panic("virtio disk has no queue 0");
    80005452:	00003517          	auipc	a0,0x3
    80005456:	48e50513          	add	a0,a0,1166 # 800088e0 <syscall_names+0x388>
    8000545a:	00001097          	auipc	ra,0x1
    8000545e:	82c080e7          	jalr	-2004(ra) # 80005c86 <panic>
    panic("virtio disk max queue too short");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	49e50513          	add	a0,a0,1182 # 80008900 <syscall_names+0x3a8>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	81c080e7          	jalr	-2020(ra) # 80005c86 <panic>
    panic("virtio disk kalloc");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	4ae50513          	add	a0,a0,1198 # 80008920 <syscall_names+0x3c8>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	80c080e7          	jalr	-2036(ra) # 80005c86 <panic>

0000000080005482 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005482:	7159                	add	sp,sp,-112
    80005484:	f486                	sd	ra,104(sp)
    80005486:	f0a2                	sd	s0,96(sp)
    80005488:	eca6                	sd	s1,88(sp)
    8000548a:	e8ca                	sd	s2,80(sp)
    8000548c:	e4ce                	sd	s3,72(sp)
    8000548e:	e0d2                	sd	s4,64(sp)
    80005490:	fc56                	sd	s5,56(sp)
    80005492:	f85a                	sd	s6,48(sp)
    80005494:	f45e                	sd	s7,40(sp)
    80005496:	f062                	sd	s8,32(sp)
    80005498:	ec66                	sd	s9,24(sp)
    8000549a:	e86a                	sd	s10,16(sp)
    8000549c:	1880                	add	s0,sp,112
    8000549e:	8a2a                	mv	s4,a0
    800054a0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054a2:	00c52c83          	lw	s9,12(a0)
    800054a6:	001c9c9b          	sllw	s9,s9,0x1
    800054aa:	1c82                	sll	s9,s9,0x20
    800054ac:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054b0:	00015517          	auipc	a0,0x15
    800054b4:	9b850513          	add	a0,a0,-1608 # 80019e68 <disk+0x128>
    800054b8:	00001097          	auipc	ra,0x1
    800054bc:	d06080e7          	jalr	-762(ra) # 800061be <acquire>
  for(int i = 0; i < 3; i++){
    800054c0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800054c2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054c4:	00015b17          	auipc	s6,0x15
    800054c8:	87cb0b13          	add	s6,s6,-1924 # 80019d40 <disk>
  for(int i = 0; i < 3; i++){
    800054cc:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054ce:	00015c17          	auipc	s8,0x15
    800054d2:	99ac0c13          	add	s8,s8,-1638 # 80019e68 <disk+0x128>
    800054d6:	a095                	j	8000553a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054d8:	00fb0733          	add	a4,s6,a5
    800054dc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054e0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800054e2:	0207c563          	bltz	a5,8000550c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800054e6:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800054e8:	0591                	add	a1,a1,4
    800054ea:	05560d63          	beq	a2,s5,80005544 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800054ee:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800054f0:	00015717          	auipc	a4,0x15
    800054f4:	85070713          	add	a4,a4,-1968 # 80019d40 <disk>
    800054f8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800054fa:	01874683          	lbu	a3,24(a4)
    800054fe:	fee9                	bnez	a3,800054d8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005500:	2785                	addw	a5,a5,1
    80005502:	0705                	add	a4,a4,1
    80005504:	fe979be3          	bne	a5,s1,800054fa <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005508:	57fd                	li	a5,-1
    8000550a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000550c:	00c05e63          	blez	a2,80005528 <virtio_disk_rw+0xa6>
    80005510:	060a                	sll	a2,a2,0x2
    80005512:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005516:	0009a503          	lw	a0,0(s3)
    8000551a:	00000097          	auipc	ra,0x0
    8000551e:	cfc080e7          	jalr	-772(ra) # 80005216 <free_desc>
      for(int j = 0; j < i; j++)
    80005522:	0991                	add	s3,s3,4
    80005524:	ffa999e3          	bne	s3,s10,80005516 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005528:	85e2                	mv	a1,s8
    8000552a:	00015517          	auipc	a0,0x15
    8000552e:	82e50513          	add	a0,a0,-2002 # 80019d58 <disk+0x18>
    80005532:	ffffc097          	auipc	ra,0xffffc
    80005536:	01e080e7          	jalr	30(ra) # 80001550 <sleep>
  for(int i = 0; i < 3; i++){
    8000553a:	f9040993          	add	s3,s0,-112
{
    8000553e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005540:	864a                	mv	a2,s2
    80005542:	b775                	j	800054ee <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005544:	f9042503          	lw	a0,-112(s0)
    80005548:	00a50713          	add	a4,a0,10
    8000554c:	0712                	sll	a4,a4,0x4

  if(write)
    8000554e:	00014797          	auipc	a5,0x14
    80005552:	7f278793          	add	a5,a5,2034 # 80019d40 <disk>
    80005556:	00e786b3          	add	a3,a5,a4
    8000555a:	01703633          	snez	a2,s7
    8000555e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005560:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005564:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005568:	f6070613          	add	a2,a4,-160
    8000556c:	6394                	ld	a3,0(a5)
    8000556e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005570:	00870593          	add	a1,a4,8
    80005574:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005576:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005578:	0007b803          	ld	a6,0(a5)
    8000557c:	9642                	add	a2,a2,a6
    8000557e:	46c1                	li	a3,16
    80005580:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005582:	4585                	li	a1,1
    80005584:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005588:	f9442683          	lw	a3,-108(s0)
    8000558c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005590:	0692                	sll	a3,a3,0x4
    80005592:	9836                	add	a6,a6,a3
    80005594:	058a0613          	add	a2,s4,88
    80005598:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000559c:	0007b803          	ld	a6,0(a5)
    800055a0:	96c2                	add	a3,a3,a6
    800055a2:	40000613          	li	a2,1024
    800055a6:	c690                	sw	a2,8(a3)
  if(write)
    800055a8:	001bb613          	seqz	a2,s7
    800055ac:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055b0:	00166613          	or	a2,a2,1
    800055b4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055b8:	f9842603          	lw	a2,-104(s0)
    800055bc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055c0:	00250693          	add	a3,a0,2
    800055c4:	0692                	sll	a3,a3,0x4
    800055c6:	96be                	add	a3,a3,a5
    800055c8:	58fd                	li	a7,-1
    800055ca:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055ce:	0612                	sll	a2,a2,0x4
    800055d0:	9832                	add	a6,a6,a2
    800055d2:	f9070713          	add	a4,a4,-112
    800055d6:	973e                	add	a4,a4,a5
    800055d8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055dc:	6398                	ld	a4,0(a5)
    800055de:	9732                	add	a4,a4,a2
    800055e0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055e2:	4609                	li	a2,2
    800055e4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800055e8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055ec:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800055f0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055f4:	6794                	ld	a3,8(a5)
    800055f6:	0026d703          	lhu	a4,2(a3)
    800055fa:	8b1d                	and	a4,a4,7
    800055fc:	0706                	sll	a4,a4,0x1
    800055fe:	96ba                	add	a3,a3,a4
    80005600:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005604:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005608:	6798                	ld	a4,8(a5)
    8000560a:	00275783          	lhu	a5,2(a4)
    8000560e:	2785                	addw	a5,a5,1
    80005610:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005614:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005618:	100017b7          	lui	a5,0x10001
    8000561c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005620:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005624:	00015917          	auipc	s2,0x15
    80005628:	84490913          	add	s2,s2,-1980 # 80019e68 <disk+0x128>
  while(b->disk == 1) {
    8000562c:	4485                	li	s1,1
    8000562e:	00b79c63          	bne	a5,a1,80005646 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005632:	85ca                	mv	a1,s2
    80005634:	8552                	mv	a0,s4
    80005636:	ffffc097          	auipc	ra,0xffffc
    8000563a:	f1a080e7          	jalr	-230(ra) # 80001550 <sleep>
  while(b->disk == 1) {
    8000563e:	004a2783          	lw	a5,4(s4)
    80005642:	fe9788e3          	beq	a5,s1,80005632 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005646:	f9042903          	lw	s2,-112(s0)
    8000564a:	00290713          	add	a4,s2,2
    8000564e:	0712                	sll	a4,a4,0x4
    80005650:	00014797          	auipc	a5,0x14
    80005654:	6f078793          	add	a5,a5,1776 # 80019d40 <disk>
    80005658:	97ba                	add	a5,a5,a4
    8000565a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000565e:	00014997          	auipc	s3,0x14
    80005662:	6e298993          	add	s3,s3,1762 # 80019d40 <disk>
    80005666:	00491713          	sll	a4,s2,0x4
    8000566a:	0009b783          	ld	a5,0(s3)
    8000566e:	97ba                	add	a5,a5,a4
    80005670:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005674:	854a                	mv	a0,s2
    80005676:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000567a:	00000097          	auipc	ra,0x0
    8000567e:	b9c080e7          	jalr	-1124(ra) # 80005216 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005682:	8885                	and	s1,s1,1
    80005684:	f0ed                	bnez	s1,80005666 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005686:	00014517          	auipc	a0,0x14
    8000568a:	7e250513          	add	a0,a0,2018 # 80019e68 <disk+0x128>
    8000568e:	00001097          	auipc	ra,0x1
    80005692:	be4080e7          	jalr	-1052(ra) # 80006272 <release>
}
    80005696:	70a6                	ld	ra,104(sp)
    80005698:	7406                	ld	s0,96(sp)
    8000569a:	64e6                	ld	s1,88(sp)
    8000569c:	6946                	ld	s2,80(sp)
    8000569e:	69a6                	ld	s3,72(sp)
    800056a0:	6a06                	ld	s4,64(sp)
    800056a2:	7ae2                	ld	s5,56(sp)
    800056a4:	7b42                	ld	s6,48(sp)
    800056a6:	7ba2                	ld	s7,40(sp)
    800056a8:	7c02                	ld	s8,32(sp)
    800056aa:	6ce2                	ld	s9,24(sp)
    800056ac:	6d42                	ld	s10,16(sp)
    800056ae:	6165                	add	sp,sp,112
    800056b0:	8082                	ret

00000000800056b2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056b2:	1101                	add	sp,sp,-32
    800056b4:	ec06                	sd	ra,24(sp)
    800056b6:	e822                	sd	s0,16(sp)
    800056b8:	e426                	sd	s1,8(sp)
    800056ba:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056bc:	00014497          	auipc	s1,0x14
    800056c0:	68448493          	add	s1,s1,1668 # 80019d40 <disk>
    800056c4:	00014517          	auipc	a0,0x14
    800056c8:	7a450513          	add	a0,a0,1956 # 80019e68 <disk+0x128>
    800056cc:	00001097          	auipc	ra,0x1
    800056d0:	af2080e7          	jalr	-1294(ra) # 800061be <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056d4:	10001737          	lui	a4,0x10001
    800056d8:	533c                	lw	a5,96(a4)
    800056da:	8b8d                	and	a5,a5,3
    800056dc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056de:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056e2:	689c                	ld	a5,16(s1)
    800056e4:	0204d703          	lhu	a4,32(s1)
    800056e8:	0027d783          	lhu	a5,2(a5)
    800056ec:	04f70863          	beq	a4,a5,8000573c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056f0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056f4:	6898                	ld	a4,16(s1)
    800056f6:	0204d783          	lhu	a5,32(s1)
    800056fa:	8b9d                	and	a5,a5,7
    800056fc:	078e                	sll	a5,a5,0x3
    800056fe:	97ba                	add	a5,a5,a4
    80005700:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005702:	00278713          	add	a4,a5,2
    80005706:	0712                	sll	a4,a4,0x4
    80005708:	9726                	add	a4,a4,s1
    8000570a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000570e:	e721                	bnez	a4,80005756 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005710:	0789                	add	a5,a5,2
    80005712:	0792                	sll	a5,a5,0x4
    80005714:	97a6                	add	a5,a5,s1
    80005716:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005718:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000571c:	ffffc097          	auipc	ra,0xffffc
    80005720:	e98080e7          	jalr	-360(ra) # 800015b4 <wakeup>

    disk.used_idx += 1;
    80005724:	0204d783          	lhu	a5,32(s1)
    80005728:	2785                	addw	a5,a5,1
    8000572a:	17c2                	sll	a5,a5,0x30
    8000572c:	93c1                	srl	a5,a5,0x30
    8000572e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005732:	6898                	ld	a4,16(s1)
    80005734:	00275703          	lhu	a4,2(a4)
    80005738:	faf71ce3          	bne	a4,a5,800056f0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000573c:	00014517          	auipc	a0,0x14
    80005740:	72c50513          	add	a0,a0,1836 # 80019e68 <disk+0x128>
    80005744:	00001097          	auipc	ra,0x1
    80005748:	b2e080e7          	jalr	-1234(ra) # 80006272 <release>
}
    8000574c:	60e2                	ld	ra,24(sp)
    8000574e:	6442                	ld	s0,16(sp)
    80005750:	64a2                	ld	s1,8(sp)
    80005752:	6105                	add	sp,sp,32
    80005754:	8082                	ret
      panic("virtio_disk_intr status");
    80005756:	00003517          	auipc	a0,0x3
    8000575a:	1e250513          	add	a0,a0,482 # 80008938 <syscall_names+0x3e0>
    8000575e:	00000097          	auipc	ra,0x0
    80005762:	528080e7          	jalr	1320(ra) # 80005c86 <panic>

0000000080005766 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005766:	1141                	add	sp,sp,-16
    80005768:	e422                	sd	s0,8(sp)
    8000576a:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000576c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005770:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005774:	0037979b          	sllw	a5,a5,0x3
    80005778:	02004737          	lui	a4,0x2004
    8000577c:	97ba                	add	a5,a5,a4
    8000577e:	0200c737          	lui	a4,0x200c
    80005782:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005786:	000f4637          	lui	a2,0xf4
    8000578a:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000578e:	9732                	add	a4,a4,a2
    80005790:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005792:	00259693          	sll	a3,a1,0x2
    80005796:	96ae                	add	a3,a3,a1
    80005798:	068e                	sll	a3,a3,0x3
    8000579a:	00014717          	auipc	a4,0x14
    8000579e:	6e670713          	add	a4,a4,1766 # 80019e80 <timer_scratch>
    800057a2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057a4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057a6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057a8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057ac:	00000797          	auipc	a5,0x0
    800057b0:	9a478793          	add	a5,a5,-1628 # 80005150 <timervec>
    800057b4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057b8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057bc:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057c4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057c8:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057cc:	30479073          	csrw	mie,a5
}
    800057d0:	6422                	ld	s0,8(sp)
    800057d2:	0141                	add	sp,sp,16
    800057d4:	8082                	ret

00000000800057d6 <start>:
{
    800057d6:	1141                	add	sp,sp,-16
    800057d8:	e406                	sd	ra,8(sp)
    800057da:	e022                	sd	s0,0(sp)
    800057dc:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057de:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057e2:	7779                	lui	a4,0xffffe
    800057e4:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc73f>
    800057e8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ea:	6705                	lui	a4,0x1
    800057ec:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057f0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057f2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057f6:	ffffb797          	auipc	a5,0xffffb
    800057fa:	b7278793          	add	a5,a5,-1166 # 80000368 <main>
    800057fe:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005802:	4781                	li	a5,0
    80005804:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005808:	67c1                	lui	a5,0x10
    8000580a:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000580c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005810:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005814:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005818:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000581c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005820:	57fd                	li	a5,-1
    80005822:	83a9                	srl	a5,a5,0xa
    80005824:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005828:	47bd                	li	a5,15
    8000582a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000582e:	00000097          	auipc	ra,0x0
    80005832:	f38080e7          	jalr	-200(ra) # 80005766 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005836:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000583a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000583c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000583e:	30200073          	mret
}
    80005842:	60a2                	ld	ra,8(sp)
    80005844:	6402                	ld	s0,0(sp)
    80005846:	0141                	add	sp,sp,16
    80005848:	8082                	ret

000000008000584a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000584a:	715d                	add	sp,sp,-80
    8000584c:	e486                	sd	ra,72(sp)
    8000584e:	e0a2                	sd	s0,64(sp)
    80005850:	fc26                	sd	s1,56(sp)
    80005852:	f84a                	sd	s2,48(sp)
    80005854:	f44e                	sd	s3,40(sp)
    80005856:	f052                	sd	s4,32(sp)
    80005858:	ec56                	sd	s5,24(sp)
    8000585a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000585c:	04c05763          	blez	a2,800058aa <consolewrite+0x60>
    80005860:	8a2a                	mv	s4,a0
    80005862:	84ae                	mv	s1,a1
    80005864:	89b2                	mv	s3,a2
    80005866:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005868:	5afd                	li	s5,-1
    8000586a:	4685                	li	a3,1
    8000586c:	8626                	mv	a2,s1
    8000586e:	85d2                	mv	a1,s4
    80005870:	fbf40513          	add	a0,s0,-65
    80005874:	ffffc097          	auipc	ra,0xffffc
    80005878:	13a080e7          	jalr	314(ra) # 800019ae <either_copyin>
    8000587c:	01550d63          	beq	a0,s5,80005896 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005880:	fbf44503          	lbu	a0,-65(s0)
    80005884:	00000097          	auipc	ra,0x0
    80005888:	780080e7          	jalr	1920(ra) # 80006004 <uartputc>
  for(i = 0; i < n; i++){
    8000588c:	2905                	addw	s2,s2,1
    8000588e:	0485                	add	s1,s1,1
    80005890:	fd299de3          	bne	s3,s2,8000586a <consolewrite+0x20>
    80005894:	894e                	mv	s2,s3
  }

  return i;
}
    80005896:	854a                	mv	a0,s2
    80005898:	60a6                	ld	ra,72(sp)
    8000589a:	6406                	ld	s0,64(sp)
    8000589c:	74e2                	ld	s1,56(sp)
    8000589e:	7942                	ld	s2,48(sp)
    800058a0:	79a2                	ld	s3,40(sp)
    800058a2:	7a02                	ld	s4,32(sp)
    800058a4:	6ae2                	ld	s5,24(sp)
    800058a6:	6161                	add	sp,sp,80
    800058a8:	8082                	ret
  for(i = 0; i < n; i++){
    800058aa:	4901                	li	s2,0
    800058ac:	b7ed                	j	80005896 <consolewrite+0x4c>

00000000800058ae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058ae:	711d                	add	sp,sp,-96
    800058b0:	ec86                	sd	ra,88(sp)
    800058b2:	e8a2                	sd	s0,80(sp)
    800058b4:	e4a6                	sd	s1,72(sp)
    800058b6:	e0ca                	sd	s2,64(sp)
    800058b8:	fc4e                	sd	s3,56(sp)
    800058ba:	f852                	sd	s4,48(sp)
    800058bc:	f456                	sd	s5,40(sp)
    800058be:	f05a                	sd	s6,32(sp)
    800058c0:	ec5e                	sd	s7,24(sp)
    800058c2:	1080                	add	s0,sp,96
    800058c4:	8aaa                	mv	s5,a0
    800058c6:	8a2e                	mv	s4,a1
    800058c8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058ca:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058ce:	0001c517          	auipc	a0,0x1c
    800058d2:	6f250513          	add	a0,a0,1778 # 80021fc0 <cons>
    800058d6:	00001097          	auipc	ra,0x1
    800058da:	8e8080e7          	jalr	-1816(ra) # 800061be <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058de:	0001c497          	auipc	s1,0x1c
    800058e2:	6e248493          	add	s1,s1,1762 # 80021fc0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058e6:	0001c917          	auipc	s2,0x1c
    800058ea:	77290913          	add	s2,s2,1906 # 80022058 <cons+0x98>
  while(n > 0){
    800058ee:	09305263          	blez	s3,80005972 <consoleread+0xc4>
    while(cons.r == cons.w){
    800058f2:	0984a783          	lw	a5,152(s1)
    800058f6:	09c4a703          	lw	a4,156(s1)
    800058fa:	02f71763          	bne	a4,a5,80005928 <consoleread+0x7a>
      if(killed(myproc())){
    800058fe:	ffffb097          	auipc	ra,0xffffb
    80005902:	59e080e7          	jalr	1438(ra) # 80000e9c <myproc>
    80005906:	ffffc097          	auipc	ra,0xffffc
    8000590a:	ef2080e7          	jalr	-270(ra) # 800017f8 <killed>
    8000590e:	ed2d                	bnez	a0,80005988 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005910:	85a6                	mv	a1,s1
    80005912:	854a                	mv	a0,s2
    80005914:	ffffc097          	auipc	ra,0xffffc
    80005918:	c3c080e7          	jalr	-964(ra) # 80001550 <sleep>
    while(cons.r == cons.w){
    8000591c:	0984a783          	lw	a5,152(s1)
    80005920:	09c4a703          	lw	a4,156(s1)
    80005924:	fcf70de3          	beq	a4,a5,800058fe <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005928:	0001c717          	auipc	a4,0x1c
    8000592c:	69870713          	add	a4,a4,1688 # 80021fc0 <cons>
    80005930:	0017869b          	addw	a3,a5,1
    80005934:	08d72c23          	sw	a3,152(a4)
    80005938:	07f7f693          	and	a3,a5,127
    8000593c:	9736                	add	a4,a4,a3
    8000593e:	01874703          	lbu	a4,24(a4)
    80005942:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005946:	4691                	li	a3,4
    80005948:	06db8463          	beq	s7,a3,800059b0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000594c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005950:	4685                	li	a3,1
    80005952:	faf40613          	add	a2,s0,-81
    80005956:	85d2                	mv	a1,s4
    80005958:	8556                	mv	a0,s5
    8000595a:	ffffc097          	auipc	ra,0xffffc
    8000595e:	ffe080e7          	jalr	-2(ra) # 80001958 <either_copyout>
    80005962:	57fd                	li	a5,-1
    80005964:	00f50763          	beq	a0,a5,80005972 <consoleread+0xc4>
      break;

    dst++;
    80005968:	0a05                	add	s4,s4,1
    --n;
    8000596a:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    8000596c:	47a9                	li	a5,10
    8000596e:	f8fb90e3          	bne	s7,a5,800058ee <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005972:	0001c517          	auipc	a0,0x1c
    80005976:	64e50513          	add	a0,a0,1614 # 80021fc0 <cons>
    8000597a:	00001097          	auipc	ra,0x1
    8000597e:	8f8080e7          	jalr	-1800(ra) # 80006272 <release>

  return target - n;
    80005982:	413b053b          	subw	a0,s6,s3
    80005986:	a811                	j	8000599a <consoleread+0xec>
        release(&cons.lock);
    80005988:	0001c517          	auipc	a0,0x1c
    8000598c:	63850513          	add	a0,a0,1592 # 80021fc0 <cons>
    80005990:	00001097          	auipc	ra,0x1
    80005994:	8e2080e7          	jalr	-1822(ra) # 80006272 <release>
        return -1;
    80005998:	557d                	li	a0,-1
}
    8000599a:	60e6                	ld	ra,88(sp)
    8000599c:	6446                	ld	s0,80(sp)
    8000599e:	64a6                	ld	s1,72(sp)
    800059a0:	6906                	ld	s2,64(sp)
    800059a2:	79e2                	ld	s3,56(sp)
    800059a4:	7a42                	ld	s4,48(sp)
    800059a6:	7aa2                	ld	s5,40(sp)
    800059a8:	7b02                	ld	s6,32(sp)
    800059aa:	6be2                	ld	s7,24(sp)
    800059ac:	6125                	add	sp,sp,96
    800059ae:	8082                	ret
      if(n < target){
    800059b0:	0009871b          	sext.w	a4,s3
    800059b4:	fb677fe3          	bgeu	a4,s6,80005972 <consoleread+0xc4>
        cons.r--;
    800059b8:	0001c717          	auipc	a4,0x1c
    800059bc:	6af72023          	sw	a5,1696(a4) # 80022058 <cons+0x98>
    800059c0:	bf4d                	j	80005972 <consoleread+0xc4>

00000000800059c2 <consputc>:
{
    800059c2:	1141                	add	sp,sp,-16
    800059c4:	e406                	sd	ra,8(sp)
    800059c6:	e022                	sd	s0,0(sp)
    800059c8:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    800059ca:	10000793          	li	a5,256
    800059ce:	00f50a63          	beq	a0,a5,800059e2 <consputc+0x20>
    uartputc_sync(c);
    800059d2:	00000097          	auipc	ra,0x0
    800059d6:	560080e7          	jalr	1376(ra) # 80005f32 <uartputc_sync>
}
    800059da:	60a2                	ld	ra,8(sp)
    800059dc:	6402                	ld	s0,0(sp)
    800059de:	0141                	add	sp,sp,16
    800059e0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059e2:	4521                	li	a0,8
    800059e4:	00000097          	auipc	ra,0x0
    800059e8:	54e080e7          	jalr	1358(ra) # 80005f32 <uartputc_sync>
    800059ec:	02000513          	li	a0,32
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	542080e7          	jalr	1346(ra) # 80005f32 <uartputc_sync>
    800059f8:	4521                	li	a0,8
    800059fa:	00000097          	auipc	ra,0x0
    800059fe:	538080e7          	jalr	1336(ra) # 80005f32 <uartputc_sync>
    80005a02:	bfe1                	j	800059da <consputc+0x18>

0000000080005a04 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a04:	1101                	add	sp,sp,-32
    80005a06:	ec06                	sd	ra,24(sp)
    80005a08:	e822                	sd	s0,16(sp)
    80005a0a:	e426                	sd	s1,8(sp)
    80005a0c:	e04a                	sd	s2,0(sp)
    80005a0e:	1000                	add	s0,sp,32
    80005a10:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a12:	0001c517          	auipc	a0,0x1c
    80005a16:	5ae50513          	add	a0,a0,1454 # 80021fc0 <cons>
    80005a1a:	00000097          	auipc	ra,0x0
    80005a1e:	7a4080e7          	jalr	1956(ra) # 800061be <acquire>

  switch(c){
    80005a22:	47d5                	li	a5,21
    80005a24:	0af48663          	beq	s1,a5,80005ad0 <consoleintr+0xcc>
    80005a28:	0297ca63          	blt	a5,s1,80005a5c <consoleintr+0x58>
    80005a2c:	47a1                	li	a5,8
    80005a2e:	0ef48763          	beq	s1,a5,80005b1c <consoleintr+0x118>
    80005a32:	47c1                	li	a5,16
    80005a34:	10f49a63          	bne	s1,a5,80005b48 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a38:	ffffc097          	auipc	ra,0xffffc
    80005a3c:	fcc080e7          	jalr	-52(ra) # 80001a04 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a40:	0001c517          	auipc	a0,0x1c
    80005a44:	58050513          	add	a0,a0,1408 # 80021fc0 <cons>
    80005a48:	00001097          	auipc	ra,0x1
    80005a4c:	82a080e7          	jalr	-2006(ra) # 80006272 <release>
}
    80005a50:	60e2                	ld	ra,24(sp)
    80005a52:	6442                	ld	s0,16(sp)
    80005a54:	64a2                	ld	s1,8(sp)
    80005a56:	6902                	ld	s2,0(sp)
    80005a58:	6105                	add	sp,sp,32
    80005a5a:	8082                	ret
  switch(c){
    80005a5c:	07f00793          	li	a5,127
    80005a60:	0af48e63          	beq	s1,a5,80005b1c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a64:	0001c717          	auipc	a4,0x1c
    80005a68:	55c70713          	add	a4,a4,1372 # 80021fc0 <cons>
    80005a6c:	0a072783          	lw	a5,160(a4)
    80005a70:	09872703          	lw	a4,152(a4)
    80005a74:	9f99                	subw	a5,a5,a4
    80005a76:	07f00713          	li	a4,127
    80005a7a:	fcf763e3          	bltu	a4,a5,80005a40 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a7e:	47b5                	li	a5,13
    80005a80:	0cf48763          	beq	s1,a5,80005b4e <consoleintr+0x14a>
      consputc(c);
    80005a84:	8526                	mv	a0,s1
    80005a86:	00000097          	auipc	ra,0x0
    80005a8a:	f3c080e7          	jalr	-196(ra) # 800059c2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a8e:	0001c797          	auipc	a5,0x1c
    80005a92:	53278793          	add	a5,a5,1330 # 80021fc0 <cons>
    80005a96:	0a07a683          	lw	a3,160(a5)
    80005a9a:	0016871b          	addw	a4,a3,1
    80005a9e:	0007061b          	sext.w	a2,a4
    80005aa2:	0ae7a023          	sw	a4,160(a5)
    80005aa6:	07f6f693          	and	a3,a3,127
    80005aaa:	97b6                	add	a5,a5,a3
    80005aac:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005ab0:	47a9                	li	a5,10
    80005ab2:	0cf48563          	beq	s1,a5,80005b7c <consoleintr+0x178>
    80005ab6:	4791                	li	a5,4
    80005ab8:	0cf48263          	beq	s1,a5,80005b7c <consoleintr+0x178>
    80005abc:	0001c797          	auipc	a5,0x1c
    80005ac0:	59c7a783          	lw	a5,1436(a5) # 80022058 <cons+0x98>
    80005ac4:	9f1d                	subw	a4,a4,a5
    80005ac6:	08000793          	li	a5,128
    80005aca:	f6f71be3          	bne	a4,a5,80005a40 <consoleintr+0x3c>
    80005ace:	a07d                	j	80005b7c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ad0:	0001c717          	auipc	a4,0x1c
    80005ad4:	4f070713          	add	a4,a4,1264 # 80021fc0 <cons>
    80005ad8:	0a072783          	lw	a5,160(a4)
    80005adc:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ae0:	0001c497          	auipc	s1,0x1c
    80005ae4:	4e048493          	add	s1,s1,1248 # 80021fc0 <cons>
    while(cons.e != cons.w &&
    80005ae8:	4929                	li	s2,10
    80005aea:	f4f70be3          	beq	a4,a5,80005a40 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005aee:	37fd                	addw	a5,a5,-1
    80005af0:	07f7f713          	and	a4,a5,127
    80005af4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005af6:	01874703          	lbu	a4,24(a4)
    80005afa:	f52703e3          	beq	a4,s2,80005a40 <consoleintr+0x3c>
      cons.e--;
    80005afe:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b02:	10000513          	li	a0,256
    80005b06:	00000097          	auipc	ra,0x0
    80005b0a:	ebc080e7          	jalr	-324(ra) # 800059c2 <consputc>
    while(cons.e != cons.w &&
    80005b0e:	0a04a783          	lw	a5,160(s1)
    80005b12:	09c4a703          	lw	a4,156(s1)
    80005b16:	fcf71ce3          	bne	a4,a5,80005aee <consoleintr+0xea>
    80005b1a:	b71d                	j	80005a40 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b1c:	0001c717          	auipc	a4,0x1c
    80005b20:	4a470713          	add	a4,a4,1188 # 80021fc0 <cons>
    80005b24:	0a072783          	lw	a5,160(a4)
    80005b28:	09c72703          	lw	a4,156(a4)
    80005b2c:	f0f70ae3          	beq	a4,a5,80005a40 <consoleintr+0x3c>
      cons.e--;
    80005b30:	37fd                	addw	a5,a5,-1
    80005b32:	0001c717          	auipc	a4,0x1c
    80005b36:	52f72723          	sw	a5,1326(a4) # 80022060 <cons+0xa0>
      consputc(BACKSPACE);
    80005b3a:	10000513          	li	a0,256
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	e84080e7          	jalr	-380(ra) # 800059c2 <consputc>
    80005b46:	bded                	j	80005a40 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b48:	ee048ce3          	beqz	s1,80005a40 <consoleintr+0x3c>
    80005b4c:	bf21                	j	80005a64 <consoleintr+0x60>
      consputc(c);
    80005b4e:	4529                	li	a0,10
    80005b50:	00000097          	auipc	ra,0x0
    80005b54:	e72080e7          	jalr	-398(ra) # 800059c2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b58:	0001c797          	auipc	a5,0x1c
    80005b5c:	46878793          	add	a5,a5,1128 # 80021fc0 <cons>
    80005b60:	0a07a703          	lw	a4,160(a5)
    80005b64:	0017069b          	addw	a3,a4,1
    80005b68:	0006861b          	sext.w	a2,a3
    80005b6c:	0ad7a023          	sw	a3,160(a5)
    80005b70:	07f77713          	and	a4,a4,127
    80005b74:	97ba                	add	a5,a5,a4
    80005b76:	4729                	li	a4,10
    80005b78:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b7c:	0001c797          	auipc	a5,0x1c
    80005b80:	4ec7a023          	sw	a2,1248(a5) # 8002205c <cons+0x9c>
        wakeup(&cons.r);
    80005b84:	0001c517          	auipc	a0,0x1c
    80005b88:	4d450513          	add	a0,a0,1236 # 80022058 <cons+0x98>
    80005b8c:	ffffc097          	auipc	ra,0xffffc
    80005b90:	a28080e7          	jalr	-1496(ra) # 800015b4 <wakeup>
    80005b94:	b575                	j	80005a40 <consoleintr+0x3c>

0000000080005b96 <consoleinit>:

void
consoleinit(void)
{
    80005b96:	1141                	add	sp,sp,-16
    80005b98:	e406                	sd	ra,8(sp)
    80005b9a:	e022                	sd	s0,0(sp)
    80005b9c:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b9e:	00003597          	auipc	a1,0x3
    80005ba2:	db258593          	add	a1,a1,-590 # 80008950 <syscall_names+0x3f8>
    80005ba6:	0001c517          	auipc	a0,0x1c
    80005baa:	41a50513          	add	a0,a0,1050 # 80021fc0 <cons>
    80005bae:	00000097          	auipc	ra,0x0
    80005bb2:	580080e7          	jalr	1408(ra) # 8000612e <initlock>

  uartinit();
    80005bb6:	00000097          	auipc	ra,0x0
    80005bba:	32c080e7          	jalr	812(ra) # 80005ee2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bbe:	00013797          	auipc	a5,0x13
    80005bc2:	12a78793          	add	a5,a5,298 # 80018ce8 <devsw>
    80005bc6:	00000717          	auipc	a4,0x0
    80005bca:	ce870713          	add	a4,a4,-792 # 800058ae <consoleread>
    80005bce:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bd0:	00000717          	auipc	a4,0x0
    80005bd4:	c7a70713          	add	a4,a4,-902 # 8000584a <consolewrite>
    80005bd8:	ef98                	sd	a4,24(a5)
}
    80005bda:	60a2                	ld	ra,8(sp)
    80005bdc:	6402                	ld	s0,0(sp)
    80005bde:	0141                	add	sp,sp,16
    80005be0:	8082                	ret

0000000080005be2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005be2:	7179                	add	sp,sp,-48
    80005be4:	f406                	sd	ra,40(sp)
    80005be6:	f022                	sd	s0,32(sp)
    80005be8:	ec26                	sd	s1,24(sp)
    80005bea:	e84a                	sd	s2,16(sp)
    80005bec:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bee:	c219                	beqz	a2,80005bf4 <printint+0x12>
    80005bf0:	08054763          	bltz	a0,80005c7e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005bf4:	2501                	sext.w	a0,a0
    80005bf6:	4881                	li	a7,0
    80005bf8:	fd040693          	add	a3,s0,-48

  i = 0;
    80005bfc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bfe:	2581                	sext.w	a1,a1
    80005c00:	00003617          	auipc	a2,0x3
    80005c04:	d8060613          	add	a2,a2,-640 # 80008980 <digits>
    80005c08:	883a                	mv	a6,a4
    80005c0a:	2705                	addw	a4,a4,1
    80005c0c:	02b577bb          	remuw	a5,a0,a1
    80005c10:	1782                	sll	a5,a5,0x20
    80005c12:	9381                	srl	a5,a5,0x20
    80005c14:	97b2                	add	a5,a5,a2
    80005c16:	0007c783          	lbu	a5,0(a5)
    80005c1a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c1e:	0005079b          	sext.w	a5,a0
    80005c22:	02b5553b          	divuw	a0,a0,a1
    80005c26:	0685                	add	a3,a3,1
    80005c28:	feb7f0e3          	bgeu	a5,a1,80005c08 <printint+0x26>

  if(sign)
    80005c2c:	00088c63          	beqz	a7,80005c44 <printint+0x62>
    buf[i++] = '-';
    80005c30:	fe070793          	add	a5,a4,-32
    80005c34:	00878733          	add	a4,a5,s0
    80005c38:	02d00793          	li	a5,45
    80005c3c:	fef70823          	sb	a5,-16(a4)
    80005c40:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005c44:	02e05763          	blez	a4,80005c72 <printint+0x90>
    80005c48:	fd040793          	add	a5,s0,-48
    80005c4c:	00e784b3          	add	s1,a5,a4
    80005c50:	fff78913          	add	s2,a5,-1
    80005c54:	993a                	add	s2,s2,a4
    80005c56:	377d                	addw	a4,a4,-1
    80005c58:	1702                	sll	a4,a4,0x20
    80005c5a:	9301                	srl	a4,a4,0x20
    80005c5c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c60:	fff4c503          	lbu	a0,-1(s1)
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	d5e080e7          	jalr	-674(ra) # 800059c2 <consputc>
  while(--i >= 0)
    80005c6c:	14fd                	add	s1,s1,-1
    80005c6e:	ff2499e3          	bne	s1,s2,80005c60 <printint+0x7e>
}
    80005c72:	70a2                	ld	ra,40(sp)
    80005c74:	7402                	ld	s0,32(sp)
    80005c76:	64e2                	ld	s1,24(sp)
    80005c78:	6942                	ld	s2,16(sp)
    80005c7a:	6145                	add	sp,sp,48
    80005c7c:	8082                	ret
    x = -xx;
    80005c7e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c82:	4885                	li	a7,1
    x = -xx;
    80005c84:	bf95                	j	80005bf8 <printint+0x16>

0000000080005c86 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c86:	1101                	add	sp,sp,-32
    80005c88:	ec06                	sd	ra,24(sp)
    80005c8a:	e822                	sd	s0,16(sp)
    80005c8c:	e426                	sd	s1,8(sp)
    80005c8e:	1000                	add	s0,sp,32
    80005c90:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c92:	0001c797          	auipc	a5,0x1c
    80005c96:	3e07a723          	sw	zero,1006(a5) # 80022080 <pr+0x18>
  printf("panic: ");
    80005c9a:	00003517          	auipc	a0,0x3
    80005c9e:	cbe50513          	add	a0,a0,-834 # 80008958 <syscall_names+0x400>
    80005ca2:	00000097          	auipc	ra,0x0
    80005ca6:	02e080e7          	jalr	46(ra) # 80005cd0 <printf>
  printf(s);
    80005caa:	8526                	mv	a0,s1
    80005cac:	00000097          	auipc	ra,0x0
    80005cb0:	024080e7          	jalr	36(ra) # 80005cd0 <printf>
  printf("\n");
    80005cb4:	00002517          	auipc	a0,0x2
    80005cb8:	39450513          	add	a0,a0,916 # 80008048 <etext+0x48>
    80005cbc:	00000097          	auipc	ra,0x0
    80005cc0:	014080e7          	jalr	20(ra) # 80005cd0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cc4:	4785                	li	a5,1
    80005cc6:	00003717          	auipc	a4,0x3
    80005cca:	d6f72b23          	sw	a5,-650(a4) # 80008a3c <panicked>
  for(;;)
    80005cce:	a001                	j	80005cce <panic+0x48>

0000000080005cd0 <printf>:
{
    80005cd0:	7131                	add	sp,sp,-192
    80005cd2:	fc86                	sd	ra,120(sp)
    80005cd4:	f8a2                	sd	s0,112(sp)
    80005cd6:	f4a6                	sd	s1,104(sp)
    80005cd8:	f0ca                	sd	s2,96(sp)
    80005cda:	ecce                	sd	s3,88(sp)
    80005cdc:	e8d2                	sd	s4,80(sp)
    80005cde:	e4d6                	sd	s5,72(sp)
    80005ce0:	e0da                	sd	s6,64(sp)
    80005ce2:	fc5e                	sd	s7,56(sp)
    80005ce4:	f862                	sd	s8,48(sp)
    80005ce6:	f466                	sd	s9,40(sp)
    80005ce8:	f06a                	sd	s10,32(sp)
    80005cea:	ec6e                	sd	s11,24(sp)
    80005cec:	0100                	add	s0,sp,128
    80005cee:	8a2a                	mv	s4,a0
    80005cf0:	e40c                	sd	a1,8(s0)
    80005cf2:	e810                	sd	a2,16(s0)
    80005cf4:	ec14                	sd	a3,24(s0)
    80005cf6:	f018                	sd	a4,32(s0)
    80005cf8:	f41c                	sd	a5,40(s0)
    80005cfa:	03043823          	sd	a6,48(s0)
    80005cfe:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d02:	0001cd97          	auipc	s11,0x1c
    80005d06:	37edad83          	lw	s11,894(s11) # 80022080 <pr+0x18>
  if(locking)
    80005d0a:	020d9b63          	bnez	s11,80005d40 <printf+0x70>
  if (fmt == 0)
    80005d0e:	040a0263          	beqz	s4,80005d52 <printf+0x82>
  va_start(ap, fmt);
    80005d12:	00840793          	add	a5,s0,8
    80005d16:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d1a:	000a4503          	lbu	a0,0(s4)
    80005d1e:	14050f63          	beqz	a0,80005e7c <printf+0x1ac>
    80005d22:	4981                	li	s3,0
    if(c != '%'){
    80005d24:	02500a93          	li	s5,37
    switch(c){
    80005d28:	07000b93          	li	s7,112
  consputc('x');
    80005d2c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d2e:	00003b17          	auipc	s6,0x3
    80005d32:	c52b0b13          	add	s6,s6,-942 # 80008980 <digits>
    switch(c){
    80005d36:	07300c93          	li	s9,115
    80005d3a:	06400c13          	li	s8,100
    80005d3e:	a82d                	j	80005d78 <printf+0xa8>
    acquire(&pr.lock);
    80005d40:	0001c517          	auipc	a0,0x1c
    80005d44:	32850513          	add	a0,a0,808 # 80022068 <pr>
    80005d48:	00000097          	auipc	ra,0x0
    80005d4c:	476080e7          	jalr	1142(ra) # 800061be <acquire>
    80005d50:	bf7d                	j	80005d0e <printf+0x3e>
    panic("null fmt");
    80005d52:	00003517          	auipc	a0,0x3
    80005d56:	c1650513          	add	a0,a0,-1002 # 80008968 <syscall_names+0x410>
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	f2c080e7          	jalr	-212(ra) # 80005c86 <panic>
      consputc(c);
    80005d62:	00000097          	auipc	ra,0x0
    80005d66:	c60080e7          	jalr	-928(ra) # 800059c2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d6a:	2985                	addw	s3,s3,1
    80005d6c:	013a07b3          	add	a5,s4,s3
    80005d70:	0007c503          	lbu	a0,0(a5)
    80005d74:	10050463          	beqz	a0,80005e7c <printf+0x1ac>
    if(c != '%'){
    80005d78:	ff5515e3          	bne	a0,s5,80005d62 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d7c:	2985                	addw	s3,s3,1
    80005d7e:	013a07b3          	add	a5,s4,s3
    80005d82:	0007c783          	lbu	a5,0(a5)
    80005d86:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d8a:	cbed                	beqz	a5,80005e7c <printf+0x1ac>
    switch(c){
    80005d8c:	05778a63          	beq	a5,s7,80005de0 <printf+0x110>
    80005d90:	02fbf663          	bgeu	s7,a5,80005dbc <printf+0xec>
    80005d94:	09978863          	beq	a5,s9,80005e24 <printf+0x154>
    80005d98:	07800713          	li	a4,120
    80005d9c:	0ce79563          	bne	a5,a4,80005e66 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005da0:	f8843783          	ld	a5,-120(s0)
    80005da4:	00878713          	add	a4,a5,8
    80005da8:	f8e43423          	sd	a4,-120(s0)
    80005dac:	4605                	li	a2,1
    80005dae:	85ea                	mv	a1,s10
    80005db0:	4388                	lw	a0,0(a5)
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	e30080e7          	jalr	-464(ra) # 80005be2 <printint>
      break;
    80005dba:	bf45                	j	80005d6a <printf+0x9a>
    switch(c){
    80005dbc:	09578f63          	beq	a5,s5,80005e5a <printf+0x18a>
    80005dc0:	0b879363          	bne	a5,s8,80005e66 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005dc4:	f8843783          	ld	a5,-120(s0)
    80005dc8:	00878713          	add	a4,a5,8
    80005dcc:	f8e43423          	sd	a4,-120(s0)
    80005dd0:	4605                	li	a2,1
    80005dd2:	45a9                	li	a1,10
    80005dd4:	4388                	lw	a0,0(a5)
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	e0c080e7          	jalr	-500(ra) # 80005be2 <printint>
      break;
    80005dde:	b771                	j	80005d6a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005de0:	f8843783          	ld	a5,-120(s0)
    80005de4:	00878713          	add	a4,a5,8
    80005de8:	f8e43423          	sd	a4,-120(s0)
    80005dec:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005df0:	03000513          	li	a0,48
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	bce080e7          	jalr	-1074(ra) # 800059c2 <consputc>
  consputc('x');
    80005dfc:	07800513          	li	a0,120
    80005e00:	00000097          	auipc	ra,0x0
    80005e04:	bc2080e7          	jalr	-1086(ra) # 800059c2 <consputc>
    80005e08:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e0a:	03c95793          	srl	a5,s2,0x3c
    80005e0e:	97da                	add	a5,a5,s6
    80005e10:	0007c503          	lbu	a0,0(a5)
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	bae080e7          	jalr	-1106(ra) # 800059c2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e1c:	0912                	sll	s2,s2,0x4
    80005e1e:	34fd                	addw	s1,s1,-1
    80005e20:	f4ed                	bnez	s1,80005e0a <printf+0x13a>
    80005e22:	b7a1                	j	80005d6a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e24:	f8843783          	ld	a5,-120(s0)
    80005e28:	00878713          	add	a4,a5,8
    80005e2c:	f8e43423          	sd	a4,-120(s0)
    80005e30:	6384                	ld	s1,0(a5)
    80005e32:	cc89                	beqz	s1,80005e4c <printf+0x17c>
      for(; *s; s++)
    80005e34:	0004c503          	lbu	a0,0(s1)
    80005e38:	d90d                	beqz	a0,80005d6a <printf+0x9a>
        consputc(*s);
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	b88080e7          	jalr	-1144(ra) # 800059c2 <consputc>
      for(; *s; s++)
    80005e42:	0485                	add	s1,s1,1
    80005e44:	0004c503          	lbu	a0,0(s1)
    80005e48:	f96d                	bnez	a0,80005e3a <printf+0x16a>
    80005e4a:	b705                	j	80005d6a <printf+0x9a>
        s = "(null)";
    80005e4c:	00003497          	auipc	s1,0x3
    80005e50:	b1448493          	add	s1,s1,-1260 # 80008960 <syscall_names+0x408>
      for(; *s; s++)
    80005e54:	02800513          	li	a0,40
    80005e58:	b7cd                	j	80005e3a <printf+0x16a>
      consputc('%');
    80005e5a:	8556                	mv	a0,s5
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	b66080e7          	jalr	-1178(ra) # 800059c2 <consputc>
      break;
    80005e64:	b719                	j	80005d6a <printf+0x9a>
      consputc('%');
    80005e66:	8556                	mv	a0,s5
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	b5a080e7          	jalr	-1190(ra) # 800059c2 <consputc>
      consputc(c);
    80005e70:	8526                	mv	a0,s1
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	b50080e7          	jalr	-1200(ra) # 800059c2 <consputc>
      break;
    80005e7a:	bdc5                	j	80005d6a <printf+0x9a>
  if(locking)
    80005e7c:	020d9163          	bnez	s11,80005e9e <printf+0x1ce>
}
    80005e80:	70e6                	ld	ra,120(sp)
    80005e82:	7446                	ld	s0,112(sp)
    80005e84:	74a6                	ld	s1,104(sp)
    80005e86:	7906                	ld	s2,96(sp)
    80005e88:	69e6                	ld	s3,88(sp)
    80005e8a:	6a46                	ld	s4,80(sp)
    80005e8c:	6aa6                	ld	s5,72(sp)
    80005e8e:	6b06                	ld	s6,64(sp)
    80005e90:	7be2                	ld	s7,56(sp)
    80005e92:	7c42                	ld	s8,48(sp)
    80005e94:	7ca2                	ld	s9,40(sp)
    80005e96:	7d02                	ld	s10,32(sp)
    80005e98:	6de2                	ld	s11,24(sp)
    80005e9a:	6129                	add	sp,sp,192
    80005e9c:	8082                	ret
    release(&pr.lock);
    80005e9e:	0001c517          	auipc	a0,0x1c
    80005ea2:	1ca50513          	add	a0,a0,458 # 80022068 <pr>
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	3cc080e7          	jalr	972(ra) # 80006272 <release>
}
    80005eae:	bfc9                	j	80005e80 <printf+0x1b0>

0000000080005eb0 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005eb0:	1101                	add	sp,sp,-32
    80005eb2:	ec06                	sd	ra,24(sp)
    80005eb4:	e822                	sd	s0,16(sp)
    80005eb6:	e426                	sd	s1,8(sp)
    80005eb8:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80005eba:	0001c497          	auipc	s1,0x1c
    80005ebe:	1ae48493          	add	s1,s1,430 # 80022068 <pr>
    80005ec2:	00003597          	auipc	a1,0x3
    80005ec6:	ab658593          	add	a1,a1,-1354 # 80008978 <syscall_names+0x420>
    80005eca:	8526                	mv	a0,s1
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	262080e7          	jalr	610(ra) # 8000612e <initlock>
  pr.locking = 1;
    80005ed4:	4785                	li	a5,1
    80005ed6:	cc9c                	sw	a5,24(s1)
}
    80005ed8:	60e2                	ld	ra,24(sp)
    80005eda:	6442                	ld	s0,16(sp)
    80005edc:	64a2                	ld	s1,8(sp)
    80005ede:	6105                	add	sp,sp,32
    80005ee0:	8082                	ret

0000000080005ee2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ee2:	1141                	add	sp,sp,-16
    80005ee4:	e406                	sd	ra,8(sp)
    80005ee6:	e022                	sd	s0,0(sp)
    80005ee8:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005eea:	100007b7          	lui	a5,0x10000
    80005eee:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ef2:	f8000713          	li	a4,-128
    80005ef6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005efa:	470d                	li	a4,3
    80005efc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f00:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f04:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f08:	469d                	li	a3,7
    80005f0a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f0e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f12:	00003597          	auipc	a1,0x3
    80005f16:	a8658593          	add	a1,a1,-1402 # 80008998 <digits+0x18>
    80005f1a:	0001c517          	auipc	a0,0x1c
    80005f1e:	16e50513          	add	a0,a0,366 # 80022088 <uart_tx_lock>
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	20c080e7          	jalr	524(ra) # 8000612e <initlock>
}
    80005f2a:	60a2                	ld	ra,8(sp)
    80005f2c:	6402                	ld	s0,0(sp)
    80005f2e:	0141                	add	sp,sp,16
    80005f30:	8082                	ret

0000000080005f32 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f32:	1101                	add	sp,sp,-32
    80005f34:	ec06                	sd	ra,24(sp)
    80005f36:	e822                	sd	s0,16(sp)
    80005f38:	e426                	sd	s1,8(sp)
    80005f3a:	1000                	add	s0,sp,32
    80005f3c:	84aa                	mv	s1,a0
  push_off();
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	234080e7          	jalr	564(ra) # 80006172 <push_off>

  if(panicked){
    80005f46:	00003797          	auipc	a5,0x3
    80005f4a:	af67a783          	lw	a5,-1290(a5) # 80008a3c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f4e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f52:	c391                	beqz	a5,80005f56 <uartputc_sync+0x24>
    for(;;)
    80005f54:	a001                	j	80005f54 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f56:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f5a:	0207f793          	and	a5,a5,32
    80005f5e:	dfe5                	beqz	a5,80005f56 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f60:	0ff4f513          	zext.b	a0,s1
    80005f64:	100007b7          	lui	a5,0x10000
    80005f68:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	2a6080e7          	jalr	678(ra) # 80006212 <pop_off>
}
    80005f74:	60e2                	ld	ra,24(sp)
    80005f76:	6442                	ld	s0,16(sp)
    80005f78:	64a2                	ld	s1,8(sp)
    80005f7a:	6105                	add	sp,sp,32
    80005f7c:	8082                	ret

0000000080005f7e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f7e:	00003797          	auipc	a5,0x3
    80005f82:	ac27b783          	ld	a5,-1342(a5) # 80008a40 <uart_tx_r>
    80005f86:	00003717          	auipc	a4,0x3
    80005f8a:	ac273703          	ld	a4,-1342(a4) # 80008a48 <uart_tx_w>
    80005f8e:	06f70a63          	beq	a4,a5,80006002 <uartstart+0x84>
{
    80005f92:	7139                	add	sp,sp,-64
    80005f94:	fc06                	sd	ra,56(sp)
    80005f96:	f822                	sd	s0,48(sp)
    80005f98:	f426                	sd	s1,40(sp)
    80005f9a:	f04a                	sd	s2,32(sp)
    80005f9c:	ec4e                	sd	s3,24(sp)
    80005f9e:	e852                	sd	s4,16(sp)
    80005fa0:	e456                	sd	s5,8(sp)
    80005fa2:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fa4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fa8:	0001ca17          	auipc	s4,0x1c
    80005fac:	0e0a0a13          	add	s4,s4,224 # 80022088 <uart_tx_lock>
    uart_tx_r += 1;
    80005fb0:	00003497          	auipc	s1,0x3
    80005fb4:	a9048493          	add	s1,s1,-1392 # 80008a40 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fb8:	00003997          	auipc	s3,0x3
    80005fbc:	a9098993          	add	s3,s3,-1392 # 80008a48 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fc0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fc4:	02077713          	and	a4,a4,32
    80005fc8:	c705                	beqz	a4,80005ff0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fca:	01f7f713          	and	a4,a5,31
    80005fce:	9752                	add	a4,a4,s4
    80005fd0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fd4:	0785                	add	a5,a5,1
    80005fd6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fd8:	8526                	mv	a0,s1
    80005fda:	ffffb097          	auipc	ra,0xffffb
    80005fde:	5da080e7          	jalr	1498(ra) # 800015b4 <wakeup>
    
    WriteReg(THR, c);
    80005fe2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fe6:	609c                	ld	a5,0(s1)
    80005fe8:	0009b703          	ld	a4,0(s3)
    80005fec:	fcf71ae3          	bne	a4,a5,80005fc0 <uartstart+0x42>
  }
}
    80005ff0:	70e2                	ld	ra,56(sp)
    80005ff2:	7442                	ld	s0,48(sp)
    80005ff4:	74a2                	ld	s1,40(sp)
    80005ff6:	7902                	ld	s2,32(sp)
    80005ff8:	69e2                	ld	s3,24(sp)
    80005ffa:	6a42                	ld	s4,16(sp)
    80005ffc:	6aa2                	ld	s5,8(sp)
    80005ffe:	6121                	add	sp,sp,64
    80006000:	8082                	ret
    80006002:	8082                	ret

0000000080006004 <uartputc>:
{
    80006004:	7179                	add	sp,sp,-48
    80006006:	f406                	sd	ra,40(sp)
    80006008:	f022                	sd	s0,32(sp)
    8000600a:	ec26                	sd	s1,24(sp)
    8000600c:	e84a                	sd	s2,16(sp)
    8000600e:	e44e                	sd	s3,8(sp)
    80006010:	e052                	sd	s4,0(sp)
    80006012:	1800                	add	s0,sp,48
    80006014:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006016:	0001c517          	auipc	a0,0x1c
    8000601a:	07250513          	add	a0,a0,114 # 80022088 <uart_tx_lock>
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	1a0080e7          	jalr	416(ra) # 800061be <acquire>
  if(panicked){
    80006026:	00003797          	auipc	a5,0x3
    8000602a:	a167a783          	lw	a5,-1514(a5) # 80008a3c <panicked>
    8000602e:	e7c9                	bnez	a5,800060b8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006030:	00003717          	auipc	a4,0x3
    80006034:	a1873703          	ld	a4,-1512(a4) # 80008a48 <uart_tx_w>
    80006038:	00003797          	auipc	a5,0x3
    8000603c:	a087b783          	ld	a5,-1528(a5) # 80008a40 <uart_tx_r>
    80006040:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006044:	0001c997          	auipc	s3,0x1c
    80006048:	04498993          	add	s3,s3,68 # 80022088 <uart_tx_lock>
    8000604c:	00003497          	auipc	s1,0x3
    80006050:	9f448493          	add	s1,s1,-1548 # 80008a40 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006054:	00003917          	auipc	s2,0x3
    80006058:	9f490913          	add	s2,s2,-1548 # 80008a48 <uart_tx_w>
    8000605c:	00e79f63          	bne	a5,a4,8000607a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006060:	85ce                	mv	a1,s3
    80006062:	8526                	mv	a0,s1
    80006064:	ffffb097          	auipc	ra,0xffffb
    80006068:	4ec080e7          	jalr	1260(ra) # 80001550 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000606c:	00093703          	ld	a4,0(s2)
    80006070:	609c                	ld	a5,0(s1)
    80006072:	02078793          	add	a5,a5,32
    80006076:	fee785e3          	beq	a5,a4,80006060 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000607a:	0001c497          	auipc	s1,0x1c
    8000607e:	00e48493          	add	s1,s1,14 # 80022088 <uart_tx_lock>
    80006082:	01f77793          	and	a5,a4,31
    80006086:	97a6                	add	a5,a5,s1
    80006088:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000608c:	0705                	add	a4,a4,1
    8000608e:	00003797          	auipc	a5,0x3
    80006092:	9ae7bd23          	sd	a4,-1606(a5) # 80008a48 <uart_tx_w>
  uartstart();
    80006096:	00000097          	auipc	ra,0x0
    8000609a:	ee8080e7          	jalr	-280(ra) # 80005f7e <uartstart>
  release(&uart_tx_lock);
    8000609e:	8526                	mv	a0,s1
    800060a0:	00000097          	auipc	ra,0x0
    800060a4:	1d2080e7          	jalr	466(ra) # 80006272 <release>
}
    800060a8:	70a2                	ld	ra,40(sp)
    800060aa:	7402                	ld	s0,32(sp)
    800060ac:	64e2                	ld	s1,24(sp)
    800060ae:	6942                	ld	s2,16(sp)
    800060b0:	69a2                	ld	s3,8(sp)
    800060b2:	6a02                	ld	s4,0(sp)
    800060b4:	6145                	add	sp,sp,48
    800060b6:	8082                	ret
    for(;;)
    800060b8:	a001                	j	800060b8 <uartputc+0xb4>

00000000800060ba <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060ba:	1141                	add	sp,sp,-16
    800060bc:	e422                	sd	s0,8(sp)
    800060be:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060c0:	100007b7          	lui	a5,0x10000
    800060c4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060c8:	8b85                	and	a5,a5,1
    800060ca:	cb81                	beqz	a5,800060da <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060cc:	100007b7          	lui	a5,0x10000
    800060d0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060d4:	6422                	ld	s0,8(sp)
    800060d6:	0141                	add	sp,sp,16
    800060d8:	8082                	ret
    return -1;
    800060da:	557d                	li	a0,-1
    800060dc:	bfe5                	j	800060d4 <uartgetc+0x1a>

00000000800060de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060de:	1101                	add	sp,sp,-32
    800060e0:	ec06                	sd	ra,24(sp)
    800060e2:	e822                	sd	s0,16(sp)
    800060e4:	e426                	sd	s1,8(sp)
    800060e6:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060e8:	54fd                	li	s1,-1
    800060ea:	a029                	j	800060f4 <uartintr+0x16>
      break;
    consoleintr(c);
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	918080e7          	jalr	-1768(ra) # 80005a04 <consoleintr>
    int c = uartgetc();
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	fc6080e7          	jalr	-58(ra) # 800060ba <uartgetc>
    if(c == -1)
    800060fc:	fe9518e3          	bne	a0,s1,800060ec <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006100:	0001c497          	auipc	s1,0x1c
    80006104:	f8848493          	add	s1,s1,-120 # 80022088 <uart_tx_lock>
    80006108:	8526                	mv	a0,s1
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	0b4080e7          	jalr	180(ra) # 800061be <acquire>
  uartstart();
    80006112:	00000097          	auipc	ra,0x0
    80006116:	e6c080e7          	jalr	-404(ra) # 80005f7e <uartstart>
  release(&uart_tx_lock);
    8000611a:	8526                	mv	a0,s1
    8000611c:	00000097          	auipc	ra,0x0
    80006120:	156080e7          	jalr	342(ra) # 80006272 <release>
}
    80006124:	60e2                	ld	ra,24(sp)
    80006126:	6442                	ld	s0,16(sp)
    80006128:	64a2                	ld	s1,8(sp)
    8000612a:	6105                	add	sp,sp,32
    8000612c:	8082                	ret

000000008000612e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000612e:	1141                	add	sp,sp,-16
    80006130:	e422                	sd	s0,8(sp)
    80006132:	0800                	add	s0,sp,16
  lk->name = name;
    80006134:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006136:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000613a:	00053823          	sd	zero,16(a0)
}
    8000613e:	6422                	ld	s0,8(sp)
    80006140:	0141                	add	sp,sp,16
    80006142:	8082                	ret

0000000080006144 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006144:	411c                	lw	a5,0(a0)
    80006146:	e399                	bnez	a5,8000614c <holding+0x8>
    80006148:	4501                	li	a0,0
  return r;
}
    8000614a:	8082                	ret
{
    8000614c:	1101                	add	sp,sp,-32
    8000614e:	ec06                	sd	ra,24(sp)
    80006150:	e822                	sd	s0,16(sp)
    80006152:	e426                	sd	s1,8(sp)
    80006154:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006156:	6904                	ld	s1,16(a0)
    80006158:	ffffb097          	auipc	ra,0xffffb
    8000615c:	d28080e7          	jalr	-728(ra) # 80000e80 <mycpu>
    80006160:	40a48533          	sub	a0,s1,a0
    80006164:	00153513          	seqz	a0,a0
}
    80006168:	60e2                	ld	ra,24(sp)
    8000616a:	6442                	ld	s0,16(sp)
    8000616c:	64a2                	ld	s1,8(sp)
    8000616e:	6105                	add	sp,sp,32
    80006170:	8082                	ret

0000000080006172 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006172:	1101                	add	sp,sp,-32
    80006174:	ec06                	sd	ra,24(sp)
    80006176:	e822                	sd	s0,16(sp)
    80006178:	e426                	sd	s1,8(sp)
    8000617a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000617c:	100024f3          	csrr	s1,sstatus
    80006180:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006184:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006186:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000618a:	ffffb097          	auipc	ra,0xffffb
    8000618e:	cf6080e7          	jalr	-778(ra) # 80000e80 <mycpu>
    80006192:	5d3c                	lw	a5,120(a0)
    80006194:	cf89                	beqz	a5,800061ae <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006196:	ffffb097          	auipc	ra,0xffffb
    8000619a:	cea080e7          	jalr	-790(ra) # 80000e80 <mycpu>
    8000619e:	5d3c                	lw	a5,120(a0)
    800061a0:	2785                	addw	a5,a5,1
    800061a2:	dd3c                	sw	a5,120(a0)
}
    800061a4:	60e2                	ld	ra,24(sp)
    800061a6:	6442                	ld	s0,16(sp)
    800061a8:	64a2                	ld	s1,8(sp)
    800061aa:	6105                	add	sp,sp,32
    800061ac:	8082                	ret
    mycpu()->intena = old;
    800061ae:	ffffb097          	auipc	ra,0xffffb
    800061b2:	cd2080e7          	jalr	-814(ra) # 80000e80 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061b6:	8085                	srl	s1,s1,0x1
    800061b8:	8885                	and	s1,s1,1
    800061ba:	dd64                	sw	s1,124(a0)
    800061bc:	bfe9                	j	80006196 <push_off+0x24>

00000000800061be <acquire>:
{
    800061be:	1101                	add	sp,sp,-32
    800061c0:	ec06                	sd	ra,24(sp)
    800061c2:	e822                	sd	s0,16(sp)
    800061c4:	e426                	sd	s1,8(sp)
    800061c6:	1000                	add	s0,sp,32
    800061c8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	fa8080e7          	jalr	-88(ra) # 80006172 <push_off>
  if(holding(lk))
    800061d2:	8526                	mv	a0,s1
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	f70080e7          	jalr	-144(ra) # 80006144 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061dc:	4705                	li	a4,1
  if(holding(lk))
    800061de:	e115                	bnez	a0,80006202 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061e0:	87ba                	mv	a5,a4
    800061e2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061e6:	2781                	sext.w	a5,a5
    800061e8:	ffe5                	bnez	a5,800061e0 <acquire+0x22>
  __sync_synchronize();
    800061ea:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061ee:	ffffb097          	auipc	ra,0xffffb
    800061f2:	c92080e7          	jalr	-878(ra) # 80000e80 <mycpu>
    800061f6:	e888                	sd	a0,16(s1)
}
    800061f8:	60e2                	ld	ra,24(sp)
    800061fa:	6442                	ld	s0,16(sp)
    800061fc:	64a2                	ld	s1,8(sp)
    800061fe:	6105                	add	sp,sp,32
    80006200:	8082                	ret
    panic("acquire");
    80006202:	00002517          	auipc	a0,0x2
    80006206:	79e50513          	add	a0,a0,1950 # 800089a0 <digits+0x20>
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	a7c080e7          	jalr	-1412(ra) # 80005c86 <panic>

0000000080006212 <pop_off>:

void
pop_off(void)
{
    80006212:	1141                	add	sp,sp,-16
    80006214:	e406                	sd	ra,8(sp)
    80006216:	e022                	sd	s0,0(sp)
    80006218:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    8000621a:	ffffb097          	auipc	ra,0xffffb
    8000621e:	c66080e7          	jalr	-922(ra) # 80000e80 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006222:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006226:	8b89                	and	a5,a5,2
  if(intr_get())
    80006228:	e78d                	bnez	a5,80006252 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000622a:	5d3c                	lw	a5,120(a0)
    8000622c:	02f05b63          	blez	a5,80006262 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006230:	37fd                	addw	a5,a5,-1
    80006232:	0007871b          	sext.w	a4,a5
    80006236:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006238:	eb09                	bnez	a4,8000624a <pop_off+0x38>
    8000623a:	5d7c                	lw	a5,124(a0)
    8000623c:	c799                	beqz	a5,8000624a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000623e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006242:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006246:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000624a:	60a2                	ld	ra,8(sp)
    8000624c:	6402                	ld	s0,0(sp)
    8000624e:	0141                	add	sp,sp,16
    80006250:	8082                	ret
    panic("pop_off - interruptible");
    80006252:	00002517          	auipc	a0,0x2
    80006256:	75650513          	add	a0,a0,1878 # 800089a8 <digits+0x28>
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	a2c080e7          	jalr	-1492(ra) # 80005c86 <panic>
    panic("pop_off");
    80006262:	00002517          	auipc	a0,0x2
    80006266:	75e50513          	add	a0,a0,1886 # 800089c0 <digits+0x40>
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	a1c080e7          	jalr	-1508(ra) # 80005c86 <panic>

0000000080006272 <release>:
{
    80006272:	1101                	add	sp,sp,-32
    80006274:	ec06                	sd	ra,24(sp)
    80006276:	e822                	sd	s0,16(sp)
    80006278:	e426                	sd	s1,8(sp)
    8000627a:	1000                	add	s0,sp,32
    8000627c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	ec6080e7          	jalr	-314(ra) # 80006144 <holding>
    80006286:	c115                	beqz	a0,800062aa <release+0x38>
  lk->cpu = 0;
    80006288:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000628c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006290:	0f50000f          	fence	iorw,ow
    80006294:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	f7a080e7          	jalr	-134(ra) # 80006212 <pop_off>
}
    800062a0:	60e2                	ld	ra,24(sp)
    800062a2:	6442                	ld	s0,16(sp)
    800062a4:	64a2                	ld	s1,8(sp)
    800062a6:	6105                	add	sp,sp,32
    800062a8:	8082                	ret
    panic("release");
    800062aa:	00002517          	auipc	a0,0x2
    800062ae:	71e50513          	add	a0,a0,1822 # 800089c8 <digits+0x48>
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	9d4080e7          	jalr	-1580(ra) # 80005c86 <panic>
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

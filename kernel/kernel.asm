
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	59013103          	ld	sp,1424(sp) # 8000a590 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6b7040ef          	jal	80004ecc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e3a9                	bnez	a5,8000006e <kfree+0x52>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00024797          	auipc	a5,0x24
    80000034:	ae078793          	addi	a5,a5,-1312 # 80023b10 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	59c90913          	addi	s2,s2,1436 # 8000a5e0 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	0e7050ef          	jal	80005934 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	16b050ef          	jal	800059c8 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("kfree");
    8000006e:	00007517          	auipc	a0,0x7
    80000072:	f9250513          	addi	a0,a0,-110 # 80007000 <etext>
    80000076:	590050ef          	jal	80005606 <panic>

000000008000007a <freerange>:
{
    8000007a:	7179                	addi	sp,sp,-48
    8000007c:	f406                	sd	ra,40(sp)
    8000007e:	f022                	sd	s0,32(sp)
    80000080:	ec26                	sd	s1,24(sp)
    80000082:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000084:	6785                	lui	a5,0x1
    80000086:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000008a:	00e504b3          	add	s1,a0,a4
    8000008e:	777d                	lui	a4,0xfffff
    80000090:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000092:	94be                	add	s1,s1,a5
    80000094:	0295e263          	bltu	a1,s1,800000b8 <freerange+0x3e>
    80000098:	e84a                	sd	s2,16(sp)
    8000009a:	e44e                	sd	s3,8(sp)
    8000009c:	e052                	sd	s4,0(sp)
    8000009e:	892e                	mv	s2,a1
    kfree(p);
    800000a0:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a2:	89be                	mv	s3,a5
    kfree(p);
    800000a4:	01448533          	add	a0,s1,s4
    800000a8:	f75ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000ac:	94ce                	add	s1,s1,s3
    800000ae:	fe997be3          	bgeu	s2,s1,800000a4 <freerange+0x2a>
    800000b2:	6942                	ld	s2,16(sp)
    800000b4:	69a2                	ld	s3,8(sp)
    800000b6:	6a02                	ld	s4,0(sp)
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6145                	addi	sp,sp,48
    800000c0:	8082                	ret

00000000800000c2 <kinit>:
{
    800000c2:	1141                	addi	sp,sp,-16
    800000c4:	e406                	sd	ra,8(sp)
    800000c6:	e022                	sd	s0,0(sp)
    800000c8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000ca:	00007597          	auipc	a1,0x7
    800000ce:	f4658593          	addi	a1,a1,-186 # 80007010 <etext+0x10>
    800000d2:	0000a517          	auipc	a0,0xa
    800000d6:	50e50513          	addi	a0,a0,1294 # 8000a5e0 <kmem>
    800000da:	7d6050ef          	jal	800058b0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00024517          	auipc	a0,0x24
    800000e6:	a2e50513          	addi	a0,a0,-1490 # 80023b10 <end>
    800000ea:	f91ff0ef          	jal	8000007a <freerange>
}
    800000ee:	60a2                	ld	ra,8(sp)
    800000f0:	6402                	ld	s0,0(sp)
    800000f2:	0141                	addi	sp,sp,16
    800000f4:	8082                	ret

00000000800000f6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000100:	0000a497          	auipc	s1,0xa
    80000104:	4e048493          	addi	s1,s1,1248 # 8000a5e0 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	02b050ef          	jal	80005934 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	4ef73223          	sd	a5,1252(a4) # 8000a5f8 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	4c450513          	addi	a0,a0,1220 # 8000a5e0 <kmem>
    80000124:	0a5050ef          	jal	800059c8 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000128:	8526                	mv	a0,s1
    8000012a:	60e2                	ld	ra,24(sp)
    8000012c:	6442                	ld	s0,16(sp)
    8000012e:	64a2                	ld	s1,8(sp)
    80000130:	6105                	addi	sp,sp,32
    80000132:	8082                	ret

0000000080000134 <freemem>:

int 
freemem(void) 
{
    80000134:	1101                	addi	sp,sp,-32
    80000136:	ec06                	sd	ra,24(sp)
    80000138:	e822                	sd	s0,16(sp)
    8000013a:	e426                	sd	s1,8(sp)
    8000013c:	1000                	addi	s0,sp,32
  int n = 0;
  struct run *r;
  acquire(&kmem.lock);
    8000013e:	0000a497          	auipc	s1,0xa
    80000142:	4a248493          	addi	s1,s1,1186 # 8000a5e0 <kmem>
    80000146:	8526                	mv	a0,s1
    80000148:	7ec050ef          	jal	80005934 <acquire>
  
  for (r = kmem.freelist; r; r = r->next)
    8000014c:	6c9c                	ld	a5,24(s1)
    8000014e:	c395                	beqz	a5,80000172 <freemem+0x3e>
  int n = 0;
    80000150:	4481                	li	s1,0
    ++n;
    80000152:	2485                	addiw	s1,s1,1
  for (r = kmem.freelist; r; r = r->next)
    80000154:	639c                	ld	a5,0(a5)
    80000156:	fff5                	bnez	a5,80000152 <freemem+0x1e>

  release(&kmem.lock);
    80000158:	0000a517          	auipc	a0,0xa
    8000015c:	48850513          	addi	a0,a0,1160 # 8000a5e0 <kmem>
    80000160:	069050ef          	jal	800059c8 <release>

  return n * 4096;
}
    80000164:	00c4951b          	slliw	a0,s1,0xc
    80000168:	60e2                	ld	ra,24(sp)
    8000016a:	6442                	ld	s0,16(sp)
    8000016c:	64a2                	ld	s1,8(sp)
    8000016e:	6105                	addi	sp,sp,32
    80000170:	8082                	ret
  int n = 0;
    80000172:	4481                	li	s1,0
    80000174:	b7d5                	j	80000158 <freemem+0x24>

0000000080000176 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000176:	1141                	addi	sp,sp,-16
    80000178:	e406                	sd	ra,8(sp)
    8000017a:	e022                	sd	s0,0(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1e>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x14>
  }
  return dst;
}
    80000194:	60a2                	ld	ra,8(sp)
    80000196:	6402                	ld	s0,0(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e406                	sd	ra,8(sp)
    800001a0:	e022                	sd	s0,0(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca0d                	beqz	a2,800001d6 <memcmp+0x3a>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x16>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x32>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	60a2                	ld	ra,8(sp)
    800001d0:	6402                	ld	s0,0(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  return 0;
    800001d6:	4501                	li	a0,0
    800001d8:	bfdd                	j	800001ce <memcmp+0x32>

00000000800001da <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001da:	1141                	addi	sp,sp,-16
    800001dc:	e406                	sd	ra,8(sp)
    800001de:	e022                	sd	s0,0(sp)
    800001e0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001e2:	c205                	beqz	a2,80000202 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e4:	02a5e363          	bltu	a1,a0,8000020a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e8:	1602                	slli	a2,a2,0x20
    800001ea:	9201                	srli	a2,a2,0x20
    800001ec:	00c587b3          	add	a5,a1,a2
{
    800001f0:	872a                	mv	a4,a0
      *d++ = *s++;
    800001f2:	0585                	addi	a1,a1,1
    800001f4:	0705                	addi	a4,a4,1
    800001f6:	fff5c683          	lbu	a3,-1(a1)
    800001fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001fe:	feb79ae3          	bne	a5,a1,800001f2 <memmove+0x18>

  return dst;
}
    80000202:	60a2                	ld	ra,8(sp)
    80000204:	6402                	ld	s0,0(sp)
    80000206:	0141                	addi	sp,sp,16
    80000208:	8082                	ret
  if(s < d && s + n > d){
    8000020a:	02061693          	slli	a3,a2,0x20
    8000020e:	9281                	srli	a3,a3,0x20
    80000210:	00d58733          	add	a4,a1,a3
    80000214:	fce57ae3          	bgeu	a0,a4,800001e8 <memmove+0xe>
    d += n;
    80000218:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000021a:	fff6079b          	addiw	a5,a2,-1
    8000021e:	1782                	slli	a5,a5,0x20
    80000220:	9381                	srli	a5,a5,0x20
    80000222:	fff7c793          	not	a5,a5
    80000226:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000228:	177d                	addi	a4,a4,-1
    8000022a:	16fd                	addi	a3,a3,-1
    8000022c:	00074603          	lbu	a2,0(a4)
    80000230:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000234:	fee79ae3          	bne	a5,a4,80000228 <memmove+0x4e>
    80000238:	b7e9                	j	80000202 <memmove+0x28>

000000008000023a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000023a:	1141                	addi	sp,sp,-16
    8000023c:	e406                	sd	ra,8(sp)
    8000023e:	e022                	sd	s0,0(sp)
    80000240:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000242:	f99ff0ef          	jal	800001da <memmove>
}
    80000246:	60a2                	ld	ra,8(sp)
    80000248:	6402                	ld	s0,0(sp)
    8000024a:	0141                	addi	sp,sp,16
    8000024c:	8082                	ret

000000008000024e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024e:	1141                	addi	sp,sp,-16
    80000250:	e406                	sd	ra,8(sp)
    80000252:	e022                	sd	s0,0(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x24>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x28>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x28>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0xa>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a801                	j	80000280 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a031                	j	80000280 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000276:	00054503          	lbu	a0,0(a0)
    8000027a:	0005c783          	lbu	a5,0(a1)
    8000027e:	9d1d                	subw	a0,a0,a5
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret

0000000080000288 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000288:	1141                	addi	sp,sp,-16
    8000028a:	e406                	sd	ra,8(sp)
    8000028c:	e022                	sd	s0,0(sp)
    8000028e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000290:	87aa                	mv	a5,a0
    80000292:	86b2                	mv	a3,a2
    80000294:	367d                	addiw	a2,a2,-1
    80000296:	02d05563          	blez	a3,800002c0 <strncpy+0x38>
    8000029a:	0785                	addi	a5,a5,1
    8000029c:	0005c703          	lbu	a4,0(a1)
    800002a0:	fee78fa3          	sb	a4,-1(a5)
    800002a4:	0585                	addi	a1,a1,1
    800002a6:	f775                	bnez	a4,80000292 <strncpy+0xa>
    ;
  while(n-- > 0)
    800002a8:	873e                	mv	a4,a5
    800002aa:	00c05b63          	blez	a2,800002c0 <strncpy+0x38>
    800002ae:	9fb5                	addw	a5,a5,a3
    800002b0:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    800002b2:	0705                	addi	a4,a4,1
    800002b4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002b8:	40e786bb          	subw	a3,a5,a4
    800002bc:	fed04be3          	bgtz	a3,800002b2 <strncpy+0x2a>
  return os;
}
    800002c0:	60a2                	ld	ra,8(sp)
    800002c2:	6402                	ld	s0,0(sp)
    800002c4:	0141                	addi	sp,sp,16
    800002c6:	8082                	ret

00000000800002c8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c8:	1141                	addi	sp,sp,-16
    800002ca:	e406                	sd	ra,8(sp)
    800002cc:	e022                	sd	s0,0(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2e>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x2a>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x18>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	60a2                	ld	ra,8(sp)
    800002f8:	6402                	ld	s0,0(sp)
    800002fa:	0141                	addi	sp,sp,16
    800002fc:	8082                	ret

00000000800002fe <strlen>:

int
strlen(const char *s)
{
    800002fe:	1141                	addi	sp,sp,-16
    80000300:	e406                	sd	ra,8(sp)
    80000302:	e022                	sd	s0,0(sp)
    80000304:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000306:	00054783          	lbu	a5,0(a0)
    8000030a:	cf99                	beqz	a5,80000328 <strlen+0x2a>
    8000030c:	0505                	addi	a0,a0,1
    8000030e:	87aa                	mv	a5,a0
    80000310:	86be                	mv	a3,a5
    80000312:	0785                	addi	a5,a5,1
    80000314:	fff7c703          	lbu	a4,-1(a5)
    80000318:	ff65                	bnez	a4,80000310 <strlen+0x12>
    8000031a:	40a6853b          	subw	a0,a3,a0
    8000031e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000320:	60a2                	ld	ra,8(sp)
    80000322:	6402                	ld	s0,0(sp)
    80000324:	0141                	addi	sp,sp,16
    80000326:	8082                	ret
  for(n = 0; s[n]; n++)
    80000328:	4501                	li	a0,0
    8000032a:	bfdd                	j	80000320 <strlen+0x22>

000000008000032c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000032c:	1141                	addi	sp,sp,-16
    8000032e:	e406                	sd	ra,8(sp)
    80000330:	e022                	sd	s0,0(sp)
    80000332:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000334:	225000ef          	jal	80000d58 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000338:	0000a717          	auipc	a4,0xa
    8000033c:	27870713          	addi	a4,a4,632 # 8000a5b0 <started>
  if(cpuid() == 0){
    80000340:	c51d                	beqz	a0,8000036e <main+0x42>
    while(started == 0)
    80000342:	431c                	lw	a5,0(a4)
    80000344:	2781                	sext.w	a5,a5
    80000346:	dff5                	beqz	a5,80000342 <main+0x16>
      ;
    __sync_synchronize();
    80000348:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000034c:	20d000ef          	jal	80000d58 <cpuid>
    80000350:	85aa                	mv	a1,a0
    80000352:	00007517          	auipc	a0,0x7
    80000356:	ce650513          	addi	a0,a0,-794 # 80007038 <etext+0x38>
    8000035a:	7dd040ef          	jal	80005336 <printf>
    kvminithart();    // turn on paging
    8000035e:	080000ef          	jal	800003de <kvminithart>
    trapinithart();   // install kernel trap vector
    80000362:	5b2010ef          	jal	80001914 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	5b2040ef          	jal	80004918 <plicinithart>
  }

  scheduler();        
    8000036a:	663000ef          	jal	800011cc <scheduler>
    consoleinit();
    8000036e:	6fb040ef          	jal	80005268 <consoleinit>
    printfinit();
    80000372:	2ce050ef          	jal	80005640 <printfinit>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	7b9040ef          	jal	80005336 <printf>
    printf("xv6 kernel is booting\n");
    80000382:	00007517          	auipc	a0,0x7
    80000386:	c9e50513          	addi	a0,a0,-866 # 80007020 <etext+0x20>
    8000038a:	7ad040ef          	jal	80005336 <printf>
    printf("\n");
    8000038e:	00007517          	auipc	a0,0x7
    80000392:	c8a50513          	addi	a0,a0,-886 # 80007018 <etext+0x18>
    80000396:	7a1040ef          	jal	80005336 <printf>
    kinit();         // physical page allocator
    8000039a:	d29ff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    8000039e:	2ce000ef          	jal	8000066c <kvminit>
    kvminithart();   // turn on paging
    800003a2:	03c000ef          	jal	800003de <kvminithart>
    procinit();      // process table
    800003a6:	103000ef          	jal	80000ca8 <procinit>
    trapinit();      // trap vectors
    800003aa:	546010ef          	jal	800018f0 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ae:	566010ef          	jal	80001914 <trapinithart>
    plicinit();      // set up interrupt controller
    800003b2:	54c040ef          	jal	800048fe <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003b6:	562040ef          	jal	80004918 <plicinithart>
    binit();         // buffer cache
    800003ba:	479010ef          	jal	80002032 <binit>
    iinit();         // inode table
    800003be:	244020ef          	jal	80002602 <iinit>
    fileinit();      // file table
    800003c2:	012030ef          	jal	800033d4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003c6:	642040ef          	jal	80004a08 <virtio_disk_init>
    userinit();      // first user process
    800003ca:	42f000ef          	jal	80000ff8 <userinit>
    __sync_synchronize();
    800003ce:	0330000f          	fence	rw,rw
    started = 1;
    800003d2:	4785                	li	a5,1
    800003d4:	0000a717          	auipc	a4,0xa
    800003d8:	1cf72e23          	sw	a5,476(a4) # 8000a5b0 <started>
    800003dc:	b779                	j	8000036a <main+0x3e>

00000000800003de <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003de:	1141                	addi	sp,sp,-16
    800003e0:	e406                	sd	ra,8(sp)
    800003e2:	e022                	sd	s0,0(sp)
    800003e4:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003e6:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003ea:	0000a797          	auipc	a5,0xa
    800003ee:	1ce7b783          	ld	a5,462(a5) # 8000a5b8 <kernel_pagetable>
    800003f2:	83b1                	srli	a5,a5,0xc
    800003f4:	577d                	li	a4,-1
    800003f6:	177e                	slli	a4,a4,0x3f
    800003f8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003fa:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003fe:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000402:	60a2                	ld	ra,8(sp)
    80000404:	6402                	ld	s0,0(sp)
    80000406:	0141                	addi	sp,sp,16
    80000408:	8082                	ret

000000008000040a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000040a:	7139                	addi	sp,sp,-64
    8000040c:	fc06                	sd	ra,56(sp)
    8000040e:	f822                	sd	s0,48(sp)
    80000410:	f426                	sd	s1,40(sp)
    80000412:	f04a                	sd	s2,32(sp)
    80000414:	ec4e                	sd	s3,24(sp)
    80000416:	e852                	sd	s4,16(sp)
    80000418:	e456                	sd	s5,8(sp)
    8000041a:	e05a                	sd	s6,0(sp)
    8000041c:	0080                	addi	s0,sp,64
    8000041e:	84aa                	mv	s1,a0
    80000420:	89ae                	mv	s3,a1
    80000422:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000424:	57fd                	li	a5,-1
    80000426:	83e9                	srli	a5,a5,0x1a
    80000428:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000042a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000042c:	04b7e263          	bltu	a5,a1,80000470 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000430:	0149d933          	srl	s2,s3,s4
    80000434:	1ff97913          	andi	s2,s2,511
    80000438:	090e                	slli	s2,s2,0x3
    8000043a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000043c:	00093483          	ld	s1,0(s2)
    80000440:	0014f793          	andi	a5,s1,1
    80000444:	cf85                	beqz	a5,8000047c <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000446:	80a9                	srli	s1,s1,0xa
    80000448:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    8000044a:	3a5d                	addiw	s4,s4,-9
    8000044c:	ff6a12e3          	bne	s4,s6,80000430 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000450:	00c9d513          	srli	a0,s3,0xc
    80000454:	1ff57513          	andi	a0,a0,511
    80000458:	050e                	slli	a0,a0,0x3
    8000045a:	9526                	add	a0,a0,s1
}
    8000045c:	70e2                	ld	ra,56(sp)
    8000045e:	7442                	ld	s0,48(sp)
    80000460:	74a2                	ld	s1,40(sp)
    80000462:	7902                	ld	s2,32(sp)
    80000464:	69e2                	ld	s3,24(sp)
    80000466:	6a42                	ld	s4,16(sp)
    80000468:	6aa2                	ld	s5,8(sp)
    8000046a:	6b02                	ld	s6,0(sp)
    8000046c:	6121                	addi	sp,sp,64
    8000046e:	8082                	ret
    panic("walk");
    80000470:	00007517          	auipc	a0,0x7
    80000474:	be050513          	addi	a0,a0,-1056 # 80007050 <etext+0x50>
    80000478:	18e050ef          	jal	80005606 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000047c:	020a8263          	beqz	s5,800004a0 <walk+0x96>
    80000480:	c77ff0ef          	jal	800000f6 <kalloc>
    80000484:	84aa                	mv	s1,a0
    80000486:	d979                	beqz	a0,8000045c <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000488:	6605                	lui	a2,0x1
    8000048a:	4581                	li	a1,0
    8000048c:	cebff0ef          	jal	80000176 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000490:	00c4d793          	srli	a5,s1,0xc
    80000494:	07aa                	slli	a5,a5,0xa
    80000496:	0017e793          	ori	a5,a5,1
    8000049a:	00f93023          	sd	a5,0(s2)
    8000049e:	b775                	j	8000044a <walk+0x40>
        return 0;
    800004a0:	4501                	li	a0,0
    800004a2:	bf6d                	j	8000045c <walk+0x52>

00000000800004a4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004a4:	57fd                	li	a5,-1
    800004a6:	83e9                	srli	a5,a5,0x1a
    800004a8:	00b7f463          	bgeu	a5,a1,800004b0 <walkaddr+0xc>
    return 0;
    800004ac:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800004ae:	8082                	ret
{
    800004b0:	1141                	addi	sp,sp,-16
    800004b2:	e406                	sd	ra,8(sp)
    800004b4:	e022                	sd	s0,0(sp)
    800004b6:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004b8:	4601                	li	a2,0
    800004ba:	f51ff0ef          	jal	8000040a <walk>
  if(pte == 0)
    800004be:	c105                	beqz	a0,800004de <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800004c0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004c2:	0117f693          	andi	a3,a5,17
    800004c6:	4745                	li	a4,17
    return 0;
    800004c8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004ca:	00e68663          	beq	a3,a4,800004d6 <walkaddr+0x32>
}
    800004ce:	60a2                	ld	ra,8(sp)
    800004d0:	6402                	ld	s0,0(sp)
    800004d2:	0141                	addi	sp,sp,16
    800004d4:	8082                	ret
  pa = PTE2PA(*pte);
    800004d6:	83a9                	srli	a5,a5,0xa
    800004d8:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004dc:	bfcd                	j	800004ce <walkaddr+0x2a>
    return 0;
    800004de:	4501                	li	a0,0
    800004e0:	b7fd                	j	800004ce <walkaddr+0x2a>

00000000800004e2 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004e2:	715d                	addi	sp,sp,-80
    800004e4:	e486                	sd	ra,72(sp)
    800004e6:	e0a2                	sd	s0,64(sp)
    800004e8:	fc26                	sd	s1,56(sp)
    800004ea:	f84a                	sd	s2,48(sp)
    800004ec:	f44e                	sd	s3,40(sp)
    800004ee:	f052                	sd	s4,32(sp)
    800004f0:	ec56                	sd	s5,24(sp)
    800004f2:	e85a                	sd	s6,16(sp)
    800004f4:	e45e                	sd	s7,8(sp)
    800004f6:	e062                	sd	s8,0(sp)
    800004f8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004fa:	03459793          	slli	a5,a1,0x34
    800004fe:	e7b1                	bnez	a5,8000054a <mappages+0x68>
    80000500:	8aaa                	mv	s5,a0
    80000502:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000504:	03461793          	slli	a5,a2,0x34
    80000508:	e7b9                	bnez	a5,80000556 <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    8000050a:	ce21                	beqz	a2,80000562 <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000050c:	77fd                	lui	a5,0xfffff
    8000050e:	963e                	add	a2,a2,a5
    80000510:	00b609b3          	add	s3,a2,a1
  a = va;
    80000514:	892e                	mv	s2,a1
    80000516:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    8000051a:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000051c:	6c05                	lui	s8,0x1
    8000051e:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000522:	865e                	mv	a2,s7
    80000524:	85ca                	mv	a1,s2
    80000526:	8556                	mv	a0,s5
    80000528:	ee3ff0ef          	jal	8000040a <walk>
    8000052c:	c539                	beqz	a0,8000057a <mappages+0x98>
    if(*pte & PTE_V)
    8000052e:	611c                	ld	a5,0(a0)
    80000530:	8b85                	andi	a5,a5,1
    80000532:	ef95                	bnez	a5,8000056e <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000534:	80b1                	srli	s1,s1,0xc
    80000536:	04aa                	slli	s1,s1,0xa
    80000538:	0164e4b3          	or	s1,s1,s6
    8000053c:	0014e493          	ori	s1,s1,1
    80000540:	e104                	sd	s1,0(a0)
    if(a == last)
    80000542:	05390963          	beq	s2,s3,80000594 <mappages+0xb2>
    a += PGSIZE;
    80000546:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80000548:	bfd9                	j	8000051e <mappages+0x3c>
    panic("mappages: va not aligned");
    8000054a:	00007517          	auipc	a0,0x7
    8000054e:	b0e50513          	addi	a0,a0,-1266 # 80007058 <etext+0x58>
    80000552:	0b4050ef          	jal	80005606 <panic>
    panic("mappages: size not aligned");
    80000556:	00007517          	auipc	a0,0x7
    8000055a:	b2250513          	addi	a0,a0,-1246 # 80007078 <etext+0x78>
    8000055e:	0a8050ef          	jal	80005606 <panic>
    panic("mappages: size");
    80000562:	00007517          	auipc	a0,0x7
    80000566:	b3650513          	addi	a0,a0,-1226 # 80007098 <etext+0x98>
    8000056a:	09c050ef          	jal	80005606 <panic>
      panic("mappages: remap");
    8000056e:	00007517          	auipc	a0,0x7
    80000572:	b3a50513          	addi	a0,a0,-1222 # 800070a8 <etext+0xa8>
    80000576:	090050ef          	jal	80005606 <panic>
      return -1;
    8000057a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000057c:	60a6                	ld	ra,72(sp)
    8000057e:	6406                	ld	s0,64(sp)
    80000580:	74e2                	ld	s1,56(sp)
    80000582:	7942                	ld	s2,48(sp)
    80000584:	79a2                	ld	s3,40(sp)
    80000586:	7a02                	ld	s4,32(sp)
    80000588:	6ae2                	ld	s5,24(sp)
    8000058a:	6b42                	ld	s6,16(sp)
    8000058c:	6ba2                	ld	s7,8(sp)
    8000058e:	6c02                	ld	s8,0(sp)
    80000590:	6161                	addi	sp,sp,80
    80000592:	8082                	ret
  return 0;
    80000594:	4501                	li	a0,0
    80000596:	b7dd                	j	8000057c <mappages+0x9a>

0000000080000598 <kvmmap>:
{
    80000598:	1141                	addi	sp,sp,-16
    8000059a:	e406                	sd	ra,8(sp)
    8000059c:	e022                	sd	s0,0(sp)
    8000059e:	0800                	addi	s0,sp,16
    800005a0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005a2:	86b2                	mv	a3,a2
    800005a4:	863e                	mv	a2,a5
    800005a6:	f3dff0ef          	jal	800004e2 <mappages>
    800005aa:	e509                	bnez	a0,800005b4 <kvmmap+0x1c>
}
    800005ac:	60a2                	ld	ra,8(sp)
    800005ae:	6402                	ld	s0,0(sp)
    800005b0:	0141                	addi	sp,sp,16
    800005b2:	8082                	ret
    panic("kvmmap");
    800005b4:	00007517          	auipc	a0,0x7
    800005b8:	b0450513          	addi	a0,a0,-1276 # 800070b8 <etext+0xb8>
    800005bc:	04a050ef          	jal	80005606 <panic>

00000000800005c0 <kvmmake>:
{
    800005c0:	1101                	addi	sp,sp,-32
    800005c2:	ec06                	sd	ra,24(sp)
    800005c4:	e822                	sd	s0,16(sp)
    800005c6:	e426                	sd	s1,8(sp)
    800005c8:	e04a                	sd	s2,0(sp)
    800005ca:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005cc:	b2bff0ef          	jal	800000f6 <kalloc>
    800005d0:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005d2:	6605                	lui	a2,0x1
    800005d4:	4581                	li	a1,0
    800005d6:	ba1ff0ef          	jal	80000176 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005da:	4719                	li	a4,6
    800005dc:	6685                	lui	a3,0x1
    800005de:	10000637          	lui	a2,0x10000
    800005e2:	85b2                	mv	a1,a2
    800005e4:	8526                	mv	a0,s1
    800005e6:	fb3ff0ef          	jal	80000598 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005ea:	4719                	li	a4,6
    800005ec:	6685                	lui	a3,0x1
    800005ee:	10001637          	lui	a2,0x10001
    800005f2:	85b2                	mv	a1,a2
    800005f4:	8526                	mv	a0,s1
    800005f6:	fa3ff0ef          	jal	80000598 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005fa:	4719                	li	a4,6
    800005fc:	040006b7          	lui	a3,0x4000
    80000600:	0c000637          	lui	a2,0xc000
    80000604:	85b2                	mv	a1,a2
    80000606:	8526                	mv	a0,s1
    80000608:	f91ff0ef          	jal	80000598 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000060c:	00007917          	auipc	s2,0x7
    80000610:	9f490913          	addi	s2,s2,-1548 # 80007000 <etext>
    80000614:	4729                	li	a4,10
    80000616:	80007697          	auipc	a3,0x80007
    8000061a:	9ea68693          	addi	a3,a3,-1558 # 7000 <_entry-0x7fff9000>
    8000061e:	4605                	li	a2,1
    80000620:	067e                	slli	a2,a2,0x1f
    80000622:	85b2                	mv	a1,a2
    80000624:	8526                	mv	a0,s1
    80000626:	f73ff0ef          	jal	80000598 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000062a:	4719                	li	a4,6
    8000062c:	46c5                	li	a3,17
    8000062e:	06ee                	slli	a3,a3,0x1b
    80000630:	412686b3          	sub	a3,a3,s2
    80000634:	864a                	mv	a2,s2
    80000636:	85ca                	mv	a1,s2
    80000638:	8526                	mv	a0,s1
    8000063a:	f5fff0ef          	jal	80000598 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000063e:	4729                	li	a4,10
    80000640:	6685                	lui	a3,0x1
    80000642:	00006617          	auipc	a2,0x6
    80000646:	9be60613          	addi	a2,a2,-1602 # 80006000 <_trampoline>
    8000064a:	040005b7          	lui	a1,0x4000
    8000064e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000650:	05b2                	slli	a1,a1,0xc
    80000652:	8526                	mv	a0,s1
    80000654:	f45ff0ef          	jal	80000598 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000658:	8526                	mv	a0,s1
    8000065a:	5b0000ef          	jal	80000c0a <proc_mapstacks>
}
    8000065e:	8526                	mv	a0,s1
    80000660:	60e2                	ld	ra,24(sp)
    80000662:	6442                	ld	s0,16(sp)
    80000664:	64a2                	ld	s1,8(sp)
    80000666:	6902                	ld	s2,0(sp)
    80000668:	6105                	addi	sp,sp,32
    8000066a:	8082                	ret

000000008000066c <kvminit>:
{
    8000066c:	1141                	addi	sp,sp,-16
    8000066e:	e406                	sd	ra,8(sp)
    80000670:	e022                	sd	s0,0(sp)
    80000672:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000674:	f4dff0ef          	jal	800005c0 <kvmmake>
    80000678:	0000a797          	auipc	a5,0xa
    8000067c:	f4a7b023          	sd	a0,-192(a5) # 8000a5b8 <kernel_pagetable>
}
    80000680:	60a2                	ld	ra,8(sp)
    80000682:	6402                	ld	s0,0(sp)
    80000684:	0141                	addi	sp,sp,16
    80000686:	8082                	ret

0000000080000688 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000688:	715d                	addi	sp,sp,-80
    8000068a:	e486                	sd	ra,72(sp)
    8000068c:	e0a2                	sd	s0,64(sp)
    8000068e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    80000690:	03459793          	slli	a5,a1,0x34
    80000694:	e39d                	bnez	a5,800006ba <uvmunmap+0x32>
    80000696:	f84a                	sd	s2,48(sp)
    80000698:	f44e                	sd	s3,40(sp)
    8000069a:	f052                	sd	s4,32(sp)
    8000069c:	ec56                	sd	s5,24(sp)
    8000069e:	e85a                	sd	s6,16(sp)
    800006a0:	e45e                	sd	s7,8(sp)
    800006a2:	8a2a                	mv	s4,a0
    800006a4:	892e                	mv	s2,a1
    800006a6:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006a8:	0632                	slli	a2,a2,0xc
    800006aa:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    800006ae:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006b0:	6b05                	lui	s6,0x1
    800006b2:	0935f763          	bgeu	a1,s3,80000740 <uvmunmap+0xb8>
    800006b6:	fc26                	sd	s1,56(sp)
    800006b8:	a8a1                	j	80000710 <uvmunmap+0x88>
    800006ba:	fc26                	sd	s1,56(sp)
    800006bc:	f84a                	sd	s2,48(sp)
    800006be:	f44e                	sd	s3,40(sp)
    800006c0:	f052                	sd	s4,32(sp)
    800006c2:	ec56                	sd	s5,24(sp)
    800006c4:	e85a                	sd	s6,16(sp)
    800006c6:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006c8:	00007517          	auipc	a0,0x7
    800006cc:	9f850513          	addi	a0,a0,-1544 # 800070c0 <etext+0xc0>
    800006d0:	737040ef          	jal	80005606 <panic>
      panic("uvmunmap: walk");
    800006d4:	00007517          	auipc	a0,0x7
    800006d8:	a0450513          	addi	a0,a0,-1532 # 800070d8 <etext+0xd8>
    800006dc:	72b040ef          	jal	80005606 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    800006e0:	85ca                	mv	a1,s2
    800006e2:	00007517          	auipc	a0,0x7
    800006e6:	a0650513          	addi	a0,a0,-1530 # 800070e8 <etext+0xe8>
    800006ea:	44d040ef          	jal	80005336 <printf>
      panic("uvmunmap: not mapped");
    800006ee:	00007517          	auipc	a0,0x7
    800006f2:	a0a50513          	addi	a0,a0,-1526 # 800070f8 <etext+0xf8>
    800006f6:	711040ef          	jal	80005606 <panic>
      panic("uvmunmap: not a leaf");
    800006fa:	00007517          	auipc	a0,0x7
    800006fe:	a1650513          	addi	a0,a0,-1514 # 80007110 <etext+0x110>
    80000702:	705040ef          	jal	80005606 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000706:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000070a:	995a                	add	s2,s2,s6
    8000070c:	03397963          	bgeu	s2,s3,8000073e <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000710:	4601                	li	a2,0
    80000712:	85ca                	mv	a1,s2
    80000714:	8552                	mv	a0,s4
    80000716:	cf5ff0ef          	jal	8000040a <walk>
    8000071a:	84aa                	mv	s1,a0
    8000071c:	dd45                	beqz	a0,800006d4 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    8000071e:	6110                	ld	a2,0(a0)
    80000720:	00167793          	andi	a5,a2,1
    80000724:	dfd5                	beqz	a5,800006e0 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000726:	3ff67793          	andi	a5,a2,1023
    8000072a:	fd7788e3          	beq	a5,s7,800006fa <uvmunmap+0x72>
    if(do_free){
    8000072e:	fc0a8ce3          	beqz	s5,80000706 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    80000732:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80000734:	00c61513          	slli	a0,a2,0xc
    80000738:	8e5ff0ef          	jal	8000001c <kfree>
    8000073c:	b7e9                	j	80000706 <uvmunmap+0x7e>
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
  }
}
    8000074c:	60a6                	ld	ra,72(sp)
    8000074e:	6406                	ld	s0,64(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret

0000000080000754 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000754:	1101                	addi	sp,sp,-32
    80000756:	ec06                	sd	ra,24(sp)
    80000758:	e822                	sd	s0,16(sp)
    8000075a:	e426                	sd	s1,8(sp)
    8000075c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000075e:	999ff0ef          	jal	800000f6 <kalloc>
    80000762:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000764:	c509                	beqz	a0,8000076e <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000766:	6605                	lui	a2,0x1
    80000768:	4581                	li	a1,0
    8000076a:	a0dff0ef          	jal	80000176 <memset>
  return pagetable;
}
    8000076e:	8526                	mv	a0,s1
    80000770:	60e2                	ld	ra,24(sp)
    80000772:	6442                	ld	s0,16(sp)
    80000774:	64a2                	ld	s1,8(sp)
    80000776:	6105                	addi	sp,sp,32
    80000778:	8082                	ret

000000008000077a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000077a:	7179                	addi	sp,sp,-48
    8000077c:	f406                	sd	ra,40(sp)
    8000077e:	f022                	sd	s0,32(sp)
    80000780:	ec26                	sd	s1,24(sp)
    80000782:	e84a                	sd	s2,16(sp)
    80000784:	e44e                	sd	s3,8(sp)
    80000786:	e052                	sd	s4,0(sp)
    80000788:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000078a:	6785                	lui	a5,0x1
    8000078c:	04f67063          	bgeu	a2,a5,800007cc <uvmfirst+0x52>
    80000790:	8a2a                	mv	s4,a0
    80000792:	89ae                	mv	s3,a1
    80000794:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000796:	961ff0ef          	jal	800000f6 <kalloc>
    8000079a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000079c:	6605                	lui	a2,0x1
    8000079e:	4581                	li	a1,0
    800007a0:	9d7ff0ef          	jal	80000176 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800007a4:	4779                	li	a4,30
    800007a6:	86ca                	mv	a3,s2
    800007a8:	6605                	lui	a2,0x1
    800007aa:	4581                	li	a1,0
    800007ac:	8552                	mv	a0,s4
    800007ae:	d35ff0ef          	jal	800004e2 <mappages>
  memmove(mem, src, sz);
    800007b2:	8626                	mv	a2,s1
    800007b4:	85ce                	mv	a1,s3
    800007b6:	854a                	mv	a0,s2
    800007b8:	a23ff0ef          	jal	800001da <memmove>
}
    800007bc:	70a2                	ld	ra,40(sp)
    800007be:	7402                	ld	s0,32(sp)
    800007c0:	64e2                	ld	s1,24(sp)
    800007c2:	6942                	ld	s2,16(sp)
    800007c4:	69a2                	ld	s3,8(sp)
    800007c6:	6a02                	ld	s4,0(sp)
    800007c8:	6145                	addi	sp,sp,48
    800007ca:	8082                	ret
    panic("uvmfirst: more than a page");
    800007cc:	00007517          	auipc	a0,0x7
    800007d0:	95c50513          	addi	a0,a0,-1700 # 80007128 <etext+0x128>
    800007d4:	633040ef          	jal	80005606 <panic>

00000000800007d8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007d8:	1101                	addi	sp,sp,-32
    800007da:	ec06                	sd	ra,24(sp)
    800007dc:	e822                	sd	s0,16(sp)
    800007de:	e426                	sd	s1,8(sp)
    800007e0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007e2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007e4:	00b67d63          	bgeu	a2,a1,800007fe <uvmdealloc+0x26>
    800007e8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007ea:	6785                	lui	a5,0x1
    800007ec:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007ee:	00f60733          	add	a4,a2,a5
    800007f2:	76fd                	lui	a3,0xfffff
    800007f4:	8f75                	and	a4,a4,a3
    800007f6:	97ae                	add	a5,a5,a1
    800007f8:	8ff5                	and	a5,a5,a3
    800007fa:	00f76863          	bltu	a4,a5,8000080a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007fe:	8526                	mv	a0,s1
    80000800:	60e2                	ld	ra,24(sp)
    80000802:	6442                	ld	s0,16(sp)
    80000804:	64a2                	ld	s1,8(sp)
    80000806:	6105                	addi	sp,sp,32
    80000808:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000080a:	8f99                	sub	a5,a5,a4
    8000080c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000080e:	4685                	li	a3,1
    80000810:	0007861b          	sext.w	a2,a5
    80000814:	85ba                	mv	a1,a4
    80000816:	e73ff0ef          	jal	80000688 <uvmunmap>
    8000081a:	b7d5                	j	800007fe <uvmdealloc+0x26>

000000008000081c <uvmalloc>:
  if(newsz < oldsz)
    8000081c:	08b66f63          	bltu	a2,a1,800008ba <uvmalloc+0x9e>
{
    80000820:	715d                	addi	sp,sp,-80
    80000822:	e486                	sd	ra,72(sp)
    80000824:	e0a2                	sd	s0,64(sp)
    80000826:	f052                	sd	s4,32(sp)
    80000828:	ec56                	sd	s5,24(sp)
    8000082a:	e85a                	sd	s6,16(sp)
    8000082c:	0880                	addi	s0,sp,80
    8000082e:	8b2a                	mv	s6,a0
    80000830:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    80000832:	6785                	lui	a5,0x1
    80000834:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000836:	95be                	add	a1,a1,a5
    80000838:	77fd                	lui	a5,0xfffff
    8000083a:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    8000083e:	08ca7063          	bgeu	s4,a2,800008be <uvmalloc+0xa2>
    80000842:	fc26                	sd	s1,56(sp)
    80000844:	f84a                	sd	s2,48(sp)
    80000846:	f44e                	sd	s3,40(sp)
    80000848:	e45e                	sd	s7,8(sp)
    8000084a:	8952                	mv	s2,s4
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000084c:	0126eb93          	ori	s7,a3,18
    80000850:	6985                	lui	s3,0x1
    mem = kalloc();
    80000852:	8a5ff0ef          	jal	800000f6 <kalloc>
    80000856:	84aa                	mv	s1,a0
    if(mem == 0){
    80000858:	c115                	beqz	a0,8000087c <uvmalloc+0x60>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000085a:	875e                	mv	a4,s7
    8000085c:	86aa                	mv	a3,a0
    8000085e:	864e                	mv	a2,s3
    80000860:	85ca                	mv	a1,s2
    80000862:	855a                	mv	a0,s6
    80000864:	c7fff0ef          	jal	800004e2 <mappages>
    80000868:	e91d                	bnez	a0,8000089e <uvmalloc+0x82>
  for(a = oldsz; a < newsz; a += sz){
    8000086a:	994e                	add	s2,s2,s3
    8000086c:	ff5963e3          	bltu	s2,s5,80000852 <uvmalloc+0x36>
  return newsz;
    80000870:	8556                	mv	a0,s5
    80000872:	74e2                	ld	s1,56(sp)
    80000874:	7942                	ld	s2,48(sp)
    80000876:	79a2                	ld	s3,40(sp)
    80000878:	6ba2                	ld	s7,8(sp)
    8000087a:	a819                	j	80000890 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000087c:	8652                	mv	a2,s4
    8000087e:	85ca                	mv	a1,s2
    80000880:	855a                	mv	a0,s6
    80000882:	f57ff0ef          	jal	800007d8 <uvmdealloc>
      return 0;
    80000886:	4501                	li	a0,0
    80000888:	74e2                	ld	s1,56(sp)
    8000088a:	7942                	ld	s2,48(sp)
    8000088c:	79a2                	ld	s3,40(sp)
    8000088e:	6ba2                	ld	s7,8(sp)
}
    80000890:	60a6                	ld	ra,72(sp)
    80000892:	6406                	ld	s0,64(sp)
    80000894:	7a02                	ld	s4,32(sp)
    80000896:	6ae2                	ld	s5,24(sp)
    80000898:	6b42                	ld	s6,16(sp)
    8000089a:	6161                	addi	sp,sp,80
    8000089c:	8082                	ret
      kfree(mem);
    8000089e:	8526                	mv	a0,s1
    800008a0:	f7cff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800008a4:	8652                	mv	a2,s4
    800008a6:	85ca                	mv	a1,s2
    800008a8:	855a                	mv	a0,s6
    800008aa:	f2fff0ef          	jal	800007d8 <uvmdealloc>
      return 0;
    800008ae:	4501                	li	a0,0
    800008b0:	74e2                	ld	s1,56(sp)
    800008b2:	7942                	ld	s2,48(sp)
    800008b4:	79a2                	ld	s3,40(sp)
    800008b6:	6ba2                	ld	s7,8(sp)
    800008b8:	bfe1                	j	80000890 <uvmalloc+0x74>
    return oldsz;
    800008ba:	852e                	mv	a0,a1
}
    800008bc:	8082                	ret
  return newsz;
    800008be:	8532                	mv	a0,a2
    800008c0:	bfc1                	j	80000890 <uvmalloc+0x74>

00000000800008c2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800008c2:	7179                	addi	sp,sp,-48
    800008c4:	f406                	sd	ra,40(sp)
    800008c6:	f022                	sd	s0,32(sp)
    800008c8:	ec26                	sd	s1,24(sp)
    800008ca:	e84a                	sd	s2,16(sp)
    800008cc:	e44e                	sd	s3,8(sp)
    800008ce:	e052                	sd	s4,0(sp)
    800008d0:	1800                	addi	s0,sp,48
    800008d2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008d4:	84aa                	mv	s1,a0
    800008d6:	6905                	lui	s2,0x1
    800008d8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008da:	4985                	li	s3,1
    800008dc:	a819                	j	800008f2 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008de:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008e0:	00c79513          	slli	a0,a5,0xc
    800008e4:	fdfff0ef          	jal	800008c2 <freewalk>
      pagetable[i] = 0;
    800008e8:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008ec:	04a1                	addi	s1,s1,8
    800008ee:	01248f63          	beq	s1,s2,8000090c <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008f2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008f4:	00f7f713          	andi	a4,a5,15
    800008f8:	ff3703e3          	beq	a4,s3,800008de <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008fc:	8b85                	andi	a5,a5,1
    800008fe:	d7fd                	beqz	a5,800008ec <freewalk+0x2a>
      panic("freewalk: leaf");
    80000900:	00007517          	auipc	a0,0x7
    80000904:	84850513          	addi	a0,a0,-1976 # 80007148 <etext+0x148>
    80000908:	4ff040ef          	jal	80005606 <panic>
    }
  }
  kfree((void*)pagetable);
    8000090c:	8552                	mv	a0,s4
    8000090e:	f0eff0ef          	jal	8000001c <kfree>
}
    80000912:	70a2                	ld	ra,40(sp)
    80000914:	7402                	ld	s0,32(sp)
    80000916:	64e2                	ld	s1,24(sp)
    80000918:	6942                	ld	s2,16(sp)
    8000091a:	69a2                	ld	s3,8(sp)
    8000091c:	6a02                	ld	s4,0(sp)
    8000091e:	6145                	addi	sp,sp,48
    80000920:	8082                	ret

0000000080000922 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000922:	1101                	addi	sp,sp,-32
    80000924:	ec06                	sd	ra,24(sp)
    80000926:	e822                	sd	s0,16(sp)
    80000928:	e426                	sd	s1,8(sp)
    8000092a:	1000                	addi	s0,sp,32
    8000092c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000092e:	e989                	bnez	a1,80000940 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000930:	8526                	mv	a0,s1
    80000932:	f91ff0ef          	jal	800008c2 <freewalk>
}
    80000936:	60e2                	ld	ra,24(sp)
    80000938:	6442                	ld	s0,16(sp)
    8000093a:	64a2                	ld	s1,8(sp)
    8000093c:	6105                	addi	sp,sp,32
    8000093e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000940:	6785                	lui	a5,0x1
    80000942:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000944:	95be                	add	a1,a1,a5
    80000946:	4685                	li	a3,1
    80000948:	00c5d613          	srli	a2,a1,0xc
    8000094c:	4581                	li	a1,0
    8000094e:	d3bff0ef          	jal	80000688 <uvmunmap>
    80000952:	bff9                	j	80000930 <uvmfree+0xe>

0000000080000954 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    80000954:	ca4d                	beqz	a2,80000a06 <uvmcopy+0xb2>
{
    80000956:	715d                	addi	sp,sp,-80
    80000958:	e486                	sd	ra,72(sp)
    8000095a:	e0a2                	sd	s0,64(sp)
    8000095c:	fc26                	sd	s1,56(sp)
    8000095e:	f84a                	sd	s2,48(sp)
    80000960:	f44e                	sd	s3,40(sp)
    80000962:	f052                	sd	s4,32(sp)
    80000964:	ec56                	sd	s5,24(sp)
    80000966:	e85a                	sd	s6,16(sp)
    80000968:	e45e                	sd	s7,8(sp)
    8000096a:	e062                	sd	s8,0(sp)
    8000096c:	0880                	addi	s0,sp,80
    8000096e:	8baa                	mv	s7,a0
    80000970:	8b2e                	mv	s6,a1
    80000972:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += szinc){
    80000974:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000976:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80000978:	4601                	li	a2,0
    8000097a:	85ce                	mv	a1,s3
    8000097c:	855e                	mv	a0,s7
    8000097e:	a8dff0ef          	jal	8000040a <walk>
    80000982:	cd1d                	beqz	a0,800009c0 <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    80000984:	6118                	ld	a4,0(a0)
    80000986:	00177793          	andi	a5,a4,1
    8000098a:	c3a9                	beqz	a5,800009cc <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    8000098c:	00a75593          	srli	a1,a4,0xa
    80000990:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000994:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000998:	f5eff0ef          	jal	800000f6 <kalloc>
    8000099c:	892a                	mv	s2,a0
    8000099e:	c121                	beqz	a0,800009de <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    800009a0:	8652                	mv	a2,s4
    800009a2:	85e2                	mv	a1,s8
    800009a4:	837ff0ef          	jal	800001da <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800009a8:	8726                	mv	a4,s1
    800009aa:	86ca                	mv	a3,s2
    800009ac:	8652                	mv	a2,s4
    800009ae:	85ce                	mv	a1,s3
    800009b0:	855a                	mv	a0,s6
    800009b2:	b31ff0ef          	jal	800004e2 <mappages>
    800009b6:	e10d                	bnez	a0,800009d8 <uvmcopy+0x84>
  for(i = 0; i < sz; i += szinc){
    800009b8:	99d2                	add	s3,s3,s4
    800009ba:	fb59efe3          	bltu	s3,s5,80000978 <uvmcopy+0x24>
    800009be:	a805                	j	800009ee <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    800009c0:	00006517          	auipc	a0,0x6
    800009c4:	79850513          	addi	a0,a0,1944 # 80007158 <etext+0x158>
    800009c8:	43f040ef          	jal	80005606 <panic>
      panic("uvmcopy: page not present");
    800009cc:	00006517          	auipc	a0,0x6
    800009d0:	7ac50513          	addi	a0,a0,1964 # 80007178 <etext+0x178>
    800009d4:	433040ef          	jal	80005606 <panic>
      kfree(mem);
    800009d8:	854a                	mv	a0,s2
    800009da:	e42ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009de:	4685                	li	a3,1
    800009e0:	00c9d613          	srli	a2,s3,0xc
    800009e4:	4581                	li	a1,0
    800009e6:	855a                	mv	a0,s6
    800009e8:	ca1ff0ef          	jal	80000688 <uvmunmap>
  return -1;
    800009ec:	557d                	li	a0,-1
}
    800009ee:	60a6                	ld	ra,72(sp)
    800009f0:	6406                	ld	s0,64(sp)
    800009f2:	74e2                	ld	s1,56(sp)
    800009f4:	7942                	ld	s2,48(sp)
    800009f6:	79a2                	ld	s3,40(sp)
    800009f8:	7a02                	ld	s4,32(sp)
    800009fa:	6ae2                	ld	s5,24(sp)
    800009fc:	6b42                	ld	s6,16(sp)
    800009fe:	6ba2                	ld	s7,8(sp)
    80000a00:	6c02                	ld	s8,0(sp)
    80000a02:	6161                	addi	sp,sp,80
    80000a04:	8082                	ret
  return 0;
    80000a06:	4501                	li	a0,0
}
    80000a08:	8082                	ret

0000000080000a0a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000a0a:	1141                	addi	sp,sp,-16
    80000a0c:	e406                	sd	ra,8(sp)
    80000a0e:	e022                	sd	s0,0(sp)
    80000a10:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000a12:	4601                	li	a2,0
    80000a14:	9f7ff0ef          	jal	8000040a <walk>
  if(pte == 0)
    80000a18:	c901                	beqz	a0,80000a28 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000a1a:	611c                	ld	a5,0(a0)
    80000a1c:	9bbd                	andi	a5,a5,-17
    80000a1e:	e11c                	sd	a5,0(a0)
}
    80000a20:	60a2                	ld	ra,8(sp)
    80000a22:	6402                	ld	s0,0(sp)
    80000a24:	0141                	addi	sp,sp,16
    80000a26:	8082                	ret
    panic("uvmclear");
    80000a28:	00006517          	auipc	a0,0x6
    80000a2c:	77050513          	addi	a0,a0,1904 # 80007198 <etext+0x198>
    80000a30:	3d7040ef          	jal	80005606 <panic>

0000000080000a34 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a34:	c2d1                	beqz	a3,80000ab8 <copyout+0x84>
{
    80000a36:	711d                	addi	sp,sp,-96
    80000a38:	ec86                	sd	ra,88(sp)
    80000a3a:	e8a2                	sd	s0,80(sp)
    80000a3c:	e4a6                	sd	s1,72(sp)
    80000a3e:	e0ca                	sd	s2,64(sp)
    80000a40:	fc4e                	sd	s3,56(sp)
    80000a42:	f852                	sd	s4,48(sp)
    80000a44:	f456                	sd	s5,40(sp)
    80000a46:	f05a                	sd	s6,32(sp)
    80000a48:	ec5e                	sd	s7,24(sp)
    80000a4a:	e862                	sd	s8,16(sp)
    80000a4c:	e466                	sd	s9,8(sp)
    80000a4e:	1080                	addi	s0,sp,96
    80000a50:	8b2a                	mv	s6,a0
    80000a52:	89ae                	mv	s3,a1
    80000a54:	8ab2                	mv	s5,a2
    80000a56:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000a58:	7cfd                	lui	s9,0xfffff
    if (va0 >= MAXVA)
    80000a5a:	5c7d                	li	s8,-1
    80000a5c:	01ac5c13          	srli	s8,s8,0x1a
      return -1;
    
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000a60:	6b85                	lui	s7,0x1
    80000a62:	a005                	j	80000a82 <copyout+0x4e>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a64:	412989b3          	sub	s3,s3,s2
    80000a68:	0004861b          	sext.w	a2,s1
    80000a6c:	85d6                	mv	a1,s5
    80000a6e:	954e                	add	a0,a0,s3
    80000a70:	f6aff0ef          	jal	800001da <memmove>

    len -= n;
    80000a74:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000a78:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000a7a:	017909b3          	add	s3,s2,s7
  while(len > 0){
    80000a7e:	020a0b63          	beqz	s4,80000ab4 <copyout+0x80>
    va0 = PGROUNDDOWN(dstva);
    80000a82:	0199f933          	and	s2,s3,s9
    if (va0 >= MAXVA)
    80000a86:	032c6b63          	bltu	s8,s2,80000abc <copyout+0x88>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a8a:	4601                	li	a2,0
    80000a8c:	85ca                	mv	a1,s2
    80000a8e:	855a                	mv	a0,s6
    80000a90:	97bff0ef          	jal	8000040a <walk>
    80000a94:	c131                	beqz	a0,80000ad8 <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a96:	611c                	ld	a5,0(a0)
    80000a98:	8b91                	andi	a5,a5,4
    80000a9a:	c3a9                	beqz	a5,80000adc <copyout+0xa8>
    pa0 = walkaddr(pagetable, va0);
    80000a9c:	85ca                	mv	a1,s2
    80000a9e:	855a                	mv	a0,s6
    80000aa0:	a05ff0ef          	jal	800004a4 <walkaddr>
    if(pa0 == 0)
    80000aa4:	cd15                	beqz	a0,80000ae0 <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    80000aa6:	413904b3          	sub	s1,s2,s3
    80000aaa:	94de                	add	s1,s1,s7
    if(n > len)
    80000aac:	fa9a7ce3          	bgeu	s4,s1,80000a64 <copyout+0x30>
    80000ab0:	84d2                	mv	s1,s4
    80000ab2:	bf4d                	j	80000a64 <copyout+0x30>
  }
  return 0;
    80000ab4:	4501                	li	a0,0
    80000ab6:	a021                	j	80000abe <copyout+0x8a>
    80000ab8:	4501                	li	a0,0
}
    80000aba:	8082                	ret
      return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60e6                	ld	ra,88(sp)
    80000ac0:	6446                	ld	s0,80(sp)
    80000ac2:	64a6                	ld	s1,72(sp)
    80000ac4:	6906                	ld	s2,64(sp)
    80000ac6:	79e2                	ld	s3,56(sp)
    80000ac8:	7a42                	ld	s4,48(sp)
    80000aca:	7aa2                	ld	s5,40(sp)
    80000acc:	7b02                	ld	s6,32(sp)
    80000ace:	6be2                	ld	s7,24(sp)
    80000ad0:	6c42                	ld	s8,16(sp)
    80000ad2:	6ca2                	ld	s9,8(sp)
    80000ad4:	6125                	addi	sp,sp,96
    80000ad6:	8082                	ret
      return -1;
    80000ad8:	557d                	li	a0,-1
    80000ada:	b7d5                	j	80000abe <copyout+0x8a>
      return -1;
    80000adc:	557d                	li	a0,-1
    80000ade:	b7c5                	j	80000abe <copyout+0x8a>
      return -1;
    80000ae0:	557d                	li	a0,-1
    80000ae2:	bff1                	j	80000abe <copyout+0x8a>

0000000080000ae4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000ae4:	c6a5                	beqz	a3,80000b4c <copyin+0x68>
{
    80000ae6:	715d                	addi	sp,sp,-80
    80000ae8:	e486                	sd	ra,72(sp)
    80000aea:	e0a2                	sd	s0,64(sp)
    80000aec:	fc26                	sd	s1,56(sp)
    80000aee:	f84a                	sd	s2,48(sp)
    80000af0:	f44e                	sd	s3,40(sp)
    80000af2:	f052                	sd	s4,32(sp)
    80000af4:	ec56                	sd	s5,24(sp)
    80000af6:	e85a                	sd	s6,16(sp)
    80000af8:	e45e                	sd	s7,8(sp)
    80000afa:	e062                	sd	s8,0(sp)
    80000afc:	0880                	addi	s0,sp,80
    80000afe:	8b2a                	mv	s6,a0
    80000b00:	8a2e                	mv	s4,a1
    80000b02:	8c32                	mv	s8,a2
    80000b04:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b06:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b08:	6a85                	lui	s5,0x1
    80000b0a:	a00d                	j	80000b2c <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b0c:	018505b3          	add	a1,a0,s8
    80000b10:	0004861b          	sext.w	a2,s1
    80000b14:	412585b3          	sub	a1,a1,s2
    80000b18:	8552                	mv	a0,s4
    80000b1a:	ec0ff0ef          	jal	800001da <memmove>

    len -= n;
    80000b1e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b22:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b24:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b28:	02098063          	beqz	s3,80000b48 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b2c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b30:	85ca                	mv	a1,s2
    80000b32:	855a                	mv	a0,s6
    80000b34:	971ff0ef          	jal	800004a4 <walkaddr>
    if(pa0 == 0)
    80000b38:	cd01                	beqz	a0,80000b50 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b3a:	418904b3          	sub	s1,s2,s8
    80000b3e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b40:	fc99f6e3          	bgeu	s3,s1,80000b0c <copyin+0x28>
    80000b44:	84ce                	mv	s1,s3
    80000b46:	b7d9                	j	80000b0c <copyin+0x28>
  }
  return 0;
    80000b48:	4501                	li	a0,0
    80000b4a:	a021                	j	80000b52 <copyin+0x6e>
    80000b4c:	4501                	li	a0,0
}
    80000b4e:	8082                	ret
      return -1;
    80000b50:	557d                	li	a0,-1
}
    80000b52:	60a6                	ld	ra,72(sp)
    80000b54:	6406                	ld	s0,64(sp)
    80000b56:	74e2                	ld	s1,56(sp)
    80000b58:	7942                	ld	s2,48(sp)
    80000b5a:	79a2                	ld	s3,40(sp)
    80000b5c:	7a02                	ld	s4,32(sp)
    80000b5e:	6ae2                	ld	s5,24(sp)
    80000b60:	6b42                	ld	s6,16(sp)
    80000b62:	6ba2                	ld	s7,8(sp)
    80000b64:	6c02                	ld	s8,0(sp)
    80000b66:	6161                	addi	sp,sp,80
    80000b68:	8082                	ret

0000000080000b6a <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000b6a:	715d                	addi	sp,sp,-80
    80000b6c:	e486                	sd	ra,72(sp)
    80000b6e:	e0a2                	sd	s0,64(sp)
    80000b70:	fc26                	sd	s1,56(sp)
    80000b72:	f84a                	sd	s2,48(sp)
    80000b74:	f44e                	sd	s3,40(sp)
    80000b76:	f052                	sd	s4,32(sp)
    80000b78:	ec56                	sd	s5,24(sp)
    80000b7a:	e85a                	sd	s6,16(sp)
    80000b7c:	e45e                	sd	s7,8(sp)
    80000b7e:	0880                	addi	s0,sp,80
    80000b80:	8aaa                	mv	s5,a0
    80000b82:	89ae                	mv	s3,a1
    80000b84:	8bb2                	mv	s7,a2
    80000b86:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000b88:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b8a:	6a05                	lui	s4,0x1
    80000b8c:	a02d                	j	80000bb6 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b8e:	00078023          	sb	zero,0(a5)
    80000b92:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b94:	0017c793          	xori	a5,a5,1
    80000b98:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b9c:	60a6                	ld	ra,72(sp)
    80000b9e:	6406                	ld	s0,64(sp)
    80000ba0:	74e2                	ld	s1,56(sp)
    80000ba2:	7942                	ld	s2,48(sp)
    80000ba4:	79a2                	ld	s3,40(sp)
    80000ba6:	7a02                	ld	s4,32(sp)
    80000ba8:	6ae2                	ld	s5,24(sp)
    80000baa:	6b42                	ld	s6,16(sp)
    80000bac:	6ba2                	ld	s7,8(sp)
    80000bae:	6161                	addi	sp,sp,80
    80000bb0:	8082                	ret
    srcva = va0 + PGSIZE;
    80000bb2:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000bb6:	c4b1                	beqz	s1,80000c02 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000bbc:	85ca                	mv	a1,s2
    80000bbe:	8556                	mv	a0,s5
    80000bc0:	8e5ff0ef          	jal	800004a4 <walkaddr>
    if(pa0 == 0)
    80000bc4:	c129                	beqz	a0,80000c06 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80000bc6:	41790633          	sub	a2,s2,s7
    80000bca:	9652                	add	a2,a2,s4
    if(n > max)
    80000bcc:	00c4f363          	bgeu	s1,a2,80000bd2 <copyinstr+0x68>
    80000bd0:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000bd2:	412b8bb3          	sub	s7,s7,s2
    80000bd6:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000bd8:	de69                	beqz	a2,80000bb2 <copyinstr+0x48>
    80000bda:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000bdc:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000be0:	964e                	add	a2,a2,s3
    80000be2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000be4:	00f68733          	add	a4,a3,a5
    80000be8:	00074703          	lbu	a4,0(a4)
    80000bec:	d34d                	beqz	a4,80000b8e <copyinstr+0x24>
        *dst = *p;
    80000bee:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bf2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bf4:	fec797e3          	bne	a5,a2,80000be2 <copyinstr+0x78>
    80000bf8:	14fd                	addi	s1,s1,-1
    80000bfa:	94ce                	add	s1,s1,s3
      --max;
    80000bfc:	8c8d                	sub	s1,s1,a1
    80000bfe:	89be                	mv	s3,a5
    80000c00:	bf4d                	j	80000bb2 <copyinstr+0x48>
    80000c02:	4781                	li	a5,0
    80000c04:	bf41                	j	80000b94 <copyinstr+0x2a>
      return -1;
    80000c06:	557d                	li	a0,-1
    80000c08:	bf51                	j	80000b9c <copyinstr+0x32>

0000000080000c0a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c0a:	715d                	addi	sp,sp,-80
    80000c0c:	e486                	sd	ra,72(sp)
    80000c0e:	e0a2                	sd	s0,64(sp)
    80000c10:	fc26                	sd	s1,56(sp)
    80000c12:	f84a                	sd	s2,48(sp)
    80000c14:	f44e                	sd	s3,40(sp)
    80000c16:	f052                	sd	s4,32(sp)
    80000c18:	ec56                	sd	s5,24(sp)
    80000c1a:	e85a                	sd	s6,16(sp)
    80000c1c:	e45e                	sd	s7,8(sp)
    80000c1e:	e062                	sd	s8,0(sp)
    80000c20:	0880                	addi	s0,sp,80
    80000c22:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c24:	0000a497          	auipc	s1,0xa
    80000c28:	e0c48493          	addi	s1,s1,-500 # 8000aa30 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c2c:	8c26                	mv	s8,s1
    80000c2e:	e9bd37b7          	lui	a5,0xe9bd3
    80000c32:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bafc97>
    80000c36:	d37a7937          	lui	s2,0xd37a7
    80000c3a:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff5378343e>
    80000c3e:	1902                	slli	s2,s2,0x20
    80000c40:	993e                	add	s2,s2,a5
    80000c42:	040009b7          	lui	s3,0x4000
    80000c46:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c48:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c4a:	4b99                	li	s7,6
    80000c4c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4e:	00010a97          	auipc	s5,0x10
    80000c52:	9e2a8a93          	addi	s5,s5,-1566 # 80010630 <tickslock>
    char *pa = kalloc();
    80000c56:	ca0ff0ef          	jal	800000f6 <kalloc>
    80000c5a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c5c:	c121                	beqz	a0,80000c9c <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000c5e:	418485b3          	sub	a1,s1,s8
    80000c62:	8591                	srai	a1,a1,0x4
    80000c64:	032585b3          	mul	a1,a1,s2
    80000c68:	2585                	addiw	a1,a1,1
    80000c6a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c6e:	875e                	mv	a4,s7
    80000c70:	86da                	mv	a3,s6
    80000c72:	40b985b3          	sub	a1,s3,a1
    80000c76:	8552                	mv	a0,s4
    80000c78:	921ff0ef          	jal	80000598 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c7c:	17048493          	addi	s1,s1,368
    80000c80:	fd549be3          	bne	s1,s5,80000c56 <proc_mapstacks+0x4c>
  }
}
    80000c84:	60a6                	ld	ra,72(sp)
    80000c86:	6406                	ld	s0,64(sp)
    80000c88:	74e2                	ld	s1,56(sp)
    80000c8a:	7942                	ld	s2,48(sp)
    80000c8c:	79a2                	ld	s3,40(sp)
    80000c8e:	7a02                	ld	s4,32(sp)
    80000c90:	6ae2                	ld	s5,24(sp)
    80000c92:	6b42                	ld	s6,16(sp)
    80000c94:	6ba2                	ld	s7,8(sp)
    80000c96:	6c02                	ld	s8,0(sp)
    80000c98:	6161                	addi	sp,sp,80
    80000c9a:	8082                	ret
      panic("kalloc");
    80000c9c:	00006517          	auipc	a0,0x6
    80000ca0:	50c50513          	addi	a0,a0,1292 # 800071a8 <etext+0x1a8>
    80000ca4:	163040ef          	jal	80005606 <panic>

0000000080000ca8 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000ca8:	7139                	addi	sp,sp,-64
    80000caa:	fc06                	sd	ra,56(sp)
    80000cac:	f822                	sd	s0,48(sp)
    80000cae:	f426                	sd	s1,40(sp)
    80000cb0:	f04a                	sd	s2,32(sp)
    80000cb2:	ec4e                	sd	s3,24(sp)
    80000cb4:	e852                	sd	s4,16(sp)
    80000cb6:	e456                	sd	s5,8(sp)
    80000cb8:	e05a                	sd	s6,0(sp)
    80000cba:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cbc:	00006597          	auipc	a1,0x6
    80000cc0:	4f458593          	addi	a1,a1,1268 # 800071b0 <etext+0x1b0>
    80000cc4:	0000a517          	auipc	a0,0xa
    80000cc8:	93c50513          	addi	a0,a0,-1732 # 8000a600 <pid_lock>
    80000ccc:	3e5040ef          	jal	800058b0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cd0:	00006597          	auipc	a1,0x6
    80000cd4:	4e858593          	addi	a1,a1,1256 # 800071b8 <etext+0x1b8>
    80000cd8:	0000a517          	auipc	a0,0xa
    80000cdc:	94050513          	addi	a0,a0,-1728 # 8000a618 <wait_lock>
    80000ce0:	3d1040ef          	jal	800058b0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce4:	0000a497          	auipc	s1,0xa
    80000ce8:	d4c48493          	addi	s1,s1,-692 # 8000aa30 <proc>
      initlock(&p->lock, "proc");
    80000cec:	00006b17          	auipc	s6,0x6
    80000cf0:	4dcb0b13          	addi	s6,s6,1244 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cf4:	8aa6                	mv	s5,s1
    80000cf6:	e9bd37b7          	lui	a5,0xe9bd3
    80000cfa:	7a778793          	addi	a5,a5,1959 # ffffffffe9bd37a7 <end+0xffffffff69bafc97>
    80000cfe:	d37a7937          	lui	s2,0xd37a7
    80000d02:	f4e90913          	addi	s2,s2,-178 # ffffffffd37a6f4e <end+0xffffffff5378343e>
    80000d06:	1902                	slli	s2,s2,0x20
    80000d08:	993e                	add	s2,s2,a5
    80000d0a:	040009b7          	lui	s3,0x4000
    80000d0e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d10:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	00010a17          	auipc	s4,0x10
    80000d16:	91ea0a13          	addi	s4,s4,-1762 # 80010630 <tickslock>
      initlock(&p->lock, "proc");
    80000d1a:	85da                	mv	a1,s6
    80000d1c:	8526                	mv	a0,s1
    80000d1e:	393040ef          	jal	800058b0 <initlock>
      p->state = UNUSED;
    80000d22:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d26:	415487b3          	sub	a5,s1,s5
    80000d2a:	8791                	srai	a5,a5,0x4
    80000d2c:	032787b3          	mul	a5,a5,s2
    80000d30:	2785                	addiw	a5,a5,1
    80000d32:	00d7979b          	slliw	a5,a5,0xd
    80000d36:	40f987b3          	sub	a5,s3,a5
    80000d3a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	17048493          	addi	s1,s1,368
    80000d40:	fd449de3          	bne	s1,s4,80000d1a <procinit+0x72>
  }
}
    80000d44:	70e2                	ld	ra,56(sp)
    80000d46:	7442                	ld	s0,48(sp)
    80000d48:	74a2                	ld	s1,40(sp)
    80000d4a:	7902                	ld	s2,32(sp)
    80000d4c:	69e2                	ld	s3,24(sp)
    80000d4e:	6a42                	ld	s4,16(sp)
    80000d50:	6aa2                	ld	s5,8(sp)
    80000d52:	6b02                	ld	s6,0(sp)
    80000d54:	6121                	addi	sp,sp,64
    80000d56:	8082                	ret

0000000080000d58 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e406                	sd	ra,8(sp)
    80000d5c:	e022                	sd	s0,0(sp)
    80000d5e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d60:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d62:	2501                	sext.w	a0,a0
    80000d64:	60a2                	ld	ra,8(sp)
    80000d66:	6402                	ld	s0,0(sp)
    80000d68:	0141                	addi	sp,sp,16
    80000d6a:	8082                	ret

0000000080000d6c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d6c:	1141                	addi	sp,sp,-16
    80000d6e:	e406                	sd	ra,8(sp)
    80000d70:	e022                	sd	s0,0(sp)
    80000d72:	0800                	addi	s0,sp,16
    80000d74:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d76:	2781                	sext.w	a5,a5
    80000d78:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d7a:	0000a517          	auipc	a0,0xa
    80000d7e:	8b650513          	addi	a0,a0,-1866 # 8000a630 <cpus>
    80000d82:	953e                	add	a0,a0,a5
    80000d84:	60a2                	ld	ra,8(sp)
    80000d86:	6402                	ld	s0,0(sp)
    80000d88:	0141                	addi	sp,sp,16
    80000d8a:	8082                	ret

0000000080000d8c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d8c:	1101                	addi	sp,sp,-32
    80000d8e:	ec06                	sd	ra,24(sp)
    80000d90:	e822                	sd	s0,16(sp)
    80000d92:	e426                	sd	s1,8(sp)
    80000d94:	1000                	addi	s0,sp,32
  push_off();
    80000d96:	35f040ef          	jal	800058f4 <push_off>
    80000d9a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d9c:	2781                	sext.w	a5,a5
    80000d9e:	079e                	slli	a5,a5,0x7
    80000da0:	0000a717          	auipc	a4,0xa
    80000da4:	86070713          	addi	a4,a4,-1952 # 8000a600 <pid_lock>
    80000da8:	97ba                	add	a5,a5,a4
    80000daa:	7b84                	ld	s1,48(a5)
  pop_off();
    80000dac:	3cd040ef          	jal	80005978 <pop_off>
  return p;
}
    80000db0:	8526                	mv	a0,s1
    80000db2:	60e2                	ld	ra,24(sp)
    80000db4:	6442                	ld	s0,16(sp)
    80000db6:	64a2                	ld	s1,8(sp)
    80000db8:	6105                	addi	sp,sp,32
    80000dba:	8082                	ret

0000000080000dbc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dbc:	1141                	addi	sp,sp,-16
    80000dbe:	e406                	sd	ra,8(sp)
    80000dc0:	e022                	sd	s0,0(sp)
    80000dc2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000dc4:	fc9ff0ef          	jal	80000d8c <myproc>
    80000dc8:	401040ef          	jal	800059c8 <release>

  if (first) {
    80000dcc:	00009797          	auipc	a5,0x9
    80000dd0:	7747a783          	lw	a5,1908(a5) # 8000a540 <first.1>
    80000dd4:	e799                	bnez	a5,80000de2 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000dd6:	35b000ef          	jal	80001930 <usertrapret>
}
    80000dda:	60a2                	ld	ra,8(sp)
    80000ddc:	6402                	ld	s0,0(sp)
    80000dde:	0141                	addi	sp,sp,16
    80000de0:	8082                	ret
    fsinit(ROOTDEV);
    80000de2:	4505                	li	a0,1
    80000de4:	7b2010ef          	jal	80002596 <fsinit>
    first = 0;
    80000de8:	00009797          	auipc	a5,0x9
    80000dec:	7407ac23          	sw	zero,1880(a5) # 8000a540 <first.1>
    __sync_synchronize();
    80000df0:	0330000f          	fence	rw,rw
    80000df4:	b7cd                	j	80000dd6 <forkret+0x1a>

0000000080000df6 <allocpid>:
{
    80000df6:	1101                	addi	sp,sp,-32
    80000df8:	ec06                	sd	ra,24(sp)
    80000dfa:	e822                	sd	s0,16(sp)
    80000dfc:	e426                	sd	s1,8(sp)
    80000dfe:	e04a                	sd	s2,0(sp)
    80000e00:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e02:	00009917          	auipc	s2,0x9
    80000e06:	7fe90913          	addi	s2,s2,2046 # 8000a600 <pid_lock>
    80000e0a:	854a                	mv	a0,s2
    80000e0c:	329040ef          	jal	80005934 <acquire>
  pid = nextpid;
    80000e10:	00009797          	auipc	a5,0x9
    80000e14:	73478793          	addi	a5,a5,1844 # 8000a544 <nextpid>
    80000e18:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e1a:	0014871b          	addiw	a4,s1,1
    80000e1e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e20:	854a                	mv	a0,s2
    80000e22:	3a7040ef          	jal	800059c8 <release>
}
    80000e26:	8526                	mv	a0,s1
    80000e28:	60e2                	ld	ra,24(sp)
    80000e2a:	6442                	ld	s0,16(sp)
    80000e2c:	64a2                	ld	s1,8(sp)
    80000e2e:	6902                	ld	s2,0(sp)
    80000e30:	6105                	addi	sp,sp,32
    80000e32:	8082                	ret

0000000080000e34 <proc_pagetable>:
{
    80000e34:	1101                	addi	sp,sp,-32
    80000e36:	ec06                	sd	ra,24(sp)
    80000e38:	e822                	sd	s0,16(sp)
    80000e3a:	e426                	sd	s1,8(sp)
    80000e3c:	e04a                	sd	s2,0(sp)
    80000e3e:	1000                	addi	s0,sp,32
    80000e40:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e42:	913ff0ef          	jal	80000754 <uvmcreate>
    80000e46:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e48:	cd05                	beqz	a0,80000e80 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e4a:	4729                	li	a4,10
    80000e4c:	00005697          	auipc	a3,0x5
    80000e50:	1b468693          	addi	a3,a3,436 # 80006000 <_trampoline>
    80000e54:	6605                	lui	a2,0x1
    80000e56:	040005b7          	lui	a1,0x4000
    80000e5a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e5c:	05b2                	slli	a1,a1,0xc
    80000e5e:	e84ff0ef          	jal	800004e2 <mappages>
    80000e62:	02054663          	bltz	a0,80000e8e <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e66:	4719                	li	a4,6
    80000e68:	05893683          	ld	a3,88(s2)
    80000e6c:	6605                	lui	a2,0x1
    80000e6e:	020005b7          	lui	a1,0x2000
    80000e72:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e74:	05b6                	slli	a1,a1,0xd
    80000e76:	8526                	mv	a0,s1
    80000e78:	e6aff0ef          	jal	800004e2 <mappages>
    80000e7c:	00054f63          	bltz	a0,80000e9a <proc_pagetable+0x66>
}
    80000e80:	8526                	mv	a0,s1
    80000e82:	60e2                	ld	ra,24(sp)
    80000e84:	6442                	ld	s0,16(sp)
    80000e86:	64a2                	ld	s1,8(sp)
    80000e88:	6902                	ld	s2,0(sp)
    80000e8a:	6105                	addi	sp,sp,32
    80000e8c:	8082                	ret
    uvmfree(pagetable, 0);
    80000e8e:	4581                	li	a1,0
    80000e90:	8526                	mv	a0,s1
    80000e92:	a91ff0ef          	jal	80000922 <uvmfree>
    return 0;
    80000e96:	4481                	li	s1,0
    80000e98:	b7e5                	j	80000e80 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e9a:	4681                	li	a3,0
    80000e9c:	4605                	li	a2,1
    80000e9e:	040005b7          	lui	a1,0x4000
    80000ea2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea4:	05b2                	slli	a1,a1,0xc
    80000ea6:	8526                	mv	a0,s1
    80000ea8:	fe0ff0ef          	jal	80000688 <uvmunmap>
    uvmfree(pagetable, 0);
    80000eac:	4581                	li	a1,0
    80000eae:	8526                	mv	a0,s1
    80000eb0:	a73ff0ef          	jal	80000922 <uvmfree>
    return 0;
    80000eb4:	4481                	li	s1,0
    80000eb6:	b7e9                	j	80000e80 <proc_pagetable+0x4c>

0000000080000eb8 <proc_freepagetable>:
{
    80000eb8:	1101                	addi	sp,sp,-32
    80000eba:	ec06                	sd	ra,24(sp)
    80000ebc:	e822                	sd	s0,16(sp)
    80000ebe:	e426                	sd	s1,8(sp)
    80000ec0:	e04a                	sd	s2,0(sp)
    80000ec2:	1000                	addi	s0,sp,32
    80000ec4:	84aa                	mv	s1,a0
    80000ec6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ec8:	4681                	li	a3,0
    80000eca:	4605                	li	a2,1
    80000ecc:	040005b7          	lui	a1,0x4000
    80000ed0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ed2:	05b2                	slli	a1,a1,0xc
    80000ed4:	fb4ff0ef          	jal	80000688 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ed8:	4681                	li	a3,0
    80000eda:	4605                	li	a2,1
    80000edc:	020005b7          	lui	a1,0x2000
    80000ee0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ee2:	05b6                	slli	a1,a1,0xd
    80000ee4:	8526                	mv	a0,s1
    80000ee6:	fa2ff0ef          	jal	80000688 <uvmunmap>
  uvmfree(pagetable, sz);
    80000eea:	85ca                	mv	a1,s2
    80000eec:	8526                	mv	a0,s1
    80000eee:	a35ff0ef          	jal	80000922 <uvmfree>
}
    80000ef2:	60e2                	ld	ra,24(sp)
    80000ef4:	6442                	ld	s0,16(sp)
    80000ef6:	64a2                	ld	s1,8(sp)
    80000ef8:	6902                	ld	s2,0(sp)
    80000efa:	6105                	addi	sp,sp,32
    80000efc:	8082                	ret

0000000080000efe <freeproc>:
{
    80000efe:	1101                	addi	sp,sp,-32
    80000f00:	ec06                	sd	ra,24(sp)
    80000f02:	e822                	sd	s0,16(sp)
    80000f04:	e426                	sd	s1,8(sp)
    80000f06:	1000                	addi	s0,sp,32
    80000f08:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f0a:	6d28                	ld	a0,88(a0)
    80000f0c:	c119                	beqz	a0,80000f12 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f0e:	90eff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f12:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f16:	68a8                	ld	a0,80(s1)
    80000f18:	c501                	beqz	a0,80000f20 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f1a:	64ac                	ld	a1,72(s1)
    80000f1c:	f9dff0ef          	jal	80000eb8 <proc_freepagetable>
  p->pagetable = 0;
    80000f20:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f24:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f28:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f2c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f30:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f34:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f38:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f3c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f40:	0004ac23          	sw	zero,24(s1)
  p->trace_mask = 0;
    80000f44:	1604a423          	sw	zero,360(s1)
}
    80000f48:	60e2                	ld	ra,24(sp)
    80000f4a:	6442                	ld	s0,16(sp)
    80000f4c:	64a2                	ld	s1,8(sp)
    80000f4e:	6105                	addi	sp,sp,32
    80000f50:	8082                	ret

0000000080000f52 <allocproc>:
{
    80000f52:	1101                	addi	sp,sp,-32
    80000f54:	ec06                	sd	ra,24(sp)
    80000f56:	e822                	sd	s0,16(sp)
    80000f58:	e426                	sd	s1,8(sp)
    80000f5a:	e04a                	sd	s2,0(sp)
    80000f5c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5e:	0000a497          	auipc	s1,0xa
    80000f62:	ad248493          	addi	s1,s1,-1326 # 8000aa30 <proc>
    80000f66:	0000f917          	auipc	s2,0xf
    80000f6a:	6ca90913          	addi	s2,s2,1738 # 80010630 <tickslock>
    acquire(&p->lock);
    80000f6e:	8526                	mv	a0,s1
    80000f70:	1c5040ef          	jal	80005934 <acquire>
    if(p->state == UNUSED) {
    80000f74:	4c9c                	lw	a5,24(s1)
    80000f76:	cb91                	beqz	a5,80000f8a <allocproc+0x38>
      release(&p->lock);
    80000f78:	8526                	mv	a0,s1
    80000f7a:	24f040ef          	jal	800059c8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7e:	17048493          	addi	s1,s1,368
    80000f82:	ff2496e3          	bne	s1,s2,80000f6e <allocproc+0x1c>
  return 0;
    80000f86:	4481                	li	s1,0
    80000f88:	a089                	j	80000fca <allocproc+0x78>
  p->pid = allocpid();
    80000f8a:	e6dff0ef          	jal	80000df6 <allocpid>
    80000f8e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f90:	4785                	li	a5,1
    80000f92:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f94:	962ff0ef          	jal	800000f6 <kalloc>
    80000f98:	892a                	mv	s2,a0
    80000f9a:	eca8                	sd	a0,88(s1)
    80000f9c:	cd15                	beqz	a0,80000fd8 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f9e:	8526                	mv	a0,s1
    80000fa0:	e95ff0ef          	jal	80000e34 <proc_pagetable>
    80000fa4:	892a                	mv	s2,a0
    80000fa6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fa8:	c121                	beqz	a0,80000fe8 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000faa:	07000613          	li	a2,112
    80000fae:	4581                	li	a1,0
    80000fb0:	06048513          	addi	a0,s1,96
    80000fb4:	9c2ff0ef          	jal	80000176 <memset>
  p->context.ra = (uint64)forkret;
    80000fb8:	00000797          	auipc	a5,0x0
    80000fbc:	e0478793          	addi	a5,a5,-508 # 80000dbc <forkret>
    80000fc0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fc2:	60bc                	ld	a5,64(s1)
    80000fc4:	6705                	lui	a4,0x1
    80000fc6:	97ba                	add	a5,a5,a4
    80000fc8:	f4bc                	sd	a5,104(s1)
}
    80000fca:	8526                	mv	a0,s1
    80000fcc:	60e2                	ld	ra,24(sp)
    80000fce:	6442                	ld	s0,16(sp)
    80000fd0:	64a2                	ld	s1,8(sp)
    80000fd2:	6902                	ld	s2,0(sp)
    80000fd4:	6105                	addi	sp,sp,32
    80000fd6:	8082                	ret
    freeproc(p);
    80000fd8:	8526                	mv	a0,s1
    80000fda:	f25ff0ef          	jal	80000efe <freeproc>
    release(&p->lock);
    80000fde:	8526                	mv	a0,s1
    80000fe0:	1e9040ef          	jal	800059c8 <release>
    return 0;
    80000fe4:	84ca                	mv	s1,s2
    80000fe6:	b7d5                	j	80000fca <allocproc+0x78>
    freeproc(p);
    80000fe8:	8526                	mv	a0,s1
    80000fea:	f15ff0ef          	jal	80000efe <freeproc>
    release(&p->lock);
    80000fee:	8526                	mv	a0,s1
    80000ff0:	1d9040ef          	jal	800059c8 <release>
    return 0;
    80000ff4:	84ca                	mv	s1,s2
    80000ff6:	bfd1                	j	80000fca <allocproc+0x78>

0000000080000ff8 <userinit>:
{
    80000ff8:	1101                	addi	sp,sp,-32
    80000ffa:	ec06                	sd	ra,24(sp)
    80000ffc:	e822                	sd	s0,16(sp)
    80000ffe:	e426                	sd	s1,8(sp)
    80001000:	1000                	addi	s0,sp,32
  p = allocproc();
    80001002:	f51ff0ef          	jal	80000f52 <allocproc>
    80001006:	84aa                	mv	s1,a0
  initproc = p;
    80001008:	00009797          	auipc	a5,0x9
    8000100c:	5aa7bc23          	sd	a0,1464(a5) # 8000a5c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001010:	03400613          	li	a2,52
    80001014:	00009597          	auipc	a1,0x9
    80001018:	53c58593          	addi	a1,a1,1340 # 8000a550 <initcode>
    8000101c:	6928                	ld	a0,80(a0)
    8000101e:	f5cff0ef          	jal	8000077a <uvmfirst>
  p->sz = PGSIZE;
    80001022:	6785                	lui	a5,0x1
    80001024:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001026:	6cb8                	ld	a4,88(s1)
    80001028:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000102c:	6cb8                	ld	a4,88(s1)
    8000102e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001030:	4641                	li	a2,16
    80001032:	00006597          	auipc	a1,0x6
    80001036:	19e58593          	addi	a1,a1,414 # 800071d0 <etext+0x1d0>
    8000103a:	15848513          	addi	a0,s1,344
    8000103e:	a8aff0ef          	jal	800002c8 <safestrcpy>
  p->cwd = namei("/");
    80001042:	00006517          	auipc	a0,0x6
    80001046:	19e50513          	addi	a0,a0,414 # 800071e0 <etext+0x1e0>
    8000104a:	671010ef          	jal	80002eba <namei>
    8000104e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001052:	478d                	li	a5,3
    80001054:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001056:	8526                	mv	a0,s1
    80001058:	171040ef          	jal	800059c8 <release>
}
    8000105c:	60e2                	ld	ra,24(sp)
    8000105e:	6442                	ld	s0,16(sp)
    80001060:	64a2                	ld	s1,8(sp)
    80001062:	6105                	addi	sp,sp,32
    80001064:	8082                	ret

0000000080001066 <growproc>:
{
    80001066:	1101                	addi	sp,sp,-32
    80001068:	ec06                	sd	ra,24(sp)
    8000106a:	e822                	sd	s0,16(sp)
    8000106c:	e426                	sd	s1,8(sp)
    8000106e:	e04a                	sd	s2,0(sp)
    80001070:	1000                	addi	s0,sp,32
    80001072:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001074:	d19ff0ef          	jal	80000d8c <myproc>
    80001078:	84aa                	mv	s1,a0
  sz = p->sz;
    8000107a:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000107c:	01204c63          	bgtz	s2,80001094 <growproc+0x2e>
  } else if(n < 0){
    80001080:	02094463          	bltz	s2,800010a8 <growproc+0x42>
  p->sz = sz;
    80001084:	e4ac                	sd	a1,72(s1)
  return 0;
    80001086:	4501                	li	a0,0
}
    80001088:	60e2                	ld	ra,24(sp)
    8000108a:	6442                	ld	s0,16(sp)
    8000108c:	64a2                	ld	s1,8(sp)
    8000108e:	6902                	ld	s2,0(sp)
    80001090:	6105                	addi	sp,sp,32
    80001092:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001094:	4691                	li	a3,4
    80001096:	00b90633          	add	a2,s2,a1
    8000109a:	6928                	ld	a0,80(a0)
    8000109c:	f80ff0ef          	jal	8000081c <uvmalloc>
    800010a0:	85aa                	mv	a1,a0
    800010a2:	f16d                	bnez	a0,80001084 <growproc+0x1e>
      return -1;
    800010a4:	557d                	li	a0,-1
    800010a6:	b7cd                	j	80001088 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010a8:	00b90633          	add	a2,s2,a1
    800010ac:	6928                	ld	a0,80(a0)
    800010ae:	f2aff0ef          	jal	800007d8 <uvmdealloc>
    800010b2:	85aa                	mv	a1,a0
    800010b4:	bfc1                	j	80001084 <growproc+0x1e>

00000000800010b6 <fork>:
{
    800010b6:	7139                	addi	sp,sp,-64
    800010b8:	fc06                	sd	ra,56(sp)
    800010ba:	f822                	sd	s0,48(sp)
    800010bc:	f04a                	sd	s2,32(sp)
    800010be:	e456                	sd	s5,8(sp)
    800010c0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010c2:	ccbff0ef          	jal	80000d8c <myproc>
    800010c6:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010c8:	e8bff0ef          	jal	80000f52 <allocproc>
    800010cc:	0e050e63          	beqz	a0,800011c8 <fork+0x112>
    800010d0:	ec4e                	sd	s3,24(sp)
    800010d2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010d4:	048ab603          	ld	a2,72(s5)
    800010d8:	692c                	ld	a1,80(a0)
    800010da:	050ab503          	ld	a0,80(s5)
    800010de:	877ff0ef          	jal	80000954 <uvmcopy>
    800010e2:	04054a63          	bltz	a0,80001136 <fork+0x80>
    800010e6:	f426                	sd	s1,40(sp)
    800010e8:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800010ea:	048ab783          	ld	a5,72(s5)
    800010ee:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800010f2:	058ab683          	ld	a3,88(s5)
    800010f6:	87b6                	mv	a5,a3
    800010f8:	0589b703          	ld	a4,88(s3)
    800010fc:	12068693          	addi	a3,a3,288
    80001100:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001104:	6788                	ld	a0,8(a5)
    80001106:	6b8c                	ld	a1,16(a5)
    80001108:	6f90                	ld	a2,24(a5)
    8000110a:	01073023          	sd	a6,0(a4)
    8000110e:	e708                	sd	a0,8(a4)
    80001110:	eb0c                	sd	a1,16(a4)
    80001112:	ef10                	sd	a2,24(a4)
    80001114:	02078793          	addi	a5,a5,32
    80001118:	02070713          	addi	a4,a4,32
    8000111c:	fed792e3          	bne	a5,a3,80001100 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001120:	0589b783          	ld	a5,88(s3)
    80001124:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001128:	0d0a8493          	addi	s1,s5,208
    8000112c:	0d098913          	addi	s2,s3,208
    80001130:	150a8a13          	addi	s4,s5,336
    80001134:	a831                	j	80001150 <fork+0x9a>
    freeproc(np);
    80001136:	854e                	mv	a0,s3
    80001138:	dc7ff0ef          	jal	80000efe <freeproc>
    release(&np->lock);
    8000113c:	854e                	mv	a0,s3
    8000113e:	08b040ef          	jal	800059c8 <release>
    return -1;
    80001142:	597d                	li	s2,-1
    80001144:	69e2                	ld	s3,24(sp)
    80001146:	a895                	j	800011ba <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001148:	04a1                	addi	s1,s1,8
    8000114a:	0921                	addi	s2,s2,8
    8000114c:	01448963          	beq	s1,s4,8000115e <fork+0xa8>
    if(p->ofile[i])
    80001150:	6088                	ld	a0,0(s1)
    80001152:	d97d                	beqz	a0,80001148 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001154:	302020ef          	jal	80003456 <filedup>
    80001158:	00a93023          	sd	a0,0(s2)
    8000115c:	b7f5                	j	80001148 <fork+0x92>
  np->cwd = idup(p->cwd);
    8000115e:	150ab503          	ld	a0,336(s5)
    80001162:	632010ef          	jal	80002794 <idup>
    80001166:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000116a:	4641                	li	a2,16
    8000116c:	158a8593          	addi	a1,s5,344
    80001170:	15898513          	addi	a0,s3,344
    80001174:	954ff0ef          	jal	800002c8 <safestrcpy>
  pid = np->pid;
    80001178:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000117c:	854e                	mv	a0,s3
    8000117e:	04b040ef          	jal	800059c8 <release>
  acquire(&wait_lock);
    80001182:	00009497          	auipc	s1,0x9
    80001186:	49648493          	addi	s1,s1,1174 # 8000a618 <wait_lock>
    8000118a:	8526                	mv	a0,s1
    8000118c:	7a8040ef          	jal	80005934 <acquire>
  np->parent = p;
    80001190:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001194:	8526                	mv	a0,s1
    80001196:	033040ef          	jal	800059c8 <release>
  acquire(&np->lock);
    8000119a:	854e                	mv	a0,s3
    8000119c:	798040ef          	jal	80005934 <acquire>
  np->state = RUNNABLE;
    800011a0:	478d                	li	a5,3
    800011a2:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800011a6:	854e                	mv	a0,s3
    800011a8:	021040ef          	jal	800059c8 <release>
  np->trace_mask = p->trace_mask;
    800011ac:	168aa783          	lw	a5,360(s5)
    800011b0:	16f9a423          	sw	a5,360(s3)
  return pid;
    800011b4:	74a2                	ld	s1,40(sp)
    800011b6:	69e2                	ld	s3,24(sp)
    800011b8:	6a42                	ld	s4,16(sp)
}
    800011ba:	854a                	mv	a0,s2
    800011bc:	70e2                	ld	ra,56(sp)
    800011be:	7442                	ld	s0,48(sp)
    800011c0:	7902                	ld	s2,32(sp)
    800011c2:	6aa2                	ld	s5,8(sp)
    800011c4:	6121                	addi	sp,sp,64
    800011c6:	8082                	ret
    return -1;
    800011c8:	597d                	li	s2,-1
    800011ca:	bfc5                	j	800011ba <fork+0x104>

00000000800011cc <scheduler>:
{
    800011cc:	715d                	addi	sp,sp,-80
    800011ce:	e486                	sd	ra,72(sp)
    800011d0:	e0a2                	sd	s0,64(sp)
    800011d2:	fc26                	sd	s1,56(sp)
    800011d4:	f84a                	sd	s2,48(sp)
    800011d6:	f44e                	sd	s3,40(sp)
    800011d8:	f052                	sd	s4,32(sp)
    800011da:	ec56                	sd	s5,24(sp)
    800011dc:	e85a                	sd	s6,16(sp)
    800011de:	e45e                	sd	s7,8(sp)
    800011e0:	e062                	sd	s8,0(sp)
    800011e2:	0880                	addi	s0,sp,80
    800011e4:	8792                	mv	a5,tp
  int id = r_tp();
    800011e6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011e8:	00779b13          	slli	s6,a5,0x7
    800011ec:	00009717          	auipc	a4,0x9
    800011f0:	41470713          	addi	a4,a4,1044 # 8000a600 <pid_lock>
    800011f4:	975a                	add	a4,a4,s6
    800011f6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011fa:	00009717          	auipc	a4,0x9
    800011fe:	43e70713          	addi	a4,a4,1086 # 8000a638 <cpus+0x8>
    80001202:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001204:	4c11                	li	s8,4
        c->proc = p;
    80001206:	079e                	slli	a5,a5,0x7
    80001208:	00009a17          	auipc	s4,0x9
    8000120c:	3f8a0a13          	addi	s4,s4,1016 # 8000a600 <pid_lock>
    80001210:	9a3e                	add	s4,s4,a5
        found = 1;
    80001212:	4b85                	li	s7,1
    80001214:	a0a9                	j	8000125e <scheduler+0x92>
      release(&p->lock);
    80001216:	8526                	mv	a0,s1
    80001218:	7b0040ef          	jal	800059c8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000121c:	17048493          	addi	s1,s1,368
    80001220:	03248563          	beq	s1,s2,8000124a <scheduler+0x7e>
      acquire(&p->lock);
    80001224:	8526                	mv	a0,s1
    80001226:	70e040ef          	jal	80005934 <acquire>
      if(p->state == RUNNABLE) {
    8000122a:	4c9c                	lw	a5,24(s1)
    8000122c:	ff3795e3          	bne	a5,s3,80001216 <scheduler+0x4a>
        p->state = RUNNING;
    80001230:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001234:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001238:	06048593          	addi	a1,s1,96
    8000123c:	855a                	mv	a0,s6
    8000123e:	648000ef          	jal	80001886 <swtch>
        c->proc = 0;
    80001242:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001246:	8ade                	mv	s5,s7
    80001248:	b7f9                	j	80001216 <scheduler+0x4a>
    if(found == 0) {
    8000124a:	000a9a63          	bnez	s5,8000125e <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000124e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001252:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001256:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000125a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000125e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001262:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001266:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000126a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000126c:	00009497          	auipc	s1,0x9
    80001270:	7c448493          	addi	s1,s1,1988 # 8000aa30 <proc>
      if(p->state == RUNNABLE) {
    80001274:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001276:	0000f917          	auipc	s2,0xf
    8000127a:	3ba90913          	addi	s2,s2,954 # 80010630 <tickslock>
    8000127e:	b75d                	j	80001224 <scheduler+0x58>

0000000080001280 <sched>:
{
    80001280:	7179                	addi	sp,sp,-48
    80001282:	f406                	sd	ra,40(sp)
    80001284:	f022                	sd	s0,32(sp)
    80001286:	ec26                	sd	s1,24(sp)
    80001288:	e84a                	sd	s2,16(sp)
    8000128a:	e44e                	sd	s3,8(sp)
    8000128c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000128e:	affff0ef          	jal	80000d8c <myproc>
    80001292:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001294:	636040ef          	jal	800058ca <holding>
    80001298:	c92d                	beqz	a0,8000130a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000129a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000129c:	2781                	sext.w	a5,a5
    8000129e:	079e                	slli	a5,a5,0x7
    800012a0:	00009717          	auipc	a4,0x9
    800012a4:	36070713          	addi	a4,a4,864 # 8000a600 <pid_lock>
    800012a8:	97ba                	add	a5,a5,a4
    800012aa:	0a87a703          	lw	a4,168(a5)
    800012ae:	4785                	li	a5,1
    800012b0:	06f71363          	bne	a4,a5,80001316 <sched+0x96>
  if(p->state == RUNNING)
    800012b4:	4c98                	lw	a4,24(s1)
    800012b6:	4791                	li	a5,4
    800012b8:	06f70563          	beq	a4,a5,80001322 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012bc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012c0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012c2:	e7b5                	bnez	a5,8000132e <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012c4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012c6:	00009917          	auipc	s2,0x9
    800012ca:	33a90913          	addi	s2,s2,826 # 8000a600 <pid_lock>
    800012ce:	2781                	sext.w	a5,a5
    800012d0:	079e                	slli	a5,a5,0x7
    800012d2:	97ca                	add	a5,a5,s2
    800012d4:	0ac7a983          	lw	s3,172(a5)
    800012d8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012da:	2781                	sext.w	a5,a5
    800012dc:	079e                	slli	a5,a5,0x7
    800012de:	00009597          	auipc	a1,0x9
    800012e2:	35a58593          	addi	a1,a1,858 # 8000a638 <cpus+0x8>
    800012e6:	95be                	add	a1,a1,a5
    800012e8:	06048513          	addi	a0,s1,96
    800012ec:	59a000ef          	jal	80001886 <swtch>
    800012f0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012f2:	2781                	sext.w	a5,a5
    800012f4:	079e                	slli	a5,a5,0x7
    800012f6:	993e                	add	s2,s2,a5
    800012f8:	0b392623          	sw	s3,172(s2)
}
    800012fc:	70a2                	ld	ra,40(sp)
    800012fe:	7402                	ld	s0,32(sp)
    80001300:	64e2                	ld	s1,24(sp)
    80001302:	6942                	ld	s2,16(sp)
    80001304:	69a2                	ld	s3,8(sp)
    80001306:	6145                	addi	sp,sp,48
    80001308:	8082                	ret
    panic("sched p->lock");
    8000130a:	00006517          	auipc	a0,0x6
    8000130e:	ede50513          	addi	a0,a0,-290 # 800071e8 <etext+0x1e8>
    80001312:	2f4040ef          	jal	80005606 <panic>
    panic("sched locks");
    80001316:	00006517          	auipc	a0,0x6
    8000131a:	ee250513          	addi	a0,a0,-286 # 800071f8 <etext+0x1f8>
    8000131e:	2e8040ef          	jal	80005606 <panic>
    panic("sched running");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	ee650513          	addi	a0,a0,-282 # 80007208 <etext+0x208>
    8000132a:	2dc040ef          	jal	80005606 <panic>
    panic("sched interruptible");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	eea50513          	addi	a0,a0,-278 # 80007218 <etext+0x218>
    80001336:	2d0040ef          	jal	80005606 <panic>

000000008000133a <yield>:
{
    8000133a:	1101                	addi	sp,sp,-32
    8000133c:	ec06                	sd	ra,24(sp)
    8000133e:	e822                	sd	s0,16(sp)
    80001340:	e426                	sd	s1,8(sp)
    80001342:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001344:	a49ff0ef          	jal	80000d8c <myproc>
    80001348:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000134a:	5ea040ef          	jal	80005934 <acquire>
  p->state = RUNNABLE;
    8000134e:	478d                	li	a5,3
    80001350:	cc9c                	sw	a5,24(s1)
  sched();
    80001352:	f2fff0ef          	jal	80001280 <sched>
  release(&p->lock);
    80001356:	8526                	mv	a0,s1
    80001358:	670040ef          	jal	800059c8 <release>
}
    8000135c:	60e2                	ld	ra,24(sp)
    8000135e:	6442                	ld	s0,16(sp)
    80001360:	64a2                	ld	s1,8(sp)
    80001362:	6105                	addi	sp,sp,32
    80001364:	8082                	ret

0000000080001366 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001366:	7179                	addi	sp,sp,-48
    80001368:	f406                	sd	ra,40(sp)
    8000136a:	f022                	sd	s0,32(sp)
    8000136c:	ec26                	sd	s1,24(sp)
    8000136e:	e84a                	sd	s2,16(sp)
    80001370:	e44e                	sd	s3,8(sp)
    80001372:	1800                	addi	s0,sp,48
    80001374:	89aa                	mv	s3,a0
    80001376:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001378:	a15ff0ef          	jal	80000d8c <myproc>
    8000137c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000137e:	5b6040ef          	jal	80005934 <acquire>
  release(lk);
    80001382:	854a                	mv	a0,s2
    80001384:	644040ef          	jal	800059c8 <release>

  // Go to sleep.
  p->chan = chan;
    80001388:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000138c:	4789                	li	a5,2
    8000138e:	cc9c                	sw	a5,24(s1)

  sched();
    80001390:	ef1ff0ef          	jal	80001280 <sched>

  // Tidy up.
  p->chan = 0;
    80001394:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001398:	8526                	mv	a0,s1
    8000139a:	62e040ef          	jal	800059c8 <release>
  acquire(lk);
    8000139e:	854a                	mv	a0,s2
    800013a0:	594040ef          	jal	80005934 <acquire>
}
    800013a4:	70a2                	ld	ra,40(sp)
    800013a6:	7402                	ld	s0,32(sp)
    800013a8:	64e2                	ld	s1,24(sp)
    800013aa:	6942                	ld	s2,16(sp)
    800013ac:	69a2                	ld	s3,8(sp)
    800013ae:	6145                	addi	sp,sp,48
    800013b0:	8082                	ret

00000000800013b2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013b2:	7139                	addi	sp,sp,-64
    800013b4:	fc06                	sd	ra,56(sp)
    800013b6:	f822                	sd	s0,48(sp)
    800013b8:	f426                	sd	s1,40(sp)
    800013ba:	f04a                	sd	s2,32(sp)
    800013bc:	ec4e                	sd	s3,24(sp)
    800013be:	e852                	sd	s4,16(sp)
    800013c0:	e456                	sd	s5,8(sp)
    800013c2:	0080                	addi	s0,sp,64
    800013c4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013c6:	00009497          	auipc	s1,0x9
    800013ca:	66a48493          	addi	s1,s1,1642 # 8000aa30 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013ce:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013d0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013d2:	0000f917          	auipc	s2,0xf
    800013d6:	25e90913          	addi	s2,s2,606 # 80010630 <tickslock>
    800013da:	a801                	j	800013ea <wakeup+0x38>
      }
      release(&p->lock);
    800013dc:	8526                	mv	a0,s1
    800013de:	5ea040ef          	jal	800059c8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013e2:	17048493          	addi	s1,s1,368
    800013e6:	03248263          	beq	s1,s2,8000140a <wakeup+0x58>
    if(p != myproc()){
    800013ea:	9a3ff0ef          	jal	80000d8c <myproc>
    800013ee:	fea48ae3          	beq	s1,a0,800013e2 <wakeup+0x30>
      acquire(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	540040ef          	jal	80005934 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013f8:	4c9c                	lw	a5,24(s1)
    800013fa:	ff3791e3          	bne	a5,s3,800013dc <wakeup+0x2a>
    800013fe:	709c                	ld	a5,32(s1)
    80001400:	fd479ee3          	bne	a5,s4,800013dc <wakeup+0x2a>
        p->state = RUNNABLE;
    80001404:	0154ac23          	sw	s5,24(s1)
    80001408:	bfd1                	j	800013dc <wakeup+0x2a>
    }
  }
}
    8000140a:	70e2                	ld	ra,56(sp)
    8000140c:	7442                	ld	s0,48(sp)
    8000140e:	74a2                	ld	s1,40(sp)
    80001410:	7902                	ld	s2,32(sp)
    80001412:	69e2                	ld	s3,24(sp)
    80001414:	6a42                	ld	s4,16(sp)
    80001416:	6aa2                	ld	s5,8(sp)
    80001418:	6121                	addi	sp,sp,64
    8000141a:	8082                	ret

000000008000141c <reparent>:
{
    8000141c:	7179                	addi	sp,sp,-48
    8000141e:	f406                	sd	ra,40(sp)
    80001420:	f022                	sd	s0,32(sp)
    80001422:	ec26                	sd	s1,24(sp)
    80001424:	e84a                	sd	s2,16(sp)
    80001426:	e44e                	sd	s3,8(sp)
    80001428:	e052                	sd	s4,0(sp)
    8000142a:	1800                	addi	s0,sp,48
    8000142c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000142e:	00009497          	auipc	s1,0x9
    80001432:	60248493          	addi	s1,s1,1538 # 8000aa30 <proc>
      pp->parent = initproc;
    80001436:	00009a17          	auipc	s4,0x9
    8000143a:	18aa0a13          	addi	s4,s4,394 # 8000a5c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143e:	0000f997          	auipc	s3,0xf
    80001442:	1f298993          	addi	s3,s3,498 # 80010630 <tickslock>
    80001446:	a029                	j	80001450 <reparent+0x34>
    80001448:	17048493          	addi	s1,s1,368
    8000144c:	01348b63          	beq	s1,s3,80001462 <reparent+0x46>
    if(pp->parent == p){
    80001450:	7c9c                	ld	a5,56(s1)
    80001452:	ff279be3          	bne	a5,s2,80001448 <reparent+0x2c>
      pp->parent = initproc;
    80001456:	000a3503          	ld	a0,0(s4)
    8000145a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000145c:	f57ff0ef          	jal	800013b2 <wakeup>
    80001460:	b7e5                	j	80001448 <reparent+0x2c>
}
    80001462:	70a2                	ld	ra,40(sp)
    80001464:	7402                	ld	s0,32(sp)
    80001466:	64e2                	ld	s1,24(sp)
    80001468:	6942                	ld	s2,16(sp)
    8000146a:	69a2                	ld	s3,8(sp)
    8000146c:	6a02                	ld	s4,0(sp)
    8000146e:	6145                	addi	sp,sp,48
    80001470:	8082                	ret

0000000080001472 <exit>:
{
    80001472:	7179                	addi	sp,sp,-48
    80001474:	f406                	sd	ra,40(sp)
    80001476:	f022                	sd	s0,32(sp)
    80001478:	ec26                	sd	s1,24(sp)
    8000147a:	e84a                	sd	s2,16(sp)
    8000147c:	e44e                	sd	s3,8(sp)
    8000147e:	e052                	sd	s4,0(sp)
    80001480:	1800                	addi	s0,sp,48
    80001482:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001484:	909ff0ef          	jal	80000d8c <myproc>
    80001488:	89aa                	mv	s3,a0
  if(p == initproc)
    8000148a:	00009797          	auipc	a5,0x9
    8000148e:	1367b783          	ld	a5,310(a5) # 8000a5c0 <initproc>
    80001492:	0d050493          	addi	s1,a0,208
    80001496:	15050913          	addi	s2,a0,336
    8000149a:	00a79b63          	bne	a5,a0,800014b0 <exit+0x3e>
    panic("init exiting");
    8000149e:	00006517          	auipc	a0,0x6
    800014a2:	d9250513          	addi	a0,a0,-622 # 80007230 <etext+0x230>
    800014a6:	160040ef          	jal	80005606 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800014aa:	04a1                	addi	s1,s1,8
    800014ac:	01248963          	beq	s1,s2,800014be <exit+0x4c>
    if(p->ofile[fd]){
    800014b0:	6088                	ld	a0,0(s1)
    800014b2:	dd65                	beqz	a0,800014aa <exit+0x38>
      fileclose(f);
    800014b4:	7e9010ef          	jal	8000349c <fileclose>
      p->ofile[fd] = 0;
    800014b8:	0004b023          	sd	zero,0(s1)
    800014bc:	b7fd                	j	800014aa <exit+0x38>
  begin_op();
    800014be:	3bf010ef          	jal	8000307c <begin_op>
  iput(p->cwd);
    800014c2:	1509b503          	ld	a0,336(s3)
    800014c6:	486010ef          	jal	8000294c <iput>
  end_op();
    800014ca:	41d010ef          	jal	800030e6 <end_op>
  p->cwd = 0;
    800014ce:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014d2:	00009497          	auipc	s1,0x9
    800014d6:	14648493          	addi	s1,s1,326 # 8000a618 <wait_lock>
    800014da:	8526                	mv	a0,s1
    800014dc:	458040ef          	jal	80005934 <acquire>
  reparent(p);
    800014e0:	854e                	mv	a0,s3
    800014e2:	f3bff0ef          	jal	8000141c <reparent>
  wakeup(p->parent);
    800014e6:	0389b503          	ld	a0,56(s3)
    800014ea:	ec9ff0ef          	jal	800013b2 <wakeup>
  acquire(&p->lock);
    800014ee:	854e                	mv	a0,s3
    800014f0:	444040ef          	jal	80005934 <acquire>
  p->xstate = status;
    800014f4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014f8:	4795                	li	a5,5
    800014fa:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	4c8040ef          	jal	800059c8 <release>
  sched();
    80001504:	d7dff0ef          	jal	80001280 <sched>
  panic("zombie exit");
    80001508:	00006517          	auipc	a0,0x6
    8000150c:	d3850513          	addi	a0,a0,-712 # 80007240 <etext+0x240>
    80001510:	0f6040ef          	jal	80005606 <panic>

0000000080001514 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001514:	7179                	addi	sp,sp,-48
    80001516:	f406                	sd	ra,40(sp)
    80001518:	f022                	sd	s0,32(sp)
    8000151a:	ec26                	sd	s1,24(sp)
    8000151c:	e84a                	sd	s2,16(sp)
    8000151e:	e44e                	sd	s3,8(sp)
    80001520:	1800                	addi	s0,sp,48
    80001522:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001524:	00009497          	auipc	s1,0x9
    80001528:	50c48493          	addi	s1,s1,1292 # 8000aa30 <proc>
    8000152c:	0000f997          	auipc	s3,0xf
    80001530:	10498993          	addi	s3,s3,260 # 80010630 <tickslock>
    acquire(&p->lock);
    80001534:	8526                	mv	a0,s1
    80001536:	3fe040ef          	jal	80005934 <acquire>
    if(p->pid == pid){
    8000153a:	589c                	lw	a5,48(s1)
    8000153c:	01278b63          	beq	a5,s2,80001552 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	486040ef          	jal	800059c8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001546:	17048493          	addi	s1,s1,368
    8000154a:	ff3495e3          	bne	s1,s3,80001534 <kill+0x20>
  }
  return -1;
    8000154e:	557d                	li	a0,-1
    80001550:	a819                	j	80001566 <kill+0x52>
      p->killed = 1;
    80001552:	4785                	li	a5,1
    80001554:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001556:	4c98                	lw	a4,24(s1)
    80001558:	4789                	li	a5,2
    8000155a:	00f70d63          	beq	a4,a5,80001574 <kill+0x60>
      release(&p->lock);
    8000155e:	8526                	mv	a0,s1
    80001560:	468040ef          	jal	800059c8 <release>
      return 0;
    80001564:	4501                	li	a0,0
}
    80001566:	70a2                	ld	ra,40(sp)
    80001568:	7402                	ld	s0,32(sp)
    8000156a:	64e2                	ld	s1,24(sp)
    8000156c:	6942                	ld	s2,16(sp)
    8000156e:	69a2                	ld	s3,8(sp)
    80001570:	6145                	addi	sp,sp,48
    80001572:	8082                	ret
        p->state = RUNNABLE;
    80001574:	478d                	li	a5,3
    80001576:	cc9c                	sw	a5,24(s1)
    80001578:	b7dd                	j	8000155e <kill+0x4a>

000000008000157a <setkilled>:

void
setkilled(struct proc *p)
{
    8000157a:	1101                	addi	sp,sp,-32
    8000157c:	ec06                	sd	ra,24(sp)
    8000157e:	e822                	sd	s0,16(sp)
    80001580:	e426                	sd	s1,8(sp)
    80001582:	1000                	addi	s0,sp,32
    80001584:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001586:	3ae040ef          	jal	80005934 <acquire>
  p->killed = 1;
    8000158a:	4785                	li	a5,1
    8000158c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	438040ef          	jal	800059c8 <release>
}
    80001594:	60e2                	ld	ra,24(sp)
    80001596:	6442                	ld	s0,16(sp)
    80001598:	64a2                	ld	s1,8(sp)
    8000159a:	6105                	addi	sp,sp,32
    8000159c:	8082                	ret

000000008000159e <killed>:

int
killed(struct proc *p)
{
    8000159e:	1101                	addi	sp,sp,-32
    800015a0:	ec06                	sd	ra,24(sp)
    800015a2:	e822                	sd	s0,16(sp)
    800015a4:	e426                	sd	s1,8(sp)
    800015a6:	e04a                	sd	s2,0(sp)
    800015a8:	1000                	addi	s0,sp,32
    800015aa:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015ac:	388040ef          	jal	80005934 <acquire>
  k = p->killed;
    800015b0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015b4:	8526                	mv	a0,s1
    800015b6:	412040ef          	jal	800059c8 <release>
  return k;
}
    800015ba:	854a                	mv	a0,s2
    800015bc:	60e2                	ld	ra,24(sp)
    800015be:	6442                	ld	s0,16(sp)
    800015c0:	64a2                	ld	s1,8(sp)
    800015c2:	6902                	ld	s2,0(sp)
    800015c4:	6105                	addi	sp,sp,32
    800015c6:	8082                	ret

00000000800015c8 <wait>:
{
    800015c8:	715d                	addi	sp,sp,-80
    800015ca:	e486                	sd	ra,72(sp)
    800015cc:	e0a2                	sd	s0,64(sp)
    800015ce:	fc26                	sd	s1,56(sp)
    800015d0:	f84a                	sd	s2,48(sp)
    800015d2:	f44e                	sd	s3,40(sp)
    800015d4:	f052                	sd	s4,32(sp)
    800015d6:	ec56                	sd	s5,24(sp)
    800015d8:	e85a                	sd	s6,16(sp)
    800015da:	e45e                	sd	s7,8(sp)
    800015dc:	0880                	addi	s0,sp,80
    800015de:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015e0:	facff0ef          	jal	80000d8c <myproc>
    800015e4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e6:	00009517          	auipc	a0,0x9
    800015ea:	03250513          	addi	a0,a0,50 # 8000a618 <wait_lock>
    800015ee:	346040ef          	jal	80005934 <acquire>
        if(pp->state == ZOMBIE){
    800015f2:	4a15                	li	s4,5
        havekids = 1;
    800015f4:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f6:	0000f997          	auipc	s3,0xf
    800015fa:	03a98993          	addi	s3,s3,58 # 80010630 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fe:	00009b97          	auipc	s7,0x9
    80001602:	01ab8b93          	addi	s7,s7,26 # 8000a618 <wait_lock>
    80001606:	a869                	j	800016a0 <wait+0xd8>
          pid = pp->pid;
    80001608:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000160c:	000b0c63          	beqz	s6,80001624 <wait+0x5c>
    80001610:	4691                	li	a3,4
    80001612:	02c48613          	addi	a2,s1,44
    80001616:	85da                	mv	a1,s6
    80001618:	05093503          	ld	a0,80(s2)
    8000161c:	c18ff0ef          	jal	80000a34 <copyout>
    80001620:	02054a63          	bltz	a0,80001654 <wait+0x8c>
          freeproc(pp);
    80001624:	8526                	mv	a0,s1
    80001626:	8d9ff0ef          	jal	80000efe <freeproc>
          release(&pp->lock);
    8000162a:	8526                	mv	a0,s1
    8000162c:	39c040ef          	jal	800059c8 <release>
          release(&wait_lock);
    80001630:	00009517          	auipc	a0,0x9
    80001634:	fe850513          	addi	a0,a0,-24 # 8000a618 <wait_lock>
    80001638:	390040ef          	jal	800059c8 <release>
}
    8000163c:	854e                	mv	a0,s3
    8000163e:	60a6                	ld	ra,72(sp)
    80001640:	6406                	ld	s0,64(sp)
    80001642:	74e2                	ld	s1,56(sp)
    80001644:	7942                	ld	s2,48(sp)
    80001646:	79a2                	ld	s3,40(sp)
    80001648:	7a02                	ld	s4,32(sp)
    8000164a:	6ae2                	ld	s5,24(sp)
    8000164c:	6b42                	ld	s6,16(sp)
    8000164e:	6ba2                	ld	s7,8(sp)
    80001650:	6161                	addi	sp,sp,80
    80001652:	8082                	ret
            release(&pp->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	372040ef          	jal	800059c8 <release>
            release(&wait_lock);
    8000165a:	00009517          	auipc	a0,0x9
    8000165e:	fbe50513          	addi	a0,a0,-66 # 8000a618 <wait_lock>
    80001662:	366040ef          	jal	800059c8 <release>
            return -1;
    80001666:	59fd                	li	s3,-1
    80001668:	bfd1                	j	8000163c <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000166a:	17048493          	addi	s1,s1,368
    8000166e:	03348063          	beq	s1,s3,8000168e <wait+0xc6>
      if(pp->parent == p){
    80001672:	7c9c                	ld	a5,56(s1)
    80001674:	ff279be3          	bne	a5,s2,8000166a <wait+0xa2>
        acquire(&pp->lock);
    80001678:	8526                	mv	a0,s1
    8000167a:	2ba040ef          	jal	80005934 <acquire>
        if(pp->state == ZOMBIE){
    8000167e:	4c9c                	lw	a5,24(s1)
    80001680:	f94784e3          	beq	a5,s4,80001608 <wait+0x40>
        release(&pp->lock);
    80001684:	8526                	mv	a0,s1
    80001686:	342040ef          	jal	800059c8 <release>
        havekids = 1;
    8000168a:	8756                	mv	a4,s5
    8000168c:	bff9                	j	8000166a <wait+0xa2>
    if(!havekids || killed(p)){
    8000168e:	cf19                	beqz	a4,800016ac <wait+0xe4>
    80001690:	854a                	mv	a0,s2
    80001692:	f0dff0ef          	jal	8000159e <killed>
    80001696:	e919                	bnez	a0,800016ac <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001698:	85de                	mv	a1,s7
    8000169a:	854a                	mv	a0,s2
    8000169c:	ccbff0ef          	jal	80001366 <sleep>
    havekids = 0;
    800016a0:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016a2:	00009497          	auipc	s1,0x9
    800016a6:	38e48493          	addi	s1,s1,910 # 8000aa30 <proc>
    800016aa:	b7e1                	j	80001672 <wait+0xaa>
      release(&wait_lock);
    800016ac:	00009517          	auipc	a0,0x9
    800016b0:	f6c50513          	addi	a0,a0,-148 # 8000a618 <wait_lock>
    800016b4:	314040ef          	jal	800059c8 <release>
      return -1;
    800016b8:	59fd                	li	s3,-1
    800016ba:	b749                	j	8000163c <wait+0x74>

00000000800016bc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016bc:	7179                	addi	sp,sp,-48
    800016be:	f406                	sd	ra,40(sp)
    800016c0:	f022                	sd	s0,32(sp)
    800016c2:	ec26                	sd	s1,24(sp)
    800016c4:	e84a                	sd	s2,16(sp)
    800016c6:	e44e                	sd	s3,8(sp)
    800016c8:	e052                	sd	s4,0(sp)
    800016ca:	1800                	addi	s0,sp,48
    800016cc:	84aa                	mv	s1,a0
    800016ce:	892e                	mv	s2,a1
    800016d0:	89b2                	mv	s3,a2
    800016d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016d4:	eb8ff0ef          	jal	80000d8c <myproc>
  if(user_dst){
    800016d8:	cc99                	beqz	s1,800016f6 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016da:	86d2                	mv	a3,s4
    800016dc:	864e                	mv	a2,s3
    800016de:	85ca                	mv	a1,s2
    800016e0:	6928                	ld	a0,80(a0)
    800016e2:	b52ff0ef          	jal	80000a34 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016e6:	70a2                	ld	ra,40(sp)
    800016e8:	7402                	ld	s0,32(sp)
    800016ea:	64e2                	ld	s1,24(sp)
    800016ec:	6942                	ld	s2,16(sp)
    800016ee:	69a2                	ld	s3,8(sp)
    800016f0:	6a02                	ld	s4,0(sp)
    800016f2:	6145                	addi	sp,sp,48
    800016f4:	8082                	ret
    memmove((char *)dst, src, len);
    800016f6:	000a061b          	sext.w	a2,s4
    800016fa:	85ce                	mv	a1,s3
    800016fc:	854a                	mv	a0,s2
    800016fe:	addfe0ef          	jal	800001da <memmove>
    return 0;
    80001702:	8526                	mv	a0,s1
    80001704:	b7cd                	j	800016e6 <either_copyout+0x2a>

0000000080001706 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	e052                	sd	s4,0(sp)
    80001714:	1800                	addi	s0,sp,48
    80001716:	892a                	mv	s2,a0
    80001718:	84ae                	mv	s1,a1
    8000171a:	89b2                	mv	s3,a2
    8000171c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000171e:	e6eff0ef          	jal	80000d8c <myproc>
  if(user_src){
    80001722:	cc99                	beqz	s1,80001740 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001724:	86d2                	mv	a3,s4
    80001726:	864e                	mv	a2,s3
    80001728:	85ca                	mv	a1,s2
    8000172a:	6928                	ld	a0,80(a0)
    8000172c:	bb8ff0ef          	jal	80000ae4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001730:	70a2                	ld	ra,40(sp)
    80001732:	7402                	ld	s0,32(sp)
    80001734:	64e2                	ld	s1,24(sp)
    80001736:	6942                	ld	s2,16(sp)
    80001738:	69a2                	ld	s3,8(sp)
    8000173a:	6a02                	ld	s4,0(sp)
    8000173c:	6145                	addi	sp,sp,48
    8000173e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001740:	000a061b          	sext.w	a2,s4
    80001744:	85ce                	mv	a1,s3
    80001746:	854a                	mv	a0,s2
    80001748:	a93fe0ef          	jal	800001da <memmove>
    return 0;
    8000174c:	8526                	mv	a0,s1
    8000174e:	b7cd                	j	80001730 <either_copyin+0x2a>

0000000080001750 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001750:	715d                	addi	sp,sp,-80
    80001752:	e486                	sd	ra,72(sp)
    80001754:	e0a2                	sd	s0,64(sp)
    80001756:	fc26                	sd	s1,56(sp)
    80001758:	f84a                	sd	s2,48(sp)
    8000175a:	f44e                	sd	s3,40(sp)
    8000175c:	f052                	sd	s4,32(sp)
    8000175e:	ec56                	sd	s5,24(sp)
    80001760:	e85a                	sd	s6,16(sp)
    80001762:	e45e                	sd	s7,8(sp)
    80001764:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001766:	00006517          	auipc	a0,0x6
    8000176a:	8b250513          	addi	a0,a0,-1870 # 80007018 <etext+0x18>
    8000176e:	3c9030ef          	jal	80005336 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001772:	00009497          	auipc	s1,0x9
    80001776:	41648493          	addi	s1,s1,1046 # 8000ab88 <proc+0x158>
    8000177a:	0000f917          	auipc	s2,0xf
    8000177e:	00e90913          	addi	s2,s2,14 # 80010788 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001782:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001784:	00006997          	auipc	s3,0x6
    80001788:	acc98993          	addi	s3,s3,-1332 # 80007250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    8000178c:	00006a97          	auipc	s5,0x6
    80001790:	acca8a93          	addi	s5,s5,-1332 # 80007258 <etext+0x258>
    printf("\n");
    80001794:	00006a17          	auipc	s4,0x6
    80001798:	884a0a13          	addi	s4,s4,-1916 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000179c:	00006b97          	auipc	s7,0x6
    800017a0:	0bcb8b93          	addi	s7,s7,188 # 80007858 <states.0>
    800017a4:	a829                	j	800017be <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017a6:	ed86a583          	lw	a1,-296(a3)
    800017aa:	8556                	mv	a0,s5
    800017ac:	38b030ef          	jal	80005336 <printf>
    printf("\n");
    800017b0:	8552                	mv	a0,s4
    800017b2:	385030ef          	jal	80005336 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017b6:	17048493          	addi	s1,s1,368
    800017ba:	03248263          	beq	s1,s2,800017de <procdump+0x8e>
    if(p->state == UNUSED)
    800017be:	86a6                	mv	a3,s1
    800017c0:	ec04a783          	lw	a5,-320(s1)
    800017c4:	dbed                	beqz	a5,800017b6 <procdump+0x66>
      state = "???";
    800017c6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017c8:	fcfb6fe3          	bltu	s6,a5,800017a6 <procdump+0x56>
    800017cc:	02079713          	slli	a4,a5,0x20
    800017d0:	01d75793          	srli	a5,a4,0x1d
    800017d4:	97de                	add	a5,a5,s7
    800017d6:	6390                	ld	a2,0(a5)
    800017d8:	f679                	bnez	a2,800017a6 <procdump+0x56>
      state = "???";
    800017da:	864e                	mv	a2,s3
    800017dc:	b7e9                	j	800017a6 <procdump+0x56>
  }
}
    800017de:	60a6                	ld	ra,72(sp)
    800017e0:	6406                	ld	s0,64(sp)
    800017e2:	74e2                	ld	s1,56(sp)
    800017e4:	7942                	ld	s2,48(sp)
    800017e6:	79a2                	ld	s3,40(sp)
    800017e8:	7a02                	ld	s4,32(sp)
    800017ea:	6ae2                	ld	s5,24(sp)
    800017ec:	6b42                	ld	s6,16(sp)
    800017ee:	6ba2                	ld	s7,8(sp)
    800017f0:	6161                	addi	sp,sp,80
    800017f2:	8082                	ret

00000000800017f4 <nproc>:

// Get the number of processes whose state is not UNUSED. 
int
nproc(void)
{
    800017f4:	7179                	addi	sp,sp,-48
    800017f6:	f406                	sd	ra,40(sp)
    800017f8:	f022                	sd	s0,32(sp)
    800017fa:	ec26                	sd	s1,24(sp)
    800017fc:	e84a                	sd	s2,16(sp)
    800017fe:	e44e                	sd	s3,8(sp)
    80001800:	1800                	addi	s0,sp,48
  int n = 0;
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001802:	00009497          	auipc	s1,0x9
    80001806:	22e48493          	addi	s1,s1,558 # 8000aa30 <proc>
  int n = 0;
    8000180a:	4901                	li	s2,0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000180c:	0000f997          	auipc	s3,0xf
    80001810:	e2498993          	addi	s3,s3,-476 # 80010630 <tickslock>
    80001814:	a801                	j	80001824 <nproc+0x30>
    acquire(&p->lock);
    if(p->state != UNUSED)
      ++n;
    release(&p->lock);
    80001816:	8526                	mv	a0,s1
    80001818:	1b0040ef          	jal	800059c8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000181c:	17048493          	addi	s1,s1,368
    80001820:	01348963          	beq	s1,s3,80001832 <nproc+0x3e>
    acquire(&p->lock);
    80001824:	8526                	mv	a0,s1
    80001826:	10e040ef          	jal	80005934 <acquire>
    if(p->state != UNUSED)
    8000182a:	4c9c                	lw	a5,24(s1)
    8000182c:	d7ed                	beqz	a5,80001816 <nproc+0x22>
      ++n;
    8000182e:	2905                	addiw	s2,s2,1
    80001830:	b7dd                	j	80001816 <nproc+0x22>
  }

  return n;
}
    80001832:	854a                	mv	a0,s2
    80001834:	70a2                	ld	ra,40(sp)
    80001836:	7402                	ld	s0,32(sp)
    80001838:	64e2                	ld	s1,24(sp)
    8000183a:	6942                	ld	s2,16(sp)
    8000183c:	69a2                	ld	s3,8(sp)
    8000183e:	6145                	addi	sp,sp,48
    80001840:	8082                	ret

0000000080001842 <fileopencount_process>:

int
fileopencount_process(void)
{
    80001842:	1101                	addi	sp,sp,-32
    80001844:	ec06                	sd	ra,24(sp)
    80001846:	e822                	sd	s0,16(sp)
    80001848:	e426                	sd	s1,8(sp)
    8000184a:	e04a                	sd	s2,0(sp)
    8000184c:	1000                	addi	s0,sp,32
  struct proc *p = myproc(); // Get current process
    8000184e:	d3eff0ef          	jal	80000d8c <myproc>
    80001852:	892a                	mv	s2,a0
  int count = 0;
  int i;

  acquire(&p->lock); // Lock the process structure
    80001854:	0e0040ef          	jal	80005934 <acquire>
  for(i = 0; i < NOFILE; i++){
    80001858:	0d090793          	addi	a5,s2,208
    8000185c:	15090693          	addi	a3,s2,336
  int count = 0;
    80001860:	4481                	li	s1,0
    80001862:	a021                	j	8000186a <fileopencount_process+0x28>
  for(i = 0; i < NOFILE; i++){
    80001864:	07a1                	addi	a5,a5,8
    80001866:	00d78663          	beq	a5,a3,80001872 <fileopencount_process+0x30>
    if(p->ofile[i] != 0) // Check if the file descriptor is valid
    8000186a:	6398                	ld	a4,0(a5)
    8000186c:	df65                	beqz	a4,80001864 <fileopencount_process+0x22>
      count++;
    8000186e:	2485                	addiw	s1,s1,1
    80001870:	bfd5                	j	80001864 <fileopencount_process+0x22>
  }
  release(&p->lock); // Unlock the process structure
    80001872:	854a                	mv	a0,s2
    80001874:	154040ef          	jal	800059c8 <release>

  return count;
}
    80001878:	8526                	mv	a0,s1
    8000187a:	60e2                	ld	ra,24(sp)
    8000187c:	6442                	ld	s0,16(sp)
    8000187e:	64a2                	ld	s1,8(sp)
    80001880:	6902                	ld	s2,0(sp)
    80001882:	6105                	addi	sp,sp,32
    80001884:	8082                	ret

0000000080001886 <swtch>:
    80001886:	00153023          	sd	ra,0(a0)
    8000188a:	00253423          	sd	sp,8(a0)
    8000188e:	e900                	sd	s0,16(a0)
    80001890:	ed04                	sd	s1,24(a0)
    80001892:	03253023          	sd	s2,32(a0)
    80001896:	03353423          	sd	s3,40(a0)
    8000189a:	03453823          	sd	s4,48(a0)
    8000189e:	03553c23          	sd	s5,56(a0)
    800018a2:	05653023          	sd	s6,64(a0)
    800018a6:	05753423          	sd	s7,72(a0)
    800018aa:	05853823          	sd	s8,80(a0)
    800018ae:	05953c23          	sd	s9,88(a0)
    800018b2:	07a53023          	sd	s10,96(a0)
    800018b6:	07b53423          	sd	s11,104(a0)
    800018ba:	0005b083          	ld	ra,0(a1)
    800018be:	0085b103          	ld	sp,8(a1)
    800018c2:	6980                	ld	s0,16(a1)
    800018c4:	6d84                	ld	s1,24(a1)
    800018c6:	0205b903          	ld	s2,32(a1)
    800018ca:	0285b983          	ld	s3,40(a1)
    800018ce:	0305ba03          	ld	s4,48(a1)
    800018d2:	0385ba83          	ld	s5,56(a1)
    800018d6:	0405bb03          	ld	s6,64(a1)
    800018da:	0485bb83          	ld	s7,72(a1)
    800018de:	0505bc03          	ld	s8,80(a1)
    800018e2:	0585bc83          	ld	s9,88(a1)
    800018e6:	0605bd03          	ld	s10,96(a1)
    800018ea:	0685bd83          	ld	s11,104(a1)
    800018ee:	8082                	ret

00000000800018f0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018f0:	1141                	addi	sp,sp,-16
    800018f2:	e406                	sd	ra,8(sp)
    800018f4:	e022                	sd	s0,0(sp)
    800018f6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018f8:	00006597          	auipc	a1,0x6
    800018fc:	9a058593          	addi	a1,a1,-1632 # 80007298 <etext+0x298>
    80001900:	0000f517          	auipc	a0,0xf
    80001904:	d3050513          	addi	a0,a0,-720 # 80010630 <tickslock>
    80001908:	7a9030ef          	jal	800058b0 <initlock>
}
    8000190c:	60a2                	ld	ra,8(sp)
    8000190e:	6402                	ld	s0,0(sp)
    80001910:	0141                	addi	sp,sp,16
    80001912:	8082                	ret

0000000080001914 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001914:	1141                	addi	sp,sp,-16
    80001916:	e406                	sd	ra,8(sp)
    80001918:	e022                	sd	s0,0(sp)
    8000191a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000191c:	00003797          	auipc	a5,0x3
    80001920:	f8478793          	addi	a5,a5,-124 # 800048a0 <kernelvec>
    80001924:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001928:	60a2                	ld	ra,8(sp)
    8000192a:	6402                	ld	s0,0(sp)
    8000192c:	0141                	addi	sp,sp,16
    8000192e:	8082                	ret

0000000080001930 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001930:	1141                	addi	sp,sp,-16
    80001932:	e406                	sd	ra,8(sp)
    80001934:	e022                	sd	s0,0(sp)
    80001936:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001938:	c54ff0ef          	jal	80000d8c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000193c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001940:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001942:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001946:	00004697          	auipc	a3,0x4
    8000194a:	6ba68693          	addi	a3,a3,1722 # 80006000 <_trampoline>
    8000194e:	00004717          	auipc	a4,0x4
    80001952:	6b270713          	addi	a4,a4,1714 # 80006000 <_trampoline>
    80001956:	8f15                	sub	a4,a4,a3
    80001958:	040007b7          	lui	a5,0x4000
    8000195c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000195e:	07b2                	slli	a5,a5,0xc
    80001960:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001962:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001966:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001968:	18002673          	csrr	a2,satp
    8000196c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000196e:	6d30                	ld	a2,88(a0)
    80001970:	6138                	ld	a4,64(a0)
    80001972:	6585                	lui	a1,0x1
    80001974:	972e                	add	a4,a4,a1
    80001976:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001978:	6d38                	ld	a4,88(a0)
    8000197a:	00000617          	auipc	a2,0x0
    8000197e:	11060613          	addi	a2,a2,272 # 80001a8a <usertrap>
    80001982:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001984:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001986:	8612                	mv	a2,tp
    80001988:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000198a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000198e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001992:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001996:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000199a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000199c:	6f18                	ld	a4,24(a4)
    8000199e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800019a2:	6928                	ld	a0,80(a0)
    800019a4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019a6:	00004717          	auipc	a4,0x4
    800019aa:	6f670713          	addi	a4,a4,1782 # 8000609c <userret>
    800019ae:	8f15                	sub	a4,a4,a3
    800019b0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019b2:	577d                	li	a4,-1
    800019b4:	177e                	slli	a4,a4,0x3f
    800019b6:	8d59                	or	a0,a0,a4
    800019b8:	9782                	jalr	a5
}
    800019ba:	60a2                	ld	ra,8(sp)
    800019bc:	6402                	ld	s0,0(sp)
    800019be:	0141                	addi	sp,sp,16
    800019c0:	8082                	ret

00000000800019c2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800019c2:	1101                	addi	sp,sp,-32
    800019c4:	ec06                	sd	ra,24(sp)
    800019c6:	e822                	sd	s0,16(sp)
    800019c8:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800019ca:	b8eff0ef          	jal	80000d58 <cpuid>
    800019ce:	cd11                	beqz	a0,800019ea <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800019d0:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800019d4:	000f4737          	lui	a4,0xf4
    800019d8:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800019dc:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800019de:	14d79073          	csrw	stimecmp,a5
}
    800019e2:	60e2                	ld	ra,24(sp)
    800019e4:	6442                	ld	s0,16(sp)
    800019e6:	6105                	addi	sp,sp,32
    800019e8:	8082                	ret
    800019ea:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800019ec:	0000f497          	auipc	s1,0xf
    800019f0:	c4448493          	addi	s1,s1,-956 # 80010630 <tickslock>
    800019f4:	8526                	mv	a0,s1
    800019f6:	73f030ef          	jal	80005934 <acquire>
    ticks++;
    800019fa:	00009517          	auipc	a0,0x9
    800019fe:	bce50513          	addi	a0,a0,-1074 # 8000a5c8 <ticks>
    80001a02:	411c                	lw	a5,0(a0)
    80001a04:	2785                	addiw	a5,a5,1
    80001a06:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001a08:	9abff0ef          	jal	800013b2 <wakeup>
    release(&tickslock);
    80001a0c:	8526                	mv	a0,s1
    80001a0e:	7bb030ef          	jal	800059c8 <release>
    80001a12:	64a2                	ld	s1,8(sp)
    80001a14:	bf75                	j	800019d0 <clockintr+0xe>

0000000080001a16 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a16:	1101                	addi	sp,sp,-32
    80001a18:	ec06                	sd	ra,24(sp)
    80001a1a:	e822                	sd	s0,16(sp)
    80001a1c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a1e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001a22:	57fd                	li	a5,-1
    80001a24:	17fe                	slli	a5,a5,0x3f
    80001a26:	07a5                	addi	a5,a5,9
    80001a28:	00f70c63          	beq	a4,a5,80001a40 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a2c:	57fd                	li	a5,-1
    80001a2e:	17fe                	slli	a5,a5,0x3f
    80001a30:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a32:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a34:	04f70763          	beq	a4,a5,80001a82 <devintr+0x6c>
  }
}
    80001a38:	60e2                	ld	ra,24(sp)
    80001a3a:	6442                	ld	s0,16(sp)
    80001a3c:	6105                	addi	sp,sp,32
    80001a3e:	8082                	ret
    80001a40:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a42:	70b020ef          	jal	8000494c <plic_claim>
    80001a46:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a48:	47a9                	li	a5,10
    80001a4a:	00f50963          	beq	a0,a5,80001a5c <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a4e:	4785                	li	a5,1
    80001a50:	00f50963          	beq	a0,a5,80001a62 <devintr+0x4c>
    return 1;
    80001a54:	4505                	li	a0,1
    } else if(irq){
    80001a56:	e889                	bnez	s1,80001a68 <devintr+0x52>
    80001a58:	64a2                	ld	s1,8(sp)
    80001a5a:	bff9                	j	80001a38 <devintr+0x22>
      uartintr();
    80001a5c:	619030ef          	jal	80005874 <uartintr>
    if(irq)
    80001a60:	a819                	j	80001a76 <devintr+0x60>
      virtio_disk_intr();
    80001a62:	37a030ef          	jal	80004ddc <virtio_disk_intr>
    if(irq)
    80001a66:	a801                	j	80001a76 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a68:	85a6                	mv	a1,s1
    80001a6a:	00006517          	auipc	a0,0x6
    80001a6e:	83650513          	addi	a0,a0,-1994 # 800072a0 <etext+0x2a0>
    80001a72:	0c5030ef          	jal	80005336 <printf>
      plic_complete(irq);
    80001a76:	8526                	mv	a0,s1
    80001a78:	6f5020ef          	jal	8000496c <plic_complete>
    return 1;
    80001a7c:	4505                	li	a0,1
    80001a7e:	64a2                	ld	s1,8(sp)
    80001a80:	bf65                	j	80001a38 <devintr+0x22>
    clockintr();
    80001a82:	f41ff0ef          	jal	800019c2 <clockintr>
    return 2;
    80001a86:	4509                	li	a0,2
    80001a88:	bf45                	j	80001a38 <devintr+0x22>

0000000080001a8a <usertrap>:
{
    80001a8a:	1101                	addi	sp,sp,-32
    80001a8c:	ec06                	sd	ra,24(sp)
    80001a8e:	e822                	sd	s0,16(sp)
    80001a90:	e426                	sd	s1,8(sp)
    80001a92:	e04a                	sd	s2,0(sp)
    80001a94:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a96:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a9a:	1007f793          	andi	a5,a5,256
    80001a9e:	ef85                	bnez	a5,80001ad6 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa0:	00003797          	auipc	a5,0x3
    80001aa4:	e0078793          	addi	a5,a5,-512 # 800048a0 <kernelvec>
    80001aa8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001aac:	ae0ff0ef          	jal	80000d8c <myproc>
    80001ab0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ab2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ab4:	14102773          	csrr	a4,sepc
    80001ab8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aba:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001abe:	47a1                	li	a5,8
    80001ac0:	02f70163          	beq	a4,a5,80001ae2 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001ac4:	f53ff0ef          	jal	80001a16 <devintr>
    80001ac8:	892a                	mv	s2,a0
    80001aca:	c135                	beqz	a0,80001b2e <usertrap+0xa4>
  if(killed(p))
    80001acc:	8526                	mv	a0,s1
    80001ace:	ad1ff0ef          	jal	8000159e <killed>
    80001ad2:	cd1d                	beqz	a0,80001b10 <usertrap+0x86>
    80001ad4:	a81d                	j	80001b0a <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001ad6:	00005517          	auipc	a0,0x5
    80001ada:	7ea50513          	addi	a0,a0,2026 # 800072c0 <etext+0x2c0>
    80001ade:	329030ef          	jal	80005606 <panic>
    if(killed(p))
    80001ae2:	abdff0ef          	jal	8000159e <killed>
    80001ae6:	e121                	bnez	a0,80001b26 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001ae8:	6cb8                	ld	a4,88(s1)
    80001aea:	6f1c                	ld	a5,24(a4)
    80001aec:	0791                	addi	a5,a5,4
    80001aee:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001af0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001af4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001af8:	10079073          	csrw	sstatus,a5
    syscall();
    80001afc:	240000ef          	jal	80001d3c <syscall>
  if(killed(p))
    80001b00:	8526                	mv	a0,s1
    80001b02:	a9dff0ef          	jal	8000159e <killed>
    80001b06:	c901                	beqz	a0,80001b16 <usertrap+0x8c>
    80001b08:	4901                	li	s2,0
    exit(-1);
    80001b0a:	557d                	li	a0,-1
    80001b0c:	967ff0ef          	jal	80001472 <exit>
  if(which_dev == 2)
    80001b10:	4789                	li	a5,2
    80001b12:	04f90563          	beq	s2,a5,80001b5c <usertrap+0xd2>
  usertrapret();
    80001b16:	e1bff0ef          	jal	80001930 <usertrapret>
}
    80001b1a:	60e2                	ld	ra,24(sp)
    80001b1c:	6442                	ld	s0,16(sp)
    80001b1e:	64a2                	ld	s1,8(sp)
    80001b20:	6902                	ld	s2,0(sp)
    80001b22:	6105                	addi	sp,sp,32
    80001b24:	8082                	ret
      exit(-1);
    80001b26:	557d                	li	a0,-1
    80001b28:	94bff0ef          	jal	80001472 <exit>
    80001b2c:	bf75                	j	80001ae8 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b2e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b32:	5890                	lw	a2,48(s1)
    80001b34:	00005517          	auipc	a0,0x5
    80001b38:	7ac50513          	addi	a0,a0,1964 # 800072e0 <etext+0x2e0>
    80001b3c:	7fa030ef          	jal	80005336 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b40:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b44:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b48:	00005517          	auipc	a0,0x5
    80001b4c:	7c850513          	addi	a0,a0,1992 # 80007310 <etext+0x310>
    80001b50:	7e6030ef          	jal	80005336 <printf>
    setkilled(p);
    80001b54:	8526                	mv	a0,s1
    80001b56:	a25ff0ef          	jal	8000157a <setkilled>
    80001b5a:	b75d                	j	80001b00 <usertrap+0x76>
    yield();
    80001b5c:	fdeff0ef          	jal	8000133a <yield>
    80001b60:	bf5d                	j	80001b16 <usertrap+0x8c>

0000000080001b62 <kerneltrap>:
{
    80001b62:	7179                	addi	sp,sp,-48
    80001b64:	f406                	sd	ra,40(sp)
    80001b66:	f022                	sd	s0,32(sp)
    80001b68:	ec26                	sd	s1,24(sp)
    80001b6a:	e84a                	sd	s2,16(sp)
    80001b6c:	e44e                	sd	s3,8(sp)
    80001b6e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b70:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b74:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b78:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b7c:	1004f793          	andi	a5,s1,256
    80001b80:	c795                	beqz	a5,80001bac <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b82:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b86:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b88:	eb85                	bnez	a5,80001bb8 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b8a:	e8dff0ef          	jal	80001a16 <devintr>
    80001b8e:	c91d                	beqz	a0,80001bc4 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b90:	4789                	li	a5,2
    80001b92:	04f50a63          	beq	a0,a5,80001be6 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b96:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b9a:	10049073          	csrw	sstatus,s1
}
    80001b9e:	70a2                	ld	ra,40(sp)
    80001ba0:	7402                	ld	s0,32(sp)
    80001ba2:	64e2                	ld	s1,24(sp)
    80001ba4:	6942                	ld	s2,16(sp)
    80001ba6:	69a2                	ld	s3,8(sp)
    80001ba8:	6145                	addi	sp,sp,48
    80001baa:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001bac:	00005517          	auipc	a0,0x5
    80001bb0:	78c50513          	addi	a0,a0,1932 # 80007338 <etext+0x338>
    80001bb4:	253030ef          	jal	80005606 <panic>
    panic("kerneltrap: interrupts enabled");
    80001bb8:	00005517          	auipc	a0,0x5
    80001bbc:	7a850513          	addi	a0,a0,1960 # 80007360 <etext+0x360>
    80001bc0:	247030ef          	jal	80005606 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bc4:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001bc8:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001bcc:	85ce                	mv	a1,s3
    80001bce:	00005517          	auipc	a0,0x5
    80001bd2:	7b250513          	addi	a0,a0,1970 # 80007380 <etext+0x380>
    80001bd6:	760030ef          	jal	80005336 <printf>
    panic("kerneltrap");
    80001bda:	00005517          	auipc	a0,0x5
    80001bde:	7ce50513          	addi	a0,a0,1998 # 800073a8 <etext+0x3a8>
    80001be2:	225030ef          	jal	80005606 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001be6:	9a6ff0ef          	jal	80000d8c <myproc>
    80001bea:	d555                	beqz	a0,80001b96 <kerneltrap+0x34>
    yield();
    80001bec:	f4eff0ef          	jal	8000133a <yield>
    80001bf0:	b75d                	j	80001b96 <kerneltrap+0x34>

0000000080001bf2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bf2:	1101                	addi	sp,sp,-32
    80001bf4:	ec06                	sd	ra,24(sp)
    80001bf6:	e822                	sd	s0,16(sp)
    80001bf8:	e426                	sd	s1,8(sp)
    80001bfa:	1000                	addi	s0,sp,32
    80001bfc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bfe:	98eff0ef          	jal	80000d8c <myproc>
  switch (n) {
    80001c02:	4795                	li	a5,5
    80001c04:	0497e163          	bltu	a5,s1,80001c46 <argraw+0x54>
    80001c08:	048a                	slli	s1,s1,0x2
    80001c0a:	00006717          	auipc	a4,0x6
    80001c0e:	c7e70713          	addi	a4,a4,-898 # 80007888 <states.0+0x30>
    80001c12:	94ba                	add	s1,s1,a4
    80001c14:	409c                	lw	a5,0(s1)
    80001c16:	97ba                	add	a5,a5,a4
    80001c18:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c1a:	6d3c                	ld	a5,88(a0)
    80001c1c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c1e:	60e2                	ld	ra,24(sp)
    80001c20:	6442                	ld	s0,16(sp)
    80001c22:	64a2                	ld	s1,8(sp)
    80001c24:	6105                	addi	sp,sp,32
    80001c26:	8082                	ret
    return p->trapframe->a1;
    80001c28:	6d3c                	ld	a5,88(a0)
    80001c2a:	7fa8                	ld	a0,120(a5)
    80001c2c:	bfcd                	j	80001c1e <argraw+0x2c>
    return p->trapframe->a2;
    80001c2e:	6d3c                	ld	a5,88(a0)
    80001c30:	63c8                	ld	a0,128(a5)
    80001c32:	b7f5                	j	80001c1e <argraw+0x2c>
    return p->trapframe->a3;
    80001c34:	6d3c                	ld	a5,88(a0)
    80001c36:	67c8                	ld	a0,136(a5)
    80001c38:	b7dd                	j	80001c1e <argraw+0x2c>
    return p->trapframe->a4;
    80001c3a:	6d3c                	ld	a5,88(a0)
    80001c3c:	6bc8                	ld	a0,144(a5)
    80001c3e:	b7c5                	j	80001c1e <argraw+0x2c>
    return p->trapframe->a5;
    80001c40:	6d3c                	ld	a5,88(a0)
    80001c42:	6fc8                	ld	a0,152(a5)
    80001c44:	bfe9                	j	80001c1e <argraw+0x2c>
  panic("argraw");
    80001c46:	00005517          	auipc	a0,0x5
    80001c4a:	77250513          	addi	a0,a0,1906 # 800073b8 <etext+0x3b8>
    80001c4e:	1b9030ef          	jal	80005606 <panic>

0000000080001c52 <fetchaddr>:
{
    80001c52:	1101                	addi	sp,sp,-32
    80001c54:	ec06                	sd	ra,24(sp)
    80001c56:	e822                	sd	s0,16(sp)
    80001c58:	e426                	sd	s1,8(sp)
    80001c5a:	e04a                	sd	s2,0(sp)
    80001c5c:	1000                	addi	s0,sp,32
    80001c5e:	84aa                	mv	s1,a0
    80001c60:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c62:	92aff0ef          	jal	80000d8c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c66:	653c                	ld	a5,72(a0)
    80001c68:	02f4f663          	bgeu	s1,a5,80001c94 <fetchaddr+0x42>
    80001c6c:	00848713          	addi	a4,s1,8
    80001c70:	02e7e463          	bltu	a5,a4,80001c98 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c74:	46a1                	li	a3,8
    80001c76:	8626                	mv	a2,s1
    80001c78:	85ca                	mv	a1,s2
    80001c7a:	6928                	ld	a0,80(a0)
    80001c7c:	e69fe0ef          	jal	80000ae4 <copyin>
    80001c80:	00a03533          	snez	a0,a0
    80001c84:	40a0053b          	negw	a0,a0
}
    80001c88:	60e2                	ld	ra,24(sp)
    80001c8a:	6442                	ld	s0,16(sp)
    80001c8c:	64a2                	ld	s1,8(sp)
    80001c8e:	6902                	ld	s2,0(sp)
    80001c90:	6105                	addi	sp,sp,32
    80001c92:	8082                	ret
    return -1;
    80001c94:	557d                	li	a0,-1
    80001c96:	bfcd                	j	80001c88 <fetchaddr+0x36>
    80001c98:	557d                	li	a0,-1
    80001c9a:	b7fd                	j	80001c88 <fetchaddr+0x36>

0000000080001c9c <fetchstr>:
{
    80001c9c:	7179                	addi	sp,sp,-48
    80001c9e:	f406                	sd	ra,40(sp)
    80001ca0:	f022                	sd	s0,32(sp)
    80001ca2:	ec26                	sd	s1,24(sp)
    80001ca4:	e84a                	sd	s2,16(sp)
    80001ca6:	e44e                	sd	s3,8(sp)
    80001ca8:	1800                	addi	s0,sp,48
    80001caa:	892a                	mv	s2,a0
    80001cac:	84ae                	mv	s1,a1
    80001cae:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001cb0:	8dcff0ef          	jal	80000d8c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001cb4:	86ce                	mv	a3,s3
    80001cb6:	864a                	mv	a2,s2
    80001cb8:	85a6                	mv	a1,s1
    80001cba:	6928                	ld	a0,80(a0)
    80001cbc:	eaffe0ef          	jal	80000b6a <copyinstr>
    80001cc0:	00054c63          	bltz	a0,80001cd8 <fetchstr+0x3c>
  return strlen(buf);
    80001cc4:	8526                	mv	a0,s1
    80001cc6:	e38fe0ef          	jal	800002fe <strlen>
}
    80001cca:	70a2                	ld	ra,40(sp)
    80001ccc:	7402                	ld	s0,32(sp)
    80001cce:	64e2                	ld	s1,24(sp)
    80001cd0:	6942                	ld	s2,16(sp)
    80001cd2:	69a2                	ld	s3,8(sp)
    80001cd4:	6145                	addi	sp,sp,48
    80001cd6:	8082                	ret
    return -1;
    80001cd8:	557d                	li	a0,-1
    80001cda:	bfc5                	j	80001cca <fetchstr+0x2e>

0000000080001cdc <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001cdc:	1101                	addi	sp,sp,-32
    80001cde:	ec06                	sd	ra,24(sp)
    80001ce0:	e822                	sd	s0,16(sp)
    80001ce2:	e426                	sd	s1,8(sp)
    80001ce4:	1000                	addi	s0,sp,32
    80001ce6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ce8:	f0bff0ef          	jal	80001bf2 <argraw>
    80001cec:	c088                	sw	a0,0(s1)
}
    80001cee:	60e2                	ld	ra,24(sp)
    80001cf0:	6442                	ld	s0,16(sp)
    80001cf2:	64a2                	ld	s1,8(sp)
    80001cf4:	6105                	addi	sp,sp,32
    80001cf6:	8082                	ret

0000000080001cf8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cf8:	1101                	addi	sp,sp,-32
    80001cfa:	ec06                	sd	ra,24(sp)
    80001cfc:	e822                	sd	s0,16(sp)
    80001cfe:	e426                	sd	s1,8(sp)
    80001d00:	1000                	addi	s0,sp,32
    80001d02:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d04:	eefff0ef          	jal	80001bf2 <argraw>
    80001d08:	e088                	sd	a0,0(s1)
}
    80001d0a:	60e2                	ld	ra,24(sp)
    80001d0c:	6442                	ld	s0,16(sp)
    80001d0e:	64a2                	ld	s1,8(sp)
    80001d10:	6105                	addi	sp,sp,32
    80001d12:	8082                	ret

0000000080001d14 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d14:	1101                	addi	sp,sp,-32
    80001d16:	ec06                	sd	ra,24(sp)
    80001d18:	e822                	sd	s0,16(sp)
    80001d1a:	e426                	sd	s1,8(sp)
    80001d1c:	e04a                	sd	s2,0(sp)
    80001d1e:	1000                	addi	s0,sp,32
    80001d20:	84ae                	mv	s1,a1
    80001d22:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001d24:	ecfff0ef          	jal	80001bf2 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001d28:	864a                	mv	a2,s2
    80001d2a:	85a6                	mv	a1,s1
    80001d2c:	f71ff0ef          	jal	80001c9c <fetchstr>
}
    80001d30:	60e2                	ld	ra,24(sp)
    80001d32:	6442                	ld	s0,16(sp)
    80001d34:	64a2                	ld	s1,8(sp)
    80001d36:	6902                	ld	s2,0(sp)
    80001d38:	6105                	addi	sp,sp,32
    80001d3a:	8082                	ret

0000000080001d3c <syscall>:
};


void
syscall(void)
{
    80001d3c:	7179                	addi	sp,sp,-48
    80001d3e:	f406                	sd	ra,40(sp)
    80001d40:	f022                	sd	s0,32(sp)
    80001d42:	ec26                	sd	s1,24(sp)
    80001d44:	e84a                	sd	s2,16(sp)
    80001d46:	e44e                	sd	s3,8(sp)
    80001d48:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001d4a:	842ff0ef          	jal	80000d8c <myproc>
    80001d4e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d50:	05853983          	ld	s3,88(a0)
    80001d54:	0a89b783          	ld	a5,168(s3)
    80001d58:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d5c:	37fd                	addiw	a5,a5,-1
    80001d5e:	475d                	li	a4,23
    80001d60:	00f76f63          	bltu	a4,a5,80001d7e <syscall+0x42>
    80001d64:	00391713          	slli	a4,s2,0x3
    80001d68:	00006797          	auipc	a5,0x6
    80001d6c:	b3878793          	addi	a5,a5,-1224 # 800078a0 <syscalls>
    80001d70:	97ba                	add	a5,a5,a4
    80001d72:	639c                	ld	a5,0(a5)
    80001d74:	c789                	beqz	a5,80001d7e <syscall+0x42>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d76:	9782                	jalr	a5
    80001d78:	06a9b823          	sd	a0,112(s3)
    80001d7c:	a831                	j	80001d98 <syscall+0x5c>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d7e:	86ca                	mv	a3,s2
    80001d80:	15848613          	addi	a2,s1,344
    80001d84:	588c                	lw	a1,48(s1)
    80001d86:	00005517          	auipc	a0,0x5
    80001d8a:	63a50513          	addi	a0,a0,1594 # 800073c0 <etext+0x3c0>
    80001d8e:	5a8030ef          	jal	80005336 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d92:	6cbc                	ld	a5,88(s1)
    80001d94:	577d                	li	a4,-1
    80001d96:	fbb8                	sd	a4,112(a5)
  }

  if (p->trace_mask & (1 << num))
    80001d98:	1684a783          	lw	a5,360(s1)
    80001d9c:	4127d7bb          	sraw	a5,a5,s2
    80001da0:	8b85                	andi	a5,a5,1
    80001da2:	eb81                	bnez	a5,80001db2 <syscall+0x76>
    printf("%d: syscall %s -> %lu\n", p->pid, sys_name[num], p->trapframe->a0);
}
    80001da4:	70a2                	ld	ra,40(sp)
    80001da6:	7402                	ld	s0,32(sp)
    80001da8:	64e2                	ld	s1,24(sp)
    80001daa:	6942                	ld	s2,16(sp)
    80001dac:	69a2                	ld	s3,8(sp)
    80001dae:	6145                	addi	sp,sp,48
    80001db0:	8082                	ret
    printf("%d: syscall %s -> %lu\n", p->pid, sys_name[num], p->trapframe->a0);
    80001db2:	6cb8                	ld	a4,88(s1)
    80001db4:	090e                	slli	s2,s2,0x3
    80001db6:	00006797          	auipc	a5,0x6
    80001dba:	aea78793          	addi	a5,a5,-1302 # 800078a0 <syscalls>
    80001dbe:	97ca                	add	a5,a5,s2
    80001dc0:	7b34                	ld	a3,112(a4)
    80001dc2:	67f0                	ld	a2,200(a5)
    80001dc4:	588c                	lw	a1,48(s1)
    80001dc6:	00005517          	auipc	a0,0x5
    80001dca:	61a50513          	addi	a0,a0,1562 # 800073e0 <etext+0x3e0>
    80001dce:	568030ef          	jal	80005336 <printf>
}
    80001dd2:	bfc9                	j	80001da4 <syscall+0x68>

0000000080001dd4 <sys_exit>:

struct sysinfo;

uint64
sys_exit(void)
{
    80001dd4:	1101                	addi	sp,sp,-32
    80001dd6:	ec06                	sd	ra,24(sp)
    80001dd8:	e822                	sd	s0,16(sp)
    80001dda:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001ddc:	fec40593          	addi	a1,s0,-20
    80001de0:	4501                	li	a0,0
    80001de2:	efbff0ef          	jal	80001cdc <argint>
  exit(n);
    80001de6:	fec42503          	lw	a0,-20(s0)
    80001dea:	e88ff0ef          	jal	80001472 <exit>
  return 0;  // not reached
}
    80001dee:	4501                	li	a0,0
    80001df0:	60e2                	ld	ra,24(sp)
    80001df2:	6442                	ld	s0,16(sp)
    80001df4:	6105                	addi	sp,sp,32
    80001df6:	8082                	ret

0000000080001df8 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001df8:	1141                	addi	sp,sp,-16
    80001dfa:	e406                	sd	ra,8(sp)
    80001dfc:	e022                	sd	s0,0(sp)
    80001dfe:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001e00:	f8dfe0ef          	jal	80000d8c <myproc>
}
    80001e04:	5908                	lw	a0,48(a0)
    80001e06:	60a2                	ld	ra,8(sp)
    80001e08:	6402                	ld	s0,0(sp)
    80001e0a:	0141                	addi	sp,sp,16
    80001e0c:	8082                	ret

0000000080001e0e <sys_fork>:

uint64
sys_fork(void)
{
    80001e0e:	1141                	addi	sp,sp,-16
    80001e10:	e406                	sd	ra,8(sp)
    80001e12:	e022                	sd	s0,0(sp)
    80001e14:	0800                	addi	s0,sp,16
  return fork();
    80001e16:	aa0ff0ef          	jal	800010b6 <fork>
}
    80001e1a:	60a2                	ld	ra,8(sp)
    80001e1c:	6402                	ld	s0,0(sp)
    80001e1e:	0141                	addi	sp,sp,16
    80001e20:	8082                	ret

0000000080001e22 <sys_wait>:

uint64
sys_wait(void)
{
    80001e22:	1101                	addi	sp,sp,-32
    80001e24:	ec06                	sd	ra,24(sp)
    80001e26:	e822                	sd	s0,16(sp)
    80001e28:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e2a:	fe840593          	addi	a1,s0,-24
    80001e2e:	4501                	li	a0,0
    80001e30:	ec9ff0ef          	jal	80001cf8 <argaddr>
  return wait(p);
    80001e34:	fe843503          	ld	a0,-24(s0)
    80001e38:	f90ff0ef          	jal	800015c8 <wait>
}
    80001e3c:	60e2                	ld	ra,24(sp)
    80001e3e:	6442                	ld	s0,16(sp)
    80001e40:	6105                	addi	sp,sp,32
    80001e42:	8082                	ret

0000000080001e44 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e44:	7179                	addi	sp,sp,-48
    80001e46:	f406                	sd	ra,40(sp)
    80001e48:	f022                	sd	s0,32(sp)
    80001e4a:	ec26                	sd	s1,24(sp)
    80001e4c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e4e:	fdc40593          	addi	a1,s0,-36
    80001e52:	4501                	li	a0,0
    80001e54:	e89ff0ef          	jal	80001cdc <argint>
  addr = myproc()->sz;
    80001e58:	f35fe0ef          	jal	80000d8c <myproc>
    80001e5c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e5e:	fdc42503          	lw	a0,-36(s0)
    80001e62:	a04ff0ef          	jal	80001066 <growproc>
    80001e66:	00054863          	bltz	a0,80001e76 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e6a:	8526                	mv	a0,s1
    80001e6c:	70a2                	ld	ra,40(sp)
    80001e6e:	7402                	ld	s0,32(sp)
    80001e70:	64e2                	ld	s1,24(sp)
    80001e72:	6145                	addi	sp,sp,48
    80001e74:	8082                	ret
    return -1;
    80001e76:	54fd                	li	s1,-1
    80001e78:	bfcd                	j	80001e6a <sys_sbrk+0x26>

0000000080001e7a <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e7a:	7139                	addi	sp,sp,-64
    80001e7c:	fc06                	sd	ra,56(sp)
    80001e7e:	f822                	sd	s0,48(sp)
    80001e80:	f04a                	sd	s2,32(sp)
    80001e82:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e84:	fcc40593          	addi	a1,s0,-52
    80001e88:	4501                	li	a0,0
    80001e8a:	e53ff0ef          	jal	80001cdc <argint>
  if(n < 0)
    80001e8e:	fcc42783          	lw	a5,-52(s0)
    80001e92:	0607c763          	bltz	a5,80001f00 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e96:	0000e517          	auipc	a0,0xe
    80001e9a:	79a50513          	addi	a0,a0,1946 # 80010630 <tickslock>
    80001e9e:	297030ef          	jal	80005934 <acquire>
  ticks0 = ticks;
    80001ea2:	00008917          	auipc	s2,0x8
    80001ea6:	72692903          	lw	s2,1830(s2) # 8000a5c8 <ticks>
  while(ticks - ticks0 < n){
    80001eaa:	fcc42783          	lw	a5,-52(s0)
    80001eae:	cf8d                	beqz	a5,80001ee8 <sys_sleep+0x6e>
    80001eb0:	f426                	sd	s1,40(sp)
    80001eb2:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001eb4:	0000e997          	auipc	s3,0xe
    80001eb8:	77c98993          	addi	s3,s3,1916 # 80010630 <tickslock>
    80001ebc:	00008497          	auipc	s1,0x8
    80001ec0:	70c48493          	addi	s1,s1,1804 # 8000a5c8 <ticks>
    if(killed(myproc())){
    80001ec4:	ec9fe0ef          	jal	80000d8c <myproc>
    80001ec8:	ed6ff0ef          	jal	8000159e <killed>
    80001ecc:	ed0d                	bnez	a0,80001f06 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001ece:	85ce                	mv	a1,s3
    80001ed0:	8526                	mv	a0,s1
    80001ed2:	c94ff0ef          	jal	80001366 <sleep>
  while(ticks - ticks0 < n){
    80001ed6:	409c                	lw	a5,0(s1)
    80001ed8:	412787bb          	subw	a5,a5,s2
    80001edc:	fcc42703          	lw	a4,-52(s0)
    80001ee0:	fee7e2e3          	bltu	a5,a4,80001ec4 <sys_sleep+0x4a>
    80001ee4:	74a2                	ld	s1,40(sp)
    80001ee6:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ee8:	0000e517          	auipc	a0,0xe
    80001eec:	74850513          	addi	a0,a0,1864 # 80010630 <tickslock>
    80001ef0:	2d9030ef          	jal	800059c8 <release>
  return 0;
    80001ef4:	4501                	li	a0,0
}
    80001ef6:	70e2                	ld	ra,56(sp)
    80001ef8:	7442                	ld	s0,48(sp)
    80001efa:	7902                	ld	s2,32(sp)
    80001efc:	6121                	addi	sp,sp,64
    80001efe:	8082                	ret
    n = 0;
    80001f00:	fc042623          	sw	zero,-52(s0)
    80001f04:	bf49                	j	80001e96 <sys_sleep+0x1c>
      release(&tickslock);
    80001f06:	0000e517          	auipc	a0,0xe
    80001f0a:	72a50513          	addi	a0,a0,1834 # 80010630 <tickslock>
    80001f0e:	2bb030ef          	jal	800059c8 <release>
      return -1;
    80001f12:	557d                	li	a0,-1
    80001f14:	74a2                	ld	s1,40(sp)
    80001f16:	69e2                	ld	s3,24(sp)
    80001f18:	bff9                	j	80001ef6 <sys_sleep+0x7c>

0000000080001f1a <sys_kill>:

uint64
sys_kill(void)
{
    80001f1a:	1101                	addi	sp,sp,-32
    80001f1c:	ec06                	sd	ra,24(sp)
    80001f1e:	e822                	sd	s0,16(sp)
    80001f20:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f22:	fec40593          	addi	a1,s0,-20
    80001f26:	4501                	li	a0,0
    80001f28:	db5ff0ef          	jal	80001cdc <argint>
  return kill(pid);
    80001f2c:	fec42503          	lw	a0,-20(s0)
    80001f30:	de4ff0ef          	jal	80001514 <kill>
}
    80001f34:	60e2                	ld	ra,24(sp)
    80001f36:	6442                	ld	s0,16(sp)
    80001f38:	6105                	addi	sp,sp,32
    80001f3a:	8082                	ret

0000000080001f3c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f3c:	1101                	addi	sp,sp,-32
    80001f3e:	ec06                	sd	ra,24(sp)
    80001f40:	e822                	sd	s0,16(sp)
    80001f42:	e426                	sd	s1,8(sp)
    80001f44:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f46:	0000e517          	auipc	a0,0xe
    80001f4a:	6ea50513          	addi	a0,a0,1770 # 80010630 <tickslock>
    80001f4e:	1e7030ef          	jal	80005934 <acquire>
  xticks = ticks;
    80001f52:	00008497          	auipc	s1,0x8
    80001f56:	6764a483          	lw	s1,1654(s1) # 8000a5c8 <ticks>
  release(&tickslock);
    80001f5a:	0000e517          	auipc	a0,0xe
    80001f5e:	6d650513          	addi	a0,a0,1750 # 80010630 <tickslock>
    80001f62:	267030ef          	jal	800059c8 <release>
  return xticks;
}
    80001f66:	02049513          	slli	a0,s1,0x20
    80001f6a:	9101                	srli	a0,a0,0x20
    80001f6c:	60e2                	ld	ra,24(sp)
    80001f6e:	6442                	ld	s0,16(sp)
    80001f70:	64a2                	ld	s1,8(sp)
    80001f72:	6105                	addi	sp,sp,32
    80001f74:	8082                	ret

0000000080001f76 <sys_hello>:

uint64 sys_hello(void) {
    80001f76:	1141                	addi	sp,sp,-16
    80001f78:	e406                	sd	ra,8(sp)
    80001f7a:	e022                	sd	s0,0(sp)
    80001f7c:	0800                	addi	s0,sp,16
  printf("Hello, world! \n");
    80001f7e:	00005517          	auipc	a0,0x5
    80001f82:	53250513          	addi	a0,a0,1330 # 800074b0 <etext+0x4b0>
    80001f86:	3b0030ef          	jal	80005336 <printf>
  return 0;
}
    80001f8a:	4501                	li	a0,0
    80001f8c:	60a2                	ld	ra,8(sp)
    80001f8e:	6402                	ld	s0,0(sp)
    80001f90:	0141                	addi	sp,sp,16
    80001f92:	8082                	ret

0000000080001f94 <sys_trace>:

uint64 sys_trace(void) {
    80001f94:	1101                	addi	sp,sp,-32
    80001f96:	ec06                	sd	ra,24(sp)
    80001f98:	e822                	sd	s0,16(sp)
    80001f9a:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80001f9c:	fec40593          	addi	a1,s0,-20
    80001fa0:	4501                	li	a0,0
    80001fa2:	d3bff0ef          	jal	80001cdc <argint>

  if (mask < 0) return -1;
    80001fa6:	fec42783          	lw	a5,-20(s0)
    80001faa:	557d                	li	a0,-1
    80001fac:	0007c963          	bltz	a5,80001fbe <sys_trace+0x2a>
  myproc()->trace_mask = mask;
    80001fb0:	dddfe0ef          	jal	80000d8c <myproc>
    80001fb4:	fec42783          	lw	a5,-20(s0)
    80001fb8:	16f52423          	sw	a5,360(a0)
  return 0;
    80001fbc:	4501                	li	a0,0
}
    80001fbe:	60e2                	ld	ra,24(sp)
    80001fc0:	6442                	ld	s0,16(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret

0000000080001fc6 <sysinfo>:


int
sysinfo(uint64 addr) {
    80001fc6:	7179                	addi	sp,sp,-48
    80001fc8:	f406                	sd	ra,40(sp)
    80001fca:	f022                	sd	s0,32(sp)
    80001fcc:	ec26                	sd	s1,24(sp)
    80001fce:	e84a                	sd	s2,16(sp)
    80001fd0:	1800                	addi	s0,sp,48
    80001fd2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001fd4:	db9fe0ef          	jal	80000d8c <myproc>
    80001fd8:	84aa                	mv	s1,a0
  struct sysinfo info;

  info.freemem = freemem();
    80001fda:	95afe0ef          	jal	80000134 <freemem>
    80001fde:	fca42823          	sw	a0,-48(s0)
  info.nproc = nproc();
    80001fe2:	813ff0ef          	jal	800017f4 <nproc>
    80001fe6:	fca42a23          	sw	a0,-44(s0)
  info.nopenfiles = fileopencount();
    80001fea:	7c2010ef          	jal	800037ac <fileopencount>
    80001fee:	fca42c23          	sw	a0,-40(s0)

  if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    80001ff2:	46b1                	li	a3,12
    80001ff4:	fd040613          	addi	a2,s0,-48
    80001ff8:	85ca                	mv	a1,s2
    80001ffa:	68a8                	ld	a0,80(s1)
    80001ffc:	a39fe0ef          	jal	80000a34 <copyout>
    return -1;
  return 0;
}
    80002000:	41f5551b          	sraiw	a0,a0,0x1f
    80002004:	70a2                	ld	ra,40(sp)
    80002006:	7402                	ld	s0,32(sp)
    80002008:	64e2                	ld	s1,24(sp)
    8000200a:	6942                	ld	s2,16(sp)
    8000200c:	6145                	addi	sp,sp,48
    8000200e:	8082                	ret

0000000080002010 <sys_sysinfo>:

uint64 
sys_sysinfo(void)
{
    80002010:	1101                	addi	sp,sp,-32
    80002012:	ec06                	sd	ra,24(sp)
    80002014:	e822                	sd	s0,16(sp)
    80002016:	1000                	addi	s0,sp,32
  uint64 info;

  argaddr(0, &info);
    80002018:	fe840593          	addi	a1,s0,-24
    8000201c:	4501                	li	a0,0
    8000201e:	cdbff0ef          	jal	80001cf8 <argaddr>
  if (info < 0) 
    return 1;
  return sysinfo(info);
    80002022:	fe843503          	ld	a0,-24(s0)
    80002026:	fa1ff0ef          	jal	80001fc6 <sysinfo>
}
    8000202a:	60e2                	ld	ra,24(sp)
    8000202c:	6442                	ld	s0,16(sp)
    8000202e:	6105                	addi	sp,sp,32
    80002030:	8082                	ret

0000000080002032 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002032:	7179                	addi	sp,sp,-48
    80002034:	f406                	sd	ra,40(sp)
    80002036:	f022                	sd	s0,32(sp)
    80002038:	ec26                	sd	s1,24(sp)
    8000203a:	e84a                	sd	s2,16(sp)
    8000203c:	e44e                	sd	s3,8(sp)
    8000203e:	e052                	sd	s4,0(sp)
    80002040:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002042:	00005597          	auipc	a1,0x5
    80002046:	47e58593          	addi	a1,a1,1150 # 800074c0 <etext+0x4c0>
    8000204a:	0000e517          	auipc	a0,0xe
    8000204e:	5fe50513          	addi	a0,a0,1534 # 80010648 <bcache>
    80002052:	05f030ef          	jal	800058b0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002056:	00016797          	auipc	a5,0x16
    8000205a:	5f278793          	addi	a5,a5,1522 # 80018648 <bcache+0x8000>
    8000205e:	00017717          	auipc	a4,0x17
    80002062:	85270713          	addi	a4,a4,-1966 # 800188b0 <bcache+0x8268>
    80002066:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000206a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000206e:	0000e497          	auipc	s1,0xe
    80002072:	5f248493          	addi	s1,s1,1522 # 80010660 <bcache+0x18>
    b->next = bcache.head.next;
    80002076:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002078:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000207a:	00005a17          	auipc	s4,0x5
    8000207e:	44ea0a13          	addi	s4,s4,1102 # 800074c8 <etext+0x4c8>
    b->next = bcache.head.next;
    80002082:	2b893783          	ld	a5,696(s2)
    80002086:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002088:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000208c:	85d2                	mv	a1,s4
    8000208e:	01048513          	addi	a0,s1,16
    80002092:	244010ef          	jal	800032d6 <initsleeplock>
    bcache.head.next->prev = b;
    80002096:	2b893783          	ld	a5,696(s2)
    8000209a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000209c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020a0:	45848493          	addi	s1,s1,1112
    800020a4:	fd349fe3          	bne	s1,s3,80002082 <binit+0x50>
  }
}
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6942                	ld	s2,16(sp)
    800020b0:	69a2                	ld	s3,8(sp)
    800020b2:	6a02                	ld	s4,0(sp)
    800020b4:	6145                	addi	sp,sp,48
    800020b6:	8082                	ret

00000000800020b8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800020b8:	7179                	addi	sp,sp,-48
    800020ba:	f406                	sd	ra,40(sp)
    800020bc:	f022                	sd	s0,32(sp)
    800020be:	ec26                	sd	s1,24(sp)
    800020c0:	e84a                	sd	s2,16(sp)
    800020c2:	e44e                	sd	s3,8(sp)
    800020c4:	1800                	addi	s0,sp,48
    800020c6:	892a                	mv	s2,a0
    800020c8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800020ca:	0000e517          	auipc	a0,0xe
    800020ce:	57e50513          	addi	a0,a0,1406 # 80010648 <bcache>
    800020d2:	063030ef          	jal	80005934 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800020d6:	00017497          	auipc	s1,0x17
    800020da:	82a4b483          	ld	s1,-2006(s1) # 80018900 <bcache+0x82b8>
    800020de:	00016797          	auipc	a5,0x16
    800020e2:	7d278793          	addi	a5,a5,2002 # 800188b0 <bcache+0x8268>
    800020e6:	02f48b63          	beq	s1,a5,8000211c <bread+0x64>
    800020ea:	873e                	mv	a4,a5
    800020ec:	a021                	j	800020f4 <bread+0x3c>
    800020ee:	68a4                	ld	s1,80(s1)
    800020f0:	02e48663          	beq	s1,a4,8000211c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800020f4:	449c                	lw	a5,8(s1)
    800020f6:	ff279ce3          	bne	a5,s2,800020ee <bread+0x36>
    800020fa:	44dc                	lw	a5,12(s1)
    800020fc:	ff3799e3          	bne	a5,s3,800020ee <bread+0x36>
      b->refcnt++;
    80002100:	40bc                	lw	a5,64(s1)
    80002102:	2785                	addiw	a5,a5,1
    80002104:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002106:	0000e517          	auipc	a0,0xe
    8000210a:	54250513          	addi	a0,a0,1346 # 80010648 <bcache>
    8000210e:	0bb030ef          	jal	800059c8 <release>
      acquiresleep(&b->lock);
    80002112:	01048513          	addi	a0,s1,16
    80002116:	1f6010ef          	jal	8000330c <acquiresleep>
      return b;
    8000211a:	a889                	j	8000216c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000211c:	00016497          	auipc	s1,0x16
    80002120:	7dc4b483          	ld	s1,2012(s1) # 800188f8 <bcache+0x82b0>
    80002124:	00016797          	auipc	a5,0x16
    80002128:	78c78793          	addi	a5,a5,1932 # 800188b0 <bcache+0x8268>
    8000212c:	00f48863          	beq	s1,a5,8000213c <bread+0x84>
    80002130:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002132:	40bc                	lw	a5,64(s1)
    80002134:	cb91                	beqz	a5,80002148 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002136:	64a4                	ld	s1,72(s1)
    80002138:	fee49de3          	bne	s1,a4,80002132 <bread+0x7a>
  panic("bget: no buffers");
    8000213c:	00005517          	auipc	a0,0x5
    80002140:	39450513          	addi	a0,a0,916 # 800074d0 <etext+0x4d0>
    80002144:	4c2030ef          	jal	80005606 <panic>
      b->dev = dev;
    80002148:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000214c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002150:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002154:	4785                	li	a5,1
    80002156:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002158:	0000e517          	auipc	a0,0xe
    8000215c:	4f050513          	addi	a0,a0,1264 # 80010648 <bcache>
    80002160:	069030ef          	jal	800059c8 <release>
      acquiresleep(&b->lock);
    80002164:	01048513          	addi	a0,s1,16
    80002168:	1a4010ef          	jal	8000330c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000216c:	409c                	lw	a5,0(s1)
    8000216e:	cb89                	beqz	a5,80002180 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002170:	8526                	mv	a0,s1
    80002172:	70a2                	ld	ra,40(sp)
    80002174:	7402                	ld	s0,32(sp)
    80002176:	64e2                	ld	s1,24(sp)
    80002178:	6942                	ld	s2,16(sp)
    8000217a:	69a2                	ld	s3,8(sp)
    8000217c:	6145                	addi	sp,sp,48
    8000217e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002180:	4581                	li	a1,0
    80002182:	8526                	mv	a0,s1
    80002184:	24d020ef          	jal	80004bd0 <virtio_disk_rw>
    b->valid = 1;
    80002188:	4785                	li	a5,1
    8000218a:	c09c                	sw	a5,0(s1)
  return b;
    8000218c:	b7d5                	j	80002170 <bread+0xb8>

000000008000218e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000218e:	1101                	addi	sp,sp,-32
    80002190:	ec06                	sd	ra,24(sp)
    80002192:	e822                	sd	s0,16(sp)
    80002194:	e426                	sd	s1,8(sp)
    80002196:	1000                	addi	s0,sp,32
    80002198:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000219a:	0541                	addi	a0,a0,16
    8000219c:	1ee010ef          	jal	8000338a <holdingsleep>
    800021a0:	c911                	beqz	a0,800021b4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021a2:	4585                	li	a1,1
    800021a4:	8526                	mv	a0,s1
    800021a6:	22b020ef          	jal	80004bd0 <virtio_disk_rw>
}
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	64a2                	ld	s1,8(sp)
    800021b0:	6105                	addi	sp,sp,32
    800021b2:	8082                	ret
    panic("bwrite");
    800021b4:	00005517          	auipc	a0,0x5
    800021b8:	33450513          	addi	a0,a0,820 # 800074e8 <etext+0x4e8>
    800021bc:	44a030ef          	jal	80005606 <panic>

00000000800021c0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800021c0:	1101                	addi	sp,sp,-32
    800021c2:	ec06                	sd	ra,24(sp)
    800021c4:	e822                	sd	s0,16(sp)
    800021c6:	e426                	sd	s1,8(sp)
    800021c8:	e04a                	sd	s2,0(sp)
    800021ca:	1000                	addi	s0,sp,32
    800021cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021ce:	01050913          	addi	s2,a0,16
    800021d2:	854a                	mv	a0,s2
    800021d4:	1b6010ef          	jal	8000338a <holdingsleep>
    800021d8:	c125                	beqz	a0,80002238 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800021da:	854a                	mv	a0,s2
    800021dc:	176010ef          	jal	80003352 <releasesleep>

  acquire(&bcache.lock);
    800021e0:	0000e517          	auipc	a0,0xe
    800021e4:	46850513          	addi	a0,a0,1128 # 80010648 <bcache>
    800021e8:	74c030ef          	jal	80005934 <acquire>
  b->refcnt--;
    800021ec:	40bc                	lw	a5,64(s1)
    800021ee:	37fd                	addiw	a5,a5,-1
    800021f0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800021f2:	e79d                	bnez	a5,80002220 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800021f4:	68b8                	ld	a4,80(s1)
    800021f6:	64bc                	ld	a5,72(s1)
    800021f8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800021fa:	68b8                	ld	a4,80(s1)
    800021fc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800021fe:	00016797          	auipc	a5,0x16
    80002202:	44a78793          	addi	a5,a5,1098 # 80018648 <bcache+0x8000>
    80002206:	2b87b703          	ld	a4,696(a5)
    8000220a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000220c:	00016717          	auipc	a4,0x16
    80002210:	6a470713          	addi	a4,a4,1700 # 800188b0 <bcache+0x8268>
    80002214:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002216:	2b87b703          	ld	a4,696(a5)
    8000221a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000221c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002220:	0000e517          	auipc	a0,0xe
    80002224:	42850513          	addi	a0,a0,1064 # 80010648 <bcache>
    80002228:	7a0030ef          	jal	800059c8 <release>
}
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	64a2                	ld	s1,8(sp)
    80002232:	6902                	ld	s2,0(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret
    panic("brelse");
    80002238:	00005517          	auipc	a0,0x5
    8000223c:	2b850513          	addi	a0,a0,696 # 800074f0 <etext+0x4f0>
    80002240:	3c6030ef          	jal	80005606 <panic>

0000000080002244 <bpin>:

void
bpin(struct buf *b) {
    80002244:	1101                	addi	sp,sp,-32
    80002246:	ec06                	sd	ra,24(sp)
    80002248:	e822                	sd	s0,16(sp)
    8000224a:	e426                	sd	s1,8(sp)
    8000224c:	1000                	addi	s0,sp,32
    8000224e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002250:	0000e517          	auipc	a0,0xe
    80002254:	3f850513          	addi	a0,a0,1016 # 80010648 <bcache>
    80002258:	6dc030ef          	jal	80005934 <acquire>
  b->refcnt++;
    8000225c:	40bc                	lw	a5,64(s1)
    8000225e:	2785                	addiw	a5,a5,1
    80002260:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002262:	0000e517          	auipc	a0,0xe
    80002266:	3e650513          	addi	a0,a0,998 # 80010648 <bcache>
    8000226a:	75e030ef          	jal	800059c8 <release>
}
    8000226e:	60e2                	ld	ra,24(sp)
    80002270:	6442                	ld	s0,16(sp)
    80002272:	64a2                	ld	s1,8(sp)
    80002274:	6105                	addi	sp,sp,32
    80002276:	8082                	ret

0000000080002278 <bunpin>:

void
bunpin(struct buf *b) {
    80002278:	1101                	addi	sp,sp,-32
    8000227a:	ec06                	sd	ra,24(sp)
    8000227c:	e822                	sd	s0,16(sp)
    8000227e:	e426                	sd	s1,8(sp)
    80002280:	1000                	addi	s0,sp,32
    80002282:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002284:	0000e517          	auipc	a0,0xe
    80002288:	3c450513          	addi	a0,a0,964 # 80010648 <bcache>
    8000228c:	6a8030ef          	jal	80005934 <acquire>
  b->refcnt--;
    80002290:	40bc                	lw	a5,64(s1)
    80002292:	37fd                	addiw	a5,a5,-1
    80002294:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002296:	0000e517          	auipc	a0,0xe
    8000229a:	3b250513          	addi	a0,a0,946 # 80010648 <bcache>
    8000229e:	72a030ef          	jal	800059c8 <release>
}
    800022a2:	60e2                	ld	ra,24(sp)
    800022a4:	6442                	ld	s0,16(sp)
    800022a6:	64a2                	ld	s1,8(sp)
    800022a8:	6105                	addi	sp,sp,32
    800022aa:	8082                	ret

00000000800022ac <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800022ac:	1101                	addi	sp,sp,-32
    800022ae:	ec06                	sd	ra,24(sp)
    800022b0:	e822                	sd	s0,16(sp)
    800022b2:	e426                	sd	s1,8(sp)
    800022b4:	e04a                	sd	s2,0(sp)
    800022b6:	1000                	addi	s0,sp,32
    800022b8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800022ba:	00d5d79b          	srliw	a5,a1,0xd
    800022be:	00017597          	auipc	a1,0x17
    800022c2:	a665a583          	lw	a1,-1434(a1) # 80018d24 <sb+0x1c>
    800022c6:	9dbd                	addw	a1,a1,a5
    800022c8:	df1ff0ef          	jal	800020b8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800022cc:	0074f713          	andi	a4,s1,7
    800022d0:	4785                	li	a5,1
    800022d2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800022d6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800022d8:	90d9                	srli	s1,s1,0x36
    800022da:	00950733          	add	a4,a0,s1
    800022de:	05874703          	lbu	a4,88(a4)
    800022e2:	00e7f6b3          	and	a3,a5,a4
    800022e6:	c29d                	beqz	a3,8000230c <bfree+0x60>
    800022e8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800022ea:	94aa                	add	s1,s1,a0
    800022ec:	fff7c793          	not	a5,a5
    800022f0:	8f7d                	and	a4,a4,a5
    800022f2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800022f6:	711000ef          	jal	80003206 <log_write>
  brelse(bp);
    800022fa:	854a                	mv	a0,s2
    800022fc:	ec5ff0ef          	jal	800021c0 <brelse>
}
    80002300:	60e2                	ld	ra,24(sp)
    80002302:	6442                	ld	s0,16(sp)
    80002304:	64a2                	ld	s1,8(sp)
    80002306:	6902                	ld	s2,0(sp)
    80002308:	6105                	addi	sp,sp,32
    8000230a:	8082                	ret
    panic("freeing free block");
    8000230c:	00005517          	auipc	a0,0x5
    80002310:	1ec50513          	addi	a0,a0,492 # 800074f8 <etext+0x4f8>
    80002314:	2f2030ef          	jal	80005606 <panic>

0000000080002318 <balloc>:
{
    80002318:	715d                	addi	sp,sp,-80
    8000231a:	e486                	sd	ra,72(sp)
    8000231c:	e0a2                	sd	s0,64(sp)
    8000231e:	fc26                	sd	s1,56(sp)
    80002320:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002322:	00017797          	auipc	a5,0x17
    80002326:	9ea7a783          	lw	a5,-1558(a5) # 80018d0c <sb+0x4>
    8000232a:	0e078863          	beqz	a5,8000241a <balloc+0x102>
    8000232e:	f84a                	sd	s2,48(sp)
    80002330:	f44e                	sd	s3,40(sp)
    80002332:	f052                	sd	s4,32(sp)
    80002334:	ec56                	sd	s5,24(sp)
    80002336:	e85a                	sd	s6,16(sp)
    80002338:	e45e                	sd	s7,8(sp)
    8000233a:	e062                	sd	s8,0(sp)
    8000233c:	8baa                	mv	s7,a0
    8000233e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002340:	00017b17          	auipc	s6,0x17
    80002344:	9c8b0b13          	addi	s6,s6,-1592 # 80018d08 <sb>
      m = 1 << (bi % 8);
    80002348:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000234a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000234c:	6c09                	lui	s8,0x2
    8000234e:	a09d                	j	800023b4 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002350:	97ca                	add	a5,a5,s2
    80002352:	8e55                	or	a2,a2,a3
    80002354:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002358:	854a                	mv	a0,s2
    8000235a:	6ad000ef          	jal	80003206 <log_write>
        brelse(bp);
    8000235e:	854a                	mv	a0,s2
    80002360:	e61ff0ef          	jal	800021c0 <brelse>
  bp = bread(dev, bno);
    80002364:	85a6                	mv	a1,s1
    80002366:	855e                	mv	a0,s7
    80002368:	d51ff0ef          	jal	800020b8 <bread>
    8000236c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000236e:	40000613          	li	a2,1024
    80002372:	4581                	li	a1,0
    80002374:	05850513          	addi	a0,a0,88
    80002378:	dfffd0ef          	jal	80000176 <memset>
  log_write(bp);
    8000237c:	854a                	mv	a0,s2
    8000237e:	689000ef          	jal	80003206 <log_write>
  brelse(bp);
    80002382:	854a                	mv	a0,s2
    80002384:	e3dff0ef          	jal	800021c0 <brelse>
}
    80002388:	7942                	ld	s2,48(sp)
    8000238a:	79a2                	ld	s3,40(sp)
    8000238c:	7a02                	ld	s4,32(sp)
    8000238e:	6ae2                	ld	s5,24(sp)
    80002390:	6b42                	ld	s6,16(sp)
    80002392:	6ba2                	ld	s7,8(sp)
    80002394:	6c02                	ld	s8,0(sp)
}
    80002396:	8526                	mv	a0,s1
    80002398:	60a6                	ld	ra,72(sp)
    8000239a:	6406                	ld	s0,64(sp)
    8000239c:	74e2                	ld	s1,56(sp)
    8000239e:	6161                	addi	sp,sp,80
    800023a0:	8082                	ret
    brelse(bp);
    800023a2:	854a                	mv	a0,s2
    800023a4:	e1dff0ef          	jal	800021c0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800023a8:	015c0abb          	addw	s5,s8,s5
    800023ac:	004b2783          	lw	a5,4(s6)
    800023b0:	04fafe63          	bgeu	s5,a5,8000240c <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800023b4:	41fad79b          	sraiw	a5,s5,0x1f
    800023b8:	0137d79b          	srliw	a5,a5,0x13
    800023bc:	015787bb          	addw	a5,a5,s5
    800023c0:	40d7d79b          	sraiw	a5,a5,0xd
    800023c4:	01cb2583          	lw	a1,28(s6)
    800023c8:	9dbd                	addw	a1,a1,a5
    800023ca:	855e                	mv	a0,s7
    800023cc:	cedff0ef          	jal	800020b8 <bread>
    800023d0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023d2:	004b2503          	lw	a0,4(s6)
    800023d6:	84d6                	mv	s1,s5
    800023d8:	4701                	li	a4,0
    800023da:	fca4f4e3          	bgeu	s1,a0,800023a2 <balloc+0x8a>
      m = 1 << (bi % 8);
    800023de:	00777693          	andi	a3,a4,7
    800023e2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800023e6:	41f7579b          	sraiw	a5,a4,0x1f
    800023ea:	01d7d79b          	srliw	a5,a5,0x1d
    800023ee:	9fb9                	addw	a5,a5,a4
    800023f0:	4037d79b          	sraiw	a5,a5,0x3
    800023f4:	00f90633          	add	a2,s2,a5
    800023f8:	05864603          	lbu	a2,88(a2)
    800023fc:	00c6f5b3          	and	a1,a3,a2
    80002400:	d9a1                	beqz	a1,80002350 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002402:	2705                	addiw	a4,a4,1
    80002404:	2485                	addiw	s1,s1,1
    80002406:	fd471ae3          	bne	a4,s4,800023da <balloc+0xc2>
    8000240a:	bf61                	j	800023a2 <balloc+0x8a>
    8000240c:	7942                	ld	s2,48(sp)
    8000240e:	79a2                	ld	s3,40(sp)
    80002410:	7a02                	ld	s4,32(sp)
    80002412:	6ae2                	ld	s5,24(sp)
    80002414:	6b42                	ld	s6,16(sp)
    80002416:	6ba2                	ld	s7,8(sp)
    80002418:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000241a:	00005517          	auipc	a0,0x5
    8000241e:	0f650513          	addi	a0,a0,246 # 80007510 <etext+0x510>
    80002422:	715020ef          	jal	80005336 <printf>
  return 0;
    80002426:	4481                	li	s1,0
    80002428:	b7bd                	j	80002396 <balloc+0x7e>

000000008000242a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000242a:	7179                	addi	sp,sp,-48
    8000242c:	f406                	sd	ra,40(sp)
    8000242e:	f022                	sd	s0,32(sp)
    80002430:	ec26                	sd	s1,24(sp)
    80002432:	e84a                	sd	s2,16(sp)
    80002434:	e44e                	sd	s3,8(sp)
    80002436:	1800                	addi	s0,sp,48
    80002438:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000243a:	47ad                	li	a5,11
    8000243c:	02b7e363          	bltu	a5,a1,80002462 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002440:	02059793          	slli	a5,a1,0x20
    80002444:	01e7d593          	srli	a1,a5,0x1e
    80002448:	00b504b3          	add	s1,a0,a1
    8000244c:	0504a903          	lw	s2,80(s1)
    80002450:	06091363          	bnez	s2,800024b6 <bmap+0x8c>
      addr = balloc(ip->dev);
    80002454:	4108                	lw	a0,0(a0)
    80002456:	ec3ff0ef          	jal	80002318 <balloc>
    8000245a:	892a                	mv	s2,a0
      if(addr == 0)
    8000245c:	cd29                	beqz	a0,800024b6 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    8000245e:	c8a8                	sw	a0,80(s1)
    80002460:	a899                	j	800024b6 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002462:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80002466:	0ff00793          	li	a5,255
    8000246a:	0697e963          	bltu	a5,s1,800024dc <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000246e:	08052903          	lw	s2,128(a0)
    80002472:	00091b63          	bnez	s2,80002488 <bmap+0x5e>
      addr = balloc(ip->dev);
    80002476:	4108                	lw	a0,0(a0)
    80002478:	ea1ff0ef          	jal	80002318 <balloc>
    8000247c:	892a                	mv	s2,a0
      if(addr == 0)
    8000247e:	cd05                	beqz	a0,800024b6 <bmap+0x8c>
    80002480:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002482:	08a9a023          	sw	a0,128(s3)
    80002486:	a011                	j	8000248a <bmap+0x60>
    80002488:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000248a:	85ca                	mv	a1,s2
    8000248c:	0009a503          	lw	a0,0(s3)
    80002490:	c29ff0ef          	jal	800020b8 <bread>
    80002494:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002496:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000249a:	02049713          	slli	a4,s1,0x20
    8000249e:	01e75593          	srli	a1,a4,0x1e
    800024a2:	00b784b3          	add	s1,a5,a1
    800024a6:	0004a903          	lw	s2,0(s1)
    800024aa:	00090e63          	beqz	s2,800024c6 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800024ae:	8552                	mv	a0,s4
    800024b0:	d11ff0ef          	jal	800021c0 <brelse>
    return addr;
    800024b4:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800024b6:	854a                	mv	a0,s2
    800024b8:	70a2                	ld	ra,40(sp)
    800024ba:	7402                	ld	s0,32(sp)
    800024bc:	64e2                	ld	s1,24(sp)
    800024be:	6942                	ld	s2,16(sp)
    800024c0:	69a2                	ld	s3,8(sp)
    800024c2:	6145                	addi	sp,sp,48
    800024c4:	8082                	ret
      addr = balloc(ip->dev);
    800024c6:	0009a503          	lw	a0,0(s3)
    800024ca:	e4fff0ef          	jal	80002318 <balloc>
    800024ce:	892a                	mv	s2,a0
      if(addr){
    800024d0:	dd79                	beqz	a0,800024ae <bmap+0x84>
        a[bn] = addr;
    800024d2:	c088                	sw	a0,0(s1)
        log_write(bp);
    800024d4:	8552                	mv	a0,s4
    800024d6:	531000ef          	jal	80003206 <log_write>
    800024da:	bfd1                	j	800024ae <bmap+0x84>
    800024dc:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800024de:	00005517          	auipc	a0,0x5
    800024e2:	04a50513          	addi	a0,a0,74 # 80007528 <etext+0x528>
    800024e6:	120030ef          	jal	80005606 <panic>

00000000800024ea <iget>:
{
    800024ea:	7179                	addi	sp,sp,-48
    800024ec:	f406                	sd	ra,40(sp)
    800024ee:	f022                	sd	s0,32(sp)
    800024f0:	ec26                	sd	s1,24(sp)
    800024f2:	e84a                	sd	s2,16(sp)
    800024f4:	e44e                	sd	s3,8(sp)
    800024f6:	e052                	sd	s4,0(sp)
    800024f8:	1800                	addi	s0,sp,48
    800024fa:	89aa                	mv	s3,a0
    800024fc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800024fe:	00017517          	auipc	a0,0x17
    80002502:	82a50513          	addi	a0,a0,-2006 # 80018d28 <itable>
    80002506:	42e030ef          	jal	80005934 <acquire>
  empty = 0;
    8000250a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000250c:	00017497          	auipc	s1,0x17
    80002510:	83448493          	addi	s1,s1,-1996 # 80018d40 <itable+0x18>
    80002514:	00018697          	auipc	a3,0x18
    80002518:	2bc68693          	addi	a3,a3,700 # 8001a7d0 <log>
    8000251c:	a039                	j	8000252a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000251e:	02090963          	beqz	s2,80002550 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002522:	08848493          	addi	s1,s1,136
    80002526:	02d48863          	beq	s1,a3,80002556 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000252a:	449c                	lw	a5,8(s1)
    8000252c:	fef059e3          	blez	a5,8000251e <iget+0x34>
    80002530:	4098                	lw	a4,0(s1)
    80002532:	ff3716e3          	bne	a4,s3,8000251e <iget+0x34>
    80002536:	40d8                	lw	a4,4(s1)
    80002538:	ff4713e3          	bne	a4,s4,8000251e <iget+0x34>
      ip->ref++;
    8000253c:	2785                	addiw	a5,a5,1
    8000253e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002540:	00016517          	auipc	a0,0x16
    80002544:	7e850513          	addi	a0,a0,2024 # 80018d28 <itable>
    80002548:	480030ef          	jal	800059c8 <release>
      return ip;
    8000254c:	8926                	mv	s2,s1
    8000254e:	a02d                	j	80002578 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002550:	fbe9                	bnez	a5,80002522 <iget+0x38>
      empty = ip;
    80002552:	8926                	mv	s2,s1
    80002554:	b7f9                	j	80002522 <iget+0x38>
  if(empty == 0)
    80002556:	02090a63          	beqz	s2,8000258a <iget+0xa0>
  ip->dev = dev;
    8000255a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000255e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002562:	4785                	li	a5,1
    80002564:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002568:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000256c:	00016517          	auipc	a0,0x16
    80002570:	7bc50513          	addi	a0,a0,1980 # 80018d28 <itable>
    80002574:	454030ef          	jal	800059c8 <release>
}
    80002578:	854a                	mv	a0,s2
    8000257a:	70a2                	ld	ra,40(sp)
    8000257c:	7402                	ld	s0,32(sp)
    8000257e:	64e2                	ld	s1,24(sp)
    80002580:	6942                	ld	s2,16(sp)
    80002582:	69a2                	ld	s3,8(sp)
    80002584:	6a02                	ld	s4,0(sp)
    80002586:	6145                	addi	sp,sp,48
    80002588:	8082                	ret
    panic("iget: no inodes");
    8000258a:	00005517          	auipc	a0,0x5
    8000258e:	fb650513          	addi	a0,a0,-74 # 80007540 <etext+0x540>
    80002592:	074030ef          	jal	80005606 <panic>

0000000080002596 <fsinit>:
fsinit(int dev) {
    80002596:	7179                	addi	sp,sp,-48
    80002598:	f406                	sd	ra,40(sp)
    8000259a:	f022                	sd	s0,32(sp)
    8000259c:	ec26                	sd	s1,24(sp)
    8000259e:	e84a                	sd	s2,16(sp)
    800025a0:	e44e                	sd	s3,8(sp)
    800025a2:	1800                	addi	s0,sp,48
    800025a4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800025a6:	4585                	li	a1,1
    800025a8:	b11ff0ef          	jal	800020b8 <bread>
    800025ac:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800025ae:	00016997          	auipc	s3,0x16
    800025b2:	75a98993          	addi	s3,s3,1882 # 80018d08 <sb>
    800025b6:	02000613          	li	a2,32
    800025ba:	05850593          	addi	a1,a0,88
    800025be:	854e                	mv	a0,s3
    800025c0:	c1bfd0ef          	jal	800001da <memmove>
  brelse(bp);
    800025c4:	8526                	mv	a0,s1
    800025c6:	bfbff0ef          	jal	800021c0 <brelse>
  if(sb.magic != FSMAGIC)
    800025ca:	0009a703          	lw	a4,0(s3)
    800025ce:	102037b7          	lui	a5,0x10203
    800025d2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800025d6:	02f71063          	bne	a4,a5,800025f6 <fsinit+0x60>
  initlog(dev, &sb);
    800025da:	00016597          	auipc	a1,0x16
    800025de:	72e58593          	addi	a1,a1,1838 # 80018d08 <sb>
    800025e2:	854a                	mv	a0,s2
    800025e4:	215000ef          	jal	80002ff8 <initlog>
}
    800025e8:	70a2                	ld	ra,40(sp)
    800025ea:	7402                	ld	s0,32(sp)
    800025ec:	64e2                	ld	s1,24(sp)
    800025ee:	6942                	ld	s2,16(sp)
    800025f0:	69a2                	ld	s3,8(sp)
    800025f2:	6145                	addi	sp,sp,48
    800025f4:	8082                	ret
    panic("invalid file system");
    800025f6:	00005517          	auipc	a0,0x5
    800025fa:	f5a50513          	addi	a0,a0,-166 # 80007550 <etext+0x550>
    800025fe:	008030ef          	jal	80005606 <panic>

0000000080002602 <iinit>:
{
    80002602:	7179                	addi	sp,sp,-48
    80002604:	f406                	sd	ra,40(sp)
    80002606:	f022                	sd	s0,32(sp)
    80002608:	ec26                	sd	s1,24(sp)
    8000260a:	e84a                	sd	s2,16(sp)
    8000260c:	e44e                	sd	s3,8(sp)
    8000260e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002610:	00005597          	auipc	a1,0x5
    80002614:	f5858593          	addi	a1,a1,-168 # 80007568 <etext+0x568>
    80002618:	00016517          	auipc	a0,0x16
    8000261c:	71050513          	addi	a0,a0,1808 # 80018d28 <itable>
    80002620:	290030ef          	jal	800058b0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002624:	00016497          	auipc	s1,0x16
    80002628:	72c48493          	addi	s1,s1,1836 # 80018d50 <itable+0x28>
    8000262c:	00018997          	auipc	s3,0x18
    80002630:	1b498993          	addi	s3,s3,436 # 8001a7e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002634:	00005917          	auipc	s2,0x5
    80002638:	f3c90913          	addi	s2,s2,-196 # 80007570 <etext+0x570>
    8000263c:	85ca                	mv	a1,s2
    8000263e:	8526                	mv	a0,s1
    80002640:	497000ef          	jal	800032d6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002644:	08848493          	addi	s1,s1,136
    80002648:	ff349ae3          	bne	s1,s3,8000263c <iinit+0x3a>
}
    8000264c:	70a2                	ld	ra,40(sp)
    8000264e:	7402                	ld	s0,32(sp)
    80002650:	64e2                	ld	s1,24(sp)
    80002652:	6942                	ld	s2,16(sp)
    80002654:	69a2                	ld	s3,8(sp)
    80002656:	6145                	addi	sp,sp,48
    80002658:	8082                	ret

000000008000265a <ialloc>:
{
    8000265a:	7139                	addi	sp,sp,-64
    8000265c:	fc06                	sd	ra,56(sp)
    8000265e:	f822                	sd	s0,48(sp)
    80002660:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002662:	00016717          	auipc	a4,0x16
    80002666:	6b272703          	lw	a4,1714(a4) # 80018d14 <sb+0xc>
    8000266a:	4785                	li	a5,1
    8000266c:	06e7f063          	bgeu	a5,a4,800026cc <ialloc+0x72>
    80002670:	f426                	sd	s1,40(sp)
    80002672:	f04a                	sd	s2,32(sp)
    80002674:	ec4e                	sd	s3,24(sp)
    80002676:	e852                	sd	s4,16(sp)
    80002678:	e456                	sd	s5,8(sp)
    8000267a:	e05a                	sd	s6,0(sp)
    8000267c:	8aaa                	mv	s5,a0
    8000267e:	8b2e                	mv	s6,a1
    80002680:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002682:	00016a17          	auipc	s4,0x16
    80002686:	686a0a13          	addi	s4,s4,1670 # 80018d08 <sb>
    8000268a:	00495593          	srli	a1,s2,0x4
    8000268e:	018a2783          	lw	a5,24(s4)
    80002692:	9dbd                	addw	a1,a1,a5
    80002694:	8556                	mv	a0,s5
    80002696:	a23ff0ef          	jal	800020b8 <bread>
    8000269a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000269c:	05850993          	addi	s3,a0,88
    800026a0:	00f97793          	andi	a5,s2,15
    800026a4:	079a                	slli	a5,a5,0x6
    800026a6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800026a8:	00099783          	lh	a5,0(s3)
    800026ac:	cb9d                	beqz	a5,800026e2 <ialloc+0x88>
    brelse(bp);
    800026ae:	b13ff0ef          	jal	800021c0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800026b2:	0905                	addi	s2,s2,1
    800026b4:	00ca2703          	lw	a4,12(s4)
    800026b8:	0009079b          	sext.w	a5,s2
    800026bc:	fce7e7e3          	bltu	a5,a4,8000268a <ialloc+0x30>
    800026c0:	74a2                	ld	s1,40(sp)
    800026c2:	7902                	ld	s2,32(sp)
    800026c4:	69e2                	ld	s3,24(sp)
    800026c6:	6a42                	ld	s4,16(sp)
    800026c8:	6aa2                	ld	s5,8(sp)
    800026ca:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800026cc:	00005517          	auipc	a0,0x5
    800026d0:	eac50513          	addi	a0,a0,-340 # 80007578 <etext+0x578>
    800026d4:	463020ef          	jal	80005336 <printf>
  return 0;
    800026d8:	4501                	li	a0,0
}
    800026da:	70e2                	ld	ra,56(sp)
    800026dc:	7442                	ld	s0,48(sp)
    800026de:	6121                	addi	sp,sp,64
    800026e0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800026e2:	04000613          	li	a2,64
    800026e6:	4581                	li	a1,0
    800026e8:	854e                	mv	a0,s3
    800026ea:	a8dfd0ef          	jal	80000176 <memset>
      dip->type = type;
    800026ee:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800026f2:	8526                	mv	a0,s1
    800026f4:	313000ef          	jal	80003206 <log_write>
      brelse(bp);
    800026f8:	8526                	mv	a0,s1
    800026fa:	ac7ff0ef          	jal	800021c0 <brelse>
      return iget(dev, inum);
    800026fe:	0009059b          	sext.w	a1,s2
    80002702:	8556                	mv	a0,s5
    80002704:	de7ff0ef          	jal	800024ea <iget>
    80002708:	74a2                	ld	s1,40(sp)
    8000270a:	7902                	ld	s2,32(sp)
    8000270c:	69e2                	ld	s3,24(sp)
    8000270e:	6a42                	ld	s4,16(sp)
    80002710:	6aa2                	ld	s5,8(sp)
    80002712:	6b02                	ld	s6,0(sp)
    80002714:	b7d9                	j	800026da <ialloc+0x80>

0000000080002716 <iupdate>:
{
    80002716:	1101                	addi	sp,sp,-32
    80002718:	ec06                	sd	ra,24(sp)
    8000271a:	e822                	sd	s0,16(sp)
    8000271c:	e426                	sd	s1,8(sp)
    8000271e:	e04a                	sd	s2,0(sp)
    80002720:	1000                	addi	s0,sp,32
    80002722:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002724:	415c                	lw	a5,4(a0)
    80002726:	0047d79b          	srliw	a5,a5,0x4
    8000272a:	00016597          	auipc	a1,0x16
    8000272e:	5f65a583          	lw	a1,1526(a1) # 80018d20 <sb+0x18>
    80002732:	9dbd                	addw	a1,a1,a5
    80002734:	4108                	lw	a0,0(a0)
    80002736:	983ff0ef          	jal	800020b8 <bread>
    8000273a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000273c:	05850793          	addi	a5,a0,88
    80002740:	40d8                	lw	a4,4(s1)
    80002742:	8b3d                	andi	a4,a4,15
    80002744:	071a                	slli	a4,a4,0x6
    80002746:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002748:	04449703          	lh	a4,68(s1)
    8000274c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002750:	04649703          	lh	a4,70(s1)
    80002754:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002758:	04849703          	lh	a4,72(s1)
    8000275c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002760:	04a49703          	lh	a4,74(s1)
    80002764:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002768:	44f8                	lw	a4,76(s1)
    8000276a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000276c:	03400613          	li	a2,52
    80002770:	05048593          	addi	a1,s1,80
    80002774:	00c78513          	addi	a0,a5,12
    80002778:	a63fd0ef          	jal	800001da <memmove>
  log_write(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	289000ef          	jal	80003206 <log_write>
  brelse(bp);
    80002782:	854a                	mv	a0,s2
    80002784:	a3dff0ef          	jal	800021c0 <brelse>
}
    80002788:	60e2                	ld	ra,24(sp)
    8000278a:	6442                	ld	s0,16(sp)
    8000278c:	64a2                	ld	s1,8(sp)
    8000278e:	6902                	ld	s2,0(sp)
    80002790:	6105                	addi	sp,sp,32
    80002792:	8082                	ret

0000000080002794 <idup>:
{
    80002794:	1101                	addi	sp,sp,-32
    80002796:	ec06                	sd	ra,24(sp)
    80002798:	e822                	sd	s0,16(sp)
    8000279a:	e426                	sd	s1,8(sp)
    8000279c:	1000                	addi	s0,sp,32
    8000279e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027a0:	00016517          	auipc	a0,0x16
    800027a4:	58850513          	addi	a0,a0,1416 # 80018d28 <itable>
    800027a8:	18c030ef          	jal	80005934 <acquire>
  ip->ref++;
    800027ac:	449c                	lw	a5,8(s1)
    800027ae:	2785                	addiw	a5,a5,1
    800027b0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027b2:	00016517          	auipc	a0,0x16
    800027b6:	57650513          	addi	a0,a0,1398 # 80018d28 <itable>
    800027ba:	20e030ef          	jal	800059c8 <release>
}
    800027be:	8526                	mv	a0,s1
    800027c0:	60e2                	ld	ra,24(sp)
    800027c2:	6442                	ld	s0,16(sp)
    800027c4:	64a2                	ld	s1,8(sp)
    800027c6:	6105                	addi	sp,sp,32
    800027c8:	8082                	ret

00000000800027ca <ilock>:
{
    800027ca:	1101                	addi	sp,sp,-32
    800027cc:	ec06                	sd	ra,24(sp)
    800027ce:	e822                	sd	s0,16(sp)
    800027d0:	e426                	sd	s1,8(sp)
    800027d2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800027d4:	cd19                	beqz	a0,800027f2 <ilock+0x28>
    800027d6:	84aa                	mv	s1,a0
    800027d8:	451c                	lw	a5,8(a0)
    800027da:	00f05c63          	blez	a5,800027f2 <ilock+0x28>
  acquiresleep(&ip->lock);
    800027de:	0541                	addi	a0,a0,16
    800027e0:	32d000ef          	jal	8000330c <acquiresleep>
  if(ip->valid == 0){
    800027e4:	40bc                	lw	a5,64(s1)
    800027e6:	cf89                	beqz	a5,80002800 <ilock+0x36>
}
    800027e8:	60e2                	ld	ra,24(sp)
    800027ea:	6442                	ld	s0,16(sp)
    800027ec:	64a2                	ld	s1,8(sp)
    800027ee:	6105                	addi	sp,sp,32
    800027f0:	8082                	ret
    800027f2:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800027f4:	00005517          	auipc	a0,0x5
    800027f8:	d9c50513          	addi	a0,a0,-612 # 80007590 <etext+0x590>
    800027fc:	60b020ef          	jal	80005606 <panic>
    80002800:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002802:	40dc                	lw	a5,4(s1)
    80002804:	0047d79b          	srliw	a5,a5,0x4
    80002808:	00016597          	auipc	a1,0x16
    8000280c:	5185a583          	lw	a1,1304(a1) # 80018d20 <sb+0x18>
    80002810:	9dbd                	addw	a1,a1,a5
    80002812:	4088                	lw	a0,0(s1)
    80002814:	8a5ff0ef          	jal	800020b8 <bread>
    80002818:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000281a:	05850593          	addi	a1,a0,88
    8000281e:	40dc                	lw	a5,4(s1)
    80002820:	8bbd                	andi	a5,a5,15
    80002822:	079a                	slli	a5,a5,0x6
    80002824:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002826:	00059783          	lh	a5,0(a1)
    8000282a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000282e:	00259783          	lh	a5,2(a1)
    80002832:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002836:	00459783          	lh	a5,4(a1)
    8000283a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000283e:	00659783          	lh	a5,6(a1)
    80002842:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002846:	459c                	lw	a5,8(a1)
    80002848:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000284a:	03400613          	li	a2,52
    8000284e:	05b1                	addi	a1,a1,12
    80002850:	05048513          	addi	a0,s1,80
    80002854:	987fd0ef          	jal	800001da <memmove>
    brelse(bp);
    80002858:	854a                	mv	a0,s2
    8000285a:	967ff0ef          	jal	800021c0 <brelse>
    ip->valid = 1;
    8000285e:	4785                	li	a5,1
    80002860:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002862:	04449783          	lh	a5,68(s1)
    80002866:	c399                	beqz	a5,8000286c <ilock+0xa2>
    80002868:	6902                	ld	s2,0(sp)
    8000286a:	bfbd                	j	800027e8 <ilock+0x1e>
      panic("ilock: no type");
    8000286c:	00005517          	auipc	a0,0x5
    80002870:	d2c50513          	addi	a0,a0,-724 # 80007598 <etext+0x598>
    80002874:	593020ef          	jal	80005606 <panic>

0000000080002878 <iunlock>:
{
    80002878:	1101                	addi	sp,sp,-32
    8000287a:	ec06                	sd	ra,24(sp)
    8000287c:	e822                	sd	s0,16(sp)
    8000287e:	e426                	sd	s1,8(sp)
    80002880:	e04a                	sd	s2,0(sp)
    80002882:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002884:	c505                	beqz	a0,800028ac <iunlock+0x34>
    80002886:	84aa                	mv	s1,a0
    80002888:	01050913          	addi	s2,a0,16
    8000288c:	854a                	mv	a0,s2
    8000288e:	2fd000ef          	jal	8000338a <holdingsleep>
    80002892:	cd09                	beqz	a0,800028ac <iunlock+0x34>
    80002894:	449c                	lw	a5,8(s1)
    80002896:	00f05b63          	blez	a5,800028ac <iunlock+0x34>
  releasesleep(&ip->lock);
    8000289a:	854a                	mv	a0,s2
    8000289c:	2b7000ef          	jal	80003352 <releasesleep>
}
    800028a0:	60e2                	ld	ra,24(sp)
    800028a2:	6442                	ld	s0,16(sp)
    800028a4:	64a2                	ld	s1,8(sp)
    800028a6:	6902                	ld	s2,0(sp)
    800028a8:	6105                	addi	sp,sp,32
    800028aa:	8082                	ret
    panic("iunlock");
    800028ac:	00005517          	auipc	a0,0x5
    800028b0:	cfc50513          	addi	a0,a0,-772 # 800075a8 <etext+0x5a8>
    800028b4:	553020ef          	jal	80005606 <panic>

00000000800028b8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800028b8:	7179                	addi	sp,sp,-48
    800028ba:	f406                	sd	ra,40(sp)
    800028bc:	f022                	sd	s0,32(sp)
    800028be:	ec26                	sd	s1,24(sp)
    800028c0:	e84a                	sd	s2,16(sp)
    800028c2:	e44e                	sd	s3,8(sp)
    800028c4:	1800                	addi	s0,sp,48
    800028c6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800028c8:	05050493          	addi	s1,a0,80
    800028cc:	08050913          	addi	s2,a0,128
    800028d0:	a021                	j	800028d8 <itrunc+0x20>
    800028d2:	0491                	addi	s1,s1,4
    800028d4:	01248b63          	beq	s1,s2,800028ea <itrunc+0x32>
    if(ip->addrs[i]){
    800028d8:	408c                	lw	a1,0(s1)
    800028da:	dde5                	beqz	a1,800028d2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800028dc:	0009a503          	lw	a0,0(s3)
    800028e0:	9cdff0ef          	jal	800022ac <bfree>
      ip->addrs[i] = 0;
    800028e4:	0004a023          	sw	zero,0(s1)
    800028e8:	b7ed                	j	800028d2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800028ea:	0809a583          	lw	a1,128(s3)
    800028ee:	ed89                	bnez	a1,80002908 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800028f0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800028f4:	854e                	mv	a0,s3
    800028f6:	e21ff0ef          	jal	80002716 <iupdate>
}
    800028fa:	70a2                	ld	ra,40(sp)
    800028fc:	7402                	ld	s0,32(sp)
    800028fe:	64e2                	ld	s1,24(sp)
    80002900:	6942                	ld	s2,16(sp)
    80002902:	69a2                	ld	s3,8(sp)
    80002904:	6145                	addi	sp,sp,48
    80002906:	8082                	ret
    80002908:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000290a:	0009a503          	lw	a0,0(s3)
    8000290e:	faaff0ef          	jal	800020b8 <bread>
    80002912:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002914:	05850493          	addi	s1,a0,88
    80002918:	45850913          	addi	s2,a0,1112
    8000291c:	a021                	j	80002924 <itrunc+0x6c>
    8000291e:	0491                	addi	s1,s1,4
    80002920:	01248963          	beq	s1,s2,80002932 <itrunc+0x7a>
      if(a[j])
    80002924:	408c                	lw	a1,0(s1)
    80002926:	dde5                	beqz	a1,8000291e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002928:	0009a503          	lw	a0,0(s3)
    8000292c:	981ff0ef          	jal	800022ac <bfree>
    80002930:	b7fd                	j	8000291e <itrunc+0x66>
    brelse(bp);
    80002932:	8552                	mv	a0,s4
    80002934:	88dff0ef          	jal	800021c0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002938:	0809a583          	lw	a1,128(s3)
    8000293c:	0009a503          	lw	a0,0(s3)
    80002940:	96dff0ef          	jal	800022ac <bfree>
    ip->addrs[NDIRECT] = 0;
    80002944:	0809a023          	sw	zero,128(s3)
    80002948:	6a02                	ld	s4,0(sp)
    8000294a:	b75d                	j	800028f0 <itrunc+0x38>

000000008000294c <iput>:
{
    8000294c:	1101                	addi	sp,sp,-32
    8000294e:	ec06                	sd	ra,24(sp)
    80002950:	e822                	sd	s0,16(sp)
    80002952:	e426                	sd	s1,8(sp)
    80002954:	1000                	addi	s0,sp,32
    80002956:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002958:	00016517          	auipc	a0,0x16
    8000295c:	3d050513          	addi	a0,a0,976 # 80018d28 <itable>
    80002960:	7d5020ef          	jal	80005934 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002964:	4498                	lw	a4,8(s1)
    80002966:	4785                	li	a5,1
    80002968:	02f70063          	beq	a4,a5,80002988 <iput+0x3c>
  ip->ref--;
    8000296c:	449c                	lw	a5,8(s1)
    8000296e:	37fd                	addiw	a5,a5,-1
    80002970:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002972:	00016517          	auipc	a0,0x16
    80002976:	3b650513          	addi	a0,a0,950 # 80018d28 <itable>
    8000297a:	04e030ef          	jal	800059c8 <release>
}
    8000297e:	60e2                	ld	ra,24(sp)
    80002980:	6442                	ld	s0,16(sp)
    80002982:	64a2                	ld	s1,8(sp)
    80002984:	6105                	addi	sp,sp,32
    80002986:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002988:	40bc                	lw	a5,64(s1)
    8000298a:	d3ed                	beqz	a5,8000296c <iput+0x20>
    8000298c:	04a49783          	lh	a5,74(s1)
    80002990:	fff1                	bnez	a5,8000296c <iput+0x20>
    80002992:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002994:	01048913          	addi	s2,s1,16
    80002998:	854a                	mv	a0,s2
    8000299a:	173000ef          	jal	8000330c <acquiresleep>
    release(&itable.lock);
    8000299e:	00016517          	auipc	a0,0x16
    800029a2:	38a50513          	addi	a0,a0,906 # 80018d28 <itable>
    800029a6:	022030ef          	jal	800059c8 <release>
    itrunc(ip);
    800029aa:	8526                	mv	a0,s1
    800029ac:	f0dff0ef          	jal	800028b8 <itrunc>
    ip->type = 0;
    800029b0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800029b4:	8526                	mv	a0,s1
    800029b6:	d61ff0ef          	jal	80002716 <iupdate>
    ip->valid = 0;
    800029ba:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800029be:	854a                	mv	a0,s2
    800029c0:	193000ef          	jal	80003352 <releasesleep>
    acquire(&itable.lock);
    800029c4:	00016517          	auipc	a0,0x16
    800029c8:	36450513          	addi	a0,a0,868 # 80018d28 <itable>
    800029cc:	769020ef          	jal	80005934 <acquire>
    800029d0:	6902                	ld	s2,0(sp)
    800029d2:	bf69                	j	8000296c <iput+0x20>

00000000800029d4 <iunlockput>:
{
    800029d4:	1101                	addi	sp,sp,-32
    800029d6:	ec06                	sd	ra,24(sp)
    800029d8:	e822                	sd	s0,16(sp)
    800029da:	e426                	sd	s1,8(sp)
    800029dc:	1000                	addi	s0,sp,32
    800029de:	84aa                	mv	s1,a0
  iunlock(ip);
    800029e0:	e99ff0ef          	jal	80002878 <iunlock>
  iput(ip);
    800029e4:	8526                	mv	a0,s1
    800029e6:	f67ff0ef          	jal	8000294c <iput>
}
    800029ea:	60e2                	ld	ra,24(sp)
    800029ec:	6442                	ld	s0,16(sp)
    800029ee:	64a2                	ld	s1,8(sp)
    800029f0:	6105                	addi	sp,sp,32
    800029f2:	8082                	ret

00000000800029f4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800029f4:	1141                	addi	sp,sp,-16
    800029f6:	e406                	sd	ra,8(sp)
    800029f8:	e022                	sd	s0,0(sp)
    800029fa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800029fc:	411c                	lw	a5,0(a0)
    800029fe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a00:	415c                	lw	a5,4(a0)
    80002a02:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a04:	04451783          	lh	a5,68(a0)
    80002a08:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a0c:	04a51783          	lh	a5,74(a0)
    80002a10:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a14:	04c56783          	lwu	a5,76(a0)
    80002a18:	e99c                	sd	a5,16(a1)
}
    80002a1a:	60a2                	ld	ra,8(sp)
    80002a1c:	6402                	ld	s0,0(sp)
    80002a1e:	0141                	addi	sp,sp,16
    80002a20:	8082                	ret

0000000080002a22 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a22:	457c                	lw	a5,76(a0)
    80002a24:	0ed7e663          	bltu	a5,a3,80002b10 <readi+0xee>
{
    80002a28:	7159                	addi	sp,sp,-112
    80002a2a:	f486                	sd	ra,104(sp)
    80002a2c:	f0a2                	sd	s0,96(sp)
    80002a2e:	eca6                	sd	s1,88(sp)
    80002a30:	e0d2                	sd	s4,64(sp)
    80002a32:	fc56                	sd	s5,56(sp)
    80002a34:	f85a                	sd	s6,48(sp)
    80002a36:	f45e                	sd	s7,40(sp)
    80002a38:	1880                	addi	s0,sp,112
    80002a3a:	8b2a                	mv	s6,a0
    80002a3c:	8bae                	mv	s7,a1
    80002a3e:	8a32                	mv	s4,a2
    80002a40:	84b6                	mv	s1,a3
    80002a42:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a44:	9f35                	addw	a4,a4,a3
    return 0;
    80002a46:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a48:	0ad76b63          	bltu	a4,a3,80002afe <readi+0xdc>
    80002a4c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a4e:	00e7f463          	bgeu	a5,a4,80002a56 <readi+0x34>
    n = ip->size - off;
    80002a52:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a56:	080a8b63          	beqz	s5,80002aec <readi+0xca>
    80002a5a:	e8ca                	sd	s2,80(sp)
    80002a5c:	f062                	sd	s8,32(sp)
    80002a5e:	ec66                	sd	s9,24(sp)
    80002a60:	e86a                	sd	s10,16(sp)
    80002a62:	e46e                	sd	s11,8(sp)
    80002a64:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a66:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a6a:	5c7d                	li	s8,-1
    80002a6c:	a80d                	j	80002a9e <readi+0x7c>
    80002a6e:	020d1d93          	slli	s11,s10,0x20
    80002a72:	020ddd93          	srli	s11,s11,0x20
    80002a76:	05890613          	addi	a2,s2,88
    80002a7a:	86ee                	mv	a3,s11
    80002a7c:	963e                	add	a2,a2,a5
    80002a7e:	85d2                	mv	a1,s4
    80002a80:	855e                	mv	a0,s7
    80002a82:	c3bfe0ef          	jal	800016bc <either_copyout>
    80002a86:	05850363          	beq	a0,s8,80002acc <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a8a:	854a                	mv	a0,s2
    80002a8c:	f34ff0ef          	jal	800021c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a90:	013d09bb          	addw	s3,s10,s3
    80002a94:	009d04bb          	addw	s1,s10,s1
    80002a98:	9a6e                	add	s4,s4,s11
    80002a9a:	0559f363          	bgeu	s3,s5,80002ae0 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002a9e:	00a4d59b          	srliw	a1,s1,0xa
    80002aa2:	855a                	mv	a0,s6
    80002aa4:	987ff0ef          	jal	8000242a <bmap>
    80002aa8:	85aa                	mv	a1,a0
    if(addr == 0)
    80002aaa:	c139                	beqz	a0,80002af0 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002aac:	000b2503          	lw	a0,0(s6)
    80002ab0:	e08ff0ef          	jal	800020b8 <bread>
    80002ab4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ab6:	3ff4f793          	andi	a5,s1,1023
    80002aba:	40fc873b          	subw	a4,s9,a5
    80002abe:	413a86bb          	subw	a3,s5,s3
    80002ac2:	8d3a                	mv	s10,a4
    80002ac4:	fae6f5e3          	bgeu	a3,a4,80002a6e <readi+0x4c>
    80002ac8:	8d36                	mv	s10,a3
    80002aca:	b755                	j	80002a6e <readi+0x4c>
      brelse(bp);
    80002acc:	854a                	mv	a0,s2
    80002ace:	ef2ff0ef          	jal	800021c0 <brelse>
      tot = -1;
    80002ad2:	59fd                	li	s3,-1
      break;
    80002ad4:	6946                	ld	s2,80(sp)
    80002ad6:	7c02                	ld	s8,32(sp)
    80002ad8:	6ce2                	ld	s9,24(sp)
    80002ada:	6d42                	ld	s10,16(sp)
    80002adc:	6da2                	ld	s11,8(sp)
    80002ade:	a831                	j	80002afa <readi+0xd8>
    80002ae0:	6946                	ld	s2,80(sp)
    80002ae2:	7c02                	ld	s8,32(sp)
    80002ae4:	6ce2                	ld	s9,24(sp)
    80002ae6:	6d42                	ld	s10,16(sp)
    80002ae8:	6da2                	ld	s11,8(sp)
    80002aea:	a801                	j	80002afa <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002aec:	89d6                	mv	s3,s5
    80002aee:	a031                	j	80002afa <readi+0xd8>
    80002af0:	6946                	ld	s2,80(sp)
    80002af2:	7c02                	ld	s8,32(sp)
    80002af4:	6ce2                	ld	s9,24(sp)
    80002af6:	6d42                	ld	s10,16(sp)
    80002af8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002afa:	854e                	mv	a0,s3
    80002afc:	69a6                	ld	s3,72(sp)
}
    80002afe:	70a6                	ld	ra,104(sp)
    80002b00:	7406                	ld	s0,96(sp)
    80002b02:	64e6                	ld	s1,88(sp)
    80002b04:	6a06                	ld	s4,64(sp)
    80002b06:	7ae2                	ld	s5,56(sp)
    80002b08:	7b42                	ld	s6,48(sp)
    80002b0a:	7ba2                	ld	s7,40(sp)
    80002b0c:	6165                	addi	sp,sp,112
    80002b0e:	8082                	ret
    return 0;
    80002b10:	4501                	li	a0,0
}
    80002b12:	8082                	ret

0000000080002b14 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b14:	457c                	lw	a5,76(a0)
    80002b16:	0ed7eb63          	bltu	a5,a3,80002c0c <writei+0xf8>
{
    80002b1a:	7159                	addi	sp,sp,-112
    80002b1c:	f486                	sd	ra,104(sp)
    80002b1e:	f0a2                	sd	s0,96(sp)
    80002b20:	e8ca                	sd	s2,80(sp)
    80002b22:	e0d2                	sd	s4,64(sp)
    80002b24:	fc56                	sd	s5,56(sp)
    80002b26:	f85a                	sd	s6,48(sp)
    80002b28:	f45e                	sd	s7,40(sp)
    80002b2a:	1880                	addi	s0,sp,112
    80002b2c:	8aaa                	mv	s5,a0
    80002b2e:	8bae                	mv	s7,a1
    80002b30:	8a32                	mv	s4,a2
    80002b32:	8936                	mv	s2,a3
    80002b34:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b36:	00e687bb          	addw	a5,a3,a4
    80002b3a:	0cd7eb63          	bltu	a5,a3,80002c10 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b3e:	00043737          	lui	a4,0x43
    80002b42:	0cf76963          	bltu	a4,a5,80002c14 <writei+0x100>
    80002b46:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b48:	0a0b0a63          	beqz	s6,80002bfc <writei+0xe8>
    80002b4c:	eca6                	sd	s1,88(sp)
    80002b4e:	f062                	sd	s8,32(sp)
    80002b50:	ec66                	sd	s9,24(sp)
    80002b52:	e86a                	sd	s10,16(sp)
    80002b54:	e46e                	sd	s11,8(sp)
    80002b56:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b58:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b5c:	5c7d                	li	s8,-1
    80002b5e:	a825                	j	80002b96 <writei+0x82>
    80002b60:	020d1d93          	slli	s11,s10,0x20
    80002b64:	020ddd93          	srli	s11,s11,0x20
    80002b68:	05848513          	addi	a0,s1,88
    80002b6c:	86ee                	mv	a3,s11
    80002b6e:	8652                	mv	a2,s4
    80002b70:	85de                	mv	a1,s7
    80002b72:	953e                	add	a0,a0,a5
    80002b74:	b93fe0ef          	jal	80001706 <either_copyin>
    80002b78:	05850663          	beq	a0,s8,80002bc4 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b7c:	8526                	mv	a0,s1
    80002b7e:	688000ef          	jal	80003206 <log_write>
    brelse(bp);
    80002b82:	8526                	mv	a0,s1
    80002b84:	e3cff0ef          	jal	800021c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b88:	013d09bb          	addw	s3,s10,s3
    80002b8c:	012d093b          	addw	s2,s10,s2
    80002b90:	9a6e                	add	s4,s4,s11
    80002b92:	0369fc63          	bgeu	s3,s6,80002bca <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002b96:	00a9559b          	srliw	a1,s2,0xa
    80002b9a:	8556                	mv	a0,s5
    80002b9c:	88fff0ef          	jal	8000242a <bmap>
    80002ba0:	85aa                	mv	a1,a0
    if(addr == 0)
    80002ba2:	c505                	beqz	a0,80002bca <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002ba4:	000aa503          	lw	a0,0(s5)
    80002ba8:	d10ff0ef          	jal	800020b8 <bread>
    80002bac:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bae:	3ff97793          	andi	a5,s2,1023
    80002bb2:	40fc873b          	subw	a4,s9,a5
    80002bb6:	413b06bb          	subw	a3,s6,s3
    80002bba:	8d3a                	mv	s10,a4
    80002bbc:	fae6f2e3          	bgeu	a3,a4,80002b60 <writei+0x4c>
    80002bc0:	8d36                	mv	s10,a3
    80002bc2:	bf79                	j	80002b60 <writei+0x4c>
      brelse(bp);
    80002bc4:	8526                	mv	a0,s1
    80002bc6:	dfaff0ef          	jal	800021c0 <brelse>
  }

  if(off > ip->size)
    80002bca:	04caa783          	lw	a5,76(s5)
    80002bce:	0327f963          	bgeu	a5,s2,80002c00 <writei+0xec>
    ip->size = off;
    80002bd2:	052aa623          	sw	s2,76(s5)
    80002bd6:	64e6                	ld	s1,88(sp)
    80002bd8:	7c02                	ld	s8,32(sp)
    80002bda:	6ce2                	ld	s9,24(sp)
    80002bdc:	6d42                	ld	s10,16(sp)
    80002bde:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002be0:	8556                	mv	a0,s5
    80002be2:	b35ff0ef          	jal	80002716 <iupdate>

  return tot;
    80002be6:	854e                	mv	a0,s3
    80002be8:	69a6                	ld	s3,72(sp)
}
    80002bea:	70a6                	ld	ra,104(sp)
    80002bec:	7406                	ld	s0,96(sp)
    80002bee:	6946                	ld	s2,80(sp)
    80002bf0:	6a06                	ld	s4,64(sp)
    80002bf2:	7ae2                	ld	s5,56(sp)
    80002bf4:	7b42                	ld	s6,48(sp)
    80002bf6:	7ba2                	ld	s7,40(sp)
    80002bf8:	6165                	addi	sp,sp,112
    80002bfa:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bfc:	89da                	mv	s3,s6
    80002bfe:	b7cd                	j	80002be0 <writei+0xcc>
    80002c00:	64e6                	ld	s1,88(sp)
    80002c02:	7c02                	ld	s8,32(sp)
    80002c04:	6ce2                	ld	s9,24(sp)
    80002c06:	6d42                	ld	s10,16(sp)
    80002c08:	6da2                	ld	s11,8(sp)
    80002c0a:	bfd9                	j	80002be0 <writei+0xcc>
    return -1;
    80002c0c:	557d                	li	a0,-1
}
    80002c0e:	8082                	ret
    return -1;
    80002c10:	557d                	li	a0,-1
    80002c12:	bfe1                	j	80002bea <writei+0xd6>
    return -1;
    80002c14:	557d                	li	a0,-1
    80002c16:	bfd1                	j	80002bea <writei+0xd6>

0000000080002c18 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c18:	1141                	addi	sp,sp,-16
    80002c1a:	e406                	sd	ra,8(sp)
    80002c1c:	e022                	sd	s0,0(sp)
    80002c1e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c20:	4639                	li	a2,14
    80002c22:	e2cfd0ef          	jal	8000024e <strncmp>
}
    80002c26:	60a2                	ld	ra,8(sp)
    80002c28:	6402                	ld	s0,0(sp)
    80002c2a:	0141                	addi	sp,sp,16
    80002c2c:	8082                	ret

0000000080002c2e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c2e:	711d                	addi	sp,sp,-96
    80002c30:	ec86                	sd	ra,88(sp)
    80002c32:	e8a2                	sd	s0,80(sp)
    80002c34:	e4a6                	sd	s1,72(sp)
    80002c36:	e0ca                	sd	s2,64(sp)
    80002c38:	fc4e                	sd	s3,56(sp)
    80002c3a:	f852                	sd	s4,48(sp)
    80002c3c:	f456                	sd	s5,40(sp)
    80002c3e:	f05a                	sd	s6,32(sp)
    80002c40:	ec5e                	sd	s7,24(sp)
    80002c42:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c44:	04451703          	lh	a4,68(a0)
    80002c48:	4785                	li	a5,1
    80002c4a:	00f71f63          	bne	a4,a5,80002c68 <dirlookup+0x3a>
    80002c4e:	892a                	mv	s2,a0
    80002c50:	8aae                	mv	s5,a1
    80002c52:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c54:	457c                	lw	a5,76(a0)
    80002c56:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c58:	fa040a13          	addi	s4,s0,-96
    80002c5c:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002c5e:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c62:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c64:	e39d                	bnez	a5,80002c8a <dirlookup+0x5c>
    80002c66:	a8b9                	j	80002cc4 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002c68:	00005517          	auipc	a0,0x5
    80002c6c:	94850513          	addi	a0,a0,-1720 # 800075b0 <etext+0x5b0>
    80002c70:	197020ef          	jal	80005606 <panic>
      panic("dirlookup read");
    80002c74:	00005517          	auipc	a0,0x5
    80002c78:	95450513          	addi	a0,a0,-1708 # 800075c8 <etext+0x5c8>
    80002c7c:	18b020ef          	jal	80005606 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c80:	24c1                	addiw	s1,s1,16
    80002c82:	04c92783          	lw	a5,76(s2)
    80002c86:	02f4fe63          	bgeu	s1,a5,80002cc2 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c8a:	874e                	mv	a4,s3
    80002c8c:	86a6                	mv	a3,s1
    80002c8e:	8652                	mv	a2,s4
    80002c90:	4581                	li	a1,0
    80002c92:	854a                	mv	a0,s2
    80002c94:	d8fff0ef          	jal	80002a22 <readi>
    80002c98:	fd351ee3          	bne	a0,s3,80002c74 <dirlookup+0x46>
    if(de.inum == 0)
    80002c9c:	fa045783          	lhu	a5,-96(s0)
    80002ca0:	d3e5                	beqz	a5,80002c80 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002ca2:	85da                	mv	a1,s6
    80002ca4:	8556                	mv	a0,s5
    80002ca6:	f73ff0ef          	jal	80002c18 <namecmp>
    80002caa:	f979                	bnez	a0,80002c80 <dirlookup+0x52>
      if(poff)
    80002cac:	000b8463          	beqz	s7,80002cb4 <dirlookup+0x86>
        *poff = off;
    80002cb0:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002cb4:	fa045583          	lhu	a1,-96(s0)
    80002cb8:	00092503          	lw	a0,0(s2)
    80002cbc:	82fff0ef          	jal	800024ea <iget>
    80002cc0:	a011                	j	80002cc4 <dirlookup+0x96>
  return 0;
    80002cc2:	4501                	li	a0,0
}
    80002cc4:	60e6                	ld	ra,88(sp)
    80002cc6:	6446                	ld	s0,80(sp)
    80002cc8:	64a6                	ld	s1,72(sp)
    80002cca:	6906                	ld	s2,64(sp)
    80002ccc:	79e2                	ld	s3,56(sp)
    80002cce:	7a42                	ld	s4,48(sp)
    80002cd0:	7aa2                	ld	s5,40(sp)
    80002cd2:	7b02                	ld	s6,32(sp)
    80002cd4:	6be2                	ld	s7,24(sp)
    80002cd6:	6125                	addi	sp,sp,96
    80002cd8:	8082                	ret

0000000080002cda <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002cda:	711d                	addi	sp,sp,-96
    80002cdc:	ec86                	sd	ra,88(sp)
    80002cde:	e8a2                	sd	s0,80(sp)
    80002ce0:	e4a6                	sd	s1,72(sp)
    80002ce2:	e0ca                	sd	s2,64(sp)
    80002ce4:	fc4e                	sd	s3,56(sp)
    80002ce6:	f852                	sd	s4,48(sp)
    80002ce8:	f456                	sd	s5,40(sp)
    80002cea:	f05a                	sd	s6,32(sp)
    80002cec:	ec5e                	sd	s7,24(sp)
    80002cee:	e862                	sd	s8,16(sp)
    80002cf0:	e466                	sd	s9,8(sp)
    80002cf2:	e06a                	sd	s10,0(sp)
    80002cf4:	1080                	addi	s0,sp,96
    80002cf6:	84aa                	mv	s1,a0
    80002cf8:	8b2e                	mv	s6,a1
    80002cfa:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002cfc:	00054703          	lbu	a4,0(a0)
    80002d00:	02f00793          	li	a5,47
    80002d04:	00f70f63          	beq	a4,a5,80002d22 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d08:	884fe0ef          	jal	80000d8c <myproc>
    80002d0c:	15053503          	ld	a0,336(a0)
    80002d10:	a85ff0ef          	jal	80002794 <idup>
    80002d14:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d16:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d1a:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002d1c:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d1e:	4b85                	li	s7,1
    80002d20:	a879                	j	80002dbe <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002d22:	4585                	li	a1,1
    80002d24:	852e                	mv	a0,a1
    80002d26:	fc4ff0ef          	jal	800024ea <iget>
    80002d2a:	8a2a                	mv	s4,a0
    80002d2c:	b7ed                	j	80002d16 <namex+0x3c>
      iunlockput(ip);
    80002d2e:	8552                	mv	a0,s4
    80002d30:	ca5ff0ef          	jal	800029d4 <iunlockput>
      return 0;
    80002d34:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d36:	8552                	mv	a0,s4
    80002d38:	60e6                	ld	ra,88(sp)
    80002d3a:	6446                	ld	s0,80(sp)
    80002d3c:	64a6                	ld	s1,72(sp)
    80002d3e:	6906                	ld	s2,64(sp)
    80002d40:	79e2                	ld	s3,56(sp)
    80002d42:	7a42                	ld	s4,48(sp)
    80002d44:	7aa2                	ld	s5,40(sp)
    80002d46:	7b02                	ld	s6,32(sp)
    80002d48:	6be2                	ld	s7,24(sp)
    80002d4a:	6c42                	ld	s8,16(sp)
    80002d4c:	6ca2                	ld	s9,8(sp)
    80002d4e:	6d02                	ld	s10,0(sp)
    80002d50:	6125                	addi	sp,sp,96
    80002d52:	8082                	ret
      iunlock(ip);
    80002d54:	8552                	mv	a0,s4
    80002d56:	b23ff0ef          	jal	80002878 <iunlock>
      return ip;
    80002d5a:	bff1                	j	80002d36 <namex+0x5c>
      iunlockput(ip);
    80002d5c:	8552                	mv	a0,s4
    80002d5e:	c77ff0ef          	jal	800029d4 <iunlockput>
      return 0;
    80002d62:	8a4e                	mv	s4,s3
    80002d64:	bfc9                	j	80002d36 <namex+0x5c>
  len = path - s;
    80002d66:	40998633          	sub	a2,s3,s1
    80002d6a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002d6e:	09ac5063          	bge	s8,s10,80002dee <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002d72:	8666                	mv	a2,s9
    80002d74:	85a6                	mv	a1,s1
    80002d76:	8556                	mv	a0,s5
    80002d78:	c62fd0ef          	jal	800001da <memmove>
    80002d7c:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d7e:	0004c783          	lbu	a5,0(s1)
    80002d82:	01279763          	bne	a5,s2,80002d90 <namex+0xb6>
    path++;
    80002d86:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d88:	0004c783          	lbu	a5,0(s1)
    80002d8c:	ff278de3          	beq	a5,s2,80002d86 <namex+0xac>
    ilock(ip);
    80002d90:	8552                	mv	a0,s4
    80002d92:	a39ff0ef          	jal	800027ca <ilock>
    if(ip->type != T_DIR){
    80002d96:	044a1783          	lh	a5,68(s4)
    80002d9a:	f9779ae3          	bne	a5,s7,80002d2e <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002d9e:	000b0563          	beqz	s6,80002da8 <namex+0xce>
    80002da2:	0004c783          	lbu	a5,0(s1)
    80002da6:	d7dd                	beqz	a5,80002d54 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002da8:	4601                	li	a2,0
    80002daa:	85d6                	mv	a1,s5
    80002dac:	8552                	mv	a0,s4
    80002dae:	e81ff0ef          	jal	80002c2e <dirlookup>
    80002db2:	89aa                	mv	s3,a0
    80002db4:	d545                	beqz	a0,80002d5c <namex+0x82>
    iunlockput(ip);
    80002db6:	8552                	mv	a0,s4
    80002db8:	c1dff0ef          	jal	800029d4 <iunlockput>
    ip = next;
    80002dbc:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002dbe:	0004c783          	lbu	a5,0(s1)
    80002dc2:	01279763          	bne	a5,s2,80002dd0 <namex+0xf6>
    path++;
    80002dc6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dc8:	0004c783          	lbu	a5,0(s1)
    80002dcc:	ff278de3          	beq	a5,s2,80002dc6 <namex+0xec>
  if(*path == 0)
    80002dd0:	cb8d                	beqz	a5,80002e02 <namex+0x128>
  while(*path != '/' && *path != 0)
    80002dd2:	0004c783          	lbu	a5,0(s1)
    80002dd6:	89a6                	mv	s3,s1
  len = path - s;
    80002dd8:	4d01                	li	s10,0
    80002dda:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002ddc:	01278963          	beq	a5,s2,80002dee <namex+0x114>
    80002de0:	d3d9                	beqz	a5,80002d66 <namex+0x8c>
    path++;
    80002de2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002de4:	0009c783          	lbu	a5,0(s3)
    80002de8:	ff279ce3          	bne	a5,s2,80002de0 <namex+0x106>
    80002dec:	bfad                	j	80002d66 <namex+0x8c>
    memmove(name, s, len);
    80002dee:	2601                	sext.w	a2,a2
    80002df0:	85a6                	mv	a1,s1
    80002df2:	8556                	mv	a0,s5
    80002df4:	be6fd0ef          	jal	800001da <memmove>
    name[len] = 0;
    80002df8:	9d56                	add	s10,s10,s5
    80002dfa:	000d0023          	sb	zero,0(s10)
    80002dfe:	84ce                	mv	s1,s3
    80002e00:	bfbd                	j	80002d7e <namex+0xa4>
  if(nameiparent){
    80002e02:	f20b0ae3          	beqz	s6,80002d36 <namex+0x5c>
    iput(ip);
    80002e06:	8552                	mv	a0,s4
    80002e08:	b45ff0ef          	jal	8000294c <iput>
    return 0;
    80002e0c:	4a01                	li	s4,0
    80002e0e:	b725                	j	80002d36 <namex+0x5c>

0000000080002e10 <dirlink>:
{
    80002e10:	715d                	addi	sp,sp,-80
    80002e12:	e486                	sd	ra,72(sp)
    80002e14:	e0a2                	sd	s0,64(sp)
    80002e16:	f84a                	sd	s2,48(sp)
    80002e18:	ec56                	sd	s5,24(sp)
    80002e1a:	e85a                	sd	s6,16(sp)
    80002e1c:	0880                	addi	s0,sp,80
    80002e1e:	892a                	mv	s2,a0
    80002e20:	8aae                	mv	s5,a1
    80002e22:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e24:	4601                	li	a2,0
    80002e26:	e09ff0ef          	jal	80002c2e <dirlookup>
    80002e2a:	ed1d                	bnez	a0,80002e68 <dirlink+0x58>
    80002e2c:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e2e:	04c92483          	lw	s1,76(s2)
    80002e32:	c4b9                	beqz	s1,80002e80 <dirlink+0x70>
    80002e34:	f44e                	sd	s3,40(sp)
    80002e36:	f052                	sd	s4,32(sp)
    80002e38:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e3a:	fb040a13          	addi	s4,s0,-80
    80002e3e:	49c1                	li	s3,16
    80002e40:	874e                	mv	a4,s3
    80002e42:	86a6                	mv	a3,s1
    80002e44:	8652                	mv	a2,s4
    80002e46:	4581                	li	a1,0
    80002e48:	854a                	mv	a0,s2
    80002e4a:	bd9ff0ef          	jal	80002a22 <readi>
    80002e4e:	03351163          	bne	a0,s3,80002e70 <dirlink+0x60>
    if(de.inum == 0)
    80002e52:	fb045783          	lhu	a5,-80(s0)
    80002e56:	c39d                	beqz	a5,80002e7c <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e58:	24c1                	addiw	s1,s1,16
    80002e5a:	04c92783          	lw	a5,76(s2)
    80002e5e:	fef4e1e3          	bltu	s1,a5,80002e40 <dirlink+0x30>
    80002e62:	79a2                	ld	s3,40(sp)
    80002e64:	7a02                	ld	s4,32(sp)
    80002e66:	a829                	j	80002e80 <dirlink+0x70>
    iput(ip);
    80002e68:	ae5ff0ef          	jal	8000294c <iput>
    return -1;
    80002e6c:	557d                	li	a0,-1
    80002e6e:	a83d                	j	80002eac <dirlink+0x9c>
      panic("dirlink read");
    80002e70:	00004517          	auipc	a0,0x4
    80002e74:	76850513          	addi	a0,a0,1896 # 800075d8 <etext+0x5d8>
    80002e78:	78e020ef          	jal	80005606 <panic>
    80002e7c:	79a2                	ld	s3,40(sp)
    80002e7e:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002e80:	4639                	li	a2,14
    80002e82:	85d6                	mv	a1,s5
    80002e84:	fb240513          	addi	a0,s0,-78
    80002e88:	c00fd0ef          	jal	80000288 <strncpy>
  de.inum = inum;
    80002e8c:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e90:	4741                	li	a4,16
    80002e92:	86a6                	mv	a3,s1
    80002e94:	fb040613          	addi	a2,s0,-80
    80002e98:	4581                	li	a1,0
    80002e9a:	854a                	mv	a0,s2
    80002e9c:	c79ff0ef          	jal	80002b14 <writei>
    80002ea0:	1541                	addi	a0,a0,-16
    80002ea2:	00a03533          	snez	a0,a0
    80002ea6:	40a0053b          	negw	a0,a0
    80002eaa:	74e2                	ld	s1,56(sp)
}
    80002eac:	60a6                	ld	ra,72(sp)
    80002eae:	6406                	ld	s0,64(sp)
    80002eb0:	7942                	ld	s2,48(sp)
    80002eb2:	6ae2                	ld	s5,24(sp)
    80002eb4:	6b42                	ld	s6,16(sp)
    80002eb6:	6161                	addi	sp,sp,80
    80002eb8:	8082                	ret

0000000080002eba <namei>:

struct inode*
namei(char *path)
{
    80002eba:	1101                	addi	sp,sp,-32
    80002ebc:	ec06                	sd	ra,24(sp)
    80002ebe:	e822                	sd	s0,16(sp)
    80002ec0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002ec2:	fe040613          	addi	a2,s0,-32
    80002ec6:	4581                	li	a1,0
    80002ec8:	e13ff0ef          	jal	80002cda <namex>
}
    80002ecc:	60e2                	ld	ra,24(sp)
    80002ece:	6442                	ld	s0,16(sp)
    80002ed0:	6105                	addi	sp,sp,32
    80002ed2:	8082                	ret

0000000080002ed4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002ed4:	1141                	addi	sp,sp,-16
    80002ed6:	e406                	sd	ra,8(sp)
    80002ed8:	e022                	sd	s0,0(sp)
    80002eda:	0800                	addi	s0,sp,16
    80002edc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002ede:	4585                	li	a1,1
    80002ee0:	dfbff0ef          	jal	80002cda <namex>
}
    80002ee4:	60a2                	ld	ra,8(sp)
    80002ee6:	6402                	ld	s0,0(sp)
    80002ee8:	0141                	addi	sp,sp,16
    80002eea:	8082                	ret

0000000080002eec <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002eec:	1101                	addi	sp,sp,-32
    80002eee:	ec06                	sd	ra,24(sp)
    80002ef0:	e822                	sd	s0,16(sp)
    80002ef2:	e426                	sd	s1,8(sp)
    80002ef4:	e04a                	sd	s2,0(sp)
    80002ef6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002ef8:	00018917          	auipc	s2,0x18
    80002efc:	8d890913          	addi	s2,s2,-1832 # 8001a7d0 <log>
    80002f00:	01892583          	lw	a1,24(s2)
    80002f04:	02892503          	lw	a0,40(s2)
    80002f08:	9b0ff0ef          	jal	800020b8 <bread>
    80002f0c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f0e:	02c92603          	lw	a2,44(s2)
    80002f12:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f14:	00c05f63          	blez	a2,80002f32 <write_head+0x46>
    80002f18:	00018717          	auipc	a4,0x18
    80002f1c:	8e870713          	addi	a4,a4,-1816 # 8001a800 <log+0x30>
    80002f20:	87aa                	mv	a5,a0
    80002f22:	060a                	slli	a2,a2,0x2
    80002f24:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f26:	4314                	lw	a3,0(a4)
    80002f28:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f2a:	0711                	addi	a4,a4,4
    80002f2c:	0791                	addi	a5,a5,4
    80002f2e:	fec79ce3          	bne	a5,a2,80002f26 <write_head+0x3a>
  }
  bwrite(buf);
    80002f32:	8526                	mv	a0,s1
    80002f34:	a5aff0ef          	jal	8000218e <bwrite>
  brelse(buf);
    80002f38:	8526                	mv	a0,s1
    80002f3a:	a86ff0ef          	jal	800021c0 <brelse>
}
    80002f3e:	60e2                	ld	ra,24(sp)
    80002f40:	6442                	ld	s0,16(sp)
    80002f42:	64a2                	ld	s1,8(sp)
    80002f44:	6902                	ld	s2,0(sp)
    80002f46:	6105                	addi	sp,sp,32
    80002f48:	8082                	ret

0000000080002f4a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f4a:	00018797          	auipc	a5,0x18
    80002f4e:	8b27a783          	lw	a5,-1870(a5) # 8001a7fc <log+0x2c>
    80002f52:	0af05263          	blez	a5,80002ff6 <install_trans+0xac>
{
    80002f56:	715d                	addi	sp,sp,-80
    80002f58:	e486                	sd	ra,72(sp)
    80002f5a:	e0a2                	sd	s0,64(sp)
    80002f5c:	fc26                	sd	s1,56(sp)
    80002f5e:	f84a                	sd	s2,48(sp)
    80002f60:	f44e                	sd	s3,40(sp)
    80002f62:	f052                	sd	s4,32(sp)
    80002f64:	ec56                	sd	s5,24(sp)
    80002f66:	e85a                	sd	s6,16(sp)
    80002f68:	e45e                	sd	s7,8(sp)
    80002f6a:	0880                	addi	s0,sp,80
    80002f6c:	8b2a                	mv	s6,a0
    80002f6e:	00018a97          	auipc	s5,0x18
    80002f72:	892a8a93          	addi	s5,s5,-1902 # 8001a800 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f76:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f78:	00018997          	auipc	s3,0x18
    80002f7c:	85898993          	addi	s3,s3,-1960 # 8001a7d0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f80:	40000b93          	li	s7,1024
    80002f84:	a829                	j	80002f9e <install_trans+0x54>
    brelse(lbuf);
    80002f86:	854a                	mv	a0,s2
    80002f88:	a38ff0ef          	jal	800021c0 <brelse>
    brelse(dbuf);
    80002f8c:	8526                	mv	a0,s1
    80002f8e:	a32ff0ef          	jal	800021c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f92:	2a05                	addiw	s4,s4,1
    80002f94:	0a91                	addi	s5,s5,4
    80002f96:	02c9a783          	lw	a5,44(s3)
    80002f9a:	04fa5363          	bge	s4,a5,80002fe0 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f9e:	0189a583          	lw	a1,24(s3)
    80002fa2:	014585bb          	addw	a1,a1,s4
    80002fa6:	2585                	addiw	a1,a1,1
    80002fa8:	0289a503          	lw	a0,40(s3)
    80002fac:	90cff0ef          	jal	800020b8 <bread>
    80002fb0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002fb2:	000aa583          	lw	a1,0(s5)
    80002fb6:	0289a503          	lw	a0,40(s3)
    80002fba:	8feff0ef          	jal	800020b8 <bread>
    80002fbe:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fc0:	865e                	mv	a2,s7
    80002fc2:	05890593          	addi	a1,s2,88
    80002fc6:	05850513          	addi	a0,a0,88
    80002fca:	a10fd0ef          	jal	800001da <memmove>
    bwrite(dbuf);  // write dst to disk
    80002fce:	8526                	mv	a0,s1
    80002fd0:	9beff0ef          	jal	8000218e <bwrite>
    if(recovering == 0)
    80002fd4:	fa0b19e3          	bnez	s6,80002f86 <install_trans+0x3c>
      bunpin(dbuf);
    80002fd8:	8526                	mv	a0,s1
    80002fda:	a9eff0ef          	jal	80002278 <bunpin>
    80002fde:	b765                	j	80002f86 <install_trans+0x3c>
}
    80002fe0:	60a6                	ld	ra,72(sp)
    80002fe2:	6406                	ld	s0,64(sp)
    80002fe4:	74e2                	ld	s1,56(sp)
    80002fe6:	7942                	ld	s2,48(sp)
    80002fe8:	79a2                	ld	s3,40(sp)
    80002fea:	7a02                	ld	s4,32(sp)
    80002fec:	6ae2                	ld	s5,24(sp)
    80002fee:	6b42                	ld	s6,16(sp)
    80002ff0:	6ba2                	ld	s7,8(sp)
    80002ff2:	6161                	addi	sp,sp,80
    80002ff4:	8082                	ret
    80002ff6:	8082                	ret

0000000080002ff8 <initlog>:
{
    80002ff8:	7179                	addi	sp,sp,-48
    80002ffa:	f406                	sd	ra,40(sp)
    80002ffc:	f022                	sd	s0,32(sp)
    80002ffe:	ec26                	sd	s1,24(sp)
    80003000:	e84a                	sd	s2,16(sp)
    80003002:	e44e                	sd	s3,8(sp)
    80003004:	1800                	addi	s0,sp,48
    80003006:	892a                	mv	s2,a0
    80003008:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000300a:	00017497          	auipc	s1,0x17
    8000300e:	7c648493          	addi	s1,s1,1990 # 8001a7d0 <log>
    80003012:	00004597          	auipc	a1,0x4
    80003016:	5d658593          	addi	a1,a1,1494 # 800075e8 <etext+0x5e8>
    8000301a:	8526                	mv	a0,s1
    8000301c:	095020ef          	jal	800058b0 <initlock>
  log.start = sb->logstart;
    80003020:	0149a583          	lw	a1,20(s3)
    80003024:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003026:	0109a783          	lw	a5,16(s3)
    8000302a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000302c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003030:	854a                	mv	a0,s2
    80003032:	886ff0ef          	jal	800020b8 <bread>
  log.lh.n = lh->n;
    80003036:	4d30                	lw	a2,88(a0)
    80003038:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000303a:	00c05f63          	blez	a2,80003058 <initlog+0x60>
    8000303e:	87aa                	mv	a5,a0
    80003040:	00017717          	auipc	a4,0x17
    80003044:	7c070713          	addi	a4,a4,1984 # 8001a800 <log+0x30>
    80003048:	060a                	slli	a2,a2,0x2
    8000304a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000304c:	4ff4                	lw	a3,92(a5)
    8000304e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003050:	0791                	addi	a5,a5,4
    80003052:	0711                	addi	a4,a4,4
    80003054:	fec79ce3          	bne	a5,a2,8000304c <initlog+0x54>
  brelse(buf);
    80003058:	968ff0ef          	jal	800021c0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000305c:	4505                	li	a0,1
    8000305e:	eedff0ef          	jal	80002f4a <install_trans>
  log.lh.n = 0;
    80003062:	00017797          	auipc	a5,0x17
    80003066:	7807ad23          	sw	zero,1946(a5) # 8001a7fc <log+0x2c>
  write_head(); // clear the log
    8000306a:	e83ff0ef          	jal	80002eec <write_head>
}
    8000306e:	70a2                	ld	ra,40(sp)
    80003070:	7402                	ld	s0,32(sp)
    80003072:	64e2                	ld	s1,24(sp)
    80003074:	6942                	ld	s2,16(sp)
    80003076:	69a2                	ld	s3,8(sp)
    80003078:	6145                	addi	sp,sp,48
    8000307a:	8082                	ret

000000008000307c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000307c:	1101                	addi	sp,sp,-32
    8000307e:	ec06                	sd	ra,24(sp)
    80003080:	e822                	sd	s0,16(sp)
    80003082:	e426                	sd	s1,8(sp)
    80003084:	e04a                	sd	s2,0(sp)
    80003086:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003088:	00017517          	auipc	a0,0x17
    8000308c:	74850513          	addi	a0,a0,1864 # 8001a7d0 <log>
    80003090:	0a5020ef          	jal	80005934 <acquire>
  while(1){
    if(log.committing){
    80003094:	00017497          	auipc	s1,0x17
    80003098:	73c48493          	addi	s1,s1,1852 # 8001a7d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000309c:	4979                	li	s2,30
    8000309e:	a029                	j	800030a8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030a0:	85a6                	mv	a1,s1
    800030a2:	8526                	mv	a0,s1
    800030a4:	ac2fe0ef          	jal	80001366 <sleep>
    if(log.committing){
    800030a8:	50dc                	lw	a5,36(s1)
    800030aa:	fbfd                	bnez	a5,800030a0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800030ac:	5098                	lw	a4,32(s1)
    800030ae:	2705                	addiw	a4,a4,1
    800030b0:	0027179b          	slliw	a5,a4,0x2
    800030b4:	9fb9                	addw	a5,a5,a4
    800030b6:	0017979b          	slliw	a5,a5,0x1
    800030ba:	54d4                	lw	a3,44(s1)
    800030bc:	9fb5                	addw	a5,a5,a3
    800030be:	00f95763          	bge	s2,a5,800030cc <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800030c2:	85a6                	mv	a1,s1
    800030c4:	8526                	mv	a0,s1
    800030c6:	aa0fe0ef          	jal	80001366 <sleep>
    800030ca:	bff9                	j	800030a8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800030cc:	00017517          	auipc	a0,0x17
    800030d0:	70450513          	addi	a0,a0,1796 # 8001a7d0 <log>
    800030d4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800030d6:	0f3020ef          	jal	800059c8 <release>
      break;
    }
  }
}
    800030da:	60e2                	ld	ra,24(sp)
    800030dc:	6442                	ld	s0,16(sp)
    800030de:	64a2                	ld	s1,8(sp)
    800030e0:	6902                	ld	s2,0(sp)
    800030e2:	6105                	addi	sp,sp,32
    800030e4:	8082                	ret

00000000800030e6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800030e6:	7139                	addi	sp,sp,-64
    800030e8:	fc06                	sd	ra,56(sp)
    800030ea:	f822                	sd	s0,48(sp)
    800030ec:	f426                	sd	s1,40(sp)
    800030ee:	f04a                	sd	s2,32(sp)
    800030f0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800030f2:	00017497          	auipc	s1,0x17
    800030f6:	6de48493          	addi	s1,s1,1758 # 8001a7d0 <log>
    800030fa:	8526                	mv	a0,s1
    800030fc:	039020ef          	jal	80005934 <acquire>
  log.outstanding -= 1;
    80003100:	509c                	lw	a5,32(s1)
    80003102:	37fd                	addiw	a5,a5,-1
    80003104:	893e                	mv	s2,a5
    80003106:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003108:	50dc                	lw	a5,36(s1)
    8000310a:	ef9d                	bnez	a5,80003148 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    8000310c:	04091863          	bnez	s2,8000315c <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003110:	00017497          	auipc	s1,0x17
    80003114:	6c048493          	addi	s1,s1,1728 # 8001a7d0 <log>
    80003118:	4785                	li	a5,1
    8000311a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000311c:	8526                	mv	a0,s1
    8000311e:	0ab020ef          	jal	800059c8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003122:	54dc                	lw	a5,44(s1)
    80003124:	04f04c63          	bgtz	a5,8000317c <end_op+0x96>
    acquire(&log.lock);
    80003128:	00017497          	auipc	s1,0x17
    8000312c:	6a848493          	addi	s1,s1,1704 # 8001a7d0 <log>
    80003130:	8526                	mv	a0,s1
    80003132:	003020ef          	jal	80005934 <acquire>
    log.committing = 0;
    80003136:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000313a:	8526                	mv	a0,s1
    8000313c:	a76fe0ef          	jal	800013b2 <wakeup>
    release(&log.lock);
    80003140:	8526                	mv	a0,s1
    80003142:	087020ef          	jal	800059c8 <release>
}
    80003146:	a02d                	j	80003170 <end_op+0x8a>
    80003148:	ec4e                	sd	s3,24(sp)
    8000314a:	e852                	sd	s4,16(sp)
    8000314c:	e456                	sd	s5,8(sp)
    8000314e:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003150:	00004517          	auipc	a0,0x4
    80003154:	4a050513          	addi	a0,a0,1184 # 800075f0 <etext+0x5f0>
    80003158:	4ae020ef          	jal	80005606 <panic>
    wakeup(&log);
    8000315c:	00017497          	auipc	s1,0x17
    80003160:	67448493          	addi	s1,s1,1652 # 8001a7d0 <log>
    80003164:	8526                	mv	a0,s1
    80003166:	a4cfe0ef          	jal	800013b2 <wakeup>
  release(&log.lock);
    8000316a:	8526                	mv	a0,s1
    8000316c:	05d020ef          	jal	800059c8 <release>
}
    80003170:	70e2                	ld	ra,56(sp)
    80003172:	7442                	ld	s0,48(sp)
    80003174:	74a2                	ld	s1,40(sp)
    80003176:	7902                	ld	s2,32(sp)
    80003178:	6121                	addi	sp,sp,64
    8000317a:	8082                	ret
    8000317c:	ec4e                	sd	s3,24(sp)
    8000317e:	e852                	sd	s4,16(sp)
    80003180:	e456                	sd	s5,8(sp)
    80003182:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003184:	00017a97          	auipc	s5,0x17
    80003188:	67ca8a93          	addi	s5,s5,1660 # 8001a800 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000318c:	00017a17          	auipc	s4,0x17
    80003190:	644a0a13          	addi	s4,s4,1604 # 8001a7d0 <log>
    memmove(to->data, from->data, BSIZE);
    80003194:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003198:	018a2583          	lw	a1,24(s4)
    8000319c:	012585bb          	addw	a1,a1,s2
    800031a0:	2585                	addiw	a1,a1,1
    800031a2:	028a2503          	lw	a0,40(s4)
    800031a6:	f13fe0ef          	jal	800020b8 <bread>
    800031aa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031ac:	000aa583          	lw	a1,0(s5)
    800031b0:	028a2503          	lw	a0,40(s4)
    800031b4:	f05fe0ef          	jal	800020b8 <bread>
    800031b8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031ba:	865a                	mv	a2,s6
    800031bc:	05850593          	addi	a1,a0,88
    800031c0:	05848513          	addi	a0,s1,88
    800031c4:	816fd0ef          	jal	800001da <memmove>
    bwrite(to);  // write the log
    800031c8:	8526                	mv	a0,s1
    800031ca:	fc5fe0ef          	jal	8000218e <bwrite>
    brelse(from);
    800031ce:	854e                	mv	a0,s3
    800031d0:	ff1fe0ef          	jal	800021c0 <brelse>
    brelse(to);
    800031d4:	8526                	mv	a0,s1
    800031d6:	febfe0ef          	jal	800021c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031da:	2905                	addiw	s2,s2,1
    800031dc:	0a91                	addi	s5,s5,4
    800031de:	02ca2783          	lw	a5,44(s4)
    800031e2:	faf94be3          	blt	s2,a5,80003198 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800031e6:	d07ff0ef          	jal	80002eec <write_head>
    install_trans(0); // Now install writes to home locations
    800031ea:	4501                	li	a0,0
    800031ec:	d5fff0ef          	jal	80002f4a <install_trans>
    log.lh.n = 0;
    800031f0:	00017797          	auipc	a5,0x17
    800031f4:	6007a623          	sw	zero,1548(a5) # 8001a7fc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800031f8:	cf5ff0ef          	jal	80002eec <write_head>
    800031fc:	69e2                	ld	s3,24(sp)
    800031fe:	6a42                	ld	s4,16(sp)
    80003200:	6aa2                	ld	s5,8(sp)
    80003202:	6b02                	ld	s6,0(sp)
    80003204:	b715                	j	80003128 <end_op+0x42>

0000000080003206 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003206:	1101                	addi	sp,sp,-32
    80003208:	ec06                	sd	ra,24(sp)
    8000320a:	e822                	sd	s0,16(sp)
    8000320c:	e426                	sd	s1,8(sp)
    8000320e:	e04a                	sd	s2,0(sp)
    80003210:	1000                	addi	s0,sp,32
    80003212:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003214:	00017917          	auipc	s2,0x17
    80003218:	5bc90913          	addi	s2,s2,1468 # 8001a7d0 <log>
    8000321c:	854a                	mv	a0,s2
    8000321e:	716020ef          	jal	80005934 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003222:	02c92603          	lw	a2,44(s2)
    80003226:	47f5                	li	a5,29
    80003228:	06c7c363          	blt	a5,a2,8000328e <log_write+0x88>
    8000322c:	00017797          	auipc	a5,0x17
    80003230:	5c07a783          	lw	a5,1472(a5) # 8001a7ec <log+0x1c>
    80003234:	37fd                	addiw	a5,a5,-1
    80003236:	04f65c63          	bge	a2,a5,8000328e <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000323a:	00017797          	auipc	a5,0x17
    8000323e:	5b67a783          	lw	a5,1462(a5) # 8001a7f0 <log+0x20>
    80003242:	04f05c63          	blez	a5,8000329a <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003246:	4781                	li	a5,0
    80003248:	04c05f63          	blez	a2,800032a6 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000324c:	44cc                	lw	a1,12(s1)
    8000324e:	00017717          	auipc	a4,0x17
    80003252:	5b270713          	addi	a4,a4,1458 # 8001a800 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003256:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003258:	4314                	lw	a3,0(a4)
    8000325a:	04b68663          	beq	a3,a1,800032a6 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000325e:	2785                	addiw	a5,a5,1
    80003260:	0711                	addi	a4,a4,4
    80003262:	fef61be3          	bne	a2,a5,80003258 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003266:	0621                	addi	a2,a2,8
    80003268:	060a                	slli	a2,a2,0x2
    8000326a:	00017797          	auipc	a5,0x17
    8000326e:	56678793          	addi	a5,a5,1382 # 8001a7d0 <log>
    80003272:	97b2                	add	a5,a5,a2
    80003274:	44d8                	lw	a4,12(s1)
    80003276:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003278:	8526                	mv	a0,s1
    8000327a:	fcbfe0ef          	jal	80002244 <bpin>
    log.lh.n++;
    8000327e:	00017717          	auipc	a4,0x17
    80003282:	55270713          	addi	a4,a4,1362 # 8001a7d0 <log>
    80003286:	575c                	lw	a5,44(a4)
    80003288:	2785                	addiw	a5,a5,1
    8000328a:	d75c                	sw	a5,44(a4)
    8000328c:	a80d                	j	800032be <log_write+0xb8>
    panic("too big a transaction");
    8000328e:	00004517          	auipc	a0,0x4
    80003292:	37250513          	addi	a0,a0,882 # 80007600 <etext+0x600>
    80003296:	370020ef          	jal	80005606 <panic>
    panic("log_write outside of trans");
    8000329a:	00004517          	auipc	a0,0x4
    8000329e:	37e50513          	addi	a0,a0,894 # 80007618 <etext+0x618>
    800032a2:	364020ef          	jal	80005606 <panic>
  log.lh.block[i] = b->blockno;
    800032a6:	00878693          	addi	a3,a5,8
    800032aa:	068a                	slli	a3,a3,0x2
    800032ac:	00017717          	auipc	a4,0x17
    800032b0:	52470713          	addi	a4,a4,1316 # 8001a7d0 <log>
    800032b4:	9736                	add	a4,a4,a3
    800032b6:	44d4                	lw	a3,12(s1)
    800032b8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032ba:	faf60fe3          	beq	a2,a5,80003278 <log_write+0x72>
  }
  release(&log.lock);
    800032be:	00017517          	auipc	a0,0x17
    800032c2:	51250513          	addi	a0,a0,1298 # 8001a7d0 <log>
    800032c6:	702020ef          	jal	800059c8 <release>
}
    800032ca:	60e2                	ld	ra,24(sp)
    800032cc:	6442                	ld	s0,16(sp)
    800032ce:	64a2                	ld	s1,8(sp)
    800032d0:	6902                	ld	s2,0(sp)
    800032d2:	6105                	addi	sp,sp,32
    800032d4:	8082                	ret

00000000800032d6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800032d6:	1101                	addi	sp,sp,-32
    800032d8:	ec06                	sd	ra,24(sp)
    800032da:	e822                	sd	s0,16(sp)
    800032dc:	e426                	sd	s1,8(sp)
    800032de:	e04a                	sd	s2,0(sp)
    800032e0:	1000                	addi	s0,sp,32
    800032e2:	84aa                	mv	s1,a0
    800032e4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800032e6:	00004597          	auipc	a1,0x4
    800032ea:	35258593          	addi	a1,a1,850 # 80007638 <etext+0x638>
    800032ee:	0521                	addi	a0,a0,8
    800032f0:	5c0020ef          	jal	800058b0 <initlock>
  lk->name = name;
    800032f4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800032f8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032fc:	0204a423          	sw	zero,40(s1)
}
    80003300:	60e2                	ld	ra,24(sp)
    80003302:	6442                	ld	s0,16(sp)
    80003304:	64a2                	ld	s1,8(sp)
    80003306:	6902                	ld	s2,0(sp)
    80003308:	6105                	addi	sp,sp,32
    8000330a:	8082                	ret

000000008000330c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000330c:	1101                	addi	sp,sp,-32
    8000330e:	ec06                	sd	ra,24(sp)
    80003310:	e822                	sd	s0,16(sp)
    80003312:	e426                	sd	s1,8(sp)
    80003314:	e04a                	sd	s2,0(sp)
    80003316:	1000                	addi	s0,sp,32
    80003318:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000331a:	00850913          	addi	s2,a0,8
    8000331e:	854a                	mv	a0,s2
    80003320:	614020ef          	jal	80005934 <acquire>
  while (lk->locked) {
    80003324:	409c                	lw	a5,0(s1)
    80003326:	c799                	beqz	a5,80003334 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003328:	85ca                	mv	a1,s2
    8000332a:	8526                	mv	a0,s1
    8000332c:	83afe0ef          	jal	80001366 <sleep>
  while (lk->locked) {
    80003330:	409c                	lw	a5,0(s1)
    80003332:	fbfd                	bnez	a5,80003328 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003334:	4785                	li	a5,1
    80003336:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003338:	a55fd0ef          	jal	80000d8c <myproc>
    8000333c:	591c                	lw	a5,48(a0)
    8000333e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003340:	854a                	mv	a0,s2
    80003342:	686020ef          	jal	800059c8 <release>
}
    80003346:	60e2                	ld	ra,24(sp)
    80003348:	6442                	ld	s0,16(sp)
    8000334a:	64a2                	ld	s1,8(sp)
    8000334c:	6902                	ld	s2,0(sp)
    8000334e:	6105                	addi	sp,sp,32
    80003350:	8082                	ret

0000000080003352 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003352:	1101                	addi	sp,sp,-32
    80003354:	ec06                	sd	ra,24(sp)
    80003356:	e822                	sd	s0,16(sp)
    80003358:	e426                	sd	s1,8(sp)
    8000335a:	e04a                	sd	s2,0(sp)
    8000335c:	1000                	addi	s0,sp,32
    8000335e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003360:	00850913          	addi	s2,a0,8
    80003364:	854a                	mv	a0,s2
    80003366:	5ce020ef          	jal	80005934 <acquire>
  lk->locked = 0;
    8000336a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000336e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003372:	8526                	mv	a0,s1
    80003374:	83efe0ef          	jal	800013b2 <wakeup>
  release(&lk->lk);
    80003378:	854a                	mv	a0,s2
    8000337a:	64e020ef          	jal	800059c8 <release>
}
    8000337e:	60e2                	ld	ra,24(sp)
    80003380:	6442                	ld	s0,16(sp)
    80003382:	64a2                	ld	s1,8(sp)
    80003384:	6902                	ld	s2,0(sp)
    80003386:	6105                	addi	sp,sp,32
    80003388:	8082                	ret

000000008000338a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000338a:	7179                	addi	sp,sp,-48
    8000338c:	f406                	sd	ra,40(sp)
    8000338e:	f022                	sd	s0,32(sp)
    80003390:	ec26                	sd	s1,24(sp)
    80003392:	e84a                	sd	s2,16(sp)
    80003394:	1800                	addi	s0,sp,48
    80003396:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003398:	00850913          	addi	s2,a0,8
    8000339c:	854a                	mv	a0,s2
    8000339e:	596020ef          	jal	80005934 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033a2:	409c                	lw	a5,0(s1)
    800033a4:	ef81                	bnez	a5,800033bc <holdingsleep+0x32>
    800033a6:	4481                	li	s1,0
  release(&lk->lk);
    800033a8:	854a                	mv	a0,s2
    800033aa:	61e020ef          	jal	800059c8 <release>
  return r;
}
    800033ae:	8526                	mv	a0,s1
    800033b0:	70a2                	ld	ra,40(sp)
    800033b2:	7402                	ld	s0,32(sp)
    800033b4:	64e2                	ld	s1,24(sp)
    800033b6:	6942                	ld	s2,16(sp)
    800033b8:	6145                	addi	sp,sp,48
    800033ba:	8082                	ret
    800033bc:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800033be:	0284a983          	lw	s3,40(s1)
    800033c2:	9cbfd0ef          	jal	80000d8c <myproc>
    800033c6:	5904                	lw	s1,48(a0)
    800033c8:	413484b3          	sub	s1,s1,s3
    800033cc:	0014b493          	seqz	s1,s1
    800033d0:	69a2                	ld	s3,8(sp)
    800033d2:	bfd9                	j	800033a8 <holdingsleep+0x1e>

00000000800033d4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800033d4:	1141                	addi	sp,sp,-16
    800033d6:	e406                	sd	ra,8(sp)
    800033d8:	e022                	sd	s0,0(sp)
    800033da:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800033dc:	00004597          	auipc	a1,0x4
    800033e0:	26c58593          	addi	a1,a1,620 # 80007648 <etext+0x648>
    800033e4:	00017517          	auipc	a0,0x17
    800033e8:	53450513          	addi	a0,a0,1332 # 8001a918 <ftable>
    800033ec:	4c4020ef          	jal	800058b0 <initlock>
}
    800033f0:	60a2                	ld	ra,8(sp)
    800033f2:	6402                	ld	s0,0(sp)
    800033f4:	0141                	addi	sp,sp,16
    800033f6:	8082                	ret

00000000800033f8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800033f8:	1101                	addi	sp,sp,-32
    800033fa:	ec06                	sd	ra,24(sp)
    800033fc:	e822                	sd	s0,16(sp)
    800033fe:	e426                	sd	s1,8(sp)
    80003400:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003402:	00017517          	auipc	a0,0x17
    80003406:	51650513          	addi	a0,a0,1302 # 8001a918 <ftable>
    8000340a:	52a020ef          	jal	80005934 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000340e:	00017497          	auipc	s1,0x17
    80003412:	52248493          	addi	s1,s1,1314 # 8001a930 <ftable+0x18>
    80003416:	00018717          	auipc	a4,0x18
    8000341a:	4ba70713          	addi	a4,a4,1210 # 8001b8d0 <disk>
    if(f->ref == 0){
    8000341e:	40dc                	lw	a5,4(s1)
    80003420:	cf89                	beqz	a5,8000343a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003422:	02848493          	addi	s1,s1,40
    80003426:	fee49ce3          	bne	s1,a4,8000341e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000342a:	00017517          	auipc	a0,0x17
    8000342e:	4ee50513          	addi	a0,a0,1262 # 8001a918 <ftable>
    80003432:	596020ef          	jal	800059c8 <release>
  return 0;
    80003436:	4481                	li	s1,0
    80003438:	a809                	j	8000344a <filealloc+0x52>
      f->ref = 1;
    8000343a:	4785                	li	a5,1
    8000343c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000343e:	00017517          	auipc	a0,0x17
    80003442:	4da50513          	addi	a0,a0,1242 # 8001a918 <ftable>
    80003446:	582020ef          	jal	800059c8 <release>
}
    8000344a:	8526                	mv	a0,s1
    8000344c:	60e2                	ld	ra,24(sp)
    8000344e:	6442                	ld	s0,16(sp)
    80003450:	64a2                	ld	s1,8(sp)
    80003452:	6105                	addi	sp,sp,32
    80003454:	8082                	ret

0000000080003456 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003456:	1101                	addi	sp,sp,-32
    80003458:	ec06                	sd	ra,24(sp)
    8000345a:	e822                	sd	s0,16(sp)
    8000345c:	e426                	sd	s1,8(sp)
    8000345e:	1000                	addi	s0,sp,32
    80003460:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003462:	00017517          	auipc	a0,0x17
    80003466:	4b650513          	addi	a0,a0,1206 # 8001a918 <ftable>
    8000346a:	4ca020ef          	jal	80005934 <acquire>
  if(f->ref < 1)
    8000346e:	40dc                	lw	a5,4(s1)
    80003470:	02f05063          	blez	a5,80003490 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003474:	2785                	addiw	a5,a5,1
    80003476:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003478:	00017517          	auipc	a0,0x17
    8000347c:	4a050513          	addi	a0,a0,1184 # 8001a918 <ftable>
    80003480:	548020ef          	jal	800059c8 <release>
  return f;
}
    80003484:	8526                	mv	a0,s1
    80003486:	60e2                	ld	ra,24(sp)
    80003488:	6442                	ld	s0,16(sp)
    8000348a:	64a2                	ld	s1,8(sp)
    8000348c:	6105                	addi	sp,sp,32
    8000348e:	8082                	ret
    panic("filedup");
    80003490:	00004517          	auipc	a0,0x4
    80003494:	1c050513          	addi	a0,a0,448 # 80007650 <etext+0x650>
    80003498:	16e020ef          	jal	80005606 <panic>

000000008000349c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000349c:	7139                	addi	sp,sp,-64
    8000349e:	fc06                	sd	ra,56(sp)
    800034a0:	f822                	sd	s0,48(sp)
    800034a2:	f426                	sd	s1,40(sp)
    800034a4:	0080                	addi	s0,sp,64
    800034a6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800034a8:	00017517          	auipc	a0,0x17
    800034ac:	47050513          	addi	a0,a0,1136 # 8001a918 <ftable>
    800034b0:	484020ef          	jal	80005934 <acquire>
  if(f->ref < 1)
    800034b4:	40dc                	lw	a5,4(s1)
    800034b6:	04f05863          	blez	a5,80003506 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    800034ba:	37fd                	addiw	a5,a5,-1
    800034bc:	c0dc                	sw	a5,4(s1)
    800034be:	04f04e63          	bgtz	a5,8000351a <fileclose+0x7e>
    800034c2:	f04a                	sd	s2,32(sp)
    800034c4:	ec4e                	sd	s3,24(sp)
    800034c6:	e852                	sd	s4,16(sp)
    800034c8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800034ca:	0004a903          	lw	s2,0(s1)
    800034ce:	0094ca83          	lbu	s5,9(s1)
    800034d2:	0104ba03          	ld	s4,16(s1)
    800034d6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800034da:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800034de:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800034e2:	00017517          	auipc	a0,0x17
    800034e6:	43650513          	addi	a0,a0,1078 # 8001a918 <ftable>
    800034ea:	4de020ef          	jal	800059c8 <release>

  if(ff.type == FD_PIPE){
    800034ee:	4785                	li	a5,1
    800034f0:	04f90063          	beq	s2,a5,80003530 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800034f4:	3979                	addiw	s2,s2,-2
    800034f6:	4785                	li	a5,1
    800034f8:	0527f563          	bgeu	a5,s2,80003542 <fileclose+0xa6>
    800034fc:	7902                	ld	s2,32(sp)
    800034fe:	69e2                	ld	s3,24(sp)
    80003500:	6a42                	ld	s4,16(sp)
    80003502:	6aa2                	ld	s5,8(sp)
    80003504:	a00d                	j	80003526 <fileclose+0x8a>
    80003506:	f04a                	sd	s2,32(sp)
    80003508:	ec4e                	sd	s3,24(sp)
    8000350a:	e852                	sd	s4,16(sp)
    8000350c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000350e:	00004517          	auipc	a0,0x4
    80003512:	14a50513          	addi	a0,a0,330 # 80007658 <etext+0x658>
    80003516:	0f0020ef          	jal	80005606 <panic>
    release(&ftable.lock);
    8000351a:	00017517          	auipc	a0,0x17
    8000351e:	3fe50513          	addi	a0,a0,1022 # 8001a918 <ftable>
    80003522:	4a6020ef          	jal	800059c8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003526:	70e2                	ld	ra,56(sp)
    80003528:	7442                	ld	s0,48(sp)
    8000352a:	74a2                	ld	s1,40(sp)
    8000352c:	6121                	addi	sp,sp,64
    8000352e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003530:	85d6                	mv	a1,s5
    80003532:	8552                	mv	a0,s4
    80003534:	394000ef          	jal	800038c8 <pipeclose>
    80003538:	7902                	ld	s2,32(sp)
    8000353a:	69e2                	ld	s3,24(sp)
    8000353c:	6a42                	ld	s4,16(sp)
    8000353e:	6aa2                	ld	s5,8(sp)
    80003540:	b7dd                	j	80003526 <fileclose+0x8a>
    begin_op();
    80003542:	b3bff0ef          	jal	8000307c <begin_op>
    iput(ff.ip);
    80003546:	854e                	mv	a0,s3
    80003548:	c04ff0ef          	jal	8000294c <iput>
    end_op();
    8000354c:	b9bff0ef          	jal	800030e6 <end_op>
    80003550:	7902                	ld	s2,32(sp)
    80003552:	69e2                	ld	s3,24(sp)
    80003554:	6a42                	ld	s4,16(sp)
    80003556:	6aa2                	ld	s5,8(sp)
    80003558:	b7f9                	j	80003526 <fileclose+0x8a>

000000008000355a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000355a:	715d                	addi	sp,sp,-80
    8000355c:	e486                	sd	ra,72(sp)
    8000355e:	e0a2                	sd	s0,64(sp)
    80003560:	fc26                	sd	s1,56(sp)
    80003562:	f44e                	sd	s3,40(sp)
    80003564:	0880                	addi	s0,sp,80
    80003566:	84aa                	mv	s1,a0
    80003568:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000356a:	823fd0ef          	jal	80000d8c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000356e:	409c                	lw	a5,0(s1)
    80003570:	37f9                	addiw	a5,a5,-2
    80003572:	4705                	li	a4,1
    80003574:	04f76263          	bltu	a4,a5,800035b8 <filestat+0x5e>
    80003578:	f84a                	sd	s2,48(sp)
    8000357a:	f052                	sd	s4,32(sp)
    8000357c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000357e:	6c88                	ld	a0,24(s1)
    80003580:	a4aff0ef          	jal	800027ca <ilock>
    stati(f->ip, &st);
    80003584:	fb840a13          	addi	s4,s0,-72
    80003588:	85d2                	mv	a1,s4
    8000358a:	6c88                	ld	a0,24(s1)
    8000358c:	c68ff0ef          	jal	800029f4 <stati>
    iunlock(f->ip);
    80003590:	6c88                	ld	a0,24(s1)
    80003592:	ae6ff0ef          	jal	80002878 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003596:	46e1                	li	a3,24
    80003598:	8652                	mv	a2,s4
    8000359a:	85ce                	mv	a1,s3
    8000359c:	05093503          	ld	a0,80(s2)
    800035a0:	c94fd0ef          	jal	80000a34 <copyout>
    800035a4:	41f5551b          	sraiw	a0,a0,0x1f
    800035a8:	7942                	ld	s2,48(sp)
    800035aa:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800035ac:	60a6                	ld	ra,72(sp)
    800035ae:	6406                	ld	s0,64(sp)
    800035b0:	74e2                	ld	s1,56(sp)
    800035b2:	79a2                	ld	s3,40(sp)
    800035b4:	6161                	addi	sp,sp,80
    800035b6:	8082                	ret
  return -1;
    800035b8:	557d                	li	a0,-1
    800035ba:	bfcd                	j	800035ac <filestat+0x52>

00000000800035bc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035bc:	7179                	addi	sp,sp,-48
    800035be:	f406                	sd	ra,40(sp)
    800035c0:	f022                	sd	s0,32(sp)
    800035c2:	e84a                	sd	s2,16(sp)
    800035c4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035c6:	00854783          	lbu	a5,8(a0)
    800035ca:	cfd1                	beqz	a5,80003666 <fileread+0xaa>
    800035cc:	ec26                	sd	s1,24(sp)
    800035ce:	e44e                	sd	s3,8(sp)
    800035d0:	84aa                	mv	s1,a0
    800035d2:	89ae                	mv	s3,a1
    800035d4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800035d6:	411c                	lw	a5,0(a0)
    800035d8:	4705                	li	a4,1
    800035da:	04e78363          	beq	a5,a4,80003620 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035de:	470d                	li	a4,3
    800035e0:	04e78763          	beq	a5,a4,8000362e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800035e4:	4709                	li	a4,2
    800035e6:	06e79a63          	bne	a5,a4,8000365a <fileread+0x9e>
    ilock(f->ip);
    800035ea:	6d08                	ld	a0,24(a0)
    800035ec:	9deff0ef          	jal	800027ca <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800035f0:	874a                	mv	a4,s2
    800035f2:	5094                	lw	a3,32(s1)
    800035f4:	864e                	mv	a2,s3
    800035f6:	4585                	li	a1,1
    800035f8:	6c88                	ld	a0,24(s1)
    800035fa:	c28ff0ef          	jal	80002a22 <readi>
    800035fe:	892a                	mv	s2,a0
    80003600:	00a05563          	blez	a0,8000360a <fileread+0x4e>
      f->off += r;
    80003604:	509c                	lw	a5,32(s1)
    80003606:	9fa9                	addw	a5,a5,a0
    80003608:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000360a:	6c88                	ld	a0,24(s1)
    8000360c:	a6cff0ef          	jal	80002878 <iunlock>
    80003610:	64e2                	ld	s1,24(sp)
    80003612:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003614:	854a                	mv	a0,s2
    80003616:	70a2                	ld	ra,40(sp)
    80003618:	7402                	ld	s0,32(sp)
    8000361a:	6942                	ld	s2,16(sp)
    8000361c:	6145                	addi	sp,sp,48
    8000361e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003620:	6908                	ld	a0,16(a0)
    80003622:	3f6000ef          	jal	80003a18 <piperead>
    80003626:	892a                	mv	s2,a0
    80003628:	64e2                	ld	s1,24(sp)
    8000362a:	69a2                	ld	s3,8(sp)
    8000362c:	b7e5                	j	80003614 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000362e:	02451783          	lh	a5,36(a0)
    80003632:	03079693          	slli	a3,a5,0x30
    80003636:	92c1                	srli	a3,a3,0x30
    80003638:	4725                	li	a4,9
    8000363a:	02d76863          	bltu	a4,a3,8000366a <fileread+0xae>
    8000363e:	0792                	slli	a5,a5,0x4
    80003640:	00017717          	auipc	a4,0x17
    80003644:	23870713          	addi	a4,a4,568 # 8001a878 <devsw>
    80003648:	97ba                	add	a5,a5,a4
    8000364a:	639c                	ld	a5,0(a5)
    8000364c:	c39d                	beqz	a5,80003672 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000364e:	4505                	li	a0,1
    80003650:	9782                	jalr	a5
    80003652:	892a                	mv	s2,a0
    80003654:	64e2                	ld	s1,24(sp)
    80003656:	69a2                	ld	s3,8(sp)
    80003658:	bf75                	j	80003614 <fileread+0x58>
    panic("fileread");
    8000365a:	00004517          	auipc	a0,0x4
    8000365e:	00e50513          	addi	a0,a0,14 # 80007668 <etext+0x668>
    80003662:	7a5010ef          	jal	80005606 <panic>
    return -1;
    80003666:	597d                	li	s2,-1
    80003668:	b775                	j	80003614 <fileread+0x58>
      return -1;
    8000366a:	597d                	li	s2,-1
    8000366c:	64e2                	ld	s1,24(sp)
    8000366e:	69a2                	ld	s3,8(sp)
    80003670:	b755                	j	80003614 <fileread+0x58>
    80003672:	597d                	li	s2,-1
    80003674:	64e2                	ld	s1,24(sp)
    80003676:	69a2                	ld	s3,8(sp)
    80003678:	bf71                	j	80003614 <fileread+0x58>

000000008000367a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000367a:	00954783          	lbu	a5,9(a0)
    8000367e:	10078e63          	beqz	a5,8000379a <filewrite+0x120>
{
    80003682:	711d                	addi	sp,sp,-96
    80003684:	ec86                	sd	ra,88(sp)
    80003686:	e8a2                	sd	s0,80(sp)
    80003688:	e0ca                	sd	s2,64(sp)
    8000368a:	f456                	sd	s5,40(sp)
    8000368c:	f05a                	sd	s6,32(sp)
    8000368e:	1080                	addi	s0,sp,96
    80003690:	892a                	mv	s2,a0
    80003692:	8b2e                	mv	s6,a1
    80003694:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003696:	411c                	lw	a5,0(a0)
    80003698:	4705                	li	a4,1
    8000369a:	02e78963          	beq	a5,a4,800036cc <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000369e:	470d                	li	a4,3
    800036a0:	02e78a63          	beq	a5,a4,800036d4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036a4:	4709                	li	a4,2
    800036a6:	0ce79e63          	bne	a5,a4,80003782 <filewrite+0x108>
    800036aa:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800036ac:	0ac05963          	blez	a2,8000375e <filewrite+0xe4>
    800036b0:	e4a6                	sd	s1,72(sp)
    800036b2:	fc4e                	sd	s3,56(sp)
    800036b4:	ec5e                	sd	s7,24(sp)
    800036b6:	e862                	sd	s8,16(sp)
    800036b8:	e466                	sd	s9,8(sp)
    int i = 0;
    800036ba:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800036bc:	6b85                	lui	s7,0x1
    800036be:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036c2:	6c85                	lui	s9,0x1
    800036c4:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036c8:	4c05                	li	s8,1
    800036ca:	a8ad                	j	80003744 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    800036cc:	6908                	ld	a0,16(a0)
    800036ce:	252000ef          	jal	80003920 <pipewrite>
    800036d2:	a04d                	j	80003774 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800036d4:	02451783          	lh	a5,36(a0)
    800036d8:	03079693          	slli	a3,a5,0x30
    800036dc:	92c1                	srli	a3,a3,0x30
    800036de:	4725                	li	a4,9
    800036e0:	0ad76f63          	bltu	a4,a3,8000379e <filewrite+0x124>
    800036e4:	0792                	slli	a5,a5,0x4
    800036e6:	00017717          	auipc	a4,0x17
    800036ea:	19270713          	addi	a4,a4,402 # 8001a878 <devsw>
    800036ee:	97ba                	add	a5,a5,a4
    800036f0:	679c                	ld	a5,8(a5)
    800036f2:	cbc5                	beqz	a5,800037a2 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    800036f4:	4505                	li	a0,1
    800036f6:	9782                	jalr	a5
    800036f8:	a8b5                	j	80003774 <filewrite+0xfa>
      if(n1 > max)
    800036fa:	2981                	sext.w	s3,s3
      begin_op();
    800036fc:	981ff0ef          	jal	8000307c <begin_op>
      ilock(f->ip);
    80003700:	01893503          	ld	a0,24(s2)
    80003704:	8c6ff0ef          	jal	800027ca <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003708:	874e                	mv	a4,s3
    8000370a:	02092683          	lw	a3,32(s2)
    8000370e:	016a0633          	add	a2,s4,s6
    80003712:	85e2                	mv	a1,s8
    80003714:	01893503          	ld	a0,24(s2)
    80003718:	bfcff0ef          	jal	80002b14 <writei>
    8000371c:	84aa                	mv	s1,a0
    8000371e:	00a05763          	blez	a0,8000372c <filewrite+0xb2>
        f->off += r;
    80003722:	02092783          	lw	a5,32(s2)
    80003726:	9fa9                	addw	a5,a5,a0
    80003728:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000372c:	01893503          	ld	a0,24(s2)
    80003730:	948ff0ef          	jal	80002878 <iunlock>
      end_op();
    80003734:	9b3ff0ef          	jal	800030e6 <end_op>

      if(r != n1){
    80003738:	02999563          	bne	s3,s1,80003762 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    8000373c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003740:	015a5963          	bge	s4,s5,80003752 <filewrite+0xd8>
      int n1 = n - i;
    80003744:	414a87bb          	subw	a5,s5,s4
    80003748:	89be                	mv	s3,a5
      if(n1 > max)
    8000374a:	fafbd8e3          	bge	s7,a5,800036fa <filewrite+0x80>
    8000374e:	89e6                	mv	s3,s9
    80003750:	b76d                	j	800036fa <filewrite+0x80>
    80003752:	64a6                	ld	s1,72(sp)
    80003754:	79e2                	ld	s3,56(sp)
    80003756:	6be2                	ld	s7,24(sp)
    80003758:	6c42                	ld	s8,16(sp)
    8000375a:	6ca2                	ld	s9,8(sp)
    8000375c:	a801                	j	8000376c <filewrite+0xf2>
    int i = 0;
    8000375e:	4a01                	li	s4,0
    80003760:	a031                	j	8000376c <filewrite+0xf2>
    80003762:	64a6                	ld	s1,72(sp)
    80003764:	79e2                	ld	s3,56(sp)
    80003766:	6be2                	ld	s7,24(sp)
    80003768:	6c42                	ld	s8,16(sp)
    8000376a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000376c:	034a9d63          	bne	s5,s4,800037a6 <filewrite+0x12c>
    80003770:	8556                	mv	a0,s5
    80003772:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003774:	60e6                	ld	ra,88(sp)
    80003776:	6446                	ld	s0,80(sp)
    80003778:	6906                	ld	s2,64(sp)
    8000377a:	7aa2                	ld	s5,40(sp)
    8000377c:	7b02                	ld	s6,32(sp)
    8000377e:	6125                	addi	sp,sp,96
    80003780:	8082                	ret
    80003782:	e4a6                	sd	s1,72(sp)
    80003784:	fc4e                	sd	s3,56(sp)
    80003786:	f852                	sd	s4,48(sp)
    80003788:	ec5e                	sd	s7,24(sp)
    8000378a:	e862                	sd	s8,16(sp)
    8000378c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000378e:	00004517          	auipc	a0,0x4
    80003792:	eea50513          	addi	a0,a0,-278 # 80007678 <etext+0x678>
    80003796:	671010ef          	jal	80005606 <panic>
    return -1;
    8000379a:	557d                	li	a0,-1
}
    8000379c:	8082                	ret
      return -1;
    8000379e:	557d                	li	a0,-1
    800037a0:	bfd1                	j	80003774 <filewrite+0xfa>
    800037a2:	557d                	li	a0,-1
    800037a4:	bfc1                	j	80003774 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800037a6:	557d                	li	a0,-1
    800037a8:	7a42                	ld	s4,48(sp)
    800037aa:	b7e9                	j	80003774 <filewrite+0xfa>

00000000800037ac <fileopencount>:

int
fileopencount(void)
{
    800037ac:	1101                	addi	sp,sp,-32
    800037ae:	ec06                	sd	ra,24(sp)
    800037b0:	e822                	sd	s0,16(sp)
    800037b2:	e426                	sd	s1,8(sp)
    800037b4:	1000                	addi	s0,sp,32
  int count = 0;
  int i;
  acquire(&ftable.lock);
    800037b6:	00017517          	auipc	a0,0x17
    800037ba:	16250513          	addi	a0,a0,354 # 8001a918 <ftable>
    800037be:	176020ef          	jal	80005934 <acquire>
  for(i = 0; i < NFILE; i++){
    800037c2:	00017797          	auipc	a5,0x17
    800037c6:	17278793          	addi	a5,a5,370 # 8001a934 <ftable+0x1c>
    800037ca:	00018697          	auipc	a3,0x18
    800037ce:	10a68693          	addi	a3,a3,266 # 8001b8d4 <disk+0x4>
  int count = 0;
    800037d2:	4481                	li	s1,0
    800037d4:	a029                	j	800037de <fileopencount+0x32>
  for(i = 0; i < NFILE; i++){
    800037d6:	02878793          	addi	a5,a5,40
    800037da:	00d78763          	beq	a5,a3,800037e8 <fileopencount+0x3c>
    if(ftable.file[i].ref > 0)
    800037de:	4398                	lw	a4,0(a5)
    800037e0:	fee05be3          	blez	a4,800037d6 <fileopencount+0x2a>
      count++;
    800037e4:	2485                	addiw	s1,s1,1
    800037e6:	bfc5                	j	800037d6 <fileopencount+0x2a>
  }
  release(&ftable.lock);
    800037e8:	00017517          	auipc	a0,0x17
    800037ec:	13050513          	addi	a0,a0,304 # 8001a918 <ftable>
    800037f0:	1d8020ef          	jal	800059c8 <release>
  return count;
}
    800037f4:	8526                	mv	a0,s1
    800037f6:	60e2                	ld	ra,24(sp)
    800037f8:	6442                	ld	s0,16(sp)
    800037fa:	64a2                	ld	s1,8(sp)
    800037fc:	6105                	addi	sp,sp,32
    800037fe:	8082                	ret

0000000080003800 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003800:	7179                	addi	sp,sp,-48
    80003802:	f406                	sd	ra,40(sp)
    80003804:	f022                	sd	s0,32(sp)
    80003806:	ec26                	sd	s1,24(sp)
    80003808:	e052                	sd	s4,0(sp)
    8000380a:	1800                	addi	s0,sp,48
    8000380c:	84aa                	mv	s1,a0
    8000380e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003810:	0005b023          	sd	zero,0(a1)
    80003814:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003818:	be1ff0ef          	jal	800033f8 <filealloc>
    8000381c:	e088                	sd	a0,0(s1)
    8000381e:	c549                	beqz	a0,800038a8 <pipealloc+0xa8>
    80003820:	bd9ff0ef          	jal	800033f8 <filealloc>
    80003824:	00aa3023          	sd	a0,0(s4)
    80003828:	cd25                	beqz	a0,800038a0 <pipealloc+0xa0>
    8000382a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000382c:	8cbfc0ef          	jal	800000f6 <kalloc>
    80003830:	892a                	mv	s2,a0
    80003832:	c12d                	beqz	a0,80003894 <pipealloc+0x94>
    80003834:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003836:	4985                	li	s3,1
    80003838:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000383c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003840:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003844:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003848:	00004597          	auipc	a1,0x4
    8000384c:	bc858593          	addi	a1,a1,-1080 # 80007410 <etext+0x410>
    80003850:	060020ef          	jal	800058b0 <initlock>
  (*f0)->type = FD_PIPE;
    80003854:	609c                	ld	a5,0(s1)
    80003856:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000385a:	609c                	ld	a5,0(s1)
    8000385c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003860:	609c                	ld	a5,0(s1)
    80003862:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003866:	609c                	ld	a5,0(s1)
    80003868:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000386c:	000a3783          	ld	a5,0(s4)
    80003870:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003874:	000a3783          	ld	a5,0(s4)
    80003878:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000387c:	000a3783          	ld	a5,0(s4)
    80003880:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003884:	000a3783          	ld	a5,0(s4)
    80003888:	0127b823          	sd	s2,16(a5)
  return 0;
    8000388c:	4501                	li	a0,0
    8000388e:	6942                	ld	s2,16(sp)
    80003890:	69a2                	ld	s3,8(sp)
    80003892:	a01d                	j	800038b8 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003894:	6088                	ld	a0,0(s1)
    80003896:	c119                	beqz	a0,8000389c <pipealloc+0x9c>
    80003898:	6942                	ld	s2,16(sp)
    8000389a:	a029                	j	800038a4 <pipealloc+0xa4>
    8000389c:	6942                	ld	s2,16(sp)
    8000389e:	a029                	j	800038a8 <pipealloc+0xa8>
    800038a0:	6088                	ld	a0,0(s1)
    800038a2:	c10d                	beqz	a0,800038c4 <pipealloc+0xc4>
    fileclose(*f0);
    800038a4:	bf9ff0ef          	jal	8000349c <fileclose>
  if(*f1)
    800038a8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800038ac:	557d                	li	a0,-1
  if(*f1)
    800038ae:	c789                	beqz	a5,800038b8 <pipealloc+0xb8>
    fileclose(*f1);
    800038b0:	853e                	mv	a0,a5
    800038b2:	bebff0ef          	jal	8000349c <fileclose>
  return -1;
    800038b6:	557d                	li	a0,-1
}
    800038b8:	70a2                	ld	ra,40(sp)
    800038ba:	7402                	ld	s0,32(sp)
    800038bc:	64e2                	ld	s1,24(sp)
    800038be:	6a02                	ld	s4,0(sp)
    800038c0:	6145                	addi	sp,sp,48
    800038c2:	8082                	ret
  return -1;
    800038c4:	557d                	li	a0,-1
    800038c6:	bfcd                	j	800038b8 <pipealloc+0xb8>

00000000800038c8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800038c8:	1101                	addi	sp,sp,-32
    800038ca:	ec06                	sd	ra,24(sp)
    800038cc:	e822                	sd	s0,16(sp)
    800038ce:	e426                	sd	s1,8(sp)
    800038d0:	e04a                	sd	s2,0(sp)
    800038d2:	1000                	addi	s0,sp,32
    800038d4:	84aa                	mv	s1,a0
    800038d6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800038d8:	05c020ef          	jal	80005934 <acquire>
  if(writable){
    800038dc:	02090763          	beqz	s2,8000390a <pipeclose+0x42>
    pi->writeopen = 0;
    800038e0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800038e4:	21848513          	addi	a0,s1,536
    800038e8:	acbfd0ef          	jal	800013b2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800038ec:	2204b783          	ld	a5,544(s1)
    800038f0:	e785                	bnez	a5,80003918 <pipeclose+0x50>
    release(&pi->lock);
    800038f2:	8526                	mv	a0,s1
    800038f4:	0d4020ef          	jal	800059c8 <release>
    kfree((char*)pi);
    800038f8:	8526                	mv	a0,s1
    800038fa:	f22fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800038fe:	60e2                	ld	ra,24(sp)
    80003900:	6442                	ld	s0,16(sp)
    80003902:	64a2                	ld	s1,8(sp)
    80003904:	6902                	ld	s2,0(sp)
    80003906:	6105                	addi	sp,sp,32
    80003908:	8082                	ret
    pi->readopen = 0;
    8000390a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000390e:	21c48513          	addi	a0,s1,540
    80003912:	aa1fd0ef          	jal	800013b2 <wakeup>
    80003916:	bfd9                	j	800038ec <pipeclose+0x24>
    release(&pi->lock);
    80003918:	8526                	mv	a0,s1
    8000391a:	0ae020ef          	jal	800059c8 <release>
}
    8000391e:	b7c5                	j	800038fe <pipeclose+0x36>

0000000080003920 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003920:	7159                	addi	sp,sp,-112
    80003922:	f486                	sd	ra,104(sp)
    80003924:	f0a2                	sd	s0,96(sp)
    80003926:	eca6                	sd	s1,88(sp)
    80003928:	e8ca                	sd	s2,80(sp)
    8000392a:	e4ce                	sd	s3,72(sp)
    8000392c:	e0d2                	sd	s4,64(sp)
    8000392e:	fc56                	sd	s5,56(sp)
    80003930:	1880                	addi	s0,sp,112
    80003932:	84aa                	mv	s1,a0
    80003934:	8aae                	mv	s5,a1
    80003936:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003938:	c54fd0ef          	jal	80000d8c <myproc>
    8000393c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000393e:	8526                	mv	a0,s1
    80003940:	7f5010ef          	jal	80005934 <acquire>
  while(i < n){
    80003944:	0d405263          	blez	s4,80003a08 <pipewrite+0xe8>
    80003948:	f85a                	sd	s6,48(sp)
    8000394a:	f45e                	sd	s7,40(sp)
    8000394c:	f062                	sd	s8,32(sp)
    8000394e:	ec66                	sd	s9,24(sp)
    80003950:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003952:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003954:	f9f40c13          	addi	s8,s0,-97
    80003958:	4b85                	li	s7,1
    8000395a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000395c:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003960:	21c48c93          	addi	s9,s1,540
    80003964:	a82d                	j	8000399e <pipewrite+0x7e>
      release(&pi->lock);
    80003966:	8526                	mv	a0,s1
    80003968:	060020ef          	jal	800059c8 <release>
      return -1;
    8000396c:	597d                	li	s2,-1
    8000396e:	7b42                	ld	s6,48(sp)
    80003970:	7ba2                	ld	s7,40(sp)
    80003972:	7c02                	ld	s8,32(sp)
    80003974:	6ce2                	ld	s9,24(sp)
    80003976:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003978:	854a                	mv	a0,s2
    8000397a:	70a6                	ld	ra,104(sp)
    8000397c:	7406                	ld	s0,96(sp)
    8000397e:	64e6                	ld	s1,88(sp)
    80003980:	6946                	ld	s2,80(sp)
    80003982:	69a6                	ld	s3,72(sp)
    80003984:	6a06                	ld	s4,64(sp)
    80003986:	7ae2                	ld	s5,56(sp)
    80003988:	6165                	addi	sp,sp,112
    8000398a:	8082                	ret
      wakeup(&pi->nread);
    8000398c:	856a                	mv	a0,s10
    8000398e:	a25fd0ef          	jal	800013b2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003992:	85a6                	mv	a1,s1
    80003994:	8566                	mv	a0,s9
    80003996:	9d1fd0ef          	jal	80001366 <sleep>
  while(i < n){
    8000399a:	05495a63          	bge	s2,s4,800039ee <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    8000399e:	2204a783          	lw	a5,544(s1)
    800039a2:	d3f1                	beqz	a5,80003966 <pipewrite+0x46>
    800039a4:	854e                	mv	a0,s3
    800039a6:	bf9fd0ef          	jal	8000159e <killed>
    800039aa:	fd55                	bnez	a0,80003966 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800039ac:	2184a783          	lw	a5,536(s1)
    800039b0:	21c4a703          	lw	a4,540(s1)
    800039b4:	2007879b          	addiw	a5,a5,512
    800039b8:	fcf70ae3          	beq	a4,a5,8000398c <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800039bc:	86de                	mv	a3,s7
    800039be:	01590633          	add	a2,s2,s5
    800039c2:	85e2                	mv	a1,s8
    800039c4:	0509b503          	ld	a0,80(s3)
    800039c8:	91cfd0ef          	jal	80000ae4 <copyin>
    800039cc:	05650063          	beq	a0,s6,80003a0c <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800039d0:	21c4a783          	lw	a5,540(s1)
    800039d4:	0017871b          	addiw	a4,a5,1
    800039d8:	20e4ae23          	sw	a4,540(s1)
    800039dc:	1ff7f793          	andi	a5,a5,511
    800039e0:	97a6                	add	a5,a5,s1
    800039e2:	f9f44703          	lbu	a4,-97(s0)
    800039e6:	00e78c23          	sb	a4,24(a5)
      i++;
    800039ea:	2905                	addiw	s2,s2,1
    800039ec:	b77d                	j	8000399a <pipewrite+0x7a>
    800039ee:	7b42                	ld	s6,48(sp)
    800039f0:	7ba2                	ld	s7,40(sp)
    800039f2:	7c02                	ld	s8,32(sp)
    800039f4:	6ce2                	ld	s9,24(sp)
    800039f6:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800039f8:	21848513          	addi	a0,s1,536
    800039fc:	9b7fd0ef          	jal	800013b2 <wakeup>
  release(&pi->lock);
    80003a00:	8526                	mv	a0,s1
    80003a02:	7c7010ef          	jal	800059c8 <release>
  return i;
    80003a06:	bf8d                	j	80003978 <pipewrite+0x58>
  int i = 0;
    80003a08:	4901                	li	s2,0
    80003a0a:	b7fd                	j	800039f8 <pipewrite+0xd8>
    80003a0c:	7b42                	ld	s6,48(sp)
    80003a0e:	7ba2                	ld	s7,40(sp)
    80003a10:	7c02                	ld	s8,32(sp)
    80003a12:	6ce2                	ld	s9,24(sp)
    80003a14:	6d42                	ld	s10,16(sp)
    80003a16:	b7cd                	j	800039f8 <pipewrite+0xd8>

0000000080003a18 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003a18:	711d                	addi	sp,sp,-96
    80003a1a:	ec86                	sd	ra,88(sp)
    80003a1c:	e8a2                	sd	s0,80(sp)
    80003a1e:	e4a6                	sd	s1,72(sp)
    80003a20:	e0ca                	sd	s2,64(sp)
    80003a22:	fc4e                	sd	s3,56(sp)
    80003a24:	f852                	sd	s4,48(sp)
    80003a26:	f456                	sd	s5,40(sp)
    80003a28:	1080                	addi	s0,sp,96
    80003a2a:	84aa                	mv	s1,a0
    80003a2c:	892e                	mv	s2,a1
    80003a2e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003a30:	b5cfd0ef          	jal	80000d8c <myproc>
    80003a34:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003a36:	8526                	mv	a0,s1
    80003a38:	6fd010ef          	jal	80005934 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a3c:	2184a703          	lw	a4,536(s1)
    80003a40:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a44:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a48:	02f71763          	bne	a4,a5,80003a76 <piperead+0x5e>
    80003a4c:	2244a783          	lw	a5,548(s1)
    80003a50:	cf85                	beqz	a5,80003a88 <piperead+0x70>
    if(killed(pr)){
    80003a52:	8552                	mv	a0,s4
    80003a54:	b4bfd0ef          	jal	8000159e <killed>
    80003a58:	e11d                	bnez	a0,80003a7e <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a5a:	85a6                	mv	a1,s1
    80003a5c:	854e                	mv	a0,s3
    80003a5e:	909fd0ef          	jal	80001366 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a62:	2184a703          	lw	a4,536(s1)
    80003a66:	21c4a783          	lw	a5,540(s1)
    80003a6a:	fef701e3          	beq	a4,a5,80003a4c <piperead+0x34>
    80003a6e:	f05a                	sd	s6,32(sp)
    80003a70:	ec5e                	sd	s7,24(sp)
    80003a72:	e862                	sd	s8,16(sp)
    80003a74:	a829                	j	80003a8e <piperead+0x76>
    80003a76:	f05a                	sd	s6,32(sp)
    80003a78:	ec5e                	sd	s7,24(sp)
    80003a7a:	e862                	sd	s8,16(sp)
    80003a7c:	a809                	j	80003a8e <piperead+0x76>
      release(&pi->lock);
    80003a7e:	8526                	mv	a0,s1
    80003a80:	749010ef          	jal	800059c8 <release>
      return -1;
    80003a84:	59fd                	li	s3,-1
    80003a86:	a0a5                	j	80003aee <piperead+0xd6>
    80003a88:	f05a                	sd	s6,32(sp)
    80003a8a:	ec5e                	sd	s7,24(sp)
    80003a8c:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a8e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a90:	faf40c13          	addi	s8,s0,-81
    80003a94:	4b85                	li	s7,1
    80003a96:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a98:	05505163          	blez	s5,80003ada <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80003a9c:	2184a783          	lw	a5,536(s1)
    80003aa0:	21c4a703          	lw	a4,540(s1)
    80003aa4:	02f70b63          	beq	a4,a5,80003ada <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003aa8:	0017871b          	addiw	a4,a5,1
    80003aac:	20e4ac23          	sw	a4,536(s1)
    80003ab0:	1ff7f793          	andi	a5,a5,511
    80003ab4:	97a6                	add	a5,a5,s1
    80003ab6:	0187c783          	lbu	a5,24(a5)
    80003aba:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003abe:	86de                	mv	a3,s7
    80003ac0:	8662                	mv	a2,s8
    80003ac2:	85ca                	mv	a1,s2
    80003ac4:	050a3503          	ld	a0,80(s4)
    80003ac8:	f6dfc0ef          	jal	80000a34 <copyout>
    80003acc:	01650763          	beq	a0,s6,80003ada <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ad0:	2985                	addiw	s3,s3,1
    80003ad2:	0905                	addi	s2,s2,1
    80003ad4:	fd3a94e3          	bne	s5,s3,80003a9c <piperead+0x84>
    80003ad8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ada:	21c48513          	addi	a0,s1,540
    80003ade:	8d5fd0ef          	jal	800013b2 <wakeup>
  release(&pi->lock);
    80003ae2:	8526                	mv	a0,s1
    80003ae4:	6e5010ef          	jal	800059c8 <release>
    80003ae8:	7b02                	ld	s6,32(sp)
    80003aea:	6be2                	ld	s7,24(sp)
    80003aec:	6c42                	ld	s8,16(sp)
  return i;
}
    80003aee:	854e                	mv	a0,s3
    80003af0:	60e6                	ld	ra,88(sp)
    80003af2:	6446                	ld	s0,80(sp)
    80003af4:	64a6                	ld	s1,72(sp)
    80003af6:	6906                	ld	s2,64(sp)
    80003af8:	79e2                	ld	s3,56(sp)
    80003afa:	7a42                	ld	s4,48(sp)
    80003afc:	7aa2                	ld	s5,40(sp)
    80003afe:	6125                	addi	sp,sp,96
    80003b00:	8082                	ret

0000000080003b02 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003b02:	1141                	addi	sp,sp,-16
    80003b04:	e406                	sd	ra,8(sp)
    80003b06:	e022                	sd	s0,0(sp)
    80003b08:	0800                	addi	s0,sp,16
    80003b0a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003b0c:	0035151b          	slliw	a0,a0,0x3
    80003b10:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003b12:	8b89                	andi	a5,a5,2
    80003b14:	c399                	beqz	a5,80003b1a <flags2perm+0x18>
      perm |= PTE_W;
    80003b16:	00456513          	ori	a0,a0,4
    return perm;
}
    80003b1a:	60a2                	ld	ra,8(sp)
    80003b1c:	6402                	ld	s0,0(sp)
    80003b1e:	0141                	addi	sp,sp,16
    80003b20:	8082                	ret

0000000080003b22 <exec>:

int
exec(char *path, char **argv)
{
    80003b22:	de010113          	addi	sp,sp,-544
    80003b26:	20113c23          	sd	ra,536(sp)
    80003b2a:	20813823          	sd	s0,528(sp)
    80003b2e:	20913423          	sd	s1,520(sp)
    80003b32:	21213023          	sd	s2,512(sp)
    80003b36:	1400                	addi	s0,sp,544
    80003b38:	892a                	mv	s2,a0
    80003b3a:	dea43823          	sd	a0,-528(s0)
    80003b3e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003b42:	a4afd0ef          	jal	80000d8c <myproc>
    80003b46:	84aa                	mv	s1,a0

  begin_op();
    80003b48:	d34ff0ef          	jal	8000307c <begin_op>

  if((ip = namei(path)) == 0){
    80003b4c:	854a                	mv	a0,s2
    80003b4e:	b6cff0ef          	jal	80002eba <namei>
    80003b52:	cd21                	beqz	a0,80003baa <exec+0x88>
    80003b54:	fbd2                	sd	s4,496(sp)
    80003b56:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003b58:	c73fe0ef          	jal	800027ca <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b5c:	04000713          	li	a4,64
    80003b60:	4681                	li	a3,0
    80003b62:	e5040613          	addi	a2,s0,-432
    80003b66:	4581                	li	a1,0
    80003b68:	8552                	mv	a0,s4
    80003b6a:	eb9fe0ef          	jal	80002a22 <readi>
    80003b6e:	04000793          	li	a5,64
    80003b72:	00f51a63          	bne	a0,a5,80003b86 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003b76:	e5042703          	lw	a4,-432(s0)
    80003b7a:	464c47b7          	lui	a5,0x464c4
    80003b7e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b82:	02f70863          	beq	a4,a5,80003bb2 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b86:	8552                	mv	a0,s4
    80003b88:	e4dfe0ef          	jal	800029d4 <iunlockput>
    end_op();
    80003b8c:	d5aff0ef          	jal	800030e6 <end_op>
  }
  return -1;
    80003b90:	557d                	li	a0,-1
    80003b92:	7a5e                	ld	s4,496(sp)
}
    80003b94:	21813083          	ld	ra,536(sp)
    80003b98:	21013403          	ld	s0,528(sp)
    80003b9c:	20813483          	ld	s1,520(sp)
    80003ba0:	20013903          	ld	s2,512(sp)
    80003ba4:	22010113          	addi	sp,sp,544
    80003ba8:	8082                	ret
    end_op();
    80003baa:	d3cff0ef          	jal	800030e6 <end_op>
    return -1;
    80003bae:	557d                	li	a0,-1
    80003bb0:	b7d5                	j	80003b94 <exec+0x72>
    80003bb2:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003bb4:	8526                	mv	a0,s1
    80003bb6:	a7efd0ef          	jal	80000e34 <proc_pagetable>
    80003bba:	8b2a                	mv	s6,a0
    80003bbc:	26050d63          	beqz	a0,80003e36 <exec+0x314>
    80003bc0:	ffce                	sd	s3,504(sp)
    80003bc2:	f7d6                	sd	s5,488(sp)
    80003bc4:	efde                	sd	s7,472(sp)
    80003bc6:	ebe2                	sd	s8,464(sp)
    80003bc8:	e7e6                	sd	s9,456(sp)
    80003bca:	e3ea                	sd	s10,448(sp)
    80003bcc:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bce:	e7042683          	lw	a3,-400(s0)
    80003bd2:	e8845783          	lhu	a5,-376(s0)
    80003bd6:	0e078763          	beqz	a5,80003cc4 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003bda:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bdc:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bde:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003be2:	6c85                	lui	s9,0x1
    80003be4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003be8:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003bec:	6a85                	lui	s5,0x1
    80003bee:	a085                	j	80003c4e <exec+0x12c>
      panic("loadseg: address should exist");
    80003bf0:	00004517          	auipc	a0,0x4
    80003bf4:	a9850513          	addi	a0,a0,-1384 # 80007688 <etext+0x688>
    80003bf8:	20f010ef          	jal	80005606 <panic>
    if(sz - i < PGSIZE)
    80003bfc:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003bfe:	874a                	mv	a4,s2
    80003c00:	009c06bb          	addw	a3,s8,s1
    80003c04:	4581                	li	a1,0
    80003c06:	8552                	mv	a0,s4
    80003c08:	e1bfe0ef          	jal	80002a22 <readi>
    80003c0c:	22a91963          	bne	s2,a0,80003e3e <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003c10:	009a84bb          	addw	s1,s5,s1
    80003c14:	0334f263          	bgeu	s1,s3,80003c38 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003c18:	02049593          	slli	a1,s1,0x20
    80003c1c:	9181                	srli	a1,a1,0x20
    80003c1e:	95de                	add	a1,a1,s7
    80003c20:	855a                	mv	a0,s6
    80003c22:	883fc0ef          	jal	800004a4 <walkaddr>
    80003c26:	862a                	mv	a2,a0
    if(pa == 0)
    80003c28:	d561                	beqz	a0,80003bf0 <exec+0xce>
    if(sz - i < PGSIZE)
    80003c2a:	409987bb          	subw	a5,s3,s1
    80003c2e:	893e                	mv	s2,a5
    80003c30:	fcfcf6e3          	bgeu	s9,a5,80003bfc <exec+0xda>
    80003c34:	8956                	mv	s2,s5
    80003c36:	b7d9                	j	80003bfc <exec+0xda>
    sz = sz1;
    80003c38:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c3c:	2d05                	addiw	s10,s10,1
    80003c3e:	e0843783          	ld	a5,-504(s0)
    80003c42:	0387869b          	addiw	a3,a5,56
    80003c46:	e8845783          	lhu	a5,-376(s0)
    80003c4a:	06fd5e63          	bge	s10,a5,80003cc6 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c4e:	e0d43423          	sd	a3,-504(s0)
    80003c52:	876e                	mv	a4,s11
    80003c54:	e1840613          	addi	a2,s0,-488
    80003c58:	4581                	li	a1,0
    80003c5a:	8552                	mv	a0,s4
    80003c5c:	dc7fe0ef          	jal	80002a22 <readi>
    80003c60:	1db51d63          	bne	a0,s11,80003e3a <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003c64:	e1842783          	lw	a5,-488(s0)
    80003c68:	4705                	li	a4,1
    80003c6a:	fce799e3          	bne	a5,a4,80003c3c <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003c6e:	e4043483          	ld	s1,-448(s0)
    80003c72:	e3843783          	ld	a5,-456(s0)
    80003c76:	1ef4e263          	bltu	s1,a5,80003e5a <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c7a:	e2843783          	ld	a5,-472(s0)
    80003c7e:	94be                	add	s1,s1,a5
    80003c80:	1ef4e063          	bltu	s1,a5,80003e60 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003c84:	de843703          	ld	a4,-536(s0)
    80003c88:	8ff9                	and	a5,a5,a4
    80003c8a:	1c079e63          	bnez	a5,80003e66 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c8e:	e1c42503          	lw	a0,-484(s0)
    80003c92:	e71ff0ef          	jal	80003b02 <flags2perm>
    80003c96:	86aa                	mv	a3,a0
    80003c98:	8626                	mv	a2,s1
    80003c9a:	85ca                	mv	a1,s2
    80003c9c:	855a                	mv	a0,s6
    80003c9e:	b7ffc0ef          	jal	8000081c <uvmalloc>
    80003ca2:	dea43c23          	sd	a0,-520(s0)
    80003ca6:	1c050363          	beqz	a0,80003e6c <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003caa:	e2843b83          	ld	s7,-472(s0)
    80003cae:	e2042c03          	lw	s8,-480(s0)
    80003cb2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003cb6:	00098463          	beqz	s3,80003cbe <exec+0x19c>
    80003cba:	4481                	li	s1,0
    80003cbc:	bfb1                	j	80003c18 <exec+0xf6>
    sz = sz1;
    80003cbe:	df843903          	ld	s2,-520(s0)
    80003cc2:	bfad                	j	80003c3c <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003cc4:	4901                	li	s2,0
  iunlockput(ip);
    80003cc6:	8552                	mv	a0,s4
    80003cc8:	d0dfe0ef          	jal	800029d4 <iunlockput>
  end_op();
    80003ccc:	c1aff0ef          	jal	800030e6 <end_op>
  p = myproc();
    80003cd0:	8bcfd0ef          	jal	80000d8c <myproc>
    80003cd4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003cd6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003cda:	6985                	lui	s3,0x1
    80003cdc:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003cde:	99ca                	add	s3,s3,s2
    80003ce0:	77fd                	lui	a5,0xfffff
    80003ce2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003ce6:	4691                	li	a3,4
    80003ce8:	6609                	lui	a2,0x2
    80003cea:	964e                	add	a2,a2,s3
    80003cec:	85ce                	mv	a1,s3
    80003cee:	855a                	mv	a0,s6
    80003cf0:	b2dfc0ef          	jal	8000081c <uvmalloc>
    80003cf4:	8a2a                	mv	s4,a0
    80003cf6:	e105                	bnez	a0,80003d16 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003cf8:	85ce                	mv	a1,s3
    80003cfa:	855a                	mv	a0,s6
    80003cfc:	9bcfd0ef          	jal	80000eb8 <proc_freepagetable>
  return -1;
    80003d00:	557d                	li	a0,-1
    80003d02:	79fe                	ld	s3,504(sp)
    80003d04:	7a5e                	ld	s4,496(sp)
    80003d06:	7abe                	ld	s5,488(sp)
    80003d08:	7b1e                	ld	s6,480(sp)
    80003d0a:	6bfe                	ld	s7,472(sp)
    80003d0c:	6c5e                	ld	s8,464(sp)
    80003d0e:	6cbe                	ld	s9,456(sp)
    80003d10:	6d1e                	ld	s10,448(sp)
    80003d12:	7dfa                	ld	s11,440(sp)
    80003d14:	b541                	j	80003b94 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003d16:	75f9                	lui	a1,0xffffe
    80003d18:	95aa                	add	a1,a1,a0
    80003d1a:	855a                	mv	a0,s6
    80003d1c:	ceffc0ef          	jal	80000a0a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003d20:	7bfd                	lui	s7,0xfffff
    80003d22:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003d24:	e0043783          	ld	a5,-512(s0)
    80003d28:	6388                	ld	a0,0(a5)
  sp = sz;
    80003d2a:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003d2c:	4481                	li	s1,0
    ustack[argc] = sp;
    80003d2e:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003d32:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003d36:	cd21                	beqz	a0,80003d8e <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003d38:	dc6fc0ef          	jal	800002fe <strlen>
    80003d3c:	0015079b          	addiw	a5,a0,1
    80003d40:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003d44:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003d48:	13796563          	bltu	s2,s7,80003e72 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003d4c:	e0043d83          	ld	s11,-512(s0)
    80003d50:	000db983          	ld	s3,0(s11)
    80003d54:	854e                	mv	a0,s3
    80003d56:	da8fc0ef          	jal	800002fe <strlen>
    80003d5a:	0015069b          	addiw	a3,a0,1
    80003d5e:	864e                	mv	a2,s3
    80003d60:	85ca                	mv	a1,s2
    80003d62:	855a                	mv	a0,s6
    80003d64:	cd1fc0ef          	jal	80000a34 <copyout>
    80003d68:	10054763          	bltz	a0,80003e76 <exec+0x354>
    ustack[argc] = sp;
    80003d6c:	00349793          	slli	a5,s1,0x3
    80003d70:	97e6                	add	a5,a5,s9
    80003d72:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb4f0>
  for(argc = 0; argv[argc]; argc++) {
    80003d76:	0485                	addi	s1,s1,1
    80003d78:	008d8793          	addi	a5,s11,8
    80003d7c:	e0f43023          	sd	a5,-512(s0)
    80003d80:	008db503          	ld	a0,8(s11)
    80003d84:	c509                	beqz	a0,80003d8e <exec+0x26c>
    if(argc >= MAXARG)
    80003d86:	fb8499e3          	bne	s1,s8,80003d38 <exec+0x216>
  sz = sz1;
    80003d8a:	89d2                	mv	s3,s4
    80003d8c:	b7b5                	j	80003cf8 <exec+0x1d6>
  ustack[argc] = 0;
    80003d8e:	00349793          	slli	a5,s1,0x3
    80003d92:	f9078793          	addi	a5,a5,-112
    80003d96:	97a2                	add	a5,a5,s0
    80003d98:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003d9c:	00148693          	addi	a3,s1,1
    80003da0:	068e                	slli	a3,a3,0x3
    80003da2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003da6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003daa:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003dac:	f57966e3          	bltu	s2,s7,80003cf8 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003db0:	e9040613          	addi	a2,s0,-368
    80003db4:	85ca                	mv	a1,s2
    80003db6:	855a                	mv	a0,s6
    80003db8:	c7dfc0ef          	jal	80000a34 <copyout>
    80003dbc:	f2054ee3          	bltz	a0,80003cf8 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003dc0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003dc4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003dc8:	df043783          	ld	a5,-528(s0)
    80003dcc:	0007c703          	lbu	a4,0(a5)
    80003dd0:	cf11                	beqz	a4,80003dec <exec+0x2ca>
    80003dd2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003dd4:	02f00693          	li	a3,47
    80003dd8:	a029                	j	80003de2 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003dda:	0785                	addi	a5,a5,1
    80003ddc:	fff7c703          	lbu	a4,-1(a5)
    80003de0:	c711                	beqz	a4,80003dec <exec+0x2ca>
    if(*s == '/')
    80003de2:	fed71ce3          	bne	a4,a3,80003dda <exec+0x2b8>
      last = s+1;
    80003de6:	def43823          	sd	a5,-528(s0)
    80003dea:	bfc5                	j	80003dda <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003dec:	4641                	li	a2,16
    80003dee:	df043583          	ld	a1,-528(s0)
    80003df2:	158a8513          	addi	a0,s5,344
    80003df6:	cd2fc0ef          	jal	800002c8 <safestrcpy>
  oldpagetable = p->pagetable;
    80003dfa:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003dfe:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003e02:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003e06:	058ab783          	ld	a5,88(s5)
    80003e0a:	e6843703          	ld	a4,-408(s0)
    80003e0e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003e10:	058ab783          	ld	a5,88(s5)
    80003e14:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003e18:	85ea                	mv	a1,s10
    80003e1a:	89efd0ef          	jal	80000eb8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003e1e:	0004851b          	sext.w	a0,s1
    80003e22:	79fe                	ld	s3,504(sp)
    80003e24:	7a5e                	ld	s4,496(sp)
    80003e26:	7abe                	ld	s5,488(sp)
    80003e28:	7b1e                	ld	s6,480(sp)
    80003e2a:	6bfe                	ld	s7,472(sp)
    80003e2c:	6c5e                	ld	s8,464(sp)
    80003e2e:	6cbe                	ld	s9,456(sp)
    80003e30:	6d1e                	ld	s10,448(sp)
    80003e32:	7dfa                	ld	s11,440(sp)
    80003e34:	b385                	j	80003b94 <exec+0x72>
    80003e36:	7b1e                	ld	s6,480(sp)
    80003e38:	b3b9                	j	80003b86 <exec+0x64>
    80003e3a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003e3e:	df843583          	ld	a1,-520(s0)
    80003e42:	855a                	mv	a0,s6
    80003e44:	874fd0ef          	jal	80000eb8 <proc_freepagetable>
  if(ip){
    80003e48:	79fe                	ld	s3,504(sp)
    80003e4a:	7abe                	ld	s5,488(sp)
    80003e4c:	7b1e                	ld	s6,480(sp)
    80003e4e:	6bfe                	ld	s7,472(sp)
    80003e50:	6c5e                	ld	s8,464(sp)
    80003e52:	6cbe                	ld	s9,456(sp)
    80003e54:	6d1e                	ld	s10,448(sp)
    80003e56:	7dfa                	ld	s11,440(sp)
    80003e58:	b33d                	j	80003b86 <exec+0x64>
    80003e5a:	df243c23          	sd	s2,-520(s0)
    80003e5e:	b7c5                	j	80003e3e <exec+0x31c>
    80003e60:	df243c23          	sd	s2,-520(s0)
    80003e64:	bfe9                	j	80003e3e <exec+0x31c>
    80003e66:	df243c23          	sd	s2,-520(s0)
    80003e6a:	bfd1                	j	80003e3e <exec+0x31c>
    80003e6c:	df243c23          	sd	s2,-520(s0)
    80003e70:	b7f9                	j	80003e3e <exec+0x31c>
  sz = sz1;
    80003e72:	89d2                	mv	s3,s4
    80003e74:	b551                	j	80003cf8 <exec+0x1d6>
    80003e76:	89d2                	mv	s3,s4
    80003e78:	b541                	j	80003cf8 <exec+0x1d6>

0000000080003e7a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e7a:	7179                	addi	sp,sp,-48
    80003e7c:	f406                	sd	ra,40(sp)
    80003e7e:	f022                	sd	s0,32(sp)
    80003e80:	ec26                	sd	s1,24(sp)
    80003e82:	e84a                	sd	s2,16(sp)
    80003e84:	1800                	addi	s0,sp,48
    80003e86:	892e                	mv	s2,a1
    80003e88:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e8a:	fdc40593          	addi	a1,s0,-36
    80003e8e:	e4ffd0ef          	jal	80001cdc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e92:	fdc42703          	lw	a4,-36(s0)
    80003e96:	47bd                	li	a5,15
    80003e98:	02e7e963          	bltu	a5,a4,80003eca <argfd+0x50>
    80003e9c:	ef1fc0ef          	jal	80000d8c <myproc>
    80003ea0:	fdc42703          	lw	a4,-36(s0)
    80003ea4:	01a70793          	addi	a5,a4,26
    80003ea8:	078e                	slli	a5,a5,0x3
    80003eaa:	953e                	add	a0,a0,a5
    80003eac:	611c                	ld	a5,0(a0)
    80003eae:	c385                	beqz	a5,80003ece <argfd+0x54>
    return -1;
  if(pfd)
    80003eb0:	00090463          	beqz	s2,80003eb8 <argfd+0x3e>
    *pfd = fd;
    80003eb4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003eb8:	4501                	li	a0,0
  if(pf)
    80003eba:	c091                	beqz	s1,80003ebe <argfd+0x44>
    *pf = f;
    80003ebc:	e09c                	sd	a5,0(s1)
}
    80003ebe:	70a2                	ld	ra,40(sp)
    80003ec0:	7402                	ld	s0,32(sp)
    80003ec2:	64e2                	ld	s1,24(sp)
    80003ec4:	6942                	ld	s2,16(sp)
    80003ec6:	6145                	addi	sp,sp,48
    80003ec8:	8082                	ret
    return -1;
    80003eca:	557d                	li	a0,-1
    80003ecc:	bfcd                	j	80003ebe <argfd+0x44>
    80003ece:	557d                	li	a0,-1
    80003ed0:	b7fd                	j	80003ebe <argfd+0x44>

0000000080003ed2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003ed2:	1101                	addi	sp,sp,-32
    80003ed4:	ec06                	sd	ra,24(sp)
    80003ed6:	e822                	sd	s0,16(sp)
    80003ed8:	e426                	sd	s1,8(sp)
    80003eda:	1000                	addi	s0,sp,32
    80003edc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003ede:	eaffc0ef          	jal	80000d8c <myproc>
    80003ee2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003ee4:	0d050793          	addi	a5,a0,208
    80003ee8:	4501                	li	a0,0
    80003eea:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003eec:	6398                	ld	a4,0(a5)
    80003eee:	cb19                	beqz	a4,80003f04 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003ef0:	2505                	addiw	a0,a0,1
    80003ef2:	07a1                	addi	a5,a5,8
    80003ef4:	fed51ce3          	bne	a0,a3,80003eec <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003ef8:	557d                	li	a0,-1
}
    80003efa:	60e2                	ld	ra,24(sp)
    80003efc:	6442                	ld	s0,16(sp)
    80003efe:	64a2                	ld	s1,8(sp)
    80003f00:	6105                	addi	sp,sp,32
    80003f02:	8082                	ret
      p->ofile[fd] = f;
    80003f04:	01a50793          	addi	a5,a0,26
    80003f08:	078e                	slli	a5,a5,0x3
    80003f0a:	963e                	add	a2,a2,a5
    80003f0c:	e204                	sd	s1,0(a2)
      return fd;
    80003f0e:	b7f5                	j	80003efa <fdalloc+0x28>

0000000080003f10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003f10:	715d                	addi	sp,sp,-80
    80003f12:	e486                	sd	ra,72(sp)
    80003f14:	e0a2                	sd	s0,64(sp)
    80003f16:	fc26                	sd	s1,56(sp)
    80003f18:	f84a                	sd	s2,48(sp)
    80003f1a:	f44e                	sd	s3,40(sp)
    80003f1c:	ec56                	sd	s5,24(sp)
    80003f1e:	e85a                	sd	s6,16(sp)
    80003f20:	0880                	addi	s0,sp,80
    80003f22:	8b2e                	mv	s6,a1
    80003f24:	89b2                	mv	s3,a2
    80003f26:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003f28:	fb040593          	addi	a1,s0,-80
    80003f2c:	fa9fe0ef          	jal	80002ed4 <nameiparent>
    80003f30:	84aa                	mv	s1,a0
    80003f32:	10050a63          	beqz	a0,80004046 <create+0x136>
    return 0;

  ilock(dp);
    80003f36:	895fe0ef          	jal	800027ca <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f3a:	4601                	li	a2,0
    80003f3c:	fb040593          	addi	a1,s0,-80
    80003f40:	8526                	mv	a0,s1
    80003f42:	cedfe0ef          	jal	80002c2e <dirlookup>
    80003f46:	8aaa                	mv	s5,a0
    80003f48:	c129                	beqz	a0,80003f8a <create+0x7a>
    iunlockput(dp);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	a89fe0ef          	jal	800029d4 <iunlockput>
    ilock(ip);
    80003f50:	8556                	mv	a0,s5
    80003f52:	879fe0ef          	jal	800027ca <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003f56:	4789                	li	a5,2
    80003f58:	02fb1463          	bne	s6,a5,80003f80 <create+0x70>
    80003f5c:	044ad783          	lhu	a5,68(s5)
    80003f60:	37f9                	addiw	a5,a5,-2
    80003f62:	17c2                	slli	a5,a5,0x30
    80003f64:	93c1                	srli	a5,a5,0x30
    80003f66:	4705                	li	a4,1
    80003f68:	00f76c63          	bltu	a4,a5,80003f80 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f6c:	8556                	mv	a0,s5
    80003f6e:	60a6                	ld	ra,72(sp)
    80003f70:	6406                	ld	s0,64(sp)
    80003f72:	74e2                	ld	s1,56(sp)
    80003f74:	7942                	ld	s2,48(sp)
    80003f76:	79a2                	ld	s3,40(sp)
    80003f78:	6ae2                	ld	s5,24(sp)
    80003f7a:	6b42                	ld	s6,16(sp)
    80003f7c:	6161                	addi	sp,sp,80
    80003f7e:	8082                	ret
    iunlockput(ip);
    80003f80:	8556                	mv	a0,s5
    80003f82:	a53fe0ef          	jal	800029d4 <iunlockput>
    return 0;
    80003f86:	4a81                	li	s5,0
    80003f88:	b7d5                	j	80003f6c <create+0x5c>
    80003f8a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f8c:	85da                	mv	a1,s6
    80003f8e:	4088                	lw	a0,0(s1)
    80003f90:	ecafe0ef          	jal	8000265a <ialloc>
    80003f94:	8a2a                	mv	s4,a0
    80003f96:	cd15                	beqz	a0,80003fd2 <create+0xc2>
  ilock(ip);
    80003f98:	833fe0ef          	jal	800027ca <ilock>
  ip->major = major;
    80003f9c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003fa0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003fa4:	4905                	li	s2,1
    80003fa6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003faa:	8552                	mv	a0,s4
    80003fac:	f6afe0ef          	jal	80002716 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003fb0:	032b0763          	beq	s6,s2,80003fde <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fb4:	004a2603          	lw	a2,4(s4)
    80003fb8:	fb040593          	addi	a1,s0,-80
    80003fbc:	8526                	mv	a0,s1
    80003fbe:	e53fe0ef          	jal	80002e10 <dirlink>
    80003fc2:	06054563          	bltz	a0,8000402c <create+0x11c>
  iunlockput(dp);
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	a0dfe0ef          	jal	800029d4 <iunlockput>
  return ip;
    80003fcc:	8ad2                	mv	s5,s4
    80003fce:	7a02                	ld	s4,32(sp)
    80003fd0:	bf71                	j	80003f6c <create+0x5c>
    iunlockput(dp);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	a01fe0ef          	jal	800029d4 <iunlockput>
    return 0;
    80003fd8:	8ad2                	mv	s5,s4
    80003fda:	7a02                	ld	s4,32(sp)
    80003fdc:	bf41                	j	80003f6c <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003fde:	004a2603          	lw	a2,4(s4)
    80003fe2:	00003597          	auipc	a1,0x3
    80003fe6:	6c658593          	addi	a1,a1,1734 # 800076a8 <etext+0x6a8>
    80003fea:	8552                	mv	a0,s4
    80003fec:	e25fe0ef          	jal	80002e10 <dirlink>
    80003ff0:	02054e63          	bltz	a0,8000402c <create+0x11c>
    80003ff4:	40d0                	lw	a2,4(s1)
    80003ff6:	00003597          	auipc	a1,0x3
    80003ffa:	6ba58593          	addi	a1,a1,1722 # 800076b0 <etext+0x6b0>
    80003ffe:	8552                	mv	a0,s4
    80004000:	e11fe0ef          	jal	80002e10 <dirlink>
    80004004:	02054463          	bltz	a0,8000402c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004008:	004a2603          	lw	a2,4(s4)
    8000400c:	fb040593          	addi	a1,s0,-80
    80004010:	8526                	mv	a0,s1
    80004012:	dfffe0ef          	jal	80002e10 <dirlink>
    80004016:	00054b63          	bltz	a0,8000402c <create+0x11c>
    dp->nlink++;  // for ".."
    8000401a:	04a4d783          	lhu	a5,74(s1)
    8000401e:	2785                	addiw	a5,a5,1
    80004020:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004024:	8526                	mv	a0,s1
    80004026:	ef0fe0ef          	jal	80002716 <iupdate>
    8000402a:	bf71                	j	80003fc6 <create+0xb6>
  ip->nlink = 0;
    8000402c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004030:	8552                	mv	a0,s4
    80004032:	ee4fe0ef          	jal	80002716 <iupdate>
  iunlockput(ip);
    80004036:	8552                	mv	a0,s4
    80004038:	99dfe0ef          	jal	800029d4 <iunlockput>
  iunlockput(dp);
    8000403c:	8526                	mv	a0,s1
    8000403e:	997fe0ef          	jal	800029d4 <iunlockput>
  return 0;
    80004042:	7a02                	ld	s4,32(sp)
    80004044:	b725                	j	80003f6c <create+0x5c>
    return 0;
    80004046:	8aaa                	mv	s5,a0
    80004048:	b715                	j	80003f6c <create+0x5c>

000000008000404a <sys_dup>:
{
    8000404a:	7179                	addi	sp,sp,-48
    8000404c:	f406                	sd	ra,40(sp)
    8000404e:	f022                	sd	s0,32(sp)
    80004050:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004052:	fd840613          	addi	a2,s0,-40
    80004056:	4581                	li	a1,0
    80004058:	4501                	li	a0,0
    8000405a:	e21ff0ef          	jal	80003e7a <argfd>
    return -1;
    8000405e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004060:	02054363          	bltz	a0,80004086 <sys_dup+0x3c>
    80004064:	ec26                	sd	s1,24(sp)
    80004066:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004068:	fd843903          	ld	s2,-40(s0)
    8000406c:	854a                	mv	a0,s2
    8000406e:	e65ff0ef          	jal	80003ed2 <fdalloc>
    80004072:	84aa                	mv	s1,a0
    return -1;
    80004074:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004076:	00054d63          	bltz	a0,80004090 <sys_dup+0x46>
  filedup(f);
    8000407a:	854a                	mv	a0,s2
    8000407c:	bdaff0ef          	jal	80003456 <filedup>
  return fd;
    80004080:	87a6                	mv	a5,s1
    80004082:	64e2                	ld	s1,24(sp)
    80004084:	6942                	ld	s2,16(sp)
}
    80004086:	853e                	mv	a0,a5
    80004088:	70a2                	ld	ra,40(sp)
    8000408a:	7402                	ld	s0,32(sp)
    8000408c:	6145                	addi	sp,sp,48
    8000408e:	8082                	ret
    80004090:	64e2                	ld	s1,24(sp)
    80004092:	6942                	ld	s2,16(sp)
    80004094:	bfcd                	j	80004086 <sys_dup+0x3c>

0000000080004096 <sys_read>:
{
    80004096:	7179                	addi	sp,sp,-48
    80004098:	f406                	sd	ra,40(sp)
    8000409a:	f022                	sd	s0,32(sp)
    8000409c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000409e:	fd840593          	addi	a1,s0,-40
    800040a2:	4505                	li	a0,1
    800040a4:	c55fd0ef          	jal	80001cf8 <argaddr>
  argint(2, &n);
    800040a8:	fe440593          	addi	a1,s0,-28
    800040ac:	4509                	li	a0,2
    800040ae:	c2ffd0ef          	jal	80001cdc <argint>
  if(argfd(0, 0, &f) < 0)
    800040b2:	fe840613          	addi	a2,s0,-24
    800040b6:	4581                	li	a1,0
    800040b8:	4501                	li	a0,0
    800040ba:	dc1ff0ef          	jal	80003e7a <argfd>
    800040be:	87aa                	mv	a5,a0
    return -1;
    800040c0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040c2:	0007ca63          	bltz	a5,800040d6 <sys_read+0x40>
  return fileread(f, p, n);
    800040c6:	fe442603          	lw	a2,-28(s0)
    800040ca:	fd843583          	ld	a1,-40(s0)
    800040ce:	fe843503          	ld	a0,-24(s0)
    800040d2:	ceaff0ef          	jal	800035bc <fileread>
}
    800040d6:	70a2                	ld	ra,40(sp)
    800040d8:	7402                	ld	s0,32(sp)
    800040da:	6145                	addi	sp,sp,48
    800040dc:	8082                	ret

00000000800040de <sys_write>:
{
    800040de:	7179                	addi	sp,sp,-48
    800040e0:	f406                	sd	ra,40(sp)
    800040e2:	f022                	sd	s0,32(sp)
    800040e4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040e6:	fd840593          	addi	a1,s0,-40
    800040ea:	4505                	li	a0,1
    800040ec:	c0dfd0ef          	jal	80001cf8 <argaddr>
  argint(2, &n);
    800040f0:	fe440593          	addi	a1,s0,-28
    800040f4:	4509                	li	a0,2
    800040f6:	be7fd0ef          	jal	80001cdc <argint>
  if(argfd(0, 0, &f) < 0)
    800040fa:	fe840613          	addi	a2,s0,-24
    800040fe:	4581                	li	a1,0
    80004100:	4501                	li	a0,0
    80004102:	d79ff0ef          	jal	80003e7a <argfd>
    80004106:	87aa                	mv	a5,a0
    return -1;
    80004108:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000410a:	0007ca63          	bltz	a5,8000411e <sys_write+0x40>
  return filewrite(f, p, n);
    8000410e:	fe442603          	lw	a2,-28(s0)
    80004112:	fd843583          	ld	a1,-40(s0)
    80004116:	fe843503          	ld	a0,-24(s0)
    8000411a:	d60ff0ef          	jal	8000367a <filewrite>
}
    8000411e:	70a2                	ld	ra,40(sp)
    80004120:	7402                	ld	s0,32(sp)
    80004122:	6145                	addi	sp,sp,48
    80004124:	8082                	ret

0000000080004126 <sys_close>:
{
    80004126:	1101                	addi	sp,sp,-32
    80004128:	ec06                	sd	ra,24(sp)
    8000412a:	e822                	sd	s0,16(sp)
    8000412c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000412e:	fe040613          	addi	a2,s0,-32
    80004132:	fec40593          	addi	a1,s0,-20
    80004136:	4501                	li	a0,0
    80004138:	d43ff0ef          	jal	80003e7a <argfd>
    return -1;
    8000413c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000413e:	02054063          	bltz	a0,8000415e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004142:	c4bfc0ef          	jal	80000d8c <myproc>
    80004146:	fec42783          	lw	a5,-20(s0)
    8000414a:	07e9                	addi	a5,a5,26
    8000414c:	078e                	slli	a5,a5,0x3
    8000414e:	953e                	add	a0,a0,a5
    80004150:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004154:	fe043503          	ld	a0,-32(s0)
    80004158:	b44ff0ef          	jal	8000349c <fileclose>
  return 0;
    8000415c:	4781                	li	a5,0
}
    8000415e:	853e                	mv	a0,a5
    80004160:	60e2                	ld	ra,24(sp)
    80004162:	6442                	ld	s0,16(sp)
    80004164:	6105                	addi	sp,sp,32
    80004166:	8082                	ret

0000000080004168 <sys_fstat>:
{
    80004168:	1101                	addi	sp,sp,-32
    8000416a:	ec06                	sd	ra,24(sp)
    8000416c:	e822                	sd	s0,16(sp)
    8000416e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004170:	fe040593          	addi	a1,s0,-32
    80004174:	4505                	li	a0,1
    80004176:	b83fd0ef          	jal	80001cf8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000417a:	fe840613          	addi	a2,s0,-24
    8000417e:	4581                	li	a1,0
    80004180:	4501                	li	a0,0
    80004182:	cf9ff0ef          	jal	80003e7a <argfd>
    80004186:	87aa                	mv	a5,a0
    return -1;
    80004188:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000418a:	0007c863          	bltz	a5,8000419a <sys_fstat+0x32>
  return filestat(f, st);
    8000418e:	fe043583          	ld	a1,-32(s0)
    80004192:	fe843503          	ld	a0,-24(s0)
    80004196:	bc4ff0ef          	jal	8000355a <filestat>
}
    8000419a:	60e2                	ld	ra,24(sp)
    8000419c:	6442                	ld	s0,16(sp)
    8000419e:	6105                	addi	sp,sp,32
    800041a0:	8082                	ret

00000000800041a2 <sys_link>:
{
    800041a2:	7169                	addi	sp,sp,-304
    800041a4:	f606                	sd	ra,296(sp)
    800041a6:	f222                	sd	s0,288(sp)
    800041a8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041aa:	08000613          	li	a2,128
    800041ae:	ed040593          	addi	a1,s0,-304
    800041b2:	4501                	li	a0,0
    800041b4:	b61fd0ef          	jal	80001d14 <argstr>
    return -1;
    800041b8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041ba:	0c054e63          	bltz	a0,80004296 <sys_link+0xf4>
    800041be:	08000613          	li	a2,128
    800041c2:	f5040593          	addi	a1,s0,-176
    800041c6:	4505                	li	a0,1
    800041c8:	b4dfd0ef          	jal	80001d14 <argstr>
    return -1;
    800041cc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041ce:	0c054463          	bltz	a0,80004296 <sys_link+0xf4>
    800041d2:	ee26                	sd	s1,280(sp)
  begin_op();
    800041d4:	ea9fe0ef          	jal	8000307c <begin_op>
  if((ip = namei(old)) == 0){
    800041d8:	ed040513          	addi	a0,s0,-304
    800041dc:	cdffe0ef          	jal	80002eba <namei>
    800041e0:	84aa                	mv	s1,a0
    800041e2:	c53d                	beqz	a0,80004250 <sys_link+0xae>
  ilock(ip);
    800041e4:	de6fe0ef          	jal	800027ca <ilock>
  if(ip->type == T_DIR){
    800041e8:	04449703          	lh	a4,68(s1)
    800041ec:	4785                	li	a5,1
    800041ee:	06f70663          	beq	a4,a5,8000425a <sys_link+0xb8>
    800041f2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800041f4:	04a4d783          	lhu	a5,74(s1)
    800041f8:	2785                	addiw	a5,a5,1
    800041fa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041fe:	8526                	mv	a0,s1
    80004200:	d16fe0ef          	jal	80002716 <iupdate>
  iunlock(ip);
    80004204:	8526                	mv	a0,s1
    80004206:	e72fe0ef          	jal	80002878 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000420a:	fd040593          	addi	a1,s0,-48
    8000420e:	f5040513          	addi	a0,s0,-176
    80004212:	cc3fe0ef          	jal	80002ed4 <nameiparent>
    80004216:	892a                	mv	s2,a0
    80004218:	cd21                	beqz	a0,80004270 <sys_link+0xce>
  ilock(dp);
    8000421a:	db0fe0ef          	jal	800027ca <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000421e:	00092703          	lw	a4,0(s2)
    80004222:	409c                	lw	a5,0(s1)
    80004224:	04f71363          	bne	a4,a5,8000426a <sys_link+0xc8>
    80004228:	40d0                	lw	a2,4(s1)
    8000422a:	fd040593          	addi	a1,s0,-48
    8000422e:	854a                	mv	a0,s2
    80004230:	be1fe0ef          	jal	80002e10 <dirlink>
    80004234:	02054b63          	bltz	a0,8000426a <sys_link+0xc8>
  iunlockput(dp);
    80004238:	854a                	mv	a0,s2
    8000423a:	f9afe0ef          	jal	800029d4 <iunlockput>
  iput(ip);
    8000423e:	8526                	mv	a0,s1
    80004240:	f0cfe0ef          	jal	8000294c <iput>
  end_op();
    80004244:	ea3fe0ef          	jal	800030e6 <end_op>
  return 0;
    80004248:	4781                	li	a5,0
    8000424a:	64f2                	ld	s1,280(sp)
    8000424c:	6952                	ld	s2,272(sp)
    8000424e:	a0a1                	j	80004296 <sys_link+0xf4>
    end_op();
    80004250:	e97fe0ef          	jal	800030e6 <end_op>
    return -1;
    80004254:	57fd                	li	a5,-1
    80004256:	64f2                	ld	s1,280(sp)
    80004258:	a83d                	j	80004296 <sys_link+0xf4>
    iunlockput(ip);
    8000425a:	8526                	mv	a0,s1
    8000425c:	f78fe0ef          	jal	800029d4 <iunlockput>
    end_op();
    80004260:	e87fe0ef          	jal	800030e6 <end_op>
    return -1;
    80004264:	57fd                	li	a5,-1
    80004266:	64f2                	ld	s1,280(sp)
    80004268:	a03d                	j	80004296 <sys_link+0xf4>
    iunlockput(dp);
    8000426a:	854a                	mv	a0,s2
    8000426c:	f68fe0ef          	jal	800029d4 <iunlockput>
  ilock(ip);
    80004270:	8526                	mv	a0,s1
    80004272:	d58fe0ef          	jal	800027ca <ilock>
  ip->nlink--;
    80004276:	04a4d783          	lhu	a5,74(s1)
    8000427a:	37fd                	addiw	a5,a5,-1
    8000427c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004280:	8526                	mv	a0,s1
    80004282:	c94fe0ef          	jal	80002716 <iupdate>
  iunlockput(ip);
    80004286:	8526                	mv	a0,s1
    80004288:	f4cfe0ef          	jal	800029d4 <iunlockput>
  end_op();
    8000428c:	e5bfe0ef          	jal	800030e6 <end_op>
  return -1;
    80004290:	57fd                	li	a5,-1
    80004292:	64f2                	ld	s1,280(sp)
    80004294:	6952                	ld	s2,272(sp)
}
    80004296:	853e                	mv	a0,a5
    80004298:	70b2                	ld	ra,296(sp)
    8000429a:	7412                	ld	s0,288(sp)
    8000429c:	6155                	addi	sp,sp,304
    8000429e:	8082                	ret

00000000800042a0 <sys_unlink>:
{
    800042a0:	7111                	addi	sp,sp,-256
    800042a2:	fd86                	sd	ra,248(sp)
    800042a4:	f9a2                	sd	s0,240(sp)
    800042a6:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800042a8:	08000613          	li	a2,128
    800042ac:	f2040593          	addi	a1,s0,-224
    800042b0:	4501                	li	a0,0
    800042b2:	a63fd0ef          	jal	80001d14 <argstr>
    800042b6:	16054663          	bltz	a0,80004422 <sys_unlink+0x182>
    800042ba:	f5a6                	sd	s1,232(sp)
  begin_op();
    800042bc:	dc1fe0ef          	jal	8000307c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800042c0:	fa040593          	addi	a1,s0,-96
    800042c4:	f2040513          	addi	a0,s0,-224
    800042c8:	c0dfe0ef          	jal	80002ed4 <nameiparent>
    800042cc:	84aa                	mv	s1,a0
    800042ce:	c955                	beqz	a0,80004382 <sys_unlink+0xe2>
  ilock(dp);
    800042d0:	cfafe0ef          	jal	800027ca <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800042d4:	00003597          	auipc	a1,0x3
    800042d8:	3d458593          	addi	a1,a1,980 # 800076a8 <etext+0x6a8>
    800042dc:	fa040513          	addi	a0,s0,-96
    800042e0:	939fe0ef          	jal	80002c18 <namecmp>
    800042e4:	12050463          	beqz	a0,8000440c <sys_unlink+0x16c>
    800042e8:	00003597          	auipc	a1,0x3
    800042ec:	3c858593          	addi	a1,a1,968 # 800076b0 <etext+0x6b0>
    800042f0:	fa040513          	addi	a0,s0,-96
    800042f4:	925fe0ef          	jal	80002c18 <namecmp>
    800042f8:	10050a63          	beqz	a0,8000440c <sys_unlink+0x16c>
    800042fc:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800042fe:	f1c40613          	addi	a2,s0,-228
    80004302:	fa040593          	addi	a1,s0,-96
    80004306:	8526                	mv	a0,s1
    80004308:	927fe0ef          	jal	80002c2e <dirlookup>
    8000430c:	892a                	mv	s2,a0
    8000430e:	0e050e63          	beqz	a0,8000440a <sys_unlink+0x16a>
    80004312:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004314:	cb6fe0ef          	jal	800027ca <ilock>
  if(ip->nlink < 1)
    80004318:	04a91783          	lh	a5,74(s2)
    8000431c:	06f05863          	blez	a5,8000438c <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004320:	04491703          	lh	a4,68(s2)
    80004324:	4785                	li	a5,1
    80004326:	06f70b63          	beq	a4,a5,8000439c <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    8000432a:	fb040993          	addi	s3,s0,-80
    8000432e:	4641                	li	a2,16
    80004330:	4581                	li	a1,0
    80004332:	854e                	mv	a0,s3
    80004334:	e43fb0ef          	jal	80000176 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004338:	4741                	li	a4,16
    8000433a:	f1c42683          	lw	a3,-228(s0)
    8000433e:	864e                	mv	a2,s3
    80004340:	4581                	li	a1,0
    80004342:	8526                	mv	a0,s1
    80004344:	fd0fe0ef          	jal	80002b14 <writei>
    80004348:	47c1                	li	a5,16
    8000434a:	08f51f63          	bne	a0,a5,800043e8 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    8000434e:	04491703          	lh	a4,68(s2)
    80004352:	4785                	li	a5,1
    80004354:	0af70263          	beq	a4,a5,800043f8 <sys_unlink+0x158>
  iunlockput(dp);
    80004358:	8526                	mv	a0,s1
    8000435a:	e7afe0ef          	jal	800029d4 <iunlockput>
  ip->nlink--;
    8000435e:	04a95783          	lhu	a5,74(s2)
    80004362:	37fd                	addiw	a5,a5,-1
    80004364:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004368:	854a                	mv	a0,s2
    8000436a:	bacfe0ef          	jal	80002716 <iupdate>
  iunlockput(ip);
    8000436e:	854a                	mv	a0,s2
    80004370:	e64fe0ef          	jal	800029d4 <iunlockput>
  end_op();
    80004374:	d73fe0ef          	jal	800030e6 <end_op>
  return 0;
    80004378:	4501                	li	a0,0
    8000437a:	74ae                	ld	s1,232(sp)
    8000437c:	790e                	ld	s2,224(sp)
    8000437e:	69ee                	ld	s3,216(sp)
    80004380:	a869                	j	8000441a <sys_unlink+0x17a>
    end_op();
    80004382:	d65fe0ef          	jal	800030e6 <end_op>
    return -1;
    80004386:	557d                	li	a0,-1
    80004388:	74ae                	ld	s1,232(sp)
    8000438a:	a841                	j	8000441a <sys_unlink+0x17a>
    8000438c:	e9d2                	sd	s4,208(sp)
    8000438e:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004390:	00003517          	auipc	a0,0x3
    80004394:	32850513          	addi	a0,a0,808 # 800076b8 <etext+0x6b8>
    80004398:	26e010ef          	jal	80005606 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000439c:	04c92703          	lw	a4,76(s2)
    800043a0:	02000793          	li	a5,32
    800043a4:	f8e7f3e3          	bgeu	a5,a4,8000432a <sys_unlink+0x8a>
    800043a8:	e9d2                	sd	s4,208(sp)
    800043aa:	e5d6                	sd	s5,200(sp)
    800043ac:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043ae:	f0840a93          	addi	s5,s0,-248
    800043b2:	4a41                	li	s4,16
    800043b4:	8752                	mv	a4,s4
    800043b6:	86ce                	mv	a3,s3
    800043b8:	8656                	mv	a2,s5
    800043ba:	4581                	li	a1,0
    800043bc:	854a                	mv	a0,s2
    800043be:	e64fe0ef          	jal	80002a22 <readi>
    800043c2:	01451d63          	bne	a0,s4,800043dc <sys_unlink+0x13c>
    if(de.inum != 0)
    800043c6:	f0845783          	lhu	a5,-248(s0)
    800043ca:	efb1                	bnez	a5,80004426 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043cc:	29c1                	addiw	s3,s3,16
    800043ce:	04c92783          	lw	a5,76(s2)
    800043d2:	fef9e1e3          	bltu	s3,a5,800043b4 <sys_unlink+0x114>
    800043d6:	6a4e                	ld	s4,208(sp)
    800043d8:	6aae                	ld	s5,200(sp)
    800043da:	bf81                	j	8000432a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800043dc:	00003517          	auipc	a0,0x3
    800043e0:	2f450513          	addi	a0,a0,756 # 800076d0 <etext+0x6d0>
    800043e4:	222010ef          	jal	80005606 <panic>
    800043e8:	e9d2                	sd	s4,208(sp)
    800043ea:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800043ec:	00003517          	auipc	a0,0x3
    800043f0:	2fc50513          	addi	a0,a0,764 # 800076e8 <etext+0x6e8>
    800043f4:	212010ef          	jal	80005606 <panic>
    dp->nlink--;
    800043f8:	04a4d783          	lhu	a5,74(s1)
    800043fc:	37fd                	addiw	a5,a5,-1
    800043fe:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004402:	8526                	mv	a0,s1
    80004404:	b12fe0ef          	jal	80002716 <iupdate>
    80004408:	bf81                	j	80004358 <sys_unlink+0xb8>
    8000440a:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    8000440c:	8526                	mv	a0,s1
    8000440e:	dc6fe0ef          	jal	800029d4 <iunlockput>
  end_op();
    80004412:	cd5fe0ef          	jal	800030e6 <end_op>
  return -1;
    80004416:	557d                	li	a0,-1
    80004418:	74ae                	ld	s1,232(sp)
}
    8000441a:	70ee                	ld	ra,248(sp)
    8000441c:	744e                	ld	s0,240(sp)
    8000441e:	6111                	addi	sp,sp,256
    80004420:	8082                	ret
    return -1;
    80004422:	557d                	li	a0,-1
    80004424:	bfdd                	j	8000441a <sys_unlink+0x17a>
    iunlockput(ip);
    80004426:	854a                	mv	a0,s2
    80004428:	dacfe0ef          	jal	800029d4 <iunlockput>
    goto bad;
    8000442c:	790e                	ld	s2,224(sp)
    8000442e:	69ee                	ld	s3,216(sp)
    80004430:	6a4e                	ld	s4,208(sp)
    80004432:	6aae                	ld	s5,200(sp)
    80004434:	bfe1                	j	8000440c <sys_unlink+0x16c>

0000000080004436 <sys_open>:

uint64
sys_open(void)
{
    80004436:	7131                	addi	sp,sp,-192
    80004438:	fd06                	sd	ra,184(sp)
    8000443a:	f922                	sd	s0,176(sp)
    8000443c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000443e:	f4c40593          	addi	a1,s0,-180
    80004442:	4505                	li	a0,1
    80004444:	899fd0ef          	jal	80001cdc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004448:	08000613          	li	a2,128
    8000444c:	f5040593          	addi	a1,s0,-176
    80004450:	4501                	li	a0,0
    80004452:	8c3fd0ef          	jal	80001d14 <argstr>
    80004456:	87aa                	mv	a5,a0
    return -1;
    80004458:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000445a:	0a07c363          	bltz	a5,80004500 <sys_open+0xca>
    8000445e:	f526                	sd	s1,168(sp)

  begin_op();
    80004460:	c1dfe0ef          	jal	8000307c <begin_op>

  if(omode & O_CREATE){
    80004464:	f4c42783          	lw	a5,-180(s0)
    80004468:	2007f793          	andi	a5,a5,512
    8000446c:	c3dd                	beqz	a5,80004512 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000446e:	4681                	li	a3,0
    80004470:	4601                	li	a2,0
    80004472:	4589                	li	a1,2
    80004474:	f5040513          	addi	a0,s0,-176
    80004478:	a99ff0ef          	jal	80003f10 <create>
    8000447c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000447e:	c549                	beqz	a0,80004508 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004480:	04449703          	lh	a4,68(s1)
    80004484:	478d                	li	a5,3
    80004486:	00f71763          	bne	a4,a5,80004494 <sys_open+0x5e>
    8000448a:	0464d703          	lhu	a4,70(s1)
    8000448e:	47a5                	li	a5,9
    80004490:	0ae7ee63          	bltu	a5,a4,8000454c <sys_open+0x116>
    80004494:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004496:	f63fe0ef          	jal	800033f8 <filealloc>
    8000449a:	892a                	mv	s2,a0
    8000449c:	c561                	beqz	a0,80004564 <sys_open+0x12e>
    8000449e:	ed4e                	sd	s3,152(sp)
    800044a0:	a33ff0ef          	jal	80003ed2 <fdalloc>
    800044a4:	89aa                	mv	s3,a0
    800044a6:	0a054b63          	bltz	a0,8000455c <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800044aa:	04449703          	lh	a4,68(s1)
    800044ae:	478d                	li	a5,3
    800044b0:	0cf70363          	beq	a4,a5,80004576 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800044b4:	4789                	li	a5,2
    800044b6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800044ba:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800044be:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800044c2:	f4c42783          	lw	a5,-180(s0)
    800044c6:	0017f713          	andi	a4,a5,1
    800044ca:	00174713          	xori	a4,a4,1
    800044ce:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800044d2:	0037f713          	andi	a4,a5,3
    800044d6:	00e03733          	snez	a4,a4
    800044da:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800044de:	4007f793          	andi	a5,a5,1024
    800044e2:	c791                	beqz	a5,800044ee <sys_open+0xb8>
    800044e4:	04449703          	lh	a4,68(s1)
    800044e8:	4789                	li	a5,2
    800044ea:	08f70d63          	beq	a4,a5,80004584 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800044ee:	8526                	mv	a0,s1
    800044f0:	b88fe0ef          	jal	80002878 <iunlock>
  end_op();
    800044f4:	bf3fe0ef          	jal	800030e6 <end_op>

  return fd;
    800044f8:	854e                	mv	a0,s3
    800044fa:	74aa                	ld	s1,168(sp)
    800044fc:	790a                	ld	s2,160(sp)
    800044fe:	69ea                	ld	s3,152(sp)
}
    80004500:	70ea                	ld	ra,184(sp)
    80004502:	744a                	ld	s0,176(sp)
    80004504:	6129                	addi	sp,sp,192
    80004506:	8082                	ret
      end_op();
    80004508:	bdffe0ef          	jal	800030e6 <end_op>
      return -1;
    8000450c:	557d                	li	a0,-1
    8000450e:	74aa                	ld	s1,168(sp)
    80004510:	bfc5                	j	80004500 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004512:	f5040513          	addi	a0,s0,-176
    80004516:	9a5fe0ef          	jal	80002eba <namei>
    8000451a:	84aa                	mv	s1,a0
    8000451c:	c11d                	beqz	a0,80004542 <sys_open+0x10c>
    ilock(ip);
    8000451e:	aacfe0ef          	jal	800027ca <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004522:	04449703          	lh	a4,68(s1)
    80004526:	4785                	li	a5,1
    80004528:	f4f71ce3          	bne	a4,a5,80004480 <sys_open+0x4a>
    8000452c:	f4c42783          	lw	a5,-180(s0)
    80004530:	d3b5                	beqz	a5,80004494 <sys_open+0x5e>
      iunlockput(ip);
    80004532:	8526                	mv	a0,s1
    80004534:	ca0fe0ef          	jal	800029d4 <iunlockput>
      end_op();
    80004538:	baffe0ef          	jal	800030e6 <end_op>
      return -1;
    8000453c:	557d                	li	a0,-1
    8000453e:	74aa                	ld	s1,168(sp)
    80004540:	b7c1                	j	80004500 <sys_open+0xca>
      end_op();
    80004542:	ba5fe0ef          	jal	800030e6 <end_op>
      return -1;
    80004546:	557d                	li	a0,-1
    80004548:	74aa                	ld	s1,168(sp)
    8000454a:	bf5d                	j	80004500 <sys_open+0xca>
    iunlockput(ip);
    8000454c:	8526                	mv	a0,s1
    8000454e:	c86fe0ef          	jal	800029d4 <iunlockput>
    end_op();
    80004552:	b95fe0ef          	jal	800030e6 <end_op>
    return -1;
    80004556:	557d                	li	a0,-1
    80004558:	74aa                	ld	s1,168(sp)
    8000455a:	b75d                	j	80004500 <sys_open+0xca>
      fileclose(f);
    8000455c:	854a                	mv	a0,s2
    8000455e:	f3ffe0ef          	jal	8000349c <fileclose>
    80004562:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004564:	8526                	mv	a0,s1
    80004566:	c6efe0ef          	jal	800029d4 <iunlockput>
    end_op();
    8000456a:	b7dfe0ef          	jal	800030e6 <end_op>
    return -1;
    8000456e:	557d                	li	a0,-1
    80004570:	74aa                	ld	s1,168(sp)
    80004572:	790a                	ld	s2,160(sp)
    80004574:	b771                	j	80004500 <sys_open+0xca>
    f->type = FD_DEVICE;
    80004576:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000457a:	04649783          	lh	a5,70(s1)
    8000457e:	02f91223          	sh	a5,36(s2)
    80004582:	bf35                	j	800044be <sys_open+0x88>
    itrunc(ip);
    80004584:	8526                	mv	a0,s1
    80004586:	b32fe0ef          	jal	800028b8 <itrunc>
    8000458a:	b795                	j	800044ee <sys_open+0xb8>

000000008000458c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000458c:	7175                	addi	sp,sp,-144
    8000458e:	e506                	sd	ra,136(sp)
    80004590:	e122                	sd	s0,128(sp)
    80004592:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004594:	ae9fe0ef          	jal	8000307c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004598:	08000613          	li	a2,128
    8000459c:	f7040593          	addi	a1,s0,-144
    800045a0:	4501                	li	a0,0
    800045a2:	f72fd0ef          	jal	80001d14 <argstr>
    800045a6:	02054363          	bltz	a0,800045cc <sys_mkdir+0x40>
    800045aa:	4681                	li	a3,0
    800045ac:	4601                	li	a2,0
    800045ae:	4585                	li	a1,1
    800045b0:	f7040513          	addi	a0,s0,-144
    800045b4:	95dff0ef          	jal	80003f10 <create>
    800045b8:	c911                	beqz	a0,800045cc <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045ba:	c1afe0ef          	jal	800029d4 <iunlockput>
  end_op();
    800045be:	b29fe0ef          	jal	800030e6 <end_op>
  return 0;
    800045c2:	4501                	li	a0,0
}
    800045c4:	60aa                	ld	ra,136(sp)
    800045c6:	640a                	ld	s0,128(sp)
    800045c8:	6149                	addi	sp,sp,144
    800045ca:	8082                	ret
    end_op();
    800045cc:	b1bfe0ef          	jal	800030e6 <end_op>
    return -1;
    800045d0:	557d                	li	a0,-1
    800045d2:	bfcd                	j	800045c4 <sys_mkdir+0x38>

00000000800045d4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800045d4:	7135                	addi	sp,sp,-160
    800045d6:	ed06                	sd	ra,152(sp)
    800045d8:	e922                	sd	s0,144(sp)
    800045da:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800045dc:	aa1fe0ef          	jal	8000307c <begin_op>
  argint(1, &major);
    800045e0:	f6c40593          	addi	a1,s0,-148
    800045e4:	4505                	li	a0,1
    800045e6:	ef6fd0ef          	jal	80001cdc <argint>
  argint(2, &minor);
    800045ea:	f6840593          	addi	a1,s0,-152
    800045ee:	4509                	li	a0,2
    800045f0:	eecfd0ef          	jal	80001cdc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045f4:	08000613          	li	a2,128
    800045f8:	f7040593          	addi	a1,s0,-144
    800045fc:	4501                	li	a0,0
    800045fe:	f16fd0ef          	jal	80001d14 <argstr>
    80004602:	02054563          	bltz	a0,8000462c <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004606:	f6841683          	lh	a3,-152(s0)
    8000460a:	f6c41603          	lh	a2,-148(s0)
    8000460e:	458d                	li	a1,3
    80004610:	f7040513          	addi	a0,s0,-144
    80004614:	8fdff0ef          	jal	80003f10 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004618:	c911                	beqz	a0,8000462c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000461a:	bbafe0ef          	jal	800029d4 <iunlockput>
  end_op();
    8000461e:	ac9fe0ef          	jal	800030e6 <end_op>
  return 0;
    80004622:	4501                	li	a0,0
}
    80004624:	60ea                	ld	ra,152(sp)
    80004626:	644a                	ld	s0,144(sp)
    80004628:	610d                	addi	sp,sp,160
    8000462a:	8082                	ret
    end_op();
    8000462c:	abbfe0ef          	jal	800030e6 <end_op>
    return -1;
    80004630:	557d                	li	a0,-1
    80004632:	bfcd                	j	80004624 <sys_mknod+0x50>

0000000080004634 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004634:	7135                	addi	sp,sp,-160
    80004636:	ed06                	sd	ra,152(sp)
    80004638:	e922                	sd	s0,144(sp)
    8000463a:	e14a                	sd	s2,128(sp)
    8000463c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000463e:	f4efc0ef          	jal	80000d8c <myproc>
    80004642:	892a                	mv	s2,a0
  
  begin_op();
    80004644:	a39fe0ef          	jal	8000307c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004648:	08000613          	li	a2,128
    8000464c:	f6040593          	addi	a1,s0,-160
    80004650:	4501                	li	a0,0
    80004652:	ec2fd0ef          	jal	80001d14 <argstr>
    80004656:	04054363          	bltz	a0,8000469c <sys_chdir+0x68>
    8000465a:	e526                	sd	s1,136(sp)
    8000465c:	f6040513          	addi	a0,s0,-160
    80004660:	85bfe0ef          	jal	80002eba <namei>
    80004664:	84aa                	mv	s1,a0
    80004666:	c915                	beqz	a0,8000469a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004668:	962fe0ef          	jal	800027ca <ilock>
  if(ip->type != T_DIR){
    8000466c:	04449703          	lh	a4,68(s1)
    80004670:	4785                	li	a5,1
    80004672:	02f71963          	bne	a4,a5,800046a4 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004676:	8526                	mv	a0,s1
    80004678:	a00fe0ef          	jal	80002878 <iunlock>
  iput(p->cwd);
    8000467c:	15093503          	ld	a0,336(s2)
    80004680:	accfe0ef          	jal	8000294c <iput>
  end_op();
    80004684:	a63fe0ef          	jal	800030e6 <end_op>
  p->cwd = ip;
    80004688:	14993823          	sd	s1,336(s2)
  return 0;
    8000468c:	4501                	li	a0,0
    8000468e:	64aa                	ld	s1,136(sp)
}
    80004690:	60ea                	ld	ra,152(sp)
    80004692:	644a                	ld	s0,144(sp)
    80004694:	690a                	ld	s2,128(sp)
    80004696:	610d                	addi	sp,sp,160
    80004698:	8082                	ret
    8000469a:	64aa                	ld	s1,136(sp)
    end_op();
    8000469c:	a4bfe0ef          	jal	800030e6 <end_op>
    return -1;
    800046a0:	557d                	li	a0,-1
    800046a2:	b7fd                	j	80004690 <sys_chdir+0x5c>
    iunlockput(ip);
    800046a4:	8526                	mv	a0,s1
    800046a6:	b2efe0ef          	jal	800029d4 <iunlockput>
    end_op();
    800046aa:	a3dfe0ef          	jal	800030e6 <end_op>
    return -1;
    800046ae:	557d                	li	a0,-1
    800046b0:	64aa                	ld	s1,136(sp)
    800046b2:	bff9                	j	80004690 <sys_chdir+0x5c>

00000000800046b4 <sys_exec>:

uint64
sys_exec(void)
{
    800046b4:	7105                	addi	sp,sp,-480
    800046b6:	ef86                	sd	ra,472(sp)
    800046b8:	eba2                	sd	s0,464(sp)
    800046ba:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800046bc:	e2840593          	addi	a1,s0,-472
    800046c0:	4505                	li	a0,1
    800046c2:	e36fd0ef          	jal	80001cf8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800046c6:	08000613          	li	a2,128
    800046ca:	f3040593          	addi	a1,s0,-208
    800046ce:	4501                	li	a0,0
    800046d0:	e44fd0ef          	jal	80001d14 <argstr>
    800046d4:	87aa                	mv	a5,a0
    return -1;
    800046d6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800046d8:	0e07c063          	bltz	a5,800047b8 <sys_exec+0x104>
    800046dc:	e7a6                	sd	s1,456(sp)
    800046de:	e3ca                	sd	s2,448(sp)
    800046e0:	ff4e                	sd	s3,440(sp)
    800046e2:	fb52                	sd	s4,432(sp)
    800046e4:	f756                	sd	s5,424(sp)
    800046e6:	f35a                	sd	s6,416(sp)
    800046e8:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800046ea:	e3040a13          	addi	s4,s0,-464
    800046ee:	10000613          	li	a2,256
    800046f2:	4581                	li	a1,0
    800046f4:	8552                	mv	a0,s4
    800046f6:	a81fb0ef          	jal	80000176 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800046fa:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800046fc:	89d2                	mv	s3,s4
    800046fe:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004700:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004704:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004706:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000470a:	00391513          	slli	a0,s2,0x3
    8000470e:	85d6                	mv	a1,s5
    80004710:	e2843783          	ld	a5,-472(s0)
    80004714:	953e                	add	a0,a0,a5
    80004716:	d3cfd0ef          	jal	80001c52 <fetchaddr>
    8000471a:	02054663          	bltz	a0,80004746 <sys_exec+0x92>
    if(uarg == 0){
    8000471e:	e2043783          	ld	a5,-480(s0)
    80004722:	c7a1                	beqz	a5,8000476a <sys_exec+0xb6>
    argv[i] = kalloc();
    80004724:	9d3fb0ef          	jal	800000f6 <kalloc>
    80004728:	85aa                	mv	a1,a0
    8000472a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000472e:	cd01                	beqz	a0,80004746 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004730:	865a                	mv	a2,s6
    80004732:	e2043503          	ld	a0,-480(s0)
    80004736:	d66fd0ef          	jal	80001c9c <fetchstr>
    8000473a:	00054663          	bltz	a0,80004746 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000473e:	0905                	addi	s2,s2,1
    80004740:	09a1                	addi	s3,s3,8
    80004742:	fd7914e3          	bne	s2,s7,8000470a <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004746:	100a0a13          	addi	s4,s4,256
    8000474a:	6088                	ld	a0,0(s1)
    8000474c:	cd31                	beqz	a0,800047a8 <sys_exec+0xf4>
    kfree(argv[i]);
    8000474e:	8cffb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004752:	04a1                	addi	s1,s1,8
    80004754:	ff449be3          	bne	s1,s4,8000474a <sys_exec+0x96>
  return -1;
    80004758:	557d                	li	a0,-1
    8000475a:	64be                	ld	s1,456(sp)
    8000475c:	691e                	ld	s2,448(sp)
    8000475e:	79fa                	ld	s3,440(sp)
    80004760:	7a5a                	ld	s4,432(sp)
    80004762:	7aba                	ld	s5,424(sp)
    80004764:	7b1a                	ld	s6,416(sp)
    80004766:	6bfa                	ld	s7,408(sp)
    80004768:	a881                	j	800047b8 <sys_exec+0x104>
      argv[i] = 0;
    8000476a:	0009079b          	sext.w	a5,s2
    8000476e:	e3040593          	addi	a1,s0,-464
    80004772:	078e                	slli	a5,a5,0x3
    80004774:	97ae                	add	a5,a5,a1
    80004776:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    8000477a:	f3040513          	addi	a0,s0,-208
    8000477e:	ba4ff0ef          	jal	80003b22 <exec>
    80004782:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004784:	100a0a13          	addi	s4,s4,256
    80004788:	6088                	ld	a0,0(s1)
    8000478a:	c511                	beqz	a0,80004796 <sys_exec+0xe2>
    kfree(argv[i]);
    8000478c:	891fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004790:	04a1                	addi	s1,s1,8
    80004792:	ff449be3          	bne	s1,s4,80004788 <sys_exec+0xd4>
  return ret;
    80004796:	854a                	mv	a0,s2
    80004798:	64be                	ld	s1,456(sp)
    8000479a:	691e                	ld	s2,448(sp)
    8000479c:	79fa                	ld	s3,440(sp)
    8000479e:	7a5a                	ld	s4,432(sp)
    800047a0:	7aba                	ld	s5,424(sp)
    800047a2:	7b1a                	ld	s6,416(sp)
    800047a4:	6bfa                	ld	s7,408(sp)
    800047a6:	a809                	j	800047b8 <sys_exec+0x104>
  return -1;
    800047a8:	557d                	li	a0,-1
    800047aa:	64be                	ld	s1,456(sp)
    800047ac:	691e                	ld	s2,448(sp)
    800047ae:	79fa                	ld	s3,440(sp)
    800047b0:	7a5a                	ld	s4,432(sp)
    800047b2:	7aba                	ld	s5,424(sp)
    800047b4:	7b1a                	ld	s6,416(sp)
    800047b6:	6bfa                	ld	s7,408(sp)
}
    800047b8:	60fe                	ld	ra,472(sp)
    800047ba:	645e                	ld	s0,464(sp)
    800047bc:	613d                	addi	sp,sp,480
    800047be:	8082                	ret

00000000800047c0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800047c0:	7139                	addi	sp,sp,-64
    800047c2:	fc06                	sd	ra,56(sp)
    800047c4:	f822                	sd	s0,48(sp)
    800047c6:	f426                	sd	s1,40(sp)
    800047c8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800047ca:	dc2fc0ef          	jal	80000d8c <myproc>
    800047ce:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800047d0:	fd840593          	addi	a1,s0,-40
    800047d4:	4501                	li	a0,0
    800047d6:	d22fd0ef          	jal	80001cf8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800047da:	fc840593          	addi	a1,s0,-56
    800047de:	fd040513          	addi	a0,s0,-48
    800047e2:	81eff0ef          	jal	80003800 <pipealloc>
    return -1;
    800047e6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800047e8:	0a054463          	bltz	a0,80004890 <sys_pipe+0xd0>
  fd0 = -1;
    800047ec:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800047f0:	fd043503          	ld	a0,-48(s0)
    800047f4:	edeff0ef          	jal	80003ed2 <fdalloc>
    800047f8:	fca42223          	sw	a0,-60(s0)
    800047fc:	08054163          	bltz	a0,8000487e <sys_pipe+0xbe>
    80004800:	fc843503          	ld	a0,-56(s0)
    80004804:	eceff0ef          	jal	80003ed2 <fdalloc>
    80004808:	fca42023          	sw	a0,-64(s0)
    8000480c:	06054063          	bltz	a0,8000486c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004810:	4691                	li	a3,4
    80004812:	fc440613          	addi	a2,s0,-60
    80004816:	fd843583          	ld	a1,-40(s0)
    8000481a:	68a8                	ld	a0,80(s1)
    8000481c:	a18fc0ef          	jal	80000a34 <copyout>
    80004820:	00054e63          	bltz	a0,8000483c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004824:	4691                	li	a3,4
    80004826:	fc040613          	addi	a2,s0,-64
    8000482a:	fd843583          	ld	a1,-40(s0)
    8000482e:	95b6                	add	a1,a1,a3
    80004830:	68a8                	ld	a0,80(s1)
    80004832:	a02fc0ef          	jal	80000a34 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004836:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004838:	04055c63          	bgez	a0,80004890 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000483c:	fc442783          	lw	a5,-60(s0)
    80004840:	07e9                	addi	a5,a5,26
    80004842:	078e                	slli	a5,a5,0x3
    80004844:	97a6                	add	a5,a5,s1
    80004846:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000484a:	fc042783          	lw	a5,-64(s0)
    8000484e:	07e9                	addi	a5,a5,26
    80004850:	078e                	slli	a5,a5,0x3
    80004852:	94be                	add	s1,s1,a5
    80004854:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004858:	fd043503          	ld	a0,-48(s0)
    8000485c:	c41fe0ef          	jal	8000349c <fileclose>
    fileclose(wf);
    80004860:	fc843503          	ld	a0,-56(s0)
    80004864:	c39fe0ef          	jal	8000349c <fileclose>
    return -1;
    80004868:	57fd                	li	a5,-1
    8000486a:	a01d                	j	80004890 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000486c:	fc442783          	lw	a5,-60(s0)
    80004870:	0007c763          	bltz	a5,8000487e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004874:	07e9                	addi	a5,a5,26
    80004876:	078e                	slli	a5,a5,0x3
    80004878:	97a6                	add	a5,a5,s1
    8000487a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000487e:	fd043503          	ld	a0,-48(s0)
    80004882:	c1bfe0ef          	jal	8000349c <fileclose>
    fileclose(wf);
    80004886:	fc843503          	ld	a0,-56(s0)
    8000488a:	c13fe0ef          	jal	8000349c <fileclose>
    return -1;
    8000488e:	57fd                	li	a5,-1
}
    80004890:	853e                	mv	a0,a5
    80004892:	70e2                	ld	ra,56(sp)
    80004894:	7442                	ld	s0,48(sp)
    80004896:	74a2                	ld	s1,40(sp)
    80004898:	6121                	addi	sp,sp,64
    8000489a:	8082                	ret
    8000489c:	0000                	unimp
	...

00000000800048a0 <kernelvec>:
    800048a0:	7111                	addi	sp,sp,-256
    800048a2:	e006                	sd	ra,0(sp)
    800048a4:	e40a                	sd	sp,8(sp)
    800048a6:	e80e                	sd	gp,16(sp)
    800048a8:	ec12                	sd	tp,24(sp)
    800048aa:	f016                	sd	t0,32(sp)
    800048ac:	f41a                	sd	t1,40(sp)
    800048ae:	f81e                	sd	t2,48(sp)
    800048b0:	e4aa                	sd	a0,72(sp)
    800048b2:	e8ae                	sd	a1,80(sp)
    800048b4:	ecb2                	sd	a2,88(sp)
    800048b6:	f0b6                	sd	a3,96(sp)
    800048b8:	f4ba                	sd	a4,104(sp)
    800048ba:	f8be                	sd	a5,112(sp)
    800048bc:	fcc2                	sd	a6,120(sp)
    800048be:	e146                	sd	a7,128(sp)
    800048c0:	edf2                	sd	t3,216(sp)
    800048c2:	f1f6                	sd	t4,224(sp)
    800048c4:	f5fa                	sd	t5,232(sp)
    800048c6:	f9fe                	sd	t6,240(sp)
    800048c8:	a9afd0ef          	jal	80001b62 <kerneltrap>
    800048cc:	6082                	ld	ra,0(sp)
    800048ce:	6122                	ld	sp,8(sp)
    800048d0:	61c2                	ld	gp,16(sp)
    800048d2:	7282                	ld	t0,32(sp)
    800048d4:	7322                	ld	t1,40(sp)
    800048d6:	73c2                	ld	t2,48(sp)
    800048d8:	6526                	ld	a0,72(sp)
    800048da:	65c6                	ld	a1,80(sp)
    800048dc:	6666                	ld	a2,88(sp)
    800048de:	7686                	ld	a3,96(sp)
    800048e0:	7726                	ld	a4,104(sp)
    800048e2:	77c6                	ld	a5,112(sp)
    800048e4:	7866                	ld	a6,120(sp)
    800048e6:	688a                	ld	a7,128(sp)
    800048e8:	6e6e                	ld	t3,216(sp)
    800048ea:	7e8e                	ld	t4,224(sp)
    800048ec:	7f2e                	ld	t5,232(sp)
    800048ee:	7fce                	ld	t6,240(sp)
    800048f0:	6111                	addi	sp,sp,256
    800048f2:	10200073          	sret
	...

00000000800048fe <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800048fe:	1141                	addi	sp,sp,-16
    80004900:	e406                	sd	ra,8(sp)
    80004902:	e022                	sd	s0,0(sp)
    80004904:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004906:	0c000737          	lui	a4,0xc000
    8000490a:	4785                	li	a5,1
    8000490c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000490e:	c35c                	sw	a5,4(a4)
}
    80004910:	60a2                	ld	ra,8(sp)
    80004912:	6402                	ld	s0,0(sp)
    80004914:	0141                	addi	sp,sp,16
    80004916:	8082                	ret

0000000080004918 <plicinithart>:

void
plicinithart(void)
{
    80004918:	1141                	addi	sp,sp,-16
    8000491a:	e406                	sd	ra,8(sp)
    8000491c:	e022                	sd	s0,0(sp)
    8000491e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004920:	c38fc0ef          	jal	80000d58 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004924:	0085171b          	slliw	a4,a0,0x8
    80004928:	0c0027b7          	lui	a5,0xc002
    8000492c:	97ba                	add	a5,a5,a4
    8000492e:	40200713          	li	a4,1026
    80004932:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004936:	00d5151b          	slliw	a0,a0,0xd
    8000493a:	0c2017b7          	lui	a5,0xc201
    8000493e:	97aa                	add	a5,a5,a0
    80004940:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004944:	60a2                	ld	ra,8(sp)
    80004946:	6402                	ld	s0,0(sp)
    80004948:	0141                	addi	sp,sp,16
    8000494a:	8082                	ret

000000008000494c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000494c:	1141                	addi	sp,sp,-16
    8000494e:	e406                	sd	ra,8(sp)
    80004950:	e022                	sd	s0,0(sp)
    80004952:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004954:	c04fc0ef          	jal	80000d58 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004958:	00d5151b          	slliw	a0,a0,0xd
    8000495c:	0c2017b7          	lui	a5,0xc201
    80004960:	97aa                	add	a5,a5,a0
  return irq;
}
    80004962:	43c8                	lw	a0,4(a5)
    80004964:	60a2                	ld	ra,8(sp)
    80004966:	6402                	ld	s0,0(sp)
    80004968:	0141                	addi	sp,sp,16
    8000496a:	8082                	ret

000000008000496c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000496c:	1101                	addi	sp,sp,-32
    8000496e:	ec06                	sd	ra,24(sp)
    80004970:	e822                	sd	s0,16(sp)
    80004972:	e426                	sd	s1,8(sp)
    80004974:	1000                	addi	s0,sp,32
    80004976:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004978:	be0fc0ef          	jal	80000d58 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000497c:	00d5179b          	slliw	a5,a0,0xd
    80004980:	0c201737          	lui	a4,0xc201
    80004984:	97ba                	add	a5,a5,a4
    80004986:	c3c4                	sw	s1,4(a5)
}
    80004988:	60e2                	ld	ra,24(sp)
    8000498a:	6442                	ld	s0,16(sp)
    8000498c:	64a2                	ld	s1,8(sp)
    8000498e:	6105                	addi	sp,sp,32
    80004990:	8082                	ret

0000000080004992 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004992:	1141                	addi	sp,sp,-16
    80004994:	e406                	sd	ra,8(sp)
    80004996:	e022                	sd	s0,0(sp)
    80004998:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000499a:	479d                	li	a5,7
    8000499c:	04a7ca63          	blt	a5,a0,800049f0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800049a0:	00017797          	auipc	a5,0x17
    800049a4:	f3078793          	addi	a5,a5,-208 # 8001b8d0 <disk>
    800049a8:	97aa                	add	a5,a5,a0
    800049aa:	0187c783          	lbu	a5,24(a5)
    800049ae:	e7b9                	bnez	a5,800049fc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800049b0:	00451693          	slli	a3,a0,0x4
    800049b4:	00017797          	auipc	a5,0x17
    800049b8:	f1c78793          	addi	a5,a5,-228 # 8001b8d0 <disk>
    800049bc:	6398                	ld	a4,0(a5)
    800049be:	9736                	add	a4,a4,a3
    800049c0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800049c4:	6398                	ld	a4,0(a5)
    800049c6:	9736                	add	a4,a4,a3
    800049c8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800049cc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800049d0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800049d4:	97aa                	add	a5,a5,a0
    800049d6:	4705                	li	a4,1
    800049d8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800049dc:	00017517          	auipc	a0,0x17
    800049e0:	f0c50513          	addi	a0,a0,-244 # 8001b8e8 <disk+0x18>
    800049e4:	9cffc0ef          	jal	800013b2 <wakeup>
}
    800049e8:	60a2                	ld	ra,8(sp)
    800049ea:	6402                	ld	s0,0(sp)
    800049ec:	0141                	addi	sp,sp,16
    800049ee:	8082                	ret
    panic("free_desc 1");
    800049f0:	00003517          	auipc	a0,0x3
    800049f4:	d0850513          	addi	a0,a0,-760 # 800076f8 <etext+0x6f8>
    800049f8:	40f000ef          	jal	80005606 <panic>
    panic("free_desc 2");
    800049fc:	00003517          	auipc	a0,0x3
    80004a00:	d0c50513          	addi	a0,a0,-756 # 80007708 <etext+0x708>
    80004a04:	403000ef          	jal	80005606 <panic>

0000000080004a08 <virtio_disk_init>:
{
    80004a08:	1101                	addi	sp,sp,-32
    80004a0a:	ec06                	sd	ra,24(sp)
    80004a0c:	e822                	sd	s0,16(sp)
    80004a0e:	e426                	sd	s1,8(sp)
    80004a10:	e04a                	sd	s2,0(sp)
    80004a12:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004a14:	00003597          	auipc	a1,0x3
    80004a18:	d0458593          	addi	a1,a1,-764 # 80007718 <etext+0x718>
    80004a1c:	00017517          	auipc	a0,0x17
    80004a20:	fdc50513          	addi	a0,a0,-36 # 8001b9f8 <disk+0x128>
    80004a24:	68d000ef          	jal	800058b0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a28:	100017b7          	lui	a5,0x10001
    80004a2c:	4398                	lw	a4,0(a5)
    80004a2e:	2701                	sext.w	a4,a4
    80004a30:	747277b7          	lui	a5,0x74727
    80004a34:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004a38:	14f71863          	bne	a4,a5,80004b88 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a3c:	100017b7          	lui	a5,0x10001
    80004a40:	43dc                	lw	a5,4(a5)
    80004a42:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a44:	4709                	li	a4,2
    80004a46:	14e79163          	bne	a5,a4,80004b88 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a4a:	100017b7          	lui	a5,0x10001
    80004a4e:	479c                	lw	a5,8(a5)
    80004a50:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a52:	12e79b63          	bne	a5,a4,80004b88 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004a56:	100017b7          	lui	a5,0x10001
    80004a5a:	47d8                	lw	a4,12(a5)
    80004a5c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a5e:	554d47b7          	lui	a5,0x554d4
    80004a62:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a66:	12f71163          	bne	a4,a5,80004b88 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a6a:	100017b7          	lui	a5,0x10001
    80004a6e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a72:	4705                	li	a4,1
    80004a74:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a76:	470d                	li	a4,3
    80004a78:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a7a:	10001737          	lui	a4,0x10001
    80004a7e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a80:	c7ffe6b7          	lui	a3,0xc7ffe
    80004a84:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdac4f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a88:	8f75                	and	a4,a4,a3
    80004a8a:	100016b7          	lui	a3,0x10001
    80004a8e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a90:	472d                	li	a4,11
    80004a92:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a94:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a98:	439c                	lw	a5,0(a5)
    80004a9a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a9e:	8ba1                	andi	a5,a5,8
    80004aa0:	0e078a63          	beqz	a5,80004b94 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004aa4:	100017b7          	lui	a5,0x10001
    80004aa8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004aac:	43fc                	lw	a5,68(a5)
    80004aae:	2781                	sext.w	a5,a5
    80004ab0:	0e079863          	bnez	a5,80004ba0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004ab4:	100017b7          	lui	a5,0x10001
    80004ab8:	5bdc                	lw	a5,52(a5)
    80004aba:	2781                	sext.w	a5,a5
  if(max == 0)
    80004abc:	0e078863          	beqz	a5,80004bac <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004ac0:	471d                	li	a4,7
    80004ac2:	0ef77b63          	bgeu	a4,a5,80004bb8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004ac6:	e30fb0ef          	jal	800000f6 <kalloc>
    80004aca:	00017497          	auipc	s1,0x17
    80004ace:	e0648493          	addi	s1,s1,-506 # 8001b8d0 <disk>
    80004ad2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004ad4:	e22fb0ef          	jal	800000f6 <kalloc>
    80004ad8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004ada:	e1cfb0ef          	jal	800000f6 <kalloc>
    80004ade:	87aa                	mv	a5,a0
    80004ae0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004ae2:	6088                	ld	a0,0(s1)
    80004ae4:	0e050063          	beqz	a0,80004bc4 <virtio_disk_init+0x1bc>
    80004ae8:	00017717          	auipc	a4,0x17
    80004aec:	df073703          	ld	a4,-528(a4) # 8001b8d8 <disk+0x8>
    80004af0:	cb71                	beqz	a4,80004bc4 <virtio_disk_init+0x1bc>
    80004af2:	cbe9                	beqz	a5,80004bc4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004af4:	6605                	lui	a2,0x1
    80004af6:	4581                	li	a1,0
    80004af8:	e7efb0ef          	jal	80000176 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004afc:	00017497          	auipc	s1,0x17
    80004b00:	dd448493          	addi	s1,s1,-556 # 8001b8d0 <disk>
    80004b04:	6605                	lui	a2,0x1
    80004b06:	4581                	li	a1,0
    80004b08:	6488                	ld	a0,8(s1)
    80004b0a:	e6cfb0ef          	jal	80000176 <memset>
  memset(disk.used, 0, PGSIZE);
    80004b0e:	6605                	lui	a2,0x1
    80004b10:	4581                	li	a1,0
    80004b12:	6888                	ld	a0,16(s1)
    80004b14:	e62fb0ef          	jal	80000176 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004b18:	100017b7          	lui	a5,0x10001
    80004b1c:	4721                	li	a4,8
    80004b1e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004b20:	4098                	lw	a4,0(s1)
    80004b22:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004b26:	40d8                	lw	a4,4(s1)
    80004b28:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004b2c:	649c                	ld	a5,8(s1)
    80004b2e:	0007869b          	sext.w	a3,a5
    80004b32:	10001737          	lui	a4,0x10001
    80004b36:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004b3a:	9781                	srai	a5,a5,0x20
    80004b3c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b40:	689c                	ld	a5,16(s1)
    80004b42:	0007869b          	sext.w	a3,a5
    80004b46:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b4a:	9781                	srai	a5,a5,0x20
    80004b4c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004b50:	4785                	li	a5,1
    80004b52:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b54:	00f48c23          	sb	a5,24(s1)
    80004b58:	00f48ca3          	sb	a5,25(s1)
    80004b5c:	00f48d23          	sb	a5,26(s1)
    80004b60:	00f48da3          	sb	a5,27(s1)
    80004b64:	00f48e23          	sb	a5,28(s1)
    80004b68:	00f48ea3          	sb	a5,29(s1)
    80004b6c:	00f48f23          	sb	a5,30(s1)
    80004b70:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b74:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b78:	07272823          	sw	s2,112(a4)
}
    80004b7c:	60e2                	ld	ra,24(sp)
    80004b7e:	6442                	ld	s0,16(sp)
    80004b80:	64a2                	ld	s1,8(sp)
    80004b82:	6902                	ld	s2,0(sp)
    80004b84:	6105                	addi	sp,sp,32
    80004b86:	8082                	ret
    panic("could not find virtio disk");
    80004b88:	00003517          	auipc	a0,0x3
    80004b8c:	ba050513          	addi	a0,a0,-1120 # 80007728 <etext+0x728>
    80004b90:	277000ef          	jal	80005606 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b94:	00003517          	auipc	a0,0x3
    80004b98:	bb450513          	addi	a0,a0,-1100 # 80007748 <etext+0x748>
    80004b9c:	26b000ef          	jal	80005606 <panic>
    panic("virtio disk should not be ready");
    80004ba0:	00003517          	auipc	a0,0x3
    80004ba4:	bc850513          	addi	a0,a0,-1080 # 80007768 <etext+0x768>
    80004ba8:	25f000ef          	jal	80005606 <panic>
    panic("virtio disk has no queue 0");
    80004bac:	00003517          	auipc	a0,0x3
    80004bb0:	bdc50513          	addi	a0,a0,-1060 # 80007788 <etext+0x788>
    80004bb4:	253000ef          	jal	80005606 <panic>
    panic("virtio disk max queue too short");
    80004bb8:	00003517          	auipc	a0,0x3
    80004bbc:	bf050513          	addi	a0,a0,-1040 # 800077a8 <etext+0x7a8>
    80004bc0:	247000ef          	jal	80005606 <panic>
    panic("virtio disk kalloc");
    80004bc4:	00003517          	auipc	a0,0x3
    80004bc8:	c0450513          	addi	a0,a0,-1020 # 800077c8 <etext+0x7c8>
    80004bcc:	23b000ef          	jal	80005606 <panic>

0000000080004bd0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004bd0:	711d                	addi	sp,sp,-96
    80004bd2:	ec86                	sd	ra,88(sp)
    80004bd4:	e8a2                	sd	s0,80(sp)
    80004bd6:	e4a6                	sd	s1,72(sp)
    80004bd8:	e0ca                	sd	s2,64(sp)
    80004bda:	fc4e                	sd	s3,56(sp)
    80004bdc:	f852                	sd	s4,48(sp)
    80004bde:	f456                	sd	s5,40(sp)
    80004be0:	f05a                	sd	s6,32(sp)
    80004be2:	ec5e                	sd	s7,24(sp)
    80004be4:	e862                	sd	s8,16(sp)
    80004be6:	1080                	addi	s0,sp,96
    80004be8:	89aa                	mv	s3,a0
    80004bea:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004bec:	00c52b83          	lw	s7,12(a0)
    80004bf0:	001b9b9b          	slliw	s7,s7,0x1
    80004bf4:	1b82                	slli	s7,s7,0x20
    80004bf6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004bfa:	00017517          	auipc	a0,0x17
    80004bfe:	dfe50513          	addi	a0,a0,-514 # 8001b9f8 <disk+0x128>
    80004c02:	533000ef          	jal	80005934 <acquire>
  for(int i = 0; i < NUM; i++){
    80004c06:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004c08:	00017a97          	auipc	s5,0x17
    80004c0c:	cc8a8a93          	addi	s5,s5,-824 # 8001b8d0 <disk>
  for(int i = 0; i < 3; i++){
    80004c10:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004c12:	5c7d                	li	s8,-1
    80004c14:	a095                	j	80004c78 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004c16:	00fa8733          	add	a4,s5,a5
    80004c1a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004c1e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004c20:	0207c563          	bltz	a5,80004c4a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004c24:	2905                	addiw	s2,s2,1
    80004c26:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c28:	05490c63          	beq	s2,s4,80004c80 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004c2c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c2e:	00017717          	auipc	a4,0x17
    80004c32:	ca270713          	addi	a4,a4,-862 # 8001b8d0 <disk>
    80004c36:	4781                	li	a5,0
    if(disk.free[i]){
    80004c38:	01874683          	lbu	a3,24(a4)
    80004c3c:	fee9                	bnez	a3,80004c16 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004c3e:	2785                	addiw	a5,a5,1
    80004c40:	0705                	addi	a4,a4,1
    80004c42:	fe979be3          	bne	a5,s1,80004c38 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004c46:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004c4a:	01205d63          	blez	s2,80004c64 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c4e:	fa042503          	lw	a0,-96(s0)
    80004c52:	d41ff0ef          	jal	80004992 <free_desc>
      for(int j = 0; j < i; j++)
    80004c56:	4785                	li	a5,1
    80004c58:	0127d663          	bge	a5,s2,80004c64 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c5c:	fa442503          	lw	a0,-92(s0)
    80004c60:	d33ff0ef          	jal	80004992 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c64:	00017597          	auipc	a1,0x17
    80004c68:	d9458593          	addi	a1,a1,-620 # 8001b9f8 <disk+0x128>
    80004c6c:	00017517          	auipc	a0,0x17
    80004c70:	c7c50513          	addi	a0,a0,-900 # 8001b8e8 <disk+0x18>
    80004c74:	ef2fc0ef          	jal	80001366 <sleep>
  for(int i = 0; i < 3; i++){
    80004c78:	fa040613          	addi	a2,s0,-96
    80004c7c:	4901                	li	s2,0
    80004c7e:	b77d                	j	80004c2c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c80:	fa042503          	lw	a0,-96(s0)
    80004c84:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c88:	00017797          	auipc	a5,0x17
    80004c8c:	c4878793          	addi	a5,a5,-952 # 8001b8d0 <disk>
    80004c90:	00a50713          	addi	a4,a0,10
    80004c94:	0712                	slli	a4,a4,0x4
    80004c96:	973e                	add	a4,a4,a5
    80004c98:	01603633          	snez	a2,s6
    80004c9c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c9e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004ca2:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ca6:	6398                	ld	a4,0(a5)
    80004ca8:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004caa:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004cae:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004cb0:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004cb2:	6390                	ld	a2,0(a5)
    80004cb4:	00d605b3          	add	a1,a2,a3
    80004cb8:	4741                	li	a4,16
    80004cba:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004cbc:	4805                	li	a6,1
    80004cbe:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004cc2:	fa442703          	lw	a4,-92(s0)
    80004cc6:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004cca:	0712                	slli	a4,a4,0x4
    80004ccc:	963a                	add	a2,a2,a4
    80004cce:	05898593          	addi	a1,s3,88
    80004cd2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004cd4:	0007b883          	ld	a7,0(a5)
    80004cd8:	9746                	add	a4,a4,a7
    80004cda:	40000613          	li	a2,1024
    80004cde:	c710                	sw	a2,8(a4)
  if(write)
    80004ce0:	001b3613          	seqz	a2,s6
    80004ce4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004ce8:	01066633          	or	a2,a2,a6
    80004cec:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004cf0:	fa842583          	lw	a1,-88(s0)
    80004cf4:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004cf8:	00250613          	addi	a2,a0,2
    80004cfc:	0612                	slli	a2,a2,0x4
    80004cfe:	963e                	add	a2,a2,a5
    80004d00:	577d                	li	a4,-1
    80004d02:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004d06:	0592                	slli	a1,a1,0x4
    80004d08:	98ae                	add	a7,a7,a1
    80004d0a:	03068713          	addi	a4,a3,48
    80004d0e:	973e                	add	a4,a4,a5
    80004d10:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004d14:	6398                	ld	a4,0(a5)
    80004d16:	972e                	add	a4,a4,a1
    80004d18:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004d1c:	4689                	li	a3,2
    80004d1e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004d22:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004d26:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004d2a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d2e:	6794                	ld	a3,8(a5)
    80004d30:	0026d703          	lhu	a4,2(a3)
    80004d34:	8b1d                	andi	a4,a4,7
    80004d36:	0706                	slli	a4,a4,0x1
    80004d38:	96ba                	add	a3,a3,a4
    80004d3a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d3e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d42:	6798                	ld	a4,8(a5)
    80004d44:	00275783          	lhu	a5,2(a4)
    80004d48:	2785                	addiw	a5,a5,1
    80004d4a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d4e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d52:	100017b7          	lui	a5,0x10001
    80004d56:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d5a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004d5e:	00017917          	auipc	s2,0x17
    80004d62:	c9a90913          	addi	s2,s2,-870 # 8001b9f8 <disk+0x128>
  while(b->disk == 1) {
    80004d66:	84c2                	mv	s1,a6
    80004d68:	01079a63          	bne	a5,a6,80004d7c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004d6c:	85ca                	mv	a1,s2
    80004d6e:	854e                	mv	a0,s3
    80004d70:	df6fc0ef          	jal	80001366 <sleep>
  while(b->disk == 1) {
    80004d74:	0049a783          	lw	a5,4(s3)
    80004d78:	fe978ae3          	beq	a5,s1,80004d6c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004d7c:	fa042903          	lw	s2,-96(s0)
    80004d80:	00290713          	addi	a4,s2,2
    80004d84:	0712                	slli	a4,a4,0x4
    80004d86:	00017797          	auipc	a5,0x17
    80004d8a:	b4a78793          	addi	a5,a5,-1206 # 8001b8d0 <disk>
    80004d8e:	97ba                	add	a5,a5,a4
    80004d90:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d94:	00017997          	auipc	s3,0x17
    80004d98:	b3c98993          	addi	s3,s3,-1220 # 8001b8d0 <disk>
    80004d9c:	00491713          	slli	a4,s2,0x4
    80004da0:	0009b783          	ld	a5,0(s3)
    80004da4:	97ba                	add	a5,a5,a4
    80004da6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004daa:	854a                	mv	a0,s2
    80004dac:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004db0:	be3ff0ef          	jal	80004992 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004db4:	8885                	andi	s1,s1,1
    80004db6:	f0fd                	bnez	s1,80004d9c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004db8:	00017517          	auipc	a0,0x17
    80004dbc:	c4050513          	addi	a0,a0,-960 # 8001b9f8 <disk+0x128>
    80004dc0:	409000ef          	jal	800059c8 <release>
}
    80004dc4:	60e6                	ld	ra,88(sp)
    80004dc6:	6446                	ld	s0,80(sp)
    80004dc8:	64a6                	ld	s1,72(sp)
    80004dca:	6906                	ld	s2,64(sp)
    80004dcc:	79e2                	ld	s3,56(sp)
    80004dce:	7a42                	ld	s4,48(sp)
    80004dd0:	7aa2                	ld	s5,40(sp)
    80004dd2:	7b02                	ld	s6,32(sp)
    80004dd4:	6be2                	ld	s7,24(sp)
    80004dd6:	6c42                	ld	s8,16(sp)
    80004dd8:	6125                	addi	sp,sp,96
    80004dda:	8082                	ret

0000000080004ddc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004ddc:	1101                	addi	sp,sp,-32
    80004dde:	ec06                	sd	ra,24(sp)
    80004de0:	e822                	sd	s0,16(sp)
    80004de2:	e426                	sd	s1,8(sp)
    80004de4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004de6:	00017497          	auipc	s1,0x17
    80004dea:	aea48493          	addi	s1,s1,-1302 # 8001b8d0 <disk>
    80004dee:	00017517          	auipc	a0,0x17
    80004df2:	c0a50513          	addi	a0,a0,-1014 # 8001b9f8 <disk+0x128>
    80004df6:	33f000ef          	jal	80005934 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004dfa:	100017b7          	lui	a5,0x10001
    80004dfe:	53bc                	lw	a5,96(a5)
    80004e00:	8b8d                	andi	a5,a5,3
    80004e02:	10001737          	lui	a4,0x10001
    80004e06:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004e08:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004e0c:	689c                	ld	a5,16(s1)
    80004e0e:	0204d703          	lhu	a4,32(s1)
    80004e12:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004e16:	04f70663          	beq	a4,a5,80004e62 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004e1a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004e1e:	6898                	ld	a4,16(s1)
    80004e20:	0204d783          	lhu	a5,32(s1)
    80004e24:	8b9d                	andi	a5,a5,7
    80004e26:	078e                	slli	a5,a5,0x3
    80004e28:	97ba                	add	a5,a5,a4
    80004e2a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e2c:	00278713          	addi	a4,a5,2
    80004e30:	0712                	slli	a4,a4,0x4
    80004e32:	9726                	add	a4,a4,s1
    80004e34:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004e38:	e321                	bnez	a4,80004e78 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e3a:	0789                	addi	a5,a5,2
    80004e3c:	0792                	slli	a5,a5,0x4
    80004e3e:	97a6                	add	a5,a5,s1
    80004e40:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e42:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004e46:	d6cfc0ef          	jal	800013b2 <wakeup>

    disk.used_idx += 1;
    80004e4a:	0204d783          	lhu	a5,32(s1)
    80004e4e:	2785                	addiw	a5,a5,1
    80004e50:	17c2                	slli	a5,a5,0x30
    80004e52:	93c1                	srli	a5,a5,0x30
    80004e54:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e58:	6898                	ld	a4,16(s1)
    80004e5a:	00275703          	lhu	a4,2(a4)
    80004e5e:	faf71ee3          	bne	a4,a5,80004e1a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e62:	00017517          	auipc	a0,0x17
    80004e66:	b9650513          	addi	a0,a0,-1130 # 8001b9f8 <disk+0x128>
    80004e6a:	35f000ef          	jal	800059c8 <release>
}
    80004e6e:	60e2                	ld	ra,24(sp)
    80004e70:	6442                	ld	s0,16(sp)
    80004e72:	64a2                	ld	s1,8(sp)
    80004e74:	6105                	addi	sp,sp,32
    80004e76:	8082                	ret
      panic("virtio_disk_intr status");
    80004e78:	00003517          	auipc	a0,0x3
    80004e7c:	96850513          	addi	a0,a0,-1688 # 800077e0 <etext+0x7e0>
    80004e80:	786000ef          	jal	80005606 <panic>

0000000080004e84 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e84:	1141                	addi	sp,sp,-16
    80004e86:	e406                	sd	ra,8(sp)
    80004e88:	e022                	sd	s0,0(sp)
    80004e8a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e8c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e90:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e94:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e98:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e9c:	577d                	li	a4,-1
    80004e9e:	177e                	slli	a4,a4,0x3f
    80004ea0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004ea2:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004ea6:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004eaa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004eae:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004eb2:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004eb6:	000f4737          	lui	a4,0xf4
    80004eba:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004ebe:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004ec0:	14d79073          	csrw	stimecmp,a5
}
    80004ec4:	60a2                	ld	ra,8(sp)
    80004ec6:	6402                	ld	s0,0(sp)
    80004ec8:	0141                	addi	sp,sp,16
    80004eca:	8082                	ret

0000000080004ecc <start>:
{
    80004ecc:	1141                	addi	sp,sp,-16
    80004ece:	e406                	sd	ra,8(sp)
    80004ed0:	e022                	sd	s0,0(sp)
    80004ed2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004ed4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004ed8:	7779                	lui	a4,0xffffe
    80004eda:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdacef>
    80004ede:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004ee0:	6705                	lui	a4,0x1
    80004ee2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004ee6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004ee8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004eec:	ffffb797          	auipc	a5,0xffffb
    80004ef0:	44078793          	addi	a5,a5,1088 # 8000032c <main>
    80004ef4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004ef8:	4781                	li	a5,0
    80004efa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004efe:	67c1                	lui	a5,0x10
    80004f00:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004f02:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004f06:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004f0a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004f0e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004f12:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004f16:	57fd                	li	a5,-1
    80004f18:	83a9                	srli	a5,a5,0xa
    80004f1a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004f1e:	47bd                	li	a5,15
    80004f20:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004f24:	f61ff0ef          	jal	80004e84 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004f28:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004f2c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004f2e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004f30:	30200073          	mret
}
    80004f34:	60a2                	ld	ra,8(sp)
    80004f36:	6402                	ld	s0,0(sp)
    80004f38:	0141                	addi	sp,sp,16
    80004f3a:	8082                	ret

0000000080004f3c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004f3c:	711d                	addi	sp,sp,-96
    80004f3e:	ec86                	sd	ra,88(sp)
    80004f40:	e8a2                	sd	s0,80(sp)
    80004f42:	e0ca                	sd	s2,64(sp)
    80004f44:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004f46:	04c05863          	blez	a2,80004f96 <consolewrite+0x5a>
    80004f4a:	e4a6                	sd	s1,72(sp)
    80004f4c:	fc4e                	sd	s3,56(sp)
    80004f4e:	f852                	sd	s4,48(sp)
    80004f50:	f456                	sd	s5,40(sp)
    80004f52:	f05a                	sd	s6,32(sp)
    80004f54:	ec5e                	sd	s7,24(sp)
    80004f56:	8a2a                	mv	s4,a0
    80004f58:	84ae                	mv	s1,a1
    80004f5a:	89b2                	mv	s3,a2
    80004f5c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004f5e:	faf40b93          	addi	s7,s0,-81
    80004f62:	4b05                	li	s6,1
    80004f64:	5afd                	li	s5,-1
    80004f66:	86da                	mv	a3,s6
    80004f68:	8626                	mv	a2,s1
    80004f6a:	85d2                	mv	a1,s4
    80004f6c:	855e                	mv	a0,s7
    80004f6e:	f98fc0ef          	jal	80001706 <either_copyin>
    80004f72:	03550463          	beq	a0,s5,80004f9a <consolewrite+0x5e>
      break;
    uartputc(c);
    80004f76:	faf44503          	lbu	a0,-81(s0)
    80004f7a:	02d000ef          	jal	800057a6 <uartputc>
  for(i = 0; i < n; i++){
    80004f7e:	2905                	addiw	s2,s2,1
    80004f80:	0485                	addi	s1,s1,1
    80004f82:	ff2992e3          	bne	s3,s2,80004f66 <consolewrite+0x2a>
    80004f86:	894e                	mv	s2,s3
    80004f88:	64a6                	ld	s1,72(sp)
    80004f8a:	79e2                	ld	s3,56(sp)
    80004f8c:	7a42                	ld	s4,48(sp)
    80004f8e:	7aa2                	ld	s5,40(sp)
    80004f90:	7b02                	ld	s6,32(sp)
    80004f92:	6be2                	ld	s7,24(sp)
    80004f94:	a809                	j	80004fa6 <consolewrite+0x6a>
    80004f96:	4901                	li	s2,0
    80004f98:	a039                	j	80004fa6 <consolewrite+0x6a>
    80004f9a:	64a6                	ld	s1,72(sp)
    80004f9c:	79e2                	ld	s3,56(sp)
    80004f9e:	7a42                	ld	s4,48(sp)
    80004fa0:	7aa2                	ld	s5,40(sp)
    80004fa2:	7b02                	ld	s6,32(sp)
    80004fa4:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004fa6:	854a                	mv	a0,s2
    80004fa8:	60e6                	ld	ra,88(sp)
    80004faa:	6446                	ld	s0,80(sp)
    80004fac:	6906                	ld	s2,64(sp)
    80004fae:	6125                	addi	sp,sp,96
    80004fb0:	8082                	ret

0000000080004fb2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004fb2:	711d                	addi	sp,sp,-96
    80004fb4:	ec86                	sd	ra,88(sp)
    80004fb6:	e8a2                	sd	s0,80(sp)
    80004fb8:	e4a6                	sd	s1,72(sp)
    80004fba:	e0ca                	sd	s2,64(sp)
    80004fbc:	fc4e                	sd	s3,56(sp)
    80004fbe:	f852                	sd	s4,48(sp)
    80004fc0:	f456                	sd	s5,40(sp)
    80004fc2:	f05a                	sd	s6,32(sp)
    80004fc4:	1080                	addi	s0,sp,96
    80004fc6:	8aaa                	mv	s5,a0
    80004fc8:	8a2e                	mv	s4,a1
    80004fca:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004fcc:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004fce:	0001f517          	auipc	a0,0x1f
    80004fd2:	a4250513          	addi	a0,a0,-1470 # 80023a10 <cons>
    80004fd6:	15f000ef          	jal	80005934 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004fda:	0001f497          	auipc	s1,0x1f
    80004fde:	a3648493          	addi	s1,s1,-1482 # 80023a10 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004fe2:	0001f917          	auipc	s2,0x1f
    80004fe6:	ac690913          	addi	s2,s2,-1338 # 80023aa8 <cons+0x98>
  while(n > 0){
    80004fea:	0b305b63          	blez	s3,800050a0 <consoleread+0xee>
    while(cons.r == cons.w){
    80004fee:	0984a783          	lw	a5,152(s1)
    80004ff2:	09c4a703          	lw	a4,156(s1)
    80004ff6:	0af71063          	bne	a4,a5,80005096 <consoleread+0xe4>
      if(killed(myproc())){
    80004ffa:	d93fb0ef          	jal	80000d8c <myproc>
    80004ffe:	da0fc0ef          	jal	8000159e <killed>
    80005002:	e12d                	bnez	a0,80005064 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80005004:	85a6                	mv	a1,s1
    80005006:	854a                	mv	a0,s2
    80005008:	b5efc0ef          	jal	80001366 <sleep>
    while(cons.r == cons.w){
    8000500c:	0984a783          	lw	a5,152(s1)
    80005010:	09c4a703          	lw	a4,156(s1)
    80005014:	fef703e3          	beq	a4,a5,80004ffa <consoleread+0x48>
    80005018:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000501a:	0001f717          	auipc	a4,0x1f
    8000501e:	9f670713          	addi	a4,a4,-1546 # 80023a10 <cons>
    80005022:	0017869b          	addiw	a3,a5,1
    80005026:	08d72c23          	sw	a3,152(a4)
    8000502a:	07f7f693          	andi	a3,a5,127
    8000502e:	9736                	add	a4,a4,a3
    80005030:	01874703          	lbu	a4,24(a4)
    80005034:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005038:	4691                	li	a3,4
    8000503a:	04db8663          	beq	s7,a3,80005086 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000503e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005042:	4685                	li	a3,1
    80005044:	faf40613          	addi	a2,s0,-81
    80005048:	85d2                	mv	a1,s4
    8000504a:	8556                	mv	a0,s5
    8000504c:	e70fc0ef          	jal	800016bc <either_copyout>
    80005050:	57fd                	li	a5,-1
    80005052:	04f50663          	beq	a0,a5,8000509e <consoleread+0xec>
      break;

    dst++;
    80005056:	0a05                	addi	s4,s4,1
    --n;
    80005058:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000505a:	47a9                	li	a5,10
    8000505c:	04fb8b63          	beq	s7,a5,800050b2 <consoleread+0x100>
    80005060:	6be2                	ld	s7,24(sp)
    80005062:	b761                	j	80004fea <consoleread+0x38>
        release(&cons.lock);
    80005064:	0001f517          	auipc	a0,0x1f
    80005068:	9ac50513          	addi	a0,a0,-1620 # 80023a10 <cons>
    8000506c:	15d000ef          	jal	800059c8 <release>
        return -1;
    80005070:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005072:	60e6                	ld	ra,88(sp)
    80005074:	6446                	ld	s0,80(sp)
    80005076:	64a6                	ld	s1,72(sp)
    80005078:	6906                	ld	s2,64(sp)
    8000507a:	79e2                	ld	s3,56(sp)
    8000507c:	7a42                	ld	s4,48(sp)
    8000507e:	7aa2                	ld	s5,40(sp)
    80005080:	7b02                	ld	s6,32(sp)
    80005082:	6125                	addi	sp,sp,96
    80005084:	8082                	ret
      if(n < target){
    80005086:	0169fa63          	bgeu	s3,s6,8000509a <consoleread+0xe8>
        cons.r--;
    8000508a:	0001f717          	auipc	a4,0x1f
    8000508e:	a0f72f23          	sw	a5,-1506(a4) # 80023aa8 <cons+0x98>
    80005092:	6be2                	ld	s7,24(sp)
    80005094:	a031                	j	800050a0 <consoleread+0xee>
    80005096:	ec5e                	sd	s7,24(sp)
    80005098:	b749                	j	8000501a <consoleread+0x68>
    8000509a:	6be2                	ld	s7,24(sp)
    8000509c:	a011                	j	800050a0 <consoleread+0xee>
    8000509e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800050a0:	0001f517          	auipc	a0,0x1f
    800050a4:	97050513          	addi	a0,a0,-1680 # 80023a10 <cons>
    800050a8:	121000ef          	jal	800059c8 <release>
  return target - n;
    800050ac:	413b053b          	subw	a0,s6,s3
    800050b0:	b7c9                	j	80005072 <consoleread+0xc0>
    800050b2:	6be2                	ld	s7,24(sp)
    800050b4:	b7f5                	j	800050a0 <consoleread+0xee>

00000000800050b6 <consputc>:
{
    800050b6:	1141                	addi	sp,sp,-16
    800050b8:	e406                	sd	ra,8(sp)
    800050ba:	e022                	sd	s0,0(sp)
    800050bc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800050be:	10000793          	li	a5,256
    800050c2:	00f50863          	beq	a0,a5,800050d2 <consputc+0x1c>
    uartputc_sync(c);
    800050c6:	5fe000ef          	jal	800056c4 <uartputc_sync>
}
    800050ca:	60a2                	ld	ra,8(sp)
    800050cc:	6402                	ld	s0,0(sp)
    800050ce:	0141                	addi	sp,sp,16
    800050d0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800050d2:	4521                	li	a0,8
    800050d4:	5f0000ef          	jal	800056c4 <uartputc_sync>
    800050d8:	02000513          	li	a0,32
    800050dc:	5e8000ef          	jal	800056c4 <uartputc_sync>
    800050e0:	4521                	li	a0,8
    800050e2:	5e2000ef          	jal	800056c4 <uartputc_sync>
    800050e6:	b7d5                	j	800050ca <consputc+0x14>

00000000800050e8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050e8:	7179                	addi	sp,sp,-48
    800050ea:	f406                	sd	ra,40(sp)
    800050ec:	f022                	sd	s0,32(sp)
    800050ee:	ec26                	sd	s1,24(sp)
    800050f0:	1800                	addi	s0,sp,48
    800050f2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800050f4:	0001f517          	auipc	a0,0x1f
    800050f8:	91c50513          	addi	a0,a0,-1764 # 80023a10 <cons>
    800050fc:	039000ef          	jal	80005934 <acquire>

  switch(c){
    80005100:	47d5                	li	a5,21
    80005102:	08f48e63          	beq	s1,a5,8000519e <consoleintr+0xb6>
    80005106:	0297c563          	blt	a5,s1,80005130 <consoleintr+0x48>
    8000510a:	47a1                	li	a5,8
    8000510c:	0ef48863          	beq	s1,a5,800051fc <consoleintr+0x114>
    80005110:	47c1                	li	a5,16
    80005112:	10f49963          	bne	s1,a5,80005224 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80005116:	e3afc0ef          	jal	80001750 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000511a:	0001f517          	auipc	a0,0x1f
    8000511e:	8f650513          	addi	a0,a0,-1802 # 80023a10 <cons>
    80005122:	0a7000ef          	jal	800059c8 <release>
}
    80005126:	70a2                	ld	ra,40(sp)
    80005128:	7402                	ld	s0,32(sp)
    8000512a:	64e2                	ld	s1,24(sp)
    8000512c:	6145                	addi	sp,sp,48
    8000512e:	8082                	ret
  switch(c){
    80005130:	07f00793          	li	a5,127
    80005134:	0cf48463          	beq	s1,a5,800051fc <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005138:	0001f717          	auipc	a4,0x1f
    8000513c:	8d870713          	addi	a4,a4,-1832 # 80023a10 <cons>
    80005140:	0a072783          	lw	a5,160(a4)
    80005144:	09872703          	lw	a4,152(a4)
    80005148:	9f99                	subw	a5,a5,a4
    8000514a:	07f00713          	li	a4,127
    8000514e:	fcf766e3          	bltu	a4,a5,8000511a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005152:	47b5                	li	a5,13
    80005154:	0cf48b63          	beq	s1,a5,8000522a <consoleintr+0x142>
      consputc(c);
    80005158:	8526                	mv	a0,s1
    8000515a:	f5dff0ef          	jal	800050b6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000515e:	0001f797          	auipc	a5,0x1f
    80005162:	8b278793          	addi	a5,a5,-1870 # 80023a10 <cons>
    80005166:	0a07a683          	lw	a3,160(a5)
    8000516a:	0016871b          	addiw	a4,a3,1
    8000516e:	863a                	mv	a2,a4
    80005170:	0ae7a023          	sw	a4,160(a5)
    80005174:	07f6f693          	andi	a3,a3,127
    80005178:	97b6                	add	a5,a5,a3
    8000517a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000517e:	47a9                	li	a5,10
    80005180:	0cf48963          	beq	s1,a5,80005252 <consoleintr+0x16a>
    80005184:	4791                	li	a5,4
    80005186:	0cf48663          	beq	s1,a5,80005252 <consoleintr+0x16a>
    8000518a:	0001f797          	auipc	a5,0x1f
    8000518e:	91e7a783          	lw	a5,-1762(a5) # 80023aa8 <cons+0x98>
    80005192:	9f1d                	subw	a4,a4,a5
    80005194:	08000793          	li	a5,128
    80005198:	f8f711e3          	bne	a4,a5,8000511a <consoleintr+0x32>
    8000519c:	a85d                	j	80005252 <consoleintr+0x16a>
    8000519e:	e84a                	sd	s2,16(sp)
    800051a0:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800051a2:	0001f717          	auipc	a4,0x1f
    800051a6:	86e70713          	addi	a4,a4,-1938 # 80023a10 <cons>
    800051aa:	0a072783          	lw	a5,160(a4)
    800051ae:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051b2:	0001f497          	auipc	s1,0x1f
    800051b6:	85e48493          	addi	s1,s1,-1954 # 80023a10 <cons>
    while(cons.e != cons.w &&
    800051ba:	4929                	li	s2,10
      consputc(BACKSPACE);
    800051bc:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    800051c0:	02f70863          	beq	a4,a5,800051f0 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051c4:	37fd                	addiw	a5,a5,-1
    800051c6:	07f7f713          	andi	a4,a5,127
    800051ca:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800051cc:	01874703          	lbu	a4,24(a4)
    800051d0:	03270363          	beq	a4,s2,800051f6 <consoleintr+0x10e>
      cons.e--;
    800051d4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800051d8:	854e                	mv	a0,s3
    800051da:	eddff0ef          	jal	800050b6 <consputc>
    while(cons.e != cons.w &&
    800051de:	0a04a783          	lw	a5,160(s1)
    800051e2:	09c4a703          	lw	a4,156(s1)
    800051e6:	fcf71fe3          	bne	a4,a5,800051c4 <consoleintr+0xdc>
    800051ea:	6942                	ld	s2,16(sp)
    800051ec:	69a2                	ld	s3,8(sp)
    800051ee:	b735                	j	8000511a <consoleintr+0x32>
    800051f0:	6942                	ld	s2,16(sp)
    800051f2:	69a2                	ld	s3,8(sp)
    800051f4:	b71d                	j	8000511a <consoleintr+0x32>
    800051f6:	6942                	ld	s2,16(sp)
    800051f8:	69a2                	ld	s3,8(sp)
    800051fa:	b705                	j	8000511a <consoleintr+0x32>
    if(cons.e != cons.w){
    800051fc:	0001f717          	auipc	a4,0x1f
    80005200:	81470713          	addi	a4,a4,-2028 # 80023a10 <cons>
    80005204:	0a072783          	lw	a5,160(a4)
    80005208:	09c72703          	lw	a4,156(a4)
    8000520c:	f0f707e3          	beq	a4,a5,8000511a <consoleintr+0x32>
      cons.e--;
    80005210:	37fd                	addiw	a5,a5,-1
    80005212:	0001f717          	auipc	a4,0x1f
    80005216:	88f72f23          	sw	a5,-1890(a4) # 80023ab0 <cons+0xa0>
      consputc(BACKSPACE);
    8000521a:	10000513          	li	a0,256
    8000521e:	e99ff0ef          	jal	800050b6 <consputc>
    80005222:	bde5                	j	8000511a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005224:	ee048be3          	beqz	s1,8000511a <consoleintr+0x32>
    80005228:	bf01                	j	80005138 <consoleintr+0x50>
      consputc(c);
    8000522a:	4529                	li	a0,10
    8000522c:	e8bff0ef          	jal	800050b6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005230:	0001e797          	auipc	a5,0x1e
    80005234:	7e078793          	addi	a5,a5,2016 # 80023a10 <cons>
    80005238:	0a07a703          	lw	a4,160(a5)
    8000523c:	0017069b          	addiw	a3,a4,1
    80005240:	8636                	mv	a2,a3
    80005242:	0ad7a023          	sw	a3,160(a5)
    80005246:	07f77713          	andi	a4,a4,127
    8000524a:	97ba                	add	a5,a5,a4
    8000524c:	4729                	li	a4,10
    8000524e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005252:	0001f797          	auipc	a5,0x1f
    80005256:	84c7ad23          	sw	a2,-1958(a5) # 80023aac <cons+0x9c>
        wakeup(&cons.r);
    8000525a:	0001f517          	auipc	a0,0x1f
    8000525e:	84e50513          	addi	a0,a0,-1970 # 80023aa8 <cons+0x98>
    80005262:	950fc0ef          	jal	800013b2 <wakeup>
    80005266:	bd55                	j	8000511a <consoleintr+0x32>

0000000080005268 <consoleinit>:

void
consoleinit(void)
{
    80005268:	1141                	addi	sp,sp,-16
    8000526a:	e406                	sd	ra,8(sp)
    8000526c:	e022                	sd	s0,0(sp)
    8000526e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005270:	00002597          	auipc	a1,0x2
    80005274:	58858593          	addi	a1,a1,1416 # 800077f8 <etext+0x7f8>
    80005278:	0001e517          	auipc	a0,0x1e
    8000527c:	79850513          	addi	a0,a0,1944 # 80023a10 <cons>
    80005280:	630000ef          	jal	800058b0 <initlock>

  uartinit();
    80005284:	3ea000ef          	jal	8000566e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005288:	00015797          	auipc	a5,0x15
    8000528c:	5f078793          	addi	a5,a5,1520 # 8001a878 <devsw>
    80005290:	00000717          	auipc	a4,0x0
    80005294:	d2270713          	addi	a4,a4,-734 # 80004fb2 <consoleread>
    80005298:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000529a:	00000717          	auipc	a4,0x0
    8000529e:	ca270713          	addi	a4,a4,-862 # 80004f3c <consolewrite>
    800052a2:	ef98                	sd	a4,24(a5)
}
    800052a4:	60a2                	ld	ra,8(sp)
    800052a6:	6402                	ld	s0,0(sp)
    800052a8:	0141                	addi	sp,sp,16
    800052aa:	8082                	ret

00000000800052ac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800052ac:	7179                	addi	sp,sp,-48
    800052ae:	f406                	sd	ra,40(sp)
    800052b0:	f022                	sd	s0,32(sp)
    800052b2:	ec26                	sd	s1,24(sp)
    800052b4:	e84a                	sd	s2,16(sp)
    800052b6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800052b8:	c219                	beqz	a2,800052be <printint+0x12>
    800052ba:	06054a63          	bltz	a0,8000532e <printint+0x82>
    x = -xx;
  else
    x = xx;
    800052be:	4e01                	li	t3,0

  i = 0;
    800052c0:	fd040313          	addi	t1,s0,-48
    x = xx;
    800052c4:	869a                	mv	a3,t1
  i = 0;
    800052c6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800052c8:	00002817          	auipc	a6,0x2
    800052cc:	76880813          	addi	a6,a6,1896 # 80007a30 <digits>
    800052d0:	88be                	mv	a7,a5
    800052d2:	0017861b          	addiw	a2,a5,1
    800052d6:	87b2                	mv	a5,a2
    800052d8:	02b57733          	remu	a4,a0,a1
    800052dc:	9742                	add	a4,a4,a6
    800052de:	00074703          	lbu	a4,0(a4)
    800052e2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800052e6:	872a                	mv	a4,a0
    800052e8:	02b55533          	divu	a0,a0,a1
    800052ec:	0685                	addi	a3,a3,1
    800052ee:	feb771e3          	bgeu	a4,a1,800052d0 <printint+0x24>

  if(sign)
    800052f2:	000e0c63          	beqz	t3,8000530a <printint+0x5e>
    buf[i++] = '-';
    800052f6:	fe060793          	addi	a5,a2,-32
    800052fa:	00878633          	add	a2,a5,s0
    800052fe:	02d00793          	li	a5,45
    80005302:	fef60823          	sb	a5,-16(a2)
    80005306:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    8000530a:	fff7891b          	addiw	s2,a5,-1
    8000530e:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005312:	fff4c503          	lbu	a0,-1(s1)
    80005316:	da1ff0ef          	jal	800050b6 <consputc>
  while(--i >= 0)
    8000531a:	397d                	addiw	s2,s2,-1
    8000531c:	14fd                	addi	s1,s1,-1
    8000531e:	fe095ae3          	bgez	s2,80005312 <printint+0x66>
}
    80005322:	70a2                	ld	ra,40(sp)
    80005324:	7402                	ld	s0,32(sp)
    80005326:	64e2                	ld	s1,24(sp)
    80005328:	6942                	ld	s2,16(sp)
    8000532a:	6145                	addi	sp,sp,48
    8000532c:	8082                	ret
    x = -xx;
    8000532e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005332:	4e05                	li	t3,1
    x = -xx;
    80005334:	b771                	j	800052c0 <printint+0x14>

0000000080005336 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005336:	7155                	addi	sp,sp,-208
    80005338:	e506                	sd	ra,136(sp)
    8000533a:	e122                	sd	s0,128(sp)
    8000533c:	f0d2                	sd	s4,96(sp)
    8000533e:	0900                	addi	s0,sp,144
    80005340:	8a2a                	mv	s4,a0
    80005342:	e40c                	sd	a1,8(s0)
    80005344:	e810                	sd	a2,16(s0)
    80005346:	ec14                	sd	a3,24(s0)
    80005348:	f018                	sd	a4,32(s0)
    8000534a:	f41c                	sd	a5,40(s0)
    8000534c:	03043823          	sd	a6,48(s0)
    80005350:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005354:	0001e797          	auipc	a5,0x1e
    80005358:	77c7a783          	lw	a5,1916(a5) # 80023ad0 <pr+0x18>
    8000535c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005360:	e3a1                	bnez	a5,800053a0 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005362:	00840793          	addi	a5,s0,8
    80005366:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000536a:	00054503          	lbu	a0,0(a0)
    8000536e:	26050663          	beqz	a0,800055da <printf+0x2a4>
    80005372:	fca6                	sd	s1,120(sp)
    80005374:	f8ca                	sd	s2,112(sp)
    80005376:	f4ce                	sd	s3,104(sp)
    80005378:	ecd6                	sd	s5,88(sp)
    8000537a:	e8da                	sd	s6,80(sp)
    8000537c:	e0e2                	sd	s8,64(sp)
    8000537e:	fc66                	sd	s9,56(sp)
    80005380:	f86a                	sd	s10,48(sp)
    80005382:	f46e                	sd	s11,40(sp)
    80005384:	4981                	li	s3,0
    if(cx != '%'){
    80005386:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000538a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000538e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005392:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005396:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000539a:	07000d93          	li	s11,112
    8000539e:	a80d                	j	800053d0 <printf+0x9a>
    acquire(&pr.lock);
    800053a0:	0001e517          	auipc	a0,0x1e
    800053a4:	71850513          	addi	a0,a0,1816 # 80023ab8 <pr>
    800053a8:	58c000ef          	jal	80005934 <acquire>
  va_start(ap, fmt);
    800053ac:	00840793          	addi	a5,s0,8
    800053b0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053b4:	000a4503          	lbu	a0,0(s4)
    800053b8:	fd4d                	bnez	a0,80005372 <printf+0x3c>
    800053ba:	ac3d                	j	800055f8 <printf+0x2c2>
      consputc(cx);
    800053bc:	cfbff0ef          	jal	800050b6 <consputc>
      continue;
    800053c0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053c2:	2485                	addiw	s1,s1,1
    800053c4:	89a6                	mv	s3,s1
    800053c6:	94d2                	add	s1,s1,s4
    800053c8:	0004c503          	lbu	a0,0(s1)
    800053cc:	1e050b63          	beqz	a0,800055c2 <printf+0x28c>
    if(cx != '%'){
    800053d0:	ff5516e3          	bne	a0,s5,800053bc <printf+0x86>
    i++;
    800053d4:	0019879b          	addiw	a5,s3,1
    800053d8:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800053da:	00fa0733          	add	a4,s4,a5
    800053de:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800053e2:	1e090063          	beqz	s2,800055c2 <printf+0x28c>
    800053e6:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    800053ea:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    800053ec:	c701                	beqz	a4,800053f4 <printf+0xbe>
    800053ee:	97d2                	add	a5,a5,s4
    800053f0:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    800053f4:	03690763          	beq	s2,s6,80005422 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    800053f8:	05890163          	beq	s2,s8,8000543a <printf+0x104>
    } else if(c0 == 'u'){
    800053fc:	0d990b63          	beq	s2,s9,800054d2 <printf+0x19c>
    } else if(c0 == 'x'){
    80005400:	13a90163          	beq	s2,s10,80005522 <printf+0x1ec>
    } else if(c0 == 'p'){
    80005404:	13b90b63          	beq	s2,s11,8000553a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005408:	07300793          	li	a5,115
    8000540c:	16f90a63          	beq	s2,a5,80005580 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005410:	1b590463          	beq	s2,s5,800055b8 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005414:	8556                	mv	a0,s5
    80005416:	ca1ff0ef          	jal	800050b6 <consputc>
      consputc(c0);
    8000541a:	854a                	mv	a0,s2
    8000541c:	c9bff0ef          	jal	800050b6 <consputc>
    80005420:	b74d                	j	800053c2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005422:	f8843783          	ld	a5,-120(s0)
    80005426:	00878713          	addi	a4,a5,8
    8000542a:	f8e43423          	sd	a4,-120(s0)
    8000542e:	4605                	li	a2,1
    80005430:	45a9                	li	a1,10
    80005432:	4388                	lw	a0,0(a5)
    80005434:	e79ff0ef          	jal	800052ac <printint>
    80005438:	b769                	j	800053c2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000543a:	03670663          	beq	a4,s6,80005466 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000543e:	05870263          	beq	a4,s8,80005482 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005442:	0b970463          	beq	a4,s9,800054ea <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005446:	fda717e3          	bne	a4,s10,80005414 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000544a:	f8843783          	ld	a5,-120(s0)
    8000544e:	00878713          	addi	a4,a5,8
    80005452:	f8e43423          	sd	a4,-120(s0)
    80005456:	4601                	li	a2,0
    80005458:	45c1                	li	a1,16
    8000545a:	6388                	ld	a0,0(a5)
    8000545c:	e51ff0ef          	jal	800052ac <printint>
      i += 1;
    80005460:	0029849b          	addiw	s1,s3,2
    80005464:	bfb9                	j	800053c2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005466:	f8843783          	ld	a5,-120(s0)
    8000546a:	00878713          	addi	a4,a5,8
    8000546e:	f8e43423          	sd	a4,-120(s0)
    80005472:	4605                	li	a2,1
    80005474:	45a9                	li	a1,10
    80005476:	6388                	ld	a0,0(a5)
    80005478:	e35ff0ef          	jal	800052ac <printint>
      i += 1;
    8000547c:	0029849b          	addiw	s1,s3,2
    80005480:	b789                	j	800053c2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005482:	06400793          	li	a5,100
    80005486:	02f68863          	beq	a3,a5,800054b6 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000548a:	07500793          	li	a5,117
    8000548e:	06f68c63          	beq	a3,a5,80005506 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005492:	07800793          	li	a5,120
    80005496:	f6f69fe3          	bne	a3,a5,80005414 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000549a:	f8843783          	ld	a5,-120(s0)
    8000549e:	00878713          	addi	a4,a5,8
    800054a2:	f8e43423          	sd	a4,-120(s0)
    800054a6:	4601                	li	a2,0
    800054a8:	45c1                	li	a1,16
    800054aa:	6388                	ld	a0,0(a5)
    800054ac:	e01ff0ef          	jal	800052ac <printint>
      i += 2;
    800054b0:	0039849b          	addiw	s1,s3,3
    800054b4:	b739                	j	800053c2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800054b6:	f8843783          	ld	a5,-120(s0)
    800054ba:	00878713          	addi	a4,a5,8
    800054be:	f8e43423          	sd	a4,-120(s0)
    800054c2:	4605                	li	a2,1
    800054c4:	45a9                	li	a1,10
    800054c6:	6388                	ld	a0,0(a5)
    800054c8:	de5ff0ef          	jal	800052ac <printint>
      i += 2;
    800054cc:	0039849b          	addiw	s1,s3,3
    800054d0:	bdcd                	j	800053c2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800054d2:	f8843783          	ld	a5,-120(s0)
    800054d6:	00878713          	addi	a4,a5,8
    800054da:	f8e43423          	sd	a4,-120(s0)
    800054de:	4601                	li	a2,0
    800054e0:	45a9                	li	a1,10
    800054e2:	4388                	lw	a0,0(a5)
    800054e4:	dc9ff0ef          	jal	800052ac <printint>
    800054e8:	bde9                	j	800053c2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800054ea:	f8843783          	ld	a5,-120(s0)
    800054ee:	00878713          	addi	a4,a5,8
    800054f2:	f8e43423          	sd	a4,-120(s0)
    800054f6:	4601                	li	a2,0
    800054f8:	45a9                	li	a1,10
    800054fa:	6388                	ld	a0,0(a5)
    800054fc:	db1ff0ef          	jal	800052ac <printint>
      i += 1;
    80005500:	0029849b          	addiw	s1,s3,2
    80005504:	bd7d                	j	800053c2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005506:	f8843783          	ld	a5,-120(s0)
    8000550a:	00878713          	addi	a4,a5,8
    8000550e:	f8e43423          	sd	a4,-120(s0)
    80005512:	4601                	li	a2,0
    80005514:	45a9                	li	a1,10
    80005516:	6388                	ld	a0,0(a5)
    80005518:	d95ff0ef          	jal	800052ac <printint>
      i += 2;
    8000551c:	0039849b          	addiw	s1,s3,3
    80005520:	b54d                	j	800053c2 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005522:	f8843783          	ld	a5,-120(s0)
    80005526:	00878713          	addi	a4,a5,8
    8000552a:	f8e43423          	sd	a4,-120(s0)
    8000552e:	4601                	li	a2,0
    80005530:	45c1                	li	a1,16
    80005532:	4388                	lw	a0,0(a5)
    80005534:	d79ff0ef          	jal	800052ac <printint>
    80005538:	b569                	j	800053c2 <printf+0x8c>
    8000553a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000553c:	f8843783          	ld	a5,-120(s0)
    80005540:	00878713          	addi	a4,a5,8
    80005544:	f8e43423          	sd	a4,-120(s0)
    80005548:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000554c:	03000513          	li	a0,48
    80005550:	b67ff0ef          	jal	800050b6 <consputc>
  consputc('x');
    80005554:	07800513          	li	a0,120
    80005558:	b5fff0ef          	jal	800050b6 <consputc>
    8000555c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000555e:	00002b97          	auipc	s7,0x2
    80005562:	4d2b8b93          	addi	s7,s7,1234 # 80007a30 <digits>
    80005566:	03c9d793          	srli	a5,s3,0x3c
    8000556a:	97de                	add	a5,a5,s7
    8000556c:	0007c503          	lbu	a0,0(a5)
    80005570:	b47ff0ef          	jal	800050b6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005574:	0992                	slli	s3,s3,0x4
    80005576:	397d                	addiw	s2,s2,-1
    80005578:	fe0917e3          	bnez	s2,80005566 <printf+0x230>
    8000557c:	6ba6                	ld	s7,72(sp)
    8000557e:	b591                	j	800053c2 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005580:	f8843783          	ld	a5,-120(s0)
    80005584:	00878713          	addi	a4,a5,8
    80005588:	f8e43423          	sd	a4,-120(s0)
    8000558c:	0007b903          	ld	s2,0(a5)
    80005590:	00090d63          	beqz	s2,800055aa <printf+0x274>
      for(; *s; s++)
    80005594:	00094503          	lbu	a0,0(s2)
    80005598:	e20505e3          	beqz	a0,800053c2 <printf+0x8c>
        consputc(*s);
    8000559c:	b1bff0ef          	jal	800050b6 <consputc>
      for(; *s; s++)
    800055a0:	0905                	addi	s2,s2,1
    800055a2:	00094503          	lbu	a0,0(s2)
    800055a6:	f97d                	bnez	a0,8000559c <printf+0x266>
    800055a8:	bd29                	j	800053c2 <printf+0x8c>
        s = "(null)";
    800055aa:	00002917          	auipc	s2,0x2
    800055ae:	25690913          	addi	s2,s2,598 # 80007800 <etext+0x800>
      for(; *s; s++)
    800055b2:	02800513          	li	a0,40
    800055b6:	b7dd                	j	8000559c <printf+0x266>
      consputc('%');
    800055b8:	02500513          	li	a0,37
    800055bc:	afbff0ef          	jal	800050b6 <consputc>
    800055c0:	b509                	j	800053c2 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800055c2:	f7843783          	ld	a5,-136(s0)
    800055c6:	e385                	bnez	a5,800055e6 <printf+0x2b0>
    800055c8:	74e6                	ld	s1,120(sp)
    800055ca:	7946                	ld	s2,112(sp)
    800055cc:	79a6                	ld	s3,104(sp)
    800055ce:	6ae6                	ld	s5,88(sp)
    800055d0:	6b46                	ld	s6,80(sp)
    800055d2:	6c06                	ld	s8,64(sp)
    800055d4:	7ce2                	ld	s9,56(sp)
    800055d6:	7d42                	ld	s10,48(sp)
    800055d8:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800055da:	4501                	li	a0,0
    800055dc:	60aa                	ld	ra,136(sp)
    800055de:	640a                	ld	s0,128(sp)
    800055e0:	7a06                	ld	s4,96(sp)
    800055e2:	6169                	addi	sp,sp,208
    800055e4:	8082                	ret
    800055e6:	74e6                	ld	s1,120(sp)
    800055e8:	7946                	ld	s2,112(sp)
    800055ea:	79a6                	ld	s3,104(sp)
    800055ec:	6ae6                	ld	s5,88(sp)
    800055ee:	6b46                	ld	s6,80(sp)
    800055f0:	6c06                	ld	s8,64(sp)
    800055f2:	7ce2                	ld	s9,56(sp)
    800055f4:	7d42                	ld	s10,48(sp)
    800055f6:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800055f8:	0001e517          	auipc	a0,0x1e
    800055fc:	4c050513          	addi	a0,a0,1216 # 80023ab8 <pr>
    80005600:	3c8000ef          	jal	800059c8 <release>
    80005604:	bfd9                	j	800055da <printf+0x2a4>

0000000080005606 <panic>:

void
panic(char *s)
{
    80005606:	1101                	addi	sp,sp,-32
    80005608:	ec06                	sd	ra,24(sp)
    8000560a:	e822                	sd	s0,16(sp)
    8000560c:	e426                	sd	s1,8(sp)
    8000560e:	1000                	addi	s0,sp,32
    80005610:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005612:	0001e797          	auipc	a5,0x1e
    80005616:	4a07af23          	sw	zero,1214(a5) # 80023ad0 <pr+0x18>
  printf("panic: ");
    8000561a:	00002517          	auipc	a0,0x2
    8000561e:	1ee50513          	addi	a0,a0,494 # 80007808 <etext+0x808>
    80005622:	d15ff0ef          	jal	80005336 <printf>
  printf("%s\n", s);
    80005626:	85a6                	mv	a1,s1
    80005628:	00002517          	auipc	a0,0x2
    8000562c:	1e850513          	addi	a0,a0,488 # 80007810 <etext+0x810>
    80005630:	d07ff0ef          	jal	80005336 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005634:	4785                	li	a5,1
    80005636:	00005717          	auipc	a4,0x5
    8000563a:	f8f72b23          	sw	a5,-106(a4) # 8000a5cc <panicked>
  for(;;)
    8000563e:	a001                	j	8000563e <panic+0x38>

0000000080005640 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005640:	1101                	addi	sp,sp,-32
    80005642:	ec06                	sd	ra,24(sp)
    80005644:	e822                	sd	s0,16(sp)
    80005646:	e426                	sd	s1,8(sp)
    80005648:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000564a:	0001e497          	auipc	s1,0x1e
    8000564e:	46e48493          	addi	s1,s1,1134 # 80023ab8 <pr>
    80005652:	00002597          	auipc	a1,0x2
    80005656:	1c658593          	addi	a1,a1,454 # 80007818 <etext+0x818>
    8000565a:	8526                	mv	a0,s1
    8000565c:	254000ef          	jal	800058b0 <initlock>
  pr.locking = 1;
    80005660:	4785                	li	a5,1
    80005662:	cc9c                	sw	a5,24(s1)
}
    80005664:	60e2                	ld	ra,24(sp)
    80005666:	6442                	ld	s0,16(sp)
    80005668:	64a2                	ld	s1,8(sp)
    8000566a:	6105                	addi	sp,sp,32
    8000566c:	8082                	ret

000000008000566e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000566e:	1141                	addi	sp,sp,-16
    80005670:	e406                	sd	ra,8(sp)
    80005672:	e022                	sd	s0,0(sp)
    80005674:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005676:	100007b7          	lui	a5,0x10000
    8000567a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000567e:	10000737          	lui	a4,0x10000
    80005682:	f8000693          	li	a3,-128
    80005686:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000568a:	468d                	li	a3,3
    8000568c:	10000637          	lui	a2,0x10000
    80005690:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005694:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005698:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000569c:	8732                	mv	a4,a2
    8000569e:	461d                	li	a2,7
    800056a0:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800056a4:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800056a8:	00002597          	auipc	a1,0x2
    800056ac:	17858593          	addi	a1,a1,376 # 80007820 <etext+0x820>
    800056b0:	0001e517          	auipc	a0,0x1e
    800056b4:	42850513          	addi	a0,a0,1064 # 80023ad8 <uart_tx_lock>
    800056b8:	1f8000ef          	jal	800058b0 <initlock>
}
    800056bc:	60a2                	ld	ra,8(sp)
    800056be:	6402                	ld	s0,0(sp)
    800056c0:	0141                	addi	sp,sp,16
    800056c2:	8082                	ret

00000000800056c4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800056c4:	1101                	addi	sp,sp,-32
    800056c6:	ec06                	sd	ra,24(sp)
    800056c8:	e822                	sd	s0,16(sp)
    800056ca:	e426                	sd	s1,8(sp)
    800056cc:	1000                	addi	s0,sp,32
    800056ce:	84aa                	mv	s1,a0
  push_off();
    800056d0:	224000ef          	jal	800058f4 <push_off>

  if(panicked){
    800056d4:	00005797          	auipc	a5,0x5
    800056d8:	ef87a783          	lw	a5,-264(a5) # 8000a5cc <panicked>
    800056dc:	e795                	bnez	a5,80005708 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800056de:	10000737          	lui	a4,0x10000
    800056e2:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800056e4:	00074783          	lbu	a5,0(a4)
    800056e8:	0207f793          	andi	a5,a5,32
    800056ec:	dfe5                	beqz	a5,800056e4 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800056ee:	0ff4f513          	zext.b	a0,s1
    800056f2:	100007b7          	lui	a5,0x10000
    800056f6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800056fa:	27e000ef          	jal	80005978 <pop_off>
}
    800056fe:	60e2                	ld	ra,24(sp)
    80005700:	6442                	ld	s0,16(sp)
    80005702:	64a2                	ld	s1,8(sp)
    80005704:	6105                	addi	sp,sp,32
    80005706:	8082                	ret
    for(;;)
    80005708:	a001                	j	80005708 <uartputc_sync+0x44>

000000008000570a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000570a:	00005797          	auipc	a5,0x5
    8000570e:	ec67b783          	ld	a5,-314(a5) # 8000a5d0 <uart_tx_r>
    80005712:	00005717          	auipc	a4,0x5
    80005716:	ec673703          	ld	a4,-314(a4) # 8000a5d8 <uart_tx_w>
    8000571a:	08f70163          	beq	a4,a5,8000579c <uartstart+0x92>
{
    8000571e:	7139                	addi	sp,sp,-64
    80005720:	fc06                	sd	ra,56(sp)
    80005722:	f822                	sd	s0,48(sp)
    80005724:	f426                	sd	s1,40(sp)
    80005726:	f04a                	sd	s2,32(sp)
    80005728:	ec4e                	sd	s3,24(sp)
    8000572a:	e852                	sd	s4,16(sp)
    8000572c:	e456                	sd	s5,8(sp)
    8000572e:	e05a                	sd	s6,0(sp)
    80005730:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005732:	10000937          	lui	s2,0x10000
    80005736:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005738:	0001ea97          	auipc	s5,0x1e
    8000573c:	3a0a8a93          	addi	s5,s5,928 # 80023ad8 <uart_tx_lock>
    uart_tx_r += 1;
    80005740:	00005497          	auipc	s1,0x5
    80005744:	e9048493          	addi	s1,s1,-368 # 8000a5d0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005748:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000574c:	00005997          	auipc	s3,0x5
    80005750:	e8c98993          	addi	s3,s3,-372 # 8000a5d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005754:	00094703          	lbu	a4,0(s2)
    80005758:	02077713          	andi	a4,a4,32
    8000575c:	c715                	beqz	a4,80005788 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000575e:	01f7f713          	andi	a4,a5,31
    80005762:	9756                	add	a4,a4,s5
    80005764:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005768:	0785                	addi	a5,a5,1
    8000576a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000576c:	8526                	mv	a0,s1
    8000576e:	c45fb0ef          	jal	800013b2 <wakeup>
    WriteReg(THR, c);
    80005772:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005776:	609c                	ld	a5,0(s1)
    80005778:	0009b703          	ld	a4,0(s3)
    8000577c:	fcf71ce3          	bne	a4,a5,80005754 <uartstart+0x4a>
      ReadReg(ISR);
    80005780:	100007b7          	lui	a5,0x10000
    80005784:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005788:	70e2                	ld	ra,56(sp)
    8000578a:	7442                	ld	s0,48(sp)
    8000578c:	74a2                	ld	s1,40(sp)
    8000578e:	7902                	ld	s2,32(sp)
    80005790:	69e2                	ld	s3,24(sp)
    80005792:	6a42                	ld	s4,16(sp)
    80005794:	6aa2                	ld	s5,8(sp)
    80005796:	6b02                	ld	s6,0(sp)
    80005798:	6121                	addi	sp,sp,64
    8000579a:	8082                	ret
      ReadReg(ISR);
    8000579c:	100007b7          	lui	a5,0x10000
    800057a0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800057a4:	8082                	ret

00000000800057a6 <uartputc>:
{
    800057a6:	7179                	addi	sp,sp,-48
    800057a8:	f406                	sd	ra,40(sp)
    800057aa:	f022                	sd	s0,32(sp)
    800057ac:	ec26                	sd	s1,24(sp)
    800057ae:	e84a                	sd	s2,16(sp)
    800057b0:	e44e                	sd	s3,8(sp)
    800057b2:	e052                	sd	s4,0(sp)
    800057b4:	1800                	addi	s0,sp,48
    800057b6:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800057b8:	0001e517          	auipc	a0,0x1e
    800057bc:	32050513          	addi	a0,a0,800 # 80023ad8 <uart_tx_lock>
    800057c0:	174000ef          	jal	80005934 <acquire>
  if(panicked){
    800057c4:	00005797          	auipc	a5,0x5
    800057c8:	e087a783          	lw	a5,-504(a5) # 8000a5cc <panicked>
    800057cc:	efbd                	bnez	a5,8000584a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057ce:	00005717          	auipc	a4,0x5
    800057d2:	e0a73703          	ld	a4,-502(a4) # 8000a5d8 <uart_tx_w>
    800057d6:	00005797          	auipc	a5,0x5
    800057da:	dfa7b783          	ld	a5,-518(a5) # 8000a5d0 <uart_tx_r>
    800057de:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800057e2:	0001e997          	auipc	s3,0x1e
    800057e6:	2f698993          	addi	s3,s3,758 # 80023ad8 <uart_tx_lock>
    800057ea:	00005497          	auipc	s1,0x5
    800057ee:	de648493          	addi	s1,s1,-538 # 8000a5d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057f2:	00005917          	auipc	s2,0x5
    800057f6:	de690913          	addi	s2,s2,-538 # 8000a5d8 <uart_tx_w>
    800057fa:	00e79d63          	bne	a5,a4,80005814 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800057fe:	85ce                	mv	a1,s3
    80005800:	8526                	mv	a0,s1
    80005802:	b65fb0ef          	jal	80001366 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005806:	00093703          	ld	a4,0(s2)
    8000580a:	609c                	ld	a5,0(s1)
    8000580c:	02078793          	addi	a5,a5,32
    80005810:	fee787e3          	beq	a5,a4,800057fe <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005814:	0001e497          	auipc	s1,0x1e
    80005818:	2c448493          	addi	s1,s1,708 # 80023ad8 <uart_tx_lock>
    8000581c:	01f77793          	andi	a5,a4,31
    80005820:	97a6                	add	a5,a5,s1
    80005822:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005826:	0705                	addi	a4,a4,1
    80005828:	00005797          	auipc	a5,0x5
    8000582c:	dae7b823          	sd	a4,-592(a5) # 8000a5d8 <uart_tx_w>
  uartstart();
    80005830:	edbff0ef          	jal	8000570a <uartstart>
  release(&uart_tx_lock);
    80005834:	8526                	mv	a0,s1
    80005836:	192000ef          	jal	800059c8 <release>
}
    8000583a:	70a2                	ld	ra,40(sp)
    8000583c:	7402                	ld	s0,32(sp)
    8000583e:	64e2                	ld	s1,24(sp)
    80005840:	6942                	ld	s2,16(sp)
    80005842:	69a2                	ld	s3,8(sp)
    80005844:	6a02                	ld	s4,0(sp)
    80005846:	6145                	addi	sp,sp,48
    80005848:	8082                	ret
    for(;;)
    8000584a:	a001                	j	8000584a <uartputc+0xa4>

000000008000584c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000584c:	1141                	addi	sp,sp,-16
    8000584e:	e406                	sd	ra,8(sp)
    80005850:	e022                	sd	s0,0(sp)
    80005852:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005854:	100007b7          	lui	a5,0x10000
    80005858:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000585c:	8b85                	andi	a5,a5,1
    8000585e:	cb89                	beqz	a5,80005870 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005860:	100007b7          	lui	a5,0x10000
    80005864:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005868:	60a2                	ld	ra,8(sp)
    8000586a:	6402                	ld	s0,0(sp)
    8000586c:	0141                	addi	sp,sp,16
    8000586e:	8082                	ret
    return -1;
    80005870:	557d                	li	a0,-1
    80005872:	bfdd                	j	80005868 <uartgetc+0x1c>

0000000080005874 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005874:	1101                	addi	sp,sp,-32
    80005876:	ec06                	sd	ra,24(sp)
    80005878:	e822                	sd	s0,16(sp)
    8000587a:	e426                	sd	s1,8(sp)
    8000587c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000587e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005880:	fcdff0ef          	jal	8000584c <uartgetc>
    if(c == -1)
    80005884:	00950563          	beq	a0,s1,8000588e <uartintr+0x1a>
      break;
    consoleintr(c);
    80005888:	861ff0ef          	jal	800050e8 <consoleintr>
  while(1){
    8000588c:	bfd5                	j	80005880 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000588e:	0001e497          	auipc	s1,0x1e
    80005892:	24a48493          	addi	s1,s1,586 # 80023ad8 <uart_tx_lock>
    80005896:	8526                	mv	a0,s1
    80005898:	09c000ef          	jal	80005934 <acquire>
  uartstart();
    8000589c:	e6fff0ef          	jal	8000570a <uartstart>
  release(&uart_tx_lock);
    800058a0:	8526                	mv	a0,s1
    800058a2:	126000ef          	jal	800059c8 <release>
}
    800058a6:	60e2                	ld	ra,24(sp)
    800058a8:	6442                	ld	s0,16(sp)
    800058aa:	64a2                	ld	s1,8(sp)
    800058ac:	6105                	addi	sp,sp,32
    800058ae:	8082                	ret

00000000800058b0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800058b0:	1141                	addi	sp,sp,-16
    800058b2:	e406                	sd	ra,8(sp)
    800058b4:	e022                	sd	s0,0(sp)
    800058b6:	0800                	addi	s0,sp,16
  lk->name = name;
    800058b8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800058ba:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800058be:	00053823          	sd	zero,16(a0)
}
    800058c2:	60a2                	ld	ra,8(sp)
    800058c4:	6402                	ld	s0,0(sp)
    800058c6:	0141                	addi	sp,sp,16
    800058c8:	8082                	ret

00000000800058ca <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800058ca:	411c                	lw	a5,0(a0)
    800058cc:	e399                	bnez	a5,800058d2 <holding+0x8>
    800058ce:	4501                	li	a0,0
  return r;
}
    800058d0:	8082                	ret
{
    800058d2:	1101                	addi	sp,sp,-32
    800058d4:	ec06                	sd	ra,24(sp)
    800058d6:	e822                	sd	s0,16(sp)
    800058d8:	e426                	sd	s1,8(sp)
    800058da:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800058dc:	6904                	ld	s1,16(a0)
    800058de:	c8efb0ef          	jal	80000d6c <mycpu>
    800058e2:	40a48533          	sub	a0,s1,a0
    800058e6:	00153513          	seqz	a0,a0
}
    800058ea:	60e2                	ld	ra,24(sp)
    800058ec:	6442                	ld	s0,16(sp)
    800058ee:	64a2                	ld	s1,8(sp)
    800058f0:	6105                	addi	sp,sp,32
    800058f2:	8082                	ret

00000000800058f4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800058f4:	1101                	addi	sp,sp,-32
    800058f6:	ec06                	sd	ra,24(sp)
    800058f8:	e822                	sd	s0,16(sp)
    800058fa:	e426                	sd	s1,8(sp)
    800058fc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058fe:	100024f3          	csrr	s1,sstatus
    80005902:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005906:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005908:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000590c:	c60fb0ef          	jal	80000d6c <mycpu>
    80005910:	5d3c                	lw	a5,120(a0)
    80005912:	cb99                	beqz	a5,80005928 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005914:	c58fb0ef          	jal	80000d6c <mycpu>
    80005918:	5d3c                	lw	a5,120(a0)
    8000591a:	2785                	addiw	a5,a5,1
    8000591c:	dd3c                	sw	a5,120(a0)
}
    8000591e:	60e2                	ld	ra,24(sp)
    80005920:	6442                	ld	s0,16(sp)
    80005922:	64a2                	ld	s1,8(sp)
    80005924:	6105                	addi	sp,sp,32
    80005926:	8082                	ret
    mycpu()->intena = old;
    80005928:	c44fb0ef          	jal	80000d6c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000592c:	8085                	srli	s1,s1,0x1
    8000592e:	8885                	andi	s1,s1,1
    80005930:	dd64                	sw	s1,124(a0)
    80005932:	b7cd                	j	80005914 <push_off+0x20>

0000000080005934 <acquire>:
{
    80005934:	1101                	addi	sp,sp,-32
    80005936:	ec06                	sd	ra,24(sp)
    80005938:	e822                	sd	s0,16(sp)
    8000593a:	e426                	sd	s1,8(sp)
    8000593c:	1000                	addi	s0,sp,32
    8000593e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005940:	fb5ff0ef          	jal	800058f4 <push_off>
  if(holding(lk))
    80005944:	8526                	mv	a0,s1
    80005946:	f85ff0ef          	jal	800058ca <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000594a:	4705                	li	a4,1
  if(holding(lk))
    8000594c:	e105                	bnez	a0,8000596c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000594e:	87ba                	mv	a5,a4
    80005950:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005954:	2781                	sext.w	a5,a5
    80005956:	ffe5                	bnez	a5,8000594e <acquire+0x1a>
  __sync_synchronize();
    80005958:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000595c:	c10fb0ef          	jal	80000d6c <mycpu>
    80005960:	e888                	sd	a0,16(s1)
}
    80005962:	60e2                	ld	ra,24(sp)
    80005964:	6442                	ld	s0,16(sp)
    80005966:	64a2                	ld	s1,8(sp)
    80005968:	6105                	addi	sp,sp,32
    8000596a:	8082                	ret
    panic("acquire");
    8000596c:	00002517          	auipc	a0,0x2
    80005970:	ebc50513          	addi	a0,a0,-324 # 80007828 <etext+0x828>
    80005974:	c93ff0ef          	jal	80005606 <panic>

0000000080005978 <pop_off>:

void
pop_off(void)
{
    80005978:	1141                	addi	sp,sp,-16
    8000597a:	e406                	sd	ra,8(sp)
    8000597c:	e022                	sd	s0,0(sp)
    8000597e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005980:	becfb0ef          	jal	80000d6c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005984:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005988:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000598a:	e39d                	bnez	a5,800059b0 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000598c:	5d3c                	lw	a5,120(a0)
    8000598e:	02f05763          	blez	a5,800059bc <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005992:	37fd                	addiw	a5,a5,-1
    80005994:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005996:	eb89                	bnez	a5,800059a8 <pop_off+0x30>
    80005998:	5d7c                	lw	a5,124(a0)
    8000599a:	c799                	beqz	a5,800059a8 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000599c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800059a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800059a4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800059a8:	60a2                	ld	ra,8(sp)
    800059aa:	6402                	ld	s0,0(sp)
    800059ac:	0141                	addi	sp,sp,16
    800059ae:	8082                	ret
    panic("pop_off - interruptible");
    800059b0:	00002517          	auipc	a0,0x2
    800059b4:	e8050513          	addi	a0,a0,-384 # 80007830 <etext+0x830>
    800059b8:	c4fff0ef          	jal	80005606 <panic>
    panic("pop_off");
    800059bc:	00002517          	auipc	a0,0x2
    800059c0:	e8c50513          	addi	a0,a0,-372 # 80007848 <etext+0x848>
    800059c4:	c43ff0ef          	jal	80005606 <panic>

00000000800059c8 <release>:
{
    800059c8:	1101                	addi	sp,sp,-32
    800059ca:	ec06                	sd	ra,24(sp)
    800059cc:	e822                	sd	s0,16(sp)
    800059ce:	e426                	sd	s1,8(sp)
    800059d0:	1000                	addi	s0,sp,32
    800059d2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800059d4:	ef7ff0ef          	jal	800058ca <holding>
    800059d8:	c105                	beqz	a0,800059f8 <release+0x30>
  lk->cpu = 0;
    800059da:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800059de:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800059e2:	0310000f          	fence	rw,w
    800059e6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800059ea:	f8fff0ef          	jal	80005978 <pop_off>
}
    800059ee:	60e2                	ld	ra,24(sp)
    800059f0:	6442                	ld	s0,16(sp)
    800059f2:	64a2                	ld	s1,8(sp)
    800059f4:	6105                	addi	sp,sp,32
    800059f6:	8082                	ret
    panic("release");
    800059f8:	00002517          	auipc	a0,0x2
    800059fc:	e5850513          	addi	a0,a0,-424 # 80007850 <etext+0x850>
    80005a00:	c07ff0ef          	jal	80005606 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...

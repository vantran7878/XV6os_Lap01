
user/_testhello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user.h"

int main() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  hello();
   8:	348000ef          	jal	350 <hello>
  exit(0);
   c:	4501                	li	a0,0
   e:	2a2000ef          	jal	2b0 <exit>

0000000000000012 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  extern int main();
  main();
  1a:	fe7ff0ef          	jal	0 <main>
  exit(0);
  1e:	4501                	li	a0,0
  20:	290000ef          	jal	2b0 <exit>

0000000000000024 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  24:	1141                	addi	sp,sp,-16
  26:	e406                	sd	ra,8(sp)
  28:	e022                	sd	s0,0(sp)
  2a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2c:	87aa                	mv	a5,a0
  2e:	0585                	addi	a1,a1,1
  30:	0785                	addi	a5,a5,1
  32:	fff5c703          	lbu	a4,-1(a1)
  36:	fee78fa3          	sb	a4,-1(a5)
  3a:	fb75                	bnez	a4,2e <strcpy+0xa>
    ;
  return os;
}
  3c:	60a2                	ld	ra,8(sp)
  3e:	6402                	ld	s0,0(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x20>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x20>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	60a2                	ld	ra,8(sp)
  6e:	6402                	ld	s0,0(sp)
  70:	0141                	addi	sp,sp,16
  72:	8082                	ret

0000000000000074 <strlen>:

uint
strlen(const char *s)
{
  74:	1141                	addi	sp,sp,-16
  76:	e406                	sd	ra,8(sp)
  78:	e022                	sd	s0,0(sp)
  7a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cf99                	beqz	a5,9e <strlen+0x2a>
  82:	0505                	addi	a0,a0,1
  84:	87aa                	mv	a5,a0
  86:	86be                	mv	a3,a5
  88:	0785                	addi	a5,a5,1
  8a:	fff7c703          	lbu	a4,-1(a5)
  8e:	ff65                	bnez	a4,86 <strlen+0x12>
  90:	40a6853b          	subw	a0,a3,a0
  94:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  96:	60a2                	ld	ra,8(sp)
  98:	6402                	ld	s0,0(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfdd                	j	96 <strlen+0x22>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e406                	sd	ra,8(sp)
  a6:	e022                	sd	s0,0(sp)
  a8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  aa:	ca19                	beqz	a2,c0 <memset+0x1e>
  ac:	87aa                	mv	a5,a0
  ae:	1602                	slli	a2,a2,0x20
  b0:	9201                	srli	a2,a2,0x20
  b2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ba:	0785                	addi	a5,a5,1
  bc:	fee79de3          	bne	a5,a4,b6 <memset+0x14>
  }
  return dst;
}
  c0:	60a2                	ld	ra,8(sp)
  c2:	6402                	ld	s0,0(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strchr>:

char*
strchr(const char *s, char c)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e406                	sd	ra,8(sp)
  cc:	e022                	sd	s0,0(sp)
  ce:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf81                	beqz	a5,ec <strchr+0x24>
    if(*s == c)
  d6:	00f58763          	beq	a1,a5,e4 <strchr+0x1c>
  for(; *s; s++)
  da:	0505                	addi	a0,a0,1
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbfd                	bnez	a5,d6 <strchr+0xe>
      return (char*)s;
  return 0;
  e2:	4501                	li	a0,0
}
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret
  return 0;
  ec:	4501                	li	a0,0
  ee:	bfdd                	j	e4 <strchr+0x1c>

00000000000000f0 <gets>:

char*
gets(char *buf, int max)
{
  f0:	7159                	addi	sp,sp,-112
  f2:	f486                	sd	ra,104(sp)
  f4:	f0a2                	sd	s0,96(sp)
  f6:	eca6                	sd	s1,88(sp)
  f8:	e8ca                	sd	s2,80(sp)
  fa:	e4ce                	sd	s3,72(sp)
  fc:	e0d2                	sd	s4,64(sp)
  fe:	fc56                	sd	s5,56(sp)
 100:	f85a                	sd	s6,48(sp)
 102:	f45e                	sd	s7,40(sp)
 104:	f062                	sd	s8,32(sp)
 106:	ec66                	sd	s9,24(sp)
 108:	e86a                	sd	s10,16(sp)
 10a:	1880                	addi	s0,sp,112
 10c:	8caa                	mv	s9,a0
 10e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 110:	892a                	mv	s2,a0
 112:	4481                	li	s1,0
    cc = read(0, &c, 1);
 114:	f9f40b13          	addi	s6,s0,-97
 118:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11a:	4ba9                	li	s7,10
 11c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 11e:	8d26                	mv	s10,s1
 120:	0014899b          	addiw	s3,s1,1
 124:	84ce                	mv	s1,s3
 126:	0349d563          	bge	s3,s4,150 <gets+0x60>
    cc = read(0, &c, 1);
 12a:	8656                	mv	a2,s5
 12c:	85da                	mv	a1,s6
 12e:	4501                	li	a0,0
 130:	198000ef          	jal	2c8 <read>
    if(cc < 1)
 134:	00a05e63          	blez	a0,150 <gets+0x60>
    buf[i++] = c;
 138:	f9f44783          	lbu	a5,-97(s0)
 13c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 140:	01778763          	beq	a5,s7,14e <gets+0x5e>
 144:	0905                	addi	s2,s2,1
 146:	fd879ce3          	bne	a5,s8,11e <gets+0x2e>
    buf[i++] = c;
 14a:	8d4e                	mv	s10,s3
 14c:	a011                	j	150 <gets+0x60>
 14e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 150:	9d66                	add	s10,s10,s9
 152:	000d0023          	sb	zero,0(s10)
  return buf;
}
 156:	8566                	mv	a0,s9
 158:	70a6                	ld	ra,104(sp)
 15a:	7406                	ld	s0,96(sp)
 15c:	64e6                	ld	s1,88(sp)
 15e:	6946                	ld	s2,80(sp)
 160:	69a6                	ld	s3,72(sp)
 162:	6a06                	ld	s4,64(sp)
 164:	7ae2                	ld	s5,56(sp)
 166:	7b42                	ld	s6,48(sp)
 168:	7ba2                	ld	s7,40(sp)
 16a:	7c02                	ld	s8,32(sp)
 16c:	6ce2                	ld	s9,24(sp)
 16e:	6d42                	ld	s10,16(sp)
 170:	6165                	addi	sp,sp,112
 172:	8082                	ret

0000000000000174 <stat>:

int
stat(const char *n, struct stat *st)
{
 174:	1101                	addi	sp,sp,-32
 176:	ec06                	sd	ra,24(sp)
 178:	e822                	sd	s0,16(sp)
 17a:	e04a                	sd	s2,0(sp)
 17c:	1000                	addi	s0,sp,32
 17e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 180:	4581                	li	a1,0
 182:	16e000ef          	jal	2f0 <open>
  if(fd < 0)
 186:	02054263          	bltz	a0,1aa <stat+0x36>
 18a:	e426                	sd	s1,8(sp)
 18c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	178000ef          	jal	308 <fstat>
 194:	892a                	mv	s2,a0
  close(fd);
 196:	8526                	mv	a0,s1
 198:	140000ef          	jal	2d8 <close>
  return r;
 19c:	64a2                	ld	s1,8(sp)
}
 19e:	854a                	mv	a0,s2
 1a0:	60e2                	ld	ra,24(sp)
 1a2:	6442                	ld	s0,16(sp)
 1a4:	6902                	ld	s2,0(sp)
 1a6:	6105                	addi	sp,sp,32
 1a8:	8082                	ret
    return -1;
 1aa:	597d                	li	s2,-1
 1ac:	bfcd                	j	19e <stat+0x2a>

00000000000001ae <atoi>:

int
atoi(const char *s)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b6:	00054683          	lbu	a3,0(a0)
 1ba:	fd06879b          	addiw	a5,a3,-48
 1be:	0ff7f793          	zext.b	a5,a5
 1c2:	4625                	li	a2,9
 1c4:	02f66963          	bltu	a2,a5,1f6 <atoi+0x48>
 1c8:	872a                	mv	a4,a0
  n = 0;
 1ca:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1cc:	0705                	addi	a4,a4,1
 1ce:	0025179b          	slliw	a5,a0,0x2
 1d2:	9fa9                	addw	a5,a5,a0
 1d4:	0017979b          	slliw	a5,a5,0x1
 1d8:	9fb5                	addw	a5,a5,a3
 1da:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1de:	00074683          	lbu	a3,0(a4)
 1e2:	fd06879b          	addiw	a5,a3,-48
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	fef671e3          	bgeu	a2,a5,1cc <atoi+0x1e>
  return n;
}
 1ee:	60a2                	ld	ra,8(sp)
 1f0:	6402                	ld	s0,0(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret
  n = 0;
 1f6:	4501                	li	a0,0
 1f8:	bfdd                	j	1ee <atoi+0x40>

00000000000001fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e406                	sd	ra,8(sp)
 1fe:	e022                	sd	s0,0(sp)
 200:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 202:	02b57563          	bgeu	a0,a1,22c <memmove+0x32>
    while(n-- > 0)
 206:	00c05f63          	blez	a2,224 <memmove+0x2a>
 20a:	1602                	slli	a2,a2,0x20
 20c:	9201                	srli	a2,a2,0x20
 20e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 212:	872a                	mv	a4,a0
      *dst++ = *src++;
 214:	0585                	addi	a1,a1,1
 216:	0705                	addi	a4,a4,1
 218:	fff5c683          	lbu	a3,-1(a1)
 21c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 220:	fee79ae3          	bne	a5,a4,214 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 224:	60a2                	ld	ra,8(sp)
 226:	6402                	ld	s0,0(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 232:	fec059e3          	blez	a2,224 <memmove+0x2a>
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 250:	fef71ae3          	bne	a4,a5,244 <memmove+0x4a>
 254:	bfc1                	j	224 <memmove+0x2a>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25e:	ca0d                	beqz	a2,290 <memcmp+0x3a>
 260:	fff6069b          	addiw	a3,a2,-1
 264:	1682                	slli	a3,a3,0x20
 266:	9281                	srli	a3,a3,0x20
 268:	0685                	addi	a3,a3,1
 26a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26c:	00054783          	lbu	a5,0(a0)
 270:	0005c703          	lbu	a4,0(a1)
 274:	00e79863          	bne	a5,a4,284 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 278:	0505                	addi	a0,a0,1
    p2++;
 27a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27c:	fed518e3          	bne	a0,a3,26c <memcmp+0x16>
  }
  return 0;
 280:	4501                	li	a0,0
 282:	a019                	j	288 <memcmp+0x32>
      return *p1 - *p2;
 284:	40e7853b          	subw	a0,a5,a4
}
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  return 0;
 290:	4501                	li	a0,0
 292:	bfdd                	j	288 <memcmp+0x32>

0000000000000294 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 29c:	f5fff0ef          	jal	1fa <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a8:	4885                	li	a7,1
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b0:	4889                	li	a7,2
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b8:	488d                	li	a7,3
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c0:	4891                	li	a7,4
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <read>:
.global read
read:
 li a7, SYS_read
 2c8:	4895                	li	a7,5
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <write>:
.global write
write:
 li a7, SYS_write
 2d0:	48c1                	li	a7,16
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <close>:
.global close
close:
 li a7, SYS_close
 2d8:	48d5                	li	a7,21
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e0:	4899                	li	a7,6
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e8:	489d                	li	a7,7
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <open>:
.global open
open:
 li a7, SYS_open
 2f0:	48bd                	li	a7,15
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f8:	48c5                	li	a7,17
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 300:	48c9                	li	a7,18
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 308:	48a1                	li	a7,8
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <link>:
.global link
link:
 li a7, SYS_link
 310:	48cd                	li	a7,19
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 318:	48d1                	li	a7,20
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 320:	48a5                	li	a7,9
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <dup>:
.global dup
dup:
 li a7, SYS_dup
 328:	48a9                	li	a7,10
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 330:	48ad                	li	a7,11
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 338:	48b1                	li	a7,12
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 340:	48b5                	li	a7,13
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 348:	48b9                	li	a7,14
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <hello>:
.global hello
hello:
 li a7, SYS_hello
 350:	48d9                	li	a7,22
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <trace>:
.global trace
trace:
 li a7, SYS_trace
 358:	48dd                	li	a7,23
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 360:	48e1                	li	a7,24
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 368:	1101                	addi	sp,sp,-32
 36a:	ec06                	sd	ra,24(sp)
 36c:	e822                	sd	s0,16(sp)
 36e:	1000                	addi	s0,sp,32
 370:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 374:	4605                	li	a2,1
 376:	fef40593          	addi	a1,s0,-17
 37a:	f57ff0ef          	jal	2d0 <write>
}
 37e:	60e2                	ld	ra,24(sp)
 380:	6442                	ld	s0,16(sp)
 382:	6105                	addi	sp,sp,32
 384:	8082                	ret

0000000000000386 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 386:	7139                	addi	sp,sp,-64
 388:	fc06                	sd	ra,56(sp)
 38a:	f822                	sd	s0,48(sp)
 38c:	f426                	sd	s1,40(sp)
 38e:	f04a                	sd	s2,32(sp)
 390:	ec4e                	sd	s3,24(sp)
 392:	0080                	addi	s0,sp,64
 394:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 396:	c299                	beqz	a3,39c <printint+0x16>
 398:	0605ce63          	bltz	a1,414 <printint+0x8e>
  neg = 0;
 39c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 39e:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3a2:	869a                	mv	a3,t1
  i = 0;
 3a4:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3a6:	00000817          	auipc	a6,0x0
 3aa:	4e280813          	addi	a6,a6,1250 # 888 <digits>
 3ae:	88be                	mv	a7,a5
 3b0:	0017851b          	addiw	a0,a5,1
 3b4:	87aa                	mv	a5,a0
 3b6:	02c5f73b          	remuw	a4,a1,a2
 3ba:	1702                	slli	a4,a4,0x20
 3bc:	9301                	srli	a4,a4,0x20
 3be:	9742                	add	a4,a4,a6
 3c0:	00074703          	lbu	a4,0(a4)
 3c4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3c8:	872e                	mv	a4,a1
 3ca:	02c5d5bb          	divuw	a1,a1,a2
 3ce:	0685                	addi	a3,a3,1
 3d0:	fcc77fe3          	bgeu	a4,a2,3ae <printint+0x28>
  if(neg)
 3d4:	000e0c63          	beqz	t3,3ec <printint+0x66>
    buf[i++] = '-';
 3d8:	fd050793          	addi	a5,a0,-48
 3dc:	00878533          	add	a0,a5,s0
 3e0:	02d00793          	li	a5,45
 3e4:	fef50823          	sb	a5,-16(a0)
 3e8:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 3ec:	fff7899b          	addiw	s3,a5,-1
 3f0:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 3f4:	fff4c583          	lbu	a1,-1(s1)
 3f8:	854a                	mv	a0,s2
 3fa:	f6fff0ef          	jal	368 <putc>
  while(--i >= 0)
 3fe:	39fd                	addiw	s3,s3,-1
 400:	14fd                	addi	s1,s1,-1
 402:	fe09d9e3          	bgez	s3,3f4 <printint+0x6e>
}
 406:	70e2                	ld	ra,56(sp)
 408:	7442                	ld	s0,48(sp)
 40a:	74a2                	ld	s1,40(sp)
 40c:	7902                	ld	s2,32(sp)
 40e:	69e2                	ld	s3,24(sp)
 410:	6121                	addi	sp,sp,64
 412:	8082                	ret
    x = -xx;
 414:	40b005bb          	negw	a1,a1
    neg = 1;
 418:	4e05                	li	t3,1
    x = -xx;
 41a:	b751                	j	39e <printint+0x18>

000000000000041c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 41c:	711d                	addi	sp,sp,-96
 41e:	ec86                	sd	ra,88(sp)
 420:	e8a2                	sd	s0,80(sp)
 422:	e4a6                	sd	s1,72(sp)
 424:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 426:	0005c483          	lbu	s1,0(a1)
 42a:	26048663          	beqz	s1,696 <vprintf+0x27a>
 42e:	e0ca                	sd	s2,64(sp)
 430:	fc4e                	sd	s3,56(sp)
 432:	f852                	sd	s4,48(sp)
 434:	f456                	sd	s5,40(sp)
 436:	f05a                	sd	s6,32(sp)
 438:	ec5e                	sd	s7,24(sp)
 43a:	e862                	sd	s8,16(sp)
 43c:	e466                	sd	s9,8(sp)
 43e:	8b2a                	mv	s6,a0
 440:	8a2e                	mv	s4,a1
 442:	8bb2                	mv	s7,a2
  state = 0;
 444:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 446:	4901                	li	s2,0
 448:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 44a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 44e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 452:	06c00c93          	li	s9,108
 456:	a00d                	j	478 <vprintf+0x5c>
        putc(fd, c0);
 458:	85a6                	mv	a1,s1
 45a:	855a                	mv	a0,s6
 45c:	f0dff0ef          	jal	368 <putc>
 460:	a019                	j	466 <vprintf+0x4a>
    } else if(state == '%'){
 462:	03598363          	beq	s3,s5,488 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 466:	0019079b          	addiw	a5,s2,1
 46a:	893e                	mv	s2,a5
 46c:	873e                	mv	a4,a5
 46e:	97d2                	add	a5,a5,s4
 470:	0007c483          	lbu	s1,0(a5)
 474:	20048963          	beqz	s1,686 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 478:	0004879b          	sext.w	a5,s1
    if(state == 0){
 47c:	fe0993e3          	bnez	s3,462 <vprintf+0x46>
      if(c0 == '%'){
 480:	fd579ce3          	bne	a5,s5,458 <vprintf+0x3c>
        state = '%';
 484:	89be                	mv	s3,a5
 486:	b7c5                	j	466 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 488:	00ea06b3          	add	a3,s4,a4
 48c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 490:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 492:	c681                	beqz	a3,49a <vprintf+0x7e>
 494:	9752                	add	a4,a4,s4
 496:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 49a:	03878e63          	beq	a5,s8,4d6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 49e:	05978863          	beq	a5,s9,4ee <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4a2:	07500713          	li	a4,117
 4a6:	0ee78263          	beq	a5,a4,58a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4aa:	07800713          	li	a4,120
 4ae:	12e78463          	beq	a5,a4,5d6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4b2:	07000713          	li	a4,112
 4b6:	14e78963          	beq	a5,a4,608 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4ba:	07300713          	li	a4,115
 4be:	18e78863          	beq	a5,a4,64e <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4c2:	02500713          	li	a4,37
 4c6:	04e79463          	bne	a5,a4,50e <vprintf+0xf2>
        putc(fd, '%');
 4ca:	85ba                	mv	a1,a4
 4cc:	855a                	mv	a0,s6
 4ce:	e9bff0ef          	jal	368 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4d2:	4981                	li	s3,0
 4d4:	bf49                	j	466 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4d6:	008b8493          	addi	s1,s7,8
 4da:	4685                	li	a3,1
 4dc:	4629                	li	a2,10
 4de:	000ba583          	lw	a1,0(s7)
 4e2:	855a                	mv	a0,s6
 4e4:	ea3ff0ef          	jal	386 <printint>
 4e8:	8ba6                	mv	s7,s1
      state = 0;
 4ea:	4981                	li	s3,0
 4ec:	bfad                	j	466 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4ee:	06400793          	li	a5,100
 4f2:	02f68963          	beq	a3,a5,524 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4f6:	06c00793          	li	a5,108
 4fa:	04f68263          	beq	a3,a5,53e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4fe:	07500793          	li	a5,117
 502:	0af68063          	beq	a3,a5,5a2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 506:	07800793          	li	a5,120
 50a:	0ef68263          	beq	a3,a5,5ee <vprintf+0x1d2>
        putc(fd, '%');
 50e:	02500593          	li	a1,37
 512:	855a                	mv	a0,s6
 514:	e55ff0ef          	jal	368 <putc>
        putc(fd, c0);
 518:	85a6                	mv	a1,s1
 51a:	855a                	mv	a0,s6
 51c:	e4dff0ef          	jal	368 <putc>
      state = 0;
 520:	4981                	li	s3,0
 522:	b791                	j	466 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 524:	008b8493          	addi	s1,s7,8
 528:	4685                	li	a3,1
 52a:	4629                	li	a2,10
 52c:	000ba583          	lw	a1,0(s7)
 530:	855a                	mv	a0,s6
 532:	e55ff0ef          	jal	386 <printint>
        i += 1;
 536:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 538:	8ba6                	mv	s7,s1
      state = 0;
 53a:	4981                	li	s3,0
        i += 1;
 53c:	b72d                	j	466 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53e:	06400793          	li	a5,100
 542:	02f60763          	beq	a2,a5,570 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 546:	07500793          	li	a5,117
 54a:	06f60963          	beq	a2,a5,5bc <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 54e:	07800793          	li	a5,120
 552:	faf61ee3          	bne	a2,a5,50e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 556:	008b8493          	addi	s1,s7,8
 55a:	4681                	li	a3,0
 55c:	4641                	li	a2,16
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e23ff0ef          	jal	386 <printint>
        i += 2;
 568:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 56a:	8ba6                	mv	s7,s1
      state = 0;
 56c:	4981                	li	s3,0
        i += 2;
 56e:	bde5                	j	466 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 570:	008b8493          	addi	s1,s7,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	e09ff0ef          	jal	386 <printint>
        i += 2;
 582:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 584:	8ba6                	mv	s7,s1
      state = 0;
 586:	4981                	li	s3,0
        i += 2;
 588:	bdf9                	j	466 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 58a:	008b8493          	addi	s1,s7,8
 58e:	4681                	li	a3,0
 590:	4629                	li	a2,10
 592:	000ba583          	lw	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	defff0ef          	jal	386 <printint>
 59c:	8ba6                	mv	s7,s1
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b5d9                	j	466 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	dd7ff0ef          	jal	386 <printint>
        i += 1;
 5b4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
        i += 1;
 5ba:	b575                	j	466 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	dbdff0ef          	jal	386 <printint>
        i += 2;
 5ce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
        i += 2;
 5d4:	bd49                	j	466 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4641                	li	a2,16
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	da3ff0ef          	jal	386 <printint>
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	bdad                	j	466 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4641                	li	a2,16
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	d8bff0ef          	jal	386 <printint>
        i += 1;
 600:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
        i += 1;
 606:	b585                	j	466 <vprintf+0x4a>
 608:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 60a:	008b8d13          	addi	s10,s7,8
 60e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 612:	03000593          	li	a1,48
 616:	855a                	mv	a0,s6
 618:	d51ff0ef          	jal	368 <putc>
  putc(fd, 'x');
 61c:	07800593          	li	a1,120
 620:	855a                	mv	a0,s6
 622:	d47ff0ef          	jal	368 <putc>
 626:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 628:	00000b97          	auipc	s7,0x0
 62c:	260b8b93          	addi	s7,s7,608 # 888 <digits>
 630:	03c9d793          	srli	a5,s3,0x3c
 634:	97de                	add	a5,a5,s7
 636:	0007c583          	lbu	a1,0(a5)
 63a:	855a                	mv	a0,s6
 63c:	d2dff0ef          	jal	368 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 640:	0992                	slli	s3,s3,0x4
 642:	34fd                	addiw	s1,s1,-1
 644:	f4f5                	bnez	s1,630 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 646:	8bea                	mv	s7,s10
      state = 0;
 648:	4981                	li	s3,0
 64a:	6d02                	ld	s10,0(sp)
 64c:	bd29                	j	466 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 64e:	008b8993          	addi	s3,s7,8
 652:	000bb483          	ld	s1,0(s7)
 656:	cc91                	beqz	s1,672 <vprintf+0x256>
        for(; *s; s++)
 658:	0004c583          	lbu	a1,0(s1)
 65c:	c195                	beqz	a1,680 <vprintf+0x264>
          putc(fd, *s);
 65e:	855a                	mv	a0,s6
 660:	d09ff0ef          	jal	368 <putc>
        for(; *s; s++)
 664:	0485                	addi	s1,s1,1
 666:	0004c583          	lbu	a1,0(s1)
 66a:	f9f5                	bnez	a1,65e <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 66c:	8bce                	mv	s7,s3
      state = 0;
 66e:	4981                	li	s3,0
 670:	bbdd                	j	466 <vprintf+0x4a>
          s = "(null)";
 672:	00000497          	auipc	s1,0x0
 676:	20e48493          	addi	s1,s1,526 # 880 <malloc+0xfe>
        for(; *s; s++)
 67a:	02800593          	li	a1,40
 67e:	b7c5                	j	65e <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	b3cd                	j	466 <vprintf+0x4a>
 686:	6906                	ld	s2,64(sp)
 688:	79e2                	ld	s3,56(sp)
 68a:	7a42                	ld	s4,48(sp)
 68c:	7aa2                	ld	s5,40(sp)
 68e:	7b02                	ld	s6,32(sp)
 690:	6be2                	ld	s7,24(sp)
 692:	6c42                	ld	s8,16(sp)
 694:	6ca2                	ld	s9,8(sp)
    }
  }
}
 696:	60e6                	ld	ra,88(sp)
 698:	6446                	ld	s0,80(sp)
 69a:	64a6                	ld	s1,72(sp)
 69c:	6125                	addi	sp,sp,96
 69e:	8082                	ret

00000000000006a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a0:	715d                	addi	sp,sp,-80
 6a2:	ec06                	sd	ra,24(sp)
 6a4:	e822                	sd	s0,16(sp)
 6a6:	1000                	addi	s0,sp,32
 6a8:	e010                	sd	a2,0(s0)
 6aa:	e414                	sd	a3,8(s0)
 6ac:	e818                	sd	a4,16(s0)
 6ae:	ec1c                	sd	a5,24(s0)
 6b0:	03043023          	sd	a6,32(s0)
 6b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b8:	8622                	mv	a2,s0
 6ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6be:	d5fff0ef          	jal	41c <vprintf>
}
 6c2:	60e2                	ld	ra,24(sp)
 6c4:	6442                	ld	s0,16(sp)
 6c6:	6161                	addi	sp,sp,80
 6c8:	8082                	ret

00000000000006ca <printf>:

void
printf(const char *fmt, ...)
{
 6ca:	711d                	addi	sp,sp,-96
 6cc:	ec06                	sd	ra,24(sp)
 6ce:	e822                	sd	s0,16(sp)
 6d0:	1000                	addi	s0,sp,32
 6d2:	e40c                	sd	a1,8(s0)
 6d4:	e810                	sd	a2,16(s0)
 6d6:	ec14                	sd	a3,24(s0)
 6d8:	f018                	sd	a4,32(s0)
 6da:	f41c                	sd	a5,40(s0)
 6dc:	03043823          	sd	a6,48(s0)
 6e0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e4:	00840613          	addi	a2,s0,8
 6e8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ec:	85aa                	mv	a1,a0
 6ee:	4505                	li	a0,1
 6f0:	d2dff0ef          	jal	41c <vprintf>
}
 6f4:	60e2                	ld	ra,24(sp)
 6f6:	6442                	ld	s0,16(sp)
 6f8:	6125                	addi	sp,sp,96
 6fa:	8082                	ret

00000000000006fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fc:	1141                	addi	sp,sp,-16
 6fe:	e406                	sd	ra,8(sp)
 700:	e022                	sd	s0,0(sp)
 702:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 704:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 708:	00001797          	auipc	a5,0x1
 70c:	8f87b783          	ld	a5,-1800(a5) # 1000 <freep>
 710:	a02d                	j	73a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 712:	4618                	lw	a4,8(a2)
 714:	9f2d                	addw	a4,a4,a1
 716:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 71a:	6398                	ld	a4,0(a5)
 71c:	6310                	ld	a2,0(a4)
 71e:	a83d                	j	75c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 720:	ff852703          	lw	a4,-8(a0)
 724:	9f31                	addw	a4,a4,a2
 726:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 728:	ff053683          	ld	a3,-16(a0)
 72c:	a091                	j	770 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72e:	6398                	ld	a4,0(a5)
 730:	00e7e463          	bltu	a5,a4,738 <free+0x3c>
 734:	00e6ea63          	bltu	a3,a4,748 <free+0x4c>
{
 738:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	fed7fae3          	bgeu	a5,a3,72e <free+0x32>
 73e:	6398                	ld	a4,0(a5)
 740:	00e6e463          	bltu	a3,a4,748 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	fee7eae3          	bltu	a5,a4,738 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 748:	ff852583          	lw	a1,-8(a0)
 74c:	6390                	ld	a2,0(a5)
 74e:	02059813          	slli	a6,a1,0x20
 752:	01c85713          	srli	a4,a6,0x1c
 756:	9736                	add	a4,a4,a3
 758:	fae60de3          	beq	a2,a4,712 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 75c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 760:	4790                	lw	a2,8(a5)
 762:	02061593          	slli	a1,a2,0x20
 766:	01c5d713          	srli	a4,a1,0x1c
 76a:	973e                	add	a4,a4,a5
 76c:	fae68ae3          	beq	a3,a4,720 <free+0x24>
    p->s.ptr = bp->s.ptr;
 770:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 772:	00001717          	auipc	a4,0x1
 776:	88f73723          	sd	a5,-1906(a4) # 1000 <freep>
}
 77a:	60a2                	ld	ra,8(sp)
 77c:	6402                	ld	s0,0(sp)
 77e:	0141                	addi	sp,sp,16
 780:	8082                	ret

0000000000000782 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 782:	7139                	addi	sp,sp,-64
 784:	fc06                	sd	ra,56(sp)
 786:	f822                	sd	s0,48(sp)
 788:	f04a                	sd	s2,32(sp)
 78a:	ec4e                	sd	s3,24(sp)
 78c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78e:	02051993          	slli	s3,a0,0x20
 792:	0209d993          	srli	s3,s3,0x20
 796:	09bd                	addi	s3,s3,15
 798:	0049d993          	srli	s3,s3,0x4
 79c:	2985                	addiw	s3,s3,1
 79e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7a0:	00001517          	auipc	a0,0x1
 7a4:	86053503          	ld	a0,-1952(a0) # 1000 <freep>
 7a8:	c905                	beqz	a0,7d8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ac:	4798                	lw	a4,8(a5)
 7ae:	09377663          	bgeu	a4,s3,83a <malloc+0xb8>
 7b2:	f426                	sd	s1,40(sp)
 7b4:	e852                	sd	s4,16(sp)
 7b6:	e456                	sd	s5,8(sp)
 7b8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ba:	8a4e                	mv	s4,s3
 7bc:	6705                	lui	a4,0x1
 7be:	00e9f363          	bgeu	s3,a4,7c4 <malloc+0x42>
 7c2:	6a05                	lui	s4,0x1
 7c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7cc:	00001497          	auipc	s1,0x1
 7d0:	83448493          	addi	s1,s1,-1996 # 1000 <freep>
  if(p == (char*)-1)
 7d4:	5afd                	li	s5,-1
 7d6:	a83d                	j	814 <malloc+0x92>
 7d8:	f426                	sd	s1,40(sp)
 7da:	e852                	sd	s4,16(sp)
 7dc:	e456                	sd	s5,8(sp)
 7de:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7e0:	00001797          	auipc	a5,0x1
 7e4:	83078793          	addi	a5,a5,-2000 # 1010 <base>
 7e8:	00001717          	auipc	a4,0x1
 7ec:	80f73c23          	sd	a5,-2024(a4) # 1000 <freep>
 7f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f6:	b7d1                	j	7ba <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7f8:	6398                	ld	a4,0(a5)
 7fa:	e118                	sd	a4,0(a0)
 7fc:	a899                	j	852 <malloc+0xd0>
  hp->s.size = nu;
 7fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 802:	0541                	addi	a0,a0,16
 804:	ef9ff0ef          	jal	6fc <free>
  return freep;
 808:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 80a:	c125                	beqz	a0,86a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80e:	4798                	lw	a4,8(a5)
 810:	03277163          	bgeu	a4,s2,832 <malloc+0xb0>
    if(p == freep)
 814:	6098                	ld	a4,0(s1)
 816:	853e                	mv	a0,a5
 818:	fef71ae3          	bne	a4,a5,80c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 81c:	8552                	mv	a0,s4
 81e:	b1bff0ef          	jal	338 <sbrk>
  if(p == (char*)-1)
 822:	fd551ee3          	bne	a0,s5,7fe <malloc+0x7c>
        return 0;
 826:	4501                	li	a0,0
 828:	74a2                	ld	s1,40(sp)
 82a:	6a42                	ld	s4,16(sp)
 82c:	6aa2                	ld	s5,8(sp)
 82e:	6b02                	ld	s6,0(sp)
 830:	a03d                	j	85e <malloc+0xdc>
 832:	74a2                	ld	s1,40(sp)
 834:	6a42                	ld	s4,16(sp)
 836:	6aa2                	ld	s5,8(sp)
 838:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83a:	fae90fe3          	beq	s2,a4,7f8 <malloc+0x76>
        p->s.size -= nunits;
 83e:	4137073b          	subw	a4,a4,s3
 842:	c798                	sw	a4,8(a5)
        p += p->s.size;
 844:	02071693          	slli	a3,a4,0x20
 848:	01c6d713          	srli	a4,a3,0x1c
 84c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 852:	00000717          	auipc	a4,0x0
 856:	7aa73723          	sd	a0,1966(a4) # 1000 <freep>
      return (void*)(p + 1);
 85a:	01078513          	addi	a0,a5,16
  }
}
 85e:	70e2                	ld	ra,56(sp)
 860:	7442                	ld	s0,48(sp)
 862:	7902                	ld	s2,32(sp)
 864:	69e2                	ld	s3,24(sp)
 866:	6121                	addi	sp,sp,64
 868:	8082                	ret
 86a:	74a2                	ld	s1,40(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
 872:	b7f5                	j	85e <malloc+0xdc>

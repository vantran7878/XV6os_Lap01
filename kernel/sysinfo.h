#include "types.h"

struct sysinfo {
  int freemem; //num of bytes of free memory
  int nproc; // num of proc unused
  int nopenfiles; // num of opening files
};

int sysinfo(uint64 info);

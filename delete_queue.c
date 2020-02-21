#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "inf136564_c.ch"


int main(int argc, char* argv[]){
    int requestQueue = msgget(1234, 0);
    int messQueue = msgget(1235,0);
    msgctl(requestQueue, IPC_RMID, NULL);
    msgctl(messQueue, IPC_RMID, NULL);
    printf("ok.\n");
}

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "inf136564_s.ch"
#include "inf136564_struct.ch"

int main(int argc, char* argv[]){
    int requestQueue = msgget(1234, 0600|IPC_CREAT);
    if(requestQueue == -1){
        printf("Error in creating Queue\n");
    }
    DataX dataX;
    while(1){
        if (msgrcv(requestQueue, &dataX, sizeof(dataX) - sizeof(long) + 1,1, IPC_NOWAIT) != -1){
            printf("-> %s\n", dataX.data);
        }
    }
}

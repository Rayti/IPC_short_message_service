#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>

int main(){
    char word[100];
    int x = 0;
    int b = 0;
    if(fork() == 0){
        while(1){
            printf("Wybierz odczyt za pomocą 1:\n");
            scanf("%d", &b);
            if(x > 10000){
                printf("-> %d\n", x);
                x =  0;
            } 
        }
    }
    else{
        while(1){
            x++;
            printf("tu\n");
            system("sleep 1");
        }
    }
    
    
    
    
}

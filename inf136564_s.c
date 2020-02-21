#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "inf136564_s.ch"

int main(int argc, char* argv[]){
    User users[100];
    char groups[100][20];
    int usersAmount = loadUsersFromFile(users);
    int groupsAmount = loadGroupsFromFile(groups);
    int i;
    /*
    for(i = 0; i < usersAmount; i++){
        printf("user %d. login: %s; pass: %s\n", i, users[i].login, users[i].password);
    }
    for(i = 0; i < groupsAmount; i++){
        printf("group %d: %s\n", i, groups[i]);
    } */
    printf("Server is working.\n");
    int requestQueue = msgget(1234, 0600|IPC_CREAT);
    int messageQueue = msgget(1235, 0600|IPC_CREAT);
    if(requestQueue == -1){
        printf("Error in creating Queue\n");
    }
    while(1){
        caseLogin(users, usersAmount);
        caseLogout(users, usersAmount);
        caseLoggedInUsers(users, usersAmount);
        caseMessageToUserIn(users, usersAmount);
    }
}

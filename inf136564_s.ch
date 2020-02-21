#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "inf136564_struct.ch"


int loadUsersFromFile(User * users){
    FILE *fp;
    if ((fp=fopen("users.txt", "r"))==NULL) {
     printf ("Can't open users.txt!\n");
     exit(1);
    }
    int i = 0;
    while(fscanf(fp, "%s %s", users[i].login, users[i].password) != EOF){
        users[i].isInGroup = 0;
        users[i].isLoggedIn = 0;
        users[i].id = i+1;
        i++;
    }
    return i;
}

int loadGroupsFromFile(char  groups[100][20]){
    FILE *fp;
    if ((fp=fopen("groups.txt", "r"))==NULL) {
     printf ("Can't open groups.txt!\n");
     exit(1);
     }
    int i = 0;
    while(fscanf(fp, "%s", groups[i]) != EOF){
        i++;
    }
    return i;
}

void caseLogin(User * users, int usersAmount){
    Request request;
    int requestQueue = msgget(1234, 0600);
    int isReceived = msgrcv(requestQueue, &request, sizeof(request) - sizeof(long) + 1, 1, IPC_NOWAIT);
    if(isReceived != -1){
        printf("Received login request.\n");
        int i;
        Response response;
        response.value = 0;
        response.type = 2;
        for(i = 0; i < usersAmount; i++){
            if(strcmp(users[i].login, request.login) == 0 && strcmp(users[i].password, request.password) == 0){
                if(users[i].isLoggedIn == 0){
                    response.value = 1;
                    response.id = users[i].id;
                    printf("User %s logged in.\n", request.login);
                    users[i].isLoggedIn = 1;
                }
                else{
                    response.value = 2;
                    printf("User %s tried logging while being already logged in.", request.login);
                }
                break;
            }
        }
        if(msgsnd(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 0) == -1){
            printf("Error in resending.\n");
        }
    }
}

void caseLogout(User * users, int usersAmount){
    Request request;
    int requestQueue = msgget(1234, 0600);
    int isReceived = msgrcv(requestQueue, &request, sizeof(request) - sizeof(long) + 1, 3, IPC_NOWAIT);
    if(isReceived != -1){
        printf("Received logout request.\n");
        int i;
        Response response;
        response.value = 2;
        response.type = 4;
        for(i = 0; i < usersAmount; i++){
            if(strcmp(users[i].login, request.login) == 0 && strcmp(users[i].password, request.password) == 0){
                if(users[i].isLoggedIn == 0){
                    response.value = 0;
                    printf("User %s tried logging out while already being logged out.\n", request.login);
                }
                else{
                    response.value = 1;
                    users[i].isLoggedIn = 0;
                    printf("User %s logged out.\n", request.login);
                }
                break;
            }
        }
        if(msgsnd(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 0) == -1){
            printf("Error in resending.\n");
        }
    }
}

void caseLoggedInUsers(User * users, int usersAmount){
    Request request;
    int requestQueue = msgget(1234, 0600);
    int isReceived = msgrcv(requestQueue, &request, sizeof(request) - sizeof(long) + 1, 5, IPC_NOWAIT);
    if(isReceived != -1){
        printf("Received logged_in_users_list request.\n");
        int i;
        int j = 0;
        Response response;
        response.value = 0;
        response.type = 6;
        for(i = 0; i < usersAmount; i++){
            if(users[i].isLoggedIn == 1){
                response.value++;
                strcpy(response.data[j], users[i].login);
                j++;
            }
        }
        if(msgsnd(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 0) == -1){
            printf("Error in resending\n");
        }
    }
}

void caseMessageToUserIn(User *users, int usersAmount){
    DataMessage dataMessage;
    Response response;
    int requestQueue = msgget(1234, 0600);
    int queue = msgget(1235, 0600);
    int isReceived = msgrcv(queue, &dataMessage, sizeof(dataMessage) - sizeof(long) + 1, 101, IPC_NOWAIT);
    if(isReceived != -1){
        printf("Received message from < %s > to < %s >.\n", dataMessage.senderLogin, dataMessage.receiverLogin);
        int i;
        response.type = 7;
        response.value = 0;
        for(i = 0; i< usersAmount; i++){
            if(strcmp(users[i].login, dataMessage.receiverLogin) == 0){
                response.value = 1;
                dataMessage.type = users[i].id;
                if(msgsnd(queue, &dataMessage, sizeof(dataMessage) - sizeof(long) + 1, 0) == -1){
                    printf("Error in sending to receiver!\n");
                }
                break;
            }
        }
        if(msgsnd(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 0) == -1){ //sending response back to sender to say that message has been sent
            printf("Error in resending\n");
        }
    }
}

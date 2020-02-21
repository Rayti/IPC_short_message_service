#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "inf136564_struct.ch"


void test(int a){
    printf("%d\n", a);
}

int requestLogin(char * login, char * password, int * id){
    int requestQueue = msgget(1234, 0);
    Request request;
    request.type = 1;
    strcpy(request.login, login);
    strcpy(request.password, password);
    if (msgsnd(requestQueue, &request, sizeof(request) - sizeof(long) + 1, 0) != 0){
            printf("Something went wrong\n");
    }
    system("sleep 1");
    Response response;
    response.value = -1;
    if(msgrcv(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 2, 0) == -1){
        printf("Error in getting data back\n");
    }
    if(response.value == 0){
        printf("Wrong login and/or password!\n");
        return 0;
    }
    if(response.value == 1){
        *id = response.id;
        printf("Login successful!\n");
        return 1;
    }
    if(response.value == 2){
        printf("You'are arleady logged in!\n");
        return 2;
    }
    printf("Error!\n");
    return -1;
}

int requestLogout(char * login, char * password){
    int requestQueue = msgget(1234, 0);
    Request request;
    request.type = 3;
    strcpy(request.login, login);
    strcpy(request.password, password);
    if (msgsnd(requestQueue, &request, sizeof(request) - sizeof(long) + 1, 0) != 0){
            printf("Something went wrong.\n");
    }
    system("sleep 1");
    Response response;
    response.value = -1;
    if(msgrcv(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 4, 0) == -1){
        printf("Error in getting data back.\n");
    }
    if(response.value == 0){
        printf("You'are arleady logged out!\n");
        return 0;
    }
    if(response.value == 1){
        printf("Logout successful!\n");
        return 1;
    }
    if(response.value == 2){
        printf("Wrong login data!\n");
        return 2;
    }
    printf("Error!\n");
    return -1;
}

void requestLoggedInUsers(){
    int requestQueue = msgget(1234, 0);
    Request request;
    request.type = 5;
    if (msgsnd(requestQueue, &request, sizeof(request) - sizeof(long) + 1, 0) != 0){
            printf("Something went wrong.\n");
    }
    system("sleep 1");
    Response response;
    response.value = -1;
    if(msgrcv(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 6, 0) == -1){
        printf("Error in getting data back.\n");
    }
    if(response.value > 0){
        int i;
        if(response.value == 1) printf("There is 1 user logged in:\n");
        else printf("There are %d users logged in:\n", response.value);
        for(i = 0; i < response.value; i++){
            printf("-- %s\n", response.data[i]);
        }
        return;
    }
    if(response.value == 0){
        printf("There is currently noone logged in\n");
        return;
    }
    printf("Error");
    return;
}

void requestGroupList(){
    int requestQueue = msgget(1234, 0);
    Request request;
    request.type = 12;
    if (msgsnd(requestQueue, &request, sizeof(request) - sizeof(long) + 1, 0) != 0){
            printf("Something went wrong.\n");
    }
    system("sleep 1");
    Response response;
    response.value = -1;
    if(msgrcv(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 13, 0) == -1){
        printf("Error in getting data back.\n");
    }
    if(response.value > 0){
        int i;
        if(response.value == 1) printf("There is 1 group available:\n");
        else printf("There are %d groups available:\n", response.value);
        for(i = 0; i < response.value; i++){
            printf("-- %s\n", response.data[i]);
        }
        return;
    }
    if(response.value == 0){
        printf("There are currently no groups available.\n");
        return;
    }
    printf("Error");
    return;
}

int requestSigningUptoGroup(char * login, char * groupName){
    int requestQueue = msgget(1234, 0);
    Request request;
    request.type = 8;
    strcpy(request.login, login);
    strcpy(request.data[0], groupName);
    if (msgsnd(requestQueue, &request, sizeof(request) - sizeof(long) + 1, 0) != 0){
            printf("Something went wrong.\n");
    }
    system("sleep 1");
    Response response;
    response.value = -1;
    if(msgrcv(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 9, 0) == -1){
        printf("Error in getting data back.\n");
    }
    if(response.value == 0){
        printf("Group %s does not exist!\n", groupName);
        return 0;
    }
    if(response.value == 1){
        printf("You signed up to %s!\n", groupName);
        return 1;
    }
    if(response.value == 2){
        printf("You are arleady in group %s!\n", response.data[0]);
        return 2;
    }
    printf("Error!\n");
    return -1;
}

int requestSigningOutOfGroup(char * login){
    int requestQueue = msgget(1234, 0);
    Request request;
    request.type = 10;
    strcpy(request.login, login);
    if (msgsnd(requestQueue, &request, sizeof(request) - sizeof(long) + 1, 0) != 0){
            printf("Something went wrong.\n");
    }
    system("sleep 1");
    Response response;
    response.value = -1;
    if(msgrcv(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 11, 0) == -1){
        printf("Error in getting data back.\n");
    }
    if(response.value == 0){
        printf("You already are not in group!\n");
        return 0;
    }
    if(response.value == 1){
        printf("You successfully signed out of group %s!\n", response.data[0]);
        return 1;
    }
    printf("Error!\n");
    return -1;
}


void sendMessage(char *myLogin, char * login, char * dm){
    DataMessage dataMessage;
    dataMessage.type = 101;
    strcpy(dataMessage.senderLogin, myLogin);
    strcpy(dataMessage.receiverLogin, login);
    strcpy(dataMessage.data, dm);
    int queue = msgget(1235,0);
    if (msgsnd(queue, &dataMessage, sizeof(dataMessage) - sizeof(long) + 1, 0) != 0){
            printf("Something went wrong.\n");
    }
    system("sleep 1");
    int requestQueue = msgget(1234, 0600);
    Response response;
    response.value = -1;
    if(msgrcv(requestQueue, &response, sizeof(response) - sizeof(long) + 1, 7, 0) == -1){
        printf("Error in getting data back.\n");
    }
    if(response.value == 1){
        printf("Successfully sent message to %s!\n", login);
        return;
    }
    if(response.value == 0){
        printf("User %s does not exists!\n", login);
        return;
    }
    printf("Error\n");
    return;
}

void receiveMessage(int id){
    DataMessage dataMessage;
    int queue = msgget(1235,0);
    if(msgrcv(queue, &dataMessage, sizeof(dataMessage) - sizeof(long) + 1, id, IPC_NOWAIT) != -1){
        printf("----------\nMessage sent by %s:\n%s\n----------\n", dataMessage.senderLogin, dataMessage.data);
    }
    else{
    printf("Nobody messaged you.\n");
    }
    printf("Tu\n");
}
